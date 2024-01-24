library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

library work;
USE work.caenlinkpkg.all;
USE work.DRM2pkg.all;
use work.io_utils.ALL;

library modelsim_lib;
use modelsim_lib.util.all; 

ENTITY CONET_MASTER IS
   PORT( 
      OPTRX_n : IN     std_logic;
      OPTRX_p : IN     std_logic;
      OPTTX_n : OUT    std_logic;
      OPTTX_p : OUT    std_logic
   );
end CONET_MASTER;

architecture SIMUL of CONET_MASTER is

----------------------------------------------------------------------
-- Component Declaration
----------------------------------------------------------------------
component ENC8B10B is
	port
	(
		CLK_IN : in STD_LOGIC;
		RUNDP_RESET_IN : in STD_LOGIC;
		CTRL_IN : in STD_LOGIC;
		DATA_IN : in STD_LOGIC_VECTOR(7 downto 0);
		RUNDP_OUT : out STD_LOGIC;
		ENCODE_OUT : out STD_LOGIC_VECTOR(9 downto 0)
	);
end component ENC8B10B;

component DEC8B10B is
	port
	(
		CLK_IN : IN STD_LOGIC;
		ENCODE_IN : in STD_LOGIC_VECTOR(9 downto 0);
		CTRL_OUT : out STD_LOGIC;
		DATA_OUT : out STD_LOGIC_VECTOR(7 downto 0)
	);
end component DEC8B10B;

component SERDES is
    port(
        OPTRX : IN     std_logic;
        OPTTX : OUT    std_logic;
        RCLK  : BUFFER std_logic := '0';
        RX    : BUFFER std_logic_vector (9 DOWNTO 0);
        BSYNC : BUFFER std_logic;
        TCLK  : IN     std_logic;
        TX    : IN     std_logic_vector (9 DOWNTO 0)
    );
end component SERDES ;

----------------------------------------------------------------------
-- Signals Declaration
----------------------------------------------------------------------

    signal tclk125: 			std_logic;
    signal rclk125: 			std_logic;
    signal OPTTX, OPTRX: 		std_logic;
	signal count_token:			integer range 0 to 200;
	signal tb_evrdy:			std_logic;
	signal tb_ssram_interrupt:	std_logic;

    ---------------------------------------------------------------------------------------------------
    -- CAENVMElib
    ---------------------------------------------------------------------------------------------------   
    subtype uint8_t          is std_logic_vector(7 downto 0);
    subtype uint16_t         is std_logic_vector(15 downto 0);
    subtype uint32_t         is std_logic_vector(31 downto 0);
  
    constant cvA24_S_BLT  : integer := 16#3F#;  -- A24 supervisory block transfer              
    constant cvA24_S_PGM  : integer := 16#3E#;  -- A24 supervisory program access              
    constant cvA24_S_DATA : integer := 16#3D#;  -- A24 supervisory data access                 
    constant cvA24_S_MBLT : integer := 16#3C#;  -- A24 supervisory 64-bit block trnsfer        
    constant cvA24_U_BLT  : integer := 16#3B#;  -- A24 non-privileged block transfer           
    constant cvA24_U_PGM  : integer := 16#3A#;  -- A24 non-privileged program access           
    constant cvA24_U_DATA : integer := 16#39#;  -- A24 non-privileged data access              
    constant cvA24_U_MBLT : integer := 16#38#;  -- A24 non-privileged 64-bit block trnsfer                                         
    constant cvA32_S_BLT  : integer := 16#0F#;  -- A32 supervisory block transfer              
    constant cvA32_S_PGM  : integer := 16#0E#;  -- A32 supervisory program access              
    constant cvA32_S_DATA : integer := 16#0D#;  -- A32 supervisory data access                 
    constant cvA32_S_MBLT : integer := 16#0C#;  -- A32 supervisory 64-bit block trnsfer        
    constant cvA32_U_BLT  : integer := 16#0B#;  -- A32 non-privileged block transfer           
    constant cvA32_U_PGM  : integer := 16#0A#;  -- A32 non-privileged program access           
    constant cvA32_U_DATA : integer := 16#09#;  -- A32 non-privileged data access              
    constant cvA32_U_MBLT : integer := 16#08#;  -- A32 non-privileged 64-bit block transfer     
    constant cvCR_CSR     : integer := 16#2F#;  -- CR/CSR space                                
    
    -- VME cycles data width
    constant cvD8         : integer := 1;  --  8 bit
    constant cvD16        : integer := 2;  -- 16 bit
    constant cvD32        : integer := 4;  -- 32 bit
    constant cvD64        : integer := 8;  -- 64 bit

    constant BYTESWAP     : std_logic := '0';    
    constant STAT_DTACK   : integer   := 4;
    constant STAT_BERR    : integer   := 5;
	
	signal count_500us:		integer range 0 to 62500;
	signal wait_for_500us:	std_logic := '0';
    
    ---------------------------------------------------------------------------------------------------
    -- malloc Buffers 
    ---------------------------------------------------------------------------------------------------
    constant MAX_OPT_SIZE  : integer := 258;       	-- un pacchetto ottico è costituito da 258 parole a 16 bit (129 parole a 32 bit)
    constant MAX_BLT_SIZE  : integer := 65535;		--(2048*1024); (60*1024);  dimensione max del pacchetto BLT in byte pari alla size di un PBLT (60Kbyte = 61440byte)
    
    -- outbuf (16 bit): dimensione max pari a quella di un pacchetto ottico 
    constant OUTBUF_SIZE : integer := MAX_OPT_SIZE;
    type  outbuf_type   is array (0 to OUTBUF_SIZE-1) of uint16_t;  
  
    -- inbuf(16 bit): dimensione max pari a quella di un PBLT
    constant INBUF_SIZE : integer := MAX_BLT_SIZE/2;
    type  inbuf_type   is array (0 to INBUF_SIZE) of uint16_t;  -- inclusa la parola di stato
  
    -- DMA buffer (32 bit)
    constant DMABUF_SIZE : integer := MAX_BLT_SIZE/4;
    type  dmabuf_type  is array (0 to DMABUF_SIZE-1) of uint32_t;  
  
    ---------------------------------------------------------------------------------------------------
    -- Optical Level 
    ---------------------------------------------------------------------------------------------------
    signal tx_data    : std_logic_vector(7 downto 0);
    signal tx_charisk : std_logic;
    signal rx_data    : std_logic_vector(7 downto 0);
    signal rx_charisk : std_logic;
    
    signal tx10b      : std_logic_vector(9 downto 0);
    signal rx10b      : std_logic_vector(9 downto 0);

    ---------------------------------------------------------------------------------------------------
    -- OUTPUT FILES
    file CLOG   : TEXT open WRITE_MODE is "conet_master.log";
    file LLOG   : TEXT open WRITE_MODE is "conet_link.log";

