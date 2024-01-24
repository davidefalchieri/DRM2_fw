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


entity CAEN_LINK is
port(

    reset      : in  std_logic;
	clear	   : in  std_logic;
	soft_clear : in  std_logic;
    a1500_reset: in  std_logic;
    clk40      : in  std_logic; 
    
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

    ------------------------------                                                 
    -- APB slave interface    
    ------------------------------                                                 
    APB_S_PADDR       : in std_logic_vector(14 downto 2); 
    APB_S_PCLK        : in std_logic;        
    APB_S_PENABLE     : in std_logic;                
    APB_S_PRESET_N    : in std_logic;                
    APB_S_PSEL        : in std_logic;                
    APB_S_PWDATA      : in std_logic_vector(31 downto 0); 
    APB_S_PWRITE      : in std_logic;                
    APB_S_PRDATA      : out std_logic_vector(31 downto 0);
    APB_S_PREADY      : out std_logic;          
    APB_S_PSLVERR     : out std_logic;          
    

    -- ************************************************************************************
    -- PXL (A1500 - Ethernet) -- HACK: pin assegnati a GPIO della scheda di sviluppo
    -- ************************************************************************************
    --RMT_RESET  : in  std_logic;                       -- Reset dalla A1500 verso la DRM (not used)
    PXL_RESET  : out std_logic;                         -- Reset per la A1500
    PXL_CS     : in  std_logic;                         -- Chip Select
    PXL_RD     : in  std_logic;                         -- Read
    PXL_WR     : in  std_logic;                         -- Write
    PXL_D      : inout  std_logic_vector (15 downto 0); -- Data
    PXL_A      : in  std_logic_vector ( 7 downto 0);    -- Address
    PXL_IRQ    : out std_logic;                         -- Interrupt Request
    PXL_IO     : inout  std_logic;    -- Spare I/Os
    PXL_OFF	   : out	std_logic;    -- out: controllo da registro(?)->spegnere la A1500

    
    -- ************************************************************************************
    -- CAEN Synchronous Local Bus Interface
    ------------------------------------------------------------
    --             |31 ... 28|27...16|15 ... 0|
    -- lb_address  |  slot   |xxxxxxx| offset |
    
    -- se slot = 1 -> accesso ai registri interni alla DRM 
    -- se slot > 1 -> accesso al VME
    ------------------------------------------------------------
    
    lb_address    : out    std_logic_vector (31 downto 0);  -- Local Bus Address 
    lb_wdata      : out    std_logic_vector (32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_wr)
    lb_rdata      : in     std_logic_vector (32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_rd)
    lb_wr         : out    std_logic;                       -- Local Bus Write
    lb_rd         : out    std_logic;                       -- Local Bus Read
    lb_rdy        : in     std_logic;                       -- Local Bus Ready (ack.)

    vme_info      : inout  VMEINFO_RECORD;            
    regs          : inout  REGS_RECORD;                     
    
     -- ************************************************************************************
     -- SROF
     -- ************************************************************************************
     -- FIFO di uscita della SR
     srof_dto   : in     std_logic_vector (32 downto 0); -- data
     srof_rd    : out    std_logic;                      -- read enable
     srof_empty : in     std_logic;                      -- empty
     evwritten  : in     std_logic;       
     ssram_interrupt:	in std_logic;		-- DAV INTERRUPT
    
    -- ************************************************************************************
    -- LED & SPARE
    -- ************************************************************************************
    --SWITCH1    : in  std_logic;

    --LED0       : out std_logic;
    --LED1       : out std_logic;
    --LED2       : out std_logic;
    --LED3       : out std_logic;
    --LED4       : out std_logic;
    --LED5       : out std_logic;
    --LED6       : out std_logic;

    SPARE0     : out std_logic;  -- GPIO pin6
    SPARE1     : out std_logic;  -- GPIO pin8
    SPARE2     : out std_logic;  -- GPIO pin12  
    SPARE3     : out std_logic;  -- GPIO pin14
    SPARE4     : out std_logic;  -- GPIO pin18
    SPARE5     : out std_logic;  -- GPIO pin20
    SPARE6     : out std_logic;  -- GPIO pin24
    SPARE7     : out std_logic;  -- GPIO pin26
    SPARE8     : out std_logic   -- GPIO pin30
    );
end CAEN_LINK;
   
architecture RTL of CAEN_LINK is

----------------------------------------------------------------------
-- Nets
----------------------------------------------------------------------
signal          tick50ms              : std_logic;  


----------------------------------------------------------------------
-- EPCS SERDES
signal          TXD0_P_net                                  : std_logic;
signal          TXD0_N_net                                  : std_logic;
signal          TXD1_P_net                                  : std_logic;
signal          TXD1_N_net                                  : std_logic;
signal          TXD2_P_net                                  : std_logic;
signal          TXD2_N_net                                  : std_logic;
signal          TXD3_P_net                                  : std_logic;
signal          TXD3_N_net                                  : std_logic;

