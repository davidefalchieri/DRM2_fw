----------------------------------------------------------------------
-- Created by SmartDesign Mon Nov 16 17:08:02 2015
-- Version: v11.6 11.6.0.34
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Libraries
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_arith.all;
-- use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;

library smartfusion2;
use smartfusion2.all;

library modelsim_lib;
use modelsim_lib.util.all; 

library work;
USE work.caenlinkpkg.all;
use work.DRM2pkg.all;

library ltm_libr;
use ltm_libr.all;

----------------------------------------------------------------------
-- I2C_GBTX_tb entity declaration
----------------------------------------------------------------------
entity I2C_GBTX_tb is
    -- Port list
    port(
        -- Outputs
        AUXSCLI        : out std_logic;
        AUXSCLO        : out std_logic;
        AUXSDAI        : out std_logic;
        AUXSDAO        : out std_logic;
        ENVGD          : out std_logic;
        ERROR_AUX      : out std_logic;
        FiEMPTY_AUX    : out std_logic;
        FiRDCNT        : out std_logic_vector(9 downto 0);
        FiWRCNT        : out std_logic_vector(9 downto 0);
        FoEMPTY_AUX    : out std_logic;
        FoRDCNT        : out std_logic_vector(9 downto 0);
        FoWRCNT        : out std_logic_vector(9 downto 0);
        GBPS_TX_DISAB  : out std_logic;
        GBTX_ARST      : out std_logic;
        GBTX_CONFIG    : out std_logic;
        GBTX_MODE      : out std_logic_vector(3 downto 0);
        GBTX_POW       : out std_logic;
        GBTX_RESETB    : out std_logic;
        GBTX_RXDVALID  : out std_logic;
        GBTX_RXLOCKM   : out std_logic_vector(1 downto 0);
        GBTX_RXRDY     : out std_logic;
        GBTX_SADD      : out std_logic_vector(3 downto 0);
        GBTX_TESTOUT_i : out std_logic;
        GBTX_TXDVALID  : out std_logic;
        GBTX_TXRDY     : out std_logic;
        I2CBSY_AUX     : out std_logic;
        I2CBSY_GBTX    : out std_logic;
        I2CBSY_INA     : out std_logic;
        I2CRXflg       : out std_logic;
        REFCLKSELECT   : out std_logic;
        SCLi_INA       : out std_logic;
        SCLo_INA       : out std_logic;
        SDAi_INA       : out std_logic;
        SDAo_INA       : out std_logic;
        SLVSCLI        : out std_logic;
        SLVSCLO        : out std_logic;
        SLVSDAI        : out std_logic;
        SLVSDAO        : out std_logic;
        STATEOVERRIDE  : out std_logic;
        TESTpls        : out std_logic_vector(3 downto 0)
        );
end I2C_GBTX_tb;
----------------------------------------------------------------------
-- I2C_GBTX_tb architecture body
----------------------------------------------------------------------
architecture RTL of I2C_GBTX_tb is
----------------------------------------------------------------------
-- Component declarations
----------------------------------------------------------------------
-----------------------------------------------------------
component DRM2_top is
-----------------------------------------------------------
port(
			-- Reset signals
        DEVRST_N		: in 		std_logic;
		SYSRESL			: out		std_logic;
		PROGL			: out		std_logic;
			-- Clock signals
		DCLK00_N		: in	 	std_logic;	-- GBTx clock from E-Links
		DCLK00_P		: in	  	std_logic;
		FPGACK40_N		: in		std_logic;	-- GBTx clock from PS
		FPGACK40_P		: in		std_logic;
		FPGACK80_N		: in		std_logic;	-- GBTx clock from PS
		FPGACK80_P		: in		std_logic;
		CPDMCK40_N		: in		std_logic;	-- clock to CPDM
		CPDMCK40_P		: in		std_logic;
		lvCLKLOS		: in		std_logic;
		--XTL				: in    	std_logic;	-- crystal in
		CLK_SEL1		: out		std_logic;	-- chooses between local (= 1) and LHC clock (= 0)
		CLK_SEL2		: out		std_logic;	-- chooses between local (= 1) and LHC clock (= 0)
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
		BERRL          	: out    	std_logic;
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
		PSM_SP1			: in		std_logic;
		PSM_SP0			: in		std_logic;
		PXL_SDN			: in		std_logic;
		SERDES_SDN		: out		std_logic;
		PSM_SI			: out		std_logic;
		PSM_SO			: in		std_logic;
		PSM_SCK			: in		std_logic;
		PXL_OFF			: out		std_logic;
		
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

		-- NI 8451 i2c
		EXTSCL			: inout 	std_logic;
        EXTSDA			: inout 	std_logic;
		-- temperature sensors I2C
		SCL				: inout 	std_logic;
        SDA				: inout 	std_logic
		
		-- FPGA configuration signals
		--JTAGSEL			: in		std_logic     
        );
end component DRM2_top;

-- I2C_Control
component I2C_Control
    -- Port list
    port(
        -- Inputs
        ENVGD          : in  std_logic;
        ERROR          : in  std_logic;
        FiAEMPTY       : in  std_logic;
        FiAFULL        : in  std_logic;
        FiEMPTY        : in  std_logic;
        FiFULL         : in  std_logic;
        FoAEMPTY       : in  std_logic;
        FoAFULL        : in  std_logic;
        FoDATA         : in  std_logic_vector(7 downto 0);
        FoEMPTY        : in  std_logic;
        FoFULL         : in  std_logic;
        GBPS_TX_DISAB  : in  std_logic;
        GBTX_ARST      : in  std_logic;
        GBTX_CONFIG    : in  std_logic;
        GBTX_MODE      : in  std_logic_vector(3 downto 0);
        GBTX_RESETB    : in  std_logic;
        GBTX_RXDVALIDf : in  std_logic;
        GBTX_RXLOCKM   : in  std_logic_vector(1 downto 0);
        GBTX_RXRDYf    : in  std_logic;
        GBTX_SADD      : in  std_logic_vector(3 downto 0);
        GBTX_TESTOUTf  : in  std_logic;
        GBTX_TXDVALID  : in  std_logic;
        GBTX_TXRDYf    : in  std_logic;
        I2CBSY_AUX     : in  std_logic;
        I2CBSY_GBTX    : in  std_logic;
        REFCLKSELECT   : in  std_logic;
        STATEOVERRIDE  : in  std_logic;
        -- Outputs
        FiDATA         : out std_logic_vector(7 downto 0);
        FiWE           : out std_logic;
        FoRE           : out std_logic;
        GBTX_POW       : out std_logic;
        GBTX_RXDVALID  : out std_logic;
        GBTX_RXRDY     : out std_logic;
        GBTX_TESTOUT   : out std_logic;
        GBTX_TXRDY     : out std_logic;
        I2CRUN         : out std_logic;
        RESETn         : out std_logic;
        SYSCLK         : out std_logic
        );
end component;
-- I2C_INA_block
component I2C_INA_block
    -- Port list
    port(
        -- Inputs
        CLK    : in  std_logic;
        RESETn : in  std_logic;
        SCLi   : in  std_logic;
        SDAi   : in  std_logic;
        -- Outputs
        I2CBSY : out std_logic;
        SCLO   : out std_logic;
        SDAO   : out std_logic
        );
end component;
-- I2C_Master_test
component I2C_Master_test
    -- Port list
    port(
        -- Inputs
        CLK      : in  std_logic;
        FiDATA   : in  std_logic_vector(7 downto 0);
        FiWRITE  : in  std_logic;
        FoREAD   : in  std_logic;
        I2CRUN   : in  std_logic;
        RESETn   : in  std_logic;
        SCLI     : in  std_logic;
        SDAI     : in  std_logic;
        -- Outputs
        ERROR    : out std_logic;
        FiAEMPTY : out std_logic;
        FiAFULL  : out std_logic;
        FiEMPTY  : out std_logic;
        FiFULL   : out std_logic;
        FiRDCNT  : out std_logic_vector(9 downto 0);
        FiWRCNT  : out std_logic_vector(9 downto 0);
        FoAEMPTY : out std_logic;
        FoAFULL  : out std_logic;
        FoDATA   : out std_logic_vector(7 downto 0);
        FoEMPTY  : out std_logic;
        FoFULL   : out std_logic;
        FoRDCNT  : out std_logic_vector(9 downto 0);
        FoWRCNT  : out std_logic_vector(9 downto 0);
        I2CBSY   : out std_logic;
        I2CRXflg : out std_logic;
        I2Cflg   : out std_logic;
        SCLO     : out std_logic;
        SDAO     : out std_logic
        );
end component;
-- I2C_Slave
component I2C_Slave
    -- Port list
    port(
        -- Inputs
        CLK    : in  std_logic;
        RESETn : in  std_logic;
        SCLi   : in  std_logic;
        SDAi   : in  std_logic;
        -- Outputs
        I2CBSY : out std_logic;
        SCLo   : out std_logic;
        SDAo   : out std_logic
        );
end component;
-- I2C_ZTEST
component I2C_ZTEST
    -- Port list
    port(
        -- Inputs
        DI  : in  std_logic;
        DZi : in  std_logic;
        -- Outputs
        DO  : out std_logic;
        DZx : out std_logic
        );
end component;

component A1500
   port(
      PXL_D     : inout  STD_LOGIC_VECTOR (15 downto 0);  -- Data
      PXL_A     : out    STD_LOGIC_VECTOR (7 downto 0);   -- Address
      PXL_WR    : out    STD_LOGIC;                       -- Write
      PXL_RD    : out    STD_LOGIC;                       -- Read
      PXL_CS    : out    STD_LOGIC;                       -- Chip Select
      PXL_IRQ   : in     STD_LOGIC;                       -- Interrupt Request
      PXL_RESET : in     STD_LOGIC;                       -- Reset
      PXL_IO    : inout  STD_LOGIC_VECTOR (7 downto 0)    -- Spare I/Os
   );
