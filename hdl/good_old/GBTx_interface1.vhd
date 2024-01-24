----------------------------------------------------------------------
-- Created by Davide Falchieri
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
USE work.caenlinkpkg.all;
use work.DRM2pkg.all;


entity GBTx_interface is
port
	(
		active_high_reset:	in  	std_logic;
		clear:				in		std_logic;
		gbt_clk_40MHz:		in  	std_logic;		
		gbt_clk_80MHz:		in  	std_logic;	
		FPGACK_40MHz:		in		std_logic;		
		regs: 				inout  	REGS_RECORD; 
		acq_on:				in		std_logic;
		clk_sel1:			in		std_logic;
		clk_sel2:			in		std_logic;
			-- GBTx interface
		GBTX_RXDVALID:		in  	std_logic;
		GBTX_DOUT:			in  	std_logic_vector(39 downto 0);	
		GBTX_TXDVALID:		out 	std_logic;
		GBTX_DIN:			out 	std_logic_vector(39 downto 0);
			-- vme_int --> GBTx interface
		DDLOF_DTI_ck:		in		std_logic_vector(32 downto 0);
		DDLOF_WR_ck:		in		std_logic;
		RODATA_ck: 			in   	std_logic;          -- 1 => Readout Data; 0 => Slow Control data
		EVDONE_ck:			in		std_logic;
			-- GBTx interface --> vme_int
		l1a_ttc:			out		std_logic;
		l1msg_dto:			out 	std_logic_vector(79 downto 0);
		l1msg_empty:		out		std_logic;
		l1msg_rd:			in		std_logic;
		      -- SSRAM interface
		RR_D : 				inout  std_logic_vector (35 downto 0);  -- Data
		RR_A : 				out    std_logic_vector (19 downto 0);  -- Address
		RR_WE: 				out    std_logic;
		RR_OE: 				out    std_logic;
		RR_LD: 				out    std_logic;
		RR_CE: 				out    std_logic;
		WPULSE: 			in     reg_wpulse
	);
end GBTx_interface;

architecture RTL of GBTx_interface is


signal GBTX_RXDVALID_int1: 	std_logic;
signal GBTX_RXDVALID_int2: 	std_logic;
signal GBTX_RXDVALID_int3: 	std_logic;
signal data_from_gbtx:		std_logic_vector(79 downto 0);
signal even_odd_rx:			std_logic;
signal GBTX_DOUT_i:			std_logic_vector(39 downto 0);
signal word_for_rdh:		std_logic_vector(79 downto 0);
signal even_odd:			std_logic;
signal altern:				std_logic;
signal valid_data_to_gbtx:	std_logic;
signal data_to_gbtx:		std_logic_vector(83 downto 0);
signal GBTX_TXDVALID_int1:	std_logic;
signal GBTX_TXDVALID_int2:	std_logic;
signal data_from_gbtx_ok:	std_logic_vector(79 downto 0);
signal data_valid:			std_logic;
signal l1msg_almfull:		std_logic;