signal          EPCS_SERDES_REFCLK_OUT                      : std_logic;
                                                          
signal          EPCS_SERDES_Lane2_READY                     : std_logic;
signal          EPCS_SERDES_Lane2_RX_CLK                    : std_logic;
signal          EPCS_SERDES_Lane2_RX_data                   : std_logic_vector(9 downto 0);
signal          EPCS_SERDES_Lane2_RX_IDLE                   : std_logic;
signal          EPCS_SERDES_Lane2_RX_RESET_N                : std_logic;
signal          EPCS_SERDES_Lane2_RX_VAL                    : std_logic;
signal          EPCS_SERDES_Lane2_TX_CLK                    : std_logic;
signal          EPCS_SERDES_Lane2_TX_RESET_N                : std_logic;
constant        EPCS_SERDES_Lane2_TX_data : std_logic_vector(9 downto 0) := "1010000011"; 
                                                          
signal          EPCS_SERDES_Lane0_READY                     : std_logic;
signal          EPCS_SERDES_Lane0_RX_CLK                    : std_logic;
signal          EPCS_SERDES_Lane0_RX_data                   : std_logic_vector(9 downto 0);
signal          EPCS_SERDES_Lane0_RX_IDLE                   : std_logic;
signal          EPCS_SERDES_Lane0_RX_RESET_N                : std_logic;
signal          EPCS_SERDES_Lane0_RX_VAL                    : std_logic;
signal          EPCS_SERDES_Lane0_TX_CLK                    : std_logic;
signal          EPCS_SERDES_Lane0_TX_RESET_N                : std_logic;
signal          EPCS_SERDES_Lane0_TX_data                   : std_logic_vector(9 downto 0);

signal          led_opt_net                                 : std_logic;

----------------------------------------------------------------------
-- CONET INTERFACE
signal          CorePCS_0_ALIGNED                           : std_logic;

signal          conet_interf_rx_data                        : std_logic_vector( 7 downto 0);
signal          conet_interf_rx_charisk                     : std_logic_vector( 0 downto 0);
signal          conet_interf_bsync                          : std_logic;
signal          conet_interf_lock                           : std_logic;
signal          conet_interf_tx_data                        : std_logic_vector( 7 downto 0);
signal          conet_interf_tx_charisk                     : std_logic_vector( 0 downto 0);
                                                                                                                            
signal          sclif_dto                                   : std_logic_vector(16 downto 0);
signal          sclif_rd                                    : std_logic;
signal          sclif_empty                                 : std_logic;
signal          sclof_dti                                   : std_logic_vector(16 downto 0);  
signal          sclof_wr                                    : std_logic;                       
signal          sclof_full                                  : std_logic;                       

signal          scl_pckw                                    : std_logic;                       -- Packet Written
signal          scl_pckrdy                                  : std_logic;                       -- Packet Ready

----------------------------------------------------------------------
-- A1500 INTERFACE                                                              
signal          pxlif_dto                                   : std_logic_vector (16 downto 0);  -- Data
signal          pxlif_rd                                    : std_logic;                       -- Read Enable
signal          pxlif_empty                                 : std_logic;                       -- Empty
signal          pxlof_dti                                   : std_logic_vector (16 downto 0);  -- Data
signal          pxlof_wr                                    : std_logic;                       -- Write Enable
signal          pxlof_full                                  : std_logic;                       -- Almost Full
                                                              
signal          pxl_pckw                                    : std_logic;                       -- Packet Written
signal          pxl_pckrdy                                  : std_logic;                       -- Packet Ready

----------------------------------------------------------------------
--signal          srof_dto                                    : std_logic_vector(32 downto 0);   -- data bus
--signal          srof_rd                                     : std_logic;                       -- read
--signal          srof_empty                                  : std_logic;                       -- empty
--signal          evwritten                                   : std_logic;                       -- event written        

-- registers
-- signal          regs                                        : REGS_RECORD; 

----------------------------------------------------------------------
-- A1500
--signal          pxl_io_i     : std_logic_vector (7 downto 0);   -- Spare I/Os

----------------------------------------------------------------------
-- LEDS & SPARE
signal          gpio_conet_interf                           : std_logic_vector( 7 downto 0);
signal          gpio_clint                                  : std_logic_vector( 7 downto 0);

signal          led1_net                                    : std_logic;
signal          led2_net                                    : std_logic;
                                                            
signal          spare0_net                                  : std_logic;
signal          spare1_net                                  : std_logic;
signal          spare2_net                                  : std_logic;
signal          spare3_net                                  : std_logic;
signal          spare4_net                                  : std_logic;
signal          spare5_net                                  : std_logic;
signal          spare6_net                                  : std_logic;
signal          spare7_net                                  : std_logic;
signal          spare8_net                                  : std_logic;