end component;

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
component cy7c1370 IS
-----------------------------------------------------------
    generic (
	addr_bits : INTEGER := 20;
	data_bits : INTEGER := 36;
        -- Timing parameters for -5 (250 Mhz)
    tCYC	: TIME    := 4.0 ns;
    tCH	: TIME    :=  1.7 ns;
    tCL	: TIME    :=  1.7 ns;
    tCO	: TIME    :=  2.6 ns;
    tAS	: TIME    :=  1.2 ns;
    tCENS	: TIME    :=  1.2 ns;
    tWES	: TIME    :=  1.2 ns;
    tDS	: TIME    :=  1.2 ns;
    tAH	: TIME    :=  0.3 ns;
    tCENH	: TIME    :=  0.3 ns;
    tWEH	: TIME    :=  0.3 ns;
    tDH	: TIME    :=  0.3 ns      
         );
    port (
	Dq	: INOUT STD_LOGIC_VECTOR ((data_bits - 1) DOWNTO 0);   	-- Data I/O
	Addr	: IN	STD_LOGIC_VECTOR ((addr_bits - 1) DOWNTO 0);   	-- Address
	Mode	: IN	STD_LOGIC	:= '1'; 			-- Burst Mode
	Clk	: IN	STD_LOGIC;                                   -- Clk
	CEN_n	: IN	STD_LOGIC;                                   -- CEN#
	AdvLd_n	: IN	STD_LOGIC;                                   -- Adv/Ld#
	Bwa_n	: IN	STD_LOGIC;                                   -- Bwa#
	Bwb_n	: IN	STD_LOGIC;                                   -- BWb#
	Bwc_n	: IN	STD_LOGIC;                                   -- Bwc#
	Bwd_n	: IN	STD_LOGIC;                                   -- BWd#
	Rw_n	: IN	STD_LOGIC;                                   -- RW#
	Oe_n	: IN	STD_LOGIC;                                   -- OE#
	Ce1_n	: IN	STD_LOGIC;                                   -- CE1#
	Ce2	: IN	STD_LOGIC;                                   -- CE2
	Ce3_n	: IN	STD_LOGIC;                                   -- CE3#
	Zz	: IN	STD_LOGIC                                    -- Snooze Mode
    );
end component cy7c1370;

-----------------------------------------------------------
component V1390sim IS		-- TRM emulator
-----------------------------------------------------------
   generic	
		(
		hptc_in_sim : IN integer
		);
   port(
	  AM:			in 	std_logic_vector(5 downto 0);
	  AS:			in 	std_logic;
	  BERR: 		out std_logic;
	  DS0: 			in  std_logic;
      DS1: 			in  std_logic;
	  WRITE: 		in  std_logic;
	  GA:			in  std_logic_vector(4 downto 0);
	  IACKB: 		in  std_logic;
      IACKINB: 		in  std_logic;
	  SYSRESB: 		in  std_logic;
	  LWORD: 		inout  std_logic;
	  VAD: 			inout  std_logic_vector (31 downto 1);
      VDB: 			inout  std_logic_vector (31 downto 0);
	  
	  bnc_resin:	in  std_logic;
	  ev_resin:		in  std_logic;
	  clk:			in  std_logic;
	  
	  L0: 			in  std_logic;
      L1A: 			in  std_logic;
      L1R: 			in  std_logic;
      L2A: 			in  std_logic;
      L2R: 			in  std_logic;

	  BUSY: 		out std_logic;
	  DRDY: 		out std_logic;    
      
      DTACK : out    std_logic
   
   );
end component V1390sim;

-----------------------------------------------------------
component vx1392sim IS		-- LTM emulator
-----------------------------------------------------------
   port(
	  AM:			in 	std_logic_vector(5 downto 0);
	  AS:			in 	std_logic;
	  BERR: 		out std_logic;
	  DS0: 			in  std_logic;
      DS1: 			in  std_logic;
	  WRITE: 		in  std_logic;
	  GA:			in  std_logic_vector(4 downto 0);
	  IACK: 		in  std_logic;
      IACKIN: 		in  std_logic;
	  SYSRES: 		in  std_logic;
	  LWORD: 		inout  std_logic;
	  A: 			inout  std_logic_vector (31 downto 1);
      D: 			inout  std_logic_vector (31 downto 0);
	  
	  BNCRES:		in  std_logic;
	  EVRES:		in  std_logic;
	  CLK:			in  std_logic;
	  
	  L0: 			in  std_logic;
      L1A: 			in  std_logic;
      L1R: 			in  std_logic;
      L2A: 			in  std_logic;
      L2R: 			in  std_logic;

	  LTM_BUSY: 	out std_logic;
	  LTM_DRDY:		out std_logic;    
      
      DTACK: 		out std_logic
   );
end component vx1392sim;

-----------------------------------------------------------
   COMPONENT FCT16543P
-----------------------------------------------------------
   GENERIC (
      SIZE : integer
   );
   PORT (
      NCEAB : IN     std_logic;
      NCEBA : IN     std_logic;
      NLEAB : IN     std_logic;
      NLEBA : IN     std_logic;
      NOEAB : IN     std_logic;
      NOEBA : IN     std_logic;
      A     : INOUT  std_logic_vector (SIZE-1 DOWNTO 0);
      B     : INOUT  std_logic_vector (SIZE-1 DOWNTO 0)
   );
   END COMPONENT;

----------------------------------------------------------------------
-- Signal declarations
----------------------------------------------------------------------
signal AUXSCLI_0              : std_logic;
signal AUXSCLO_net_0          : std_logic;
signal AUXSDAI_0              : std_logic;
signal AUXSDAO_net_0          : std_logic;
signal ENVGD_net_0            : std_logic;
signal ERROR_AUX_net_0        : std_logic;
signal FiEMPTY_AUX_net_0      : std_logic;
signal FiRDCNT_net_0          : std_logic_vector(9 downto 0);
signal FiWRCNT_net_0          : std_logic_vector(9 downto 0);
signal FoEMPTY_AUX_net_0      : std_logic;
signal FoRDCNT_net_0          : std_logic_vector(9 downto 0);
signal FoWRCNT_net_0          : std_logic_vector(9 downto 0);
signal GBPS_TX_DISAB_net_0    : std_logic;
signal GBTX_ARST_net_0        : std_logic;
signal GBTX_CONFIG_net_0      : std_logic;
signal GBTX_MODE_net_0        : std_logic_vector(3 downto 0);
signal GBTX_POW_0             : std_logic;
signal GBTX_RESETB_net_0      : std_logic;
signal GBTX_RXDVALID_0        : std_logic;
signal GBTX_RXLOCKM_net_0     : std_logic_vector(1 downto 0);
signal GBTX_RXRDY_net_0       : std_logic;
signal GBTX_SADD_net_0        : std_logic_vector(3 downto 0);
signal GBTX_TESTOUT_i_1       : std_logic;
signal GBTX_TXDVALID_net_0    : std_logic;
signal GBTX_TXRDY_0           : std_logic;
signal I2C_Control_0_FiDATA   : std_logic_vector(7 downto 0);
signal I2C_Control_0_FiWE     : std_logic;
signal I2C_Control_0_FoRE     : std_logic;
signal I2C_Control_0_I2CRUN   : std_logic;
signal I2C_Control_0_RESETn   : std_logic;
signal I2C_Control_0_SYSCLK   : std_logic;
signal I2C_GBTX_0_FiAEMPTY    : std_logic;
signal I2C_GBTX_0_FiAFULL     : std_logic;
signal I2C_GBTX_0_FiFULL      : std_logic;
signal I2C_GBTX_0_FoAEMPTY    : std_logic;
signal I2C_GBTX_0_FoAFULL     : std_logic;
signal I2C_GBTX_0_FoDATA      : std_logic_vector(7 downto 0);
signal I2C_GBTX_0_FoFULL      : std_logic;
signal I2C_ZTEST_ASCL_DZx     : std_logic;
signal I2C_ZTEST_ASDA_DZx     : std_logic;
signal I2C_ZTEST_GSCL_DZx     : std_logic;
signal I2C_ZTEST_GSDA_DZx     : std_logic;
signal I2C_ZTEST_INASCL_DZx   : std_logic;
signal I2C_ZTEST_INASDA_DZx   : std_logic;
signal I2CBSY_AUX_net_0       : std_logic;
signal I2CBSY_GBTX_net_0      : std_logic;
signal I2CBSY_INA_net_0       : std_logic;
signal I2CRXflg_net_0         : std_logic;
signal REFCLKSELECT_net_0     : std_logic;
signal SCLi_INA_net_0         : std_logic;
signal SCLo_INA_net_0         : std_logic;
signal SDAi_INA_net_0         : std_logic;
signal SDAo_INA_net_0         : std_logic;
signal SLVSCLI_net_0          : std_logic;
signal SLVSCLO_net_0          : std_logic;
signal SLVSDAI_net_0          : std_logic;
signal SLVSDAO_net_0          : std_logic;
signal STATEOVERRIDE_net_0    : std_logic;
signal TESTpls_net_0          : std_logic_vector(3 downto 0);
signal SLVSCLO_net_1          : std_logic;
signal SLVSCLI_net_1          : std_logic;
signal SLVSDAI_net_1          : std_logic;
signal SLVSDAO_net_1          : std_logic;
signal I2CRXflg_net_1         : std_logic;
signal AUXSDAO_net_1          : std_logic;
signal AUXSCLO_net_1          : std_logic;
signal AUXSDAI_0_net_0        : std_logic;
signal AUXSCLI_0_net_0        : std_logic;
signal I2CBSY_AUX_net_1       : std_logic;
signal I2CBSY_GBTX_net_1      : std_logic;
signal FiEMPTY_AUX_net_1      : std_logic;
signal FoEMPTY_AUX_net_1      : std_logic;
signal ERROR_AUX_net_1        : std_logic;
signal GBTX_RESETB_net_1      : std_logic;
signal GBTX_TXDVALID_net_1    : std_logic;
signal GBPS_TX_DISAB_net_1    : std_logic;
signal GBTX_ARST_net_1        : std_logic;
signal GBTX_CONFIG_net_1      : std_logic;
signal GBTX_TXRDY_0_net_0     : std_logic;
signal GBTX_TESTOUT_i_1_net_0 : std_logic;
signal GBTX_RXRDY_net_1       : std_logic;
signal STATEOVERRIDE_net_1    : std_logic;
signal REFCLKSELECT_net_1     : std_logic;
signal I2CBSY_INA_net_1       : std_logic;
signal SCLo_INA_net_1         : std_logic;
signal SDAo_INA_net_1         : std_logic;
signal SCLi_INA_net_1         : std_logic;
signal SDAi_INA_net_1         : std_logic;
signal ENVGD_net_1            : std_logic;
signal GBTX_POW_0_net_0       : std_logic;
signal FiWRCNT_net_1          : std_logic_vector(9 downto 0);
signal FiRDCNT_net_1          : std_logic_vector(9 downto 0);
signal FoWRCNT_net_1          : std_logic_vector(9 downto 0);
signal FoRDCNT_net_1          : std_logic_vector(9 downto 0);
signal GBTX_SADD_net_1        : std_logic_vector(3 downto 0);
signal GBTX_MODE_net_1        : std_logic_vector(3 downto 0);
signal GBTX_RXLOCKM_net_1     : std_logic_vector(1 downto 0);
signal TESTpls_net_1          : std_logic_vector(3 downto 0);

signal REFCLK0_N  : std_logic;
signal REFCLK0_P  : std_logic;
signal OPTRX_n, OPTRX_p : std_logic;
signal OPTTX_n, OPTTX_p : std_logic;

