--!------------------------------------------------------------------------
--! @author       Annalisa Mati (a.mati@caen.it), Davide Falchieri (davide.falchieri@bo.infn.it)
--! Contact       support.frontend@caen.it
--! @file         DRM2pkg.vhd
--!------------------------------------------------------------------------
--! @brief        DRM2 Package with constant and register definitions.    
--!------------------------------------------------------------------------               
--! $Id: $ 
--!------------------------------------------------------------------------
library ieee;
use ieee.Std_Logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package DRM2pkg is

  constant ALL_ZERO  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";		
  constant ALL_ONE   : std_logic_vector(31 downto 0) := "11111111111111111111111111111111";	-- right value
  --constant ALL_ONE   : std_logic_vector(31 downto 0) := x"000017FF";  					-- just for simulation

  -- number of words contained in DRM2 header and trailer (without the RDH):
  -- CDH[0]+ CDH[1] + DRM_Header (1) + DRM_Status (4) + CRC (1) + DRM_Trailer (1) = 9
  constant NW_DRM_HT: 				    integer := 9;
  constant DRMHS: 					    std_logic_vector(3 downto 0) := conv_std_logic_vector(NW_DRM_HT-4,4);
  constant DRMHV: 					    std_logic_vector(4 downto 0) := "10010"; 					-- DRM Header Version

  constant ZEROS: 					    std_logic_vector(31 downto 0) := (others => '0');
  constant FILLER: 					    std_logic_vector(31 downto 0) := X"10101010";
  
  constant RDH_SIZE:				    integer := 4;												-- RDH size (number of words) 
  
  constant SROF_ALMOST_FULL_LEVEL:	    integer := 1000;
  
  constant vi :	    integer := 1000;
  
  constant PXL_RESET_FPGA:              std_logic_vector(15 downto 0):= x"1500";
    
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- Register addresses
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  constant A_STATUS: 				std_logic_vector(15 downto 0) := X"0000";  -- R   - Status Register
  constant A_ROC_TDATA: 			std_logic_vector(15 downto 0) := X"0001";  -- R/W - ROC Test Data
  constant A_ROC_FWREV: 			std_logic_vector(15 downto 0) := X"0002";  -- R   - Firmware Revision for ROC
  constant A_CTRL_S: 				std_logic_vector(15 downto 0) := X"0003";  -- R/W - Control Register Set
  constant A_CTRL_C: 				std_logic_vector(15 downto 0) := X"0004";  -- R/W - Control Register Clear
  constant A_SHOT:   				std_logic_vector(15 downto 0) := X"0005";  -- W   - SW commands (trigger, clear, etc...)
	--constant A_not_used: 			std_logic_vector(15 downto 0) := X"0006";  -- Not Used (written by CaenVme_Init)
  constant A_DRM_ID: 				std_logic_vector(15 downto 0) := X"0007";  -- R/W - DRM ID-Number
  constant A_DEBUG: 				std_logic_vector(15 downto 0) := X"0008";  -- R/W - Debug    
  constant A_RO_ENABLE: 			std_logic_vector(15 downto 0) := X"0009";  -- R/W - TRM Readout Enable  
  constant A_TS_MASK: 				std_logic_vector(15 downto 0) := X"000A";  -- R/W - Test Signal Mask  
  constant A_ssram_ADL: 			std_logic_vector(15 downto 0) := X"000B";  -- R/W - SSRAM Address[15:0] in test mode
  constant A_ssram_DTL: 			std_logic_vector(15 downto 0) := X"000C";  -- R   - SSRAM Data[15:0] in test mode
  constant A_ssram_DTH: 			std_logic_vector(15 downto 0) := X"000D";  -- R   - SSRAM Data[31:16] in test mode 
  constant A_MAX_TRM_HIT_CNT:		std_logic_vector(15 downto 0) := X"000E";  -- RW  - max TRM hit count 
  constant A_CLOCKSEL: 				std_logic_vector(15 downto 0) := X"000F";  -- RW  - bit 0: clock_sel value
  constant A_DRDY: 					std_logic_vector(15 downto 0) := X"0010";  -- R   - DRDY on P2
  constant A_FAULT: 				std_logic_vector(15 downto 0) := X"0011";  -- R   - FAULT on P2
  constant A_TRG_BC_PIPE:           std_logic_vector(15 downto 0) := X"0012";  -- R/W - pipeline length on l1a_ttc and bunch_reset
  constant A_ORBIT_MANDRAKE:        std_logic_vector(15 downto 0) := X"0013";  -- R/W - orbit mask for readout during mandrake mode
  constant A_TRMRO_TO: 				std_logic_vector(15 downto 0) := X"0014";  -- R/W - TRM readout timeout
  constant A_FP_LEDS: 				std_logic_vector(15 downto 0) := X"0015";  -- R/W - front panel LEDs
  constant A_FP_LEMO: 				std_logic_vector(15 downto 0) := X"0016";  -- R/W - front panel LEMOs
  constant A_FP_LEMO_IN:	 		std_logic_vector(15 downto 0) := X"0017";  -- R/W - front panel LEMOs
  constant A_TRIGGER_COUNTER: 		std_logic_vector(15 downto 0) := X"0018";  -- R   - trigger_counter (counts either LTU or mandrake triggers)
  constant A_TDELAY: 				std_logic_vector(15 downto 0) := X"0019";  -- R/W - delay of the trigger after the Test Pulse
  constant A_PULSECNT: 				std_logic_vector(15 downto 0) := X"001A";  -- R   - Pulse Counter
  constant A_ROBLT32: 				std_logic_vector(15 downto 0) := X"001B";  -- R/W - Enable readout in BLT32
  constant A_RO2ESST: 				std_logic_vector(15 downto 0) := X"001C";  -- R/W - Enable readout in 2eSST
  constant A_CTRL2: 				std_logic_vector(15 downto 0) := X"001D";  -- R/W - Control Register 2
  constant A_BER_TEST: 				std_logic_vector(15 downto 0) := X"001E";  -- R/W - BER test
  constant A_BER_VALUE: 			std_logic_vector(15 downto 0) := X"001F";  -- R/W - BER value
  
  -- SC
  --constant A_SC_STATUS : integer := 16#40#;  -- R   - Status Register
  --constant A_SC_CTRL   : std_logic_vector(15 downto 0) := X"0041";  -- R/W - Control Register
  --constant A_SC_FWREV  : std_logic_vector(15 downto 0) := X"0042";  -- R   - Firmware Revision for SC
  --constant A_SC_TDATA  : std_logic_vector(15 downto 0) := X"0043";  -- R/W - SC Scretch Register (SR Data in modo test)
  --constant A_SR_ADL    : std_logic_vector(15 downto 0) := X"0044";  -- R/W - SR Address[15:0] per test mode
  --constant A_SR_DTL    : std_logic_vector(15 downto 0) := X"0045";  -- R   - SR Data[15:0] per test mode
  --constant A_SR_DTH    : std_logic_vector(15 downto 0) := X"0046";  -- R   - SR Data[31:16] per test mode
  --constant A_RR1_DTL   : std_logic_vector(15 downto 0) := X"0047";  -- R   - RR Data[15:0] per test mode (read from SC)
  --constant A_RR1_DTH   : std_logic_vector(15 downto 0) := X"0048";  -- R   - RR Data[31:16] per test mode (read from SC)
  --constant A_XPORT1    : std_logic_vector(15 downto 0) := X"0050";  -- R/W - FIFO di interscambio 1
  --constant A_XPORT1_NW : std_logic_vector(15 downto 0) := X"0051";  -- R   - Num Wodr in XPORT1
  --constant A_XPORT2    : std_logic_vector(15 downto 0) := X"0052";  -- R/W - FIFO di interscambio 2
  --constant A_XPORT2_NW : std_logic_vector(15 downto 0) := X"0053";  -- R   - Num Word in XPORT1
  
  -- I2C core registers
  ------------------------------------------------------------------------------------------------------------------------------------------
	-- I2C core generic registers
  constant A_I2CSEL: 				std_logic_vector(15 downto 0) := X"0020";  -- R/W - selecting AUX or internal bus to access GBTx I2C
  constant A_AUX_CMHZ: 				std_logic_vector(15 downto 0) := X"0021";  -- R   - clock divider value
  constant A_TESTSIGNL:				std_logic_vector(15 downto 0) := X"002C";  -- R/W - test signal selection
  constant A_DEBUGTEST:				std_logic_vector(15 downto 0) := X"002D";  -- R/W - error generation
  constant A_VERSIONP1:				std_logic_vector(15 downto 0) := X"002E";  -- R   - I2 C firmware version part 1
  constant A_VERSIONP2:				std_logic_vector(15 downto 0) := X"002F";  -- R   - I2 C firmware version part 2
	-- GBT I2C
  constant A_GI2C_DATA: 			std_logic_vector(15 downto 0) := X"0030";  -- R/W - I2C GBTX data register to access R/W the GBTx
  constant A_GI2C_ERRN: 			std_logic_vector(15 downto 0) := X"0031";  -- R/W - I2C GBTX error register
  constant A_GI2C_STAT: 			std_logic_vector(15 downto 0) := X"0032";  -- R/W - I2C GBTX control register
  constant A_GI2C_FLAG: 			std_logic_vector(15 downto 0) := X"0033";  -- R/W - I2C GBTX signal monitor register
  constant A_GI2C_RADL: 			std_logic_vector(15 downto 0) := X"0034";  -- R/W - I2C GBTX address register (LSB)
  constant A_GI2C_RADH: 			std_logic_vector(15 downto 0) := X"0035";  -- R/W - I2C GBTX address register (MSB)
  constant A_GI2C_RNML: 			std_logic_vector(15 downto 0) := X"0036";  -- R/W - I2C GBTX number of registers to be accessed (LSB)
  constant A_GI2C_RNMH: 			std_logic_vector(15 downto 0) := X"0037";  -- R/W - I2C GBTX number of registers to be accessed (MSB)
  
	-- GBT control signals
  constant A_GBTX_CTRL: 			std_logic_vector(15 downto 0) := X"0040";  -- R/W - CTRL reg GBTX control register
  constant A_GBTX_TXRX: 			std_logic_vector(15 downto 0) := X"0042";  -- R/W - TXRX reg GBTX control register
  constant A_GBTX_RSTB: 			std_logic_vector(15 downto 0) := X"0044";  -- R/W - RSTB reg GBTX control register  
	-- efuse
  constant A_EFUSECTRL: 			std_logic_vector(15 downto 0) := X"0048";  -- R/W - efuse control register
	-- ATMEGA
  constant A_ATMEGPIN: 				std_logic_vector(15 downto 0) := X"0049";  -- R/W - ATMEGA control line
  constant A_ATMEGPTR: 				std_logic_vector(15 downto 0) := X"004A";  -- R/W - ATMEGA ADC data register pointer
  constant A_ATMEGARGL: 			std_logic_vector(15 downto 0) := X"004B";  -- R/W - ATMEGA ADC data read from address ATMEGPTR (LSB)
  constant A_ATMEGARGH: 			std_logic_vector(15 downto 0) := X"004C";  -- R/W - ATMEGA ADC data read from address ATMEGPTR (MSB)
  constant A_ATMEGRAWL: 			std_logic_vector(15 downto 0) := X"004D";  -- R/W - ATMEGA word read from PSM_SO shift register LSB (debug only)
  constant A_ATMEGRAWH: 			std_logic_vector(15 downto 0) := X"004E";  -- R/W - ATMEGA word read from PSM_SO shift register MSB (debug only)
	-- SFP
  constant A_SFPDATA: 	  			std_logic_vector(15 downto 0) := X"0050";  -- R   - Data read directly from the SFP
  constant A_SFPDATAPTR: 			std_logic_vector(15 downto 0) := X"0051";  -- R/W - Pointer to the SFP register to read out (auto-incrementing)
	-- I2C temperature sensors
  constant A_TEMPGBT: 	  			std_logic_vector(15 downto 0) := X"0052";  -- temperature sensor, GBTx zone 
  constant A_TEMPLDOGBT:  			std_logic_vector(15 downto 0) := X"0053";  -- temperature sensor, GBT LDO zone 
  constant A_TEMPLDOSDES: 			std_logic_vector(15 downto 0) := X"0054";  -- temperature sensor, SERDES LDO zone 
  constant A_TEMPPXL:	 			std_logic_vector(15 downto 0) := X"0055";  -- temperature sensor, PXL zone
  constant A_TEMPLDOFPGA:			std_logic_vector(15 downto 0) := X"0056";  -- temperature sensor, IGLOO2 LDO zone
  constant A_TEMPIGLOO2:			std_logic_vector(15 downto 0) := X"0057";  -- temperature sensor, IGLOO2 zone
  constant A_TEMPVTRX:				std_logic_vector(15 downto 0) := X"0058";  -- temperature sensor, VTRX zone
	-- diagnostic data from SFP
  constant A_SFPTEMP:				std_logic_vector(15 downto 0) := X"0059";  -- SFP diagnostics, temperature (C degrees)
  constant A_SFPVOLT:				std_logic_vector(15 downto 0) := X"005A";  -- SFP diagnostics, transmitter bias current (uA)
  constant A_SFPBIAS:				std_logic_vector(15 downto 0) := X"005B";  -- SFP diagnostics, transmitter bias current (uA)
  constant A_SFPTXPOW:				std_logic_vector(15 downto 0) := X"005C";  -- SFP diagnostics, transmitter optical power (mW)
  constant A_SFPRXPOW:				std_logic_vector(15 downto 0) := X"005D";  -- SFP diagnostics, receiver optical power (mW)
  -- temperature sensors I2C status
  constant A_I2CMONITOR:			std_logic_vector(15 downto 0) := X"005E";  -- I2C SFP TEMP lines status
  constant A_SFPSTATUS:				std_logic_vector(15 downto 0) := X"005F";  -- I2C SFP TEMP lines status, error codes
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  constant A_DEBUG1:				std_logic_vector(15 downto 0) := X"0060";  -- debug1
  constant A_DEBUG2:				std_logic_vector(15 downto 0) := X"0061";  -- debug2
  constant A_P2_SIG:				std_logic_vector(15 downto 0) := X"0062";  -- P2 signals reshuffling
  constant A_TRUE_TRM_READY:		std_logic_vector(15 downto 0) := X"0063";  -- DRDY calculated by the DRM2 during a run
  
  constant A_OUTBUF: 				std_logic_vector(15 downto 0) := X"1000";  -- R   
  constant T4M: 					integer := 2;  -- Periodo=Tclk*4M  (circa 104ms a 40MHz)
  constant T16K: 					integer := 1;  -- Periodo=Tclk*16K (circa 410us a 40MHz)
  constant T64: 					integer := 0;  -- Periodo=Tclk*64  (circa 1.6us a 40MHz)

  -------------------------------------------------------------------------------------------------------------------------------------------
  -- VME ------------------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  type VMEINFO_RECORD is record  	
    cyctype     : std_logic_vector(3 downto 0);  
    dtsize      : std_logic_vector(1 downto 0);  
    am          : std_logic_vector(5 downto 0);  
    berrflag    : std_logic;  
  end record;
  
  -- address modifier
  constant A24_U_DATA: 		std_logic_vector(5 downto 0) := "111001";  -- 39
  constant A24_U_PROG: 		std_logic_vector(5 downto 0) := "111010";  -- 3A
  constant A24_S_DATA: 		std_logic_vector(5 downto 0) := "111101";  -- 3D
  constant A24_S_PROG: 		std_logic_vector(5 downto 0) := "111110";  -- 3E

  constant A32_U_DATA: 		std_logic_vector(5 downto 0) := "001001";  -- 09
  constant A32_U_PROG: 		std_logic_vector(5 downto 0) := "001010";  -- 0A
  constant A32_S_DATA: 		std_logic_vector(5 downto 0) := "001101";  -- 0D
  constant A32_S_PROG: 		std_logic_vector(5 downto 0) := "001110";  -- 0E

  constant A24_U_BLT: 		std_logic_vector(5 downto 0) := "111011";  -- 3B
  constant A24_S_BLT: 		std_logic_vector(5 downto 0) := "111111";  -- 3F
  constant A32_U_BLT: 		std_logic_vector(5 downto 0) := "001011";  -- 0B
  constant A32_S_BLT: 		std_logic_vector(5 downto 0) := "001111";  -- 0F

  constant A24_U_MBLT: 		std_logic_vector(5 downto 0) := "111000";  -- 38
  constant A24_S_MBLT: 		std_logic_vector(5 downto 0) := "111100";  -- 3C
  constant A32_U_MBLT: 		std_logic_vector(5 downto 0) := "001000";  -- 08
  constant A32_S_MBLT: 		std_logic_vector(5 downto 0) := "001100";  -- 0C

  constant CR_CSR: 			std_logic_vector(5 downto 0) := "101111";  -- 2F
  
  constant A32_U_2ESST: 	std_logic_vector(5 downto 0) := "100000";  -- 20

  -- ************************************************************************************************************************************
  -- Register definition
  -- ************************************************************************************************************************************
  subtype REGISTER_TYPE          is std_logic_vector(31 downto 0); 
  subtype REGISTER16_TYPE        is std_logic_vector(15 downto 0); 
  subtype PULSE_TYPE             is std_logic; 
  subtype tick_pulses 			 is std_logic_vector(T4M downto 0);

  type REGS_RECORD is record  	
    status: 			REGISTER_TYPE;  	-- R   - Status Register
    roc_tdata: 			REGISTER16_TYPE;  	-- R/W - ROC Test Data
    ctrl: 				REGISTER_TYPE;  	-- R/W - Control Register 
	ctrl2: 				REGISTER16_TYPE;  	-- R/W - Control2 Register 
    drm_id: 			REGISTER_TYPE;  	-- R/W - DRM ID-Number
    debug: 				REGISTER16_TYPE;  	-- R/W - Debug
	debug1: 			REGISTER16_TYPE;  	-- R   - Debug1
	debug2: 			REGISTER_TYPE;  	-- R   - Debug2
	clocksel: 			REGISTER16_TYPE;
	max_trm_hit_cnt:	REGISTER16_TYPE;	-- R/W - max TRM hit count
	trmro_to: 			REGISTER16_TYPE;
	pulsecnt: 			REGISTER16_TYPE;
	tdelay: 			REGISTER16_TYPE;
    ro_enable: 			REGISTER_TYPE;  	-- R/W - TRM Readout Enable  
    ts_mask: 			REGISTER_TYPE;  	-- R/W - Test Signal Mask  
    ssram_adl: 			REGISTER_TYPE;  	-- R/W - ssram Address[15:0] per test mode
    ssram_dtl: 			REGISTER16_TYPE;  	-- R   - ssram Data[15:0] per test mode
    ssram_dth: 			REGISTER16_TYPE;  	-- R   - ssram Data[31:16] per test mode
	pwr_ctrl: 			REGISTER16_TYPE;
	ber_test: 			REGISTER16_TYPE;
	ber_value: 			REGISTER16_TYPE;
	trigger_counter: 	REGISTER_TYPE;
	fp_leds: 			REGISTER16_TYPE;
	fp_lemo: 			REGISTER16_TYPE;
	fp_lemo_in: 		REGISTER16_TYPE;
    trg_bc_pipe:        REGISTER16_TYPE;
    orbit_mandrake:     REGISTER16_TYPE;
	P2assign:			REGISTER_TYPE;
	true_trm_ready:     REGISTER16_TYPE;	-- R
  end record;
  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- REGISTERS DEFAULT VALUES ---------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant D_ROC_TDATA: 	REGISTER16_TYPE := X"5555";  					-- R/W - ROC Test Data
  constant D_CTRL: 			REGISTER_TYPE := X"00000000";  					-- R/W - Control Register 
  constant D_CTRL2: 		std_logic_vector( 7 downto 0) := "01110000";  	-- TRMwait=7 di default
  constant D_DRM_ID: 		REGISTER_TYPE := X"00000033";  					-- R/W - DRM ID-Number
  constant D_DEBUG: 		REGISTER16_TYPE := X"AAAA";    					-- R/W - Debug
  constant D_RO_ENABLE: 	REGISTER_TYPE := X"00000000";  					-- R/W - TRM Readout Enable  
  constant D_TS_MASK: 		REGISTER_TYPE := X"00000000";  					-- R/W - Test Signal Mask  
  constant D_ssram_ADL: 	REGISTER_TYPE := X"AAAAAAAA";  					-- R/W - ssram Address[15:0] per test mode
  constant D_CLOCKSEL: 		REGISTER16_TYPE := X"0000";    					-- R/W - clock source selection
  constant D_TRMRO_TO: 		std_logic_vector( 7 downto 0) := conv_std_logic_vector(200, 8);  -- 320us
  constant D_PULSECNT: 		std_logic_vector(15 downto 0) := "0000000000000000";
  constant D_TDELAY: 		std_logic_vector(15 downto 0) := conv_std_logic_vector(200, 16); -- 5us
  constant D_PWR_CTRL: 		std_logic_vector(15 downto 0) := x"0000";
  constant D_P2_ASSIGN:		std_logic_vector(31 downto 0) := x"87654321";

  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- Register bit field ---------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- STATUS (0x00) --------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant STATUS_RO_MODE: 		integer :=  0;  -- Readout Mode (1) / Config Mode (0)
  constant STATUS_RUN: 			integer :=  1;  -- SOT received
  constant STATUS_CPDM_SCLK: 	integer :=  2;  -- CPDM Clock Status: 1=ExtClk (fibre)  0=IntClk (osc)
  constant STATUS_CLK_SRC: 		integer :=  3;  -- clock source
  constant STATUS_LTM_LTRG: 	integer :=  4;  -- LTM Local Trigger (from P2)
  constant STATUS_CLK_LHC: 		integer :=  5;  -- LHC clock (0 --> clock, 1 --> no clock)
  constant STATUS_BUSY: 		integer :=  6;  -- TRM Busy 
  constant STATUS_ERO_TO: 		integer :=  7;  -- Event Readout Timeout
  constant STATUS_CLK_ALI: 		integer :=  8;  -- aliclk status (1 --> clock, 0 --> no clock)
  constant STATUS_CLK_EXT: 		integer :=  9;  -- clock source
  constant STATUS_SC_SDN: 		integer := 10;  -- CONET shutdown
  constant STATUS_PXL_SDN: 		integer := 11;  -- A1500 shutdown
  constant STATUS_SPSEI: 		integer := 12;  -- Spare Input from P2
  constant STATUS_PULSEP: 		integer := 13;  -- Pulse from CTRL on front panel
  constant STATUS_NO_DATA: 		integer := 14;  -- active when all triggers received by DRM2 have been served
  constant STATUS_EVREADY: 		integer := 15;  -- event ready to be readout via CONET2
  -------------------------------------------------------------------------------------------------------------------------------------------

  -------------------------------------------------------------------------------------------------------------------------------------------
  -- TDATA (0x1) in IO_TEST mode ------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant TDATA_PULSE0: 		integer :=  0;
  constant TDATA_PULSE1: 		integer :=  1;
  constant TDATA_PULSE2: 		integer :=  2;
  constant TDATA_LTM_PTGL: 		integer :=  3;
  constant TDATA_SPSEO: 		integer :=  4;
  --constant TDATA_UDD0: 			integer :=  5;  -- 0 = TX; 1 = RX
  --constant TDATA_UDP0: 			integer :=  6;
  --constant TDATA_UDD1: 			integer :=  7;  -- 0 = TX; 1 = RX
  --constant TDATA_UDP1: 			integer :=  8;
  constant TDATA_BUSYP: 		integer :=  9;
  --constant TDATA_DICD: 			integer := 10;  -- 0 = TX; 1 = RX
  --constant TDATA_DIC: 			integer := 11;
  -------------------------------------------------------------------------------------------------------------------------------------------

  -------------------------------------------------------------------------------------------------------------------------------------------
  -- CTRL (0x03, 0x04) ----------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant CTRL_SYSRES: 		integer :=  0;  -- System Reset (1=attivo)
  --constant CTRL_TTCRES: 		integer :=  1;  -- TTC Reset (1=attivo)
  constant CTRL_CPDM_FCLK: 		integer :=  2;  -- CPDM Force Clock: 0=Auto  1=Forced to IntClk
  --constant CTRL_PXL_OFF: 		integer :=  4;  -- 1 => PXL OFF
  constant CTRL_TEST_EVENT: 	integer :=  5;  -- Send a test event during readout
  --constant CTRL_DISABLE_DDL: 	integer :=  6;  -- Disable input from DDL
  constant CTRL_PROG: 			integer :=  7;  -- PROG Line (Igloo2 Config)
  --constant CTRL_GHOST_DDL: 		integer :=  8;  -- Start Readout with DDL disabled
  constant CTRL_PULSE_POLARITY: integer :=  9;  -- Pulse Polarity: 0 = active low; 1 = Active high (old CPDM)
  constant CTRL_SPDO: 			integer := 11;  -- Spare Diff Out on P2
  constant CTRL_IO_TEST: 		integer := 12;  -- I/O test mode
  constant CTRL_SR_TEST:		integer := 13;	-- test SSRAM
  constant CTRL_RDH_VERSION:	integer := 15;	-- when 1 RDH v5, when 0 RDH v4
  --constant CTRL_EN_PREPULSE: 	integer := 13;  -- Enable Pre Pulse from TTC
  --constant CTRL_DISABLE_TEMP: 	integer := 14;  -- Disable Temp. Readout
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- CTRL2 (0x1D) ---------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- constant CTRL2_2ESST: 		integer :=  0;   -- Enable 2eSST
  --constant CTRL2_EMULTTC: 		integer :=  1;   -- Abilita emulazione sequenze trigger TTC 
  --constant CTRL2_ENBUSYL0: 		integer :=  2;   -- Abilita attivazione del BUSY fra L0 e L1
  --constant CTRL2_TRMBUSY: 		integer :=  3;   -- Abilita attiva`zione del BUSY verso TTC quando si attiva BUSY dalle TRM (su Backplane)
  constant CTRL2_MANDRAKE:		integer :=  2;	-- mandrake mode for trigger generation and GBT link disabling
  constant CTRL2_MANDRAKE_GO:	integer :=  3;	-- run mandrake mode (auto-trigger being generated till this bit is reset)
  constant CTRL2_TRMWAIT_4: 	integer :=  4;
  constant CTRL2_TRMWAIT_5: 	integer :=  5;
  constant CTRL2_TRMWAIT_6:	 	integer :=  6;
  constant CTRL2_SET_PREPULSE: 	integer :=  7;   -- spare (used to activate prepulse for P2 signals test)
  constant CTRL2_SETRDMODE: 	integer :=  8;	 -- spare (temporarily used to set RO_MODE for vme_int)
  constant CTRL2_DISABLE_RO: 	integer :=  9;   -- Disable TRM readout (but trigger from GBT still active)
  constant CTRL2_SR_IRQEN: 		integer := 10;   -- Enable Interrupt from SSRAM
  constant CTRL2_TRIG_IGNORE:	integer := 11;   -- ignore triggers (TOF special triggers or physics triggers)
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- SHOT (0x05) ----------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant SHOT_TEST: 			integer := 0;   -- pulse on signals enabled by TEST SIGNAL MASK
  constant SHOT_SOFT_CLEAR:		integer := 1;	-- soft clear
  --constant WP_SYSRES: 			integer := 1;   -- sysres
  constant SHOT_CLEAR: 			integer := 2;   -- clear
  constant SHOT_A1500_RESET: 	integer := 3;   -- A1500 reset (causes A1500 to reboot)
  --constant WP_SOD: 				integer := 3;   -- attiva RUN_ACQ
  --constant WP_EOD: 				integer := 4;   -- disattiva RUN_ACQ
  constant SHOT_WRR: 				integer := 5;   -- writes one test word in ssram (also writing ROC_TDATA)
  constant SHOT_LTM_PT: 			integer := 6;   -- LTM Pulse Toggle (on P2)
  --constant WP_TEMP_SENS: 		integer := 7;   -- cambia indirizzo dei sensori di temperatura
  --constant WP_TTCI2C: 			integer := 8;   -- accede al TTC via I2C
  --constant WP_RD_TRACE: 		integer := 9;   -- Read Trace
  --constant WP_TTCTRG: 			integer := 10;  -- Trigger da TTC emulato
  -------------------------------------------------------------------------------------------------------------------------------------------

  -------------------------------------------------------------------------------------------------------------------------------------------
  -- RO_ENABLE (0x09) -----------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant RO_ENABLE_1: 		integer :=  0;  -- LTM in slot 2
  constant RO_ENABLE_2: 		integer :=  1;  -- TRM in slot 3
  constant RO_ENABLE_3: 		integer :=  2;  -- TRM in slot 4
  constant RO_ENABLE_4: 		integer :=  3;  -- TRM in slot 5
  constant RO_ENABLE_5: 		integer :=  4;  -- TRM in slot 6
  constant RO_ENABLE_6: 		integer :=  5;  -- TRM in slot 7
  constant RO_ENABLE_7: 		integer :=  6;  -- TRM in slot 8
  constant RO_ENABLE_8: 		integer :=  7;  -- TRM in slot 9
  constant RO_ENABLE_9: 		integer :=  8;  -- TRM in slot 10
  constant RO_ENABLE_10: 		integer :=  9;  -- TRM in slot 11
  constant RO_ENABLE_11: 		integer := 10;  -- TRM in slot 12
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- TEST SIGNAL MASK (0x0A) ----------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant TS_MASK_CPDM_P0: 	integer :=  0;  -- CPDM Pulse 0
  constant TS_MASK_CPDM_P1: 	integer :=  1;  -- CPDM Pulse 1
  constant TS_MASK_CPDM_P2: 	integer :=  2;  -- CPDM Pulse 2
  constant TS_MASK_L0: 			integer :=  3;  -- L0
  constant TS_MASK_L1A: 		integer :=  4;  -- L1A
  constant TS_MASK_L1R: 		integer :=  5;  -- L1R
  constant TS_MASK_L2A: 		integer :=  6;  -- L2A
  constant TS_MASK_L2R: 		integer :=  7;  -- L2R
  constant TS_MASK_EVRES: 		integer :=  8;  -- Event Reset
  constant TS_MASK_BNCRES: 		integer :=  9;  -- Bunch Reset
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- Front panel leds -----------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant FP_LEDS_TEST: 		integer := 0;
  constant FP_LEDS_1: 			integer := 1;
  constant FP_LEDS_2: 			integer := 2;
  constant FP_LEDS_3: 			integer := 3;
  constant FP_LEDS_4: 			integer := 4;
  constant FP_LEDS_PROGL: 		integer := 5;
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- trigger types TT -----------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant ORBIT_TT:			integer :=  0;		-- orbit
  constant HB_TT: 				integer :=  1;		-- HB 
  constant HBr_TT: 				integer :=  2;		-- HB reject
  constant HBc_TT: 				integer :=  3;		-- health check
  constant PHYSICS_TT: 			integer :=  4;		-- physics trigger
  constant PREPULSE_TT: 		integer :=  5;		-- prepulse for calibration
  constant CALIBRATION_TT:		integer :=  6;		-- calibration trigger
  constant SOT_TT: 				integer :=  7;		-- Start of Triggered Data
  constant EOT_TT: 				integer :=  8;		-- End of Triggered Data
  constant SOC_TT: 				integer :=  9;		-- Start of Continuous Data
  constant EOC_TT: 				integer :=  10;		-- End of Continuous Data
  constant TF_TT: 				integer :=  11;		-- Time Frame delimiter
  constant FErst_TT:   			integer :=  12;		-- Front-end reset
  constant RT_TT:               integer :=  13;     -- Run type: 1 continuous, 0 triggered
  constant RS_TT:               integer :=  14;     -- Running state: 1 running, 0 not running
  constant LHCgap1_TT:          integer :=  27;     -- LHC abort gap 1
  constant LHCgap2_TT:          integer :=  28;     -- LHC abort gap 2
  constant TPCsync_TT:          integer :=  29;     -- TPC synchronization / ITSrst
  constant TPCrst_TT:           integer :=  30;     -- TPC reset on request
  constant TOF_TT:				integer :=  31;		-- TOF special trigger  
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- ber_test -------------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant BER_LOOP_EN:			integer :=  0;		-- enable GBTx loopback on Igloo2
  constant BER_RES_VALUE:		integer :=  1;		-- reset count_ber value
  constant BER_CHECK_EN: 		integer :=  2;		-- enable ber errors counting
  -------------------------------------------------------------------------------------------------------------------------------------------
 
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- CLOCK_SEL -------------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant CLOCKSEL_RESTART_CLK_CHOICE:	integer :=  0;		-- restart clock choice
  constant CLOCKSEL_PRIORITY_LHCCLK:	integer :=  1;		-- priority to LHC clock
  constant CLOCKSEL_PRIORITY_GBTCLK:	integer :=  2;		-- priority to GBT clock
  -------------------------------------------------------------------------------------------------------------------------------------------
  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- GI2C_STAT ------------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant GI2C_STAT_ERROR:         std_logic_vector(7 downto 0) := X"78";     -- R   - I2C interface error state, need to reset (x)
  constant GI2C_STAT_OK:            std_logic_vector(7 downto 0) := X"65";     -- R   - I2C interface writing done,FIFO empty, proceed (e)
  constant GI2C_STAT_WAIT:          std_logic_vector(7 downto 0) := X"62";     -- R   - I2C interface busy (b)
  constant GI2C_STAT_READ_DATA:     std_logic_vector(7 downto 0) := X"71";     -- R   - I2C interface data available on FIFO to be read (q)
  constant GI2C_STAT_GO_READ:       std_logic_vector(7 downto 0) := X"72";     -- W   - I2C interface command: start reading (r)
  constant GI2C_STAT_GO_WRITE:      std_logic_vector(7 downto 0) := X"77";     -- W   - I2C interface command: FIFO loaded, start writing (w)
  -------------------------------------------------------------------------------------------------------------------------------------------
  
      -- POWER CONTROL 
  constant PC_A1500_OFF: 			integer :=  1;  -- switched on 13 March 2018 (was 0)
  constant PC_AVAGO_OFF: 			integer :=  0;  -- switched on 13 March 2018 (was 1)
  
  subtype reg_wpulse is std_logic_vector(10 downto 0);

  -- ***************************************************************************************
  -- FILLING FUNCTION
  --    First parameter:  the bus dimension
  --    Second parameter: the low bus index
  -- ***************************************************************************************
  function fill0(n : integer) return std_logic_vector;
  function fill1(n : integer) return std_logic_vector;
  function SLOTBIT(mask : std_logic_vector(10 downto 0); slot : std_logic_vector(3 downto 0)) return std_logic;

end DRM2pkg;


package body DRM2pkg is

	function fill0(n : integer) return std_logic_vector is
    variable q : std_logic_vector(n-1 downto 0);
    begin
      q := (others => '0');
      return q;
    end fill0;

	function fill1(n : integer) return std_logic_vector is
    variable q : std_logic_vector(n-1 downto 0);
    begin
      q := (others => '1');
      return q;
    end fill1;
	
	function SLOTBIT(mask : std_logic_vector(10 downto 0); slot : std_logic_vector(3 downto 0)) return std_logic is
	  variable ret : std_logic;
	  begin
		case slot is
		  when "0010" => ret := mask(0);
		  when "0011" => ret := mask(1);
		  when "0100" => ret := mask(2);
		  when "0101" => ret := mask(3);
		  when "0110" => ret := mask(4);
		  when "0111" => ret := mask(5);
		  when "1000" => ret := mask(6);
		  when "1001" => ret := mask(7);
		  when "1010" => ret := mask(8);
		  when "1011" => ret := mask(9);
		  when "1100" => ret := mask(10);
		  when others => ret := '0';
		end case;
		return ret;
	end function;
  

end DRM2pkg;