----------------------------------------------------------------------
-- Constant assignments
----------------------------------------------------------------------
constant        VCC_net : std_logic := '1';
constant        GND_net : std_logic := '0';

constant        FORCE_DISP_const_net : std_logic_vector(0 downto 0) := "0";
constant        DISP_SEL_const_net   : std_logic_vector(0 downto 0) := "0";

----------------------------------------------------------------------
-- Component Declaration
----------------------------------------------------------------------

---------------------------
component fdiv is
---------------------------
generic (
    FXTAL : positive := 100E6;     -- System Clock Frequency
    DEBUG : boolean  := false  );  -- True in simulation to speed up the simulation
port (  
    ----------------------------------------------------------
    -- Clocks + Reset
    ----------------------------------------------------------
    clk       : in  std_logic;
    reset     : in  std_logic;
    
    tick500ns : out std_logic;
    tick1us   : out std_logic;
    tick10us  : out std_logic;
    tick100us : out std_logic;
    tick1ms   : out std_logic;
    tick10ms  : out std_logic;
    tick50ms  : out std_logic;
    tick100ms : out std_logic;
    tick1s    : out std_logic  
);
end component; -- fdiv 

--------------------------------------------------------------------
component CLINT is
--------------------------------------------------------------------
    port(
        ----------------------------------------------------------
        -- Clocks + Reset
        ----------------------------------------------------------
        clk           : in     std_logic;  -- System clock: 50 MHz
        reset         : in     std_logic;  
        clear         : in     std_logic;  
		soft_clear    : in     std_logic; 
		regs          : inout  REGS_RECORD; 
        
        -- ************************************************************************************
        -- SCL (CONET - A3818/A2818)
        -- ************************************************************************************
        -- SCL RX FIFO (from CONET)
        sclif_dto     : in     std_logic_vector (16 downto 0);  -- rx fifo data; sclif_dto(16)= last packet data
        sclif_rd      : buffer std_logic;                       -- rx fifo read
        sclif_empty   : in     std_logic;                       -- rx fifo empty
        
        -- SCL TX FIFO (to CONET)
        sclof_dti     : out    std_logic_vector (16 downto 0);  -- tx fifo data; sclof_dti(16)= last packet data
        sclof_wr      : buffer std_logic;                       -- tx fifo write
        sclof_full    : in     std_logic;                       -- tx fifo full
        
        -- handshake
        scl_pckw      : out    std_logic;                       -- Packet Written
        scl_pckrdy    : in     std_logic;                       -- Packet Ready

        -- ************************************************************************************
        -- PXL (Ethernet - A1500)
        -- ************************************************************************************
        -- PXL RX FIFO (from A1500)
        pxlif_dto     : in    std_logic_vector (16 downto 0);  -- Data
        pxlif_rd      : buffer std_logic;                       -- Read Enable
        pxlif_empty   : in    std_logic;                       -- Empty
    
        -- PXL TX FIFO (to A1500)
        pxlof_dti     : out   std_logic_vector (16 downto 0);  -- Data
        pxlof_wr      : out   std_logic;                       -- Write Enable
        pxlof_full    : in    std_logic;                       -- Almost Full
    
        -- handshake
        pxl_pckw      : out   std_logic;                       -- Packet Written
        pxl_pckrdy    : in    std_logic;                       -- Packet Ready

        -- ************************************************************************************
        -- LOCAL BUS 
        -- ************************************************************************************
        -- Output Data FIFO 
        odf_dto       : in    std_logic_vector (32 downto 0);  -- data bus: bit 32 = END EVENT
        odf_rd        : out   std_logic;                       -- read
        odf_empty     : in    std_logic;                       -- empty
        evwritten     : in    std_logic;                       -- event written   ???   
                      
        lb_address    : out   std_logic_vector (31 downto 0);  -- Local Bus Address
        lb_wdata      : out   std_logic_vector (32 downto 0);  -- Local Bus Data
        lb_rdata      : in    std_logic_vector (32 downto 0);  -- Local Bus Data
        lb_wr         : out   std_logic;                       -- Local Bus Write
        lb_rd         : buffer   std_logic;                       -- Local Bus Read
        lb_rdy        : in    std_logic;                       -- Local Bus Ready                      
        vme_info      : inout VMEINFO_RECORD;        
        
        gpio          : inout std_logic_vector(7 downto 0)        
    );
end component CLINT;