signal DO_N:		std_logic_vector(39 downto 0);
signal DO_P:		std_logic_vector(39 downto 0);
signal DI_N:		std_logic_vector(39 downto 0);
signal DI_P:		std_logic_vector(39 downto 0);

signal DCLK00_N:	std_logic;
signal DCLK00_P:	std_logic;
signal FPGACK40_N:	std_logic;
signal FPGACK40_P:	std_logic;
signal FPGACK80_N:	std_logic;
signal FPGACK80_P:	std_logic;
signal CPDMCK40_N:	std_logic;
signal CPDMCK40_P:	std_logic;

signal lvSFP_TXFAULT:	std_logic;
signal lvSFP_LOS:		std_logic;

signal PXL_A:      	std_logic_vector(7 downto 0);    -- address
signal PXL_D:      	std_logic_vector(15 downto 0);   -- data
signal PXL_CS:     	std_logic;                       -- chip select
signal PXL_RD:     	std_logic;                       -- read
signal PXL_WR:     	std_logic;                       -- write
signal PXL_RESET:  	std_logic;                       -- reset towards A1500
signal PXL_IRQ:   	std_logic;                       -- interrupt request
signal PXL_IO:     	std_logic_vector(7 downto 0);    -- spare I/Os

signal RAM_A:		std_logic_vector(19 downto 0);
signal RAM_D:	    std_logic_vector(35 downto 0);
signal RAM_CLK:     std_logic;
signal RAM_CSN:     std_logic;
signal RAM_LDN:     std_logic;
signal RAM_OEN:     std_logic;
signal RAM_WEN:     std_logic;

signal VDB:			std_logic_vector (31 downto 0);
signal VAD:			std_logic_vector (31 downto 1);
signal LWORDB:		std_logic;
signal AML:			std_logic_vector(5 downto 0);

signal ASL:			std_logic;
signal DS0L:		std_logic;
signal DS1L:		std_logic;
signal WRITEL:		std_logic;
signal DTACKB:		std_logic;
signal BERRB:		std_logic;
signal BERRL:		std_logic;
signal IACKL:		std_logic;
signal IRQB1:		std_logic;
signal SYSCLKL:		std_logic;

signal NOEDTW:		std_logic;  
signal NOEDTR:		std_logic;
signal NOEADW:		std_logic;  
signal NOEADR:		std_logic;  
signal NOEMAS:		std_logic;  
signal NOEDRDY:		std_logic; 
signal NOEFAULT:	std_logic;

signal BUNCH_RES:	std_logic;	
signal EVENT_RES:	std_logic;   
signal SPULSEL0:	std_logic;    
signal SPULSEL1:	std_logic;    
signal SPULSEL2:	std_logic;    
signal lvCPDM_FCLKL:std_logic;
signal lvCPDM_SCLKB:std_logic;
signal PULSETGLL:	std_logic;   
signal LTMLTB:		std_logic;      
signal BUSYB:		std_logic;       
signal SPSEOL:		std_logic;      
signal SPSEIB:		std_logic; 

signal lvL0:		std_logic;  
signal lvL1A:		std_logic;
signal lvL1R:		std_logic; 
signal lvL2A:		std_logic;
signal lvL2R:		std_logic;
signal lvSPD0:		std_logic;
     
signal PSM_SP1:		std_logic;		
signal PSM_SP0:		std_logic;			 
signal PXL_SDN:		std_logic;			 
signal SERDES_SDN:	std_logic;		 
signal PSM_SI:		std_logic;			 
signal PSM_SO:		std_logic;			 
signal PSM_SCK:		std_logic;			 
signal PXL_OFF:		std_logic;		

signal CLKLEDR:		std_logic;
signal SCLLED2:		std_logic;
signal CLKLEDG:		std_logic;		
signal FPGALED1:	std_logic;	
signal FPGALED2:	std_logic;	
signal FPGALED3:	std_logic;	
signal FPGALED4:	std_logic;	
signal lvFPGAIO1:	std_logic;	
signal FPGADIR1:	std_logic;	
signal lvFPGAIO2:	std_logic;	
signal FPGADIR2:	std_logic;	
signal lvFPGA_SCOPE:	std_logic;

signal EXTSCL:		std_logic := '1';
signal EXTSDA:		std_logic := '1';	
signal SCL:			std_logic;		
signal SDA:			std_logic;

signal ltm_busy:				std_logic;
signal v1390sim_slot3_busy:		std_logic;		
signal v1390sim_slot4_busy:		std_logic;		
signal v1390sim_slot5_busy:		std_logic;		
signal v1390sim_slot6_busy:		std_logic;		
signal v1390sim_slot7_busy:		std_logic;		
signal v1390sim_slot8_busy:		std_logic;		
signal v1390sim_slot9_busy:		std_logic;		
signal v1390sim_slot10_busy:	std_logic;		
signal v1390sim_slot11_busy:	std_logic;		
signal v1390sim_slot12_busy:	std_logic;	

signal D: 			std_logic_vector (31 downto 0);  -- VME data bus
signal A: 			std_logic_vector (31 downto 1);  -- VME address bus
signal LWORD: 		std_logic;
signal AM:   		std_logic_vector (5 downto 0); 	 -- VME address modifier bus
signal IRQ1:		std_logic;
signal DTACK:		std_logic;
signal BERR:		std_logic;
signal IACK:		std_logic;
signal WRITE:		std_logic;
signal AS:			std_logic;
signal SYSCLK:		std_logic;
signal DS0:			std_logic;
signal DS1:			std_logic;
signal drdy_1:		std_logic_vector(10 downto 0);
signal fault_1:		std_logic_vector(10 downto 0);
signal SPSEI:		std_logic;
signal LTMLT:		std_logic;
signal CPDM_SCLK:	std_logic;
signal CPDM_FCLKL:	std_logic;
signal PULSETGL:	std_logic;
signal SPSEO:		std_logic;
signal SPULSE0:		std_logic;
signal SPULSE1:		std_logic;
signal SPULSE2:		std_logic;
signal busy:		std_logic;
signal counter: 	integer range 0 to 30000;
signal flag_counter:std_logic := '0';
signal SYSRESL:		std_logic;
signal IACKINB:		std_logic;

signal data_from_gbtx:	std_logic_vector(79 downto 0);
signal data_to_gbtx:	std_logic_vector(79 downto 0);
signal bunch_counter: 	unsigned(11 downto 0);
signal orbit_counter: 	unsigned(31 downto 0);
signal data_valid_i:	std_logic;
signal data_valid:		std_logic;
signal tb_acq_on:		std_logic;
signal state_tb_acq:	std_logic_vector(1 downto 0);
signal simulation_time_counter:	unsigned(23 downto 0);
signal tb_data_to_gbtx:			std_logic_vector(83 downto 0);
signal tb_valid_data_to_gbtx:	std_logic;

signal tb_srof_rd:			std_logic;
signal tb_srof_rd1:			std_logic;
signal tb_srof_dto:			std_logic_vector(32 downto 0);

signal geo_address_slot2:	std_logic_vector(4 downto 0) := "01101";
signal geo_address_slot3:	std_logic_vector(4 downto 0) := "01100";
signal geo_address_slot4:	std_logic_vector(4 downto 0) := "01011";
signal geo_address_slot5:	std_logic_vector(4 downto 0) := "01010";
signal geo_address_slot6:	std_logic_vector(4 downto 0) := "01001";
signal geo_address_slot7:	std_logic_vector(4 downto 0) := "01000";
signal geo_address_slot8:	std_logic_vector(4 downto 0) := "00111";
signal geo_address_slot9:	std_logic_vector(4 downto 0) := "00110";
signal geo_address_slot10:	std_logic_vector(4 downto 0) := "00101";
signal geo_address_slot11:	std_logic_vector(4 downto 0) := "00100";
signal geo_address_slot12:	std_logic_vector(4 downto 0) := "00011";

signal orbit_acq:			std_logic;

constant vcc:		std_logic := '1';
constant gnd:		std_logic := '0';
		 

