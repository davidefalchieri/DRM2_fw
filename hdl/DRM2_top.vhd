
---------------------------------------------------------------------------------------------------------------------------------------------
-- Libraries
---------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_textio.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library smartfusion2;
use smartfusion2.all;

use std.textio.all;
use work.txt_util.all;

USE work.caenlinkpkg.all;
use work.DRM2pkg.all;

---------------------------------------------------------------------------------------------------------------------------------------------
-- DRM2_top entity declaration
---------------------------------------------------------------------------------------------------------------------------------------------
entity DRM2_top is
    port(
			-- reset signals
        DEVRST_N		: in 		std_logic;
		SYSRESL			: out		std_logic;
		PROGL			: out		std_logic;
			-- clock signals
		DCLK00_N		: in	 	std_logic;							-- GBTx clock from E-Links
		DCLK00_P		: in	  	std_logic;
		FPGACK40_N		: in		std_logic;							-- GBTx clock from PS or from LHC or from local oscillator
		FPGACK40_P		: in		std_logic;
		FPGACK80_N		: in		std_logic;							-- GBTx clock from PS
		FPGACK80_P		: in		std_logic;
		CPDMCK40_N		: in		std_logic;							-- clock from CPDM (ALICLK)
		CPDMCK40_P		: in		std_logic;
		lvCLKLOS		: in		std_logic;
		--XTL			: in    	std_logic;							-- crystal in
		CLK_SEL1		: out		std_logic;							-- chooses between local (= 1) and LHC clock (= 0)
		CLK_SEL2		: out		std_logic;
			-- GBTx DIN
		DI_N			: out   	std_logic_vector(39 downto 0);
		DI_P			: out   	std_logic_vector(39 downto 0);
			-- GBTx DOUT
		DO_N			: in	  	std_logic_vector(39 downto 0);
		DO_P			: in	  	std_logic_vector(39 downto 0);
			-- GBTx control signals
		GBTX_RESETB		: out   	std_logic;
		GBTX_RXRDY		: in    	std_logic;
		GBTX_TXRDY		: in    	std_logic;
		GBTX_CONFIG		: out   	std_logic;
        GBTX_RXDVALID	: in    	std_logic;
		GBTX_SCL		: inout 	std_logic;
        GBTX_SDA		: inout 	std_logic;
		GBTX_TXDVALID	: out   	std_logic;    
        GBTX_TESTOUT	: in    	std_logic;
		
		-------------------------------------------------------------------------------------------
		-- 	SCL - CONET (A2818/A3818) -------------------------------------------------------------
		-------------------------------------------------------------------------------------------
		REFCLK0_N		: in  	std_logic;
        REFCLK0_P		: in  	std_logic;
    
        RXD0_N			: in  	std_logic;
        RXD0_P			: in  	std_logic;
        RXD1_N			: in  	std_logic;
        RXD1_P			: in  	std_logic;
        RXD2_N			: in  	std_logic;
        RXD2_P			: in  	std_logic;
        RXD3_N			: in  	std_logic;
        RXD3_P			: in  	std_logic;
        
        TXD0_N			: out 	std_logic;
        TXD0_P			: out 	std_logic;
        TXD1_N			: out 	std_logic;
        TXD1_P			: out 	std_logic;
        TXD2_N			: out 	std_logic;
        TXD2_P			: out 	std_logic;
        TXD3_N			: out 	std_logic;
        TXD3_P			: out 	std_logic;

        lvSFP_TXDISAB	: out 	std_logic;
		lvSFP_TXFAULT	: in	std_logic;
		lvSFP_LOS		: in	std_logic;
		
		-------------------------------------------------------------------------------------------
		-- A1500 ----------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------
		PXL_A			: in    	std_logic_vector (7 downto 0);   	-- address
		PXL_D			: inout 	std_logic_vector (15 downto 0);  	-- data
		PXL_CS			: in    	std_logic;                       	-- chip select
		PXL_RD			: in    	std_logic;                       	-- read
		PXL_WR			: in    	std_logic;                       	-- write
		PXL_RESET		: out   	std_logic;                       	-- reset towards A1500
		PXL_IRQ			: out   	std_logic;                       	-- interrupt request
		PXL_IO			: inout	 	std_logic_vector (1 downto 0);   	-- spare I/Os
		-------------------------------------------------------------------------------------------
		-- SSRAM ----------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------
		RAM_A			: out		std_logic_vector(19 downto 0);
		RAM_D			: inout		std_logic_vector(35 downto 0);
		RAM_CLK			: out		std_logic;
		RAM_CSN			: out		std_logic;
		RAM_LDN			: out		std_logic;
		RAM_OEN			: out		std_logic;
		RAM_WEN			: out		std_logic;
		
		-- VME buses (data + address + address modifier)
		VDB            	: inout  	std_logic_vector (31 downto 0);  	-- VME data bus
		VAD            	: inout  	std_logic_vector (31 downto 1);  	-- VME address bus
		LWORDB         	: inout  	std_logic;
		AML            	: out  		std_logic_vector (5 downto 0);     	-- VME address modifier

		-- VME control signals
		ASL            	: buffer 	std_logic;
		DS0L           	: out    	std_logic;
		DS1L           	: out    	std_logic;
		WRITEL         	: out    	std_logic;
		DTACKB         	: in     	std_logic;
		BERRB          	: in     	std_logic;
		BERRL          	: buffer 	std_logic;
		IACKL          	: out    	std_logic;
		IRQB1          	: in     	std_logic;
		
		-- VME transceiver signals
	    NOEDTW         	: buffer 	std_logic;    						-- OE on data from DRM2 to VME
	    NOEDTR        	: buffer 	std_logic;    						-- OE on data from VME to V1718
	    NOEADW         	: buffer 	std_logic;    						-- OE on address/data from DRM2 to VME
	    NOEADR         	: buffer 	std_logic;    						-- OE on address/data from VME to V718
	    NOEMAS        	: buffer 	std_logic;    						-- OE on signals for System Controller
	    NOEDRDY       	: buffer 	std_logic;    						-- OE on Data Ready signals (towards VDB)
	    NOEFAULT       	: buffer 	std_logic;    						-- OE on Fault (towards VDB)
		
		-- custom signals on P2 VME connector
		BUNCH_RES      	: out 	 	std_logic;
	    EVENT_RES      	: out	 	std_logic;
	    SPULSEL0       	: out	 	std_logic;  						-- Pulse for CPDM
	    SPULSEL1       	: out	 	std_logic;
	    SPULSEL2       	: out	 	std_logic;
	    lvCPDM_FCLKL    : out    	std_logic;  						-- Force Clock Selection for CPDM
	    lvCPDM_SCLKB    : in     	std_logic;  						-- Clock Status of CPDM
	    PULSETGLL      	: out    	std_logic;  						-- Pulse Toggle for LTM
	    LTMLTB         	: in     	std_logic;  						-- Local Trigger from LTM
	    BUSYB          	: in     	std_logic;  						-- Busy from TRM
	    SPSEOL         	: out    	std_logic;  						-- Spare single ended OUT
	    SPSEIB         	: in     	std_logic;  						-- Spare single ended IN
		
	    lvL0           	: buffer 	std_logic;  						-- Triggers
	    lvL1A          	: buffer 	std_logic;
	    lvL1R          	: buffer 	std_logic;
	    lvL2A          	: buffer 	std_logic;
	    lvL2R          	: buffer 	std_logic;
		lvSPD0         	: out    	std_logic;  						-- Spare Differential OUT
		
		-- ATMEGA signals
		PSM_SP1			: in		std_logic;							-- in : spare
		PSM_SP0			: in		std_logic;							-- in : spare
		PXL_SDN			: in		std_logic;							-- in : A1500 has been switched off
		SERDES_SDN		: out		std_logic;							
		PSM_SI			: out		std_logic;							-- out: opcode towards micro
		PSM_SO			: in		std_logic;							-- in : data from micro
		PSM_SCK			: in		std_logic;							-- in : clock from micro
		PXL_OFF			: out		std_logic; 							-- out: switch A1500 off
		
		--e-fuses
		lvEFUSEENAB		: out		std_logic;
		EFUSESYNC		: out		std_logic;
		
		-- front panel
		CLKLEDR			: out		std_logic;
		SCLLED2			: out		std_logic;
		CLKLEDG			: out		std_logic;
		FPGALED1		: out		std_logic;
		FPGALED2		: out		std_logic;
		FPGALED3		: out		std_logic;
		FPGALED4		: out		std_logic;
		lvFPGAIO1		: inout		std_logic;
		FPGADIR1		: out		std_logic;
		lvFPGAIO2		: inout		std_logic;
		FPGADIR2		: out		std_logic;
		lvFPGA_SCOPE	: out		std_logic;

		-- NI 8451 I2C
		EXTSCL			: inout 	std_logic;
        EXTSDA			: inout 	std_logic;
		-- temperature sensors I2C
		SCL				: inout 	std_logic;
        SDA				: inout 	std_logic
		
		-- FPGA configuration signals
		--JTAGSEL			: in		std_logic     
        );
end DRM2_top;

---------------------------------------------------------------------------------------------------------------------------------------------
-- DRM2_top architecture body
---------------------------------------------------------------------------------------------------------------------------------------------
architecture RTL of DRM2_top is

-- INBUF_DIFF
---------------------------------------------------------------------------------------------------------------------------------------------
component INBUF_DIFF ------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
    generic( 
        IOSTD : string := "" 
        );
    port(
        -- Inputs
        PADN : in  std_logic;
        PADP : in  std_logic;
        -- Outputs
        Y    : out std_logic
        );
end component;

-- OUTBUF_DIFF
---------------------------------------------------------------------------------------------------------------------------------------------
component OUTBUF_DIFF -----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
    generic( 
        IOSTD : string := "" 
        );
    port(
        -- Inputs
        D    : in std_logic;
        -- Outputs
		PADP : out std_logic;
        PADN : out std_logic
        );
end component;

-- GCLKBUF_DIFF
---------------------------------------------------------------------------------------------------------------------------------------------
component GCLKBUF_DIFF ----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
    generic( 
        IOSTD : string := "" 
        );
    port(
        -- Inputs
        PADP    : in 	std_logic;
		PADN    : in 	std_logic;
		EN		: in 	std_logic;
        -- Outputs
		Y 		: out 	std_logic
        );
end component;

---------------------------------------------------------------------------------------------------------------------------------------------
component GBTx_interface is
---------------------------------------------------------------------------------------------------------------------------------------------
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
	GBTX_RXRDY: 			in    	std_logic;
		-- vme_int --> GBTx interface
	GBTx_data_fifo_dti_ck:	in		std_logic_vector(64 downto 0);
	GBTx_data_fifo_wr_ck:	in		std_logic;
	GBTx_data_fifo_almfull:	out		std_logic;
	RODATA_ck: 				in   	std_logic;          				-- 1 => Readout Data; 0 => Slow Control data
	busy_from_trm:			in		std_logic;
		-- GBTx interface --> vme_int
	l1a_ttc_delay:			out		std_logic;
	l1msg_dto:				out 	std_logic_vector(79 downto 0);
	l1msg_empty:			out		std_logic;
	l1msg_rd:				in		std_logic;
	bunch_reset_delay:		out    	std_logic
	);
end component;

---------------------------------------------------------------------------------------------------------------------------------------------
component EPCS_Demo_sb is -------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
port(
    --Input
    --CLK0                  : in std_logic;
    DEVRST_N              : in std_logic;
    FAB_RESET_N           : in std_logic;
    SDIF0_PRDATA          : in std_logic_vector(31 downto 0);
    SDIF0_PREADY          : in std_logic;
    SDIF0_PSLVERR         : in std_logic;
    SDIF0_SPLL_LOCK       : in std_logic;
    --Output
    COMM_BLK_INT          : out std_logic;
    FAB_CCC_GL0           : out std_logic;
    FAB_CCC_GL1           : out std_logic;
    FAB_CCC_LOCK          : out std_logic;
    HPMS_INT_M2F          : out std_logic_vector(15 downto 0);
    HPMS_READY            : out std_logic;
    INIT_APB_S_PCLK       : out std_logic;
    INIT_APB_S_PRESET_N   : out std_logic;
    INIT_DONE             : out std_logic;
    POWER_ON_RESET_N      : out std_logic;
    SDIF0_0_CORE_RESET_N  : out std_logic;
    SDIF0_1_CORE_RESET_N  : out std_logic;
    SDIF0_PADDR           : out std_logic_vector(15 downto 2);
    SDIF0_PENABLE         : out std_logic;
    SDIF0_PHY_RESET_N     : out std_logic;
    SDIF0_PSEL            : out std_logic;
    SDIF0_PWDATA          : out std_logic_vector(31 downto 0);
    SDIF0_PWRITE          : out std_logic;
    SDIF_READY            : out std_logic
);
end component EPCS_Demo_sb;