--------------------------------------------------------------------
component CONET_INTERF is
--------------------------------------------------------------------
port(
    sys_clk             : in  std_logic;   
    
    rx_start            : out std_logic;                                                         
    rx_comma            : out std_logic;                                                         
    
    -- TX
    tx_reset_n          : in  std_logic;
    tclk                : in  std_logic;
    tx_data             : out std_logic_vector( 7 downto 0);
    tx_charisk          : out std_logic_vector( 0 downto 0);
    -- RX
    rx_reset_n          : in  std_logic;
    rclk                : in  std_logic;                       
    rx_data             : in  std_logic_vector( 7 downto 0);
    rx_charisk          : in  std_logic_vector( 0 downto 0);    

    rx_syncstatus       : in  std_logic;                          -- CorePCS ALIGNED 

    -- ************************************************************************************
    -- RX local Pipe (dati da CONET)
    rl_dto              : buffer    std_logic_vector(16 downto 0);
    rl_rd               : in     std_logic;
    rl_empty            : buffer    std_logic;
    
    -- ************************************************************************************
    -- TX local Pipe (dati verso CONET)
    tl_dti              : in     std_logic_vector (16 downto 0);  
    tl_wr               : in     std_logic;                       
    tl_full             : out    std_logic;                       

    -- handshake  HACK: TODO
    scl_pckw            : in     std_logic;                       -- Packet Written
    scl_pckrdy          : out    std_logic;                       -- Packet Ready (RX)
    
    -- ************************************************************************************
    irq                 : in     std_logic;                       -- interrupt request (attivo alto)
                        
    tick                : in     std_logic;                       -- almeno 2 ms
                        
    gpio                : out    std_logic_vector(7 downto 0);
    led_opt             : out    std_logic                        -- led TX/RX (attivo alto)
);
end component CONET_INTERF;

--------------------------------------------------------------------
component Core_PCS is
--------------------------------------------------------------------
port(
    -- Input
    DISP_SEL    : in std_logic_vector( 0 downto 0);
    EPCS_READY  : in std_logic;
    EPCS_RxCLK  : in std_logic;
    EPCS_RxDATA : in std_logic_vector( 9 downto 0);
    EPCS_RxIDLE : in std_logic;
    EPCS_RxRSTn : in std_logic;
    EPCS_RxVAL  : in std_logic;
    EPCS_TxCLK  : in std_logic;
    EPCS_TxRSTn : in std_logic;
    FORCE_DISP  : in std_logic_vector( 0 downto 0);
    RESET_N     : in std_logic;
    TX_DATA     : in std_logic_vector( 7 downto 0);
    TX_K_CHAR   : in std_logic_vector( 0 downto 0);
    WA_RSTn     : in std_logic;
    -- Output
    ALIGNED     : out std_logic;
    B_CERR      : out std_logic_vector( 0 downto 0);
    CODE_ERR_N  : out std_logic_vector( 0 downto 0);
    EPCS_PWRDN  : out std_logic;
    EPCS_RxERR  : out std_logic;
    EPCS_TXOOB  : out std_logic;
    EPCS_TxDATA : out std_logic_vector( 9 downto 0);
    EPCS_TxVAL  : out std_logic;
    INVALID_K   : out std_logic_vector( 0 downto 0);
    RD_ERR      : out std_logic_vector( 0 downto 0);
    RX_DATA     : out std_logic_vector( 7 downto 0);
    RX_K_CHAR   : out std_logic_vector( 0 downto 0)
);
end component Core_PCS;

--------------------------------------------------------------------
component EPCS_SERDES is
--------------------------------------------------------------------
    GENERIC( 
        SIM_MODE     : integer := 0     -- Enable simulation mode ( = 1)
    );