begin
----------------------------------------------------------------------
-- Top level output port assignments
----------------------------------------------------------------------

 SLVSCLO_net_1            <= SLVSCLO_net_0;
 SLVSCLO                  <= SLVSCLO_net_1;
 SLVSCLI_net_1            <= SLVSCLI_net_0;
 SLVSCLI                  <= SLVSCLI_net_1;
 SLVSDAI_net_1            <= SLVSDAI_net_0;
 SLVSDAI                  <= SLVSDAI_net_1;
 SLVSDAO_net_1            <= SLVSDAO_net_0;
 SLVSDAO                  <= SLVSDAO_net_1;
 I2CRXflg_net_1           <= I2CRXflg_net_0;
 I2CRXflg                 <= I2CRXflg_net_1;
 AUXSDAO_net_1            <= AUXSDAO_net_0;
 AUXSDAO                  <= AUXSDAO_net_1;
 AUXSCLO_net_1            <= AUXSCLO_net_0;
 AUXSCLO                  <= AUXSCLO_net_1;
 AUXSDAI_0_net_0          <= AUXSDAI_0;
 AUXSDAI                  <= AUXSDAI_0_net_0;
 AUXSCLI_0_net_0          <= AUXSCLI_0;
 AUXSCLI                  <= AUXSCLI_0_net_0;
 I2CBSY_AUX_net_1         <= I2CBSY_AUX_net_0;
 I2CBSY_AUX               <= I2CBSY_AUX_net_1;
 I2CBSY_GBTX_net_1        <= I2CBSY_GBTX_net_0;
 I2CBSY_GBTX              <= I2CBSY_GBTX_net_1;
 FiEMPTY_AUX_net_1        <= FiEMPTY_AUX_net_0;
 FiEMPTY_AUX              <= FiEMPTY_AUX_net_1;
 FoEMPTY_AUX_net_1        <= FoEMPTY_AUX_net_0;
 FoEMPTY_AUX              <= FoEMPTY_AUX_net_1;
 ERROR_AUX_net_1          <= ERROR_AUX_net_0;
 ERROR_AUX                <= ERROR_AUX_net_1;
 GBTX_RESETB_net_1        <= GBTX_RESETB_net_0;
 GBTX_RESETB              <= GBTX_RESETB_net_1;
 GBTX_TXDVALID_net_1      <= GBTX_TXDVALID_net_0;
 GBTX_TXDVALID            <= GBTX_TXDVALID_net_1;
 GBPS_TX_DISAB_net_1      <= GBPS_TX_DISAB_net_0;
 GBPS_TX_DISAB            <= GBPS_TX_DISAB_net_1;
 GBTX_ARST_net_1          <= GBTX_ARST_net_0;
 GBTX_ARST                <= GBTX_ARST_net_1;
 GBTX_CONFIG_net_1        <= GBTX_CONFIG_net_0;
 GBTX_CONFIG              <= GBTX_CONFIG_net_1;
 GBTX_TXRDY_0_net_0       <= GBTX_TXRDY_0;
 GBTX_TXRDY               <= GBTX_TXRDY_0_net_0;
 GBTX_TESTOUT_i_1_net_0   <= GBTX_TESTOUT_i_1;
 GBTX_TESTOUT_i           <= GBTX_TESTOUT_i_1_net_0;
 GBTX_RXRDY_net_1         <= GBTX_RXRDY_net_0;
 GBTX_RXRDY               <= GBTX_RXRDY_net_1;
 STATEOVERRIDE_net_1      <= STATEOVERRIDE_net_0;
 STATEOVERRIDE            <= STATEOVERRIDE_net_1;
 REFCLKSELECT_net_1       <= REFCLKSELECT_net_0;
 REFCLKSELECT             <= REFCLKSELECT_net_1;
 I2CBSY_INA_net_1         <= I2CBSY_INA_net_0;
 I2CBSY_INA               <= I2CBSY_INA_net_1;
 SCLo_INA_net_1           <= SCLo_INA_net_0;
 SCLo_INA                 <= SCLo_INA_net_1;
 SDAo_INA_net_1           <= SDAo_INA_net_0;
 SDAo_INA                 <= SDAo_INA_net_1;
 SCLi_INA_net_1           <= SCLi_INA_net_0;
 SCLi_INA                 <= SCLi_INA_net_1;
 SDAi_INA_net_1           <= SDAi_INA_net_0;
 SDAi_INA                 <= SDAi_INA_net_1;
 ENVGD_net_1              <= ENVGD_net_0;
 ENVGD                    <= ENVGD_net_1;
 GBTX_POW_0_net_0         <= GBTX_POW_0;
 GBTX_POW                 <= GBTX_POW_0_net_0;
 FiWRCNT_net_1            <= FiWRCNT_net_0;
 FiWRCNT(9 downto 0)      <= FiWRCNT_net_1;
 FiRDCNT_net_1            <= FiRDCNT_net_0;
 FiRDCNT(9 downto 0)      <= FiRDCNT_net_1;
 FoWRCNT_net_1            <= FoWRCNT_net_0;
 FoWRCNT(9 downto 0)      <= FoWRCNT_net_1;
 FoRDCNT_net_1            <= FoRDCNT_net_0;
 FoRDCNT(9 downto 0)      <= FoRDCNT_net_1;
 GBTX_SADD_net_1          <= GBTX_SADD_net_0;
 GBTX_SADD(3 downto 0)    <= GBTX_SADD_net_1;
 GBTX_MODE_net_1          <= GBTX_MODE_net_0;
 GBTX_MODE(3 downto 0)    <= GBTX_MODE_net_1;
 GBTX_RXLOCKM_net_1       <= GBTX_RXLOCKM_net_0;
 GBTX_RXLOCKM(1 downto 0) <= GBTX_RXLOCKM_net_1;
 TESTpls_net_1            <= TESTpls_net_0;
 TESTpls(3 downto 0)      <= TESTpls_net_1;
 
 irq1 <= NOT(v1390sim_slot3_busy OR v1390sim_slot4_busy OR v1390sim_slot5_busy OR v1390sim_slot6_busy OR
		 v1390sim_slot7_busy OR v1390sim_slot8_busy OR v1390sim_slot9_busy OR v1390sim_slot10_busy OR
		 v1390sim_slot11_busy OR v1390sim_slot12_busy);
 
    sig_spy : process is
   begin
     init_signal_spy("DRM2_top_inst0/GBTx_interface_instance/acq_on", "tb_acq_on");
     wait;
   end process sig_spy;
 
process(DCLK00_P)
	begin
	if(falling_edge(DCLK00_P)) then
		DO_P(0)		<= data_from_gbtx(1) after 2 ns;   DO_N(0)	<= not(data_from_gbtx(1)) after 2 ns;
		DO_P(1)		<= data_from_gbtx(3) after 2 ns;   DO_N(1)	<= not(data_from_gbtx(3)) after 2 ns;
		DO_P(2)		<= data_from_gbtx(5) after 2 ns;   DO_N(2)	<= not(data_from_gbtx(5)) after 2 ns;
		DO_P(3)		<= data_from_gbtx(7) after 2 ns;   DO_N(3)	<= not(data_from_gbtx(7)) after 2 ns;
		DO_P(4)		<= data_from_gbtx(9) after 2 ns;   DO_N(4)	<= not(data_from_gbtx(9)) after 2 ns;
		DO_P(5)		<= data_from_gbtx(11) after 2 ns;  DO_N(5)	<= not(data_from_gbtx(11)) after 2 ns;
		DO_P(6)		<= data_from_gbtx(13) after 2 ns;  DO_N(6)	<= not(data_from_gbtx(13)) after 2 ns;
		DO_P(7)		<= data_from_gbtx(15) after 2 ns;  DO_N(7)	<= not(data_from_gbtx(15)) after 2 ns;
		
		DO_P(8)		<= data_from_gbtx(17) after 2 ns;  DO_N(8)	<= not(data_from_gbtx(17)) after 2 ns;
		DO_P(9)		<= data_from_gbtx(19) after 2 ns;  DO_N(9)	<= not(data_from_gbtx(19)) after 2 ns;
		DO_P(10)	<= data_from_gbtx(21) after 2 ns;  DO_N(10)	<= not(data_from_gbtx(21)) after 2 ns;
		DO_P(11)	<= data_from_gbtx(23) after 2 ns;  DO_N(11)	<= not(data_from_gbtx(23)) after 2 ns;
		DO_P(12)	<= data_from_gbtx(25) after 2 ns;  DO_N(12)	<= not(data_from_gbtx(25)) after 2 ns;
		DO_P(13)	<= data_from_gbtx(27) after 2 ns;  DO_N(13)	<= not(data_from_gbtx(27)) after 2 ns;
		DO_P(14)	<= data_from_gbtx(29) after 2 ns;  DO_N(14)	<= not(data_from_gbtx(29)) after 2 ns;
		DO_P(15)	<= data_from_gbtx(31) after 2 ns;  DO_N(15)	<= not(data_from_gbtx(31)) after 2 ns;
		
		DO_P(16)	<= data_from_gbtx(33) after 2 ns;  DO_N(16)	<= not(data_from_gbtx(33)) after 2 ns;
		DO_P(17)	<= data_from_gbtx(35) after 2 ns;  DO_N(17)	<= not(data_from_gbtx(35)) after 2 ns;
		DO_P(18)	<= data_from_gbtx(37) after 2 ns;  DO_N(18)	<= not(data_from_gbtx(37)) after 2 ns;
		DO_P(19)	<= data_from_gbtx(39) after 2 ns;  DO_N(19)	<= not(data_from_gbtx(39)) after 2 ns;
		DO_P(20)	<= data_from_gbtx(41) after 2 ns;  DO_N(20)	<= not(data_from_gbtx(41)) after 2 ns;
		DO_P(21)	<= data_from_gbtx(43) after 2 ns;  DO_N(21)	<= not(data_from_gbtx(43)) after 2 ns;
		DO_P(22)	<= data_from_gbtx(45) after 2 ns;  DO_N(22)	<= not(data_from_gbtx(45)) after 2 ns;
		DO_P(23)	<= data_from_gbtx(47) after 2 ns;  DO_N(23)	<= not(data_from_gbtx(47)) after 2 ns;
		
		DO_P(24)	<= data_from_gbtx(49) after 2 ns;  DO_N(24)	<= not(data_from_gbtx(49)) after 2 ns;
		DO_P(25)	<= data_from_gbtx(51) after 2 ns;  DO_N(25)	<= not(data_from_gbtx(51)) after 2 ns;
		DO_P(26)	<= data_from_gbtx(53) after 2 ns;  DO_N(26)	<= not(data_from_gbtx(53)) after 2 ns;
		DO_P(27)	<= data_from_gbtx(55) after 2 ns;  DO_N(27)	<= not(data_from_gbtx(55)) after 2 ns;
		DO_P(28)	<= data_from_gbtx(57) after 2 ns;  DO_N(28)	<= not(data_from_gbtx(57)) after 2 ns;
		DO_P(29)	<= data_from_gbtx(59) after 2 ns;  DO_N(29)	<= not(data_from_gbtx(59)) after 2 ns;
		DO_P(30)	<= data_from_gbtx(61) after 2 ns;  DO_N(30)	<= not(data_from_gbtx(61)) after 2 ns;
		DO_P(31)	<= data_from_gbtx(63) after 2 ns;  DO_N(31)	<= not(data_from_gbtx(63)) after 2 ns;
		
		DO_P(32)	<= data_from_gbtx(65) after 2 ns;  DO_N(32)	<= not(data_from_gbtx(65)) after 2 ns;
		DO_P(33)	<= data_from_gbtx(67) after 2 ns;  DO_N(33)	<= not(data_from_gbtx(67)) after 2 ns;
		DO_P(34)	<= data_from_gbtx(69) after 2 ns;  DO_N(34)	<= not(data_from_gbtx(69)) after 2 ns;
		DO_P(35)	<= data_from_gbtx(71) after 2 ns;  DO_N(35)	<= not(data_from_gbtx(71)) after 2 ns;
		DO_P(36)	<= data_from_gbtx(73) after 2 ns;  DO_N(36)	<= not(data_from_gbtx(73)) after 2 ns;
		DO_P(37)	<= data_from_gbtx(75) after 2 ns;  DO_N(37)	<= not(data_from_gbtx(75)) after 2 ns;
		DO_P(38)	<= data_from_gbtx(77) after 2 ns;  DO_N(38)	<= not(data_from_gbtx(77)) after 2 ns;
		DO_P(39)	<= data_from_gbtx(79) after 2 ns;  DO_N(39)	<= not(data_from_gbtx(79)) after 2 ns;
	
	elsif(rising_edge(DCLK00_P)) then
		DO_P(0)		<= data_from_gbtx(0) after 2 ns;   DO_N(0)	<= not(data_from_gbtx(0)) after 2 ns;
		DO_P(1)		<= data_from_gbtx(2) after 2 ns;   DO_N(1)	<= not(data_from_gbtx(2)) after 2 ns;
		DO_P(2)		<= data_from_gbtx(4) after 2 ns;   DO_N(2)	<= not(data_from_gbtx(4)) after 2 ns;
		DO_P(3)		<= data_from_gbtx(6) after 2 ns;   DO_N(3)	<= not(data_from_gbtx(6)) after 2 ns;
		DO_P(4)		<= data_from_gbtx(8) after 2 ns;   DO_N(4)	<= not(data_from_gbtx(8)) after 2 ns;
		DO_P(5)		<= data_from_gbtx(10) after 2 ns;  DO_N(5)	<= not(data_from_gbtx(10)) after 2 ns;
		DO_P(6)		<= data_from_gbtx(12) after 2 ns;  DO_N(6)	<= not(data_from_gbtx(12)) after 2 ns;
		DO_P(7)		<= data_from_gbtx(14) after 2 ns;  DO_N(7)	<= not(data_from_gbtx(14)) after 2 ns;
		
		DO_P(8)		<= data_from_gbtx(16) after 2 ns;  DO_N(8)	<= not(data_from_gbtx(16)) after 2 ns;
		DO_P(9)		<= data_from_gbtx(18) after 2 ns;  DO_N(9)	<= not(data_from_gbtx(18)) after 2 ns;
		DO_P(10)	<= data_from_gbtx(20) after 2 ns;  DO_N(10)	<= not(data_from_gbtx(20)) after 2 ns;
		DO_P(11)	<= data_from_gbtx(22) after 2 ns;  DO_N(11)	<= not(data_from_gbtx(22)) after 2 ns;
		DO_P(12)	<= data_from_gbtx(24) after 2 ns;  DO_N(12)	<= not(data_from_gbtx(24)) after 2 ns;
		DO_P(13)	<= data_from_gbtx(26) after 2 ns;  DO_N(13)	<= not(data_from_gbtx(26)) after 2 ns;
		DO_P(14)	<= data_from_gbtx(28) after 2 ns;  DO_N(14)	<= not(data_from_gbtx(28)) after 2 ns;
		DO_P(15)	<= data_from_gbtx(30) after 2 ns;  DO_N(15)	<= not(data_from_gbtx(30)) after 2 ns;
		
		DO_P(16)	<= data_from_gbtx(32) after 2 ns;  DO_N(16)	<= not(data_from_gbtx(32)) after 2 ns;
		DO_P(17)	<= data_from_gbtx(34) after 2 ns;  DO_N(17)	<= not(data_from_gbtx(34)) after 2 ns;
		DO_P(18)	<= data_from_gbtx(36) after 2 ns;  DO_N(18)	<= not(data_from_gbtx(36)) after 2 ns;
		DO_P(19)	<= data_from_gbtx(38) after 2 ns;  DO_N(19)	<= not(data_from_gbtx(38)) after 2 ns;
		DO_P(20)	<= data_from_gbtx(40) after 2 ns;  DO_N(20)	<= not(data_from_gbtx(40)) after 2 ns;
		DO_P(21)	<= data_from_gbtx(42) after 2 ns;  DO_N(21)	<= not(data_from_gbtx(42)) after 2 ns;
		DO_P(22)	<= data_from_gbtx(44) after 2 ns;  DO_N(22)	<= not(data_from_gbtx(44)) after 2 ns;
		DO_P(23)	<= data_from_gbtx(46) after 2 ns;  DO_N(23)	<= not(data_from_gbtx(46)) after 2 ns;
		
		DO_P(24)	<= data_from_gbtx(48) after 2 ns;  DO_N(24)	<= not(data_from_gbtx(48)) after 2 ns;
		DO_P(25)	<= data_from_gbtx(50) after 2 ns;  DO_N(25)	<= not(data_from_gbtx(50)) after 2 ns;
		DO_P(26)	<= data_from_gbtx(52) after 2 ns;  DO_N(26)	<= not(data_from_gbtx(52)) after 2 ns;
		DO_P(27)	<= data_from_gbtx(54) after 2 ns;  DO_N(27)	<= not(data_from_gbtx(54)) after 2 ns;
		DO_P(28)	<= data_from_gbtx(56) after 2 ns;  DO_N(28)	<= not(data_from_gbtx(56)) after 2 ns;
		DO_P(29)	<= data_from_gbtx(58) after 2 ns;  DO_N(29)	<= not(data_from_gbtx(58)) after 2 ns;
		DO_P(30)	<= data_from_gbtx(60) after 2 ns;  DO_N(30)	<= not(data_from_gbtx(60)) after 2 ns;
		DO_P(31)	<= data_from_gbtx(62) after 2 ns;  DO_N(31)	<= not(data_from_gbtx(62)) after 2 ns;
		
		DO_P(32)	<= data_from_gbtx(64) after 2 ns;  DO_N(32)	<= not(data_from_gbtx(64)) after 2 ns;
		DO_P(33)	<= data_from_gbtx(66) after 2 ns;  DO_N(33)	<= not(data_from_gbtx(66)) after 2 ns;
		DO_P(34)	<= data_from_gbtx(68) after 2 ns;  DO_N(34)	<= not(data_from_gbtx(68)) after 2 ns;
		DO_P(35)	<= data_from_gbtx(70) after 2 ns;  DO_N(35)	<= not(data_from_gbtx(70)) after 2 ns;
		DO_P(36)	<= data_from_gbtx(72) after 2 ns;  DO_N(36)	<= not(data_from_gbtx(72)) after 2 ns;
		DO_P(37)	<= data_from_gbtx(74) after 2 ns;  DO_N(37)	<= not(data_from_gbtx(74)) after 2 ns;
		DO_P(38)	<= data_from_gbtx(76) after 2 ns;  DO_N(38)	<= not(data_from_gbtx(76)) after 2 ns;
		DO_P(39)	<= data_from_gbtx(78) after 2 ns;  DO_N(39)	<= not(data_from_gbtx(78)) after 2 ns;
		
		-- DO_N		<= "1111111111111111111111111111111111011111";
		-- DO_P		<= "0000000000000000000000000000000000100000";
	end if;