signal DDLOF_DTI:			std_logic_vector(32 downto 0);
signal DDLOF_WR:			std_logic;
signal RODATA: 				std_logic;          
signal EVDONE:				std_logic;
signal data_from_vme_ck:	std_logic_vector(35 downto 0);
signal data_from_vme_gbtck:	std_logic_vector(35 downto 0);

	component l1msg
    port(
        -- Inputs
        DATA   : in  std_logic_vector(79 downto 0);
        RCLOCK : in  std_logic;
        RE     : in  std_logic;
        RESET  : in  std_logic;
        WCLOCK : in  std_logic;
        WE     : in  std_logic;
        -- Outputs
        AFULL  : out std_logic;
        EMPTY  : out std_logic;
        FULL   : out std_logic;
        Q      : out std_logic_vector(79 downto 0)
        );
	end component;

	component GBTx_data_fifo
    port(
        CLK   : in  std_logic;
        DATA  : in  std_logic_vector(32 downto 0);
        RE    : in  std_logic;
        RESET : in  std_logic;
        WE    : in  std_logic;
        DVLD  : out std_logic;
        EMPTY : out std_logic;
        FULL  : out std_logic;
        Q     : out std_logic_vector(32 downto 0)
        );
	end component;
	
	component vme_to_gbt_fifo
    port(
        DATA   : in  std_logic_vector(35 downto 0);
        RCLOCK : in  std_logic;
        RE     : in  std_logic;
        RESET  : in  std_logic;
        WCLOCK : in  std_logic;
        WE     : in  std_logic;
        EMPTY  : out std_logic;
        FULL   : out std_logic;
        Q      : out std_logic_vector(35 downto 0)
        );
	end component;

	signal count_events:	std_logic_vector(5 downto 0);
	signal l1msg_we:		std_logic;
	
	-- Segnali per la SSRAM --------------------------------------------------------------------------
	constant RR_SIZE       : integer := 17;  -- RR SRAM Size = 2^RR_SIZE
	constant RR_AFLEV      : integer := 2**(RR_SIZE-1)-(45*1024);  -- 1080KB (45Kword)
	constant RR_NEV_AFLEV  : integer := 230;  -- Almost Full level (max num di eventi)

	signal W_PNT           : std_logic_vector(RR_SIZE-1 downto 0);  -- Write Pointer
	signal R_PNT           : std_logic_vector(RR_SIZE-1 downto 0);  -- Read Pointer
	signal W_JUMP          : std_logic_vector(RR_SIZE-1 downto 0);  -- Write Pointer a cui saltare per il nuovo evento
	signal RR_NW           : std_logic_vector(RR_SIZE-1 downto 0);  -- RR Num of Words

	signal RR_Ai           : std_logic_vector(RR_SIZE-1 downto 0);  -- Address Interni
	signal RR_Di           : std_logic_vector(35 downto 0);         -- Data Interni
	signal RR_WEi          : std_logic;                             -- Write Enable interno
	signal RR_READ         : std_logic;                             -- Ciclo di lettura valido da RR
	signal RRO_VALID       : std_logic;                             -- Dati validi in uscita a RR (1 clk dopo RR_READ)
	signal RR_READ_FIRST   : std_logic;                             -- Lettura da RR della prima word di un evento
	signal RRO_VALID_FIRST : std_logic;                             -- Primo dato valido (RR_READ_FIRST cloccato)

  -- =====================================================================================
  -- Segnali utili solo in caso di SRAM Pipelined CY7C1370 o CY7C1350
  -- =====================================================================================
	signal RR_D1           : std_logic_vector(35 downto 0);         -- RR_Di ritardato di 1 clock
	signal RR_D2           : std_logic_vector(35 downto 0);         -- RR_Di ritardato di 2 clock
	signal RR_Dz           : std_logic_vector(35 downto 0);         -- RR_D con OE
	signal RR_Ds           : std_logic_vector(35 downto 0);         -- RR_D sincronizzati (in ingresso)
	signal RR_WE1          : std_logic;                             -- RR_WEi ritardato di 1
	signal RR_D_OE         : std_logic;                             -- OE dei dati verso RR
	signal RR_READ1        : std_logic;                             -- RR_READ ritardato di 1
	signal RR_READ_FIRST1  : std_logic;                             -- RR_READ_FIRST ritardato di 1
	signal RR_READ2        : std_logic;                             -- RR_READ ritardato di 2
	signal RR_READ_FIRST2  : std_logic;                             -- RR_READ_FIRST ritardato di 2
  -- =====================================================================================

	signal RR_NEV        : std_logic_vector(7 downto 0);        -- Numero di eventi in RR pronti per essere inviati a DDL
	signal RWCNT         : std_logic_vector(17 downto 0);       -- Conta le parola di un evento durante la lettura da RR
	signal EVHEAD_CNT    : std_logic_vector(3 downto 0);        -- Conta le word della header mentre le scrivo
	signal WR_EVHEAD     : std_logic;                           -- Segnala che sto scrivendo la header
	signal NE_AF         : std_logic;                           -- Almost Full per troppi eventi in RR
	signal NW_AF         : std_logic;                           -- Almost Full per troppe word in RR

	signal RROF_DTO       : std_logic_vector(32 downto 0);
	signal RROF_DTI       : std_logic_vector(32 downto 0);
	signal RROF_EMPTY     : std_logic;
	signal RROF_ALMFULL   : std_logic;
	--signal RROF_CLR       : std_logic := '0';
	signal RROF_RD        : std_logic;
	signal RROF_WR        : std_logic;
	signal RROF_RDi       : std_logic;
	signal RROF_OR        : std_logic;
	signal RROF_DVALID	  : std_logic;
	
	signal RR_VALID		  : std_logic;
	signal DDLOF_FULL	  : std_logic;
	-------------------------------------------------------------------------------------------------------------------------
	
	
	type   PSTATE is (WAIT_STATE, SOP_STATE, RDH_WORD0_STATE, RDH_WORD1_STATE, RDH_WORD2_STATE, RDH_WORD3_STATE, DATA_STATE, EOP_STATE);
	attribute syn_encoding: 		string;
    attribute syn_encoding of PSTATE: type is "onehot";
    signal state_pattern: 				PSTATE;
	
	constant c_IDLE : std_logic_vector(3 downto 0) := x"0";  
	constant c_SOP  : std_logic_vector(3 downto 0) := x"1"; 
	constant c_EOP  : std_logic_vector(3 downto 0) := x"2"; 

