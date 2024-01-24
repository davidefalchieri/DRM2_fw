
----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library smartfusion2;
use smartfusion2.all;

USE work.caenlinkpkg.all;
use work.DRM2pkg.all;

----------------------------------------------------------------------
-- DRM2_top entity declaration
----------------------------------------------------------------------
entity DRM2_top is
    port(
			-- Reset signals
        DEVRST_N		: in 		std_logic;
		SYSRESL			: out		std_logic;
		PROGL			: out		std_logic;
			-- Clock signals
		DCLK00_N		: in	 	std_logic;	-- GBTx clock from E-Links
		DCLK00_P		: in	  	std_logic;
		FPGACK40_N		: in		std_logic;	-- GBTx clock from PS or from LHC or from local oscillator
		FPGACK40_P		: in		std_logic;
		FPGACK80_N		: in		std_logic;	-- GBTx clock from PS
		FPGACK80_P		: in		std_logic;
		CPDMCK40_N		: in		std_logic;	-- clock from CPDM
		CPDMCK40_P		: in		std_logic;
		lvCLKLOS		: in		std_logic;
		--XTL				: in    	std_logic;	-- crystal in
		CLK_SEL1		: out		std_logic;	-- chooses between local (= 1) and LHC clock (= 0)
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
		
			-- ************************************************************************************
			-- 	SCL - CONET (A2818/A3818)
			-- ************************************************************************************  
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
		
			-- A1500
		PXL_A			: in    	std_logic_vector (7 downto 0);   -- address
		PXL_D			: inout 	std_logic_vector (15 downto 0);  -- data
		PXL_CS			: in    	std_logic;                       -- chip select
		PXL_RD			: in    	std_logic;                       -- read
		PXL_WR			: in    	std_logic;                       -- write
		PXL_RESET		: out   	std_logic;                       -- reset towards A1500
		PXL_IRQ			: out   	std_logic;                       -- interrupt request
		PXL_IO			: inout	 	std_logic_vector (1 downto 0);   -- spare I/Os
			-- SSRAM
		RAM_A			: out		std_logic_vector(19 downto 0);
		RAM_D			: inout		std_logic_vector(35 downto 0);
		RAM_CLK			: out		std_logic;
		RAM_CSN			: out		std_logic;
		RAM_LDN			: out		std_logic;
		RAM_OEN			: out		std_logic;
		RAM_WEN			: out		std_logic;
		
		-- VME buses (data + address + address modifier)
		VDB            	: inout  	std_logic_vector (31 downto 0);  -- VME data bus
		VAD            	: inout  	std_logic_vector (31 downto 1);  -- VME address bus
		LWORDB         	: inout  	std_logic;
		AML            	: out  		std_logic_vector (5 downto 0);     -- VME address modifier

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
	    NOEDTW         	: buffer 	std_logic;    -- OE on data from DRM2 to VME
	    NOEDTR        	: buffer 	std_logic;    -- OE on data from VME to V1718
	    NOEADW         	: buffer 	std_logic;    -- OE on address/data from DRM2 to VME
	    NOEADR         	: buffer 	std_logic;    -- OE on address/data from VME to V718
	    NOEMAS        	: buffer 	std_logic;    -- OE on signals for System Controller
	    NOEDRDY       	: buffer 	std_logic;    -- OE on Data Ready signals (towards VDB)
	    NOEFAULT       	: buffer 	std_logic;    -- OE on Fault (towards VDB)
		
		-- custom signals on P2 VME connector
		BUNCH_RES      	: out 	 	std_logic;
	    EVENT_RES      	: out	 	std_logic;
	    SPULSEL0       	: out	 	std_logic;  -- Pulse for CPDM
	    SPULSEL1       	: out	 	std_logic;
	    SPULSEL2       	: out	 	std_logic;
	    lvCPDM_FCLKL    : out    	std_logic;  -- Force Clock Selection for CPDM
	    lvCPDM_SCLKB    : in     	std_logic;  -- Clock Status of CPDM
	    PULSETGLL      	: out    	std_logic;  -- Pulse Toggle for LTM
	    LTMLTB         	: in     	std_logic;  -- Local Trigger from LTM
	    BUSYB          	: in     	std_logic;  -- Busy from TRM
	    SPSEOL         	: out    	std_logic;  -- Spare single ended OUT
	    SPSEIB         	: in     	std_logic;  -- Spare single ended IN
		
	    lvL0           	: buffer 	std_logic;  -- Triggers
	    lvL1A          	: buffer 	std_logic;
	    lvL1R          	: buffer 	std_logic;
	    lvL2A          	: buffer 	std_logic;
	    lvL2R          	: buffer 	std_logic;
		lvSPD0         	: out    	std_logic;  -- Spare Differential OUT
		
		-- ATMEGA signals
		PSM_SP1			: in		std_logic;	-- in : spare
		PSM_SP0			: in		std_logic;	-- in : spare
		PXL_SDN			: in		std_logic;	-- in : è stata spenta la A1500
		SERDES_SDN		: out		std_logic;	-- out: attenzione!!!! per ora mettere a 0
		PSM_SI			: out		std_logic;	-- out: eventuale opcode verso il micro
		PSM_SO			: in		std_logic;	-- in : comunicazione dal micro
		PSM_SCK			: in		std_logic;	-- in : comunicazione dal micro
		PXL_OFF			: out		std_logic; -- out: controllo da registro(?)->spegnere la A1500
		
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
----------------------------------------------------------------------
-- DRM2_top architecture body
----------------------------------------------------------------------
architecture RTL of DRM2_top is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------

-- INBUF_DIFF
--------------------------------------------------------------------
component INBUF_DIFF
--------------------------------------------------------------------
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
--------------------------------------------------------------------
component OUTBUF_DIFF
--------------------------------------------------------------------
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
--------------------------------------------------------------------
component GCLKBUF_DIFF
--------------------------------------------------------------------
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

--------------------------------------------------------------------
component FPGACK40_PLL
--------------------------------------------------------------------
    -- Port list
    port(
        -- Inputs
        CLK0 : in  std_logic;
        -- Outputs
        GL0  : out std_logic;
        LOCK : out std_logic
        );
end component;

--------------------------------------------------------------------
component FPGACK80_PLL
--------------------------------------------------------------------
    -- Port list
    port(
        -- Inputs
        CLK0 : in  std_logic;
        -- Outputs
        GL0  : out std_logic;
        GL1  : out std_logic;
        LOCK : out std_logic
        );
end component;

component GBTx_interface is
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
		--GBTX_DOUT:			in  	std_logic_vector(39 downto 0);	
		GBTX_DOUT_i_rise:	in		std_logic_vector(39 downto 0);
		GBTX_DOUT_i_fall:	in		std_logic_vector(39 downto 0);
		GBTX_TXDVALID:		out 	std_logic;
		--GBTX_DIN:			out 	std_logic_vector(39 downto 0);
		data_to_gbtx:		out		std_logic_vector(83 downto 0);
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
end component;

--------------------------------------------------------------------
component EPCS_Demo_sb is
--------------------------------------------------------------------
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

--------------------------------------------------------------------
component CAEN_LINK is
--------------------------------------------------------------------
port(

    reset_n    : in  std_logic;
    clk50      : in  std_logic; 

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
    PXL_IO     : inout  STD_LOGIC;                         -- Spare I/Os
	PXL_OFF	   : out	std_logic;    -- out: controllo da registro(?)->spegnere la A1500

    -- ************************************************************************************
    -- CAEN Synchronous Local Bus Interface 
    lb_address    : out    std_logic_vector (31 downto 0);  -- Local Bus Address
    lb_wdata      : out    std_logic_vector (32 downto 0);  -- Local Bus Data
    lb_rdata      : in     std_logic_vector (32 downto 0);  -- Local Bus Data
    lb_wr         : out    std_logic;                       -- Local Bus Write
    lb_rd         : out    std_logic;                       -- Local Bus Read
    lb_rdy        : in     std_logic;                       -- Local Bus Ready (ack.)
                  
	vme_info      : inout  VMEINFO_RECORD;
    regs          : in     REGS_RECORD;        
    
    -- ************************************************************************************
    -- SROF
    -- ************************************************************************************
    -- FIFO di uscita della SR
    srof_dto   : in     std_logic_vector (32 downto 0); -- data
    srof_rd    : out    std_logic;                      -- read enable
    srof_empty : in     std_logic;                      -- empty
    evwritten  : in     std_logic;                      -- interrupt di buffer ready
    
    -- ************************************************************************************
    -- SPARE
    -- ************************************************************************************
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

--------------------------------------------------------------------
component I2C_CORE
--------------------------------------------------------------------
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

--------------------------------------------------------------------
component vme_int
--------------------------------------------------------------------
   port(
      clk: 					in    	std_logic;                       -- Clock (IGLOO2 internal)
	  gbt_clk:				in		std_logic;						 -- Clock (from GBTx phase shifter)
      reset: 				in     	std_logic;                       -- Reset (active HIGH)
	  clear: 				buffer  std_logic;

      -- ************************************************************************************
        -- CAEN Synchronous Local Bus Interface 
      lb_address: 			in     	std_logic_vector (31 downto 0);  -- Local Bus Address
      lb_wdata: 			in     	std_logic_vector (32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_wr)
      lb_rdata: 			out    	std_logic_vector (32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_rd)
      lb_wr: 				in    	std_logic;                       -- Local Bus Write
      lb_rd: 				in     	std_logic;                       -- Local Bus Read
      lb_rdy: 				out    	std_logic;                       -- Local Bus Ready (ack.)
      
	  vme_info: 			inout  	VMEINFO_RECORD; 
      regs: 				inout  	REGS_RECORD; 
	  
	  -- Interfaccia verso GBTx_interface 
	  DDLOF_DTI: 			buffer  std_logic_vector (32 downto 0);  -- Data to DDL + EndPCK
	  DDLOF_WR: 			buffer  std_logic;                       -- FIFO Write Enable
	  DDLOF_FULL:			in		std_logic;
	  l1a_ttc:				in		std_logic;
	  l1msg_dto:			in   	std_logic_vector(79 downto 0);
	  l1msg_empty:			in		std_logic;
	  l1msg_rd:				out		std_logic;
	  RODATA:	 			buffer  std_logic;						 -- Readout data
	  acq_on:				out     std_logic;
	  EVDONE:				out		std_logic;
	  
	  -- SROF interface
	  srof_dto: 			out    std_logic_vector (32 downto 0); -- data
	  srof_rd: 				in     std_logic;                      -- read enable
	  srof_empty: 			buffer std_logic;                      -- empty
	  evwritten: 			out    std_logic;                      -- interrupt di buffer ready
	  
		-- GBTx register interface
	  GDI: 					in   	std_logic_vector(7 downto 0); -- Register data in
      GDO: 					out  	std_logic_vector(7 downto 0); -- Register data out
      GWR: 					out  	std_logic; -- Write signal
      GEN: 					out  	std_logic; -- Enable signal
      GADD: 				out  	std_logic_vector(7 downto 0);

		-- BRAM interface
	  bram_addr: 			out 	std_logic_vector(15 downto 0);			
	  bram_write_data: 		out 	std_logic_vector(15 downto 0);			
	  bram_rw_n: 			out 	std_logic;  										
	  bram_read_data: 		in  	std_logic_vector(15 downto 0);
	  
		-- VME address/data buses + address modifier
	  VAD: 					inout  	std_logic_vector (31 downto 1);  -- VME address bus
	  VDB: 					inout  	std_logic_vector (31 downto 0);  -- VME data bus
	  AML: 					out    	std_logic_vector (5 downto 0);   -- VME address modifier
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
	  
	  -- LED
	  VMELED: 				out    std_logic;
	  DRDYLED: 				out    std_logic;  -- LED di L2A
	  
	  -- segnali sul P2
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
	  CPDM_FCLKL: 			out    std_logic;  -- Force Clock Selection for CPDM
	  CPDM_SCLKB: 			in     std_logic;  -- Clock Status of CPDM
	  PULSETGLL: 			out    std_logic;  -- Pulse Toggle for LTM
	  LTMLTB: 				in     std_logic;  -- Local Trigger from LTM
	  BUSYB: 				in     std_logic;  -- Busy from TRM
	  SPSEOL: 				out    std_logic;  -- Spare single ended OUT
	  SPSEIB: 				in     std_logic;  -- Spare single ended IN
	  SPDO: 				out    std_logic;  -- Spare Differential OUT
	  
	  TICK: 				in     tick_pulses;
	  WPULSE: 				buffer reg_wpulse;
	  PROGL: 				out    std_logic  -- PROG (ovvero PROGL negato da un BJT) è attivo basso
   );
end component vme_int;

--------------------------------------------------------------------
component bram_controller
--------------------------------------------------------------------
port (
    -- BRAM interface
	  bram_addr: 			in 	std_logic_vector(15 downto 0);			
	  bram_write_data: 		in 	std_logic_vector(15 downto 0);			
	  bram_rw_n: 			in 	std_logic;  										
	  bram_read_data: 		out std_logic_vector(15 downto 0);
	  clock:				in  std_logic
);
end component bram_controller;

component DDR_IN
	port(D, CLK, EN, ALn, ADn, SLn, SD : in std_logic := 'U'; QR, QF : out std_logic) ;
end component;

component DDR_OUT
	port(DR, DF, CLK, EN, ALn, ADn, SLn, SD : in std_logic := 'U'; Q : out std_logic) ;
end component;


----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
-- GBTx signals
signal GBTX_SCLI:							std_logic;
signal GBTX_SCLO:							std_logic;
signal GBTX_SDAI:							std_logic;
signal GBTX_SDAO:							std_logic;
signal AUX_SCLO:							std_logic;
signal AUX_SDAO:							std_logic;
signal AUX_SCLI:							std_logic;
signal AUX_SDAI:							std_logic;
signal SCLI:								std_logic;
signal SCLO:								std_logic;
signal SDAI:								std_logic;
signal SDAO:								std_logic;
signal GBTX_CONFIG_int: 					std_logic;
signal GBTX_RESETB_int: 					std_logic;
signal GBTX_TXDVALID_int: 					std_logic;
signal GBTX_TESTOUT_int: 					std_logic;
signal GBTX_RXRDY_int: 						std_logic;
signal GBTX_RXDVALID_int: 					std_logic;
signal GBTX_TXRDY_int: 						std_logic;

-- Sysreset + CoreReset + clock signals
signal reset_n: 		      		        std_logic;  -- main reset
signal active_high_reset:                   std_logic; 
signal clk50: 			       			    std_logic;  -- main clock
signal clk20:								std_logic;  -- for GBTX I2C
signal DCLK00:								std_logic;
signal FPGACK40:							std_logic;
signal FPGACK80:							std_logic;
signal CPDMCK40:							std_logic;
-- signal DCLK00_sig:							std_logic;

-- local bus for GBTx programming
signal GDOa:		std_logic_vector(7 downto 0);
signal GDIa:		std_logic_vector(7 downto 0);
signal GWRa:		std_logic;
signal GENa:		std_logic;
signal GADDa:		std_logic_vector(7 downto 0);

signal GBTX_DOUT:	std_logic_vector(39 downto 0);
signal GBTX_DIN:	std_logic_vector(39 downto 0);

----------------------------------------------------------------------
-- TiedOff Signals
----------------------------------------------------------------------
signal VCC_net: 					std_logic;
signal GND_net: 					std_logic;
signal SDIF0_PRDATA_const_net_0: 	std_logic_vector(31 downto 0);
signal SDIF1_PRDATA_const_net_0: 	std_logic_vector(31 downto 0);
signal SDIF2_PRDATA_const_net_0: 	std_logic_vector(31 downto 0);
signal SDIF3_PRDATA_const_net_0: 	std_logic_vector(31 downto 0);

signal FPGACK_40MHz:				std_logic;
signal gbt_clk_40MHz:				std_logic;
signal gbt_clk_80MHz:				std_logic;

signal vme_info: 					VMEINFO_RECORD; 
signal regs: 						REGS_RECORD; 

signal lb_address: 					std_logic_vector (31 downto 0);  -- Local Bus Address
signal lb_wdata: 					std_logic_vector (32 downto 0);  -- Local Bus Data
signal lb_rdata: 					std_logic_vector (32 downto 0);  -- Local Bus Data
signal lb_wr: 						std_logic;                       -- Local Bus Write
signal lb_rd: 						std_logic;                       -- Local Bus Read
signal lb_rdy: 						std_logic;                       -- Local Bus Ready

----------------------------------------------------------------------
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
----------------------------------------------------------------------

-- LED:
signal VMELED:					std_logic;
signal DRDYLED:					std_logic;

-- BRAM
signal bram_addr: 				std_logic_vector(15 downto 0);			
signal bram_write_data: 		std_logic_vector(15 downto 0);			
signal bram_rw_n: 				std_logic;  										
signal bram_read_data: 			std_logic_vector(15 downto 0);

-- Contatori per i TICK (inizializzati in modo da avere attese piccole in simulazione)
signal TCNT1: 					std_logic_vector(5 downto 0) := "111000";
signal TCNT2: 					std_logic_vector(7 downto 0) := (others => '0');
signal TCNT3: 					std_logic_vector(7 downto 0) := (others => '0');
signal TICK: 					tick_pulses;

-- temporary
signal DDLOF_DTI: 				std_logic_vector(32 downto 0);  -- Data to DDL + EndPCK
signal DDLOF_WR: 				std_logic;                       -- FIFO Write Enable
signal RODATA: 					std_logic := '0';

signal srof_dto: 				std_logic_vector (32 downto 0); -- data
signal srof_rd: 				std_logic;                      -- read enable
signal srof_empty:	 			std_logic;                      -- empty
signal evwritten: 				std_logic;

signal data_to_gbtx:			std_logic_vector(32 downto 0);
signal data_valid_to_gbtx:		std_logic;

signal l1a_ttc:					std_logic;
signal l1msg_dto:				std_logic_vector(79 downto 0);
signal l1msg_empty:				std_logic;
signal l1msg_rd:				std_logic;
signal acq_on:					std_logic;
signal EVDONE:					std_logic;
signal clear:					std_logic;
SIGNAL WPULSE: 					reg_wpulse;

signal clock_selection:			std_logic_vector(1 downto 0);
signal state_clock:				std_logic_vector(1 downto 0);
signal clk_sel1_int:			std_logic;
signal clk_sel2_int:			std_logic;

signal Debug1:					std_logic;
signal Debug2:					std_logic;
signal DebugS:					std_logic;

signal data_towards_gbtx:		std_logic_vector(83 downto 0);
signal GBTX_DOUT_rise:			std_logic_vector(39 downto 0);
signal GBTX_DOUT_fall:			std_logic_vector(39 downto 0);

begin
	
----------------------------------------------------------------------
	active_high_reset 			<= not reset_n;
	--reset_n						<= POWER_ON_RESET_N;
	reset_n						<= INIT_DONE;
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
	
	data_to_gbtx				<= DDLOF_DTI;		-- from vme_int to GBTx
	data_valid_to_gbtx			<= DDLOF_WR;
----------------------------------------------------------------------

----------------------------------------------------------------------
-- GBTx clocks

	fpgack40_buf: GCLKBUF_DIFF
		port map
		(PADP => FPGACK40_P, PADN => FPGACK40_N, EN => VCC_net, Y => FPGACK40);

	FPGACK40_PLL_instance: FPGACK40_PLL
		port map(
        CLK0     => FPGACK40,
		GL0	     => FPGACK_40MHz,		-- 40 MHz from FPGACK40_P & FPGACK40_N
        LOCK     => open
        );

	--------------------------------------------
	
	FPGACK80_buf: GCLKBUF_DIFF
		port map
		(PADP => FPGACK80_P, PADN => FPGACK80_N, EN => VCC_net, Y => FPGACK80); 
		
	-- FPGACK80_PLL_instance: FPGACK80_PLL
		-- port map(
        -- CLK0     => FPGACK80,			-- 40 MHz from GBTx PS 0
        -- GL0      => gbt_clk_80MHz,		-- 80 MHz from GBTx PS 0 (multiplied on Igloo2)
		-- GL1	     => gbt_clk_40MHz,		-- same as 40 MHz from GBTx PS 0
        -- LOCK     => open
        -- );
	
	gbt_clk_40MHz	<= DCLK00;
----------------------------------------------------------------------

-- GBTx DIN
din_outbuf_instance:
	for i in 0 to 39 generate
		DDR_OUT_inst : DDR_OUT
		port map
		(DR => data_towards_gbtx(2*i+1), DF => data_towards_gbtx(2*i), CLK => not(gbt_clk_40MHz), EN => '1', ALn => '1', ADn => '1', SLn => '1', SD => '1', Q => GBTX_DIN(i));
		
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
		(D => GBTX_DOUT(i), CLK => gbt_clk_40MHz, EN => '1', ALn => '1', ADn => '1', SLn => '1', SD => '1', QR => GBTX_DOUT_rise(i), QF => GBTX_DOUT_fall(i));
		
	end generate dout_inbuf_instance;

GBTx_interface_instance: GBTx_interface
port map
	(
		active_high_reset	=> active_high_reset,
		clear				=> clear, 
		gbt_clk_40MHz		=> gbt_clk_40MHz,
		gbt_clk_80MHz		=> gbt_clk_80MHz,
		FPGACK_40MHz		=> FPGACK_40MHz,
		regs				=> regs,
		acq_on				=> acq_on,
		clk_sel1			=> clk_sel1_int,
		clk_sel2			=> clk_sel2_int,
		GBTX_RXDVALID		=> GBTX_RXDVALID_int,
		GBTX_DOUT_i_rise	=> GBTX_DOUT_rise,
		GBTX_DOUT_i_fall	=> GBTX_DOUT_fall,
		--GBTX_DOUT			=> GBTX_DOUT,
		GBTX_TXDVALID		=> GBTX_TXDVALID_int,
		-- GBTX_DIN			=> GBTX_DIN,
		data_to_gbtx		=> data_towards_gbtx,
		
		DDLOF_DTI_ck		=> data_to_gbtx,
		DDLOF_WR_ck			=> data_valid_to_gbtx,
		RODATA_ck			=> RODATA,
		EVDONE_ck			=> EVDONE,
		l1a_ttc				=> l1a_ttc,		
		l1msg_dto			=> l1msg_dto,	
		l1msg_empty			=> l1msg_empty,	
		l1msg_rd			=> l1msg_rd,
		-- SSRAM interface
		RR_D 				=> RAM_D, 
		RR_A 	            => RAM_A, 
		RR_WE               => RAM_WEN,
		RR_OE               => RAM_OEN,
		RR_LD               => RAM_LDN,
		RR_CE		        => RAM_CSN,
		WPULSE				=> WPULSE
	);

	RAM_CLK			<= gbt_clk_40MHz;

		
-----------------------------------------------------------
----------EPCS_Demo
-----------------------------------------------------------
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
    FAB_CCC_GL1         => clk50 ,                            -- out

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
        
-----------------------------------------------------------------------------------------------------------

-- GBTX_CORE_proto
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
        RESETn        => reset_n,
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

-----------------------------------------------------------------------------------------------------------
   
vme_int_instance: vme_int
   port map(
      clk        		=> FPGACK_40MHz,
	  gbt_clk			=> gbt_clk_40MHz,
      reset      		=> active_high_reset,
	  clear				=> clear,

	  -- local bus
      lb_address    	=> lb_address,
      lb_wdata      	=> lb_wdata,
      lb_rdata      	=> lb_rdata,
      lb_wr         	=> lb_wr,
      lb_rd         	=> lb_rd,  
      lb_rdy       		=> lb_rdy,
    
	  vme_info			=> vme_info,
      regs          	=> regs,
	  
	  DDLOF_DTI			=> DDLOF_DTI,	
	  DDLOF_WR			=> DDLOF_WR,	
	  DDLOF_FULL		=> '0',
	  l1a_ttc			=> l1a_ttc,
	  l1msg_dto			=> l1msg_dto,
	  l1msg_empty		=> l1msg_empty,
	  l1msg_rd			=> l1msg_rd,
	  RODATA			=> RODATA,		-- temporary as a register from CONET/A1500
	  acq_on			=> acq_on,
	  EVDONE			=> EVDONE,
	  
	  srof_dto			=> srof_dto,	
	  srof_rd			=> srof_rd,	
	  srof_empty		=> srof_empty,
	  evwritten			=> evwritten,	
	  
	  GDI  				=> GDOa,
      GDO  				=> GDIa,
      GWR  				=> GWRa,
      GEN  				=> GENa,
      GADD 				=> GADDa,

	  -- BRAM interface
	  bram_addr			=> bram_addr,				
	  bram_write_data	=> bram_write_data,	
	  bram_rw_n			=> bram_rw_n,											
	  bram_read_data	=> bram_read_data,
	  -- VME interface
	  VAD 				=> VAD, 		
	  VDB 				=> VDB, 		
	  AML 				=> AML, 		
	  ASL 				=> ASL, 		
	  DS0L 				=> DS0L, 		
	  DS1L 				=> DS1L, 		
	  WRITEL 			=> WRITEL, 	
	  LWORDB 			=> LWORDB, 	
	  DTACKB 			=> DTACKB, 	
	  BERRB 			=> BERRB, 	
	  BERRL 			=> BERRL, 	
	  IACKL 			=> IACKL, 	
	  IRQB1		 		=> IRQB1,		
	  NOEDTW 			=> NOEDTW, 	
	  NOEDTR 			=> NOEDTR, 	
	  NOEADW 			=> NOEADW, 	
	  NOEADR 			=> NOEADR, 	
	  NOEMAS 			=> NOEMAS, 	
	  NOEDRDY 			=> NOEDRDY, 	
	  NOEFAULT			=> NOEFAULT,
	  -- LED
	  VMELED			=> VMELED,
	  DRDYLED			=> DRDYLED,
	  -- segnali sul P2
	  L0				=> lvL0,
	  L1A				=> lvL1A,
	  L1R				=> lvL1R,
	  L2A				=> lvL2A,
	  L2R				=> lvL2R,
	  BUNCH_RES			=> BUNCH_RES, 				  
	  EVENT_RES			=> EVENT_RES, 				       
	  SPULSEL0			=> SPULSEL0,      
	  SPULSEL1			=> SPULSEL1, 				        
	  SPULSEL2			=> SPULSEL2, 				
	  CPDM_FCLKL		=> lvCPDM_FCLKL,
	  CPDM_SCLKB		=> lvCPDM_SCLKB,
	  PULSETGLL			=> PULSETGLL,
	  LTMLTB			=> LTMLTB,
	  BUSYB				=> BUSYB,	
	  SPSEOL			=> SPSEOL,
	  SPSEIB			=> SPSEIB,
	  SPDO				=> lvSPD0,
	  
	  TICK				=> TICK,
	  WPULSE			=> WPULSE,
	  PROGL				=> PROGL
   );
   
-----------------------------------------------------------------------------------------------------------		
CAEN_LINK_instance : CAEN_LINK
port map(

    reset_n    => reset_n,
    clk50      => FPGACK_40MHz, 

    -- ************************************************************************************
    -- SCL - CONET (A2818/A3818)
    -- ************************************************************************************    
    REFCLK0_N  => REFCLK0_N,
    REFCLK0_P  => REFCLK0_P,
                            
    RXD0_N     => RXD0_N,
    RXD0_P     => RXD0_P,
    RXD1_N     => RXD1_N,
    RXD1_P     => RXD1_P,
    RXD2_N     => RXD2_N,
    RXD2_P     => RXD2_P,
    RXD3_N     => RXD3_N,
    RXD3_P     => RXD3_P,
                        
    TXD0_N     => TXD0_N,
    TXD0_P     => TXD0_P,
    TXD1_N     => TXD1_N,
    TXD1_P     => TXD1_P,
    TXD2_N     => TXD2_N,
    TXD2_P     => TXD2_P,
    TXD3_N     => TXD3_N,
    TXD3_P     => TXD3_P,
                             
    LED1       => open,
    LED2       => SCLLED2,
    SFP_TXDISAB =>lvSFP_TXDISAB, 

     --------------------------------                                                 
     ---- APB slave interface    
     --------------------------------                                                 
     APB_S_PRESET_N   => EPCS_Demo_INIT_APB_S_PRESET_N ,    -- in
     APB_S_PADDR      => EPCS_Demo_SDIF0_INIT_APB_PADDR_0_14to2 , -- in
     APB_S_PCLK       => EPCS_Demo_INIT_APB_S_PCLK ,        -- in
     APB_S_PENABLE    => EPCS_Demo_SDIF0_INIT_APB_PENABLE , -- in
     APB_S_PSEL       => EPCS_Demo_SDIF0_INIT_APB_PSELx ,   -- in
     APB_S_PWRITE     => EPCS_Demo_SDIF0_INIT_APB_PWRITE ,  -- in
     APB_S_PWDATA     => EPCS_Demo_SDIF0_INIT_APB_PWDATA ,  -- in
     APB_S_PRDATA     => EPCS_Demo_SDIF0_INIT_APB_PRDATA ,  -- out
     APB_S_PREADY     => EPCS_Demo_SDIF0_INIT_APB_PREADY ,  -- out
     APB_S_PSLVERR    => EPCS_Demo_SDIF0_INIT_APB_PSLVERR,  -- out

    
    -- ************************************************************************************
    -- PXL (A1500 - Ethernet) -- HACK: pin assegnati a GPIO della scheda di sviluppo
    -- ************************************************************************************
    --RMT_RESET  : in  std_logic;                       -- Reset dalla A1500 verso la DRM (not used)
    PXL_RESET  => PXL_RESET,
    PXL_CS     => PXL_CS   ,
    PXL_RD     => PXL_RD   ,
    PXL_WR     => PXL_WR   ,
    PXL_D      => PXL_D    ,
    PXL_A      => PXL_A,
    PXL_IRQ    => PXL_IRQ,
    PXL_IO     => PXL_IO(0),
	PXL_OFF    => PXL_OFF,              
               
    -- ************************************************************************************
    -- CAEN Synchronous Local Bus Interface 
    lb_address    => lb_address,    --: out    std_logic_vector (31 downto 0);  -- Local Bus Address
    lb_wdata      => lb_wdata,      --: out    std_logic_vector (32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_wr)
    lb_rdata      => lb_rdata,      --: in     std_logic_vector (32 downto 0);  -- Local Bus Data (bit 32 = lb_endpkt_rd)
    lb_wr         => lb_wr,         --: out    std_logic;                       -- Local Bus Write
    lb_rd         => lb_rd,         --: out    std_logic;                       -- Local Bus Read
    lb_rdy        => lb_rdy,        --: in     std_logic;                       -- Local Bus Ready (ack.)
     
	vme_info	  => vme_info,
    regs          => regs,        
               
    -- ************************************************************************************
    -- SROF
    -- ************************************************************************************
    -- FIFO di uscita della SR
    srof_dto     => srof_dto,
    srof_rd      => srof_rd,
    srof_empty   => srof_empty,
    evwritten    => evwritten,
               
    -- ************************************************************************************
    -- SPARE
    -- ************************************************************************************

    SPARE0     => open,
    SPARE1     => open,
    SPARE2     => open,
    SPARE3     => open,
    SPARE4     => open,
    SPARE5     => open,
    SPARE6     => open,
    SPARE7     => open,
    SPARE8     => open
    );

-----------------------------------------------------------------------------------------------------------
	
bram_controller_instance: bram_controller
port map
	(
	-- BRAM interface
	  bram_addr			=> bram_addr,				 
	  bram_write_data	=> bram_write_data,	
	  bram_rw_n			=> bram_rw_n,			 									
	  bram_read_data	=> bram_read_data,	
	  clock				=> FPGACK_40MHz 
	);


DCLK00_buf: GCLKBUF_DIFF
	port map
		(PADP => DCLK00_P, PADN => DCLK00_N, EN => VCC_net, Y => DCLK00); 
		
-- DCLK00_process: process(active_high_reset, DCLK00)
	-- begin
		-- if(active_high_reset = '1') then
			-- DCLK00_sig	<= '0';
		-- elsif(rising_edge(DCLK00)) then
			-- DCLK00_sig	<= NOT(DCLK00_sig);
		-- end if;
-- end process DCLK00_process;
	
CPDMCK40_buf: INBUF_DIFF
	port map
		(PADP => CPDMCK40_P, PADN => CPDMCK40_N, Y => CPDMCK40); 

  -- *****************************************************************************
  -- TICK
  -- Un Tick e' un impulso che dura 1 periodo di CLK e viene ripetuto ogni N periodi
  -- *****************************************************************************
  -- T64:  Periodo=Tclk*64  (circa 1.6us a 40MHz)
  -- T16K: Periodo=Tclk*16K (circa 410us a 40MHz)
  -- T4M:  Periodo=Tclk*4M  (circa 104ms a 40MHz)
  process(clk50)
  begin
    if(rising_edge(clk50)) then
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

	------------------------------------------------------------------------------------------------------
	-- clock selection begin -----------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------
	
	clock_selection_process: process(clk50, INIT_DONE)
	begin
		if(INIT_DONE = '0') then	
			clock_selection	<= "01";		-- local oscillator
			state_clock		<= "00";
		elsif(rising_edge(clk50)) then
			if(state_clock = "00") then		-- wait next TICK(T4M) (up to 80 ms)
				if(TICK(T4M) = '1' and regs.clocksel(3) = '0') then
					state_clock	<= "01";
				else	
					state_clock	<= "00";
				end if;
				clock_selection	<= "01";
			elsif(state_clock = "01") then	-- wait for 80 ms 
				if(TICK(T4M) = '1') then
					state_clock	<= "10";
				else	
					state_clock	<= "01";
				end if;
				clock_selection	<= "01";
			elsif(state_clock = "10") then
				if(lvCLKLOS = '0') then	
					clock_selection		<= "10";		-- clock from LHC
				elsif(GBTX_RXRDY_int = '1') then
					clock_selection		<= "00";		-- clock from GBTx PS
				else	
					clock_selection		<= "01";		-- local oscillator
				end if;
				state_clock		<= "11";
			else
				if(regs.clocksel(3) = '1') then
					state_clock	<= "00";
				elsif(lvCLKLOS = '1' and clock_selection = "10") then
					state_clock	<= "00";
				elsif(GBTX_RXRDY_int = '0' and clock_selection = "00") then
					state_clock	<= "00";
				elsif(clock_selection = "01") then
					if(lvCLKLOS = '0' or GBTX_RXRDY_int = '1') then
						state_clock	<= "00";
					else
						state_clock	<= "11";
					end if;
				end if;
			end if;
		end if;
	end process clock_selection_process;
	
clk_sel1_int				<= clock_selection(0) when regs.clocksel(2) = '0' else regs.clocksel(0);
clk_sel2_int				<= clock_selection(1) when regs.clocksel(2) = '0' else regs.clocksel(1);

clk_sel1					<= clk_sel1_int;
clk_sel2					<= clk_sel2_int;

regs.status(STATUS_CLK_SRC)	<= clk_sel1_int; 
regs.status(STATUS_EXTOK)	<= clk_sel2_int;

	------------------------------------------------------------------------------------------------------
	-- clock selection end -------------------------------------------------------------------------------
	------------------------------------------------------------------------------------------------------

-- Reset signals
SYSRESL    	<= '1' when reset_n = '0' or regs.ctrl(CTRL_SYSRES) = '1' else '0';  -- attivo alto (c'è un BJT che inverte)
	
-- A1500	
PXL_IO(1)	<= '0';

-- front panel
FPGALED1			<= RODATA;		-- ON when in acquisition
FPGALED2			<= not DRDYLED;	
FPGALED3			<= not VMELED; 
FPGALED4			<= not BUSYB;	-- the busy LED turns ON when the TRMs are busy
	-- I/O 1 & I/O 2 
lvFPGAIO1 			<= GBTX_TESTOUT_int and FPGACK80 and CPDMCK40;
lvFPGAIO2			<= lvSFP_LOS and lvSFP_TXFAULT and lvCLKLOS;

CLKLEDR				<= clk_sel1_int; 
CLKLEDG				<= clk_sel2_int; 

FPGADIR1			<= '1';
FPGADIR2			<= '1';
lvFPGA_SCOPE		<= gbt_clk_80MHz; 

--SERDES_SDN			<= regs.pwr_ctrl(PC_AVAGO_OFF);


end RTL;