end process;

   triggers_from_gbt_process: process(I2C_Control_0_RESETn, DCLK00_P) 
      variable commonWordCounter:                    unsigned(15 downto 0);
	  constant TRIGGER_PERIOD:						 unsigned(15 downto 0) := x"03FF";	-- was x"27F6";
	  constant fixed_bcid_0:						 unsigned(11 downto 0) := x"256";
	  constant fixed_bcid_1:						 unsigned(11 downto 0) := x"6F6";
	  constant fixed_bcid_2:						 unsigned(11 downto 0) := x"B9A";
   begin                                      
      if(I2C_Control_0_RESETn = '0') then                          
         commonWordCounter                          := (others => '0');  
         bunch_counter                              <= (others => '0');
         orbit_counter                              <= (others => '0');
		 simulation_time_counter					<= (others => '0');
         data_from_gbtx                             <= (others => '0');
		 data_valid									<= '0';
		 state_tb_acq								<= "00";
      elsif(rising_edge(DCLK00_P)) then 
	  
		 simulation_time_counter	<= simulation_time_counter + 1;
         if(bunch_counter = x"0") then       -- conto da 0 a 3563
             bunch_counter   		<= bunch_counter + 1;
         elsif(bunch_counter = x"DEB") then
             bunch_counter   		<= (others => '0');
         else
             bunch_counter   		<= bunch_counter + 1;
         end if;
         if(bunch_counter = x"DEB") then
             orbit_counter   <= orbit_counter + 1;
         end if;
         
		data_from_gbtx(31 downto 1)      <= (others => '0');
		data_from_gbtx(47 downto 32)     <= "0000" & std_logic_vector(bunch_counter);
		data_from_gbtx(79 downto 48)     <= std_logic_vector(orbit_counter);
		
		if(state_tb_acq = "00") then				-- waiting for acq_on
			--if(tb_acq_on = '1') then
			if(simulation_time_counter = x"015FFF") then
				state_tb_acq			<= "01";
			else
				state_tb_acq			<= "00";
			end if;
			commonWordCounter 		:= (others => '0');	
			data_from_gbtx(RT_TT)   <= '0';      -- RT
			data_from_gbtx(RS_TT)   <= '0';      -- RS
			data_from_gbtx(EOC_TT)  <= '0';		
			orbit_acq				<= '0';	
			if(bunch_counter = x"0") then
				data_from_gbtx(HB_TT)       <= '1';      -- HB
				data_from_gbtx(HBr_TT)      <= '0';      -- HBr
				data_from_gbtx(RT_TT)    	<= '0';      -- RT
				data_from_gbtx(RS_TT)    	<= '0';      -- RS
				data_valid                  <= '1';
			else
				data_from_gbtx(HB_TT)       <= '0';      -- HB
				data_from_gbtx(HBr_TT)      <= '0';      -- HBr
				data_from_gbtx(ORBIT_TT)    <= '0';      -- BCR
				data_from_gbtx(RT_TT)    	<= '0';      -- RT
				data_from_gbtx(RS_TT)    	<= '0';      -- RS
				data_valid                  <= '0';
			end if;			
		elsif(state_tb_acq = "01") then				-- providing SOC
			if(bunch_counter = x"0") then
				data_from_gbtx(SOC_TT)      <= '1';
				data_from_gbtx(HB_TT)       <= '1';      -- HB
				data_from_gbtx(HBr_TT)      <= '0';      -- HBr
				data_from_gbtx(RT_TT)    	<= '1';      -- RT
				data_from_gbtx(RS_TT)    	<= '1';      -- RS
				data_valid                  <= '1';
				state_tb_acq				<= "10";
			else
				data_from_gbtx(SOC_TT)      <= '0';
				data_from_gbtx(HB_TT)       <= '0';      -- HB
				data_from_gbtx(HBr_TT)      <= '0';      -- HBr
				data_from_gbtx(ORBIT_TT)    <= '0';      -- BCR
				data_from_gbtx(RT_TT)    	<= '0';      -- RT
				data_from_gbtx(RS_TT)    	<= '0';      -- RS
				data_valid                  <= '0';
				state_tb_acq				<= "01";
			end if;		
			orbit_acq				<= '0';						
		elsif(state_tb_acq = "10") then				-- providing TOF special triggers
			if(commonWordCounter = TRIGGER_PERIOD) then
				commonWordCounter         := (others => '0');
			else
				commonWordCounter         := commonWordCounter + 1;
			end if;
			-----------------------------------------------------------------------------------
			-- fixed-BC triggers --------------------------------------------------------------  
			-----------------------------------------------------------------------------------
			if(bunch_counter = x"0") then 
				commonWordCounter                  := (others => '0');
				data_from_gbtx(TOF_TT)             <= '0';      	-- special TOF trigger
				data_from_gbtx(HB_TT)              <= '1';      	-- HB
				data_from_gbtx(HBr_TT)      	   <= '0'; 			-- HBr
				data_from_gbtx(ORBIT_TT)           <= '1';      	-- BCR
				data_from_gbtx(RT_TT)    		   <= '1';      	-- RT
				data_from_gbtx(RS_TT)    		   <= '1';      	-- RS
				data_valid                         <= '1';
				orbit_acq						   <= not orbit_acq;
			elsif(bunch_counter = fixed_bcid_0 or bunch_counter = fixed_bcid_1 or bunch_counter = fixed_bcid_2) then  -- fixed-BC encoded values
				commonWordCounter                  := (others => '0');
				data_from_gbtx(TOF_TT)             <= '1';      -- special TOF trigger
				data_from_gbtx(HB_TT)              <= '0';      -- HB
				data_from_gbtx(HBr_TT)      	   <= '0';      -- HBr
				data_from_gbtx(ORBIT_TT)           <= '0';      -- BCR
				data_from_gbtx(RT_TT)    		   <= '1';      -- RT
				data_from_gbtx(RS_TT)    		   <= '1';      -- RS
				data_valid                         <= '1';  
			else                             
				commonWordCounter                  := commonWordCounter + 1;
				data_from_gbtx(TOF_TT)             <= '0';     -- special TOF trigger
				data_from_gbtx(HB_TT)              <= '0';     -- HB
				data_from_gbtx(HBr_TT)      	   <= '0';     -- HBr
				data_from_gbtx(ORBIT_TT)           <= '0';     -- BCR
				data_from_gbtx(RT_TT)    		   <= '1';      -- RT
				data_from_gbtx(RS_TT)    		   <= '1';      -- RS
				data_valid                         <= '0';
			end if;  
			data_from_gbtx(SOC_TT)           <= '0';
		
			if(simulation_time_counter = x"FFFFFF") then
				state_tb_acq			<= "11";
			else
				state_tb_acq			<= "10";
			end if;
		else										-- providing EOC
			if(bunch_counter = x"0") then
				data_from_gbtx(EOC_TT)      <= '1';
				data_from_gbtx(HB_TT)       <= '1';      -- HB
				data_from_gbtx(HBr_TT)     	<= '0';      -- HBr
				data_from_gbtx(ORBIT_TT)    <= '1';      -- BCR
				data_from_gbtx(RT_TT)    	<= '1';      -- RT
				data_from_gbtx(RS_TT)    	<= '1';      -- RS
				state_tb_acq				<= "00";
				orbit_acq					<= '0';
			else
				data_from_gbtx(EOC_TT)      <= '0';
				data_from_gbtx(HB_TT)       <= '0';      -- HB
				data_from_gbtx(HBr_TT)     	<= '0';      -- HBr
				data_from_gbtx(ORBIT_TT)    <= '0';      -- BCR
				data_from_gbtx(RT_TT)    	<= '1';      -- RT
				data_from_gbtx(RS_TT)    	<= '1';      -- RS
				state_tb_acq				<= "11";
			end if;	
		end if;
		
		-----------------------------------------------------------------------------------
		-- periodic physics triggers ------------------------------------------------------  
		----------------------------------------------------------------------------------- 
		-- if(commonWordCounter = TRIGGER_PERIOD and bunch_counter = x"0") then 
			-- data_valid		                   <= '1';
			-- data_from_gbtx(TOF_TT)             <= '1';      				-- TOF special trigger
			-- data_from_gbtx(HB_TT)			   <= '1'; 						-- HB
			-- data_from_gbtx(ORBIT_TT)		   <= '1';         				-- BCR
		-- elsif(commonWordCounter = TRIGGER_PERIOD) then
			-- data_valid		                   <= '1';
			-- data_from_gbtx(TOF_TT)             <= '1';      				-- TOF special trigger
			-- data_from_gbtx(HB_TT)			   <= '0'; 						-- HB
			-- data_from_gbtx(ORBIT_TT)		   <= '0';         				
		-- elsif(bunch_counter = x"0") then
			-- data_valid		                   <= '1';
			-- data_from_gbtx(TOF_TT)             <= '0';      				-- TOF special trigger
			-- data_from_gbtx(HB_TT)			   <= '1';						-- HB
			-- data_from_gbtx(ORBIT_TT)		   <= '1';         				-- BCR
		-- else                             
			-- data_valid		                   <= '0';						-- no trigger
			-- data_from_gbtx(TOF_TT)             <= '0'; 
			-- data_from_gbtx(HB_TT)              <= '0'; 
			-- data_from_gbtx(ORBIT_TT)		   <= '0';         				
		-- end if;  
         
      end if;
   end process triggers_from_gbt_process;
   
   GBTX_RXDVALID_0	<= data_valid;
		