begin

	----------------------------------------------------------------------
	-- from vme_int towards GBTx_interface	------------------------------
	----------------------------------------------------------------------
	
	data_from_vme_ck	<= DDLOF_DTI_ck & DDLOF_WR_ck & RODATA_ck & EVDONE_ck;
	
	vme_to_gbt_fifo_instance: vme_to_gbt_fifo
    port map(
        DATA   => data_from_vme_ck,
		WE     => '1',
		WCLOCK => FPGACK_40MHz,
        RESET  => active_high_reset,		 
        RCLOCK => gbt_clk_40MHz,
        RE     => '1',
        EMPTY  => open,
        FULL   => open,
        Q      => data_from_vme_gbtck
        );
	
	DDLOF_DTI			<= data_from_vme_gbtck(35 downto 3);
	DDLOF_WR			<= data_from_vme_gbtck(2);
	RODATA				<= data_from_vme_gbtck(1);
	EVDONE				<= data_from_vme_gbtck(0);
	
	----------------------------------------------------------------------
	-- towards GBTx	------------------------------------------------------
	----------------------------------------------------------------------
	
	GBTx_data_fifo_instance: GBTx_data_fifo
	port map(
        CLK   => gbt_clk_40MHz,
        DATA  => RROF_DTI,
		WE    => RROF_WR,
        RESET => active_high_reset,
        DVLD  => RROF_DVALID,
        EMPTY => RROF_EMPTY,
        FULL  => RROF_ALMFULL,
		RE    => RROF_RD,
        Q     => RROF_DTO
        );
	
	RROF_RD <= RROF_RDi and not RROF_EMPTY;
	
	process(active_high_reset, gbt_clk_40MHz)
	begin
		if(active_high_reset = '1') then
			state_pattern		<= WAIT_STATE;
			valid_data_to_gbtx	<= '0';
		elsif(rising_edge(gbt_clk_40MHz)) then
			if(state_pattern = WAIT_STATE) then
				if(count_events > 0) then
					state_pattern	<= SOP_STATE;
				else
					state_pattern	<= WAIT_STATE;
				end if;
				RROF_RDi			<= '0';
				data_to_gbtx		<= x"0" & c_IDLE & x"0000000000000000000";
				valid_data_to_gbtx	<= '0';
			elsif(state_pattern = SOP_STATE) then
				data_to_gbtx		<= x"0" & c_SOP & x"0000000000000000000";
				valid_data_to_gbtx	<= '0';
				state_pattern		<= RDH_WORD0_STATE;
				RROF_RDi			<= not RROF_EMPTY;
			elsif(state_pattern = RDH_WORD0_STATE) then
				data_to_gbtx		<= x"0" & word_for_rdh;
				valid_data_to_gbtx	<= '1';
				RROF_RDi			<= '0';
				state_pattern		<= RDH_WORD1_STATE;
			elsif(state_pattern = RDH_WORD1_STATE) then
				data_to_gbtx		<= x"0" & word_for_rdh;
				valid_data_to_gbtx	<= '1';
				RROF_RDi			<= '0';
				state_pattern		<= RDH_WORD2_STATE;
			elsif(state_pattern = RDH_WORD2_STATE) then
				data_to_gbtx		<= x"0" & word_for_rdh;
				valid_data_to_gbtx	<= '1';
				RROF_RDi			<= '0';
				state_pattern		<= RDH_WORD3_STATE;
			elsif(state_pattern = RDH_WORD3_STATE) then
				data_to_gbtx		<= x"0" & word_for_rdh;
				valid_data_to_gbtx	<= '1';
				RROF_RDi			<= not RROF_EMPTY;
				state_pattern		<= DATA_STATE;
			elsif(state_pattern = DATA_STATE) then
				if(RROF_DVALID = '0') then
					data_to_gbtx		<= x"00000000000000000000" & c_IDLE;
					valid_data_to_gbtx	<= '0';
				else
					data_to_gbtx		<= x"000000000000" & '0' & clk_sel2 & clk_sel1 & RROF_DTO;
					valid_data_to_gbtx	<= '1';
				end if;
				if(RROF_DTO(32) = '1' and RROF_DVALID = '1') then
					state_pattern	<= EOP_STATE;
					RROF_RDi		<= '0';
				else
					RROF_RDi		<= not RROF_EMPTY;
				end if;
			elsif(state_pattern = EOP_STATE) then
				data_to_gbtx		<= x"0" & c_EOP & x"0000000000000000000";
				valid_data_to_gbtx	<= '0';
				RROF_RDi			<= '0';
				state_pattern		<= WAIT_STATE;
			end if;
		end if;
	end process;
	
	process(active_high_reset, gbt_clk_40MHz)
	begin
		if(active_high_reset = '1') then
			count_events <= (others => '0');
		elsif(rising_edge(gbt_clk_40MHz)) then
			if(EVDONE = '1' and state_pattern /= EOP_STATE) then
				count_events <= count_events + 1;
			elsif(EVDONE = '0' and state_pattern = EOP_STATE) then
				count_events <= count_events - 1;
			end if;
		end if;
	end process;
	----------------------------------------------------------------------

	----------------------------------------------------------------------
	-- from GBTx  --------------------------------------------------------
	l1a_ttc		<= data_valid and acq_on;
	
	l1msg_we	<= data_valid and acq_on;
	
	l1msg_instance : l1msg
    port map
      (DATA     => data_from_gbtx_ok,
       WE	    => l1msg_we,
       RE	    => l1msg_rd,
       WCLOCK   => gbt_clk_40MHz,	   
       RCLOCK   => FPGACK_40MHz,
       RESET    => active_high_reset,
       Q        => l1msg_dto,
       EMPTY    => l1msg_empty,
       FULL     => open,
       AFULL    => l1msg_almfull
       );

	----------------------------------------------------------------------
	
	process(gbt_clk_40MHz)
	begin
		if(rising_edge(gbt_clk_40MHz)) then
			GBTX_RXDVALID_int1	<= GBTX_RXDVALID;
			GBTX_RXDVALID_int2	<= GBTX_RXDVALID_int1;
			GBTX_RXDVALID_int3	<= GBTX_RXDVALID_int2;
		end if;
	end process;
	
	---------------------------------------------------------
	process(gbt_clk_40MHz)
	begin
		if rising_edge(gbt_clk_40MHz) then
			data_from_gbtx_ok	<= data_from_gbtx;
			data_valid			<= GBTX_RXDVALID_int3;
		end if;
	end process;
	---------------------------------------------------------
	
	GBTX_DOUT_process: process(active_high_reset, gbt_clk_80MHz)
	begin
		if(active_high_reset = '1') then
			data_from_gbtx	<= (others => '0');
			even_odd_rx		<= '0';
		elsif(falling_edge(gbt_clk_80MHz)) then		-- was falling DAV
			if(GBTX_RXDVALID_int3 = '1' AND even_odd_rx = '0') then
				data_from_gbtx(79)	<= GBTX_DOUT_i(39);	data_from_gbtx(77)	<= GBTX_DOUT_i(38);	data_from_gbtx(75)	<= GBTX_DOUT_i(37);	data_from_gbtx(73)	<= GBTX_DOUT_i(36);
				data_from_gbtx(71)	<= GBTX_DOUT_i(35);	data_from_gbtx(69)	<= GBTX_DOUT_i(34);	data_from_gbtx(67)	<= GBTX_DOUT_i(33);	data_from_gbtx(65)	<= GBTX_DOUT_i(32);
				data_from_gbtx(63)	<= GBTX_DOUT_i(31);	data_from_gbtx(61)	<= GBTX_DOUT_i(30);	data_from_gbtx(59)	<= GBTX_DOUT_i(29);	data_from_gbtx(57)	<= GBTX_DOUT_i(28);
				data_from_gbtx(55)	<= GBTX_DOUT_i(27);	data_from_gbtx(53)	<= GBTX_DOUT_i(26);	data_from_gbtx(51)	<= GBTX_DOUT_i(25);	data_from_gbtx(49)	<= GBTX_DOUT_i(24);
				data_from_gbtx(47)	<= GBTX_DOUT_i(23);	data_from_gbtx(45)	<= GBTX_DOUT_i(22);	data_from_gbtx(43)	<= GBTX_DOUT_i(21);	data_from_gbtx(41)	<= GBTX_DOUT_i(20);
				data_from_gbtx(39)	<= GBTX_DOUT_i(19);	data_from_gbtx(37)	<= GBTX_DOUT_i(18);	data_from_gbtx(35)	<= GBTX_DOUT_i(17);	data_from_gbtx(33)	<= GBTX_DOUT_i(16);
				data_from_gbtx(31)	<= GBTX_DOUT_i(15);	data_from_gbtx(29)	<= GBTX_DOUT_i(14);	data_from_gbtx(27)	<= GBTX_DOUT_i(13);	data_from_gbtx(25)	<= GBTX_DOUT_i(12);
				data_from_gbtx(23)	<= GBTX_DOUT_i(11);	data_from_gbtx(21)	<= GBTX_DOUT_i(10);	data_from_gbtx(19)	<= GBTX_DOUT_i(9);	data_from_gbtx(17)	<= GBTX_DOUT_i(8);
				data_from_gbtx(15)	<= GBTX_DOUT_i(7);	data_from_gbtx(13)	<= GBTX_DOUT_i(6);	data_from_gbtx(11)	<= GBTX_DOUT_i(5);	data_from_gbtx(9)	<= GBTX_DOUT_i(4);
				data_from_gbtx(7)	<= GBTX_DOUT_i(3);	data_from_gbtx(5)	<= GBTX_DOUT_i(2);	data_from_gbtx(3)	<= GBTX_DOUT_i(1);	data_from_gbtx(1)	<= GBTX_DOUT_i(0);
				even_odd_rx		<= '1';
			elsif(GBTX_RXDVALID_int3 = '1' AND even_odd_rx = '1') then
				data_from_gbtx(78)	<= GBTX_DOUT_i(39);	data_from_gbtx(76)	<= GBTX_DOUT_i(38);	data_from_gbtx(74)	<= GBTX_DOUT_i(37);	data_from_gbtx(72)	<= GBTX_DOUT_i(36);
				data_from_gbtx(70)	<= GBTX_DOUT_i(35);	data_from_gbtx(68)	<= GBTX_DOUT_i(34);	data_from_gbtx(66)	<= GBTX_DOUT_i(33);	data_from_gbtx(64)	<= GBTX_DOUT_i(32);
				data_from_gbtx(62)	<= GBTX_DOUT_i(31);	data_from_gbtx(60)	<= GBTX_DOUT_i(30);	data_from_gbtx(58)	<= GBTX_DOUT_i(29);	data_from_gbtx(56)	<= GBTX_DOUT_i(28);
				data_from_gbtx(54)	<= GBTX_DOUT_i(27);	data_from_gbtx(52)	<= GBTX_DOUT_i(26);	data_from_gbtx(50)	<= GBTX_DOUT_i(25);	data_from_gbtx(48)	<= GBTX_DOUT_i(24);
				data_from_gbtx(46)	<= GBTX_DOUT_i(23);	data_from_gbtx(44)	<= GBTX_DOUT_i(22);	data_from_gbtx(42)	<= GBTX_DOUT_i(21);	data_from_gbtx(40)	<= GBTX_DOUT_i(20);
				data_from_gbtx(38)	<= GBTX_DOUT_i(19);	data_from_gbtx(36)	<= GBTX_DOUT_i(18);	data_from_gbtx(34)	<= GBTX_DOUT_i(17);	data_from_gbtx(32)	<= GBTX_DOUT_i(16);
				data_from_gbtx(30)	<= GBTX_DOUT_i(15);	data_from_gbtx(28)	<= GBTX_DOUT_i(14);	data_from_gbtx(26)	<= GBTX_DOUT_i(13);	data_from_gbtx(24)	<= GBTX_DOUT_i(12);
				data_from_gbtx(22)	<= GBTX_DOUT_i(11);	data_from_gbtx(20)	<= GBTX_DOUT_i(10);	data_from_gbtx(18)	<= GBTX_DOUT_i(9);	data_from_gbtx(16)	<= GBTX_DOUT_i(8);
				data_from_gbtx(14)	<= GBTX_DOUT_i(7);	data_from_gbtx(12)	<= GBTX_DOUT_i(6);	data_from_gbtx(10)	<= GBTX_DOUT_i(5);	data_from_gbtx(8)	<= GBTX_DOUT_i(4);
				data_from_gbtx(6)	<= GBTX_DOUT_i(3);	data_from_gbtx(4)	<= GBTX_DOUT_i(2);	data_from_gbtx(2)	<= GBTX_DOUT_i(1);	data_from_gbtx(0)	<= GBTX_DOUT_i(0);
				even_odd_rx		<= '0';
			else
				data_from_gbtx	<= (others => '0');
				even_odd_rx		<= '0';
			end if;
			GBTX_DOUT_i			<= GBTX_DOUT;
		end if;
	end process GBTX_DOUT_process;
	
	data_valid_process: process(active_high_reset, gbt_clk_40MHz)
	begin
		if(active_high_reset = '1') then
			word_for_rdh	<= (others => '0');
		elsif(rising_edge(gbt_clk_40MHz)) then
			if(data_valid = '1') then
				word_for_rdh	<= data_from_gbtx_ok;
			end if;
		end if;
	end process data_valid_process;	

		-- 80 MHz
	GBTX_DIN_process: process(active_high_reset, gbt_clk_80MHz)
	begin
		if(active_high_reset = '1') then
			even_odd		<= '0';
			altern			<= '0';
		elsif(rising_edge(gbt_clk_80MHz)) then
			if(valid_data_to_gbtx = '0') then
				even_odd	<= '0';
			else
				even_odd	<= NOT(even_odd);
			end if;
			if(valid_data_to_gbtx = '1' AND even_odd = '0') then
				GBTX_DIN	<= data_to_gbtx(79) & data_to_gbtx(77) & data_to_gbtx(75) & data_to_gbtx(73) & data_to_gbtx(71) & data_to_gbtx(69) & data_to_gbtx(67) & data_to_gbtx(65) & data_to_gbtx(63) & data_to_gbtx(61) &
							   data_to_gbtx(59) & data_to_gbtx(57) & data_to_gbtx(55) & data_to_gbtx(53) & data_to_gbtx(51) & data_to_gbtx(49) & data_to_gbtx(47) & data_to_gbtx(45) & data_to_gbtx(43) & data_to_gbtx(41) &
							   data_to_gbtx(39) & data_to_gbtx(37) & data_to_gbtx(35) & data_to_gbtx(33) & data_to_gbtx(31) & data_to_gbtx(29) & data_to_gbtx(27) & data_to_gbtx(25) & data_to_gbtx(23) & data_to_gbtx(21) &
							   data_to_gbtx(19) & data_to_gbtx(17) & data_to_gbtx(15) & data_to_gbtx(13) & data_to_gbtx(11) & data_to_gbtx(9)  & data_to_gbtx(7)  & data_to_gbtx(5)  & data_to_gbtx(3)  & data_to_gbtx(1);
				altern				<= '0';
			elsif(valid_data_to_gbtx = '1' AND even_odd = '1') then	
				GBTX_DIN	<= data_to_gbtx(78) & data_to_gbtx(76) & data_to_gbtx(74) & data_to_gbtx(72) & data_to_gbtx(70) & data_to_gbtx(68) & data_to_gbtx(66) & data_to_gbtx(64) & data_to_gbtx(62) & data_to_gbtx(60) &
							   data_to_gbtx(58) & data_to_gbtx(56) & data_to_gbtx(54) & data_to_gbtx(52) & data_to_gbtx(50) & data_to_gbtx(48) & data_to_gbtx(46) & data_to_gbtx(44) & data_to_gbtx(42) & data_to_gbtx(40) &
							   data_to_gbtx(38) & data_to_gbtx(36) & data_to_gbtx(34) & data_to_gbtx(32) & data_to_gbtx(30) & data_to_gbtx(28) & data_to_gbtx(26) & data_to_gbtx(24) & data_to_gbtx(22) & data_to_gbtx(20) &
							   data_to_gbtx(18) & data_to_gbtx(16) & data_to_gbtx(14) & data_to_gbtx(12) & data_to_gbtx(10) & data_to_gbtx(8)  & data_to_gbtx(6)  & data_to_gbtx(4)  & data_to_gbtx(2)  & data_to_gbtx(0);
				altern				<= '0';
			else	-- IDLE or SOP or EOP
				if(altern = '0') then
					GBTX_DIN	<= data_to_gbtx(79) & data_to_gbtx(77) & data_to_gbtx(75) & data_to_gbtx(73) & data_to_gbtx(71) & data_to_gbtx(69) & data_to_gbtx(67) & data_to_gbtx(65) & data_to_gbtx(63) & data_to_gbtx(61) &
								   data_to_gbtx(59) & data_to_gbtx(57) & data_to_gbtx(55) & data_to_gbtx(53) & data_to_gbtx(51) & data_to_gbtx(49) & data_to_gbtx(47) & data_to_gbtx(45) & data_to_gbtx(43) & data_to_gbtx(41) &
								   data_to_gbtx(39) & data_to_gbtx(37) & data_to_gbtx(35) & data_to_gbtx(33) & data_to_gbtx(31) & data_to_gbtx(29) & data_to_gbtx(27) & data_to_gbtx(25) & data_to_gbtx(23) & data_to_gbtx(21) &
								   data_to_gbtx(19) & data_to_gbtx(17) & data_to_gbtx(15) & data_to_gbtx(13) & data_to_gbtx(11) & data_to_gbtx(9)  & data_to_gbtx(7)  & data_to_gbtx(5)  & data_to_gbtx(3)  & data_to_gbtx(1);
				else
					GBTX_DIN	<= data_to_gbtx(78) & data_to_gbtx(76) & data_to_gbtx(74) & data_to_gbtx(72) & data_to_gbtx(70) & data_to_gbtx(68) & data_to_gbtx(66) & data_to_gbtx(64) & data_to_gbtx(62) & data_to_gbtx(60) &
								   data_to_gbtx(58) & data_to_gbtx(56) & data_to_gbtx(54) & data_to_gbtx(52) & data_to_gbtx(50) & data_to_gbtx(48) & data_to_gbtx(46) & data_to_gbtx(44) & data_to_gbtx(42) & data_to_gbtx(40) &
							       data_to_gbtx(38) & data_to_gbtx(36) & data_to_gbtx(34) & data_to_gbtx(32) & data_to_gbtx(30) & data_to_gbtx(28) & data_to_gbtx(26) & data_to_gbtx(24) & data_to_gbtx(22) & data_to_gbtx(20) &
							       data_to_gbtx(18) & data_to_gbtx(16) & data_to_gbtx(14) & data_to_gbtx(12) & data_to_gbtx(10) & data_to_gbtx(8)  & data_to_gbtx(6)  & data_to_gbtx(4)  & data_to_gbtx(2)  & data_to_gbtx(0);
				end if;
				altern	<= NOT(altern);
			end if;
		end if;
	end process GBTX_DIN_process;
	
	trigger_process: process(active_high_reset, gbt_clk_40MHz)
	begin
		if(active_high_reset = '1') then
			GBTX_TXDVALID		<= '0';
			GBTX_TXDVALID_int1	<= '0';
			GBTX_TXDVALID_int2	<= '0';
		elsif(rising_edge(gbt_clk_40MHz)) then
			GBTX_TXDVALID_int1	<= valid_data_to_gbtx;
			GBTX_TXDVALID_int2	<= GBTX_TXDVALID_int1;
			GBTX_TXDVALID		<= GBTX_TXDVALID_int2;
		end if;
	end process trigger_process;
	
  
  -- *******************************************************************************************************************************
  -- Gestione SRAM RR
  -- *******************************************************************************************************************************
  
  -- I dati provengono da VME_INT che scrive come se ci fosse una FIFO DDLOF. L'ordine con cui i
  -- dati vengono scritti da VME_INT non è quello giusto (la header viene scritta per ultima);
  -- l'ordine viene ripristinato in fase di scrittura in RR gestendo l'indirizzo di scrittura
  -- in modo opportuno. La lettura da RR avviene invece in modo sequenziale.
  
  RR_OE <= '0';
  RR_CE <= '0';
  RR_LD <= '0';

  --process(CLEAR, RROF_CLR, gbt_clk_40MHz)		DAV
  process(CLEAR, gbt_clk_40MHz)
  begin
    --if CLEAR = '1' or RROF_CLR = '1' then			DAV
	if CLEAR = '1' then
      R_PNT           <= (others => '0');
      W_PNT           <= conv_std_logic_vector(NW_DRM_HT - 1, W_PNT'high + 1);  -- la header la scrivo alla fine
      W_JUMP          <= (others => '0');
      RR_WEi          <= '1';
      RR_READ         <= '0';
      RR_READ1        <= '0';
      RR_READ2        <= '0';
      RRO_VALID       <= '0';
      RR_VALID        <= '0';
      RR_READ_FIRST   <= '0';
      RR_READ_FIRST1  <= '0';
      RR_READ_FIRST2  <= '0';
      RRO_VALID_FIRST <= '0';
      RR_Di           <= (others => '0');
      RR_Ai           <= (others => '0');
      RROF_DTI        <= (others => '0');
      RROF_WR         <= '0';
      DDLOF_FULL      <= '0';
      NE_AF           <= '0';
      NW_AF           <= '0';
      RR_NW           <= (others => '0');
      RR_NEV          <= (others => '0');
      EVHEAD_CNT      <= (others => '0');
      WR_EVHEAD       <= '0';
      RWCNT           <= "000000000000000001";	  

    elsif rising_edge(gbt_clk_40MHz) then

      if RODATA = '0' then

        -- SRAM in test mode (purché non ci sia uno shut-down di SC che richiedere di mettere tutti i pin a 0)
        RR_Ai <= regs.rr_adl(0) & regs.rr_adl(15 downto 0); -- il bit 16 lo metto uguale al bit 0
        if regs.status(STATUS_SC_SDN) = '0' then
          RR_Di <= "0000" & regs.roc_tdata & regs.roc_tdata;
          RR_WEi <= not WPULSE(WP_WRR);
        else
          RR_Di <= (others => '0');
          RR_WEi <= '0';
        end if;

        RROF_WR 	<= DDLOF_WR;
        RROF_DTI 	<= DDLOF_DTI;
        DDLOF_FULL 	<= RROF_ALMFULL;

      else

        RR_READ        <= '0';
        RR_READ_FIRST  <= '0';
        RR_VALID       <= '0';
        DDLOF_FULL     <= NE_AF or NW_AF;
        -- Scrittura da ROC a RR (ha priorità sulla lettura)
        if DDLOF_WR = '1' then
          RR_WEi <= '0';
          RR_NW  <= RR_NW + 1;
          if RR_NW = RR_AFLEV then
            NW_AF <= '1';
          end if;
          RR_Ai <= W_PNT;
          RR_Di <= '0' & DDLOF_DTI(32) & DDLOF_DTI(32) & DDLOF_DTI(32 downto 0);  -- triplice copia del bit 32

          if DDLOF_DTI(32) = '1' then -- marca il trailer dell'evento (ultima parola)
            W_PNT  <= W_JUMP; -- torno indietro a scrivere le header
            W_JUMP <= W_PNT + NW_DRM_HT;  -- punta all'offset iniziale per scrivere l'evento successivo
            WR_EVHEAD <= '1';
          elsif conv_integer(EVHEAD_CNT) = NW_DRM_HT-2 then
            W_PNT  <= W_JUMP;
            W_JUMP <= W_JUMP - NW_DRM_HT + 1;
            RR_NEV <= RR_NEV + 1;
            if conv_integer(RR_NEV) = RR_NEV_AFLEV then
              NE_AF <= '1';
            end if;
            WR_EVHEAD <= '0';
            EVHEAD_CNT <= (others => '0');  -- azzero il contatore di parole dell'header
          else
            W_PNT <= W_PNT + 1;
            if WR_EVHEAD = '1' then
              EVHEAD_CNT <= EVHEAD_CNT + 1;
            end if;
          end if;

        -- Ciclo di lettura da RR verso DDL (i dati sono buoni al ciclo successivo)
        else
          RR_WEi <= '1';
          RR_Ai  <= R_PNT;  -- Indirizzo di lettura
          if RR_NEV /= "00000000" and RROF_ALMFULL = '0' and RR_READ_FIRST = '0' and RR_READ_FIRST1 = '0'
             and RR_READ_FIRST2 = '0' and RRO_VALID_FIRST = '0' then
            RR_READ <= '1';
            R_PNT <= R_PNT + 1;
            RR_NW <= RR_NW - 1;
            if RR_NW = RR_AFLEV then
              NW_AF <= '0';
            end if;
            if conv_integer(RWCNT) = 1 then
              RR_READ_FIRST <= '1';
            end if;
            if conv_integer(RWCNT) = 2 then
              RR_NEV <= RR_NEV - 1;
              if conv_integer(RR_NEV) = RR_NEV_AFLEV then
                NE_AF <= '0';
              end if;
            end if;
            RWCNT <= RWCNT - 1;
          end if;

        end if;

        -- =====================================================================================
        -- Codice valido per SRAM Pipelined CY7C1370 o CY7C1350
        -- =====================================================================================
        RR_READ1  		<= RR_READ;
        RR_READ2  		<= RR_READ1;
        RRO_VALID 		<= RR_READ2;
        RR_READ_FIRST1 	<= RR_READ_FIRST;
        RR_READ_FIRST2 	<= RR_READ_FIRST1;
        RRO_VALID_FIRST <= RR_READ_FIRST2;
        RR_VALID 		<= RR_READ2;

        -- Il segnale RR_VALID segnala che al ciclo di gbt_clk_40MHz precedente sul bus dati di RR c'era un dato
        -- buono che la Cyclone può leggere e scrivere nella sua SRAM di staging.

        -- =====================================================================================

        if RRO_VALID = '1' then
          RROF_WR <= '1';
          RROF_DTI <= RR_Ds(32 downto 0);
          if RRO_VALID_FIRST = '1' then
            RWCNT <= RR_Ds(RWCNT'high+2 downto 2);  -- Leggo l'event size (espresso in byte => divido per 4)
          end if;
        else
          RROF_WR <= '0';
        end if;

      end if;
    end if;
  end process;

	-- =====================================================================================
	-- Codice valido per SRAM Pipelined CY7C1370 o CY7C1350
	-- =====================================================================================
	  -- uscita dati verso RR (pipeline di 2 clock come previsto dalla SRAM Pipelined)
	  -- e ingresso dati (risincronizzati per migliorare timing)
	  --process(CLEAR, RROF_CLR, gbt_clk_40MHz) 	DAV
	  process(CLEAR, gbt_clk_40MHz)
	  begin
		--if CLEAR = '1' or RROF_CLR = '1' then	DAV
		if CLEAR = '1' then
		  RR_D_OE  <= '0';
		  RR_D1  <= (others => '0');
		  RR_D2  <= (others => '0');
		  RR_WE1 <= '1';
		  RR_Ds  <= (others => '0');
		elsif rising_edge(gbt_clk_40MHz) then
		  RR_WE1  <= RR_WEi;
		  RR_D1   <= RR_Di;
		  RR_D2   <= RR_D1;
		  RR_D_OE <= not RR_WE1;
		  RR_Ds   <= RR_D;
		end if;
	  end process;
	  RR_Dz <= RR_D2 when RR_D_OE = '1' else (others => 'Z');

	  -- NOTA: le uscite verso la RR sono ritardate di 1ns (in simulazione) per rispettare
	  -- l'hold time della SRAM. Nella realtà, il ritardo è garantito dal Tco della FPGA

	  RR_D  <= transport RR_Dz  after 1 ns; 
	  RR_A  <= transport "000" & RR_Ai  after 1 ns;
	  RR_WE <= transport RR_WEi after 1 ns;

	  -- TEST read
	  regs.rr_dtl <= RR_Ds(15 downto 0);
	  regs.rr_dth <= RR_Ds(31 downto 16);
	-- =====================================================================================
		
end RTL;		
		