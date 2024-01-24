----------------------------------------------------------------------
-- Created by A. Mati
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
USE work.caenlinkpkg.all;
use work.DRM2pkg.all;

entity DRM2_BOARD is

end DRM2_BOARD;

architecture SIMUL of DRM2_BOARD is

    signal reset_n    : std_logic;                         -- system Reset 

    signal REFCLK0_N  : std_logic;
    signal REFCLK0_P  : std_logic;
    signal OPTRX_n, OPTRX_p : std_logic;
    signal OPTTX_n, OPTTX_p : std_logic;
    
    signal RMT_RESET  : std_logic;                         -- Reset generato da A1500
    signal PXL_RESET  : std_logic;                         -- Reset per la A1500
    signal PXL_CS     : std_logic;                         -- Chip Select
    signal PXL_RD     : std_logic;                         -- Read
    signal PXL_WR     : std_logic;                         -- Write
    signal PXL_D      : std_logic_vector (15 downto 0);    -- Data
    signal PXL_A      : std_logic_vector ( 7 downto 0);    -- Address
    signal PXL_IRQ    : std_logic;                         -- Interrupt Request
    signal PXL_IO     : std_logic_vector (7 downto 0);     -- Spare I/Os

-----------------------------------------------------------
component CONET_MASTER is
-----------------------------------------------------------
    port( 
        OPTRX_n : IN     std_logic;
        OPTRX_p : IN     std_logic;
        OPTTX_n : OUT    std_logic;
        OPTTX_p : OUT    std_logic
    );
end component CONET_MASTER;

-----------------------------------------------------------
component A1500 is
-----------------------------------------------------------
   port(
      PXL_D     : inout  STD_LOGIC_VECTOR (15 downto 0);  -- Data
      PXL_A     : out    STD_LOGIC_VECTOR (7 downto 0);   -- Address
      PXL_WR    : out    STD_LOGIC;                       -- Write
      PXL_RD    : out    STD_LOGIC;                       -- Read
      PXL_CS    : out    STD_LOGIC;                       -- Chip Select
      PXL_IRQ   : in     STD_LOGIC;                       -- Interrupt Request
      PXL_RESET : in     STD_LOGIC;                       -- Reset
      RMT_RESET : out    STD_LOGIC;                       -- Reset generato da A1500
      PXL_IO    : inout  STD_LOGIC_VECTOR (7 downto 0)    -- Spare I/Os
   );
end component A1500 ;