----------------------------------------------------------------------
-- Component instances
----------------------------------------------------------------------
-- DRM2_top_inst0
DRM2_top_inst0 : DRM2_top
    port map( 
        -- Inputs
        DEVRST_N      => I2C_Control_0_RESETn,
		SYSRESL		  => SYSRESL,
		PROGL		  => open,
		
		DCLK00_N	  => DCLK00_N,
		DCLK00_P	  => DCLK00_P,
		FPGACK40_N	  => FPGACK40_N,	
		FPGACK40_P	  => FPGACK40_P,	
		FPGACK80_N	  => FPGACK80_N,	
		FPGACK80_P	  => FPGACK80_P,		
		CPDMCK40_N	  => CPDMCK40_N,
		CPDMCK40_P	  => CPDMCK40_P,	
		lvCLKLOS	  => '0',
		
		CLK_SEL1	  => open,
		CLK_SEL2	  => open,
		
		DI_N		  => DI_N,
		DI_P		  => DI_P,
		DO_N		  => DO_N,
		DO_P		  => DO_P,
		
		GBTX_RESETB   => GBTX_RESETB_net_0,
		GBTX_RXRDY    => '1',
		GBTX_TXRDY    => GBTX_TXRDY_0,
		GBTX_CONFIG   => GBTX_CONFIG_net_0,
		GBTX_RXDVALID => GBTX_RXDVALID_0,
		GBTX_SDA      => I2C_ZTEST_GSDA_DZx,
        GBTX_SCL      => I2C_ZTEST_GSCL_DZx,
		GBTX_TXDVALID => GBTX_TXDVALID_net_0,
        GBTX_TESTOUT  => GBTX_TESTOUT_i_1,
		
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
					  
		lvSFP_TXDISAB => open,
		lvSFP_TXFAULT => lvSFP_TXFAULT,
		lvSFP_LOS	  => lvSFP_LOS,
		
		-- A1500
		PXL_A		  => PXL_A,
		PXL_D		  => PXL_D,
		PXL_CS		  => PXL_CS,
		PXL_RD		  => PXL_RD,
		PXL_WR		  => PXL_WR,
		PXL_RESET	  => PXL_RESET,
		PXL_IRQ		  => PXL_IRQ,
		PXL_IO		  => PXL_IO(1 downto 0),
		-- SSRAM
		RAM_A		  => RAM_A,		
		RAM_D		  => RAM_D,	
		RAM_CLK		  => RAM_CLK,
		RAM_CSN		  => RAM_CSN,
		RAM_LDN		  => RAM_LDN,
		RAM_OEN		  => RAM_OEN,
		RAM_WEN		  => RAM_WEN,
		-- VME buses (data + address + address modifier)
		VDB  		  => VDB,    
		VAD     	  => VAD,   
		LWORDB  	  => LWORDB,
		AML     	  => AML,   
		-- VME control signals
		ASL    		  => ASL,    
		DS0L    	  => DS0L,   
		DS1L          => DS1L,   
		WRITEL  	  => WRITEL, 
		DTACKB  	  => DTACKB, 
		BERRB   	  => BERRB,  
		BERRL   	  => BERRL,  
		IACKL   	  => IACKL,  
		IRQB1   	  => IRQB1,
		-- VME transceiver signals
		NOEDTW  	  => NOEDTW,  
		NOEDTR   	  => NOEDTR,  
		NOEADW   	  => NOEADW,  
		NOEADR   	  => NOEADR,  
		NOEMAS   	  => NOEMAS,  
		NOEDRDY  	  => NOEDRDY, 
		NOEFAULT 	  => NOEFAULT,
		-- custom signals on P2 VME connector
		BUNCH_RES	  => BUNCH_RES,	   
		EVENT_RES     => EVENT_RES,   
		SPULSEL0      => SPULSEL0,    
		SPULSEL1      => SPULSEL1,    
		SPULSEL2      => SPULSEL2,    
		lvCPDM_FCLKL  => lvCPDM_FCLKL,
		lvCPDM_SCLKB  => lvCPDM_SCLKB,
		PULSETGLL     => PULSETGLL,   
		LTMLTB        => LTMLTB,      
		BUSYB         => BUSYB,       
		SPSEOL        => SPSEOL,      
		SPSEIB        => SPSEIB,     
		
		lvL0  		  => lvL0,  
		lvL1A 		  => lvL1A, 
		lvL1R 		  => lvL1R, 
		lvL2A 		  => lvL2A, 
		lvL2R 		  => lvL2R, 
		lvSPD0		  => lvSPD0,
		-- ATMEGA signals
		PSM_SP1		  => PSM_SP1,			
		PSM_SP0		  => PSM_SP0,		
		PXL_SDN		  => PXL_SDN,		
		SERDES_SDN	  => SERDES_SDN,	
		PSM_SI		  => PSM_SI,		
		PSM_SO		  => PSM_SO,		
		PSM_SCK		  => PSM_SCK,		
		PXL_OFF		  => PXL_OFF,	
		--e-fuses
		lvEFUSEENAB	  => open,
		EFUSESYNC	  => open,	 
		-- front panel
		CLKLEDR		  => CLKLEDR,			
		SCLLED2		  => SCLLED2,			  
		CLKLEDG		  => CLKLEDG,			
		FPGALED1	  => FPGALED1,		
		FPGALED2	  => FPGALED2,		
		FPGALED3	  => FPGALED3,		
		FPGALED4	  => FPGALED4,		
		lvFPGAIO1	  => lvFPGAIO1,		
		FPGADIR1	  => FPGADIR1,		
		lvFPGAIO2	  => lvFPGAIO2,		
		FPGADIR2	  => FPGADIR2,		
		lvFPGA_SCOPE => lvFPGA_SCOPE,
		-- NI 8451 i2c
		EXTSCL		  => EXTSCL,	
		EXTSDA		  => EXTSDA,	
		SCL			  => SCL,		
		SDA			  => SDA		
        );

			