---------------------------------------------------------------------------------------------------
begin -- architecture
---------------------------------------------------------------------------------------------------
    
    -- TX clock
    P_tclk125_proc: process
    begin
        loop
            tclk125 <= '0', '1' after 4 ns;
            wait for 8 ns;
        end loop;
        wait;
    end process P_tclk125_proc;

    I_SERDES: SERDES
    port map
    (
        OPTRX           => OPTRX,
        OPTTX           => OPTTX,
        RCLK            => rclk125,  -- recovery clock
        RX              => rx10b,
        BSYNC           => open,
        TCLK            => tclk125,
        TX              => tx10b
    );    
    
    I_ENC8B10B: ENC8B10B 
	port map
	(
		CLK_IN          => tclk125,
		RUNDP_RESET_IN  => '0',
		CTRL_IN         => tx_charisk,
		DATA_IN         => tx_data,
		RUNDP_OUT       => open,
		ENCODE_OUT      => tx10b
	);
    
    I_DEC8B10B: DEC8B10B
	port map
	(
		CLK_IN          => rclk125,  
		ENCODE_IN       => rx10b,
		CTRL_OUT        => rx_charisk,
		DATA_OUT        => rx_data
	);
    
    OPTRX   <= OPTRX_p;
    OPTTX_p <=     OPTTX;
    OPTTX_n <= not OPTTX;
    
    ---------------------------------------------------------------------------------------------------
    -- processo per gli stimoli
    process  
    
        variable address  : uint32_t;
        variable data     : uint32_t;
        variable mem_buff : dmabuf_type;
        
        variable nwr      : integer;
        variable sn       : integer;
    
        variable nb          : integer;
        variable event_size  : integer;
    
        variable outline : line;
		variable rcv_irq   : std_logic :='0';
        
        variable CTRL2_reg:           std_logic_vector(15 downto 0);
        variable CTRL2_reg_MANDRAKE:      std_logic; 
        variable CTRL2_reg_MANDRAKE_GO:   std_logic; 
        variable CTRL2_reg_TRMWAIT_4:     std_logic; 
        variable CTRL2_reg_TRMWAIT_5:     std_logic; 
        variable CTRL2_reg_TRMWAIT_6:     std_logic;
        variable CTRL2_reg_SET_PREPULSE:  std_logic; 
        variable CTRL2_reg_SETRDMODE:     std_logic; 
        variable CTRL2_reg_DISABLE_RO:    std_logic; 
        variable CTRL2_reg_SR_IRQEN:      std_logic;
		variable CTRL2_reg_TRIG_IGNORE:	  std_logic;
        
    variable CTRL_reg:            std_logic_vector(15 downto 0);
        variable CTRL_reg_SYSRES:         std_logic; 
        variable CTRL_reg_CPDM_FCLK:      std_logic; 
        variable CTRL_reg_TEST_EVENT:     std_logic; 
        variable CTRL_reg_PROG:           std_logic;
        variable CTRL_reg_PULSE_POLARITY: std_logic; 
        variable CTRL_reg_SPDO:           std_logic; 
        variable CTRL_reg_IO_TEST:        std_logic; 
        variable CTRL_reg_SR_TEST:        std_logic;
        --variable CTRL_reg_TOF_TRIGGER:    std_logic; 
        variable CTRL_reg_RDH_VERSION:    std_logic;
    
        
        -- ###############################################################################
        -- Optical level:
        -- Funzioni che gestiscono il passaggio del payload dei pacchetti ottici 
        -- ###############################################################################        
        ---------------------------------------------------------------------------
        -- SEND PACKET
        procedure Conet_SendPkt(link  :  in  integer;
                        dest        :  in  integer;
                        outbuffer   :  in  outbuf_type;
                        nword       :  in  integer) is
        variable i,header   : integer;
        variable d32 : std_logic_vector(31 downto 0) := (others => '0');
        variable MEM : std_logic_vector(31 downto 0);
        variable outline : LINE;
    
        begin
    
            write_string(outline,"SENDING DATA PAYLOAD: ");
            writeline(CLOG, outline); 
    
            -- START
            wait until tclk125'event and tclk125='1';
            tx_data           <= L_START; 
            tx_charisk        <= '1';
    
            wait until tclk125'event and tclk125='1';
            -- HEADER
            tx_data           <= (others => '0'); 
            tx_charisk        <= '0';
            wait until tclk125'event and tclk125='1';
            -- HEADER
            tx_data           <= (others => '0'); 
            tx_charisk        <= '0';
            
            for i in 0 to (nword - 1) loop -- numero di data payload a 16 bit da spedire
                write_num(outline,i, field => 2, base => decimal);
                write_string(outline, "   0x");
                write_num(outline,outbuffer(i), field => 4, base => hex);
                writeline(CLOG, outline); 
                
                -- parte bassa dal dato
                wait until tclk125'event and tclk125='1';
                tx_charisk <= '0';
                tx_data    <= outbuffer(i)( 7 downto 0); 
                -- parte alta dal dato
                wait until tclk125'event and tclk125='1';
                tx_charisk <= '0';
                tx_data    <= outbuffer(i)(15 downto 8);             
            end loop;
    
            -- STOP
            wait until tclk125'event and tclk125='1';
            tx_data           <= L_STOP; 
            tx_charisk        <= '1';
            -- NULL
            wait until tclk125'event and tclk125='1';
            tx_data           <= L_NULL; 
            tx_charisk        <= '1';
            
            write_string(outline," Nword =");
            write_num(outline,nword, field => 2, base => decimal);
            writeline(CLOG, outline); 
            
        end;
    
        ---------------------------------------------------------------------------
        -- RECEIVE PACKET
        procedure Conet_RcvPkt(link      : in     integer;
                            sender    : inout  integer;
                            inbuffer  : inout  inbuf_type;
                            nword     : inout  integer;  -- comprende lo status
                            status    : inout uint16_t) is
            variable rcv_start      : std_logic:='0';
            variable rcv_stop       : std_logic:='0';
            variable data           : uint16_t;
            variable outline        : LINE;
            variable i              : integer;
			variable altern			: std_logic:='0';
            
        begin
            --wait for 400 ns;
			--wait for 2000 ns; -- DAV
			--wait for 10000 ns; -- DAV
			--wait for 50000 ns; -- DAV
            -- HACK: ci dovrei mettere un loop di TOKEN in attesa di uno start
    
			-- TOKEN
			-- wait until rclk125'event and rclk125='1';
			-- tx_data           <= L_TOKEN; 
			-- tx_charisk        <= '1';
			-- NULL
			-- wait until rclk125'event and rclk125='1';
			-- tx_data           <= L_NULL; 
			-- tx_charisk        <= '1';
        
            i :=0; altern := '0';
    
            write_string(outline,"RECEIVED DATA PAYLOAD ");
            writeline(CLOG, outline); 
    
            while(rcv_start = '0') loop
                -- aspetto lo start
                wait until rclk125'event and rclk125='1';
					if(altern = '0') then
						tx_data           <= L_TOKEN;
						tx_charisk        <= '1';
					else
						tx_data           <= L_NULL; 
						tx_charisk        <= '1';
					end if;
					altern := not altern;
					if(rx_data = L_START and rx_charisk = '1') then
						rcv_start := '1';
						write_string(outline,"RECEIVED START ");
						writeline(CLOG, outline); 
					end if;
            end loop;
    
            while rcv_stop = '0' loop
                wait until rclk125'event and rclk125='1';     
                if (rx_data = L_STOP or rx_data = L_EOT) and rx_charisk = '1' then
                    rcv_stop := '1';
                    write_string(outline,"RECEIVED STOP ");
                    writeline(CLOG, outline); 
                else
                    -- parte bassa dato
                    data( 7 downto 0) := rx_data;
                    -- parte alta dal dato
                    wait until rclk125'event and rclk125='1';
                    data(15 downto 8) := rx_data;
    
                    write_num(outline,i, field => 2, base => decimal);
                    write_string(outline, "   0x");
                    write_num(outline,data, field => 4, base => hex);
                    writeline(CLOG, outline); 
                    if i>=1 then  -- butto via la header (come farebbe il master CONET)
                        inbuffer(i-1) := data;
                    end if;
                    i := i + 1;
                end if;
            end loop;        
                
            nword := i;
            status := data;
            write_string(outline," Nword =");
            write_num(outline,nword, field => 2, base => decimal);
            write_string(outline," status =");
            write_num(outline,status, field => 4, base => hex);
    
            writeline(CLOG, outline);         
        end;
        
        
        -- ************************************************************************
        -- Funzioni per l'accesso ai registri interni al V2718
        -- ************************************************************************
        ---------------------------------------------------------------------------
        -- READ REG: solo per debug
        procedure CAENVMEReadREG( link      : in    integer;
                                node      : in    integer;
                                address   : in    uint32_t;
                                data      : inout uint32_t) is
                                
            variable outbuf         : outbuf_type;
            variable inbuf          : inbuf_type;
            variable opcode, stat   : uint16_t;
            variable outline        : line;
        
        begin         
    
            opcode := X"4081";  -- ignoro l'input address: accesso a VMECTRL del V2718, come nella CAENVME_Init
            outbuf(0) := opcode;
            
            -- CAENVMEComm
            Conet_SendPkt(link,node,outbuf,1);
            Conet_RcvPkt(link,sn,inbuf,nwr,stat);
            data := X"0000" & inbuf(0);
        
            wait for 10 ns;
            write_string(outline, "  CAENVMEReadREG at address 0x");
            write_num(outline, address, field => 2, base => hex);
            write_string(outline, "  data=0x");
            write_num(outline, data, field => 4, base => hex);
            writeline(LLOG, outline);
            wait for 200 ns;
        end;
        
        -- ************************************************************************
        -- Funzioni per l'accesso VME
        -- ************************************************************************
        procedure CAENVME_WriteCycle(
            link      : in    integer;
            node      : in    integer;                               
            address   : in    uint32_t;
            data      : in    uint32_t;
            am        : in    integer;
            dsize     : in    integer) is
    
            variable outbuf       : outbuf_type;
            variable inbuf        : inbuf_type;
            variable opcode, stat : uint16_t;
            variable count        : integer := 0;
            variable DW           : std_logic_vector(1 downto 0) := "00";
            variable outline      : line;
            
        begin
            if dsize = cvD32 then 
                DW := "10";  -- data size da mettere nell'opcode (v. caenlinkpkg) (write in D32 o D16)
            else
                DW := "01";
            end if;
            
            -- build and write the opcode
            -- outbuf(0) = OPCODE: 
            -- OPCODE[3:0] : codifica il tipo di ciclo (v. caenlinkpkg)
            -- OPCODE[5:4] : data size
            -- OPCODE[6]   : byte Swap                                     
            -- OPCODE[7]   : last command
            -- OPCODE[13:8]: AM, nel caso la read sia sul VME
            -- OPCODE[14]  : read/write
            opcode := "10" & conv_std_logic_vector(am,6) & '1' & BYTESWAP & DW & SINGLERW; -- HACK: Byte-swapping non gestito
            outbuf(count) := opcode;                count := count + 1;
            -- write the address
            outbuf(count) := address(15 downto 0);  count := count + 1;
            outbuf(count) := address(31 downto 16); count := count + 1;
            -- write the data
            if dsize = cvD32 then
                outbuf(count) := data(15 downto 0); count := count + 1;
                outbuf(count) := data(31 downto 16);count := count + 1; 
            else  -- D16 
                outbuf(count) := data(15 downto 0); count := count + 1;
            end if;
    
            -- CAENVMEComm
            Conet_SendPkt(link,node,outbuf,count); 
            Conet_RcvPkt(link,sn,inbuf,nwr,stat);
    
            -- OUTPUT FILE
            write_string(outline, "  CAENVME_WriteCycle at address 0x");
            write_num(outline, address, field => 8, base => hex);
            write_string(outline, " AM=0x");
            write_num(outline, am, field => 2, base => hex);
            write_string(outline, "   Data=0x");
            write_num(outline, data, field => 8, base => hex);
            if stat(STAT_DTACK) = '1' then
                write_string(outline, "   RES=DTACK");
            else
                write_string(outline, "   RES=BERR ");
            end if;
            write_string(outline, "   (status=0x");
            write_num(outline, stat, field => 2, base => hex);
            write_string(outline, ")");        
            writeline(LLOG, outline);    
        end;
    
    
        -- ************************************************************************
        procedure CAENVME_ReadCycle(
            link      : in    integer;
            node      : in    integer;                               
            address   : in    uint32_t;
            data      : inout uint32_t;
            am        : in    integer;
            dsize     : in    integer) is
    
            variable outbuf       : outbuf_type;
            variable inbuf        : inbuf_type;
            variable opcode, stat : uint16_t;
            variable count        : integer := 0;
            variable DW           : std_logic_vector(1 downto 0) := "00";
            variable outline      : line;
            
        begin
        
            -- Preparo il rcv packet
            for I in 0 to MAX_OPT_SIZE-1 loop
                inbuf(I) := (others =>'0');
            end loop;
    
            if dsize = cvD32 then
                DW := "10";  -- data size da mettere nell'opcode (v. caenlinkpkg) (read in D32 o D16)
            else
                DW := "01";
            end if;
            
            -- build and write the opcode
            -- outbuf(0) = OPCODE: 
            -- OPCODE[3:0] : codifica il tipo di ciclo (v. caenlinkpkg)
            -- OPCODE[5:4] : data size
            -- OPCODE[6]   : byte Swap
            -- OPCODE[7]   : last command
            -- OPCODE[13:8]: AM, nel caso la read sia sul VME
            -- OPCODE[14]  : read/write
            opcode := "11" & conv_std_logic_vector(am,6) & '1' & BYTESWAP & DW & SINGLERW; -- HACK: Byte-swapping non gestito
            outbuf(count) := opcode;                count := count + 1;
            -- write the address
            outbuf(count) := address(15 downto 0);  count := count + 1;
            outbuf(count) := address(31 downto 16); count := count + 1;
    
            -- CAENVMEComm
            Conet_SendPkt(link,node,outbuf,count);        
            Conet_RcvPkt(link,sn,inbuf,nwr,stat);
            
            -- DISPATCH DATA
            if dsize = cvD32 then
                data(15 downto 0)  := inbuf(0);
                data(31 downto 16) := inbuf(1);
            else  -- D16/D08
                data(15 downto 0)  := inbuf(0);
                data(31 downto 16) := (others => '0');
            end if;
            wait for 10 ns;
            
            -- OUTPUT FILE
            write_string(outline, "  CAENVME_ReadCycle at address 0x");
            write_num(outline, address, field => 8, base => hex);
            write_string(outline, " AM=0x");
            write_num(outline, am, field => 2, base => hex);
            write_string(outline, "   Data=0x");
            write_num(outline, data, field => 8, base => hex);
        
            if stat(STAT_DTACK) = '1' then
                write_string(outline, "   RES=DTACK");
            else
                write_string(outline, "   RES=BERR ");
            end if;
            write_string(outline, "   (status=0x");
            write_num(outline, stat, field => 2, base => hex);
            write_string(outline, ")");
            
            writeline(LLOG, outline);    
        end;
            
        -- ************************************************************************                       
        procedure CAENVME_BLTReadCycle(    
            link      : in    integer;
            node      : in    integer;                               
            address   : in    uint32_t;
            data      : inout dmabuf_type;
            size      : in    integer;
            am        : in    integer;
            dsize     : in    integer;
            nbyte     : inout integer) is
        
            variable outbuf       : outbuf_type;
            variable inbuf        : inbuf_type;
            variable opcode, stat : uint16_t;
            variable count        : integer := 0;
            variable DW           : std_logic_vector(1 downto 0) := "00";
            variable np,i         : integer;        
    
            variable DT           : uint32_t;
            variable outline      : line;
                                            
        begin    
    
            if dsize = cvD64 then
                DW := "11";   -- data size da mettere nell'opcode (v. caenlinkpkg) (read in D32 o D64)
            elsif dsize = cvD32 then
                DW := "10";
            else
                DW := "01";   -- non si fa il D8
            end if;
        
            -- Calcolo il numero di richieste che devo fare
            np := size / MAX_BLT_SIZE;
            if ( (np * MAX_BLT_SIZE) /= size ) then 
                np := np + 1; 
            end if;
    
            for i in 0 to np-1 loop 
                -- gestione esplicita dell'end packet 
                if( i = np - 1 ) then
                    -- build and write the opcode (HACK: Byte-swapping e fifo mode non gestiti)
                    opcode   := "11" & conv_std_logic_vector(am,6) & '1' & BYTESWAP & DW & BLT;
                    outbuf(count)   := opcode; count:= count + 1;
                    -- write the number of data cycles = BLT size in byte / data width
                    outbuf(count)   := conv_std_logic_vector(((size - ((np - 1)*MAX_BLT_SIZE)) / dsize),16); 
                    write_string(outline, "   (size8bit=0x");
                    write_num(outline, size , field => 8, base => hex);
                    write_string(outline, "   (size32bit=0x");
                    write_num(outline, outbuf(count) , field => 8, base => hex);
                    writeline(LLOG, outline);
                    
                    count:= count + 1;
                else
                    -- build and write the opcode (HACK: Byte-swapping e fifo mode non gestiti)
                    opcode   := "11" & conv_std_logic_vector(am,6) & '0' & BYTESWAP & DW & PBLT;
                    outbuf(count)   := opcode; count:= count + 1;
                    -- write the number of data cycles = BLT size in byte / data width
                    outbuf(count)   := conv_std_logic_vector((MAX_BLT_SIZE / dsize),16); count:= count + 1;
                end if;
                -- write the address
                -- HACK: incrementare l'indirizzo se non in fifo mode
                outbuf(count) := address(15 downto 0);  count:= count + 1;
                outbuf(count) := address(31 downto 16); count:= count + 1;               
            end loop;
    
            -- CAENVMEComm
            Conet_SendPkt(link,node,outbuf,count); 
            Conet_RcvPkt(link,sn,inbuf,nwr,stat);
            nbyte := (nwr-1)*2; -- escluso lo status
            -- DISPATCH DATA
            if dsize = cvD64 then
				for i in 0 to ((nwr-1)/2)-1 loop 
                    data(i)(15 downto 0)  := inbuf(i*2);
                    data(i)(31 downto 16) := inbuf(i*2+1);
                end loop;
				
            elsif dsize = cvD32 then
                for i in 0 to ((nwr-1)/2)-1 loop 
                    data(i)(15 downto 0)  := inbuf(i*2);
                    data(i)(31 downto 16) := inbuf(i*2+1);
                end loop;
            else
            -- ...                
            end if;
            wait for 10 ns;
            
            
            -- OUTPUT FILE
            write_string(outline, "  CAENVME_BLTReadCycle at address 0x");
            write_num(outline, address, field => 8, base => hex);
            write_string(outline, " AM=0x");
            write_num(outline, am, field => 2, base => hex);
            write_string(outline, "    Size(bytes)=");
            write_num(outline, nbyte, base => decimal);    
        
            if stat(STAT_DTACK)='1' and stat(STAT_BERR)='0' then
                write_string(outline, " RES=DTACK");
            elsif stat(STAT_DTACK)='0' and stat(STAT_BERR)='1' then
                write_string(outline, " RES=BERR ");
            elsif stat(STAT_DTACK)='1' and stat(STAT_BERR)='1' then
                write_string(outline, " RES=DTACK/BERR ");
            end if;
            
            write_string(outline, "   (status=0x");
            write_num(outline, stat, field => 2, base => hex);
            write_string(outline, ")");
            
            writeline(LLOG, outline);   
    
            for i in 0 to ((nwr-1)/2)-1 loop 
                write_num(outline, data(i), field => 8, base => hex);
                writeline(LLOG, outline);
            end loop;
            
        
        end;
                                                            
    
    
    -- **************************************************************************
    -- Stimoli
    -- **************************************************************************    
    begin
        -- initialization
                  
		count_token		  <= 0;
		
        tx_data           <= L_COMMA; 
        tx_charisk        <= '1';  
        wait for 600 us;
		
        tx_data           <= L_NULL; 
        tx_charisk        <= '1';    
        wait for 50 us;   

		CAENVME_ReadCycle(0, 0, x"1000" & A_DEBUG, data, 0, cvD32); 		-- read DEBUG register value
        wait for  4 us; 
		CAENVME_ReadCycle(0, 0, x"1000" & A_CLOCKSEL, data, 0, cvD32); 		-- read CLOCKSEL register value
        wait for  4 us;
		CAENVME_ReadCycle(0, 0, x"1000" & A_I2CSEL, data, 0, cvD32); 		-- read I2C_SEL register value
        wait for  4 us; 
		CAENVME_ReadCycle(0, 0, x"1000" & A_VERSIONP1, data, 0, cvD32); 	-- read VERSIONP1 register value
        wait for  4 us;
		CAENVME_ReadCycle(0, 0, x"1000" & A_VERSIONP2, data, 0, cvD32); 	-- read VERSIONP2 register value
        wait for  4 us;
		CAENVME_WriteCycle(0, 0, x"1000" & A_GBTX_RSTB, x"00000000", 0, cvD32); 	-- puts GBTX_RSTB=1 (not active), otherwise it takes very long ...
        wait for  4 us;
		CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_STAT, data, 0, cvD32); 	-- read GBTx control register status
        wait for  4 us;
		
		-- writing GBTx registers
		-- -----------------------------------------------------------------------
        -- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RADL, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RADH, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RNML, x"00000002", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RNMH, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000AB", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000CD", 0, cvD32); 
        -- wait for  4 us;
		--CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000EF", 0, cvD32); 
        --wait for  4 us;
		
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_STAT, x"00000077", 0, cvD32); 	-- ASCII "w"
        -- wait for  4 us;
		-----------------------------------------------------------------------
		
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_STAT, data, 0, cvD32); 	-- read GBTx control register status
        -- wait for  4 us;
		-- while (data /= 101) loop	-- x"65" = ASCII "e" 
			-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_STAT, data, 0, cvD32); 
			-- wait for  4 us;
		-- end loop;
			
		-- reading GBTx registers
		-- -----------------------------------------------------------------------
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RADL, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RADH, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RNML, x"00000002", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RNMH, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_STAT, x"00000072", 0, cvD32); 	-- ASCII "r"
        -- wait for  4 us;
		
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_STAT, data, 0, cvD32); 	-- read GBTx control register status
        -- wait for  4 us;
		-- while (data /= 113) loop	-- x"71" = ASCII "q" 
			-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_STAT, data, 0, cvD32); 
			-- wait for  4 us;
		-- end loop;
		
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_DATA, data, 0, cvD32); 	
        -- wait for  4 us;
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_DATA, data, 0, cvD32); 	
        -- wait for  4 us;
		--CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_DATA, data, 0, cvD32); 	
        --wait for  4 us;
		-- -----------------------------------------------------------------------
		
		
		-- lettura TEMPGBT register
        CAENVME_ReadCycle(0, 0, x"1000" & A_TEMPGBT, data, 0, cvD32); 		-- reading A_TEMPGBT 
        wait for  1 us;
		-- lettura TEMPLDOGBT register
        CAENVME_ReadCycle(0, 0, x"1000" & A_TEMPLDOGBT, data, 0, cvD32); 	-- reading A_TEMPLDOGBT 
        wait for  1 us;
		-- lettura TEMPLDOSDES register
        CAENVME_ReadCycle(0, 0, x"1000" & A_TEMPLDOSDES, data, 0, cvD32);	-- reading A_TEMPLDOSDES 
        wait for  1 us; 
		
		----------------- activating P2 signals begin ----------------- 
		-- scrittura TS_MASK register
        -- CAENVME_WriteCycle(0, 0, x"1000" & A_TS_MASK, x"000003FF", 0, cvD32); 
        -- wait for  1 us;
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_TS_MASK, data, 0, cvD32); 
		-- wait for  1 us;
		-- -- scrittura SHOT register
        -- CAENVME_WriteCycle(0, 0, x"1000" & A_SHOT, x"00000001", 0, cvD32); 
        -- wait for  1 us;
		-- -- scrittura T_DELAY register
        -- CAENVME_WriteCycle(0, 0, x"1000" & A_TDELAY, x"000001FF", 0, cvD16); 
        -- wait for  1 us;
		-- -- scrittura CTRL_S register
        -- CAENVME_WriteCycle(0, 0, x"1000" & A_CTRL_S, x"00001A04", 0, cvD32); 
        -- wait for  1 us;
		-- -- scrittura CTRL2 register
        -- CAENVME_WriteCycle(0, 0, x"1000" & A_CTRL2, x"00000080", 0, cvD32); 		-- setting PREPULSE = 1 (CTRL2_SET_PREPULSE = 1)
        -- wait for  1 us;
		----------------- activating P2 signals end ----------------- 
		
		----------------- activating P2 signals begin ----------------- 
		-- scrittura TS_MASK register
        CAENVME_WriteCycle(0, 0, x"1000" & A_TS_MASK, x"00000100", 0, cvD32); 
        wait for  1 us;
		-- -- scrittura SHOT register
        CAENVME_WriteCycle(0, 0, x"1000" & A_SHOT, x"00000001", 0, cvD32); 
        wait for  1 us;
		-- scrittura TS_MASK register
        CAENVME_WriteCycle(0, 0, x"1000" & A_TS_MASK, x"00000000", 0, cvD32); 
        wait for  1 us;

		----------------- activating P2 signals end ----------------- 
		
		-- scrittura ROBLT32 register
        CAENVME_WriteCycle(0, 0, x"1000" & A_ROBLT32, x"00000000", 0, cvD32); 		-- setting A_ROBLT32 (0:MBLT, 1:BLT32) 11 bits      -- was 0
        wait for  1 us;
		
		-- scrittura RO2ESST register
        CAENVME_WriteCycle(0, 0, x"1000" & A_RO2ESST, x"000007FE", 0, cvD32); 		-- setting A_RO2ESST (0:MBLT, 1:2eSST) 11 bits		-- was 7FE
        wait for  1 us;
		
		-- scrittura RO_ENABLE register
            --CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000002", 0, cvD32); 	-- setting RO_ENABLE_2   (slot 3)
            --CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000004", 0, cvD32); 	-- setting RO_ENABLE_3   (slot 4)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000008", 0, cvD32); 	-- setting RO_ENABLE_4   (slot 5)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000010", 0, cvD32); 	-- setting RO_ENABLE_5   (slot 6)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000020", 0, cvD32); 	-- setting RO_ENABLE_6   (slot 7)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000040", 0, cvD32); 	-- setting RO_ENABLE_7   (slot 8)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000060", 0, cvD32); 	-- setting RO_ENABLE_6_7   (slot 7+8)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"000001E0", 0, cvD32); 	-- setting RO_ENABLE_6_7_8_9   (slot 7+8+9+10)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000200", 0, cvD32); 	-- setting RO_ENABLE_10   (slot 11)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000220", 0, cvD32); 	-- setting RO_ENABLE_6_10   (slot 7+11)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000038", 0, cvD32); 	-- setting RO_ENABLE_456 (slot 5+6+7)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"000003FC", 0, cvD32); 	-- setting RO_ENABLE_3_4_5_6_7_8_9_10   (slot 4+5+6+7+8+9+10+11)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"000003FE", 0, cvD32); 	-- setting RO_ENABLE_2_3_4_5_6_7_8_9_10   (slot 3+4+5+6+7+8+9+10+11)   USED !!!!
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"000003FF", 0, cvD32); 	-- setting RO_ENABLE_1_2_3_4_5_6_7_8_9_10   (slot 2+3+4+5+6+7+8+9+10+11)
			CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"000007FF", 0, cvD32); 	-- setting RO_ENABLE_1_2_3_4_5_6_7_8_9_10_11   (slot 2+3+4+5+6+7+8+9+10+11+12)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"000007FE", 0, cvD32); 	-- setting RO_ENABLE_1_2_3_4_5_6_7_8_9_10_11   (slot 3+4+5+6+7+8+9+10+11+12)
			--CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000003", 0, cvD32); 	-- setting RO_ENABLE_1_2  (slot 2+3)
            --CAENVME_WriteCycle(0, 0, x"1000" & A_RO_ENABLE, x"00000400", 0, cvD32); 	-- setting RO_ENABLE_11   (slot 12)
        wait for  1 us;
    
		----------------- VME accesses begin-----------------
		
		-- lettura registro 0x0012 (A_FIRM_REV) dalla TRM nello slot 7 via VME
        CAENVME_ReadCycle(0, 0, x"70000012", data, 9, cvD16); 
		wait for  4 us;
		
		wait for  600 us;
		-----------------------------------------
		-- Setting per l'acquisizione LTM slot 2
        
            --vme_read(BASE_ADD+A_FIRM_REV)			
			CAENVME_ReadCycle(0, 0, x"20000012", data, 0, cvD16);   
			wait for  4 us;
            
            --vme_write(BASE_ADD+A_DUMMY32,A32,D32,16#0000#); -- dummy register write
			CAENVME_WriteCycle(0, 0, x"20000028", x"1234abcd", 0, cvD32); 
			wait for 4 us;
            
            --vme_read(BASE_ADD+A_FIRM_REV)			
			CAENVME_ReadCycle(0, 0, x"20000012", data, 0, cvD16);   
			wait for  4 us;
            
            --vme_read(BASE_ADD+A_DUMMY32,A32,D32); -- dummy register read
            CAENVME_ReadCycle(0, 0, x"20000028", data, 0, cvD32);   
			wait for  4 us;
            
            --vme_read(BASE_ADD+A_BNCRESN,A32,D32); -- bcnresn read
            CAENVME_ReadCycle(0, 0, x"2000005C", data, 0, cvD32);   
			wait for  4 us;
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"2000000C", x"00000000", 0, cvD16); 
			wait for 4 us;
            
            --vme_read(BASE_ADD+A_BNCRESN,A32,D32); -- bcnresn write
            CAENVME_WriteCycle(0, 0, x"2000005C", x"0000001F", 0, cvD32);   
			wait for  4 us;
			
			------------------------------------------------------------------------------------------------------------------------------------------
			-- vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			-- CAENVME_WriteCycle(0, 0, x"20000026", x"00000001", 0, cvD16); 
			-- wait for 4 us;
			
			-- vme_write(SOFTWARE_TRIGGER)	------------------------------------------------------------------------------------------------------		
			-- CAENVME_WriteCycle(0, 0, x"2000000E", x"00000001", 0, cvD16); 
			-- wait for 16 ms;

			-- CAENVME_ReadCycle(0, 0, x"20000036", data, 0, cvD32);   -- TEMPA read
			-- wait for  4 us;
			-- CAENVME_ReadCycle(0, 0, x"20000038", data, 0, cvD32);   -- TEMPB read
			-- wait for  4 us;
			------------------------------------------------------------------------------------------------------------------------------------------

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"20000026", x"00000001", 0, cvD16); 
			wait for 4 us;
			
			--vme_write(SOFTWARE_TRIGGER)			
			CAENVME_WriteCycle(0, 0, x"2000000E", x"00000001", 0, cvD16); 
			wait for 1 ms;
			
			--vme_read(EVENTS_STORED)			
			CAENVME_ReadCycle(0, 0, x"20000010", data, 0, cvD16);   
			wait for 4 us;
			
			--BLT64
			--CAENVME_BLTReadCycle(0, 0, X"20000000", mem_buff, MAX_BLT_SIZE, cvA32_U_BLT, cvD64, nb); 
			--wait for 10 us;
			--BLT32
			CAENVME_BLTReadCycle(0, 0, X"20000000", mem_buff, 100, cvA32_U_BLT, cvD32, nb); 
			wait for  10 us;
		
		-----------------------------------------
		-- Setting per l'acquisizione TRM slot 3
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"3000000C", x"00000000", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
			CAENVME_WriteCycle(0, 0, x"30000004", x"00000088", 0, cvD16); 		-- it was 0x8A
			wait for  4 us;

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"30000026", x"00000001", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(SOFTWARE_TRIGGER)			
			-- CAENVME_WriteCycle(0, 0, x"3000000E", x"00000001", 0, cvD16); 
			-- wait for  500 us;
			
			--BLT32
			-- CAENVME_BLTReadCycle(0, 0, X"30000000", mem_buff, MAX_BLT_SIZE, cvA32_U_BLT, cvD32, nb); 
			-- wait for  10 us;
			
		-----------------------------------------
		-- Setting per l'acquisizione TRM slot 4
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"4000000C", x"00000000", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
			CAENVME_WriteCycle(0, 0, x"40000004", x"00000088", 0, cvD16); 		-- it was 0x8A
			wait for  4 us;

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"40000026", x"00000001", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(SOFTWARE_TRIGGER)			
			-- CAENVME_WriteCycle(0, 0, x"4000000E", x"00000001", 0, cvD16); 
			-- wait for  4 us;
			
			--BLT32
			-- CAENVME_BLTReadCycle(0, 0, X"40000000", mem_buff, MAX_BLT_SIZE, cvA32_U_BLT, cvD32, nb); 
			-- wait for  10 us;

		-----------------------------------------
			
		-- Setting per l'acquisizione TRM slot 5
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"5000000C", x"00000000", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
			CAENVME_WriteCycle(0, 0, x"50000004", x"00000088", 0, cvD16); 		-- it was 0x8A
			wait for  4 us;

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"50000026", x"00000001", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(SOFTWARE_TRIGGER)			
			-- CAENVME_WriteCycle(0, 0, x"5000000E", x"00000001", 0, cvD16); 
			-- wait for  4 us;
			
			--BLT64
			-- CAENVME_BLTReadCycle(0, 0, X"50000000", mem_buff, MAX_BLT_SIZE, cvA32_U_MBLT, cvD64, nb); 
			-- wait for  10 us;
		-----------------------------------------
			
		-- Setting per l'acquisizione TRM slot 6
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"6000000C", x"00000000", 0, cvD16); 
			wait for 4 us;
			
			--vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
			CAENVME_WriteCycle(0, 0, x"60000004", x"00000088", 0, cvD16); 		-- it was 0x8A
			wait for 4 us;

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"60000026", x"00000001", 0, cvD16); 
			wait for 4 us;
			
			--vme_write(SOFTWARE_TRIGGER)			
			-- CAENVME_WriteCycle(0, 0, x"6000000E", x"00000001", 0, cvD16); 
			-- wait for  4 us;
		-----------------------------------------
			
		-- Setting per l'acquisizione TRM slot 7
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"7000000C", x"00000000", 0, cvD16); 
			wait for 4 us;
			
			--vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
			CAENVME_WriteCycle(0, 0, x"70000004", x"00000088", 0, cvD16); 		-- it was 0x8A
			wait for 4 us;

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"70000026", x"00000001", 0, cvD16); 
			wait for 4 us;
			
			--vme_write(SOFTWARE_TRIGGER)			
			-- CAENVME_WriteCycle(0, 0, x"7000000E", x"00000001", 0, cvD16); 
			-- wait for  100 us;
			
			--vme_read(EVENTS_STORED)			
			-- CAENVME_ReadCycle(0, 0, x"70000010", data, 0, cvD16);   
			-- wait for  4 us;
			
			-- BLT64
			--CAENVME_BLTReadCycle(0, 0, X"70000000", mem_buff, MAX_BLT_SIZE, cvA32_U_BLT, cvD64, nb); 
			-- BLT32
			-- CAENVME_BLTReadCycle(0, 0, X"70000000", mem_buff, MAX_BLT_SIZE, cvA32_U_BLT, cvD32, nb); 
			-- wait for  10 us;
			
		-----------------------------------------
		
		-- Setting per l'acquisizione TRM slot 8
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"8000000C", x"00000000", 0, cvD16); 
			wait for 4 us;
			
			--vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
			CAENVME_WriteCycle(0, 0, x"80000004", x"00000088", 0, cvD16); 	-- it was 0x8A
			wait for 4 us;

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"80000026", x"00000001", 0, cvD16); 
			wait for 4 us;
			
			--vme_write(SOFTWARE_TRIGGER)			
			-- CAENVME_WriteCycle(0, 0, x"8000000E", x"00000001", 0, cvD16); 
			-- wait for  4 us;
			
			--BLT64
			-- CAENVME_BLTReadCycle(0, 0, X"80000000", mem_buff, MAX_BLT_SIZE, cvA32_U_MBLT, cvD64, nb); 
			-- wait for  4 us;
		-----------------------------------------
		
		-- Setting per l'acquisizione TRM slot 9
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"9000000C", x"00000000", 0, cvD16); 
			wait for 4 us;
			
			--vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
			CAENVME_WriteCycle(0, 0, x"90000004", x"00000088", 0, cvD16); 	-- it was 0x8A
			wait for 4 us;

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"90000026", x"00000001", 0, cvD16); 
			wait for 4 us;
			
			--vme_write(SOFTWARE_TRIGGER)			
			-- CAENVME_WriteCycle(0, 0, x"9000000E", x"00000001", 0, cvD16); 
			-- wait for  4 us;
			
			--BLT64
			-- CAENVME_BLTReadCycle(0, 0, X"90000000", mem_buff, MAX_BLT_SIZE, cvA32_U_MBLT, cvD64, nb); 
			-- wait for  4 us;
		-----------------------------------------
		
		-- Setting per l'acquisizione TRM slot 10
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"A000000C", x"00000000", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
			CAENVME_WriteCycle(0, 0, x"A0000004", x"00000088", 0, cvD16); 	-- it was 0x8A
			wait for  4 us;

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"A0000026", x"00000001", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(SOFTWARE_TRIGGER)			
			-- CAENVME_WriteCycle(0, 0, x"A000000E", x"00000001", 0, cvD16); 
			-- wait for  4 us;
			
			--BLT64
			-- CAENVME_BLTReadCycle(0, 0, X"A0000000", mem_buff, MAX_BLT_SIZE, cvA32_U_MBLT, cvD64, nb); 
			-- wait for  4 us;
		-----------------------------------------
		
		-- Setting per l'acquisizione TRM slot 11
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"B000000C", x"00000000", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
			CAENVME_WriteCycle(0, 0, x"B0000004", x"00000088", 0, cvD16); 	-- it was 0x8A
			wait for  4 us;

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"B0000026", x"00000001", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(SOFTWARE_TRIGGER)			
			-- CAENVME_WriteCycle(0, 0, x"B000000E", x"00000001", 0, cvD16); 
			-- wait for  4 us;
			
			--BLT64
			-- CAENVME_BLTReadCycle(0, 0, X"B0000000", mem_buff, MAX_BLT_SIZE, cvA32_U_MBLT, cvD64, nb); 
			-- wait for  4 us;
		-----------------------------------------
		
		-- Setting per l'acquisizione TRM slot 12
		
			--vme_write(BASE_ADD+A_SW_CLEAR,A32,D16,16#0000#); -- Clear
			CAENVME_WriteCycle(0, 0, x"C000000C", x"00000000", 0, cvD16); 
			wait for  4 us;
			
			--vme_write(BASE_ADD+A_CONTROL,A32,D16,16#0088#);  -- Modo con L2, No Comp, No Sub, AIR en.
			CAENVME_WriteCycle(0, 0, x"C0000004", x"00000088", 0, cvD16); 	-- it was 0x8A
			wait for  4 us;

			--vme_write(BASE_ADD+A_ACQUISITION,A32,D16,1);
			CAENVME_WriteCycle(0, 0, x"C0000026", x"00000001", 0, cvD16); 
			wait for  4 us;	
			
		----------------- VME accesses end-----------------
		
		-- all the following accesses are on slot 1 (internal DRM2)
        -- lettura FW revision

		-- scrittura DEBUG register
        --CAENVME_WriteCycle(0, 0, x"1000" & A_DEBUG, x"01234567", 0, cvD32); 
        --wait for  10 us; 
		
		--CAENVME_WriteCycle(0, 0, x"50000028", x"00000001", 0, cvD32); 
		--wait for  10 us;	
		
		-- providing a soft_clear
        CAENVME_WriteCycle(0, 0, x"1000" & A_SHOT, x"00000002", 0, cvD32); 	-- soft_clear
        wait for  10 us;
		
		-- providing a soft_clear
        CAENVME_WriteCycle(0, 0, x"1000" & A_SHOT, x"00000002", 0, cvD32); 	-- soft_clear
        wait for  10 us;

		-- writing MAX_TRM_HIT_CNT register
        CAENVME_WriteCycle(0, 0, x"1000" & A_MAX_TRM_HIT_CNT, x"000007D0", 0, cvD32); 	-- max_trm_hit_cnt = a bit more than 1920=64x30 HPTDCs
        wait for  10 us; 		
        
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------
        CTRL_reg_SYSRES         := '0'; CTRL_reg_CPDM_FCLK      := '0'; CTRL_reg_TEST_EVENT     := '0'; CTRL_reg_PROG           := '0';
        CTRL_reg_PULSE_POLARITY := '0'; CTRL_reg_SPDO           := '0'; CTRL_reg_IO_TEST        := '0'; CTRL_reg_SR_TEST        := '0';
        CTRL_reg_RDH_VERSION    := '1'; -- RDH v5
        CTRL_reg    := CTRL_reg_RDH_VERSION & '0' & CTRL_reg_SR_TEST & CTRL_reg_IO_TEST & CTRL_reg_SPDO & '0' & CTRL_reg_PULSE_POLARITY & '0' & 
                       CTRL_reg_PROG & '0' & CTRL_reg_TEST_EVENT & "00" & CTRL_reg_CPDM_FCLK & '0' & CTRL_reg_SYSRES;
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------
		CAENVME_WriteCycle(0, 0, x"1000" & A_CTRL_S, x"0000" & CTRL_reg, 0, cvD32);	
        wait for 100 us;
        
        CAENVME_WriteCycle(0, 0, x"1000" & A_ORBIT_MANDRAKE, x"0000" & x"0000", 0, cvD32); 
        
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------
        CTRL2_reg_MANDRAKE      := '0'; CTRL2_reg_MANDRAKE_GO   := '0'; CTRL2_reg_TRMWAIT_4     := '1'; CTRL2_reg_TRMWAIT_5     := '1';     CTRL2_reg_TRMWAIT_6 := '1';
        CTRL2_reg_SET_PREPULSE  := '0'; CTRL2_reg_SETRDMODE     := '1'; CTRL2_reg_DISABLE_RO    := '0'; CTRL2_reg_SR_IRQEN      := '1';		CTRL2_reg_TRIG_IGNORE   := '0';
        CTRL2_reg   := "0000" & CTRL2_reg_TRIG_IGNORE & CTRL2_reg_SR_IRQEN & CTRL2_reg_DISABLE_RO & CTRL2_reg_SETRDMODE & CTRL2_reg_SET_PREPULSE & CTRL2_reg_TRMWAIT_6 & 
                       CTRL2_reg_TRMWAIT_5 & CTRL2_reg_TRMWAIT_4 & CTRL2_reg_MANDRAKE_GO & CTRL2_reg_MANDRAKE & "00";
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------
		CAENVME_WriteCycle(0, 0, x"1000" & A_CTRL2, x"0000" & CTRL2_reg, 0, cvD32); 	
        --wait for  10 us; 
		
        wait for 400 us;
		
		CAENVME_ReadCycle(0, 0, x"40000028", data, 0, cvD32); 				-- VME access to TRM #4 during readout
		wait for 40 us;
		CAENVME_ReadCycle(0, 0, x"1000" & A_TEMPGBT, data, 0, cvD32); 		-- reading A_TEMPGBT 
        wait for 1 us;
		CAENVME_ReadCycle(0, 0, x"50000028", data, 0, cvD32); 				-- VME access to TRM #5 during readout
		wait for 40 us;
		CAENVME_ReadCycle(0, 0, x"1000" & A_TEMPGBT, data, 0, cvD32); 		-- reading A_TEMPGBT 
        wait for 1 us;
		-- BLT64
		--CAENVME_BLTReadCycle(0, 0, X"10000000"  + A_OUTBUF, mem_buff, MAX_BLT_SIZE, cvA32_U_MBLT, cvD64, nb); 
		wait for 40 us;
		CAENVME_ReadCycle(0, 0, x"1000" & A_TEMPGBT, data, 0, cvD32); 		-- reading A_TEMPGBT 
        wait for 1 us;
		
        -- start / stop mandrake triggers
        -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- CTRL2_reg_MANDRAKE      <= '1'; CTRL2_reg_MANDRAKE_GO   <= '1'; CTRL2_reg_TRMWAIT_4     <= '1'; CTRL2_reg_TRMWAIT_5     <= '1';     CTRL2_reg_TRMWAIT_6 <= '1';
        -- CTRL2_reg_SET_PREPULSE  <= '0'; CTRL2_reg_SETRDMODE     <= '1'; CTRL2_reg_DISABLE_RO    <= '0'; CTRL2_reg_SR_IRQEN      <= '1';
        -- CTRL2_reg   <= "00000" & CTRL2_reg_SR_IRQEN & CTRL2_reg_DISABLE_RO & CTRL2_reg_SETRDMODE & CTRL2_reg_SET_PREPULSE & CTRL2_reg_TRMWAIT_6 & 
                       -- CTRL2_reg_TRMWAIT_5 & CTRL2_reg_TRMWAIT_4 & CTRL2_reg_MANDRAKE_GO & CTRL2_reg_MANDRAKE & "00";
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_CTRL2, x"0000" & CTRL2_reg, 0, cvD32);	-- CTRL_MANDRAKE = 1 and CTRL_MANDRAKE_GO = 1
		-- wait for 2 ms;
        -- CTRL2_reg_MANDRAKE      <= '1'; CTRL2_reg_MANDRAKE_GO   <= '0'; CTRL2_reg_TRMWAIT_4     <= '1'; CTRL2_reg_TRMWAIT_5     <= '1';     CTRL2_reg_TRMWAIT_6 <= '1';
        -- CTRL2_reg_SET_PREPULSE  <= '0'; CTRL2_reg_SETRDMODE     <= '1'; CTRL2_reg_DISABLE_RO    <= '0'; CTRL2_reg_SR_IRQEN      <= '1';
        -- CTRL2_reg   <= "00000" & CTRL2_reg_SR_IRQEN & CTRL2_reg_DISABLE_RO & CTRL2_reg_SETRDMODE & CTRL2_reg_SET_PREPULSE & CTRL2_reg_TRMWAIT_6 & 
                       -- CTRL2_reg_TRMWAIT_5 & CTRL2_reg_TRMWAIT_4 & CTRL2_reg_MANDRAKE_GO & CTRL2_reg_MANDRAKE & "00";
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_CTRL2, x"0000" & CTRL2_reg, 0, cvD32);	-- CTRL_MANDRAKE = 1 and CTRL_MANDRAKE_GO = 0
        -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		-- BLT64
		-- CAENVME_BLTReadCycle(0, 0, X"40000000", mem_buff, MAX_BLT_SIZE, cvA32_U_MBLT, cvD64, nb); 
		-- wait for  4 us;
				
		-- CONET readout -----------------
		while(true) loop
			wait until rclk125'event and rclk125='1';
				if(tb_ssram_interrupt = '1' and wait_for_500us = '0') then		-- I wait for the internal interrupt
					--CAENVME_ReadCycle(0, 0, x"1000" & A_STATUS, data, 0, cvD32); 	
					--if (data >= x"80000000") then
						CAENVME_BLTReadCycle(0, 0, X"10000000" + A_OUTBUF, mem_buff, MAX_BLT_SIZE, cvA32_U_BLT, cvD64, nb);
					--end if;
					wait_for_500us	<= '1';
				else
					if(count_500us = 62500) then
						count_500us		<= 0;
						wait_for_500us	<= '0';
					else
						count_500us		<= count_500us + 1;
						wait_for_500us	<= '1';
					end if;
				end if;
				if(count_token = 50) then
					tx_data         <= L_TOKEN; 
					tx_charisk      <= '1';
					count_token		<= 0;	
				else	
					tx_data         <= L_NULL; 
					tx_charisk      <= '1';
					count_token		<= count_token + 1;
				end if;
		end loop;
		-- CONET readout end -------------
		
		-- data <= 0;
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_STATUS, data, 0, cvD32); 	
		-- while ((data >> 15) = 1) loop	
			-- CAENVME_BLTReadCycle(0, 0, X"10001000", mem_buff, 1024, cvA32_U_BLT, cvD32, nb);
			-- wait for  10 us;
		-- end loop;
		
		-- BLT32
		-- CAENVME_BLTReadCycle(0, 0, X"10000000" + A_OUTBUF, mem_buff, 1024, cvA32_U_BLT, cvD32, nb); 	-- 1024 instead of MAX_BLT_SIZE
		-- wait for  20 us;
		-- BLT32
		-- CAENVME_BLTReadCycle(0, 0, X"10000000" + A_OUTBUF, mem_buff, 1024, cvA32_U_BLT, cvD32, nb); 	-- 1024 instead of MAX_BLT_SIZE
		-- wait for  20 us;
		-- BLT32
		-- CAENVME_BLTReadCycle(0, 0, X"10000000" + A_OUTBUF, mem_buff, 1024, cvA32_U_BLT, cvD32, nb); 	-- 1024 instead of MAX_BLT_SIZE
		-- wait for  20 us;
		-- BLT32
		-- CAENVME_BLTReadCycle(0, 0, X"10000000" + A_OUTBUF, mem_buff, 1024, cvA32_U_BLT, cvD32, nb); 	-- 1024 instead of MAX_BLT_SIZE
		-- wait for  20 us;
		-- BLT32
		-- CAENVME_BLTReadCycle(0, 0, X"10000000" + A_OUTBUF, mem_buff, 1024, cvA32_U_BLT, cvD32, nb); 	-- 1024 instead of MAX_BLT_SIZE
		-- wait for  20 us;
		-- BLT32
		-- CAENVME_BLTReadCycle(0, 0, X"10000000" + A_OUTBUF, mem_buff, 1024, cvA32_U_BLT, cvD32, nb); 	-- 1024 instead of MAX_BLT_SIZE
		-- wait for  20 us;
		-- BLT32
		-- CAENVME_BLTReadCycle(0, 0, X"10000000" + A_OUTBUF, mem_buff, 1024, cvA32_U_BLT, cvD32, nb); 	-- 1024 instead of MAX_BLT_SIZE
		-- wait for  20 us;
		-- BLT32
		-- CAENVME_BLTReadCycle(0, 0, X"10000000" + A_OUTBUF, mem_buff, 1024, cvA32_U_BLT, cvD32, nb); 	-- 1024 instead of MAX_BLT_SIZE
		-- wait for  20 us;
		
		-- BLT64
		-- CAENVME_BLTReadCycle(0, 0, X"10000000"  + A_OUTBUF, mem_buff, MAX_BLT_SIZE, cvA32_U_MBLT, cvD64, nb); 
		-- wait for  40 us;

		
		wait for  400 us;
		
		-- writing GBTx registers
		-- -----------------------------------------------------------------------
        -- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RADL, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RADH, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RNML, x"00000009", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RNMH, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000AB", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000CD", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000EF", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000AB", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000CD", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000EF", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000AB", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000CD", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_DATA, x"000000EF", 0, cvD32); 
        -- wait for  4 us;
		
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_STAT, x"00000077", 0, cvD32); 	-- ASCII "w"
        -- wait for  4 us;
		-----------------------------------------------------------------------
		
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_STAT, data, 0, cvD32); 	-- read GBTx control register status
        -- wait for  4 us;
		-- while (data /= 101) loop	-- x"65" = ASCII "e" 
			-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_STAT, data, 0, cvD32); 
			-- wait for  4 us;
		-- end loop;
			
		--reading GBTx registers
		-----------------------------------------------------------------------
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RADL, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RADH, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RNML, x"00000009", 0, cvD32); 
        -- wait for  4 us;
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_RNMH, x"00000000", 0, cvD32); 
        -- wait for  4 us;
		
		-- CAENVME_WriteCycle(0, 0, x"1000" & A_GI2C_STAT, x"00000072", 0, cvD32); 	-- ASCII "r"
        -- wait for  4 us;
		
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_STAT, data, 0, cvD32); 	-- read GBTx control register status
        -- wait for  4 us;
		-- while (data /= 113) loop	-- x"71" = ASCII "q" 
			-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_STAT, data, 0, cvD32); 
			-- wait for  4 us;
		-- end loop;
		
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_DATA, data, 0, cvD32); 	
        -- wait for  4 us;
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_GI2C_DATA, data, 0, cvD32); 	
        -- wait for  4 us;
		
		
         -- CAENVME_ReadCycle(0, 0, x"1000002E", data, 9, cvD16); 
		 -- wait for  20 us;
		 -- CAENVME_ReadCycle(0, 0, x"1000002E", data, 9, cvD16); 
		 -- wait for  20 us;
	
		-- lettura registro 0x0012 (A_FIRM_REV) dalla TRM nello slot 7 via VME
        --CAENVME_ReadCycle(0, 0, x"70000012", data, 9, cvD16); 
		wait for 2 us;
		
		--CAENVME_WriteCycle(0, 0, x"50000028", x"00000001", 0, cvD32); 
		wait for 20 us;
		
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_DEBUG, data, 0, cvD32); 		-- read DEBUG register value
        -- wait for  4 us; 
		
		-- CAENVME_ReadCycle(0, 0, x"1000" & A_DEBUG, data, 0, cvD32); 		-- read DEBUG register value
        -- wait for  4 us; 
		
		-- lettura registro 0x0012 (A_FIRM_REV) dalla TRM nello slot 7 via VME
        -- CAENVME_ReadCycle(0, 0, x"70000012", data, 9, cvD16); 
		-- wait for  20 us;
		
		-- lettura registro 0x0012 (A_FIRM_REV) dalla TRM nello slot 7 via VME
		-- CAENVME_ReadCycle(0, 0, x"70000012", data, 9, cvD16); 
		-- wait for  20 us;
	
		-- lettura registro 0x0012 (A_FIRM_REV) dalla TRM nello slot 7 via VME
        -- CAENVME_ReadCycle(0, 0, x"70000012", data, 9, cvD16); 
		-- wait for  20 us;
		
		-- CAENVME_ReadCycle(0, 0, x"70000012", data, 9, cvD16); 
		-- wait for  2 us;
		
		-- CAENVME_ReadCycle(0, 0, x"50000028", data, 9, cvD32); 
		-- wait for  10 us;
		
		-- CAENVME_ReadCycle(0, 0, x"70000012", data, 9, cvD16); 
		-- wait for  2 us;
		
		-- CAENVME_WriteCycle(0, 0, x"50000028", x"00000001", 0, cvD32); 
		-- wait for  10 us;
		
		-- CAENVME_ReadCycle(0, 0, x"70000012", data, 9, cvD16); 
		-- wait for  2 us;
		
		-- CAENVME_ReadCycle(0, 0, x"50000028", data, 9, cvD32); 
		-- wait for  500 us;
		
		-- BLT32
		-- CAENVME_BLTReadCycle(0, 0, X"70000000", mem_buff, MAX_BLT_SIZE, cvA32_U_BLT, cvD32, nb); 
		-- wait for  4 us;
		
		-- BLT64
		-- CAENVME_BLTReadCycle(0, 0, X"70000000", mem_buff, MAX_BLT_SIZE, cvA32_U_MBLT, cvD64, nb); 
		-- wait for  4 us;
		
		wait for 2000 ms;
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------
        CTRL2_reg_MANDRAKE      := '0'; CTRL2_reg_MANDRAKE_GO   := '0'; CTRL2_reg_TRMWAIT_4     := '1'; CTRL2_reg_TRMWAIT_5     := '1';     CTRL2_reg_TRMWAIT_6 := '1';
        CTRL2_reg_SET_PREPULSE  := '0'; CTRL2_reg_SETRDMODE     := '0'; CTRL2_reg_DISABLE_RO    := '0'; CTRL2_reg_SR_IRQEN      := '0';		CTRL2_reg_TRIG_IGNORE   := '0';
        CTRL2_reg   := "0000" & CTRL2_reg_TRIG_IGNORE & CTRL2_reg_SR_IRQEN & CTRL2_reg_DISABLE_RO & CTRL2_reg_SETRDMODE & CTRL2_reg_SET_PREPULSE & CTRL2_reg_TRMWAIT_6 & 
                       CTRL2_reg_TRMWAIT_5 & CTRL2_reg_TRMWAIT_4 & CTRL2_reg_MANDRAKE_GO & CTRL2_reg_MANDRAKE & "00";
        ---------------------------------------------------------------------------------------------------------------------------------------------------------------
		CAENVME_WriteCycle(0, 0, x"1000" & A_CTRL2, x"0000" & CTRL2_reg, 0, cvD32); 	-- setting RO_MODE = 0
		wait for 2 ms;
		
        -- se è un blt, in realtà clint non guarda l'indirizzo...
        --CAENVME_BLTReadCycle(0, 0, X"32100000" + A_OUTBUF, mem_buff, MAX_BLT_SIZE, cvA32_U_DATA, cvD32, nb); 
        
    --    CAENVME_BLTReadCycle(0, 0, X"32100000" + A_OUTBUF, mem_buff, MAX_BLT_SIZE, cvA32_U_DATA, cvD32, nb); 
 
        
        wait;
    end process; 

	sig_spy_evrdy_process : process is
	begin
		 init_signal_spy("/i2c_gbtx_tb/DRM2_top_inst0/CAEN_LINK_instance/I_clint/evrdy", "tb_evrdy");
		 init_signal_spy("/i2c_gbtx_tb/DRM2_top_inst0/rod_sniffer_instance/ssram_interrupt", "tb_ssram_interrupt");
     wait;
	end process sig_spy_evrdy_process;
  
end SIMUL;