port(
    REFCLK0_N         : in  std_logic;
    REFCLK0_P         : in  std_logic;
    
    REFCLK_OUT        : out std_logic;

    TXD0_N            : out std_logic;                
    TXD0_P            : out std_logic;                
    TXD1_N            : out std_logic;                
    TXD1_P            : out std_logic;                
    TXD2_N            : out std_logic;                
    TXD2_P            : out std_logic;                
    TXD3_N            : out std_logic;                
    TXD3_P            : out std_logic;                
    
    RXD0_N            : in  std_logic;        
    RXD0_P            : in  std_logic;        
    RXD1_N            : in  std_logic;        
    RXD1_P            : in  std_logic;        
    RXD2_N            : in  std_logic;        
    RXD2_P            : in  std_logic;        
    RXD3_N            : in  std_logic;        
    RXD3_P            : in  std_logic;        
 
    ------------------------------                                                 
    -- EPCS interface    
    ------------------------------                                                 
    -- reset/ready                                                                
    EPCS_RESET_N      : in  std_logic;                
    Lane0_READY       : out std_logic;          
    Lane2_READY       : out std_logic;          

    ------------------------------                                                 
    -- transmitter channel                                                                
    Lane0_TX_data     : in  std_logic_vector(9 downto 0); 
    Lane0_TX_CLK      : out std_logic;                
    Lane0_TX_RESET_N  : out std_logic;                

    Lane2_TX_data     : in  std_logic_vector(9 downto 0);
    Lane2_TX_CLK      : out std_logic;                
    Lane2_TX_RESET_N  : out std_logic;                
    
    ------------------------------                                                 
    -- receiver channel                                                            
    Lane0_RX_data     : out std_logic_vector(9 downto 0);
    Lane0_RX_CLK      : out std_logic;          
    Lane0_RX_IDLE     : out std_logic;                   
    Lane0_RX_RESET_N  : out std_logic;                
    Lane0_RX_VAL      : out std_logic;  
    
    Lane2_RX_data     : out std_logic_vector(9 downto 0);
    Lane2_RX_CLK      : out std_logic;          
    Lane2_RX_IDLE     : out std_logic;                   
    Lane2_RX_RESET_N  : out std_logic;                
    Lane2_RX_VAL      : out std_logic;                
    
    ------------------------------                                                 
    -- APB slave interface    
    ------------------------------                                                 
    APB_S_PADDR       : in std_logic_vector(14 downto 2); 
    APB_S_PCLK        : in std_logic;        
    APB_S_PENABLE     : in std_logic;                
    APB_S_PRESET_N    : in std_logic;                
    APB_S_PSEL        : in std_logic;                
    APB_S_PWDATA      : in std_logic_vector(31 downto 0); 
    APB_S_PWRITE      : in std_logic;                
    APB_S_PRDATA      : out std_logic_vector(31 downto 0);
    APB_S_PREADY      : out std_logic;          
    APB_S_PSLVERR     : out std_logic          
    );
end component EPCS_SERDES ;


--------------------------------------------------------------------
component A1500_INTERF is
--------------------------------------------------------------------
port(
    clk        : in     std_logic;                       -- Clock
    reset      : in     std_logic;                       -- Reset
    a1500_reset: in     std_logic;
    
    -- ************************************************************************************
    -- A1500
    rmt_reset  : in     std_logic;                       -- reset dalla a1500 verso la drm
    pxl_reset  : out    std_logic;                       -- reset per la a1500
    pxl_d      : inout  std_logic_vector (15 downto 0);  -- data
    pxl_a      : in     std_logic_vector (7 downto 0);   -- address
    pxl_wr     : in     std_logic;                       -- write
    pxl_rd     : in     std_logic;                       -- read
    pxl_cs     : in     std_logic;                       -- chip select
    pxl_irq    : out    std_logic;                       -- interrupt request
    pxl_io     : inout  std_logic;  -- spare i/os
    pxl_off	   : out	std_logic;   -- out: controllo da registro(?)->spegnere la A1500
    
    -- ************************************************************************************
    -- Output FIFO
    pxlof_dti    : in   std_logic_vector (16 downto 0);
    pxlof_full   : out  std_logic;  -- in realta' e' un almost full (full-8)
    pxlof_wr     : in   std_logic;
    
    -- Input FIFO
    pxlif_dto    : buffer  std_logic_vector (16 downto 0);
    pxlif_empty  : buffer  std_logic;
    pxlif_rd     : in   std_logic;
    
    pxl_pckrdy   : out  std_logic;                     -- packet ready (in ingresso)
    pxl_pckw     : in   std_logic;                     -- packet written (in uscita)
    
    regs         : in  REGS_RECORD;                    -- per ora non usato

    -- ************************************************************************************
    -- Spare
    gpio        : out   std_logic_vector (31 downto 0)
);
end component A1500_INTERF ;