-- I2C_Control_0
I2C_Control_0 : I2C_Control
    port map( 
        -- Inputs
        GBTX_ARST      => GBTX_ARST_net_0,
        GBTX_CONFIG    => GBTX_CONFIG_net_0,
        REFCLKSELECT   => REFCLKSELECT_net_0,
        STATEOVERRIDE  => STATEOVERRIDE_net_0,
        GBTX_TESTOUTf  => GBTX_TESTOUT_i_1,
        GBPS_TX_DISAB  => GBPS_TX_DISAB_net_0,
        GBTX_TXDVALID  => GBTX_TXDVALID_net_0,
        GBTX_RXDVALIDf => GBTX_RXDVALID_0,
        GBTX_RXRDYf    => GBTX_RXRDY_net_0,
        GBTX_TXRDYf    => GBTX_TXRDY_0,
        GBTX_RESETB    => GBTX_RESETB_net_0,
        FiEMPTY        => FiEMPTY_AUX_net_0,
        ENVGD          => ENVGD_net_0,
        ERROR          => ERROR_AUX_net_0,
        FiFULL         => I2C_GBTX_0_FiFULL,
        FiAEMPTY       => I2C_GBTX_0_FiAEMPTY,
        FiAFULL        => I2C_GBTX_0_FiAFULL,
        FoAEMPTY       => I2C_GBTX_0_FoAEMPTY,
        FoAFULL        => I2C_GBTX_0_FoAFULL,
        FoEMPTY        => FoEMPTY_AUX_net_0,
        FoFULL         => I2C_GBTX_0_FoFULL,
        I2CBSY_GBTX    => I2CBSY_GBTX_net_0,
        I2CBSY_AUX     => I2CBSY_AUX_net_0,
        GBTX_MODE      => GBTX_MODE_net_0,
        GBTX_SADD      => GBTX_SADD_net_0,
        GBTX_RXLOCKM   => GBTX_RXLOCKM_net_0,
        FoDATA         => I2C_GBTX_0_FoDATA,
        -- Outputs
        GBTX_TESTOUT   => GBTX_TESTOUT_i_1,
        GBTX_RXDVALID  => open,
        GBTX_RXRDY     => GBTX_RXRDY_net_0,
        GBTX_TXRDY     => GBTX_TXRDY_0,
        GBTX_POW       => GBTX_POW_0,
        SYSCLK         => I2C_Control_0_SYSCLK,
        FiWE           => I2C_Control_0_FiWE,
        FoRE           => I2C_Control_0_FoRE,
        I2CRUN         => I2C_Control_0_I2CRUN,
        RESETn         => I2C_Control_0_RESETn,
        FiDATA         => I2C_Control_0_FiDATA 
        );

-----------------------------------------------------------
I_CONET_MASTER : CONET_MASTER
-----------------------------------------------------------
    port map( 
        OPTRX_n => OPTRX_n, -- loop
        OPTRX_p => OPTRX_p,
        OPTTX_n => OPTTX_n,
        OPTTX_p => OPTTX_p
    );
	
A1500_instance: A1500
   port map(
      PXL_D     	  => PXL_D,
      PXL_A     	  => PXL_A,
      PXL_WR    	  => PXL_WR,
      PXL_RD    	  => PXL_RD,
      PXL_CS   		  => PXL_CS,
      PXL_IRQ   	  => PXL_IRQ,
      PXL_RESET 	  => PXL_RESET,
      PXL_IO    	  => PXL_IO
   );

-- I2C_INA_block_0
I2C_INA_block_0 : I2C_INA_block
    port map( 
        -- Inputs
        SDAi   => SDAi_INA_net_0,
        CLK    => I2C_Control_0_SYSCLK,
        RESETn => I2C_Control_0_RESETn,
        SCLi   => SCLi_INA_net_0,
        -- Outputs
        I2CBSY => I2CBSY_INA_net_0,
        SCLO   => SCLo_INA_net_0,
        SDAO   => SDAo_INA_net_0 
        );
-- I2C_Master_test_inst_0
I2C_Master_test_inst_0 : I2C_Master_test
    port map( 
        -- Inputs
        CLK      => I2C_Control_0_SYSCLK,
        RESETn   => I2C_Control_0_RESETn,
        I2CRUN   => I2C_Control_0_I2CRUN,
        FoREAD   => I2C_Control_0_FoRE,
        FiWRITE  => I2C_Control_0_FiWE,
        SDAI     => AUXSDAI_0,
        SCLI     => AUXSCLI_0,
        FiDATA   => I2C_Control_0_FiDATA,
        -- Outputs
        ERROR    => ERROR_AUX_net_0,
        I2CBSY   => I2CBSY_AUX_net_0,
        FoAFULL  => I2C_GBTX_0_FoAFULL,
        FoAEMPTY => I2C_GBTX_0_FoAEMPTY,
        FoFULL   => I2C_GBTX_0_FoFULL,
        FoEMPTY  => FoEMPTY_AUX_net_0,
        FiAEMPTY => I2C_GBTX_0_FiAEMPTY,
        FiAFULL  => I2C_GBTX_0_FiAFULL,
        FiEMPTY  => FiEMPTY_AUX_net_0,
        FiFULL   => I2C_GBTX_0_FiFULL,
        SCLO     => AUXSCLO_net_0,
        SDAO     => AUXSDAO_net_0,
        I2Cflg   => open,
        I2CRXflg => I2CRXflg_net_0,
        FoDATA   => I2C_GBTX_0_FoDATA,
        FiWRCNT  => FiWRCNT_net_0,
        FiRDCNT  => FiRDCNT_net_0,
        FoWRCNT  => FoWRCNT_net_0,
        FoRDCNT  => FoRDCNT_net_0 
        );
-- I2C_Slave_test_G
I2C_Slave_test_G : I2C_Slave
    port map( 
        -- Inputs
        CLK    => I2C_Control_0_SYSCLK,
        RESETn => I2C_Control_0_RESETn,
        SDAi   => SLVSDAI_net_0,
        SCLi   => SLVSCLI_net_0,
        -- Outputs
        I2CBSY => I2CBSY_GBTX_net_0,
        SDAo   => SLVSDAO_net_0,
        SCLo   => SLVSCLO_net_0 
        );
-- I2C_ZTEST_ASCL
I2C_ZTEST_ASCL : I2C_ZTEST
    port map( 
        -- Inputs
        DZi => I2C_ZTEST_ASCL_DZx,
        DI  => AUXSCLO_net_0,
        -- Outputs
        DZx => I2C_ZTEST_ASCL_DZx,
        DO  => AUXSCLI_0 
        );
-- I2C_ZTEST_ASDA
I2C_ZTEST_ASDA : I2C_ZTEST
    port map( 
        -- Inputs
        DZi => I2C_ZTEST_ASDA_DZx,
        DI  => AUXSDAO_net_0,
        -- Outputs
        DZx => I2C_ZTEST_ASDA_DZx,
        DO  => AUXSDAI_0 
        );
-- I2C_ZTEST_GSCL
I2C_ZTEST_GSCL : I2C_ZTEST
    port map( 
        -- Inputs
        DZi => I2C_ZTEST_GSCL_DZx,
        DI  => SLVSCLO_net_0,
        -- Outputs
        DZx => I2C_ZTEST_GSCL_DZx,
        DO  => SLVSCLI_net_0 
        );
-- I2C_ZTEST_GSDA
I2C_ZTEST_GSDA : I2C_ZTEST
    port map( 
        -- Inputs
        DZi => I2C_ZTEST_GSDA_DZx,
        DI  => SLVSDAO_net_0,
        -- Outputs
        DZx => I2C_ZTEST_GSDA_DZx,
        DO  => SLVSDAI_net_0 
        );
-- I2C_ZTEST_INASCL
I2C_ZTEST_INASCL : I2C_ZTEST
    port map( 
        -- Inputs
        DZi => I2C_ZTEST_INASCL_DZx,
        DI  => SCLo_INA_net_0,
        -- Outputs
        DZx => I2C_ZTEST_INASCL_DZx,
        DO  => SCLi_INA_net_0 
        );
-- I2C_ZTEST_INASDA
I2C_ZTEST_INASDA : I2C_ZTEST
    port map( 
        -- Inputs
        DZi => I2C_ZTEST_INASDA_DZx,
        DI  => SDAo_INA_net_0,
        -- Outputs
        DZx => I2C_ZTEST_INASDA_DZx,
        DO  => SDAi_INA_net_0 
        );

-----------------------------------------------------------
cy7c1370_instance: cy7c1370
-----------------------------------------------------------
    port map (
	Dq		=> RAM_D,
	Addr	=> RAM_A,
	Mode	=> '0',
	Clk		=> RAM_CLK,
	CEN_n	=> '0',
	AdvLd_n	=> RAM_LDn,
	Bwa_n	=> '0',
	Bwb_n	=> '0',
	Bwc_n	=> '0',
	Bwd_n	=> '0',
	Rw_n	=> RAM_WEn,
	Oe_n	=> RAM_OEn,
	Ce1_n	=> RAM_CSn,
	Ce2		=> '1',
	Ce3_n	=> '0',
	Zz		=> '0'
    );

-- LTM slot 2
vx1392sim_slot2_instance: vx1392sim
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot2,
	  IACK			=> IACKL,		-- ??
      IACKIN		=> IACKINB,		-- ??
	  SYSRES		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  A  			=> A,
      D		    	=> D,
	  BNCRES		=> BUNCH_RES,
	  EVRES  		=> EVENT_RES,
	  CLK			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  LTM_BUSY		=> ltm_busy,
	  LTM_DRDY		=> drdy_1(0),    
      DTACK			=> DTACK
	);
	
-- TRM slot 3
v1390sim_slot3_instance: V1390sim
generic map
	(
		hptc_in_sim => 14
	)
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot3,
	  IACKB			=> IACKL,		-- ??
      IACKINB		=> IACKINB,		-- ??
	  SYSRESB		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  VAD			=> A,
      VDB			=> D,
	  bnc_resin		=> BUNCH_RES,
	  ev_resin		=> EVENT_RES,
	  clk			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  BUSY			=> v1390sim_slot3_busy,
	  DRDY			=> drdy_1(1),    
      DTACK			=> DTACK
	);
	
-- TRM slot 4
v1390sim_slot4_instance: V1390sim
generic map
	(
		hptc_in_sim => 15
	)
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot4,
	  IACKB			=> IACKL,		-- ??
      IACKINB		=> IACKINB,		-- ??
	  SYSRESB		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  VAD			=> A,
      VDB			=> D,
	  bnc_resin		=> BUNCH_RES,
	  ev_resin		=> EVENT_RES,
	  clk			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  BUSY			=> v1390sim_slot4_busy,
	  DRDY			=> drdy_1(2),    
      DTACK			=> DTACK
	);
	
-- TRM slot 5
v1390sim_slot5_instance: V1390sim
generic map
	(
		hptc_in_sim => 15
	)
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot5,
	  IACKB			=> IACKL,		-- ??
      IACKINB		=> IACKINB,		-- ??
	  SYSRESB		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  VAD			=> A,
      VDB			=> D,
	  bnc_resin		=> BUNCH_RES,
	  ev_resin		=> EVENT_RES,
	  clk			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  BUSY			=> v1390sim_slot5_busy,
	  DRDY			=> drdy_1(3),    
      DTACK			=> DTACK
	);
	
