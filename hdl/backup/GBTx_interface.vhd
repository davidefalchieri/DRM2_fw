---------------------------------------------------------------------------------------------------------------------------------------------
-- Created by Davide Falchieri (INFN Bologna)
---------------------------------------------------------------------------------------------------------------------------------------------
-- Notes:
--
--
---------------------------------------------------------------------------------------------------------------------------------------------
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
	active_high_reset:		in  	std_logic;
	clear:					in		std_logic;
	soft_clear:				in	 	std_logic;
	gbt_clk_40MHz:			in  	std_logic;		
	FPGACK_40MHz:			in		std_logic;		
	regs: 					inout  	REGS_RECORD; 
	acq_on:					in		std_logic;
		-- GBTx interface
	GBTX_RXDVALID:			in  	std_logic;
	GBTX_DOUT_rise:			in		std_logic_vector(39 downto 0);
	GBTX_DOUT_fall:			in		std_logic_vector(39 downto 0);
	GBTX_TXDVALID:			out 	std_logic;
	data_to_gbtx:			out		std_logic_vector(83 downto 0);
		-- vme_int --> GBTx interface
	GBTx_data_fifo_dti_ck:	in		std_logic_vector(64 downto 0);
	GBTx_data_fifo_wr_ck:	in		std_logic;
	GBTx_data_fifo_almfull:	out		std_logic;
	RODATA_ck: 				in   	std_logic;          				-- 1 => Readout Data; 0 => Slow Control data
		-- GBTx interface --> vme_int
	l1a_ttc:				out		std_logic;
	l1msg_dto:				out 	std_logic_vector(79 downto 0);
	l1msg_empty:			out		std_logic;
	l1msg_rd:				in		std_logic;
	bunch_reset_clk:		out    	std_logic
	);
end GBTx_interface;

architecture RTL of GBTx_interface is

	-- GBTx signals -------------------------------------------------------------------------------------------------------------------------
	signal GBTX_RXDVALID_int1: 					std_logic;
	signal GBTX_RXDVALID_int2: 					std_logic;
	signal data_from_gbtx:						std_logic_vector(79 downto 0);
	signal valid_data_to_gbtx:					std_logic;
	signal GBTX_TXDVALID_int1:					std_logic;
	signal GBTX_TXDVALID_int2:					std_logic;
	signal data_valid:							std_logic;
	signal l1msg_almfull:						std_logic;
	signal l1msg_rd_gbtck:						std_logic;
	signal l1msg_gbtck_we:						std_logic;
	signal l1msg_dto_gbtck:						std_logic_vector(79 downto 0);
	signal l1msg_empty_gbtck:					std_logic;
	signal l1msg_dto_valid:						std_logic;

	-- signals from vme_int -----------------------------------------------------------------------------------------------------------------
	signal RODATA: 								std_logic;          
	signal l1a_ttc_gbtck:						std_logic;
	signal l1msg_we:							std_logic;

	-- GBTx_data_fifo signals ---------------------------------------------------------------------------------------------------------------
	signal GBTx_data_fifo_empty: 				std_logic;
	signal GBTx_data_fifo_rd: 					std_logic;
	signal GBTx_data_fifo_rdi: 					std_logic;
	
	signal RODATA_int:							std_logic;
	
	-- BER check signals --------------------------------------------------------------------------------------------------------------------
	signal count_ber:							std_logic_vector(15 downto 0);
	signal ber_test_ok: 						std_logic;
	
	-- RDH signals --------------------------------------------------------------------------------------------------------------------------
	constant c_IDLE: 							std_logic_vector(3 downto 0) := x"0";  
	constant c_SOP: 							std_logic_vector(3 downto 0) := x"1"; 
	constant c_EOP: 							std_logic_vector(3 downto 0) := x"2"; 
	
	type   PSTATE is (WAIT_STATE, REC_TRIGGER_STATE, REC_TRIGGER_STATE1, 
					  HB_OPEN_SOP, HB_OPEN_RDH0, HB_OPEN_RDH1, HB_OPEN_RDH2, HB_OPEN_RDH3, 
					  HB_CLOSE_EOP, HB_CLOSE_SOP, HB_CLOSE_RDH0, HB_CLOSE_RDH1, HB_CLOSE_RDH2, HB_CLOSE_RDH3, HB_CLOSE_EOP1,
					  DATA_STATE, PHY_EOP, PHY_SOP, PHY_RDH0, PHY_RDH1, PHY_RDH2, PHY_RDH3);
	attribute syn_encoding: 					string;
    attribute syn_encoding of PSTATE: type is "onehot";
    signal state_pattern: 						PSTATE;
	
	signal rdh_header_version:					std_logic_vector(7 downto 0);
	signal rdh_header_size:						std_logic_vector(7 downto 0);
	signal rdh_block_length:					std_logic_vector(15 downto 0);
	signal rdh_fee_id:							std_logic_vector(15 downto 0);
	signal rdh_priority_bit:					std_logic_vector(7 downto 0);
	signal rdh_trg_orbit:						std_logic_vector(31 downto 0);
	signal rdh_hb_orbit:						std_logic_vector(31 downto 0);
	signal rdh_trg_bc:							std_logic_vector(11 downto 0);
	signal rdh_hb_bc:							std_logic_vector(11 downto 0);
	signal rdh_trg_type:						std_logic_vector(31 downto 0);
	signal rdh_detector_field:					std_logic_vector(31 downto 0);
	signal rdh_par:								std_logic_vector(15 downto 0);
	signal rdh_stop_bit:						std_logic_vector(7 downto 0);
	signal rdh_pages_counter:					std_logic_vector(15 downto 0);
	signal pages_counter:						std_logic_vector(15 downto 0);
	
	signal rdh_word0:							std_logic_vector(79 downto 0);
	signal rdh_word1:							std_logic_vector(79 downto 0);
	signal rdh_word2:							std_logic_vector(79 downto 0);
	signal rdh_word3:							std_logic_vector(79 downto 0);
	signal rdh_word0_old:						std_logic_vector(79 downto 0);
	signal rdh_word1_old:						std_logic_vector(79 downto 0);
	signal rdh_word2_old:						std_logic_vector(79 downto 0);
	signal rdh_word3_old:						std_logic_vector(79 downto 0);
	
	-- trigger_fifo signals -----------------------------------------------------------------------------------------------------------------
	signal re_l1a:								std_logic;
	signal re_bunch_reset:						std_logic;
	signal empty_l1a:							std_logic;
	signal empty_bunch_reset:					std_logic;
	signal trigger_fifo_l1a_q:					std_logic;
	signal trigger_fifo_bcr_q:					std_logic;
	
	signal heart_beat:							std_logic;
	signal sot, eot:							std_logic;
	signal run_active:							std_logic;
	signal bunch_reset:							std_logic;
	signal state_sot:							std_logic;
    signal trig_cnt:		        			std_logic_vector(23 downto 0);
	signal rdh_trigg_in_orbit:					std_logic_vector(7 downto 0);
	signal trigg_in_orbit:						std_logic_vector(7 downto 0);
	signal fifo_clear:							std_logic;
	signal count_data:							integer range 0 to 1023;
	signal eot_received:						std_logic_vector(1 downto 0);
	signal hb_and_phy:							std_logic;
	
	signal GBTx_data64b:						std_logic_vector(63 downto 0);
	signal GBTx_valid64b:						std_logic;
	signal GBTx_last64b:						std_logic;
	
	signal GBTx_data_fifo_dvalid:				std_logic;
	signal GBTx_fifo_out:						std_logic_vector(64 downto 0);

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
	end component l1msg;
	
	component l1msg_gbtck
    port(
        -- Inputs
        DATA   : in  std_logic_vector(79 downto 0);
        CLK    : in  std_logic;
        RE     : in  std_logic;
        RESET  : in  std_logic;
        WE     : in  std_logic;
        -- Outputs
		DVLD   : out std_logic;
        EMPTY  : out std_logic;
        FULL   : out std_logic;
        Q      : out std_logic_vector(79 downto 0)
        );
	end component l1msg_gbtck;
	
	component trigger_fifo
    port(
        -- Inputs
        DATA   : in  std_logic_vector(0 to 0);
        RCLOCK : in  std_logic;
        RE     : in  std_logic;
        RESET  : in  std_logic;
        WCLOCK : in  std_logic;
        WE     : in  std_logic;
        -- Outputs
        EMPTY  : out std_logic;
        FULL   : out std_logic;
        Q      : out std_logic_vector(0 to 0)
        );
	end component trigger_fifo;
	
	component GBTx_data_fifo
    port(
        DATA   : in  std_logic_vector(64 downto 0);
        RCLOCK : in  std_logic;
        RE     : in  std_logic;
        RESET  : in  std_logic;
        WCLOCK : in  std_logic;
        WE     : in  std_logic;
        AFULL  : out std_logic;
        DVLD   : out std_logic;
        EMPTY  : out std_logic;
        FULL   : out std_logic;
        Q      : out std_logic_vector(64 downto 0)
        );
	end component GBTx_data_fifo;

