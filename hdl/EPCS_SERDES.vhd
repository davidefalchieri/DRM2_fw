--!------------------------------------------------------------------------
--! @author       Annalisa Mati  (a.mati@caen.it)               
--! Contact       support.frontend@caen.it
--! @file         EPCS_SERDES.vhd
--!------------------------------------------------------------------------
--! @brief        MICROSEMI EPCS SERDES
--!------------------------------------------------------------------------               
--! $Id: $ 
--!------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity EPCS_SERDES is
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

end EPCS_SERDES ;

architecture RTL of EPCS_SERDES is

    constant GND_net  : std_logic := '0';                
    constant VCC_net  : std_logic := '1';                

    -----------------------------------------------------------------------------------------   
    -- Signal Declarations
    -----------------------------------------------------------------------------------------                                 

    
    signal Lane0_RX_RESET_N_net   : std_logic;
    signal Lane0_TX_RESET_N_net   : std_logic;
    signal Lane2_RX_RESET_N_net   : std_logic;
    signal Lane2_TX_RESET_N_net   : std_logic;
    
    ---------------------------

    signal SERDES_IF_0_EPCS_0_RX_DATA : std_logic_vector(9 downto 0);
    signal SERDES_IF_0_EPCS_2_RX_DATA : std_logic_vector(9 downto 0);
    
    signal Lane0_RX_CLK_net       : std_logic;
    signal Lane2_RX_CLK_net       : std_logic;
    
    signal SERDES_IF_0_EPCS_0_RX_VAL : std_logic;
    signal SERDES_IF_0_EPCS_2_RX_VAL : std_logic;
    
    signal Lane0_RX_IDLE_net    : std_logic;
    signal Lane2_RX_IDLE_net    : std_logic;
    
    signal delay_line_0_out_data  : std_logic_vector(9 downto 0);
    signal Lane0_RX_VAL_net     : std_logic;
    signal Lane0_RX_data_net    : std_logic_vector(9 downto 0);
    
    signal delay_line_2_out_data     : std_logic_vector(9 downto 0);
    signal Lane2_RX_VAL_net     : std_logic;
    signal Lane2_RX_data_net    : std_logic_vector(9 downto 0);
    ---------------------------
    signal Lane0_TX_CLK_net       : std_logic;
    signal Lane2_TX_CLK_net       : std_logic;
    
    signal epcs_tx_intf_0_txdout  : std_logic_vector(9 downto 0);
    signal epcs_tx_intf_2_txdout  : std_logic_vector(9 downto 0);
    
    -----------------------------------------------------------------------------------------   
    -- Component Declarations
    -----------------------------------------------------------------------------------------   
    component delay_line 
    generic (
        BUS_WIDTH : integer := 10;
        DELAY : integer := 5
    );
    port (
        in_data  : in  std_logic_vector(BUS_WIDTH-1 downto 0);
        out_data : out std_logic_vector(BUS_WIDTH-1 downto 0)
    );
    end component delay_line;
    
    
    ---------------------------
    component epcs_tx_intf
    ---------------------------
	port (    
        clk                  : in  std_logic;
        rstn                 : in  std_logic;
        txdin                : in  std_logic_vector(9 downto 0);
        txvali               : in  std_logic;
        txvalo               : out std_logic;
        txdout               : out std_logic_vector(9 downto 0)
    );
    end component epcs_tx_intf;
    
    ---------------------------
    component epcs_rx_intf
    ---------------------------
	port (    
        clk                  : in  std_logic;
        rstn                 : in  std_logic;
        rxdin                : in  std_logic_vector(9 downto 0);
        rxvali               : in  std_logic;
        rxvalo               : out std_logic;
        rxdout               : out std_logic_vector(9 downto 0)
    );
    end component epcs_rx_intf;
    
    ---------------------------
    component EPCS_SERDES_IF
    ---------------------------
	port (
        REFCLK0_N            : in  std_logic;
        REFCLK0_P            : in  std_logic;

        REFCLK0_OUT          : out std_logic;
                             
        TXD0_N               : out std_logic;
        TXD0_P               : out std_logic;
        TXD1_N               : out std_logic;
        TXD1_P               : out std_logic;
        TXD2_N               : out std_logic;
        TXD2_P               : out std_logic;
        TXD3_N               : out std_logic;
        TXD3_P               : out std_logic;

        RXD0_N               : in  std_logic;
        RXD0_P               : in  std_logic;
        RXD1_N               : in  std_logic;
        RXD1_P               : in  std_logic;
        RXD2_N               : in  std_logic;
        RXD2_P               : in  std_logic;
        RXD3_N               : in  std_logic;
        RXD3_P               : in  std_logic;
                                     
        -- ***************************
        -- EPCS interface    
        -- ***************************
        -- Reset        
        EPCS_0_PWRDN         : in  std_logic;
        EPCS_2_PWRDN         : in  std_logic;
        EPCS_0_RESET_N       : in  std_logic;
        EPCS_2_RESET_N       : in  std_logic;
        
        EPCS_0_RX_RESET_N    : out std_logic;
        EPCS_0_TX_RESET_N    : out std_logic; 
        EPCS_2_RX_RESET_N    : out std_logic;
        EPCS_2_TX_RESET_N    : out std_logic; 
        EPCS_0_READY         : out std_logic;
        EPCS_2_READY         : out std_logic;
        
        ------------------------------                                                 
        -- receiver channel                                                            
        ------------------------------                                                 
        EPCS_0_RX_DATA       : out std_logic_vector(9 downto 0);
        EPCS_0_RX_CLK        : out std_logic;
        EPCS_0_RX_VAL        : out std_logic;
        EPCS_0_RX_ERR        : in  std_logic;
        EPCS_0_RX_IDLE       : out std_logic;

        EPCS_2_RX_DATA       : out std_logic_vector(9 downto 0);
        EPCS_2_RX_CLK        : out std_logic;
        EPCS_2_RX_VAL        : out std_logic;
        EPCS_2_RX_ERR        : in  std_logic;
        EPCS_2_RX_IDLE       : out std_logic;
        
        ------------------------------                                                 
        -- transmitter channel                                                                
        ------------------------------                                                 
        EPCS_0_TX_DATA       : in  std_logic_vector(9 downto 0);
        EPCS_0_TX_CLK        : out std_logic;
        EPCS_0_TX_VAL        : in  std_logic;
        EPCS_0_TX_OOB        : in  std_logic;
        EPCS_0_TX_CLK_STABLE : out std_logic;

        EPCS_2_TX_DATA       : in  std_logic_vector(9 downto 0);
        EPCS_2_TX_CLK        : out std_logic;
        EPCS_2_TX_VAL        : in  std_logic;
        EPCS_2_TX_OOB        : in  std_logic;
        EPCS_2_TX_CLK_STABLE : out std_logic;
        
        -- ***************************
        -- APB slave interface    
        -- ***************************
        -- Inputs
        APB_S_PADDR          : in  std_logic_vector(14 downto 2);
        APB_S_PCLK           : in  std_logic;
        APB_S_PENABLE        : in  std_logic;
        APB_S_PRESET_N       : in  std_logic;
        APB_S_PSEL           : in  std_logic;
        APB_S_PWDATA         : in  std_logic_vector(31 downto 0);
        APB_S_PWRITE         : in  std_logic;
        -- Outputs
        APB_S_PRDATA         : out std_logic_vector(31 downto 0);
        APB_S_PREADY         : out std_logic;
        APB_S_PSLVERR        : out std_logic
	);
    end component EPCS_SERDES_IF;
        