-----------------------------------------------------------
component GBTXtest_main is
-----------------------------------------------------------
port(

    DEVRST_N   : in  std_logic;
    
    
    -- ************************************************************************************
    -- GBTx signals
    -- ************************************************************************************
    GBTX_RXDVALID: 	in    std_logic;
    GBTX_RXRDY: 	in    std_logic;
    GBTX_TESTOUT: 	in    std_logic;
    GBTX_TXRDY: 	in    std_logic;
    GBTX_ARST: 		out   std_logic;
    GBTX_CONFIG: 	out   std_logic;
    GBTX_MODE: 		out   std_logic_vector(3 downto 0);
    GBTX_RESETB: 	out   std_logic;
    GBTX_RXLOCKM: 	out   std_logic_vector(1 downto 0);
    GBTX_SADD: 		out   std_logic_vector(3 downto 0);
    GBTX_TXDVALID: 	out   std_logic;
    REFCLKSELECT: 	out   std_logic;
    STATEOVERRIDE: 	out   std_logic;
    GBTX_SCL: 		inout std_logic;
    GBTX_SDA: 		inout std_logic;
		-- GBTX DOUT
    DOUTN:			in	  std_logic_vector(31 downto 0);
    DOUTP:			in	  std_logic_vector(31 downto 0);
    DON:			in    std_logic_vector(39 downto 32);
    DOP:			in    std_logic_vector(39 downto 32);
            -- GBTX DIN
    DINN:			out	  std_logic_vector(31 downto 0);
    DINP:			out	  std_logic_vector(31 downto 0);
    DIN:			out   std_logic_vector(39 downto 32);
    DIP:			out   std_logic_vector(39 downto 32);
            -- GBTX DCK
    DCK_0:			in	  std_logic;
        -- VTrx transceiver
    GBPS_TX_DISAB: 	out   std_logic;
    -- NI 8451 i2c
    MSION061: 		inout std_logic;
    MSIOP061: 		inout std_logic;
    -- power
    ENVGD: 			out   std_logic;    					-- stabilizer enable
    TESTpls: 		out   std_logic_vector(3 downto 0);		-- power test signals
    FPGASCL: 		inout std_logic;						-- INA i2c
    FPGASDA: 		inout std_logic;  						-- INA i2c

    -- ************************************************************************************
    -- SCL - CONET (A2818/A3818)
    -- ************************************************************************************    
    REFCLK0_N  : in  std_logic;
    REFCLK0_P  : in  std_logic;

    RXD0_N     : in  std_logic;
    RXD0_P     : in  std_logic;
    RXD1_N     : in  std_logic;
    RXD1_P     : in  std_logic;
    RXD2_N     : in  std_logic;
    RXD2_P     : in  std_logic;
    RXD3_N     : in  std_logic;
    RXD3_P     : in  std_logic;

    TXD0_N     : out std_logic;
    TXD0_P     : out std_logic;
    TXD1_N     : out std_logic;
    TXD1_P     : out std_logic;
    TXD2_N     : out std_logic;
    TXD2_P     : out std_logic;
    TXD3_N     : out std_logic;
    TXD3_P     : out std_logic;

    LED1       : out std_logic;  
    LED2       : out std_logic;  
    SFP_TXDISAB     : out std_logic; 
    
    -- ************************************************************************************
    -- PXL (A1500 - Ethernet) -- HACK: pin assegnati a GPIO della scheda di sviluppo
    -- ************************************************************************************
    --RMT_RESET  : in  std_logic;                       -- Reset dalla A1500 verso la DRM (not used)
    PXL_RESET  : out std_logic;                         -- Reset per la A1500
    PXL_D      : inout  std_logic_vector (15 downto 0); -- Data
    PXL_A      : in  std_logic_vector ( 7 downto 0);    -- Address
    PXL_WR     : in  std_logic;                         -- Write
    PXL_RD     : in  std_logic;                         -- Read
    PXL_CS     : in  std_logic;                         -- Chip Select
    PXL_IRQ    : out std_logic;                         -- Interrupt Request
    PXL_IO     : inout  std_logic_vector(0 downto 0);          -- Spare I/Os
    
    SPARE0     : out std_logic
   
    );
end component GBTXtest_main;
   

-- ************************************************************************************
begin

-- code for instance HWRES pulse
P_hwrespulse_proc: process
    begin
        reset_n <= 
         '0',
         '1' after 50 ns;
        wait;
end process;

P_refclk_proc: process
    begin
        loop
            REFCLK0_N <= '0', '1' after 4 ns;
            REFCLK0_P <= '1', '0' after 4 ns;
            wait for 8 ns;
        end loop;
        wait;
 end process P_refclk_proc;

 
-----------------------------------------------------------
I_CONET_MASTER : CONET_MASTER
-----------------------------------------------------------
    port map( 
        OPTRX_n => OPTRX_n, -- loop
        OPTRX_p => OPTRX_p,
        OPTTX_n => OPTTX_n,
        OPTTX_p => OPTTX_p
    );
 
-----------------------------------------------------------
I_A1500 : A1500 
-----------------------------------------------------------
port map(
      PXL_D     => PXL_D,    
      PXL_A     => PXL_A,    
      PXL_WR    => PXL_WR,   
      PXL_RD    => PXL_RD,   
      PXL_CS    => PXL_CS,   
      PXL_IRQ   => PXL_IRQ,  
      PXL_RESET => PXL_RESET,
      RMT_RESET => RMT_RESET,
      PXL_IO    => PXL_IO
   );           