begin
--regs.rr_dtl <= (others => '0');
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------
    LED1      <= led1_net;
    LED2      <= led2_net;
    
    SPARE0    <= spare0_net;
    SPARE1    <= spare1_net;
    SPARE2    <= spare2_net;
    SPARE3    <= spare3_net;
    SPARE4    <= spare4_net;
    SPARE5    <= spare5_net;
    SPARE6    <= spare6_net;
    SPARE7    <= spare7_net;
    SPARE8    <= spare8_net;
    
    TXD0_P    <= TXD0_P_net;
    TXD0_N    <= TXD0_N_net;
    TXD1_P    <= TXD1_P_net;
    TXD1_N    <= TXD1_N_net;
    TXD2_P    <= TXD2_P_net;
    TXD2_N    <= TXD2_N_net;
    TXD3_P    <= TXD3_P_net;
    TXD3_N    <= TXD3_N_net;
    
        
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------ 
    I_FDIV: fdiv
    ------------------------------------------------------------------------------------------------ 
    generic map (
        FXTAL => 40E6,      -- System Clock Frequency
        DEBUG => false  )   -- True in simulation to speed up the simulation
    port map (   
        clk       => clk40,
        reset     => reset,
        tick500ns => open,
        tick1us   => open,
        tick10us  => open,
        tick100us => open,
        tick1ms   => open,
        tick10ms  => open,
        tick50ms  => tick50ms,
        tick100ms => open,
        tick1s    => open
    );
    
    --------------------------------------------------------------------
    I_clint : CLINT 
    --------------------------------------------------------------------
    port map(
        clk           => clk40,
        reset         => not(EPCS_SERDES_Lane0_RX_RESET_N),  	-- HACK: i reset vanno sistemati
        clear         => clear,									-- was EPCS_SERDES_Lane0_RX_RESET_N
		soft_clear    => soft_clear,
		regs	  	  => regs,
        
        -- input pipe (rx from ol)
        sclif_dto     => sclif_dto,  
        sclif_rd      => sclif_rd,   
        sclif_empty   => sclif_empty,   
        -- output pipe (tx to ol)
        sclof_dti     => sclof_dti, 
        sclof_wr      => sclof_wr,  
        sclof_full    => sclof_full,
        -- handshake
        scl_pckw      => scl_pckw,  
        scl_pckrdy    => scl_pckrdy,
        
        -- input pipe (rx from a1500)
        pxlif_dto     => pxlif_dto,   
        pxlif_rd      => pxlif_rd,    
        pxlif_empty   => pxlif_empty, 
        -- output pipe (tx to a1500)
        pxlof_dti     => pxlof_dti, 
        pxlof_wr      => pxlof_wr,  
        pxlof_full    => pxlof_full, 
        -- handshake
        pxl_pckw      => pxl_pckw,    
        pxl_pckrdy    => pxl_pckrdy,  
        
        -- local bus
        odf_dto       => srof_dto,   
        odf_rd        => srof_rd,    
        odf_empty     => srof_empty, 
        evwritten     => evwritten,
--evwritten     => '0',                      
        lb_address    => lb_address,
        lb_wdata      => lb_wdata ,
        lb_rdata      => lb_rdata ,
        lb_wr         => lb_wr    ,
        lb_rd         => lb_rd    ,  
        lb_rdy        => lb_rdy   ,
        vme_info      => vme_info ,
                             
        gpio          => gpio_clint
    );

    
    -- ************************************************************************************
    -- CONET (A2818/A3818)
    -- ************************************************************************************            

    -----------------------------------------------------------
    ----------conet_interf : sulla Lane0
    -----------------------------------------------------------
    I_conet_interf : conet_interf 
    port map (
        sys_clk         => clk40,
        rx_start        => conet_interf_lock,
        rx_comma        => conet_interf_bsync,
                        
        -- TX           
        tx_reset_n      => EPCS_SERDES_Lane0_TX_RESET_N, 
        tclk            => EPCS_SERDES_Lane0_TX_CLK,
        tx_data         => conet_interf_tx_data,
        tx_charisk      => conet_interf_tx_charisk,
        -- RX           
        rx_reset_n      => EPCS_SERDES_Lane0_RX_RESET_N,
        rclk            => EPCS_SERDES_Lane0_RX_CLK,
        rx_data         => conet_interf_rx_data,
        rx_charisk      => conet_interf_rx_charisk, 
        rx_syncstatus   => CorePCS_0_ALIGNED,
        
        -- RX local Pipe (dati da CONET)
        rl_dto          => sclif_dto,   
        rl_rd           => sclif_rd,    
        rl_empty        => sclif_empty, 
        -- TX local Pipe (dati verso CONET)
        tl_dti          => sclof_dti,    
        tl_wr           => sclof_wr,     
        tl_full         => sclof_full,
        
        -- handshake
        scl_pckw        => scl_pckw,   
        scl_pckrdy      => scl_pckrdy, 
        
        irq             => ssram_interrupt,				-- DAV INTERRUPT
                        
        tick            => tick50ms,                       
        gpio            => gpio_conet_interf,
        led_opt         => led_opt_net
    );                   
           
    -----------------------------------------------------------
    ----------CorePCS   -   Actel:DirectCore:CorePCS:3.2.137
    -----------------------------------------------------------
    --For RX bus orientation is always [n-1:0]. Whereas TX, it's 
    --orientation is upper towards lower.
    I_CorePCS : Core_PCS 
    port map (
        -- Master Reset
        RESET_N     => EPCS_SERDES_Lane0_TX_RESET_N ,  -- in
        -- EPCS control signals
        EPCS_READY  => EPCS_SERDES_Lane0_READY ,       -- in
        EPCS_PWRDN  => open,                           -- out
        EPCS_TXOOB  => open,                           -- out
        -- Word aligner signals
        WA_RSTn     => VCC_net ,                       -- in
        ALIGNED     => CorePCS_0_ALIGNED ,             -- out
                
        --------------------------------                                                 
        ---- transmitter channel                                                                
        --------------------------------                                                 
        -- 8b10b Encoder signals
        TX_DATA     => conet_interf_tx_data(7 downto 0) ,          -- in
        TX_K_CHAR   => conet_interf_tx_charisk ,                   -- in
        INVALID_K   => open,                           -- out
        FORCE_DISP  => FORCE_DISP_const_net ,          -- in
        DISP_SEL    => DISP_SEL_const_net ,            -- in
        -- EPCS TX signals       
        EPCS_TxRSTn => EPCS_SERDES_Lane0_TX_RESET_N ,  -- in
        EPCS_TxCLK  => EPCS_SERDES_Lane0_TX_CLK ,      -- in
        EPCS_TxDATA => EPCS_SERDES_Lane0_TX_data,--(9 downto 0) ,     -- out
        EPCS_TxVAL  => open,                           -- out
        
        --------------------------------                                                 
        ---- receiver channel                                                            
        --------------------------------                                                 
        -- 10b8b Decoder signals
        RX_DATA     => conet_interf_rx_data(7 downto 0) ,          -- out
        RX_K_CHAR   => conet_interf_rx_charisk    ,                -- out
        CODE_ERR_N  => open,                           -- out
        B_CERR      => open,                           -- out
        RD_ERR      => open,                           -- out

        -- EPCS RX signals       
        EPCS_RxRSTn => EPCS_SERDES_Lane0_RX_RESET_N ,  -- in
        EPCS_RxCLK  => EPCS_SERDES_Lane0_RX_CLK ,      -- in
        EPCS_RxDATA => EPCS_SERDES_Lane0_RX_data,-- (19 downto 10),     -- in
        EPCS_RxVAL  => EPCS_SERDES_Lane0_RX_VAL ,      -- in
        EPCS_RxIDLE => EPCS_SERDES_Lane0_RX_IDLE ,     -- in
        EPCS_RxERR  => open                            -- out
    );

    -----------------------------------------------------------
    ----------EPCS_SERDES
    -----------------------------------------------------------
	SFP_TXDISAB <= '0';

    I_EPCS_SERDES : EPCS_SERDES 
    port map(
        REFCLK0_P        => REFCLK0_P ,                -- in
        REFCLK0_N        => REFCLK0_N ,                -- in
        REFCLK_OUT       => EPCS_SERDES_REFCLK_OUT ,   -- out

        TXD0_P           => TXD0_P_net ,               -- out
        TXD0_N           => TXD0_N_net ,               -- out
        TXD1_P           => TXD1_P_net ,               -- out
        TXD1_N           => TXD1_N_net ,               -- out
        TXD2_P           => TXD2_P_net ,               -- out
        TXD2_N           => TXD2_N_net ,               -- out
        TXD3_P           => TXD3_P_net ,               -- out
        TXD3_N           => TXD3_N_net ,               -- out

        RXD0_P           => RXD0_P ,                   -- in
        RXD0_N           => RXD0_N ,                   -- in
        RXD1_P           => RXD1_P ,                   -- in
        RXD1_N           => RXD1_N ,                   -- in
        RXD2_P           => RXD2_P ,                   -- in
        RXD2_N           => RXD2_N ,                   -- in
        RXD3_P           => RXD3_P ,                   -- in
        RXD3_N           => RXD3_N ,                   -- in

        --------------------------------                                                 
        ---- EPCS interface    
        --------------------------------                                                 
        ---- reset/ready                                                                
        EPCS_RESET_N     => not(reset) ,      		   -- in
        Lane0_READY      => EPCS_SERDES_Lane0_READY ,  -- out
        Lane2_READY      => EPCS_SERDES_Lane2_READY ,  -- out
        
        --------------------------------                                                 
        ---- transmitter channel                                                                
        -------------------------------- 
        -- Lane0
        Lane0_TX_data    => EPCS_SERDES_Lane0_TX_data ,   -- in
        Lane0_TX_CLK     => EPCS_SERDES_Lane0_TX_CLK ,    -- out
        Lane0_TX_RESET_N => EPCS_SERDES_Lane0_TX_RESET_N ,-- out
        -- LANE2 
        Lane2_TX_data    => EPCS_SERDES_Lane2_TX_data ,   -- in
        Lane2_TX_CLK     => EPCS_SERDES_Lane2_TX_CLK ,    -- out
        Lane2_TX_RESET_N => EPCS_SERDES_Lane2_TX_RESET_N ,-- out
        
        --------------------------------                                                 
        ---- receiver channel                                                            
        --------------------------------                                                 
        -- Lane0
        Lane0_RX_data    => EPCS_SERDES_Lane0_RX_data ,   -- out
        Lane0_RX_CLK     => EPCS_SERDES_Lane0_RX_CLK ,    -- out
        Lane0_RX_IDLE    => EPCS_SERDES_Lane0_RX_IDLE ,   -- out
        Lane0_RX_RESET_N => EPCS_SERDES_Lane0_RX_RESET_N ,-- out
        Lane0_RX_VAL     => EPCS_SERDES_Lane0_RX_VAL ,    -- out
        -- LANE2
        Lane2_RX_data    => EPCS_SERDES_Lane2_RX_data ,   -- out
        Lane2_RX_CLK     => EPCS_SERDES_Lane2_RX_CLK ,    -- out
        Lane2_RX_IDLE    => EPCS_SERDES_Lane2_RX_IDLE ,   -- out
        Lane2_RX_RESET_N => EPCS_SERDES_Lane2_RX_RESET_N ,-- out
        Lane2_RX_VAL     => EPCS_SERDES_Lane2_RX_VAL ,    -- out
        
        --------------------------------                                                 
        ---- APB slave interface    
        --------------------------------                                                 
        APB_S_PRESET_N   => APB_S_PRESET_N,  --EPCS_Demo_INIT_APB_S_PRESET_N ,    -- in
        APB_S_PADDR      => APB_S_PADDR,     --EPCS_Demo_SDIF0_INIT_APB_PADDR_0_14to2 , -- in
        APB_S_PCLK       => APB_S_PCLK,      --EPCS_Demo_INIT_APB_S_PCLK ,        -- in
        APB_S_PENABLE    => APB_S_PENABLE,   --EPCS_Demo_SDIF0_INIT_APB_PENABLE , -- in
        APB_S_PSEL       => APB_S_PSEL,      --EPCS_Demo_SDIF0_INIT_APB_PSELx ,   -- in
        APB_S_PWRITE     => APB_S_PWRITE,    --EPCS_Demo_SDIF0_INIT_APB_PWRITE ,  -- in
        APB_S_PWDATA     => APB_S_PWDATA,    --EPCS_Demo_SDIF0_INIT_APB_PWDATA ,  -- in
        APB_S_PRDATA     => APB_S_PRDATA,    --EPCS_Demo_SDIF0_INIT_APB_PRDATA ,  -- out
        APB_S_PREADY     => APB_S_PREADY,    --EPCS_Demo_SDIF0_INIT_APB_PREADY ,  -- out
        APB_S_PSLVERR    => APB_S_PSLVERR    --EPCS_Demo_SDIF0_INIT_APB_PSLVERR   -- out
    );

       

    -- ************************************************************************************
    -- PXL (A1500 - Ethernet)
    -- ************************************************************************************
    -----------------------------------------------------------
    ----------A1500_INTERF
    -----------------------------------------------------------
    I_a1500_interf : A1500_INTERF 
    port map(
        CLK         => clk40,
        reset       => reset,
        a1500_reset => a1500_reset,
    
        --------------------------------                                                 
        -- A1500
        --------------------------------                                                 
        RMT_RESET   => '0',
        PXL_RESET   => PXL_RESET,
        PXL_D       => PXL_D,    
        PXL_A       => PXL_A,    
        PXL_WR      => PXL_WR,   
        PXL_RD      => PXL_RD,   
        PXL_CS      => PXL_CS,   
        PXL_IRQ     => PXL_IRQ,  
        PXL_IO      => pxl_io,   
        PXL_OFF     => pxl_off,   
       
        --------------------------------                                                 
        -- Input FIFO 
        PXLIF_DTO   => pxlif_dto,  
        PXLIF_EMPTY => pxlif_empty,
        PXLIF_RD    => pxlif_rd,   

        -- Output FIFO
        PXLOF_DTI   => pxlof_dti,  
        PXLOF_FULL  => pxlof_full, 
        PXLOF_WR    => pxlof_wr,   
                                            
        PXL_PCKRDY  => pxl_pckrdy, 
        PXL_PCKW    => pxl_pckw,   
    
		regs        => regs,
        --------------------------------                                                 
        -- Spare
        GPIO        => open
   );
    
 -----------------------------------------------------------
 ----------Debug Section
 -----------------------------------------------------------
    -- LEDS: attivi bassi
    led1_net <= not EPCS_SERDES_Lane0_READY;
    led2_net <= led_opt_net;    
    
    


    -- SPARE
    spare0_net   <= clk40;  
    spare1_net   <= '0';        
    spare2_net   <= reset;  
    spare3_net   <= gpio_conet_interf(0);    
    spare4_net   <= gpio_conet_interf(1);  
    spare5_net   <= gpio_conet_interf(2);  
    spare6_net   <= gpio_conet_interf(3);  
    spare7_net   <= gpio_conet_interf(4);  
    spare8_net   <= gpio_conet_interf(5);  
     
     
end RTL;
