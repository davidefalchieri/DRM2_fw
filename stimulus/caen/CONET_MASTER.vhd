library ieee, std;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

library work;
USE work.caenlinkpkg.all;
USE work.DRM2pkg.all;
use work.io_utils.ALL;

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

    signal tclk125 : std_logic;
    signal rclk125 : std_logic;
    signal OPTTX, OPTRX  : std_logic;

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
    constant cvA32_U_MBLT : integer := 16#08#;  -- A32 non-privileged 64-bit block trnsfer     
    constant cvCR_CSR     : integer := 16#2F#;  -- CR/CSR space                                
    
    -- VME cycles data width
    constant cvD8         : integer := 1;  --  8 bit
    constant cvD16        : integer := 2;  -- 16 bit
    constant cvD32        : integer := 4;  -- 32 bit
    constant cvD64        : integer := 8;  -- 64 bit

    constant BYTESWAP     : std_logic := '0';    
    constant STAT_DTACK   : integer   := 4;
    constant STAT_BERR    : integer   := 5;
    
    ---------------------------------------------------------------------------------------------------
    -- malloc Buffers 
    ---------------------------------------------------------------------------------------------------
    constant MAX_OPT_SIZE  : integer := 258;       -- un pacchetto ottico è costituito da 258 parole a 16 bit (129 parole a 32 bit)
    constant MAX_BLT_SIZE  : integer :=(60*1024);  -- Dimensione massima del pacchetto BLT in byte scelta pari alla dimensione di un PBLT (PBLT 64Kbyte = 61440byte)
    
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
            
        begin
            wait for 400 ns;
			--wait for 500 us;
            -- HACK: ci dovrei mettere un loop di TOKEN in attesa di uno start
    
            -- TOKEN
            wait until rclk125'event and rclk125='1';
            tx_data           <= L_TOKEN; 
            tx_charisk        <= '1';
            -- NULL
            wait until rclk125'event and rclk125='1';
            tx_data           <= L_NULL; 
            tx_charisk        <= '1';
        
            i :=0;
    
            write_string(outline,"RECEIVED DATA PAYLOAD ");
            writeline(CLOG, outline); 
    
            while rcv_start = '0' loop
                -- aspetto lo start
                wait until rclk125'event and rclk125='1';     
                if rx_data = L_START and rx_charisk = '1' then
                    rcv_start := '1';
                    write_string(outline,"RECEIVED START ");
                    writeline(CLOG, outline); 
				elsif rx_data = L_TOKEN and rx_charisk = '1' then -- é tornato indietro il token
                    write_string(outline,"RECEIVED TOKEN ");
                    writeline(CLOG, outline); 
					wait until rclk125'event and rclk125='1';      -- invio un altro token
					tx_data           <= L_TOKEN; 
					tx_charisk        <= '1';
					-- NULL
					wait until rclk125'event and rclk125='1';
					tx_data           <= L_NULL; 
					tx_charisk        <= '1';					
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
        -- Funzioni per l'accesso ai registri interni al V2718, 
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
    
            write_string(outline, "CAENVME_BLTReadCycle");
            writeline(LLOG, outline);   

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
    
            write_string(outline, "sono qui");
            writeline(LLOG, outline);   
	
            -- CAENVMEComm
            Conet_SendPkt(link,node,outbuf,count); 
            Conet_RcvPkt(link,sn,inbuf,nwr,stat);
            nbyte := (nwr-1)*2; -- escluso lo status
            -- DISPATCH DATA
            if dsize = cvD64 then
            -- ...
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
        -- inizializzazione
        tx_data           <= L_COMMA; 
        tx_charisk        <= '1';
    
        wait for 200 us;
        tx_data           <= L_NULL; 
        tx_charisk        <= '1';    
    
        wait for 200 us;    
        
        -- Lettura di FIFO_Mode fatta dalla CAENVMELib all'init
        --address := X"00000001";    
        --CAENVMEReadREG(0, 0, address, data);  
    
		write_string(outline,"SI PARTE: ");
        writeline(CLOG, outline); 
    
        -- scrittura DEBUG register
        CAENVME_WriteCycle(0, 0, x"1000" & A_DEBUG, x"01234567", 0, cvD32); 
        wait for  10 us; 
		-- lettura DEBUG register
        CAENVME_ReadCycle(0, 0, x"1000" & A_DEBUG, data, 0, cvD32); 
        wait for  10 us;  
		
		----------------- VME accesses begin-----------------
		-- scrittura registro 0x0012 dalla TRM nello slot 5 via VME
        CAENVME_WriteCycle(0, 0, x"50000012", x"12345678", 9, cvD32); 
        wait for  2 us;		
		-- lettura registro 0x0012 dalla TRM nello slot 5 via VME
        CAENVME_ReadCycle(0, 0, x"50002012", data, 9, cvD32); 
		wait for  4 us;
		
		-- scrittura registro 0x0013 dalla TRM nello slot 5 via VME
        CAENVME_WriteCycle(0, 0, x"50000013", x"abcdef01", 9, cvD32); 
        wait for  2 us;		
		-- lettura registro 0x0013 dalla TRM nello slot 5 via VME
        CAENVME_ReadCycle(0, 0, x"50002013", data, 9, cvD32); 
		wait for  4 us;
		
		-- scrittura registro 0x0014 dalla TRM nello slot 5 via VME
        CAENVME_WriteCycle(0, 0, x"50000014", x"a1b2c3d4", 9, cvD32); 
        wait for  2 us;		
		-- lettura registro 0x0014 dalla TRM nello slot 5 via VME
        CAENVME_ReadCycle(0, 0, x"50002014", data, 9, cvD32); 
		wait for  4 us;
		
		--CAENVME_BLTReadCycle(0, 0, X"52100000" + A_OUTBUF, mem_buff, MAX_BLT_SIZE, cvA32_U_BLT, cvD32, nb); 
		--CAENVME_BLTReadCycle(0, 0, X"10000000" + A_OUTBUF, mem_buff, 1024, cvA32_U_BLT, cvD32, nb); 
		--wait for  4 us;
		
		-- scrittura registro 0x0014 di una TRM nello slot 6 che non c'e'
        --CAENVME_WriteCycle(0, 0, x"60000014", x"a1b2c3d4", 9, cvD32); 
        wait for  2 us;		
		-- lettura registro 0x0014 di una TRM nello slot 6 che non c'e'
        --CAENVME_ReadCycle(0, 0, x"60002014", data, 9, cvD32); 
		wait for  4 us;
				
		write_string(outline,"SI FA IL BLT: ");
        writeline(CLOG, outline); 
		
        -- se è un blt, in realtà clint non guarda l'indirizzo...
        CAENVME_BLTReadCycle(0, 0, X"52100000" + A_OUTBUF, mem_buff, MAX_BLT_SIZE, cvA32_U_DATA, cvD32, nb); 

		write_string(outline,"FATTO IL BLT: ");
        writeline(CLOG, outline); 
		
        wait for  4 us;
		
		-- scrittura registro 0x0014 dalla TRM nello slot 5 via VME
        CAENVME_WriteCycle(0, 0, x"50000014", x"a1b2c3d4", 9, cvD32); 
        wait for  2 us;		
		-- lettura registro 0x0014 dalla TRM nello slot 5 via VME
        CAENVME_ReadCycle(0, 0, x"50002014", data, 9, cvD32); 
		wait for  4 us;
		
		wait for  40 us;
		
		----------------- VME accesses end-----------------
		
				-- scrittura SSRAM
    --    CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00000", x"12345678", 0, cvD32); 				-- write to SSRAM
    --    wait for  200 ns;
	--	CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00001", x"9ABCDEF0", 0, cvD32); 				-- write to SSRAM
    --    wait for  200 ns;
	--	CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00002", x"12345678", 0, cvD32); 				-- write to SSRAM
    --    wait for  200 ns;
	--	CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00003", x"9ABCDEF0", 0, cvD32); 				-- write to SSRAM
    --    wait for  200 ns;
	--	CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00004", x"12345678", 0, cvD32); 				-- write to SSRAM
    --    wait for  200 ns;
	--	CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00004", x"55555555", 0, cvD32); 				-- write to SSRAM
    --    wait for  200 ns;
	--			-- lettura SSRAM
    --    CAENVME_ReadCycle(0, 0, x"00" & A_SSRAM & x"00000", data, 0, cvD32); 						-- read from SSRAM
    --    wait for  200 ns;
	--	CAENVME_ReadCycle(0, 0, x"00" & A_SSRAM & x"00001", data, 0, cvD32); 						-- read from SSRAM
    --    wait for  200 ns;
	--	CAENVME_ReadCycle(0, 0, x"00" & A_SSRAM & x"00002", data, 0, cvD32); 						-- read from SSRAM
    --    wait for  200 ns;
	--	CAENVME_ReadCycle(0, 0, x"00" & A_SSRAM & x"00003", data, 0, cvD32); 						-- read from SSRAM
    --    wait for  200 ns;
	--	CAENVME_ReadCycle(0, 0, x"00" & A_SSRAM & x"00004", data, 0, cvD32); 						-- read from SSRAM
    --    wait for  200 ns;
	--	CAENVME_ReadCycle(0, 0, x"00" & A_SSRAM & x"00005", data, 0, cvD32); 						-- read from SSRAM
    --    wait for  200 ns;
    --
	--	wait for  10 us; 
	--	
	--	-- scrittura GPOWCTRL register
    --    CAENVME_WriteCycle(0, 0, A_GPOWCTRL, x"000000EE", 0, cvD32); 				-- switch on GBTx
    --    wait for  10 us; 
	--	
	--	-- scrittura GBTX FIFO
    --    CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000010", 0, cvD32); 			-- write on GBTX FIFO
    --    wait for  1 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000000", 0, cvD32); 			-- write on GBTX FIFO (LSB addr)
    --    wait for  1 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000000", 0, cvD32); 			-- write on GBTX FIFO (MSB addr)
    --    wait for  1 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"000000AB", 0, cvD32); 			-- write on GBTX FIFO
    --    wait for  10 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"000000CD", 0, cvD32); 			-- write on GBTX FIFO
    --    wait for  10 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"000000EF", 0, cvD32); 			-- write on GBTX FIFO
    --    wait for  10 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000012", 0, cvD32); 			-- write on GBTX FIFO
    --    wait for  10 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO_DONE, x"00000000", 0, cvD32); 		-- write on GBTX FIFO DONE
    --    wait for  500 us;
	--	
	--	-- lettura GBTX FIFO
    --    CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000011", 0, cvD32); 			-- read from GBTX FIFO
    --    wait for  1 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000076", 0, cvD32); 			-- read from GBTX FIFO (LSB)
    --    wait for  1 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000001", 0, cvD32); 			-- read from GBTX FIFO (MSB)
    --    wait for  1 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000003", 0, cvD32); 			-- read from GBTX FIFO 3 values
    --    wait for  10 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000000", 0, cvD32); 			-- read from GBTX FIFO 3 values
    --    wait for  10 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO_DONE, x"00000000", 0, cvD32); 		-- write on GBTX FIFO DONE
    --    wait for  800 us;
	--	
	--	CAENVME_ReadCycle(0, 0, A_GBTX_FIFO, data, 0, cvD32); 					-- read from GBTX FIFO
    --    wait for  10 us;
	--	CAENVME_ReadCycle(0, 0, A_GBTX_FIFO, data, 0, cvD32); 					-- read from GBTX FIFO
    --    wait for  10 us;
	--	CAENVME_ReadCycle(0, 0, A_GBTX_FIFO, data, 0, cvD32); 					-- read from GBTX FIFO
    --    wait for  10 us;
	--	
    --    wait for  300 us;  
    --
	--	-- lettura GBTX FIFO
    --    CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000011", 0, cvD32); 			-- read from GBTX FIFO
    --    wait for  1 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000076", 0, cvD32); 			-- read from GBTX FIFO (LSB)
    --    wait for  1 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000001", 0, cvD32); 			-- read from GBTX FIFO (MSB)
    --    wait for  1 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000003", 0, cvD32); 			-- read from GBTX FIFO 3 values
    --    wait for  10 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO, x"00000000", 0, cvD32); 			-- read from GBTX FIFO 3 values
    --    wait for  10 us;
	--	CAENVME_WriteCycle(0, 0, A_GBTX_FIFO_DONE, x"00000000", 0, cvD32); 		-- write on GBTX FIFO DONE
    --    wait for  800 us;
	--	
	--	CAENVME_ReadCycle(0, 0, A_GBTX_FIFO, data, 0, cvD32); 					-- read from GBTX FIFO
    --    wait for  10 us;
	--	CAENVME_ReadCycle(0, 0, A_GBTX_FIFO, data, 0, cvD32); 					-- read from GBTX FIFO
    --    wait for  10 us;
	--	CAENVME_ReadCycle(0, 0, A_GBTX_FIFO, data, 0, cvD32); 					-- read from GBTX FIFO
    --    wait for  10 us;
	--	
	--	-- scrittura SSRAM
    --    CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00000", x"12345678", 0, cvD32); 				-- write to SSRAM
    --    wait for  500 ns;
	--	CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00001", x"9ABCDEF0", 0, cvD32); 				-- write to SSRAM
    --    wait for  500 ns;
	--	CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00002", x"12345678", 0, cvD32); 				-- write to SSRAM
    --    wait for  500 ns;
	--	CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00003", x"9ABCDEF0", 0, cvD32); 				-- write to SSRAM
    --    wait for  500 ns;
	--	CAENVME_WriteCycle(0, 0, x"00" & A_SSRAM & x"00004", x"12345678", 0, cvD32); 				-- write to SSRAM
    --    wait for  500 ns;
	--	
    --    wait for  300 us;
        
    --    CAENVME_BLTReadCycle(0, 0, X"32100000" + A_OUTBUF, mem_buff, MAX_BLT_SIZE, cvA32_U_DATA, cvD32, nb); 
 
        
        wait;
    end process;  
  
end SIMUL;