---------------------------------------------------------------------------------------------------------------------------------------------
component CAEN_LINK is ----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
port(

    reset      : in  std_logic;
	clear	   : in  std_logic;
	soft_clear : in  std_logic;
    a1500_reset: in  std_logic;
    clk40      : in  std_logic;
	linkres_n  : out std_logic; 		-- rclk domain	

    ---------------------------------------------------------------------------------------
    -- SCL - CONET (A2818/A3818)
    ---------------------------------------------------------------------------------------
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

    ---------------------------------------------------------------------------------------                                                 
    -- APB slave interface    
    ---------------------------------------------------------------------------------------                                                 
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

    ---------------------------------------------------------------------------------------
    -- PXL (A1500 - Ethernet) -- HACK: pin assegnati a GPIO della scheda di sviluppo
    ---------------------------------------------------------------------------------------
    --RMT_RESET  : in  std_logic;                       -- reset from A1500 to DRM2 (not used)
    PXL_RESET  : out std_logic;                         -- reset to A1500
    PXL_CS     : in  std_logic;                         -- chip select
    PXL_RD     : in  std_logic;                         -- read
    PXL_WR     : in  std_logic;                         -- write
    PXL_D      : inout  std_logic_vector (15 downto 0); -- data
    PXL_A      : in  std_logic_vector ( 7 downto 0);    -- address
    PXL_IRQ    : out std_logic;                         -- interrupt request
    PXL_IO     : inout  STD_LOGIC;                         -- Spare I/Os
	PXL_OFF	   : out	std_logic;    -- out: controllo da registro(?)->spegnere la A1500

    ---------------------------------------------------------------------------------------
    -- CAEN Synchronous Local Bus Interface 
    lb_address    : out    std_logic_vector (31 downto 0);  -- Local Bus Address
    lb_wdata      : out    std_logic_vector (32 downto 0);  -- Local Bus Data
    lb_rdata      : in     std_logic_vector (32 downto 0);  -- Local Bus Data
    lb_wr         : out    std_logic;                       -- Local Bus Write
    lb_rd         : out    std_logic;                       -- Local Bus Read
    lb_rdy        : in     std_logic;                       -- Local Bus Ready (ack.)
                  
	vme_info      : inout  VMEINFO_RECORD;
    regs          : inout  REGS_RECORD;        
    
    ---------------------------------------------------------------------------------------
    -- SROF
    ---------------------------------------------------------------------------------------
    -- FIFO di uscita della SR
    srof_dto   : in     std_logic_vector (32 downto 0); -- data
    srof_rd    : out    std_logic;                      -- read enable
    srof_empty : in     std_logic;                      -- empty
    evwritten  : in     std_logic;                      -- interrupt di buffer ready
	ssram_interrupt:	in std_logic;
    
    ---------------------------------------------------------------------------------------
    -- SPARE
    ---------------------------------------------------------------------------------------
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
end component CAEN_LINK;

---------------------------------------------------------------------------------------------------------------------------------------------
component I2C_CORE is -----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
    -- Port list
    port(
        -- Inputs
        AUXSCLI       : in  std_logic;
        AUXSDAI       : in  std_logic;
        CMHZdef       : in  std_logic_vector(7 downto 0);
        Debug1in      : in  std_logic;
        DebugTestEnab : in  std_logic;
        GADDa         : in  std_logic_vector(7 downto 0);
        GBTXSCLI      : in  std_logic;
        GBTXSDAI      : in  std_logic;
        GBTX_RXDVALID : in  std_logic;
        GBTX_RXRDY    : in  std_logic;
        GBTX_TESTOUT  : in  std_logic;
        GBTX_TXRDY    : in  std_logic;
        GDIa          : in  std_logic_vector(7 downto 0);
        GENa          : in  std_logic;
        GWRa          : in  std_logic;
        PCLK          : in  std_logic;
        PSM_SCK       : in  std_logic;
        PSM_SO        : in  std_logic;
        PSM_SP0       : in  std_logic;
        PSM_SP1       : in  std_logic;
        PXL_SDN       : in  std_logic;
        RESETn        : in  std_logic;
        SCLI          : in  std_logic;
        SDAI          : in  std_logic;
        SELI2Cdef     : in  std_logic;
        -- Outputs
        AUXSCLO       : out std_logic;
        AUXSDAO       : out std_logic;
        CONET_DISAB   : out std_logic;
        Debug1        : out std_logic;
        Debug2        : out std_logic;
        DebugS        : out std_logic;
        EFUSEENAB     : out std_logic;
        EFUSESYNC     : out std_logic;
        GBTXSCLO      : out std_logic;
        GBTXSDAO      : out std_logic;
        GBTX_CONFIG   : out std_logic;
        GBTX_RESETB   : out std_logic;
        GBTX_TXDVALID : out std_logic;
        GDOa          : out std_logic_vector(7 downto 0);
        P1uS          : out std_logic;
        PSM_SI        : out std_logic;
        PXL_OFF       : out std_logic;
        SCLO          : out std_logic;
        SDAO          : out std_logic;
        SERDES_SDN    : out std_logic;
		CLOCKSEL1	  : out std_logic;
		CLOCKSEL2	  : out std_logic
        );
end component I2C_CORE;

---------------------------------------------------------------------------------------------------------------------------------------------
component vme_int is
---------------------------------------------------------------------------------------------------------------------------------------------
   port
	(
      active_high_reset: 	in     	std_logic;                       -- Reset (active HIGH)
	  clear: 				buffer  std_logic;
	  soft_clear:			buffer 	std_logic;
      a1500_reset:          buffer  std_logic;
	  FPGACK_40MHz: 		in    	std_logic;                       -- FPGACK_40MHz
	  fw_date:				in  	std_logic_vector(31 downto 0);

      -- ************************************************************************************
        -- CAEN Synchronous Local Bus Interface 
      lb_address: 			in     	std_logic_vector(31 downto 0);  -- Local Bus Address
      lb_wdata: 			in     	std_logic_vector(32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_wr)
      lb_rdata: 			out    	std_logic_vector(32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_rd)
      lb_wr: 				in    	std_logic;                       -- Local Bus Write
      lb_rd: 				in     	std_logic;                       -- Local Bus Read
      lb_rdy: 				out    	std_logic;                       -- Local Bus Ready (ack.)
      
	  vme_info: 			inout  	VMEINFO_RECORD; 
      regs: 				inout  	REGS_RECORD; 
	  
	  -- GBTx_interface signals
	  GBTx_data_fifo_dti: 	out     std_logic_vector(64 downto 0);  	-- data to GBTx + end packet
	  GBTx_data_fifo_wr:	out   	std_logic;                       	-- data to GBTx write enable
	  GBTx_data_fifo_almfull: in 	std_logic;
	  l1a_ttc_delay:		in		std_logic;
	  l1msg_dto:			in   	std_logic_vector(79 downto 0);
	  l1msg_empty:			in		std_logic;
	  l1msg_rd:				out		std_logic;
	  rodata:	 			buffer  std_logic;						 -- Readout data
	  acq_on:				out     std_logic;
	  bunch_reset_delay:	in		std_logic;
	  
	  -- rod_sniffer interface signals
	  sniff_data:			out     std_logic_vector(32 downto 0);
	  sniff_valid:			out		std_logic;
	  sniff_ctrl:			out		std_logic;
	  
		-- GBTx I2C register interface
	  GDI: 					in   	std_logic_vector(7 downto 0); 	-- Register data in
      GDO: 					out  	std_logic_vector(7 downto 0); 	-- Register data out
      GWR: 					out  	std_logic; -- Write signal
      GEN: 					out  	std_logic; -- Enable signal
      GADD: 				out  	std_logic_vector(7 downto 0);
	  
		-- VME address/data buses + address modifier
	  VAD: 					inout  	std_logic_vector(31 downto 1);  -- VME address bus
	  VDB: 					inout  	std_logic_vector(31 downto 0);  -- VME data bus
	  AML: 					out    	std_logic_vector(5 downto 0);   -- VME address modifier
		-- VME control signals
	  ASL: 					buffer 	std_logic;
	  DS0L: 				out    	std_logic;
	  DS1L: 				out    	std_logic;
	  WRITEL: 				out    	std_logic;
	  LWORDB: 				inout  	std_logic;
	  DTACKB: 				in     	std_logic;
	  BERRB: 				in     	std_logic;
	  BERRL: 				buffer 	std_logic;
	  IACKL: 				out    	std_logic;
	  IRQB1:		 		in     	std_logic;
	  -- VME transceivers active low OE signals
	  NOEDTW: 				buffer 	std_logic;    -- data bus OE from Igloo2 to VME
	  NOEDTR: 				buffer 	std_logic;    -- data bus OE from VME to Igloo2
	  NOEADW: 				buffer 	std_logic;    -- data/address bus OE from Igloo2 to VME 
	  NOEADR: 				buffer 	std_logic;    -- data/address bus OE from VME to Igloo2 
	  NOEMAS: 				buffer 	std_logic;    -- address modifier bus OE from Igloo2 to VME 
	  NOEDRDY: 				buffer 	std_logic;    -- Data Ready OE towards VDB
	  NOEFAULT: 			buffer 	std_logic;     -- Fault OE towards verso VDB
	  
	  -- LEDs
	  VMELED: 				out    std_logic;
	  DRDYLED: 				out    std_logic;  -- LED di L2A
	  
	  -- P2 signals
	  L0: 					buffer std_logic;  -- Triggers
	  L1A: 					buffer std_logic;
	  L1R: 					buffer std_logic;
	  L2A: 					buffer std_logic;
	  L2R: 					buffer std_logic;
	  BUNCH_RES: 			buffer std_logic;
	  EVENT_RES: 			buffer std_logic;
	  SPULSEL0: 			buffer std_logic;  -- Pulse for CPDM
	  SPULSEL1: 			buffer std_logic;
	  SPULSEL2: 			buffer std_logic;
	  busy_from_trm:		out	   std_logic;
	  CPDM_FCLKL: 			out    std_logic;  -- Force Clock Selection for CPDM
	  CPDM_SCLKB: 			in     std_logic;  -- Clock Status of CPDM
	  PULSETGLL: 			out    std_logic;  -- Pulse Toggle for LTM
	  LTMLTB: 				in     std_logic;  -- Local Trigger from LTM
	  SPSEOL: 				out    std_logic;  -- Spare single ended OUT
	  SPSEIB: 				in     std_logic;  -- Spare single ended IN
	  SPDO: 				out    std_logic;  -- Spare Differential OUT
	  
	  TICK: 				in     tick_pulses;
	  WPULSE: 				buffer reg_wpulse;
	  PROGL: 				out    std_logic  -- PROG (ovvero PROGL negato da un BJT) è attivo basso
   );
end component vme_int;

---------------------------------------------------------------------------------------------------------------------------------------------
component rod_sniffer is
---------------------------------------------------------------------------------------------------------------------------------------------
   port
	(
      active_high_reset: 	in     	std_logic;                      			-- reset (active HIGH)
	  clear: 				in      std_logic;
	  soft_clear:			in	 	std_logic;
	  FPGACK_40MHz: 		in    	std_logic;                      			-- FPGACK_40MHz
	  regs: 				inout  	REGS_RECORD; 
	  WPULSE: 				in      reg_wpulse;
	  acq_on:				in		std_logic;

	  -- data from vme_int
	  sniff_data: 			in	    std_logic_vector(32 downto 0);  			-- data to GBTx + endPCK
	  sniff_valid:			in   	std_logic;                      			-- FIFO write enable
	  sniff_ctrl:			in		std_logic;
	  
	  -- SROF interface
	  srof_dto: 			out    std_logic_vector(32 downto 0);  				-- data
	  srof_rd: 				in     std_logic;                      				-- read enable
	  srof_empty: 			buffer std_logic;                      				-- empty
	  evwritten: 			out    std_logic;                      				-- event written
	  ssram_interrupt:		out	   std_logic;

	  -- SSRAM interface
	  ssram_D:	 			inout  std_logic_vector(35 downto 0);   			-- data
	  ssram_A:	 			out    std_logic_vector(19 downto 0);   			-- address
	  ssram_WE: 			out    std_logic;
	  ssram_OE: 			out    std_logic;
	  ssram_LD: 			out    std_logic;
	  ssram_CE: 			out    std_logic
   );
end component rod_sniffer;

component version_reg 
port ( 
    data_out : out std_logic_vector(31 downto 0)
);
end component version_reg;

component DDR_IN
	port(D, CLK, EN, ALn, ADn, SLn, SD : in std_logic := 'U'; QR, QF : out std_logic) ;
end component;

component DDR_OUT
	port(DR, DF, CLK, EN, ALn, ADn, SLn, SD : in std_logic := 'U'; Q : out std_logic) ;
end component;


---------------------------------------------------------------------------------------------------------------------------------------------
-- Signal declarations
---------------------------------------------------------------------------------------------------------------------------------------------
-- GBTx signals
signal GBTX_SCLI:									std_logic;
signal GBTX_SCLO:									std_logic;
signal GBTX_SDAI:									std_logic;
signal GBTX_SDAO:									std_logic;
signal AUX_SCLO:									std_logic;
signal AUX_SDAO:									std_logic;
signal AUX_SCLI:									std_logic;
signal AUX_SDAI:									std_logic;
signal SCLI:										std_logic;
signal SCLO:										std_logic;
signal SDAI:										std_logic;
signal SDAO:										std_logic;
signal GBTX_CONFIG_int: 							std_logic;
signal GBTX_RESETB_int: 							std_logic;
signal GBTX_TXDVALID_int: 							std_logic;
signal GBTX_TESTOUT_int: 							std_logic;
signal GBTX_RXRDY_int: 								std_logic;
signal GBTX_RXDVALID_int: 							std_logic;
signal GBTX_TXRDY_int: 								std_logic;

-- Sysreset + CoreReset + clock signals
signal active_high_reset:                   		std_logic; 
signal clk40: 			       			    		std_logic;  -- main clock
signal clk20:										std_logic;  -- for GBTX I2C
signal FPGACK80:									std_logic;
signal CPDMCK40:									std_logic;

-- local bus for GBTx programming
signal GDOa:										std_logic_vector(7 downto 0);
signal GDIa:										std_logic_vector(7 downto 0);
signal GWRa:										std_logic;
signal GENa:										std_logic;
signal GADDa:										std_logic_vector(7 downto 0);
	
signal GBTX_DOUT:									std_logic_vector(39 downto 0);
signal GBTX_DIN:									std_logic_vector(39 downto 0);

----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal VCC_net: 									std_logic;
signal GND_net: 									std_logic;
signal SDIF0_PRDATA_const_net_0: 					std_logic_vector(31 downto 0);
signal SDIF1_PRDATA_const_net_0: 					std_logic_vector(31 downto 0);
signal SDIF2_PRDATA_const_net_0: 					std_logic_vector(31 downto 0);
signal SDIF3_PRDATA_const_net_0: 					std_logic_vector(31 downto 0);

signal FPGACK_40MHz:								std_logic;
signal gbt_clk_40MHz:								std_logic;

signal vme_info: 									VMEINFO_RECORD; 
signal regs: 										REGS_RECORD; 

signal lb_address: 									std_logic_vector (31 downto 0);  -- Local Bus Address
signal lb_wdata: 									std_logic_vector (32 downto 0);  -- Local Bus Data
signal lb_rdata: 									std_logic_vector (32 downto 0);  -- Local Bus Data
signal lb_wr: 										std_logic;                       -- Local Bus Write
signal lb_rd: 										std_logic;                       -- Local Bus Read
signal lb_rdy: 										std_logic;                       -- Local Bus Ready

---------------------------------------------------------------------------------------------------------------------------------------------
-- EPCS DEMO: APB master
signal EPCS_Demo_INIT_APB_S_PCLK: 					std_logic;
signal EPCS_Demo_INIT_APB_S_PRESET_N: 				std_logic;
signal EPCS_Demo_SDIF0_INIT_APB_PENABLE: 			std_logic;
signal EPCS_Demo_SDIF0_INIT_APB_PRDATA: 			std_logic_vector(31 downto 0);
signal EPCS_Demo_SDIF0_INIT_APB_PREADY: 			std_logic;
signal EPCS_Demo_SDIF0_INIT_APB_PSELx: 				std_logic;
signal EPCS_Demo_SDIF0_INIT_APB_PSLVERR: 			std_logic;
signal EPCS_Demo_SDIF0_INIT_APB_PWDATA: 			std_logic_vector(31 downto 0);
signal EPCS_Demo_SDIF0_INIT_APB_PWRITE: 			std_logic;
-- Bus Interface Nets Declarations - Unequal Pin Widths     
signal EPCS_Demo_SDIF0_INIT_APB_PADDR_0_14to2: 		std_logic_vector(14 downto 2);
signal EPCS_Demo_SDIF0_INIT_APB_PADDR: 				std_logic_vector(15 downto 2);
signal POWER_ON_RESET_N:							std_logic;
signal INIT_DONE:									std_logic;
---------------------------------------------------------------------------------------------------------------------------------------------

-- LED:
signal VMELED:										std_logic;
signal DRDYLED:										std_logic;
signal PROGL_int:									std_logic;

-- Contatori per i TICK (inizializzati in modo da avere attese piccole in simulazione)
signal TCNT1: 										std_logic_vector(5 downto 0) := "111000";
signal TCNT2: 										std_logic_vector(7 downto 0) := (others => '0');
signal TCNT3: 										std_logic_vector(7 downto 0) := (others => '0');
signal TICK: 										tick_pulses;

-- temporary
signal RODATA: 										std_logic := '0';

signal srof_dto: 									std_logic_vector (32 downto 0); -- data
signal srof_rd: 									std_logic;                      -- read enable
signal srof_empty:	 								std_logic;                      -- empty
signal evwritten: 									std_logic;
signal ssram_interrupt:								std_logic;

signal l1a_ttc_delay:								std_logic;
signal l1msg_dto:									std_logic_vector(79 downto 0);
signal l1msg_empty:									std_logic;
signal l1msg_rd:									std_logic;
signal acq_on:										std_logic;
signal clear:										std_logic;
signal soft_clear:									std_logic;
signal a1500_reset:                                 std_logic;
signal not_clear:									std_logic;
signal WPULSE: 										reg_wpulse;
signal GBTx_data_fifo_dti_ck:						std_logic_vector(64 downto 0);
signal GBTx_data_fifo_wr_ck:						std_logic;
signal GBTx_data_fifo_almfull:						std_logic;
signal sniff_data:									std_logic_vector(32 downto 0);
signal sniff_valid:									std_logic;
signal sniff_ctrl:									std_logic;

signal clock_selection:								std_logic_vector(1 downto 0);
signal state_clock:									std_logic_vector(1 downto 0);
signal clock_counter:								std_logic_vector(15 downto 0);

signal Debug1:										std_logic;
signal Debug2:										std_logic;
signal DebugS:										std_logic;

signal data_towards_gbtx:							std_logic_vector(83 downto 0);
signal GBTX_DOUT_rise:								std_logic_vector(39 downto 0);
signal GBTX_DOUT_fall:								std_logic_vector(39 downto 0);
signal bunch_reset_delay:							std_logic;
signal count_ali:									std_logic_vector(7 downto 0);
signal busy_from_trm:								std_logic;

file mappingFile: 									text;
signal dumpIt: 										std_logic := '1';
signal fw_date:										std_logic_vector(31 downto 0);

signal linkres_n:									std_logic; -- rclk domain (it can be used to drive FPGA logic reset from CONET)


begin

not_clear		<= not(clear);

version_reg_instance: version_reg 
port map( 
    data_out 	=> fw_date
);
	
---------------------------------------------------------------------------------------------------------------------------------------------
	active_high_reset 			<= not INIT_DONE;
	VCC_net             	 	<= '1';
	GND_net                  	<= '0';

	-- GBTx I2C signals
	GBTX_SCL					<= GBTX_SCLO when (GBTX_SCLO = '0') else 'Z'; 
	GBTX_SDA					<= GBTX_SDAO when (GBTX_SDAO = '0') else 'Z';
	GBTX_SCLI					<= GBTX_SCL;
	GBTX_SDAI					<= GBTX_SDA;
	
	-- NI USB-8451 I2C signals
	EXTSCL						<= AUX_SCLO when (AUX_SCLO = '0') else 'Z'; 
	EXTSDA						<= AUX_SDAO when (AUX_SDAO = '0') else 'Z';
	AUX_SCLI					<= EXTSCL;
	AUX_SDAI					<= EXTSDA;
	
	-- temperature sensors I2C signals
	SCL							<= SCLO when (SCLO = '0') else 'Z'; 
	SDA							<= SDAO when (SDAO = '0') else 'Z';
	SCLI						<= SCL;
	SDAI						<= SDA;
	
	GBTX_TESTOUT_int			<= GBTX_TESTOUT;
	GBTX_RXRDY_int				<= GBTX_RXRDY;
	GBTX_RXDVALID_int			<= GBTX_RXDVALID;
	GBTX_TXRDY_int				<= GBTX_TXRDY;

	GBTX_RESETB					<= GBTX_RESETB_int;
	GBTX_TXDVALID				<= GBTX_TXDVALID_int;
	GBTX_CONFIG					<= GBTX_CONFIG_int;
	 	 
	SDIF0_PRDATA_const_net_0 	<= B"00000000000000000000000000000000";
	SDIF1_PRDATA_const_net_0 	<= B"00000000000000000000000000000000";
	SDIF2_PRDATA_const_net_0 	<= B"00000000000000000000000000000000";
	SDIF3_PRDATA_const_net_0 	<= B"00000000000000000000000000000000";
	
	regs.status(STATUS_PXL_SDN)	<= PXL_SDN;

---------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------
-- DRM2 clocks

	fpgack40_buf: GCLKBUF_DIFF
		port map
		(PADP => FPGACK40_P, PADN => FPGACK40_N, EN => VCC_net, Y => FPGACK_40MHz);
	
	FPGACK80_buf: GCLKBUF_DIFF
		port map
		(PADP => FPGACK80_P, PADN => FPGACK80_N, EN => VCC_net, Y => FPGACK80); 
		
	DCLK00_buf: GCLKBUF_DIFF
	port map
		(PADP => DCLK00_P, PADN => DCLK00_N, EN => VCC_net, Y => gbt_clk_40MHz); 

	CPDMCK40_buf: GCLKBUF_DIFF 														--was INBUF_DIFF
	port map
		(PADP => CPDMCK40_P, PADN => CPDMCK40_N, EN => VCC_net, Y => CPDMCK40); 
		
---------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- GBTx DIN
din_outbuf_instance:
	for i in 0 to 39 generate
		DDR_OUT_inst : DDR_OUT
		port map
		(DR => data_towards_gbtx(2*i+1), DF => data_towards_gbtx(2*i), CLK => gbt_clk_40MHz, EN => '1', ALn => '1', ADn => '1', SLn => '1', SD => '1', Q => GBTX_DIN(i));
		
		outbuf_instance_low: OUTBUF_DIFF
		port map
		(D => GBTX_DIN(i), PADP => DI_P(i), PADN => DI_N(i)); 
	end generate din_outbuf_instance;

-- GBTx DOUT 
dout_inbuf_instance:
	for i in 0 to 39 generate
		inbuf_instance_low: INBUF_DIFF
		port map
		(PADP => DO_P(i), PADN => DO_N(i), Y => GBTX_DOUT(i)); 
		
		DDR_IN_inst : DDR_IN
		port map
		(D => GBTX_DOUT(i), CLK => not(gbt_clk_40MHz), EN => '1', ALn => '1', ADn => '1', SLn => '1', SD => '1', QR => GBTX_DOUT_rise(i), QF => GBTX_DOUT_fall(i));
		
	end generate dout_inbuf_instance;
---------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------
---------- GBTx_interface -------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
GBTx_interface_instance: GBTx_interface
port map
	(
		active_high_reset		=> active_high_reset,
		clear					=> clear, 
		soft_clear				=> soft_clear,
		gbt_clk_40MHz			=> gbt_clk_40MHz,
		FPGACK_40MHz			=> FPGACK_40MHz,
		regs					=> regs,
		acq_on					=> acq_on,
		GBTX_RXDVALID			=> GBTX_RXDVALID_int,
		GBTX_DOUT_rise			=> GBTX_DOUT_rise,
		GBTX_DOUT_fall			=> GBTX_DOUT_fall,
		GBTX_TXDVALID			=> GBTX_TXDVALID_int,
		data_to_gbtx			=> data_towards_gbtx,
		GBTX_RXRDY			    => GBTX_RXRDY_int,	
		GBTx_data_fifo_dti_ck	=> GBTx_data_fifo_dti_ck,
		GBTx_data_fifo_wr_ck	=> GBTx_data_fifo_wr_ck,
		GBTx_data_fifo_almfull  => GBTx_data_fifo_almfull,
		RODATA_ck				=> RODATA,
		busy_from_trm			=> busy_from_trm,
		l1a_ttc_delay			=> l1a_ttc_delay,		
		l1msg_dto				=> l1msg_dto,	
		l1msg_empty				=> l1msg_empty,	
		l1msg_rd				=> l1msg_rd,
		bunch_reset_delay		=> bunch_reset_delay
	);

	RAM_CLK			<= FPGACK_40MHz;
	
---------------------------------------------------------------------------------------------------------------------------------------------
----------EPCS_Demo -------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
EPCS_Demo_instance : EPCS_Demo_sb 
port map(
    FAB_RESET_N         => VCC_net ,                          -- in
    DEVRST_N            => DEVRST_N ,                         -- in
    SDIF0_SPLL_LOCK     => VCC_net ,                          -- in

    --------------------------------                                                 
    ---- APB master interface    
    --------------------------------                                                 
    INIT_APB_S_PRESET_N => EPCS_Demo_INIT_APB_S_PRESET_N ,    -- out
    SDIF0_PADDR         => EPCS_Demo_SDIF0_INIT_APB_PADDR ,   -- out (15:2)
    INIT_APB_S_PCLK     => EPCS_Demo_INIT_APB_S_PCLK ,        -- out
    SDIF0_PENABLE       => EPCS_Demo_SDIF0_INIT_APB_PENABLE , -- out
    SDIF0_PSEL          => EPCS_Demo_SDIF0_INIT_APB_PSELx ,   -- out
    SDIF0_PWRITE        => EPCS_Demo_SDIF0_INIT_APB_PWRITE ,  -- out
    SDIF0_PWDATA        => EPCS_Demo_SDIF0_INIT_APB_PWDATA ,  -- out
    SDIF0_PRDATA        => EPCS_Demo_SDIF0_INIT_APB_PRDATA ,  -- in
    SDIF0_PREADY        => EPCS_Demo_SDIF0_INIT_APB_PREADY ,  -- in
    SDIF0_PSLVERR       => EPCS_Demo_SDIF0_INIT_APB_PSLVERR , -- in

    -- Outputs
    INIT_DONE           => INIT_DONE,                         -- out
    FAB_CCC_GL0         => clk20,                             -- out
    FAB_CCC_GL1         => clk40,                             -- out

    POWER_ON_RESET_N    => POWER_ON_RESET_N,                  -- out
    SDIF_READY          => open,                              -- out
    SDIF0_PHY_RESET_N   => open,                              -- out
    SDIF0_0_CORE_RESET_N=> open,                              -- out
    SDIF0_1_CORE_RESET_N=> open,                              -- out
    FAB_CCC_LOCK        => open,                              -- out
    HPMS_READY          => open,                              -- out
    COMM_BLK_INT        => open,                              -- out
    HPMS_INT_M2F        => open                               -- out
);
		
    ----------------------------------------------------------------------
    -- Bus Interface Nets Assignments - Unequal Pin Widths
    ----------------------------------------------------------------------
    EPCS_Demo_SDIF0_INIT_APB_PADDR_0_14to2 <= EPCS_Demo_SDIF0_INIT_APB_PADDR(14 downto 2);
        
---------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------
---------- I2C_CORE -------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
I2C_CORE_instance : I2C_CORE
    port map( 
        -- Inputs
        AUXSCLI       => AUX_SCLI,
		AUXSDAI       => AUX_SDAI,
		CMHZdef		  => B"00101000",
		Debug1in	  => '1',
		DebugTestEnab => '0',
        GBTXSCLI      => GBTX_SCLI, 
        GBTXSDAI      => GBTX_SDAI, 	
		RESETn		  => not_clear,
		PCLK		  => FPGACK_40MHz, 
        GBTX_TESTOUT  => '0',
        GBTX_RXRDY    => GBTX_RXRDY_int,
        GBTX_RXDVALID => GBTX_RXDVALID_int,
        GBTX_TXRDY    => GBTX_TXRDY_int,
        GENa          => GENa,
        GWRa          => GWRa,
        SELI2Cdef     => '0',					-- '1' --> NI-8451, '0' --> A1500 for I2C control
        GDIa          => GDIa,
        GADDa         => GADDa,
		PSM_SCK		  => PSM_SCK,
		PSM_SO		  => PSM_SO,
		PSM_SP0		  => PSM_SP0,
		PSM_SP1		  => PSM_SP1,
		PXL_SDN		  => PXL_SDN,
		SCLI		  => SCLI,
		SDAI		  => SDAI,					
        -- Outputs
        AUXSCLO       => AUX_SCLO, 
		AUXSDAO       => AUX_SDAO, 
		CONET_DISAB   => open,					-- lvSFP_TXDISAB now driven by CAEN_LINK
		Debug1		  => Debug1,
		Debug2		  => Debug2,
		DebugS		  => DebugS,
		EFUSEENAB	  => lvEFUSEENAB,
		EFUSESYNC	  => EFUSESYNC,
        GBTXSCLO      => GBTX_SCLO, 
        GBTXSDAO      => GBTX_SDAO, 
        GBTX_RESETB   => GBTX_RESETB_int,
		GBTX_TXDVALID => open,
        GBTX_CONFIG   => GBTX_CONFIG_int,
        GDOa          => GDOa,
		P1uS		  => open,
		PSM_SI		  => PSM_SI,
		PXL_OFF		  => open,					-- PXL_OFF now driven by CAEN_LINK
		SCLO		  => SCLO,
		SDAO		  => SDAO,
		SERDES_SDN	  => SERDES_SDN,			-- earlier it was: 		SERDES_SDN <= regs.pwr_ctrl(PC_AVAGO_OFF);
		CLOCKSEL1	  => open,
		CLOCKSEL2	  => open
        );

---------------------------------------------------------------------------------------------------------------------------------------------
---------- vme_int --------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------   
vme_int_instance: vme_int
   port map(
      FPGACK_40MHz 			=> FPGACK_40MHz,
      active_high_reset 	=> active_high_reset,
	  clear					=> clear,
	  soft_clear			=> soft_clear,
      a1500_reset           => a1500_reset,
	  fw_date				=> fw_date,

	  -- local bus
      lb_address    		=> lb_address,
      lb_wdata      		=> lb_wdata,
      lb_rdata      		=> lb_rdata,
      lb_wr         		=> lb_wr,
      lb_rd         		=> lb_rd,  
      lb_rdy       			=> lb_rdy,
    
	  vme_info				=> vme_info,
      regs          		=> regs,
	  
	  GBTx_data_fifo_dti	=> GBTx_data_fifo_dti_ck,	
	  GBTx_data_fifo_wr		=> GBTx_data_fifo_wr_ck,	
	  GBTx_data_fifo_almfull	=> GBTx_data_fifo_almfull,
	  l1a_ttc_delay			=> l1a_ttc_delay,
	  l1msg_dto				=> l1msg_dto,
	  l1msg_empty			=> l1msg_empty,
	  l1msg_rd				=> l1msg_rd,
	  RODATA				=> RODATA,		-- temporary as a register from CONET/A1500
	  acq_on				=> acq_on,
	  bunch_reset_delay		=> bunch_reset_delay,
	  
	  sniff_data			=> sniff_data,
	  sniff_valid			=> sniff_valid,
	  sniff_ctrl			=> sniff_ctrl,
	  
	  GDI  					=> GDOa,
      GDO  					=> GDIa,
      GWR  					=> GWRa,
      GEN  					=> GENa,
      GADD 					=> GADDa,

	  -- VME interface
	  VAD 					=> VAD, 		
	  VDB 					=> VDB, 		
	  AML 					=> AML, 		
	  ASL 					=> ASL, 		
	  DS0L 					=> DS0L, 		
	  DS1L 					=> DS1L, 		
	  WRITEL 				=> WRITEL, 	
	  LWORDB 				=> LWORDB, 	
	  DTACKB 				=> DTACKB, 	
	  BERRB 				=> BERRB, 	
	  BERRL 				=> BERRL, 	
	  IACKL 				=> IACKL, 	
	  IRQB1		 			=> IRQB1,		
	  NOEDTW 				=> NOEDTW, 	
	  NOEDTR 				=> NOEDTR, 	
	  NOEADW 				=> NOEADW, 	
	  NOEADR 				=> NOEADR, 	
	  NOEMAS 				=> NOEMAS, 	
	  NOEDRDY 				=> NOEDRDY, 	
	  NOEFAULT				=> NOEFAULT,
	  -- LED
	  VMELED				=> VMELED,
	  DRDYLED				=> DRDYLED,
	  -- P2 signals
	  L0					=> lvL0,
	  L1A					=> lvL1A,
	  L1R					=> lvL1R,
	  L2A					=> lvL2A,
	  L2R					=> lvL2R,
	  BUNCH_RES				=> BUNCH_RES, 				  
	  EVENT_RES				=> EVENT_RES, 				       
	  SPULSEL0				=> SPULSEL0,      
	  SPULSEL1				=> SPULSEL1, 				        
	  SPULSEL2				=> SPULSEL2, 	
	  busy_from_trm			=> busy_from_trm,
	  CPDM_FCLKL			=> lvCPDM_FCLKL,
	  CPDM_SCLKB			=> lvCPDM_SCLKB,
	  PULSETGLL				=> PULSETGLL,
	  LTMLTB				=> LTMLTB,
	  SPSEOL				=> SPSEOL,
	  SPSEIB				=> SPSEIB,
	  SPDO					=> lvSPD0,
	  
	  TICK					=> TICK,
	  WPULSE				=> WPULSE,
	  PROGL					=> PROGL_int
	  );

---------------------------------------------------------------------------------------------------------------------------------------------
---------- rod_sniffer ----------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------- 	  
rod_sniffer_instance: rod_sniffer
   port map
   (
      active_high_reset 	=> active_high_reset,
	  clear					=> clear,
	  soft_clear			=> soft_clear,
	  FPGACK_40MHz 			=> FPGACK_40MHz,
	  regs          		=> regs,
	  WPULSE				=> WPULSE,
	  acq_on				=> acq_on,

	  -- vme_interface signals
	  sniff_data			=> sniff_data,	
	  sniff_valid			=> sniff_valid,
	  sniff_ctrl			=> sniff_ctrl,
	  
	  -- SROF interface
	  srof_dto				=> srof_dto,	
	  srof_rd				=> srof_rd,	
	  srof_empty			=> srof_empty,
	  evwritten				=> evwritten,	
	  ssram_interrupt		=> ssram_interrupt,

	  -- SSRAM interface
	  ssram_D 				=> RAM_D, 
	  ssram_A 	            => RAM_A, 
	  ssram_WE             	=> RAM_WEN,
	  ssram_OE             	=> RAM_OEN,
	  ssram_LD            	=> RAM_LDN,
	  ssram_CE		        => RAM_CSN
	);
	
---------------------------------------------------------------------------------------------------------------------------------------------
---------- CAEN_LINK ------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------- 		
CAEN_LINK_instance : CAEN_LINK
port map(

    reset    			=> active_high_reset,
	clear				=> clear,
	soft_clear			=> soft_clear,
    a1500_reset         => a1500_reset,
    clk40      			=> FPGACK_40MHz, 
	linkres_n			=> linkres_n,

    ---------------------------------------------------------------------------------------
    -- SCL - CONET (A2818/A3818)
    ---------------------------------------------------------------------------------------   
    REFCLK0_N  			=> REFCLK0_N,
    REFCLK0_P  			=> REFCLK0_P,
                            
    RXD0_N     			=> RXD0_N,
    RXD0_P     			=> RXD0_P,
    RXD1_N     			=> RXD1_N,
    RXD1_P     			=> RXD1_P,
    RXD2_N     			=> RXD2_N,
    RXD2_P     			=> RXD2_P,
    RXD3_N    			=> RXD3_N,
    RXD3_P     			=> RXD3_P,
                        
    TXD0_N     			=> TXD0_N,
    TXD0_P     			=> TXD0_P,
    TXD1_N     			=> TXD1_N,
    TXD1_P     			=> TXD1_P,
    TXD2_N     			=> TXD2_N,
    TXD2_P     			=> TXD2_P,
    TXD3_N     			=> TXD3_N,
    TXD3_P     			=> TXD3_P,
                             
    LED1       			=> open,
    LED2       			=> SCLLED2,
    SFP_TXDISAB 		=> lvSFP_TXDISAB, 

    ---------------------------------------------------------------------------------------                                               
     ---- APB slave interface    
     ---------------------------------------------------------------------------------------                                                 
     APB_S_PRESET_N   	=> EPCS_Demo_INIT_APB_S_PRESET_N ,    -- in
     APB_S_PADDR      	=> EPCS_Demo_SDIF0_INIT_APB_PADDR_0_14to2 , -- in
     APB_S_PCLK       	=> EPCS_Demo_INIT_APB_S_PCLK ,        -- in
     APB_S_PENABLE    	=> EPCS_Demo_SDIF0_INIT_APB_PENABLE , -- in
     APB_S_PSEL       	=> EPCS_Demo_SDIF0_INIT_APB_PSELx ,   -- in
     APB_S_PWRITE     	=> EPCS_Demo_SDIF0_INIT_APB_PWRITE ,  -- in
     APB_S_PWDATA     	=> EPCS_Demo_SDIF0_INIT_APB_PWDATA ,  -- in
     APB_S_PRDATA     	=> EPCS_Demo_SDIF0_INIT_APB_PRDATA ,  -- out
     APB_S_PREADY     	=> EPCS_Demo_SDIF0_INIT_APB_PREADY ,  -- out
     APB_S_PSLVERR    	=> EPCS_Demo_SDIF0_INIT_APB_PSLVERR,  -- out

    
    ---------------------------------------------------------------------------------------
    -- PXL (A1500 - Ethernet) -- HACK: pin assegnati a GPIO della scheda di sviluppo
    ---------------------------------------------------------------------------------------
    --RMT_RESET  : in  std_logic;                       -- Reset dalla A1500 verso la DRM (not used)
    PXL_RESET  			=> PXL_RESET,
    PXL_CS     			=> PXL_CS   ,
    PXL_RD     			=> PXL_RD   ,
    PXL_WR     			=> PXL_WR   ,
    PXL_D      			=> PXL_D    ,
    PXL_A      			=> PXL_A,
    PXL_IRQ    			=> PXL_IRQ,
    PXL_IO     			=> PXL_IO(0),
	PXL_OFF    			=> PXL_OFF,              
               
    ---------------------------------------------------------------------------------------
    -- CAEN Synchronous Local Bus Interface 
    lb_address    		=> lb_address,    --: out    std_logic_vector (31 downto 0);  -- Local Bus Address
    lb_wdata      		=> lb_wdata,      --: out    std_logic_vector (32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_wr)
    lb_rdata      		=> lb_rdata,      --: in     std_logic_vector (32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_rd)
    lb_wr         		=> lb_wr,         --: out    std_logic;                       -- Local Bus Write
    lb_rd         		=> lb_rd,         --: out    std_logic;                       -- Local Bus Read
    lb_rdy        		=> lb_rdy,        --: in     std_logic;                       -- Local Bus Ready (ack.)
     
	vme_info	  		=> vme_info,
    regs          		=> regs,        
               
    ---------------------------------------------------------------------------------------
    -- SROF
    ---------------------------------------------------------------------------------------
    -- SROF FIFO output
    srof_dto     		=> srof_dto,
    srof_rd      		=> srof_rd,
    srof_empty   		=> srof_empty,
    evwritten   	 	=> evwritten,
	ssram_interrupt 	=> ssram_interrupt,
               
    ---------------------------------------------------------------------------------------
    -- SPARE
    ---------------------------------------------------------------------------------------

    SPARE0     			=> open,
    SPARE1     			=> open,
    SPARE2     			=> open,
    SPARE3     			=> open,
    SPARE4     			=> open,
    SPARE5     			=> open,
    SPARE6     			=> open,
    SPARE7     			=> open,
    SPARE8     			=> open
    );

-----------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------
  -- TICK
  -- one tick is a pulse lasting 1 CLK period, which is repeated every N periods
---------------------------------------------------------------------------------------------------------------------------------------------
  -- T64:  Period=Tclk*64  (circa 1.6us a 40MHz)
  -- T16K: Period=Tclk*16K (circa 410us a 40MHz)
  -- T4M:  Period=Tclk*4M  (circa 104ms a 40MHz)
  ---------------------------------------------------------------------------------------------------------------------------------------------
  process(FPGACK_40MHz)
  begin
    if(rising_edge(FPGACK_40MHz)) then
      TCNT1 <= TCNT1 + 1;
      if TICK(T64) = '1' then
        TCNT2 <= TCNT2 + 1;
      end if;
      if TICK(T16K) = '1' then
        TCNT3 <= TCNT3 + 1;
	  end if;
      if TCNT1 = "000000" then
        TICK(T64) <= '1';
      else
        TICK(T64) <= '0';
      end if;

      if TCNT2 = "00000000" and TCNT1 = "000000" then
        TICK(T16K) <= '1';
      else
        TICK(T16K) <= '0';
      end if;

      if TCNT3 = "00000000" and TCNT2 = "00000000" and TCNT1 = "000000" then
        TICK(T4M) <= '1';
      else
        TICK(T4M) <= '0';
      end if;
    end if;
  end process;

	---------------------------------------------------------------------------------------------------------------------------------------------
	-- clock selection begin --------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------
	
	clock_selection_process: process(clk40, INIT_DONE)
	begin
		if(INIT_DONE = '0') then	
			clock_selection	<= "01";					-- local oscillator
			state_clock		<= "00";
			clock_counter	<= (others => '0');
		elsif(rising_edge(clk40)) then
			if(state_clock = "00") then					-- wait for 104 us 
				if(clock_counter = x"FFFF" and regs.clocksel(CLOCKSEL_RESTART_CLK_CHOICE) = '0') then
					state_clock	<= "01";
				else	
					state_clock	<= "00";
				end if;
				clock_selection	<= "01";				-- local oscillator
				clock_counter	<= clock_counter + 1;
			elsif(state_clock = "01") then				-- wait for 104 us 
				if(clock_counter = x"FFFF") then
					state_clock	<= "10";
				else	
					state_clock	<= "01";
				end if;
				clock_selection	<= "01";				-- local oscillator
				clock_counter	<= clock_counter + 1;
			elsif(state_clock = "10") then
				if(lvCLKLOS = '0' and regs.clocksel(CLOCKSEL_PRIORITY_LHCCLK) = '1') then			-- if regs.clocksel(CLOCKSEL_PRIORITY_LHCCLK) = '1', priority is given to LHC clock
					clock_selection		<= "10";		-- clock from LHC
				elsif(GBTX_RXRDY_int = '1' and regs.clocksel(CLOCKSEL_PRIORITY_GBTCLK) = '1') then	-- if regs.clocksel(CLOCKSEL_PRIORITY_GBTCLK) = '1', priority is given to GBT clock
					clock_selection		<= "00";		-- clock from GBTx PS
				else	
					clock_selection		<= "01";		-- local oscillator
				end if;
				state_clock		<= "11";
				clock_counter	<= (others => '0');
			else
				if(regs.clocksel(CLOCKSEL_RESTART_CLK_CHOICE) = '1') then
					state_clock	<= "00";
				elsif(lvCLKLOS = '1' and clock_selection = "10") then			-- losing LHC clock
					state_clock	<= "00";
				elsif(GBTX_RXRDY_int = '0' and clock_selection = "00") then		-- losing GBT clock
					state_clock	<= "00";
				else
					state_clock	<= "11";
				end if;
				clock_counter	<= (others => '0');
			end if;
		end if;
	end process clock_selection_process;
	
clk_sel1						<= clock_selection(0);
clk_sel2						<= clock_selection(1);

regs.status(STATUS_CLK_SRC)		<= clock_selection(0); 
regs.status(STATUS_CLK_EXT)		<= clock_selection(1);
regs.status(STATUS_CLK_LHC)		<= lvCLKLOS;

	---------------------------------------------------------------------------------------------------------------------------------------------
	-- aliclk management begin ------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------

	aliclk_process: process(CPDMCK40, INIT_DONE)
	begin
		if(INIT_DONE = '0') then
			count_ali					<= (others => '0');
			regs.status(STATUS_CLK_ALI)	<= '0';
		elsif(rising_edge(CPDMCK40)) then
			if(count_ali = x"FF") then
				count_ali					<= (others => '1');
				regs.status(STATUS_CLK_ALI)	<= '1';
			else
				count_ali					<= count_ali + 1;
				regs.status(STATUS_CLK_ALI)	<= '0';
			end if;
		end if;
	end process aliclk_process;
	
	---------------------------------------------------------------------------------------------------------------------------------------------
	-- aliclk management end --------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------
	
	---------------------------------------------------------------------------------------------------------------------------------------------
	-- clock selection end ----------------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------------------------------

-- Reset signals
SYSRESL    	<= '1' when active_high_reset = '1' or regs.ctrl(CTRL_SYSRES) = '1' else '0';  -- active high (after an inverting BJT)
	
-- A1500	
PXL_IO(1)	<= 'Z';

-- front panel LEDs
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RUN LED
FPGALED1			<= RODATA when regs.fp_leds(FP_LEDS_TEST) = '0' else regs.fp_leds(FP_LEDS_1);			-- ON when in acquisition
-- TRG LED
FPGALED2			<= not DRDYLED when regs.fp_leds(FP_LEDS_TEST) = '0' else regs.fp_leds(FP_LEDS_2);	
-- VME LED
FPGALED3			<= not VMELED when regs.fp_leds(FP_LEDS_TEST) = '0' else regs.fp_leds(FP_LEDS_3); 
-- BSY LED
FPGALED4			<= not IRQB1 when regs.fp_leds(FP_LEDS_TEST) = '0' else regs.fp_leds(FP_LEDS_4);		-- the busy LED turns ON when the TRMs are busy (new busy is IRQB1)
-- PRG LED
PROGL				<= PROGL_int when regs.fp_leds(FP_LEDS_TEST) = '0' else regs.fp_leds(FP_LEDS_PROGL);

-- CLOCK LED:
-- 			RED: 	local clock
--			GREEN:	LHC clock
--			OFF:	GBTx clock
CLKLEDR				<= clock_selection(0); 
CLKLEDG				<= clock_selection(1); 
--------------------------------------------------------------------------------------------------------------------------------------------------------------

-- front panel LEMOs
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- I/O 1
lvFPGAIO1 			<= regs.fp_lemo(6)  when (regs.fp_lemo(4) = '1' AND regs.fp_lemo(15) = '1' AND regs.fp_lemo(8) = '0') else 
					   FPGACK_40MHz     when (regs.fp_lemo(4) = '1' AND regs.fp_lemo(15) = '1' AND regs.fp_lemo(8) = '1') else 
					   GBTX_TESTOUT_int when (regs.fp_lemo(4) = '1' AND regs.fp_lemo(15) = '0') else 
					   'Z';
					   
-- I/O 2
lvFPGAIO2			<= regs.fp_lemo(7) 	                          when (regs.fp_lemo(5) = '1' AND regs.fp_lemo(8) = '0' AND regs.fp_lemo(15) = '1') else 
					   bunch_reset_delay						  when (regs.fp_lemo(5) = '1' AND regs.fp_lemo(8) = '1' AND regs.fp_lemo(15) = '1') else
					   (lvSFP_LOS and lvSFP_TXFAULT and lvCLKLOS and PXL_IO(1) and busyb) when (regs.fp_lemo(5) = '1' AND regs.fp_lemo(15) = '0') else 
					   'Z';

regs.fp_lemo_in(0)	<= lvFPGAIO1;
regs.fp_lemo_in(1)	<= lvFPGAIO2;

FPGADIR1			<= regs.fp_lemo(4);		-- (DIR = '0' --> input, DIR = '1' --> output)
FPGADIR2			<= regs.fp_lemo(5);
lvFPGA_SCOPE		<= CPDMCK40 	 when regs.fp_lemo(0) = '1' else	-- ALICLK
					   FPGACK80 	 when regs.fp_lemo(1) = '1' else	-- GBTx phase shifter 0
					   FPGACK_40MHz  when regs.fp_lemo(2) = '1' else	-- GBTx phase shifter 7 OR local clock OR LHC clock
					   gbt_clk_40MHz when regs.fp_lemo(3) = '1' else	-- GBTx E-Link clock (DCLK)
					   IRQB1	     when regs.fp_lemo(9) = '1' else
					   PXL_IO(0)	 when regs.fp_lemo(10) = '1' else
					   PXL_IO(1)	 when regs.fp_lemo(11) = '1' else
					   '1';
--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
   -- begin header generator for software tools----------
	dump_vars: process(dumpIt)
	constant DRMMAP: string := "#include " & '"' & "drmmap.h" & '"';
	variable fline: line;
	begin
		  if(dumpIt = '1') then
			  file_open(mappingFile,"./drmreg.h", WRITE_MODE);
			  write(fline,string'("// DRM2 rev2.0 firmware registers"));
			  writeline(mappingFile,fline);

			  write(fline,string'("// This is a generated file, do not edit!"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_STATUS")); write(fline, HT); write(fline, HT); write(fline, HT); 
			  write(fline, "0x" & str(conv_integer(A_STATUS),16)&"");
			  write(fline,string'("  // 32-bit R   - Status Register"));
			  writeline(mappingFile,fline);
			  
				  -- STATUS bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// STATUS register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_RO_MODE  ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_RO_MODE))),16)));
				  write(fline, HT); write(fline,string'("  // Readout Mode (1) / Config Mode (0)"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_RUN      ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_RUN))),16)));
				  write(fline, HT); write(fline,string'("  // SOD received"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_CPDM_SCLK")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_CPDM_SCLK))),16)));
				  write(fline, HT); write(fline,string'("  // CPDM Clock Status: 1=ExtClk (fibre)  0=IntClk (osc)"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_CLK_SRC  ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_CLK_SRC))),16)));
				  write(fline, HT); write(fline,string'("  // clock source"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_LTM_LTRG ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_LTM_LTRG))),16)));
				  write(fline, HT); write(fline,string'("  // LTM Local Trigger (from P2)"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_CLK_LHC  ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_CLK_LHC))),16)));
				  write(fline, HT); write(fline,string'("  // LHC clock presence"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_BUSY     ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_BUSY))),16)));
				  write(fline, HT); write(fline,string'("  // TRM busy (irq1b)"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_ERO_TO   ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_ERO_TO))),16)));
				  write(fline, HT); write(fline,string'("  // Event Readout Timeout"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_CLK_ALI   ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_CLK_ALI))),16)));
				  write(fline, HT); write(fline,string'("  // ALICLK (input from CPDM) presence"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_CLK_EXT    ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_CLK_EXT))),16)));
				  write(fline, HT); write(fline,string'("  // clock source"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_SC_SDN   ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_SC_SDN))),16)));
				  write(fline, HT); write(fline,string'("  // CONET shutdown"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_PXL_SDN  ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_PXL_SDN))),16)));
				  write(fline, HT); write(fline,string'("  // A1500 shutdown"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_SPSEI    ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_SPSEI))),16)));
				  write(fline, HT); write(fline,string'("  // Spare Input from P2"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_PULSEP   ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_PULSEP))),16)));
				  write(fline, HT); write(fline,string'("  // Pulse from CTRL on front panel"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_NO_DATA     ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_NO_DATA))),16)));
				  write(fline, HT); write(fline,string'("  // active when all triggers received by DRM2 have been served"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define STATUS_EVREADY  ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(STATUS_EVREADY))),16)));
				  write(fline, HT); write(fline,string'("  // event ready to be readout via CONET2"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------
			  
			  write(fline,string'("#define A_ROC_TDATA")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_ROC_TDATA),16)&"");
			  write(fline,string'("  // 16-bit R/W - ROC Test Data"));
			  writeline(mappingFile,fline);
			  
				  -- ROC_TDATA bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// ROC_TDATA register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TDATA_PULSE0    ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TDATA_PULSE0))),16)));
				  write(fline, HT); write(fline,string'("  // TDATA pulse 0"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TDATA_PULSE1    ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TDATA_PULSE1))),16)));
				  write(fline, HT); write(fline,string'("  // TDATA pulse 1"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TDATA_PULSE2    ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TDATA_PULSE2))),16)));
				  write(fline, HT); write(fline,string'("  // TDATA pulse 2"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TDATA_LTM_PTGL  ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TDATA_LTM_PTGL))),16)));
				  write(fline, HT); write(fline,string'("  // TDATA LTM PTGL"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TDATA_SPSEO     ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TDATA_SPSEO))),16)));
				  write(fline, HT); write(fline,string'("  // TDATA SPSEO"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TDATA_BUSYP     ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TDATA_BUSYP))),16)));
				  write(fline, HT); write(fline,string'("  // TDATA BUSYP"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------
			  
			  write(fline,string'("#define A_ROC_FWREV")); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_ROC_FWREV),16)&"");
			  write(fline,string'("  // 16-bit R   - Firmware Revision for Igloo2 FPGA"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
			  write(fline,string'("#define A_CTRL_SET")); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_CTRL_S),16)&"");
			  write(fline,string'("  // 32-bit R/W - Control Register Set"));
			  writeline(mappingFile,fline);
			  
				  -- CTRL_SET bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// CTRL_SET register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL_SYSRES        ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL_SYSRES))),16)));
				  write(fline, HT); write(fline,string'("  // Sysreset"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL_CPDM_FCLK     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL_CPDM_FCLK))),16)));
				  write(fline, HT); write(fline,string'("  // CPDM FCLK"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL_TEST_EVENT    ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL_TEST_EVENT))),16)));
				  write(fline, HT); write(fline,string'("  // Test event"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL_PROG          ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL_PROG))),16)));
				  write(fline, HT); write(fline,string'("  // PROG Line (Igloo2 Config)"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL_PULSE_POLARITY")); write(fline, HT); write(fline, HT);  write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL_PULSE_POLARITY))),16)));
				  write(fline, HT); write(fline,string'("  // Pulse Polarity: 0 = active low; 1 = Active high (old CPDM))"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL_SPDO          ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL_SPDO))),16)));
				  write(fline, HT); write(fline,string'("  // Spare Diff Out on P2"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL_IO_TEST       ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL_IO_TEST))),16)));
				  write(fline, HT); write(fline,string'("  // I/O test mode"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL_SR_TEST       ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL_SR_TEST))),16)));
				  write(fline, HT); write(fline,string'("  // test SSRAM"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL_RDH_VERSION   ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL_RDH_VERSION))),16)));
				  write(fline, HT); write(fline,string'("  // when 1 RDH v5, when 0 RDH v4"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------

			  write(fline,string'("#define A_CTRL2")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);        
			  write(fline,"0x" & str(conv_integer(A_CTRL2),16)&"");
			  write(fline,string'(" // 16-bit R/W - Control Register 2"));
			  writeline(mappingFile,fline);
			  
				  -- CTRL2 bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// CTRL2 register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL2_MANDRAKE     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL2_MANDRAKE))),16)));
				  write(fline, HT); write(fline,string'("  // MANDRAKE mode"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL2_MANDRAKE_GO     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL2_MANDRAKE_GO))),16)));
				  write(fline, HT); write(fline,string'("  // start MANDRAKE mode"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL2_TRMWAIT_4 ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL2_TRMWAIT_4))),16)));
				  write(fline, HT); write(fline,string'("  // TRM wait bit 4"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL2_TRMWAIT_5 ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL2_TRMWAIT_5))),16)));
				  write(fline, HT); write(fline,string'("  // TRM wait bit 5"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL2_TRMWAIT_6 ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL2_TRMWAIT_6))),16)));
				  write(fline, HT); write(fline,string'("  // TRM wait bit 6"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL2_SET_PREPULSE")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL2_SET_PREPULSE))),16)));
				  write(fline, HT); write(fline,string'("  // set prepulse for P2 signal test"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL2_SETRDMODE ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL2_SETRDMODE))),16)));
				  write(fline, HT); write(fline,string'("  // set RO_MODE"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL2_DISABLE_RO ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL2_DISABLE_RO))),16)));
				  write(fline, HT); write(fline,string'("  // Disable TRM readout (but trigger from GBT still active)"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL2_SR_IRQEN  ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL2_SR_IRQEN))),16)));
				  write(fline, HT); write(fline,string'("  // Enable Interrupt from SSRAM"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CTRL2_TRIG_IGNORE  ")); write(fline, HT); write(fline, HT); write(fline, HT); 
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CTRL2_TRIG_IGNORE))),16)));
				  write(fline, HT); write(fline,string'("  // Ignore triggers (TOF special triggers or physics triggers)"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------	
			  
			  write(fline,string'("#define A_CTRL_CLEAR")); write(fline, HT); write(fline, HT);        
			  write(fline,"0x" & str(conv_integer(A_CTRL_C),16)&"");
			  write(fline,string'("  // 32-bit W   - Control Register Clear"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
			  write(fline,string'("#define A_SHOT")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_SHOT),16)&"");
			  write(fline,string'("  // 11-bit W   - SW commands (trigger, clear, etc...)"));
			  writeline(mappingFile,fline);
			  
				  -- SHOT bits definition -------------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// SHOT register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define SHOT_TEST         ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(SHOT_TEST))),16)));
				  write(fline, HT); write(fline,string'("  // Pulse on signals enabled by TEST SIGNAL MASK"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define SHOT_SOFT_CLEAR   ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(SHOT_SOFT_CLEAR))),16)));
				  write(fline, HT); write(fline,string'("  // soft clear"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define SHOT_CLEAR        ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(SHOT_CLEAR))),16)));
				  write(fline, HT); write(fline,string'("  // hard clear"));
				  writeline(mappingFile,fline);
                  write(fline, HT); write(fline,string'("#define SHOT_A1500_RESET  ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(SHOT_A1500_RESET))),16)));
				  write(fline, HT); write(fline,string'("  // A1500 reset (causes A1500 reboot)"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define SHOT_WRR          ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(SHOT_WRR))),16)));
				  write(fline, HT); write(fline,string'("  // writes one test word in ssram (also writing ROC_TDATA)"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define SHOT_LTM_PT       ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(SHOT_LTM_PT))),16)));
				  write(fline, HT); write(fline,string'("  // LTM Pulse Toggle (on P2)"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------
			  
			  write(fline,string'("#define A_DRM_ID")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_DRM_ID),16)&"");
			  write(fline,string'("  // 32-bit R/W - DRM ID-Number"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_DEBUG")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_DEBUG),16)&"");
			  write(fline,string'("  // 16-bit R/W - Debug"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
			  write(fline,string'("#define A_DEBUG1")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_DEBUG1),16)&"");
			  write(fline,string'("  // 16-bit R - Debug1: isram_nw(14-1) & isram_full_debug & vtimeout_debug"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
			  write(fline,string'("#define A_DEBUG2")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_DEBUG2),16)&"");
			  write(fline,string'("  // 16-bit R - Debug2: orbit value at SOX"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
			  write(fline,string'("#define A_RO_ENABLE")); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_RO_ENABLE),16)&"");
			  write(fline,string'("  // 32-bit R/W - TRM Readout Enable"));
			  writeline(mappingFile,fline);
			  
				  -- RO_ENABLE bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// RO_ENABLE register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_1     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_1))),16)));
				  write(fline, HT); write(fline,string'("  // LTM in slot 2"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_2     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_2))),16)));
				  write(fline, HT); write(fline,string'("  // TRM in slot 3"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_3     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_3))),16)));
				  write(fline, HT); write(fline,string'("  // TRM in slot 4"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_4     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_4))),16)));
				  write(fline, HT); write(fline,string'("  // TRM in slot 5"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_5     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_5))),16)));
				  write(fline, HT); write(fline,string'("  // TRM in slot 6"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_6     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_6))),16)));
				  write(fline, HT); write(fline,string'("  // TRM in slot 7"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_7     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_7))),16)));
				  write(fline, HT); write(fline,string'("  // TRM in slot 8"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_8     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_8))),16)));
				  write(fline, HT); write(fline,string'("  // TRM in slot 9"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_9     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_9))),16)));
				  write(fline, HT); write(fline,string'("  // TRM in slot 10"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_10    ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_10))),16)));
				  write(fline, HT); write(fline,string'("  // TRM in slot 11"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define RO_ENABLE_11    ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RO_ENABLE_11))),16)));
				  write(fline, HT); write(fline,string'("  // TRM in slot 12"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------
			  
			  write(fline,string'("#define A_TS_MASK")); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_TS_MASK),16)&"");
			  write(fline,string'("  // 32-bit R/W - Test Signal Mask"));
			  writeline(mappingFile,fline);
			  
				  -- TS_MASK bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// TS_MASK register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TS_MASK_CPDM_P0 ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TS_MASK_CPDM_P0))),16)));
				  write(fline, HT); write(fline,string'("  // CPDM Pulse 0"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TS_MASK_CPDM_P1 ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TS_MASK_CPDM_P1))),16)));
				  write(fline, HT); write(fline,string'("  // CPDM Pulse 1"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TS_MASK_CPDM_P2 ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TS_MASK_CPDM_P2))),16)));
				  write(fline, HT); write(fline,string'("  // CPDM Pulse 2"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TS_MASK_L0      ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TS_MASK_L0))),16)));
				  write(fline, HT); write(fline,string'("  // L0"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TS_MASK_L1A     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TS_MASK_L1A))),16)));
				  write(fline, HT); write(fline,string'("  // L1A"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TS_MASK_L1R     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TS_MASK_L1R))),16)));
				  write(fline, HT); write(fline,string'("  // L1R"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TS_MASK_L2A     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TS_MASK_L2A))),16)));
				  write(fline, HT); write(fline,string'("  // L2A"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TS_MASK_L2R     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TS_MASK_L2R))),16)));
				  write(fline, HT); write(fline,string'("  // L2R"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TS_MASK_EVRES   ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TS_MASK_EVRES))),16)));
				  write(fline, HT); write(fline,string'("  // Event reset"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TS_MASK_BNCRES  ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TS_MASK_BNCRES))),16)));
				  write(fline, HT); write(fline,string'("  // Bunch reset"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------
				  
			  
			  write(fline,string'("#define A_ssram_ADL")); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_ssram_ADL),16)&"");
			  write(fline,string'("  // 32-bit R/W - ssram Address[15:0] per test mode"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_ssram_DTL")); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_ssram_DTL),16)&"");
			  write(fline,string'("  // 16-bit R   - ssram Data[15:0] per test mode"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_ssram_DTH")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_ssram_DTH),16)&"");
			  write(fline,string'("  // 16-bit R   - ssram Data[31:16] per test mode"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_MAX_TRM_HIT_CNT")); write(fline, HT);        
			  write(fline,"0x" & str(conv_integer(A_MAX_TRM_HIT_CNT),16)&"");
			  write(fline,string'("  // 16-bit RW  - max TRM hit count"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
			  write(fline,string'("#define A_P2_SIG")); write(fline, HT);        
			  write(fline,"0x" & str(conv_integer(A_P2_SIG),16)&"");
			  write(fline,string'("  // 32-bit RW  - P2 signals reshuffling"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); 
			  
			  write(fline,string'("#define A_TRUE_TRM_READY")); write(fline, HT);        
			  write(fline,"0x" & str(conv_integer(A_TRUE_TRM_READY),16)&"");
			  write(fline,string'("  // 16-bit R  - DRDY calculated by the DRM2 during a run"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); 
			  
			  write(fline,string'("#define A_CLOCKSEL")); write(fline, HT); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_CLOCKSEL),16)&"");
			  write(fline,string'("  // 16-bit R/W - Clock selection register"));
			  writeline(mappingFile,fline);
			  
				  -- CLOCK_SEL bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// CLOCK_SEL register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CLOCKSEL_RESTART_CLK_CHOICE")); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CLOCKSEL_RESTART_CLK_CHOICE))),16)));
				  write(fline, HT); write(fline,string'("  // restart clock choice"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CLOCKSEL_PRIORITY_LHCCLK")); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CLOCKSEL_PRIORITY_LHCCLK))),16)));
				  write(fline, HT); write(fline,string'("  // priority to LHC clock"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CLOCKSEL_PRIORITY_GBTCLK")); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CLOCKSEL_PRIORITY_GBTCLK))),16)));
				  write(fline, HT); write(fline,string'("  // priority to GBT clock"));
				  writeline(mappingFile,fline);
                  write(fline, HT); write(fline,string'("#define CLOCKSEL_PRIORITY_LOCCLK")); write(fline, HT);
				  write(fline, HT); write(fline,string'("0x0"));
				  write(fline, HT); write(fline, HT); write(fline,string'("  // priority to local clock"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------		  
			  
			  write(fline,string'("#define A_DRDY")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_DRDY),16)&"");
			  write(fline,string'(" // 16-bit R   - DRDY P2 signals register"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_FAULT")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);        
			  write(fline,"0x" & str(conv_integer(A_FAULT),16)&"");
			  write(fline,string'(" // 16-bit R   - FAULT P2 signals register"));
			  writeline(mappingFile,fline);
              
              write(fline,string'("#define A_TRG_BC_PIPE")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);        
			  write(fline,"0x" & str(conv_integer(A_TRG_BC_PIPE),16)&"");
			  write(fline,string'(" // 16-bit R   - pipeline length on l1a_ttc and bunch_reset"));
			  writeline(mappingFile,fline);
              
              write(fline,string'("#define A_ORBIT_MANDRAKE")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);        
			  write(fline,"0x" & str(conv_integer(A_ORBIT_MANDRAKE),16)&"");
			  write(fline,string'(" // 16-bit R   - orbit mask for readout during mandrake mode"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TRMRO_TO")); write(fline, HT); write(fline, HT); write(fline, HT);       
			  write(fline,"0x" & str(conv_integer(A_TRMRO_TO),16)&"");
			  write(fline,string'(" // 16-bit R/W - TRM readout timeout"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
			  write(fline,string'("#define A_FP_LEDS")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_FP_LEDS),16)&"");
			  write(fline,string'(" // 16-bit R/W - Front-panel LEDs register"));
			  writeline(mappingFile,fline);
			  
				  -- FP_LEDS bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// FP_LEDS register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define FP_LEDS_TEST    ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(FP_LEDS_TEST))),16)));
				  write(fline, HT); write(fline,string'("  // test bit"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define FP_LEDS_1       ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(FP_LEDS_1))),16)));
				  write(fline, HT); write(fline,string'("  // LED 1"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define FP_LEDS_2       ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(FP_LEDS_2))),16)));
				  write(fline, HT); write(fline,string'("  // LED 2"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define FP_LEDS_3       ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(FP_LEDS_3))),16)));
				  write(fline, HT); write(fline,string'("  // LED 3"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define FP_LEDS_4       ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(FP_LEDS_4))),16)));
				  write(fline, HT); write(fline,string'("  // LED 4"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define FP_LEDS_PROGL   ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(FP_LEDS_PROGL))),16)));
				  write(fline, HT); write(fline,string'("  // PROG LED (red)"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------
			  
			  write(fline,string'("#define A_FP_LEMO")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_FP_LEMO),16)&"");
			  write(fline,string'(" // 16-bit R/W - Front-panel out-LEMOs register"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_FP_LEMO_IN")); write(fline, HT); write(fline, HT);       
			  write(fline,"0x" & str(conv_integer(A_FP_LEMO_IN),16)&"");
			  write(fline,string'(" // 16-bit R   - Front-panel in-LEMOs register"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TRIGGER_COUNTER")); write(fline, HT);        
			  write(fline,"0x" & str(conv_integer(A_TRIGGER_COUNTER),16)&"");
			  write(fline,string'(" // 32-bit R   - Trigger counter register"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TDELAY")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_TDELAY),16)&"");
			  write(fline,string'(" // 16-bit R/W - Delay of the trigger after the Test Pulse"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_PULSECNT")); write(fline, HT); write(fline, HT); write(fline, HT);      -- to be checked !!!!!!!!!!!!!!   
			  write(fline,"0x" & str(conv_integer(A_PULSECNT),16)&"");
			  write(fline,string'(" // 16-bit R/W - Pulse counter"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_ROBLT32")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_ROBLT32),16)&"");
			  write(fline,string'(" // 11-bit R/W - Enable readout in BLT32"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
			  write(fline,string'("#define A_RO2ESST")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_RO2ESST),16)&"");
			  write(fline,string'(" // 11-bit R/W - Enable readout in 2eSST"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
			  write(fline,string'("#define A_BER_TEST")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_BER_TEST),16)&"");
			  write(fline,string'(" // 16-bit R/W - Bit Error Rate Test"));
			  writeline(mappingFile,fline);
			  
				  -- BER_TEST bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// BER_TEST register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define BER_LOOP_EN     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(BER_LOOP_EN))),16)));
				  write(fline, HT); write(fline,string'("  // enable GBTx loopback on Igloo2"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define BER_RES_VALUE   ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(BER_RES_VALUE))),16)));
				  write(fline, HT); write(fline,string'("  // reset count_ber value"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define BER_CHECK_EN    ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(BER_CHECK_EN))),16)));
				  write(fline, HT); write(fline,string'("  // enable ber errors counting"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------
			  
			  write(fline,string'("#define A_BER_VALUE")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_BER_VALUE),16)&"");
			  write(fline,string'(" // 16-bit R   - BER counter"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'(" // I2C interface registers"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_I2CSEL")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_I2CSEL),16)&"");
			  write(fline,string'(" // 32-bit R/W - selecting AUX or internal bus to access GBTx I2C"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_AUX_CMHZ")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_AUX_CMHZ),16)&"");
			  write(fline,string'(" // 32-bit R   - clock divider value"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TESTSIGNL")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_TESTSIGNL),16)&"");
			  write(fline,string'(" // 32-bit R/W - test signal selection"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_DEBUGTEST")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_DEBUGTEST),16)&"");
			  write(fline,string'(" // 32-bit R/W - error generation"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_VERSIONP1")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_VERSIONP1),16)&"");
			  write(fline,string'(" // 32-bit R   - I2C firmware version part 1"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_VERSIONP2")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_VERSIONP2),16)&"");
			  write(fline,string'(" // 32-bit R   - I2C firmware version part 2"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'(" // GBT I2C")); -------------------------------------------------------------
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_GI2C_DATA")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GI2C_DATA),16)&"");
			  write(fline,string'(" // 32-bit R/W - I2C GBTX data register to access R/W the GBTx"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_GI2C_ERRN")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GI2C_ERRN),16)&"");
			  write(fline,string'(" // 32-bit R/W - I2C GBTX error register"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_GI2C_STAT")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GI2C_STAT),16)&"");
			  write(fline,string'(" // 32-bit R/W - I2C GBTX control register"));
			  writeline(mappingFile,fline);
              
                  -- GI2C_STAT values definition ---------------------------------------------------------------------------------------------------
                  write(fline, HT); write(fline,string'("// GI2C_STAT values"));
                  writeline(mappingFile,fline);
                      
                  write(fline, HT); write(fline,string'("#define GI2C_STAT_ERROR")); write(fline, HT); write(fline, HT);         
                  write(fline, HT); write(fline,"0x" & str(conv_integer(GI2C_STAT_ERROR),16)&"");
                  write(fline, HT); write(fline,string'(" // 8-bit R - I2C interface error state, need to reset (x)"));
                  writeline(mappingFile,fline);
                  
                  write(fline, HT); write(fline,string'("#define GI2C_STAT_OK")); write(fline, HT); write(fline, HT);        
                  write(fline, HT); write(fline,"0x" & str(conv_integer(GI2C_STAT_OK),16)&"");
                  write(fline, HT); write(fline,string'(" // 8-bit R - I2C interface writing done,FIFO empty, proceed (e)"));
                  writeline(mappingFile,fline);
                  
                  write(fline, HT); write(fline,string'("#define GI2C_STAT_WAIT")); write(fline, HT); write(fline, HT);         
                  write(fline, HT); write(fline,"0x" & str(conv_integer(GI2C_STAT_WAIT),16)&"");
                  write(fline, HT); write(fline,string'(" // 8-bit R - I2C interface busy (b)"));
                  writeline(mappingFile,fline);
                  
                  write(fline, HT); write(fline,string'("#define GI2C_STAT_READ_DATA")); write(fline, HT);         
                  write(fline, HT); write(fline,"0x" & str(conv_integer(GI2C_STAT_READ_DATA),16)&"");
                  write(fline, HT); write(fline,string'(" // 8-bit R - I2C interface data available on FIFO to be read (q)"));
                  writeline(mappingFile,fline);
                  
                  write(fline, HT); write(fline,string'("#define GI2C_STAT_GO_READ")); write(fline, HT);       
                  write(fline, HT); write(fline,"0x" & str(conv_integer(GI2C_STAT_GO_READ),16)&"");
                  write(fline, HT); write(fline,string'(" // 8-bit W - I2C interface command: start reading (r)"));
                  writeline(mappingFile,fline);
                  
                  write(fline, HT); write(fline,string'("#define GI2C_STAT_GO_WRITE")); write(fline, HT);         
                  write(fline, HT); write(fline,"0x" & str(conv_integer(GI2C_STAT_GO_WRITE),16)&"");
                  write(fline, HT); write(fline,string'(" // 8-bit W - I2C interface command: FIFO loaded, start writing (w)"));
                  writeline(mappingFile,fline);
                  
                  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
                  -----------------------------------------------------------------------------------------------------------------------------
			  
			  write(fline,string'("#define A_GI2C_FLAG")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GI2C_FLAG),16)&"");
			  write(fline,string'(" // 32-bit R/W - I2C GBTX signal monitor register"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_GI2C_RADL")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GI2C_RADL),16)&"");
			  write(fline,string'(" // 32-bit R/W - I2C GBTX address register (LSB)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_GI2C_RADH")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GI2C_RADH),16)&"");
			  write(fline,string'(" // 32-bit R/W - I2C GBTX address register (MSB)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_GI2C_RNML")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GI2C_RNML),16)&"");
			  write(fline,string'(" // 32-bit R/W - I2C GBTX number of registers to be accessed (LSB)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_GI2C_RNMH")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GI2C_RNMH),16)&"");
			  write(fline,string'(" // 32-bit R/W - I2C GBTX number of registers to be accessed (MSB)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'(" // GBT control signals")); ------------------------------------------------
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_GBTX_CTRL")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GBTX_CTRL),16)&"");
			  write(fline,string'(" // 32-bit R/W - CTRL reg GBTX control register"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_GBTX_TXRX")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GBTX_TXRX),16)&"");
			  write(fline,string'(" // 32-bit R/W - TXRX reg GBTX control register"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_GBTX_RSTB")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_GBTX_RSTB),16)&"");
			  write(fline,string'(" // 32-bit R/W - RSTB reg GBTX control register"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'(" // efuse")); ------------------------------------------------
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_EFUSECTRL")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_EFUSECTRL),16)&"");
			  write(fline,string'(" // 32-bit R/W - efuse control register"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
			  write(fline,string'(" // ATMEGA")); -------------------------------------------------------------
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_ATMEGPIN")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_ATMEGPIN),16)&"");
			  write(fline,string'(" // 32-bit R/W - ATMEGA control line"));
			  writeline(mappingFile,fline);
			  
				  -- ATMEG_PIN (pwr_ctrl) bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// ATMEG_PIN register bits"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define PC_AVAGO_OFF    ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(PC_AVAGO_OFF))),16)));
				  write(fline, HT); write(fline,string'("  // to switch off the Avago transceiver"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define PC_A1500_OFF    ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(PC_A1500_OFF))),16)));
				  write(fline, HT); write(fline,string'("  // to switch off the A1500"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------
			  
			  write(fline,string'("#define A_ATMEGPTR")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_ATMEGPTR),16)&"");
			  write(fline,string'(" // 32-bit R/W - ATMEGA ADC data register pointer"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_ATMEGARGL")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_ATMEGARGL),16)&"");
			  write(fline,string'(" // 32-bit R/W - ATMEGA ADC data read from address ATMEGPTR (LSB)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_ATMEGARGH")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_ATMEGARGH),16)&"");
			  write(fline,string'(" // 32-bit R/W - ATMEGA ADC data read from address ATMEGPTR (MSB)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_ATMEGRAWL")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_ATMEGRAWL),16)&"");
			  write(fline,string'(" // 32-bit R/W - ATMEGA word read from PSM_SO shift register LSB (debug only)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_ATMEGRAWH")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_ATMEGRAWH),16)&"");
			  write(fline,string'(" // 32-bit R/W - ATMEGA word read from PSM_SO shift register MSB (debug only)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'(" // SFP")); ---------------------------------------------------------------------
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_SFPDATA")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_SFPDATA),16)&"");
			  write(fline,string'(" // 32-bit R   - Data read directly from the SFP"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_SFPDATAPTR")); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_SFPDATAPTR),16)&"");
			  write(fline,string'(" // 32-bit R   - Pointer to the SFP register to read out (auto-incrementing)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'(" // I2C temperature sensors")); ------------------------------------------------
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TEMPGBT")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_TEMPGBT),16)&"");
			  write(fline,string'(" // 32-bit R   - Temperature sensor, GBTx zone"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TEMPLDOGBT")); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_TEMPLDOGBT),16)&"");
			  write(fline,string'(" // 32-bit R   - Temperature sensor, GBT LDO zone"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TEMPLDOSDES")); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_TEMPLDOSDES),16)&"");
			  write(fline,string'(" // 32-bit R   - Temperature sensor, SERDES LDO zone"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TEMPPXL")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_TEMPPXL),16)&"");
			  write(fline,string'(" // 32-bit R   - Temperature sensor, PXL zone"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TEMPLDOFPGA")); write(fline, HT); write(fline, HT);        
			  write(fline,"0x" & str(conv_integer(A_TEMPLDOFPGA),16)&"");
			  write(fline,string'(" // 32-bit R   - Temperature sensor, IGLOO2 LDO zone"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TEMPIGLOO2")); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_TEMPIGLOO2),16)&"");
			  write(fline,string'(" // 32-bit R   - Temperature sensor, IGLOO2 zone"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_TEMPVTRX")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_TEMPVTRX),16)&"");
			  write(fline,string'(" // 32-bit R   - Temperature sensor, VTRX zone"));
			  writeline(mappingFile,fline);	 

			  write(fline,string'(" // diagnostic data from SFP")); ---------------------------------------------------
			  writeline(mappingFile,fline);	

			  write(fline,string'("#define A_SFPTEMP")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_SFPTEMP),16)&"");
			  write(fline,string'(" // 32-bit R   - SFP diagnostics, temperature (C degrees)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_SFPVOLT")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_SFPVOLT),16)&"");
			  write(fline,string'(" // 32-bit R   - SFP diagnostics, transmitter bias current (uA)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_SFPBIAS")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_SFPBIAS),16)&"");
			  write(fline,string'(" // 32-bit R   - SFP diagnostics, transmitter bias current (uA))"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_SFPTXPOW")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_SFPTXPOW),16)&"");
			  write(fline,string'(" // 32-bit R   - SFP diagnostics, transmitter optical power (mW)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_SFPRXPOW")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_SFPRXPOW),16)&"");
			  write(fline,string'(" // 32-bit R   - SFP diagnostics, receiver optical power (mW)"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'(" // temperature sensors I2C status")); ---------------------------------------------------
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_I2CMONITOR")); write(fline, HT); write(fline, HT);          
			  write(fline,"0x" & str(conv_integer(A_I2CMONITOR),16)&"");
			  write(fline,string'(" // 32-bit R   - I2C SFP TEMP lines status"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_SFPSTATUS")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_SFPSTATUS),16)&"");
			  write(fline,string'(" // 32-bit R   - I2C SFP TEMP lines status, error codes"));
			  writeline(mappingFile,fline);
			  
			  write(fline,string'(" // output buffer")); -------------------------------------------------------------------
			  writeline(mappingFile,fline);
			  
			  write(fline,string'("#define A_OUTBUF")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(A_OUTBUF),16)&"");
			  write(fline,string'(" // 32-bit R   - Output buffer"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			  
				  -- trigger types TT bits definition ---------------------------------------------------------------------------------------------------
				  write(fline, HT); write(fline,string'("// Trigger types TT bit definition"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define ORBIT_TT        ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(ORBIT_TT))),32)));
				  write(fline, HT); write(fline,string'("  // orbit"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define HB_TT           ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(HB_TT))),32)));
				  write(fline, HT); write(fline,string'("  // HB"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define HBr_TT          ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(HBr_TT))),32)));
				  write(fline, HT); write(fline,string'("  // HB reject"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define HBc_TT          ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(HBc_TT))),32)));
				  write(fline, HT); write(fline,string'("  // Health check"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define PHYSICS_TT      ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(PHYSICS_TT))),32)));
				  write(fline, HT); write(fline,string'("  // Physics trigger"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define PREPULSE_TT     ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(PREPULSE_TT))),32)));
				  write(fline, HT); write(fline,string'("  // Prepulse"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define CALIBRATION_TT  ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(CALIBRATION_TT))),32)));
				  write(fline, HT); write(fline,string'("  // Calibration"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define SOT_TT          ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(SOT_TT))),32)));
				  write(fline, HT); write(fline,string'("  // Start of Triggered Data"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define EOT_TT          ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(EOT_TT))),32)));
				  write(fline, HT); write(fline,string'("  // End of Triggered Data"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define SOC_TT          ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(SOC_TT))),32)));
				  write(fline, HT); write(fline,string'("  // Start of Continuous Data"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define EOC_TT          ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(EOC_TT))),32)));
				  write(fline, HT); write(fline,string'("  // End of Continuous Data"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TF_TT           ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TF_TT))),32)));
				  write(fline, HT); write(fline,string'("  // Time Frame delimiter"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define FErst_TT        ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(FErst_TT))),32)));
				  write(fline, HT); write(fline,string'("  // Front-end reset"));
				  writeline(mappingFile,fline);
                  write(fline, HT); write(fline,string'("#define RT_TT        ")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RT_TT))),32)));
				  write(fline, HT); write(fline,string'("  // Run type: 1 continuous, 0 triggered"));
				  writeline(mappingFile,fline);
                  write(fline, HT); write(fline,string'("#define RS_TT        ")); write(fline, HT); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(RS_TT))),32)));
				  write(fline, HT); write(fline,string'("  // Running state: 1 running, 0 not running"));
				  writeline(mappingFile,fline);
                  write(fline, HT); write(fline,string'("#define LHCgap1_TT        ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(LHCgap1_TT))),32)));
				  write(fline, HT); write(fline,string'("  // LHC abort gap 1"));
				  writeline(mappingFile,fline);
                  write(fline, HT); write(fline,string'("#define LHCgap2_TT        ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(LHCgap2_TT))),32)));
				  write(fline, HT); write(fline,string'("  // LHC abort gap 2"));
				  writeline(mappingFile,fline);
                  write(fline, HT); write(fline,string'("#define TPCsync_TT        ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TPCsync_TT))),32)));
				  write(fline, HT); write(fline,string'("  // TPC synchronization / ITSrst"));
				  writeline(mappingFile,fline);
                  write(fline, HT); write(fline,string'("#define TPCrst_TT        ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline, "0x" & hstr(conv_std_logic_vector(integer(2**(real(TPCrst_TT))),32)));
				  write(fline, HT); write(fline,string'("  // TPC reset on request"));
				  writeline(mappingFile,fline);
				  write(fline, HT); write(fline,string'("#define TOF_TT          ")); write(fline, HT); write(fline, HT); write(fline, HT);
				  write(fline, HT); write(fline,string'("0x80000000"));
				  write(fline, HT); write(fline,string'("  // TOF special trigger"));
				  writeline(mappingFile,fline);
				  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
				  -----------------------------------------------------------------------------------------------------------------------------		
                
              write(fline,string'("// A1500 mezzanine registers"));
			  writeline(mappingFile,fline);
              
              write(fline,string'("#define PXL_RESET_FPGA")); write(fline, HT); write(fline, HT); write(fline, HT);         
			  write(fline,"0x" & str(conv_integer(PXL_RESET_FPGA),16)&"");
			  write(fline,string'(" // 32-bit R   - A1500 register used to reset the Igloo2"));
			  writeline(mappingFile,fline);
			  write(fline,string'(" ")); writeline(mappingFile,fline); -- empty line
			    
			  write(fline,string'("//DRM2 rev2.0 registers"));
			  writeline(mappingFile,fline);				
			  write(fline,string'("//")); writeline(mappingFile,fline);	
			  write(fline,DRMMAP); 
			  writeline(mappingFile,fline);
			  file_close(mappingFile);
			  dumpIt <= '0';
			end if;
	end process;
	
  -- end header generator ------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------  

end RTL;