begin

    --------epcs_rx_intf
    epcs_rx_intf_0 : epcs_rx_intf
    port map (
        -- Inputs
        clk    => Lane0_RX_CLK_net,             -- uscita del SERDES
        rstn   => Lane0_RX_RESET_N_net,         -- uscita del SERDES
        rxvali => SERDES_IF_0_EPCS_0_RX_VAL,    -- uscita del SERDES
        rxdin  => delay_line_0_out_data,        -- uscita della delay_line
        -- Outputs
        rxvalo => Lane0_RX_VAL_net,
        rxdout => Lane0_RX_data_net
        );        
    Lane0_RX_data    <= Lane0_RX_data_net;      -- uscita del epcs_rx_intf
    Lane0_RX_VAL     <= Lane0_RX_VAL_net;       -- uscita del epcs_rx_intf

    Lane0_RX_CLK     <= Lane0_RX_CLK_net;       -- uscita del SERDES 
    Lane0_RX_RESET_N <= Lane0_RX_RESET_N_net;   -- uscita del SERDES
    Lane0_RX_IDLE    <= Lane0_RX_IDLE_net;      -- uscita del SERDES
    
    --------epcs_rx_intf
    epcs_rx_intf_2 : epcs_rx_intf
    port map (
        -- Inputs
        clk    => Lane2_RX_CLK_net,             -- uscita del SERDES
        rstn   => Lane2_RX_RESET_N_net,         -- uscita del SERDES
        rxvali => SERDES_IF_0_EPCS_2_RX_VAL,    -- uscita del SERDES
        rxdin  => delay_line_2_out_data,        -- uscita della delay_line
        -- Outputs                              
        rxvalo => Lane2_RX_VAL_net,             
        rxdout => Lane2_RX_data_net             
        );                                      
    Lane2_RX_data    <= Lane2_RX_data_net;      -- uscita del epcs_rx_intf
    Lane2_RX_VAL     <= Lane2_RX_VAL_net;       -- uscita del epcs_rx_intf
                                                
    Lane2_RX_CLK     <= Lane2_RX_CLK_net;       -- uscita del SERDES 
    Lane2_RX_RESET_N <= Lane2_RX_RESET_N_net;   -- uscita del SERDES
    Lane2_RX_IDLE    <= Lane2_RX_IDLE_net;      -- uscita del SERDES
        
    --------epcs_tx_intf
    epcs_tx_intf_0 : epcs_tx_intf
    port map (
        -- Inputs
        clk    => Lane0_TX_CLK_net,
        rstn   => Lane0_TX_RESET_N_net,
        txvali => GND_net,
        txdin  => Lane0_TX_data,
        -- Outputs
        txvalo => open,
        txdout => epcs_tx_intf_0_txdout 
        );

    Lane0_TX_CLK     <= Lane0_TX_CLK_net;
    Lane0_TX_RESET_N <= Lane0_TX_RESET_N_net;
    
    --------epcs_tx_intf
    epcs_tx_intf_2 : epcs_tx_intf
    port map (
        -- Inputs
        clk    => Lane2_TX_CLK_net,
        rstn   => Lane2_TX_RESET_N_net,
        txvali => GND_net,
        txdin  => Lane2_TX_data,
        -- Outputs
        txvalo => open,
        txdout => epcs_tx_intf_2_txdout
        );

    Lane2_TX_CLK     <= Lane2_TX_CLK_net;
    Lane2_TX_RESET_N <= Lane2_TX_RESET_N_net;
        
    --------delay_line
    rx_delay0 : delay_line
    port map (
        -- Inputs
        in_data  => SERDES_IF_0_EPCS_0_RX_DATA,
        -- Outputs
        out_data => delay_line_0_out_data
        );

    --------delay_line
    rx_delay2 : delay_line
    port map (
        -- Inputs
        in_data  => SERDES_IF_0_EPCS_2_RX_DATA,
        -- Outputs
        out_data => delay_line_2_out_data 
        );
        
        
    -- *****************************************************************************************************************
    EPCS_SERDES_IF_0 : EPCS_SERDES_IF
    -- *****************************************************************************************************************
	port map (
        REFCLK0_N            => REFCLK0_N,    
        REFCLK0_P            => REFCLK0_P,    
        --EPCS_FAB_REF_CLK     => clk125,
        REFCLK0_OUT          => REFCLK_OUT,  
                                           
        TXD0_N               => TXD0_N,       
        TXD0_P               => TXD0_P,       
        TXD1_N               => TXD1_N,       
        TXD1_P               => TXD1_P,       
        TXD2_N               => TXD2_N,       
        TXD2_P               => TXD2_P,       
        TXD3_N               => TXD3_N,       
        TXD3_P               => TXD3_P,       

        RXD0_N               => RXD0_N,       
        RXD0_P               => RXD0_P,       
        RXD1_N               => RXD1_N,       
        RXD1_P               => RXD1_P,       
        RXD2_N               => RXD2_N,       
        RXD2_P               => RXD2_P,       
        RXD3_N               => RXD3_N,       
        RXD3_P               => RXD3_P,       
                                           
        -- ***************************
        -- EPCS interface    
        -- ***************************
        -- Reset        
        EPCS_0_PWRDN         => GND_net,
        EPCS_2_PWRDN         => GND_net,
        EPCS_0_RESET_N       => EPCS_RESET_N,
        EPCS_2_RESET_N       => EPCS_RESET_N,
                              
        EPCS_0_RX_RESET_N    => Lane0_RX_RESET_N_net,
        EPCS_0_TX_RESET_N    => Lane0_TX_RESET_N_net, 
        EPCS_2_RX_RESET_N    => Lane2_RX_RESET_N_net,
        EPCS_2_TX_RESET_N    => Lane2_TX_RESET_N_net,  
        EPCS_0_READY         => Lane0_READY,
        EPCS_2_READY         => Lane2_READY,
        
        ------------------------------                                                 
        -- receiver channel                                                            
        ------------------------------                                                 
        EPCS_0_RX_DATA       => SERDES_IF_0_EPCS_0_RX_DATA,
        EPCS_0_RX_CLK        => Lane0_RX_CLK_net,
        EPCS_0_RX_VAL        => SERDES_IF_0_EPCS_0_RX_VAL,
        EPCS_0_RX_ERR        => GND_net,
        EPCS_0_RX_IDLE       => Lane0_RX_IDLE_net,

        EPCS_2_RX_DATA       => SERDES_IF_0_EPCS_2_RX_DATA,
        EPCS_2_RX_CLK        => Lane2_RX_CLK_net,
        EPCS_2_RX_VAL        => SERDES_IF_0_EPCS_2_RX_VAL,
        EPCS_2_RX_ERR        => GND_net,
        EPCS_2_RX_IDLE       => Lane2_RX_IDLE_net,
        
        ------------------------------                                                 
        -- transmitter channel                                                                
        ------------------------------                                                 
        EPCS_0_TX_DATA       => epcs_tx_intf_0_txdout,
        EPCS_0_TX_CLK        => Lane0_TX_CLK_net,
        EPCS_0_TX_VAL        => VCC_net,
        EPCS_0_TX_OOB        => GND_net,
        EPCS_0_TX_CLK_STABLE => open,

        EPCS_2_TX_DATA       => epcs_tx_intf_2_txdout,
        EPCS_2_TX_CLK        => Lane2_TX_CLK_net,
        EPCS_2_TX_VAL        => VCC_net,
        EPCS_2_TX_OOB        => GND_net,
        EPCS_2_TX_CLK_STABLE => open,
        
        -- ***************************
        -- APB slave interface    
        -- ***************************
        -- Inputs
        APB_S_PADDR          => APB_S_PADDR,
        APB_S_PCLK           => APB_S_PCLK,
        APB_S_PENABLE        => APB_S_PENABLE,
        APB_S_PRESET_N       => APB_S_PRESET_N,
        APB_S_PSEL           => APB_S_PSEL,
        APB_S_PWDATA         => APB_S_PWDATA, 
        APB_S_PWRITE         => APB_S_PWRITE,
        -- Outputs
        APB_S_PRDATA         => APB_S_PRDATA,
        APB_S_PREADY         => APB_S_PREADY, 
        APB_S_PSLVERR        => APB_S_PSLVERR
	);
   
        
    
end RTL;