-- TRM slot 6
v1390sim_slot6_instance: V1390sim
generic map
	(
		hptc_in_sim => 15
	)
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot6,
	  IACKB			=> IACKL,		-- ??
      IACKINB		=> IACKINB,		-- ??
	  SYSRESB		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  VAD			=> A,
      VDB			=> D,
	  bnc_resin		=> BUNCH_RES,
	  ev_resin		=> EVENT_RES,
	  clk			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  BUSY			=> v1390sim_slot6_busy,
	  DRDY			=> drdy_1(4),    
      DTACK			=> DTACK
	);
	
-- TRM slot 7
v1390sim_slot7_instance: V1390sim
generic map
	(
		hptc_in_sim => 15
	)
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot7,
	  IACKB			=> IACKL,		-- ??
      IACKINB		=> IACKINB,		-- ??
	  SYSRESB		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  VAD			=> A,
      VDB			=> D,
	  bnc_resin		=> BUNCH_RES,
	  ev_resin		=> EVENT_RES,
	  clk			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  BUSY			=> v1390sim_slot7_busy,
	  DRDY			=> drdy_1(5),    
      DTACK			=> DTACK
	);

-- TRM slot 8
v1390sim_slot8_instance: V1390sim
generic map
	(
		hptc_in_sim => 15
	)
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot8,
	  IACKB			=> IACKL,		-- ??
      IACKINB		=> IACKINB,		-- ??
	  SYSRESB		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  VAD			=> A,
      VDB			=> D,
	  bnc_resin		=> BUNCH_RES,
	  ev_resin		=> EVENT_RES,
	  clk			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  BUSY			=> v1390sim_slot8_busy,
	  DRDY			=> drdy_1(6),    
      DTACK			=> DTACK
	);

-- TRM slot 9
v1390sim_slot9_instance: V1390sim
generic map
	(
		hptc_in_sim => 15
	)
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot9,
	  IACKB			=> IACKL,		-- ??
      IACKINB		=> IACKINB,		-- ??
	  SYSRESB		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  VAD			=> A,
      VDB			=> D,
	  bnc_resin		=> BUNCH_RES,
	  ev_resin		=> EVENT_RES,
	  clk			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  BUSY			=> v1390sim_slot9_busy,
	  DRDY			=> drdy_1(7),    
      DTACK			=> DTACK
	);

-- TRM slot 10
v1390sim_slot10_instance: V1390sim
generic map
	(
		hptc_in_sim => 15
	)
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot10,
	  IACKB			=> IACKL,		-- ??
      IACKINB		=> IACKINB,		-- ??
	  SYSRESB		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  VAD			=> A,
      VDB			=> D,
	  bnc_resin		=> BUNCH_RES,
	  ev_resin		=> EVENT_RES,
	  clk			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  BUSY			=> v1390sim_slot10_busy,
	  DRDY			=> drdy_1(8),    
      DTACK			=> DTACK
	);

-- TRM slot 11
v1390sim_slot11_instance: V1390sim
generic map
	(
		hptc_in_sim => 15
	)
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot11,
	  IACKB			=> IACKL,		-- ??
      IACKINB		=> IACKINB,		-- ??
	  SYSRESB		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  VAD			=> A,
      VDB			=> D,
	  bnc_resin		=> BUNCH_RES,
	  ev_resin		=> EVENT_RES,
	  clk			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  BUSY			=> v1390sim_slot11_busy,
	  DRDY			=> drdy_1(9),    
      DTACK			=> DTACK
	);
	
-- TRM slot 12
v1390sim_slot12_instance: V1390sim
generic map
	(
		hptc_in_sim => 15
	)
port map	
	(
	  AM			=> AM,
	  AS			=> AS,
	  BERR			=> BERR,
	  DS0			=> DS0,
      DS1			=> DS1,
	  WRITE			=> WRITE,
	  GA			=> geo_address_slot12,
	  IACKB			=> IACKL,		-- ??
      IACKINB		=> IACKINB,		-- ??
	  SYSRESB		=> not(SYSRESL),
	  LWORD			=> LWORD,
	  VAD			=> A,
      VDB			=> D,
	  bnc_resin		=> BUNCH_RES,
	  ev_resin		=> EVENT_RES,
	  clk			=> FPGACK40_P,
	  L0			=> lvL0,
      L1A			=> lvL1A,
      L1R			=> lvL1R,
      L2A			=> lvL2A,
      L2R			=> lvL2R,
	  BUSY			=> v1390sim_slot12_busy,
	  DRDY			=> drdy_1(10),    
      DTACK			=> DTACK
	);
	
-----------------------------------------------------------
-- VME transceivers
-----------------------------------------------------------

   I0: FCT16543P
      GENERIC MAP (
         SIZE => 32
      )
      PORT MAP (
         A     => D,
         B     => VDB,
         NOEAB => NOEDTR,
         NOEBA => NOEDTW,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND
      );
	  
   I1: FCT16543P
      GENERIC MAP (
         SIZE => 32
      )
      PORT MAP (
         NOEAB => NOEADR,
         NOEBA => NOEADW,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND,
         A(31 downto 1)=> A(31 downto 1),
         A(0)=> LWORD,
         B(31 downto 1)=> VAD(31 downto 1),
         B(0)=> LWORDB
      );

   I2: FCT16543P
      GENERIC MAP (
         SIZE => 6
      )
      PORT MAP (
         NOEAB => VCC,
         NOEBA => NOEMAS,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND,
         A(5 downto 0) => AM(5 downto 0),
         B(5 downto 0) => AML(5 downto 0)
      );
	
    I3: FCT16543P
      GENERIC MAP (
         SIZE => 3
      )
      PORT MAP (
         NOEAB => GND,
         NOEBA => VCC,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND,
         A(0) => IRQ1,
		 A(1) => DTACK,
		 A(2) => BERR,
         B(0) => IRQB1,
		 B(1) => DTACKB,
		 B(2) => BERRB
      );
	
	BERR <= BERRL when BERRL = '0' else 'Z';
	
    I4: FCT16543P
      GENERIC MAP (
         SIZE => 6
      )
      PORT MAP (
         NOEAB => VCC,
         NOEBA => NOEMAS,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND,
         A(0) => IACK,
		 A(1) => WRITE,
		 A(2) => AS,
		 A(3) => SYSCLK,
		 A(4) => DS0,
		 A(5) => DS1,
         B(0) => IACKL,
		 B(1) => WRITEL,
		 B(2) => ASL,
		 B(3) => SYSCLKL,
		 B(4) => DS0L,
		 B(5) => DS1L
      );
	  
   I5: FCT16543P
      GENERIC MAP (
         SIZE => 11
      )
      PORT MAP (
         A     => drdy_1,
         B     => VDB(11 DOWNTO 1),
         NOEAB => NOEDRDY,
         NOEBA => vcc,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND
      );
	  
   I6: FCT16543P
      GENERIC MAP (
         SIZE => 11
      )
      PORT MAP (
         A     => fault_1,
         B     => VDB(11 DOWNTO 1),
         NOEAB => NOEFAULT,
         NOEBA => vcc,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND
      );
	
   I7: FCT16543P
      GENERIC MAP (
         SIZE => 10
      )
      PORT MAP (
         A(0)  => SPSEI,
		 A(1)  => LTMLT,
		 A(2)  => CPDM_SCLK,
		 A(3)  => lvCPDM_FCLKL,
		 A(4)  => PULSETGLL,
		 A(5)  => SPSEOL,
		 A(6)  => SPULSEL0,
		 A(7)  => SPULSEL1,
		 A(8)  => SPULSEL2,
		 A(9)  => BUSY,
         B(0)  => SPSEIB,
         B(1)  => LTMLTB,
         B(2)  => lvCPDM_SCLKB,
         B(3)  => CPDM_FCLKL,
         B(4)  => PULSETGL,
         B(5)  => SPSEO,
         B(6)  => SPULSE0,
         B(7)  => SPULSE1,
         B(8)  => SPULSE2,
         B(9)  => BUSYB,
         NOEAB => GND,
         NOEBA => vcc,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND
      );

	  CPDM_SCLK	<= '0';
	  SPSEI		<= '0';
	  LTMLT		<= '1';
---------------------------------------------------------------------------------------	  

---------------------------------------------------------------------------------------	
process
begin
    DCLK00_N <= '0';
    wait for 12.5 ns;
    DCLK00_N <= '1';
    wait for 12.5 ns;
end process;

DCLK00_P	<= NOT(DCLK00_N);

process
begin
    FPGACK40_N <= '0';
    wait for 12.5 ns;
    FPGACK40_N <= '1';
    wait for 12.5 ns;
end process;

FPGACK40_P	<= NOT(FPGACK40_N);


FPGACK80_proc: process
    begin
		wait for 5 ns;
        loop
            FPGACK80_N <= '0', '1' after 12.5 ns;
            FPGACK80_P <= '1', '0' after 12.5 ns;
            wait for 25 ns;
        end loop;
        wait;
 end process FPGACK80_proc;
 
---------------------------------------------------------------------------------------

P_refclk_proc: process
    begin
        loop
            REFCLK0_N <= '0', '1' after 4 ns;
            REFCLK0_P <= '1', '0' after 4 ns;
            wait for 8 ns;
        end loop;
        wait;
 end process P_refclk_proc;
 
  sig_spy_gbtx_process : process is
   begin
     init_signal_spy("DRM2_top_inst0/GBTx_interface_instance/data_to_gbtx", "tb_data_to_gbtx");
	 init_signal_spy("DRM2_top_inst0/GBTx_interface_instance/valid_data_to_gbtx", "tb_valid_data_to_gbtx");
     wait;
 end process sig_spy_gbtx_process;
 
 write_output_file_process:process(DCLK00_P)
	file TV_OUT: TEXT is out "drm2_gbt_output.txt";
	variable L_OUT: LINE;
 begin
	if(falling_edge(DCLK00_P)) then

		if(tb_valid_data_to_gbtx = '1') then
			hwrite(L_OUT, tb_data_to_gbtx(63 downto 0));
			writeline(TV_OUT,L_OUT);
		end if;
	end if;
 end process write_output_file_process;
 
 sig_spy_conet_process : process is
   begin
     init_signal_spy("DRM2_top_inst0/rod_sniffer_instance/srof_rd", "tb_srof_rd");
	 init_signal_spy("DRM2_top_inst0/rod_sniffer_instance/srof_dto", "tb_srof_dto");
     wait;
 end process sig_spy_conet_process;
 
 write_output_conet_process:process(FPGACK40_P)
	file TV_OUT_CONET: TEXT is out "drm2_conet_output.txt";
	variable L_OUT_CONET: LINE;
 begin
	if(falling_edge(FPGACK40_P)) then
	
		tb_srof_rd1	<= tb_srof_rd;

		if(tb_srof_rd1 = '1') then
			hwrite(L_OUT_CONET, tb_srof_dto);
			writeline(TV_OUT_CONET,L_OUT_CONET);
		end if;
	end if;
 end process write_output_conet_process;


end RTL;