begin
	
	fifo_clear					<= clear or soft_clear or regs.ctrl2(CTRL2_DISABLE_RO);
	regs.status(STATUS_RUN)		<= run_active;

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- GBTx packet header: RDH --------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------

	-- RDH word 0
	rdh_header_version 	<= x"05";
	rdh_header_size 	<= x"40";		
	rdh_block_length	<= CONV_STD_LOGIC_VECTOR(RDH_SIZE, rdh_block_length'length);		
	rdh_fee_id			<= regs.drm_id(15 downto 0);
	rdh_priority_bit	<= x"00";
	
	-- RDH word 1
	rdh_trg_orbit		<= l1msg_dto_gbtck(79 downto 48) when (l1msg_dto_gbtck(TOF_TT) = '1' and regs.ctrl(CTRL_TOF_TRIGGER) = '1') else		-- TOF trigger
						   l1msg_dto_gbtck(79 downto 48) when (l1msg_dto_gbtck(PHYSICS_TT) = '1' and regs.ctrl(CTRL_TOF_TRIGGER) = '0') else
						   (others => '0');			
	rdh_hb_orbit		<= l1msg_dto_gbtck(79 downto 48) when l1msg_dto_gbtck(HB_TT) = '1' else (others => '0');			-- HB
	
	-- RDH word 2
	rdh_trg_bc			<= l1msg_dto_gbtck(43 downto 32) when (l1msg_dto_gbtck(TOF_TT) = '1' and regs.ctrl(CTRL_TOF_TRIGGER) = '1') else		-- TOF trigger
						   l1msg_dto_gbtck(43 downto 32) when (l1msg_dto_gbtck(PHYSICS_TT) = '1' and regs.ctrl(CTRL_TOF_TRIGGER) = '0') else
						   (others => '0');	
	rdh_hb_bc			<= l1msg_dto_gbtck(43 downto 32) when l1msg_dto_gbtck(HB_TT) = '1' else (others => '0');			-- HB
	rdh_trg_type		<= l1msg_dto_gbtck(31 downto 0);
	
	-- RDH word 3
	rdh_detector_field	<= x"0000070F";
	rdh_par				<= x"0000";
	rdh_stop_bit		<= "00000000";
	rdh_pages_counter	<= x"0000";

	-- RDH v4
	-- rdh_word0 			<= x"000000" & rdh_priority_bit & rdh_fee_id & rdh_block_length & rdh_header_size & x"04";  				-- 24 zeros | 8 | 16 | 16 | 8 | 8
	-- rdh_word1 			<= x"0000" & rdh_hb_orbit & rdh_trg_orbit;																	-- 16 zeros | 32 | 32								
	-- rdh_word2 			<= x"0000" & rdh_trg_type & "0000" & rdh_hb_bc & "0000" & rdh_trg_bc;										-- 16 zeros | 32 | 4 zeros | 12 | 4 zeros | 12
	-- rdh_word3 			<= x"000000" & rdh_pages_counter & rdh_stop_bit & rdh_par & rdh_detector_field;								-- 24 zeros | 16 | 8 | 16 | 16
	
	-- RDH v5
	-- rdh_word0 			<= x"0000000000" & rdh_priority_bit & rdh_fee_id & rdh_header_size & rdh_header_version;  					-- 40 zeros | 8 | 16 | 8 | 8
	-- rdh_word1 			<= x"0000" & rdh_hb_orbit & x"00000" & rdh_hb_bc;															-- 16 zeros | 32 | 20 | 12								
	-- rdh_word2 			<= x"000000" & rdh_stop_bit & rdh_pages_counter & rdh_trg_type;												-- 24 zeros | 8 | 16 | 32
	-- rdh_word3 			<= x"00000000" & rdh_par & rdh_detector_field;																-- 24 zeros | 16 | 8 | 16 | 32	
	
	rdh_word0 			<= x"000000" & rdh_priority_bit & rdh_fee_id & rdh_block_length & rdh_header_size & x"04" when regs.CTRL(CTRL_RDH_VERSION) = '0' else	-- 24 zeros | 8 | 16 | 16 | 8 | 8
						   x"0000000000" & rdh_priority_bit & rdh_fee_id & rdh_header_size & rdh_header_version;												-- 40 zeros | 8 | 16 | 8 | 8
						   
	rdh_word1			<= x"0000" & rdh_hb_orbit & rdh_trg_orbit when regs.CTRL(CTRL_RDH_VERSION) = '0' else													-- 16 zeros | 32 | 32
						   x"0000" & rdh_hb_orbit & x"00000" & rdh_hb_bc;																						-- 16 zeros | 32 | 20 | 12
						   
	rdh_word2			<= x"0000" & rdh_trg_type & "0000" & rdh_hb_bc & "0000" & rdh_trg_bc when regs.CTRL(CTRL_RDH_VERSION) = '0' else						-- 16 zeros | 32 | 4 zeros | 12 | 4 zeros | 12
						   x"000000" & rdh_stop_bit & rdh_pages_counter & rdh_trg_type;																			-- 24 zeros | 8 | 16 | 32
						   
	rdh_word3			<= x"000000" & rdh_pages_counter & rdh_stop_bit & rdh_par & rdh_detector_field(15 downto 0) when regs.CTRL(CTRL_RDH_VERSION) = '0' else	-- 24 zeros | 16 | 8 | 16 | 16
						   x"00000000" & rdh_par & rdh_detector_field;																							-- 24 zeros | 16 | 8 | 16 | 32
	
	-----------------------------------------------------------------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- from vme_int towards GBTx_interface	-------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	RODATA_int_process: process(gbt_clk_40MHz, clear, soft_clear)
	begin	
		if(clear = '1' or soft_clear = '1') then
			RODATA_int				<= '0';
			RODATA					<= '0';
		elsif(rising_edge(gbt_clk_40MHz)) then
			RODATA_int				<= RODATA_ck;
			RODATA					<= RODATA_int;
		end if;
	end process RODATA_int_process;
	-----------------------------------------------------------------------------------------------------------------------------------------
	 
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- towards GBTx	-------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	GBTx_data_fifo_instance: GBTx_data_fifo
	port map
        (
        DATA   => GBTx_data_fifo_dti_ck,
		WE     => GBTx_data_fifo_wr_ck,
		WCLOCK => FPGACK_40MHz,
		RESET  => fifo_clear,
        RCLOCK => gbt_clk_40MHz,
        RE     => GBTx_data_fifo_rd,
        DVLD   => GBTx_data_fifo_dvalid,
        EMPTY  => GBTx_data_fifo_empty,
		AFULL  => GBTx_data_fifo_almfull,
        FULL   => open,
        Q      => GBTx_fifo_out
        );
	
	GBTx_data64b		<= GBTx_fifo_out(63 downto 0);
	GBTx_valid64b		<= GBTx_data_fifo_dvalid;
	GBTx_last64b		<= GBTx_fifo_out(64) and GBTx_data_fifo_dvalid;
	GBTx_data_fifo_rd 	<= GBTx_data_fifo_rdi and not(GBTx_data_fifo_empty) and not(GBTx_last64b);
	
	state_machine_process: process(clear, soft_clear, gbt_clk_40MHz)
	begin
		if(clear = '1' or soft_clear = '1') then
			state_pattern				<= WAIT_STATE;
			valid_data_to_gbtx			<= '0';
			l1msg_rd_gbtck				<= '0';
			GBTx_data_fifo_rdi			<= '0';
			count_data					<= 0;
			pages_counter				<= (others => '0');
			eot_received				<= "00";
			hb_and_phy					<= '0';
		elsif(rising_edge(gbt_clk_40MHz)) then
			if(state_pattern = WAIT_STATE) then
				if(regs.ber_test(BER_LOOP_EN) = '1') then
					data_to_gbtx		<= x"0" & data_from_gbtx;		-- GBTx loopback test
					valid_data_to_gbtx	<= data_valid;
					state_pattern		<= WAIT_STATE;
				elsif(l1msg_empty_gbtck = '0') then													
					data_to_gbtx		<= x"0" & c_IDLE & x"0000000000000000000";
					valid_data_to_gbtx	<= '0';
					l1msg_rd_gbtck		<= '1';
					state_pattern		<= REC_TRIGGER_STATE;
				else
					data_to_gbtx		<= x"0" & c_IDLE & x"0000000000000000000";
					valid_data_to_gbtx	<= '0';
					state_pattern		<= WAIT_STATE;
				end if;
				GBTx_data_fifo_rdi		<= '0';
				eot_received			<= "00";
				hb_and_phy				<= '0';
			elsif(state_pattern = REC_TRIGGER_STATE) then
				valid_data_to_gbtx	<= '0';
				l1msg_rd_gbtck		<= '0';
				state_pattern		<= REC_TRIGGER_STATE1;
			elsif(state_pattern = REC_TRIGGER_STATE1) then
				valid_data_to_gbtx	<= '0';
				l1msg_rd_gbtck		<= '0';
				if(l1msg_dto_gbtck(HB_TT) = '1') then
					if(l1msg_dto_gbtck(SOT_TT) = '1') then				-- after a HB+SOT
						state_pattern		<= HB_OPEN_SOP;
					elsif(l1msg_dto_gbtck(EOT_TT) = '1') then			-- after a HB+EOT
						eot_received		<= "01";
						state_pattern		<= HB_CLOSE_EOP;
					elsif((l1msg_dto_gbtck(TOF_TT) = '1' and regs.ctrl(CTRL_TOF_TRIGGER) = '1') or (l1msg_dto_gbtck(PHYSICS_TT) = '1' and regs.ctrl(CTRL_TOF_TRIGGER) = '0')) then			-- after a HB and TOF trigger in the same BC
						state_pattern		<= HB_CLOSE_EOP;
						hb_and_phy			<= '1';
					else												-- after a HB
						state_pattern		<= HB_CLOSE_EOP;
					end if;
				else													-- after a TOF trigger (l1msg_dto_gbtck(TOF_TT) = '1'or l1msg_dto_gbtck(PHYSICS_TT))
					if(GBTx_data_fifo_empty = '0') then
						GBTx_data_fifo_rdi	<= '1';
					else
						GBTx_data_fifo_rdi	<= '0';
					end if;
					state_pattern	<= DATA_STATE;
				end if;
			-- HB_OPEN ----------------------------------------------------------------------------------------------------------------------------------------
			elsif(state_pattern = HB_OPEN_SOP) then
				data_to_gbtx		<= x"0" & c_SOP & x"0000000000000000000";
				valid_data_to_gbtx	<= '0';
				l1msg_rd_gbtck		<= '0';
				state_pattern		<= HB_OPEN_RDH0;
				GBTx_data_fifo_rdi	<= '0';
				pages_counter		<= (others => '0');
				count_data			<= 0;
			elsif(state_pattern = HB_OPEN_RDH0) then
				data_to_gbtx		<= x"0" & rdh_word0;
				valid_data_to_gbtx	<= '1';
				GBTx_data_fifo_rdi	<= '0';
				rdh_word0_old		<= rdh_word0;
				state_pattern		<= HB_OPEN_RDH1;
			elsif(state_pattern = HB_OPEN_RDH1) then
				data_to_gbtx		<= x"0" & rdh_word1;
				valid_data_to_gbtx	<= '1';
				GBTx_data_fifo_rdi	<= '0';
				rdh_word1_old		<= rdh_word1;
				state_pattern		<= HB_OPEN_RDH2;
			elsif(state_pattern = HB_OPEN_RDH2) then
				data_to_gbtx		<= x"0" & rdh_word2;
				valid_data_to_gbtx	<= '1';
				GBTx_data_fifo_rdi	<= '0';
				rdh_word2_old		<= rdh_word2;
				state_pattern		<= HB_OPEN_RDH3;
			elsif(state_pattern = HB_OPEN_RDH3) then
				data_to_gbtx		<= x"0" & rdh_word3;
				valid_data_to_gbtx	<= '1';			
				GBTx_data_fifo_rdi	<= '0';	
				rdh_word3_old		<= rdh_word3;
				if(hb_and_phy = '1') then
					state_pattern	<= DATA_STATE;
				elsif(eot_received = "01") then
					state_pattern 	<= HB_CLOSE_EOP;
					eot_received	<= "10";
				else
					state_pattern	<= WAIT_STATE;
				end if;
			-- HB_CLOSE ---------------------------------------------------------------------------------------------------------------------------------------
			elsif(state_pattern = HB_CLOSE_EOP) then
				data_to_gbtx		<= x"0" & c_EOP & x"0000000000000000000";
				valid_data_to_gbtx	<= '0';			
				GBTx_data_fifo_rdi	<= '0';	
				pages_counter		<= pages_counter + 1;
				count_data			<= 0;
				state_pattern		<= HB_CLOSE_SOP;
			elsif(state_pattern = HB_CLOSE_SOP) then
				data_to_gbtx		<= x"0" & c_SOP & x"0000000000000000000";
				valid_data_to_gbtx	<= '0';
				l1msg_rd_gbtck		<= '0';
				state_pattern		<= HB_CLOSE_RDH0;
				GBTx_data_fifo_rdi	<= '0';
			elsif(state_pattern = HB_CLOSE_RDH0) then
				data_to_gbtx		<= x"0" & rdh_word0_old;
				valid_data_to_gbtx	<= '1';
				GBTx_data_fifo_rdi	<= '0';
				state_pattern		<= HB_CLOSE_RDH1;
			elsif(state_pattern = HB_CLOSE_RDH1) then
				data_to_gbtx		<= x"0" & rdh_word1_old;
				valid_data_to_gbtx	<= '1';
				GBTx_data_fifo_rdi	<= '0';
				state_pattern		<= HB_CLOSE_RDH2;
			elsif(state_pattern = HB_CLOSE_RDH2) then
				if(regs.CTRL(CTRL_RDH_VERSION) = '0') then
					data_to_gbtx		<= x"0" & rdh_word2_old;																			-- RDH v4
				else
					data_to_gbtx		<= x"0" & rdh_word2_old(79 downto 56) & "00000001" & pages_counter & rdh_word2_old(31 downto 0);	-- RDH v5
				end if;
				valid_data_to_gbtx	<= '1';
				GBTx_data_fifo_rdi	<= '0';
				state_pattern		<= HB_CLOSE_RDH3;
			elsif(state_pattern = HB_CLOSE_RDH3) then	
				if(regs.CTRL(CTRL_RDH_VERSION) = '0') then
					data_to_gbtx		<= x"0" & rdh_word3_old(79 downto 56) & pages_counter & "00000001" & rdh_word3_old(31 downto 0);	-- RDH v4
				else
					data_to_gbtx		<= x"0" & rdh_word3_old(79 downto 32) & rdh_trigg_in_orbit & rdh_word3_old(23 downto 0);			-- RDH v5
				end if;
				valid_data_to_gbtx	<= '1';			
				GBTx_data_fifo_rdi	<= '0';	
				state_pattern		<= HB_CLOSE_EOP1;
			elsif(state_pattern = HB_CLOSE_EOP1) then
				data_to_gbtx		<= x"0" & c_EOP & x"0000000000000000000";
				valid_data_to_gbtx	<= '0';			
				GBTx_data_fifo_rdi	<= '0';
				if(eot_received <= "01") then
					state_pattern 	<= HB_OPEN_SOP;
				else
					state_pattern	<= WAIT_STATE;
					eot_received	<= "00";
				end if;
			-- DATA transmission ------------------------------------------------------------------------------------------------------------------------------
			elsif(state_pattern = DATA_STATE) then
				if(GBTx_valid64b = '1') then
					data_to_gbtx		<= x"00000" & GBTx_data64b;
					valid_data_to_gbtx	<= '1';
				else
					data_to_gbtx		<= x"00000000000000000000" & c_IDLE;
					valid_data_to_gbtx	<= '0';
				end if;
				if(GBTx_data_fifo_rd = '1') then
					count_data			<= count_data + 1;
				end if;				
				if(GBTx_last64b = '1' and GBTx_valid64b = '1') then
					state_pattern			<= WAIT_STATE;
					GBTx_data_fifo_rdi		<= '0';
				elsif(count_data = 507 and GBTx_data_fifo_rd = '1') then		-- DAV: to be improved ...
					state_pattern			<= DATA_STATE;
					GBTx_data_fifo_rdi		<= '0';
				elsif(count_data > 507) then		-- DAV: 149 for simulation purposes, 508 + 4 (RDH) = 512
					state_pattern			<= PHY_EOP;
					GBTx_data_fifo_rdi		<= '0';
				else
					state_pattern			<= DATA_STATE;
					GBTx_data_fifo_rdi		<= not GBTx_data_fifo_empty;
				end if;
			elsif(state_pattern = PHY_EOP) then
				data_to_gbtx		<= x"0" & c_EOP & x"0000000000000000000";
				valid_data_to_gbtx	<= '0';			
				GBTx_data_fifo_rdi	<= '0';	
				state_pattern		<= PHY_SOP;
			elsif(state_pattern = PHY_SOP) then
				data_to_gbtx		<= x"0" & c_SOP & x"0000000000000000000";
				valid_data_to_gbtx	<= '0';
				l1msg_rd_gbtck		<= '0';
				state_pattern		<= PHY_RDH0;
				GBTx_data_fifo_rdi	<= '0';	
				pages_counter		<= pages_counter + 1;
			elsif(state_pattern = PHY_RDH0) then
				data_to_gbtx		<= x"0" & rdh_word0_old;
				valid_data_to_gbtx	<= '1';
				GBTx_data_fifo_rdi	<= '0';
				state_pattern		<= PHY_RDH1;
			elsif(state_pattern = PHY_RDH1) then
				data_to_gbtx		<= x"0" & rdh_word1_old;
				valid_data_to_gbtx	<= '1';
				GBTx_data_fifo_rdi	<= '0';
				state_pattern		<= PHY_RDH2;
			elsif(state_pattern = PHY_RDH2) then
				if(regs.CTRL(CTRL_RDH_VERSION) = '0') then
					data_to_gbtx		<= x"0" & rdh_word2_old;																-- RDH v4
				else
					data_to_gbtx		<= x"0" & rdh_word2_old(79 downto 48) & pages_counter & rdh_word2_old(31 downto 0);		-- RDH v5
				end if;
				valid_data_to_gbtx	<= '1';
				GBTx_data_fifo_rdi	<= '0';
				state_pattern		<= PHY_RDH3;
			elsif(state_pattern = PHY_RDH3) then
				if(regs.CTRL(CTRL_RDH_VERSION) = '0') then
					data_to_gbtx		<= x"0" & rdh_word3_old(79 downto 56) & pages_counter & rdh_word3_old(39 downto 0);		-- RDH v4
				else
					data_to_gbtx		<= x"0" & rdh_word3_old;																-- RDH v5
				end if;
				valid_data_to_gbtx	<= '1';			
				GBTx_data_fifo_rdi	<= '0';	
				count_data			<= 0;
				state_pattern		<= DATA_STATE;
			end if;
		end if;
	end process state_machine_process;
	
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- BER check process --------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	ber_test_process: process(clear, soft_clear, gbt_clk_40MHz)
	begin
		if(clear = '1' or soft_clear = '1') then
			ber_test_ok	<= '0';
			count_ber	<= (others => '0');
		elsif(rising_edge(gbt_clk_40MHz)) then
			if(regs.ber_test(BER_RES_VALUE) = '1') then
				ber_test_ok	<= '0';
				count_ber	<= (others => '0');
			elsif(regs.ber_test(BER_CHECK_EN) = '1') then
				if((data_from_gbtx(15 downto 0)  = data_to_gbtx(15 downto 0)+1) AND
				   (data_from_gbtx(31 downto 16) = data_to_gbtx(31 downto 16)+1) AND 
				   (data_from_gbtx(47 downto 32) = data_to_gbtx(47 downto 32)+1) AND 
				   (data_from_gbtx(63 downto 48) = data_to_gbtx(63 downto 48)+1) AND 
				   (data_from_gbtx(79 downto 64) = data_to_gbtx(79 downto 64)+1)) then
					ber_test_ok	<= '1';
				else	
					ber_test_ok	<= '0';
					if(count_ber = x"FFFF") then
						count_ber	<= x"FFFF";
					else
						count_ber	<= count_ber + 1;
					end if;
				end if;
			else	
				ber_test_ok	<= '0';
				count_ber	<= (others => '0');
			end if;
		end if;
	end process ber_test_process;
	
	regs.ber_value(15 downto 0)	<= count_ber;
	-----------------------------------------------------------------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- from GBTx  ---------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	l1a_ttc_gbtck		<= (data_valid and data_from_gbtx(TOF_TT) and acq_on and run_active and not(l1msg_almfull)) when regs.ctrl(CTRL_TOF_TRIGGER) = '1' else 	-- TOF special trigger
						   (data_valid and data_from_gbtx(PHYSICS_TT) and acq_on and run_active and not(l1msg_almfull));											-- physics trigger
	l1msg_we			<= l1a_ttc_gbtck;																					-- sync with gbt_clk
	bunch_reset			<= data_valid and data_from_gbtx(ORBIT_TT);															-- sync with gbt_clk (ORBIT)	
	heart_beat			<= data_valid and data_from_gbtx(HB_TT);															-- sync with gbt_clk (HEART_BEAT)
	sot					<= data_valid and data_from_gbtx(SOT_TT);															-- sync with gbt_clk (SOT)
	eot					<= data_valid and data_from_gbtx(EOT_TT);															-- sync with gbt_clk (EOT)
	l1msg_gbtck_we		<= l1a_ttc_gbtck or 																				-- TOF trigger
						   (data_valid and data_from_gbtx(HB_TT) and acq_on and run_active) or								-- heart beat trigger
						   (data_valid and data_from_gbtx(SOT_TT) and acq_on) or											-- SOT (Start Of Trigger)
						   (data_valid and data_from_gbtx(EOT_TT) and acq_on);												-- EOT (End Of Trigger)
	-----------------------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	trigger_fifo_l1a_instance: trigger_fifo
    port map(
        DATA(0)	=> '1',
		RESET  	=> fifo_clear,
		WCLOCK 	=> gbt_clk_40MHz,
		WE     	=> l1a_ttc_gbtck,
		RE     	=> re_l1a,
        RCLOCK 	=> FPGACK_40MHz, 		
		Q(0)   	=> trigger_fifo_l1a_q,
        EMPTY 	=> empty_l1a,
        FULL   	=> open
        );
	
	reading_trigger_fifo_process: process(clear, soft_clear, FPGACK_40MHz)
	begin
		if(clear = '1' or soft_clear = '1') then
			re_l1a		<= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
			if(empty_l1a = '0') then
				re_l1a		<= not re_l1a; 
			else
				re_l1a		<= '0';
			end if;
		end if;
	end process reading_trigger_fifo_process;
	
	l1a_ttc	<= re_l1a and not empty_l1a;
	
	trigger_fifo_bcr_instance: trigger_fifo
    port map(
        DATA(0)	=> '1',
		RESET  	=> fifo_clear,
		WCLOCK 	=> gbt_clk_40MHz,
		WE     	=> bunch_reset,
		RE     	=> re_bunch_reset,
        RCLOCK 	=> FPGACK_40MHz, 		
		Q(0)  	=> trigger_fifo_bcr_q,
        EMPTY 	=> empty_bunch_reset,
        FULL   	=> open
        );
	
	reading_bunch_fifo_process: process(clear, soft_clear, FPGACK_40MHz)
	begin
		if(clear = '1' or soft_clear = '1') then
			re_bunch_reset		<= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
			if(empty_bunch_reset = '0') then
				re_bunch_reset		<= not re_bunch_reset; 
			else
				re_bunch_reset		<= '0';
			end if;
		end if;
	end process reading_bunch_fifo_process;
	
	bunch_reset_clk	<= re_bunch_reset and not empty_bunch_reset;
	
	l1msg_instance : l1msg						-- only for TOF special triggers
    port map	
      (
	   DATA     => data_from_gbtx,
	   WCLOCK   => gbt_clk_40MHz,
	   RESET    => fifo_clear,	   
       WE	    => l1msg_we,
	   EMPTY    => l1msg_empty,
       FULL     => open,
       AFULL    => l1msg_almfull,
	   RCLOCK   => FPGACK_40MHz,
       RE	    => l1msg_rd,   
       Q        => l1msg_dto
       );
	   		
	l1msg_gbtck_instance : l1msg_gbtck			-- to be used for RDH (both heart beat and TOF special triggers)
    port map
      (
	   DATA     => data_from_gbtx,
	   CLK      => gbt_clk_40MHz,
	   RESET    => fifo_clear,
       WE	    => l1msg_gbtck_we,
	   DVLD		=> l1msg_dto_valid,
	   EMPTY    => l1msg_empty_gbtck,
       FULL     => open,
       RE	    => l1msg_rd_gbtck,	   
       Q        => l1msg_dto_gbtck
       );
	
	state_sot_process: process(clear, soft_clear, gbt_clk_40MHz)
	  begin
		if(clear = '1' or soft_clear = '1') then
			state_sot	<= '0';
			run_active	<= '0';
		elsif(rising_edge(gbt_clk_40MHz)) then
			if(acq_on = '0') then
				run_active	<= '0';
				state_sot	<= '0';
			else
				if(state_sot = '0') then
					if(sot = '1') then	
						run_active	<= '1';
						state_sot	<= '1';
					else	
						run_active	<= '0';
						state_sot	<= '0';
					end if;
				else
					if(eot = '1') then	
						run_active	<= '0';
						state_sot	<= '0';
					else	
						run_active	<= '1';
						state_sot	<= '1';
					end if;
				end if;
			end if;
		end if;
	end process state_sot_process;
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- GBTx interface -----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	gbtx_rxd_pipe_process: process(gbt_clk_40MHz)
	begin
		if(rising_edge(gbt_clk_40MHz)) then
			GBTX_RXDVALID_int1	<= GBTX_RXDVALID;
			GBTX_RXDVALID_int2	<= GBTX_RXDVALID_int1;
			data_valid			<= GBTX_RXDVALID_int2;
		end if;
	end process gbtx_rxd_pipe_process;
	
	gbtx_rx_bus_process: process(active_high_reset, gbt_clk_40MHz)
	begin	
		if(active_high_reset = '1') then
			data_from_gbtx	<= (others => '0');
		elsif(rising_edge(gbt_clk_40MHz)) then
				data_from_gbtx(79)	<= GBTX_DOUT_fall(39);	data_from_gbtx(77)	<= GBTX_DOUT_fall(38);	data_from_gbtx(75)	<= GBTX_DOUT_fall(37);	data_from_gbtx(73)	<= GBTX_DOUT_fall(36);
				data_from_gbtx(71)	<= GBTX_DOUT_fall(35);	data_from_gbtx(69)	<= GBTX_DOUT_fall(34);	data_from_gbtx(67)	<= GBTX_DOUT_fall(33);	data_from_gbtx(65)	<= GBTX_DOUT_fall(32);
				data_from_gbtx(63)	<= GBTX_DOUT_fall(31);	data_from_gbtx(61)	<= GBTX_DOUT_fall(30);	data_from_gbtx(59)	<= GBTX_DOUT_fall(29);	data_from_gbtx(57)	<= GBTX_DOUT_fall(28);
				data_from_gbtx(55)	<= GBTX_DOUT_fall(27);	data_from_gbtx(53)	<= GBTX_DOUT_fall(26);	data_from_gbtx(51)	<= GBTX_DOUT_fall(25);	data_from_gbtx(49)	<= GBTX_DOUT_fall(24);
				data_from_gbtx(47)	<= GBTX_DOUT_fall(23);	data_from_gbtx(45)	<= GBTX_DOUT_fall(22);	data_from_gbtx(43)	<= GBTX_DOUT_fall(21);	data_from_gbtx(41)	<= GBTX_DOUT_fall(20);
				data_from_gbtx(39)	<= GBTX_DOUT_fall(19);	data_from_gbtx(37)	<= GBTX_DOUT_fall(18);	data_from_gbtx(35)	<= GBTX_DOUT_fall(17);	data_from_gbtx(33)	<= GBTX_DOUT_fall(16);
				data_from_gbtx(31)	<= GBTX_DOUT_fall(15);	data_from_gbtx(29)	<= GBTX_DOUT_fall(14);	data_from_gbtx(27)	<= GBTX_DOUT_fall(13);	data_from_gbtx(25)	<= GBTX_DOUT_fall(12);
				data_from_gbtx(23)	<= GBTX_DOUT_fall(11);	data_from_gbtx(21)	<= GBTX_DOUT_fall(10);	data_from_gbtx(19)	<= GBTX_DOUT_fall(9);	data_from_gbtx(17)	<= GBTX_DOUT_fall(8);
				data_from_gbtx(15)	<= GBTX_DOUT_fall(7);	data_from_gbtx(13)	<= GBTX_DOUT_fall(6);	data_from_gbtx(11)	<= GBTX_DOUT_fall(5);	data_from_gbtx(9)	<= GBTX_DOUT_fall(4);
				data_from_gbtx(7)	<= GBTX_DOUT_fall(3);	data_from_gbtx(5)	<= GBTX_DOUT_fall(2);	data_from_gbtx(3)	<= GBTX_DOUT_fall(1);	data_from_gbtx(1)	<= GBTX_DOUT_fall(0);
				------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				data_from_gbtx(78)	<= GBTX_DOUT_rise(39);	data_from_gbtx(76)	<= GBTX_DOUT_rise(38);	data_from_gbtx(74)	<= GBTX_DOUT_rise(37);	data_from_gbtx(72)	<= GBTX_DOUT_rise(36);
				data_from_gbtx(70)	<= GBTX_DOUT_rise(35);	data_from_gbtx(68)	<= GBTX_DOUT_rise(34);	data_from_gbtx(66)	<= GBTX_DOUT_rise(33);	data_from_gbtx(64)	<= GBTX_DOUT_rise(32);
				data_from_gbtx(62)	<= GBTX_DOUT_rise(31);	data_from_gbtx(60)	<= GBTX_DOUT_rise(30);	data_from_gbtx(58)	<= GBTX_DOUT_rise(29);	data_from_gbtx(56)	<= GBTX_DOUT_rise(28);
				data_from_gbtx(54)	<= GBTX_DOUT_rise(27);	data_from_gbtx(52)	<= GBTX_DOUT_rise(26);	data_from_gbtx(50)	<= GBTX_DOUT_rise(25);	data_from_gbtx(48)	<= GBTX_DOUT_rise(24);
				data_from_gbtx(46)	<= GBTX_DOUT_rise(23);	data_from_gbtx(44)	<= GBTX_DOUT_rise(22);	data_from_gbtx(42)	<= GBTX_DOUT_rise(21);	data_from_gbtx(40)	<= GBTX_DOUT_rise(20);
				data_from_gbtx(38)	<= GBTX_DOUT_rise(19);	data_from_gbtx(36)	<= GBTX_DOUT_rise(18);	data_from_gbtx(34)	<= GBTX_DOUT_rise(17);	data_from_gbtx(32)	<= GBTX_DOUT_rise(16);
				data_from_gbtx(30)	<= GBTX_DOUT_rise(15);	data_from_gbtx(28)	<= GBTX_DOUT_rise(14);	data_from_gbtx(26)	<= GBTX_DOUT_rise(13);	data_from_gbtx(24)	<= GBTX_DOUT_rise(12);
				data_from_gbtx(22)	<= GBTX_DOUT_rise(11);	data_from_gbtx(20)	<= GBTX_DOUT_rise(10);	data_from_gbtx(18)	<= GBTX_DOUT_rise(9);	data_from_gbtx(16)	<= GBTX_DOUT_rise(8);
				data_from_gbtx(14)	<= GBTX_DOUT_rise(7);	data_from_gbtx(12)	<= GBTX_DOUT_rise(6);	data_from_gbtx(10)	<= GBTX_DOUT_rise(5);	data_from_gbtx(8)	<= GBTX_DOUT_rise(4);
				data_from_gbtx(6)	<= GBTX_DOUT_rise(3);	data_from_gbtx(4)	<= GBTX_DOUT_rise(2);	data_from_gbtx(2)	<= GBTX_DOUT_rise(1);	data_from_gbtx(0)	<= GBTX_DOUT_rise(0);	
		end if;
	end process gbtx_rx_bus_process;	
	
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
	
    trig_cnt_process: process(gbt_clk_40MHz, clear, soft_clear)
	  begin
		if(clear = '1' or soft_clear = '1') then
			trig_cnt	<= (others => '0');
		elsif(rising_edge(gbt_clk_40MHz)) then
			if(acq_on = '1') then
				if(l1a_ttc_gbtck = '1') then
					trig_cnt 	<= trig_cnt + 1;
				end if;
			else	
				trig_cnt	<= (others => '0');
			end if;
		end if;
	end process trig_cnt_process;	  
	  
	regs.trigger_counter	<= x"00" & trig_cnt;
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- counts the number of trigger received during an orbit with flow control (some triggers are ignored when flow control is active)
	trigg_in_orbit_process: process(gbt_clk_40MHz, clear, soft_clear)
	  begin
		if(clear = '1' or soft_clear = '1') then
			trigg_in_orbit		<= (others => '0');
			rdh_trigg_in_orbit	<= (others => '0');
		elsif(rising_edge(gbt_clk_40MHz)) then
			if(acq_on = '1') then
				if(l1msg_dto_valid = '1') then
					if(l1msg_dto_gbtck(HB_TT) = '1') then
						trigg_in_orbit		<= (others => '0');
						rdh_trigg_in_orbit 	<= trigg_in_orbit;
					elsif((l1msg_dto_gbtck(TOF_TT) = '1' and regs.ctrl(CTRL_TOF_TRIGGER) = '1') or (l1msg_dto_gbtck(PHYSICS_TT) = '1' and regs.ctrl(CTRL_TOF_TRIGGER) = '0')) then  
						trigg_in_orbit 		<= trigg_in_orbit + 1;
					end if;
				end if;
			else	
				trigg_in_orbit		<= (others => '0');
				rdh_trigg_in_orbit	<= (others => '0');
			end if;
		end if;
	end process trigg_in_orbit_process;	
	-----------------------------------------------------------------------------------------------------------------------------------------
						   
end RTL;		
		