-----------------------------------------------------------
GBTX_TOP_instance : GBTXtest_main 
-----------------------------------------------------------
port map(

    DEVRST_N   => reset_n,

    -- ************************************************************************************
    -- GBTx signals
    -- ************************************************************************************
    GBTX_RXDVALID => '0',  --: 	in    std_logic;
    GBTX_RXRDY    => '0',  --: 	in    std_logic;
    GBTX_TESTOUT  => '0',  --: 	in    std_logic;
    GBTX_TXRDY    => '0',  --: 	in    std_logic;
    GBTX_ARST     => open, --: 		out   std_logic;
    GBTX_CONFIG   => open, --: 	out   std_logic;
    GBTX_MODE     => open, --: 		out   std_logic_vector(3 downto 0);
    GBTX_RESETB   => open, --: 	out   std_logic;
    GBTX_RXLOCKM  => open, --: 	out   std_logic_vector(1 downto 0);
    GBTX_SADD     => open, --: 		out   std_logic_vector(3 downto 0);
    GBTX_TXDVALID => open, --: 	out   std_logic;
    REFCLKSELECT  => open, --: 	out   std_logic;
    STATEOVERRIDE => open, --: 	out   std_logic;
    GBTX_SCL      => open,  --: 		inout std_logic;
    GBTX_SDA      => open,  --: 		inout std_logic;
		-- GBTX DOUT
    DOUTN         => (others =>'0'),  --:			in	  std_logic_vector(31 downto 0);
    DOUTP         => (others =>'1'),  --:			in	  std_logic_vector(31 downto 0);
    DON           => (others =>'0'),  --:			in    std_logic_vector(39 downto 32);
    DOP           => (others =>'1'),  --:			in    std_logic_vector(39 downto 32);
            -- GBTX DIN
    DINN          => open, --:			out	  std_logic_vector(31 downto 0);
    DINP          => open, --:			out	  std_logic_vector(31 downto 0);
    DIN           => open, --:			out   std_logic_vector(39 downto 32);
    DIP           => open, --:			out   std_logic_vector(39 downto 32);
            -- GBTX DCK
    DCK_0         => '0',  --:			in	  std_logic;
        -- VTrx transceiver
    GBPS_TX_DISAB => open, --: 	out   std_logic;
    -- NI 8451 i2c
    MSION061      => open,  --: 		inout std_logic;
    MSIOP061      => open,  --: 		inout std_logic;
    -- power
    ENVGD         => open, --: 			out   std_logic;    					-- stabilizer enable
    TESTpls       => open, --: 		out   std_logic_vector(3 downto 0);		-- power test signals
    FPGASCL       => open,  --: 		inout std_logic;						-- INA i2c
    FPGASDA       => open,  --: 		inout std_logic;  						-- INA i2c


    
    -- ************************************************************************************
    -- SCL - CONET (A2818/A3818): emulato dentro EPCS_SERDES
    -- ************************************************************************************    
    REFCLK0_N  => REFCLK0_N,
    REFCLK0_P  => REFCLK0_P,
                     
    RXD0_N     => OPTTX_n,
    RXD0_P     => OPTTX_p,
    RXD1_N     => '0',
    RXD1_P     => '0',
    RXD2_N     => '0',
    RXD2_P     => '0',
    RXD3_N     => '0',
    RXD3_P     => '0',
                  
    TXD0_N     => OPTRX_n,
    TXD0_P     => OPTRX_p,
    TXD1_N     => open,
    TXD1_P     => open,
    TXD2_N     => open,
    TXD2_P     => open,
    TXD3_N     => open,
    TXD3_P     => open,
                  
    LED1       => open,
    LED2       => open,
    SFP_TXDISAB => open,
    
    -- ************************************************************************************
    -- PXL (A1500 - Ethernet) -- HACK: pin assegnati a GPIO della scheda di sviluppo
    -- ************************************************************************************
    --RMT_RESET  => 
    PXL_RESET  => PXL_RESET,
    PXL_CS     => PXL_CS,   
    PXL_RD     => PXL_RD,   
    PXL_WR     => PXL_WR,   
    PXL_D      => PXL_D,    
    PXL_A      => PXL_A,    
    PXL_IRQ    => PXL_IRQ, 
    PXL_IO     => open,    

    -- ************************************************************************************
    -- LED & SPARE
    -- ************************************************************************************

    SPARE0     => open
    );
     
end SIMUL;
