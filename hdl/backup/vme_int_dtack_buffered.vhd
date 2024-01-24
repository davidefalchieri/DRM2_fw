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
use work.DRM2pkg.all;
USE work.caenlinkpkg.all;

entity vme_int is
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
	  BUSYB: 				in     std_logic;  -- Busy from TRM
	  SPSEOL: 				out    std_logic;  -- Spare single ended OUT
	  SPSEIB: 				in     std_logic;  -- Spare single ended IN
	  SPDO: 				out    std_logic;  -- Spare Differential OUT
	  
	  TICK: 				in     tick_pulses;
	  WPULSE: 				buffer reg_wpulse;
	  PROGL: 				out    std_logic  -- PROG (ovvero PROGL negato da un BJT) è attivo basso
   );
end vme_int;


architecture RTL of vme_int is

	signal invaddr: 				std_logic;

    attribute syn_encoding: 		string;
    
    type   TSTATROC is (
						ROC_IDLE, ROC_RREG, ROC_WREG, S1_STARTCYC, S1_ASDN, S1_WAITDTK, S1_ENDCYC, S1_BREAK, S1_WRSTAT,
						S1_2ESST_ADDACK, S1_2ESST_DATA0A, S1_2ESST_DATA0B, S1_2ESST_DATA1A, S1_2ESST_DATA1B, S1_2ESST_END,
						S1_WAITTRM, S1_RO_IDLE, S1_TEST_EVENT, S1_TEST_WAIT, S1_READOUT, S1_WR_TRAILER, S1_WR_HEADER
						); 
    attribute syn_encoding of TSTATROC: type is "onehot";
    signal fsm_roc: 				TSTATROC;
	
	signal state_gbtx_config: 		std_logic;
	signal state_gbtx_en:			std_logic_vector(1 downto 0);
	
	signal lb_endpkt_i:				std_logic;
	signal lb_rdata_i:				std_logic_vector(31 downto 0);
	
	signal TEMPDT: 					std_logic_vector(63 downto 0);  			-- registro di appoggio per i dati verso la OP
	signal NWTEMP: 					std_logic_vector(2 downto 0);   			-- numero di word o lword ancora da scrivere su OP
	-- Block Transfer counters
	signal NCYC: 					std_logic_vector(15 downto 0);  			-- counts the clock cycles during a BLT
	signal BLT_SIZE: 				std_logic_vector(15 downto 0);  			-- BLT cycles to execute
  
	-- bus VME locale
	signal INTAD: 					std_logic_vector(31 downto 0);  			-- local addresses
	signal INTDT: 					std_logic_vector(31 downto 0);  			-- local data
	signal INTAM: 					std_logic_vector(5 downto 0);   			-- local AM
	signal INTLWORD: 				std_logic;                      			-- local LWORD 

	signal DRLTC: 					std_logic; 									-- VME data synchronously latched while reading
	signal VDLTC: 					std_logic_vector(63 downto 0);  			-- VME data being readas freezed in DRLTC
	signal DTACKSN: 				std_logic; 									-- synchronous DTACK active on falling edge of CLK

	-- segnali di controllo locali da/per il VME
	signal DS: 						std_logic; 									-- FSM DS (then it becomes DS0 and/or DS1)
	signal DTACKS: 					std_logic; 									-- synchronous DTACK (2 clock cycles)
	signal DTACKS1: 				std_logic; 									-- synchronous DTACK (1 clock cycles)
	signal BERRBS: 					std_logic; 									-- synchronous BERRIN (2 clock cycles)
	signal BERRBS1: 				std_logic; 									-- synchronous BERRIN (1 clock cycles)
	signal DSINHIB: 				std_logic; 									-- DS inhibit (keeps DS=1 until DTACK is closed)
	signal DSINHIBS: 				std_logic; 									-- DS inhibit clocked for FSM

	-- Flag per segnalare l'esito del ciclo eseguito (conclusione con DTACK o BERR)
	signal BERRFLAG: 				std_logic; 									-- there was a berr during the cycle
	signal DTACKFLAG: 				std_logic; 									-- there was a dtack during the cycle

	-- segnali per gli OE dei dati/indirizzi gestiti dal master
	signal NOEDTWi: 				std_logic;
	signal NOEDTRi: 				std_logic;
	signal NOEADWi: 				std_logic;
	signal NOEADRi: 				std_logic;

	-- segnali per identificare il tipo di ciclo in corso
	signal VMECYC: 					std_logic; 									-- VME access
	signal BLTCYC: 					std_logic; 									-- Block Transfer Cycle
	signal PBLTCYC:					std_logic; 									-- Packed Block Transfer Cycle
	signal IACKCYC: 				std_logic; 									-- Interrupt Acknowledge Cycle
	signal nW_R_CYC: 				std_logic; 									-- 1 = read cycle, 0 = write cycle
	signal DSIZE: 					std_logic_vector(1 downto 0); 				-- data size: 00=D8 01=D16 10=D32 11=D64
	-- signal GETDT       : std_logic; -- ho dati da leggere dalla Input Pipe (cicli di scrittura o RMW)
	signal ADDACK: 					std_logic; 									-- addr. ack. cycle in MBLT
	signal ROMODE: 					std_logic; 									-- asserted after rodata
	
	signal CYC2ESST: 				std_logic;
	signal VTIMEOUT: 				std_logic_vector(4 downto 0); 				-- VME Timeout
	signal WAITC: 					std_logic_vector(2 downto 0); 				-- wait time among cycles
	signal FSM_TIMEOUT: 			std_logic_vector(7 downto 0); 				-- Timeout in FSM operations
	signal WDOGTO: 					std_logic; 									-- watchdog timeout
	
	signal RO_DONE: 				std_logic_vector(10 downto 0); 				-- tells which TRMs have performed the readout
	signal RO_DRDY: 				std_logic_vector(10 downto 0); 				-- DRDY from TRM
	signal RO_SLOT: 				std_logic_vector(3 downto 0);  				-- TRM slot to read
	
	signal trg_bc: 					std_logic_vector(11 downto 0);  			-- trigger BCID
	signal orbit_number:			std_logic_vector(31 downto 0);				-- orbit number
	signal CRC: 					std_logic_vector(15 downto 0);  			-- event CRC
	signal EV_WCNT: 				std_logic_vector(17 downto 0);  			-- Event Word Counter
	signal INC_EVWCNTH: 			std_logic;                      			-- to break EV_WCNT in two
	signal RES_EV_WCNT: 			std_logic;                      			-- EV_WCNT reset
	signal DRM_WCNT: 				std_logic_vector(15 downto 0);  			-- Event Word Counter (without RDH)
	signal MSG_WCNT: 				std_logic_vector(4 downto 0);   			-- Word Counter	
	
	signal ECLKLOSS: 				std_logic_vector(1 downto 0); 				-- clock state (01: local clock, 00: GBT clock, 10: LHC clock)
	signal EV_BUILDING: 			std_logic;
	signal SSTLAST: 				std_logic;
	signal test_word: 				std_logic_vector(7 downto 0);   			-- Test Word for test event
	signal test_wait: 				std_logic_vector(3 downto 0);   			-- wait time among the test words
  
	signal DRM_BUNCHID: 			std_logic_vector(11 downto 0);  			-- Local Bunch ID
	signal DRM_BCNT: 				std_logic_vector(11 downto 0);  			-- DRM bunch counter
	signal vme_to_gbt_WR:			std_logic;
	
	signal ROBLT32: 				std_logic_vector(10 downto 0); 				-- register to perform accesses in BLT32 to TRMs and LTM 
	signal RO2ESST: 				std_logic_vector(10 downto 0); 				-- register to perform accesses in 2eSST to TRMs and LTM 
	
	signal C_TYPE: 					std_logic; 									-- data destination in output: ACQ_CYCLE = 1 and SLOW_CTRL_CYCLE = 0
	
	  -- C_TYPE values
	constant ACQ_CYCLE: 			std_logic := '1';
	constant SLOW_CTRL_CYCLE: 		std_logic := '0';
	
	type   TSTATE2 is (S2_INIT, S2_IDLE, S2_TP, S2_TR, S2_TR1);
	signal STATE2: 					TSTATE2;
	
	signal WDOGRES: 				std_logic; 									-- reset watchdog
	signal RO_TOUT: 				std_logic; 									-- timeout during readout
	signal RTO_FLAG: 				std_logic; 									-- readout timeout flag (goes in the data header)
	signal fifo_clear:				std_logic;
	
	signal L1MSG_RDY: 				std_logic;

	signal TEST_PULSE: 				std_logic; 									-- internally generated PULSEP (provides pulses to CPDM)
	signal SPULSEL0i: 				std_logic; 									-- internal PULSEL0 
	signal SPULSEL1i: 				std_logic; 									-- internal PULSEL1
	signal SPULSEL2i: 				std_logic; 									-- internal PULSEL2
	signal PULSEPS1: 				std_logic; 									-- resynch PULSEP 
	signal PULSE2: 					std_logic; 									-- 2-cycles long PULSE
	signal PULSE2A: 				std_logic; 									-- PULSE2 clocked with ALICLK
	signal PULSEOFF: 				std_logic; 									-- inhibits PULSEP after 1 clock cycle
	signal PREPULSES: 				std_logic; 									-- resynch PREPULSE 
	signal PULSECNT_RES: 			std_logic;		 							-- pulse counter reset
	signal TEST_TRIGGER: 			std_logic; 									-- 2-cycles long test trigger
	signal TEST_TRIGGER1: 			std_logic; 									-- 2-cycles long L2 test trigger
	signal TESTP_CNT: 				std_logic_vector(15 downto 0);  			-- test_trg sequences counter 
	
	-- temporary
	
	signal L1R_TTC: 				std_logic;
	signal L2A_TTC: 				std_logic;
	signal L2R_TTC: 				std_logic;
	signal EVENT_RES_TTC: 			std_logic;
	signal PREPULSE: 				std_logic;	
	
	signal busyp: 					std_logic;
	signal pulsep: 					std_logic := '0';
		
	signal cycle_type: 				std_logic_vector(3 downto 0);
	
	signal lb_rdy_i: 				std_logic;
	
	signal loc_evcnt:				std_logic_vector(11 downto 0);
	
	signal temper_address:			std_logic_vector(7 downto 0);
	signal temper_en:				std_logic;
	signal local_bcid_rd:			std_logic;
	
	signal vme_to_gbt_dti:			std_logic_vector(32 downto 0);
	signal vme_to_gbt_valid:		std_logic;
	
		-- int_sram signals ---------------------------------------------------------------------------------------------------------------------
	constant isram_SIZE: 						integer := 15;  							-- int_sram size = 2^isram_SIZE
	constant isram_AFLEV: 						integer := 2**(isram_SIZE-1)-1024;  		-- 15.36KB 
	constant isram_nev_aflev: 					integer := 100;  							-- Almost Full level (max num di eventi)

	signal w_pnt: 								std_logic_vector(isram_SIZE-1 downto 0);  	-- Write Pointer
	signal r_pnt: 								std_logic_vector(isram_SIZE-1 downto 0);  	-- Read Pointer
	signal w_jump: 								std_logic_vector(isram_SIZE-1 downto 0);  	-- Write Pointer to jump to for the new event
	signal isram_NW: 							std_logic_vector(isram_SIZE-1 downto 0);  	-- isram Number of Words

	signal isram_waddr: 						std_logic_vector(isram_SIZE-1 downto 0);  	-- write address
	signal isram_raddr: 						std_logic_vector(isram_SIZE-1 downto 0);  	-- read address
	signal isram_Di: 							std_logic_vector(35 downto 0);         		-- internal data
	signal isram_WEi: 							std_logic;                             		-- internal Write Enable 
	signal isram_REi: 							std_logic;                             		-- internal Write Enable
	signal isram_read: 							std_logic;                             		-- valid read cycle from isram
	signal isram_out_valid: 					std_logic;                             		-- valid read data from isram (1 clk after isram_read)
	signal isram_read_first: 					std_logic;                             		-- first word of an event read from isram
	signal isram_out_valid_first: 				std_logic;                             		-- first valid data (clocked isram_read_first)

	signal isram_dout: 							std_logic_vector(35 downto 0);         		-- sync isram_D  
	signal isram_read1: 						std_logic;                             		-- isram_read delayed by 1 clk
	signal isram_read_first1: 					std_logic;                             		-- isram_read_first delayed by 1 clk

	signal isram_nev: 							std_logic_vector(7 downto 0);        		-- number of events in isram ready to be sent to GBTx
	signal rwcnt: 								std_logic_vector(17 downto 0);       		-- counts the words of an event while reading isram
	signal evhead_cnt: 							std_logic_vector(3 downto 0);        		-- counts the words of the header while being written
	signal wr_evhead: 							std_logic;                           		-- asserted when the header is being written
	signal ne_af:	 							std_logic;                           		-- Almost Full due to too many events in isram
	signal nw_af: 								std_logic;                           		-- Almost Full due to too many words in isram
	signal isram_full: 							std_logic;
	signal drm_data:							std_logic_vector(32 downto 0);
	signal drm_valid:							std_logic;
	signal slow_ctrl_data:						std_logic;
	
	signal sniff_data_temp:						std_logic_vector(32 downto 0);
	signal sniff_valid_temp:					std_logic;
	signal sniff_ctrl_temp:						std_logic;
	
	-- DAV 21/09/2020
	signal VAD_d1:								std_logic_vector(31 downto 1);						
	signal VDB_d1:								std_logic_vector(31 downto 0);
	signal LWORDB_d1:							std_logic;
    
	
	component local_bcid
    port(
        -- Inputs
        CLK   : in  std_logic;
        DATA  : in  std_logic_vector(11 downto 0);
        RE    : in  std_logic;
        RESET : in  std_logic;
        WE    : in  std_logic;
        -- Outputs
        EMPTY : out std_logic;
        FULL  : out std_logic;
        Q     : out std_logic_vector(11 downto 0)
        );
	end component local_bcid;
	
	component int_sram
    port(
        -- Inputs
        ARST   : in  std_logic;
        CLK    : in  std_logic;
        RADDR  : in  std_logic_vector(14 downto 0);
        REN    : in  std_logic;
        WADDR  : in  std_logic_vector(14 downto 0);
        WD     : in  std_logic_vector(35 downto 0);
        WEN    : in  std_logic;
        -- Outputs
        RD     : out std_logic_vector(35 downto 0)
        );
	end component int_sram;
	
	component bus_extender
	port 
	(
		FPGACK_40MHz:			in		std_logic;
		clear:					in		std_logic;
		drm_data:				in		std_logic_vector(32 downto 0);
		drm_valid:				in		std_logic;
		GBTx_data_fifo_dti:		out		std_logic_vector(64 downto 0);
		GBTx_fifo_wr:			out		std_logic
	);
	end component bus_extender;

begin

	-----------------------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	L1R_TTC						<= '0';
	L2A_TTC						<= '0';
	L2R_TTC						<= '0';
	EVENT_RES_TTC				<= '0';
	PREPULSE					<= regs.ctrl2(CTRL2_SET_PREPULSE);			                        -- to activate P2 test signals (to deactivate, switch to 0)
	rodata						<= regs.ctrl2(CTRL2_SETRDMODE);
	ECLKLOSS        			<= regs.status(STATUS_CLK_EXT) & regs.status(STATUS_CLK_SRC);		-- 01: local clock, 00: GBT clock, 10: LHC clock
	regs.status(STATUS_BUSY)	<= irqb1;		-- new busy (irqb1)
	regs.status(STATUS_OLDBUSY)	<= busyb;		-- old busy (busyb)
	regs.status(STATUS_RO_MODE)	<= rodata;
	fifo_clear					<= clear or soft_clear;
	busy_from_trm				<= irqb1;
	
	acq_on						<= rodata;
		
	lb_rdata					<= lb_endpkt_i & lb_rdata_i;
	lb_rdy						<= lb_rdy_i; 						
		
	cycle_type					<= vme_info.cyctype;

	trg_bc         				<= l1msg_dto(43 downto 32);
	orbit_number				<= l1msg_dto(79 downto 48);
	
	vme_to_gbt_valid			<= vme_to_gbt_WR and c_type;
		
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- watchdog -----------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	WDOGTO 						<= '0';  -- not used	
	
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- OE of local buses on the board (as inputs to 543 driving the VME bus) ----------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	NOEMAS 						<= active_high_reset;
	NOEDTW 						<= NOEDTWi;
	NOEADW 						<= NOEADWi;
	NOEDTR 						<= NOEDTRi;
	NOEADR 						<= NOEADRi;
	VDB    						<= INTDT              when NOEDTWi = '0' else (others => 'Z');
	VAD    						<= INTAD(31 downto 1) when NOEADWi = '0' else (others => 'Z');
	AML    						<= INTAM              when NOEADWi = '0' else (others => 'Z');
	LWORDB 						<= INTLWORD           when NOEADWi = '0' else 'Z';
	
	clear 						<= active_high_reset or WPULSE(SHOT_CLEAR);
	soft_clear					<= active_high_reset or WPULSE(SHOT_SOFT_CLEAR);
    a1500_reset                 <= active_high_reset or WPULSE(SHOT_A1500_RESET);

	
	process(FPGACK_40MHz, active_high_reset)		-- DAV 21/09/2020   
    begin
        if(active_high_reset = '1') then
			VAD_d1		<= (others => '0');
			VDB_d1		<= (others => '0');
			LWORDB_d1	<= '1';
		elsif(rising_edge(FPGACK_40MHz)) then 
			VAD_d1		<= VAD;
			VDB_d1		<= VDB;
			LWORDB_d1	<= LWORDB;
		end if;
	end process;
		
	-----------------------------------------------------------------------------------------------------------------------------------------
    -- local bus FSM ------------------------------------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------------------
    process(FPGACK_40MHz, active_high_reset)
        
    begin
        if(active_high_reset = '1') then
			
            invaddr      		<= '0';
                       
            -- local bus
            lb_rdy_i         	<= '0';
            lb_endpkt_i    		<= '0';
            lb_rdata_i       	<= FILLER;
                        
            -- registers
            regs.roc_tdata 		<= D_ROC_TDATA;      		-- R/W - ROC Test Data
            regs.ctrl      		<= D_CTRL;           		-- R/W - Control Register Clear
			regs.ctrl2	   		<= x"00" & D_CTRL2;			-- R/W - Control2
            regs.drm_id    		<= D_DRM_ID;         		-- R/W - DRM ID-Number            
            regs.debug     		<= D_DEBUG;          		-- R/W - Debug
			regs.clocksel  		<= D_CLOCKSEL;      		-- R/W - Clock sel
			regs.trmro_to  		<= x"00" & D_TRMRO_TO;
            regs.trg_bc_pipe    <= (others => '0');
            regs.orbit_mandrake <= (others => '0');
			--regs.pulsecnt		<= D_PULSECNT;
			regs.tdelay			<= D_TDELAY;
            regs.ro_enable 		<= D_RO_ENABLE;      		-- R/W - TRM Readout Enable  
            regs.ts_mask   		<= D_TS_MASK  ;      		-- R/W - Test Signal Mask  
            regs.ssram_adl    	<= D_ssram_ADL   ;      	-- R/W - ssram Address[15:0] per test mode
			regs.pwr_ctrl		<= D_PWR_CTRL;
			regs.ber_test(2 downto 0)		<= "000";		-- R/W - BER test register
			regs.fp_leds		<= (others => '0');
			regs.fp_lemo		<= (others => '0');
			regs.status(STATUS_ERO_TO) 	<= '0';
			
			--regs.ssram_dtl			<= (others => '0');
			--regs.ssram_dth			<= (others => '0');
			ROBLT32             <= (others => '0');
			RO2ESST				<= (others => '0');
			
			CYC2ESST  			<= '0';
			nW_R_CYC  			<= '0';
			NOEDTWi     		<= '1';
			NOEDTRi     		<= '1';
			NOEADWi     		<= '1';
			NOEADRi				<= '1';
			NOEDRDY				<= '1';
			NOEFAULT			<= '1';
			ASL					<= '1';
			DS					<= '1';
			INTAD     			<= (others => '0');	
			TEMPDT    			<= (others => '0');
			NWTEMP    			<= (others => '0');
			DSIZE     			<= (others => '0');
			NCYC      			<= (others => '0');
			BLT_SIZE  			<= x"0400";			-- temporarily this is a fixed value
			ADDACK   			<= '0';
			VMECYC    			<= '0';
			BLTCYC    			<= '0';
			PBLTCYC   			<= '0';
			IACKCYC   			<= '0';
			ROMODE    			<= '0';
			INTLWORD			<= '0';
			BERRFLAG  			<= '0';
			WAITC               <= (others => '0');
			
			WPULSE              <= (others => '0');
			l1msg_rd			<= '0';
			L1MSG_RDY			<= '0';
			EV_BUILDING			<= '0';
			vme_to_gbt_DTI		<= (others => '0');
			vme_to_gbt_wr		<= '0';
			C_TYPE				<= SLOW_CTRL_CYCLE;
			temper_address		<= x"58";
			temper_en			<= '0';
			local_bcid_rd		<= '0';
			PULSECNT_RES        <= '1';
			WRITEL				<= '1';
			IACKL    			<= '1';
			INTDT				<= (others => '0');
			INTAM				<= (others => '0');
			DTACKFLAG 			<= '0';	
			FSM_TIMEOUT 		<= (others => '1');
			RO_DONE				<= (others => '0');
			RO_DRDY				<= (others => '0');
			RO_SLOT				<= (others => '0');
			RES_EV_WCNT 		<= '1';
			MSG_WCNT			<= (others => '0');
			SSTLAST				<= '0';
			test_word 			<= (others => '0');
			test_wait 			<= "0000";
			WDOGRES				<= '1';
			RO_TOUT				<= '0';
			RTO_FLAG			<= '0';
			slow_ctrl_data		<= '0';
			
            -- fsm state
            fsm_roc        <= ROC_IDLE;
            
        elsif(rising_edge(FPGACK_40MHz)) then   

            -- pulses
			vme_info.berrflag	<= BERRFLAG;
			
			-- increasing the timeout counter after 1.6us (if TRMRO_TO = 0, the timeout is disabled)
		    if(conv_integer(regs.trmro_to(7 downto 0))) = 0 then
				FSM_TIMEOUT <= (others => '1');
			elsif(TICK(T64) = '1') then
				FSM_TIMEOUT <= FSM_TIMEOUT + 1;
			end if;
                          
            case fsm_roc is
    
                -----------------------------        
                when ROC_IDLE =>
                
                    lb_rdy_i      			<= '0';
                    lb_endpkt_i   			<= '0';
                    invaddr     			<= '0';
					lb_rdata_i 				<= (others => '0');
					WPULSE              	<= (others => '0');
					
					NOEDTWi     			<= '1';
					NOEDTRi     			<= '1';
					NOEADWi     			<= '1';
					NOEADRi					<= '1';
					ASL						<= '1';
					DS						<= '1';
					BERRFLAG				<= '0';
					VMECYC    				<= '0';
					BLTCYC    				<= '0';
					PBLTCYC   				<= '0';
					NCYC      				<= (others => '0');
					vme_to_gbt_wr			<= '0';
					ADDACK   				<= '0';		-- DAV 17/08/2017
					temper_address			<= x"58";
					temper_en				<= '0';
					local_bcid_rd			<= '0';
					PULSECNT_RES            <= '0';
					slow_ctrl_data			<= '0';

                    if(lb_rd = '1' OR lb_wr = '1') then  -- request access on LB
						if(lb_address(31 downto 28) = "0001") then		-- access to a DRM2 internal register (= slot 1)
							-- reading
							if lb_rd = '1' then 
								if(lb_address(15 downto 0) = A_DRDY) then
									NOEDRDY		<= '0';
								elsif(lb_address(15 downto 0) = A_FAULT) then
									NOEFAULT	<= '0';
								end if;
								-- Accesso a un registro della scheda
								fsm_roc 	<= ROC_RREG;
							-- writing
							elsif lb_wr = '1' then  -- in scrittura solo accessi a registri della scheda
								fsm_roc <= ROC_WREG;
							end if;
							VMECYC 		<= '0';
						else											-- access to TRMs via VME
							if lb_rd = '1' then
								nW_R_CYC	<= '1';
							elsif lb_wr = '1' then
								nW_R_CYC	<= '0';
							end if;
							VMECYC 		<= '1';
							IACKCYC  	<= '0';
							if(vme_info.cyctype = BLT or vme_info.cyctype = BLT_FIFO) then
								BLTCYC   	<= '1';
								if(vme_info.dtsize = D64) then
									INTAM <= A32_U_MBLT;
									ADDACK <= '1';  -- address ack da eseguire
								else	
									INTAM <= A32_U_BLT;
								end if;
							elsif(vme_info.cyctype = PBLT or vme_info.cyctype = PBLT_FIFO) then
								PBLTCYC  	<= '1';
								BLTCYC  	<= '1';
								if(vme_info.dtsize = D64) then
									INTAM 	<= A32_U_MBLT;
									ADDACK	<= '1';  -- address ack da eseguire
								else
									INTAM	<= A32_U_BLT;
								end if;
							else
								BLTCYC   	<= '0';
								INTAM     <= A32_U_DATA;	-- ciclo singolo
							end if;
							INTAD		<= lb_address;
							DSIZE		<= vme_info.dtsize;
							NCYC     	<= "0000000000000001";   -- numero di cicli DS eseguiti
							INTDT		<= lb_wdata(31 downto 0);
							--INTAM		<= vme_info.am;
							C_TYPE		<= SLOW_CTRL_CYCLE;
							fsm_roc 	<= S1_STARTCYC;
						end if;
					elsif(rodata = '1') then
						ROMODE 		<= '1';
						C_TYPE		<= ACQ_CYCLE;
						fsm_roc 	<= S1_RO_IDLE;
					elsif(rodata = '0') then			
						ROMODE 		<= '0';
						fsm_roc 	<= ROC_IDLE;
                    end if;

                -----------------------------        
                when ROC_RREG  =>

						lb_rdy_i    <= '1';
						lb_endpkt_i <= '1';
						
						case lb_address(15 downto 0) is         
							-- ROC
							when A_STATUS           => lb_rdata_i 				<= regs.status;       				-- R   - Status Register
							when A_ROC_TDATA        => lb_rdata_i(15 downto 0) 	<= regs.roc_tdata;    				-- R/W - ROC Test Data
							when A_ROC_FWREV        => lb_rdata_i 				<= fw_date;     					-- R   - Firmware Revision for DRM2
							when A_CTRL_S           => lb_rdata_i 				<= regs.ctrl;         				-- R/W - Control Register Set
							when A_CTRL_C           => lb_rdata_i 				<= regs.ctrl;         				-- R/W - Control Register Clear
							when A_CTRL2			=> lb_rdata_i 				<= x"0000" & regs.ctrl2;
							when A_DRM_ID           => lb_rdata_i 				<= regs.drm_id;       				-- R/W - DRM ID-Number                    
							when A_DEBUG            => lb_rdata_i 				<= x"0000" & regs.debug;        	-- R/W - Debug
							when A_CLOCKSEL			=> lb_rdata_i 				<= x"0000" & regs.clocksel; 		-- R/W - bit 0 clock_sel
							when A_TRMRO_TO			=> lb_rdata_i 				<= x"0000" & regs.trmro_to;
                            when A_TRG_BC_PIPE  	=> lb_rdata_i 				<= x"0000" & regs.trg_bc_pipe;
                            when A_ORBIT_MANDRAKE   => lb_rdata_i               <= x"0000" & regs.orbit_mandrake;
							when A_ROBLT32    		=> lb_rdata_i(10 downto 0) 	<= ROBLT32;
							when A_RO2ESST			=> lb_rdata_i(10 downto 0)	<= RO2ESST;

							--when A_PULSECNT			=> lb_rdata_i <= x"0000" & regs.pulsecnt;
							when A_TDELAY			=> lb_rdata_i 				<= x"0000" & regs.tdelay;
							when A_RO_ENABLE        => lb_rdata_i 				<= regs.ro_enable;    				-- R/W - TRM Readout Enable  
							when A_TS_MASK          => lb_rdata_i 				<= regs.ts_mask;      				-- R/W - Test Signal Mask  
							when A_ssram_ADL        => lb_rdata_i 				<= regs.ssram_adl;       			-- R/W - ssram Address[15:0] per test mode
							when A_ssram_DTL        => lb_rdata_i(15 downto 0) 	<= regs.ssram_dtl;       			-- R   - ssram Data[15:0] per test mode
							when A_ssram_DTH        => lb_rdata_i(15 downto 0) 	<= regs.ssram_dth;       			-- R   - ssram Data[31:16] per test mode
							when A_BER_TEST			=> lb_rdata_i(15 downto 0)	<= regs.ber_test;					-- R/W - BER test register
							when A_BER_VALUE		=> lb_rdata_i(15 downto 0)	<= regs.ber_value;					-- R/W - BER test value (number of errors)
							when A_TRIGGER_COUNTER	=> lb_rdata_i				<= regs.trigger_counter;			-- R   - Number of received triggers 
							when A_FP_LEDS			=> lb_rdata_i(15 downto 0)	<= regs.fp_leds;
							when A_FP_LEMO			=> lb_rdata_i(15 downto 0)	<= regs.fp_lemo;
							when A_FP_LEMO_IN		=> lb_rdata_i(15 downto 0)	<= regs.fp_lemo_in;
							when A_DRDY       		=> lb_rdata_i(15 downto 0)  <= "00000" & VDB(11 downto 1); NOEDRDY		<= '1';
							when A_FAULT      		=> lb_rdata_i(15 downto 0)  <= "00000" & VDB(11 downto 1); NOEFAULT		<= '1';
														
							-- I2C_CORE block registers
							when A_I2CSEL			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_AUX_CMHZ			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_TESTSIGNL		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_DEBUGTEST		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_VERSIONP1		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_VERSIONP2		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							
							when A_GI2C_DATA		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_GI2C_ERRN		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_GI2C_STAT		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_GI2C_FLAG		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_GI2C_RADL		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_GI2C_RADH		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_GI2C_RNML		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_GI2C_RNMH		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;							
							
							when A_GBTX_CTRL		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_GBTX_TXRX		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_GBTX_RSTB		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if; 
							
							when A_EFUSECTRL		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if; 
							when A_ATMEGPIN			=> if(GEN = '1') then 
															lb_rdata_i 		<= X"000000" & GDI; 
															regs.pwr_ctrl 	<= X"00" & GDI;
													   end if; 
													    
							when A_ATMEGPTR			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if; 
							when A_ATMEGARGL		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if; 
							when A_ATMEGARGH		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if; 
							when A_ATMEGRAWL		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if; 
							when A_ATMEGRAWH		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if; 
							
							when A_SFPDATA			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_SFPDATAPTR		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;

							when A_TEMPGBT			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;				   
							when A_TEMPLDOGBT		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_TEMPLDOSDES		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_TEMPPXL			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_TEMPLDOFPGA		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_TEMPIGLOO2		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_TEMPVTRX			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							
							when A_SFPTEMP			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_SFPVOLT			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_SFPBIAS			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_SFPTXPOW			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_SFPRXPOW			=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_I2CMONITOR		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							when A_SFPSTATUS		=> if(GEN = '1') then lb_rdata_i <= X"000000" & GDI; end if;
							
							when others             => lb_rdata_i <= FILLER;
													   invaddr 	  <= '1';
						end case;
						
						if lb_rd = '0' then  -- evolvo alla chiusura del ciclo
							lb_rdy_i      	<= '0';
							lb_endpkt_i   	<= '0';
							fsm_roc     	<= ROC_IDLE;
						end if;
                    
                -----------------------------        
                when ROC_WREG  =>
                    lb_rdy_i     <= '1';
                    
						case lb_address(15 downto 0) is    
							when A_STATUS			=> regs.status(STATUS_ERO_TO) 	<= '0';
							when A_ROC_TDATA        => regs.roc_tdata       <= lb_wdata(15 downto 0);  					-- R/W - ROC Test Data
													   WPULSE(SHOT_WRR)     <= '1';
							when A_CTRL_S           => regs.ctrl            <= regs.ctrl OR lb_wdata(31 downto 0);      	-- R/W - Control Register Set
							when A_CTRL_C           => regs.ctrl            <= regs.ctrl AND not lb_wdata(31 downto 0); 	-- R/W - Control Register Clear                                           
							when A_CTRL2			=> regs.ctrl2	        <= lb_wdata(15 downto 0);
							when A_SHOT             => wpulse		        <= lb_wdata(10 downto 0);  					-- W   - SW commands (trigger, clear, etc...)
							when A_DRM_ID           => regs.drm_id          <= lb_wdata(31 downto 0);  					-- R/W - DRM ID-Number                    
							when A_DEBUG            => regs.debug           <= lb_wdata(15 downto 0);  					-- R/W - Debug
							when A_CLOCKSEL			=> regs.clocksel        <= lb_wdata(15 downto 0);					-- R/W - bit 0 clock_sel
							when A_RO_ENABLE        => regs.ro_enable       <= lb_wdata(31 downto 0);  					-- R/W - TRM Readout Enable  
							when A_TRMRO_TO			=> regs.trmro_to        <= lb_wdata(15 downto 0);
                            when A_TRG_BC_PIPE		=> regs.trg_bc_pipe     <= lb_wdata(15 downto 0);
                            when A_ORBIT_MANDRAKE   => regs.orbit_mandrake  <= lb_wdata(15 downto 0);
							when A_PULSECNT			=> PULSECNT_RES         <= '1';
							when A_TDELAY			=> regs.tdelay	        <= lb_wdata(15 downto 0);
							when A_TS_MASK          => regs.ts_mask         <= lb_wdata(31 downto 0);  					-- R/W - Test Signal Mask  
							when A_ssram_ADL        => regs.ssram_adl       <= lb_wdata(31 downto 0);  					-- R/W - ssram Address[15:0] per test mode		
							when A_ROBLT32    		=> ROBLT32              <= lb_wdata(10 downto 0);
							when A_RO2ESST			=> RO2ESST		        <= lb_wdata(10 downto 0);
							when A_BER_TEST			=> regs.ber_test(2 downto 0) <= lb_wdata(2 downto 0);			-- R/W - BER test register
							when A_FP_LEDS			=> regs.fp_leds	        <= lb_wdata(15 downto 0);
							when A_FP_LEMO			=> regs.fp_lemo	        <= lb_wdata(15 downto 0);
							
							-- GBTx config-power registers
							when A_ATMEGPIN			=> regs.pwr_ctrl	    <= lb_wdata(15 downto 0);
							              
							when others             => invaddr              <= '1';
						end case;
                                        
                    if lb_wr = '0' then  -- evolvo alla chiusura del ciclo
                        lb_rdy_i      			<= '0';
                        lb_endpkt_i   			<= '0';
                        fsm_roc     			<= ROC_IDLE;
                    end if;
					
				--*************************************************************************************
				-- VME access: begin 							
				--*************************************************************************************
				when S1_STARTCYC =>
					if(PBLTCYC = '1' and BERRFLAG = '1') then -- c'e' stato un BERR durante un BLT
						fsm_roc  	<= ROC_IDLE;
					else
						WRITEL   	<= nW_R_CYC;
						--INTLWORD 	<= not(vme_info.dtsize(1));
						INTLWORD 	<= not(dsize(1));	-- DAV 05/07/2018
						IACKL    	<= not IACKCYC;
						NOEADRi  	<= '1';
						NOEADWi  	<= '0';
						NOEDTRi  	<= not nW_R_CYC;
						NOEDTWi  	<= nW_R_CYC;
						fsm_roc  	<= S1_ASDN;
					end if;
				--------------------------------------------------------------------------------------
				when S1_ASDN =>
					ASL     	<= '0';  				-- mette giu' AS e inizio il ciclo VME
					WAITC   	<= "000";
					if(BLTCYC = '1' and INTAM = A32_U_2ESST and ROMODE = '1') then
						DS 			<= '0';
						CYC2ESST 	<= '1';
						fsm_roc		<= S1_2ESST_ADDACK;
					else  
						fsm_roc		<= S1_WAITDTK;
					end if;
				--------------------------------------------------------------------------------------
				when S1_WAITDTK =>
					DS 			<= '0';
					
					-- Se ci sono ancora dati da scrivere su OP, li scrivo e ignoro il DTACK
					if NWTEMP /= "000" then
						lb_rdata_i			<= TEMPDT(31 downto 0);
						--lb_rdy_i      		<= '1' and not(C_TYPE);
						vme_to_gbt_WR  		<= '1';
						vme_to_gbt_DTI 		<= '0' & TEMPDT(31 downto 0);
						slow_ctrl_data		<= '1' and not(C_TYPE) and bltcyc;
						TEMPDT(31 downto 0) <= TEMPDT(63 downto 32);
						NWTEMP 				<= NWTEMP - 1;
					else
						vme_to_gbt_WR 		<= '0';
						-- aspetto che i dati dal VME siano pronti (DRLTC='0') e che il ciclo precedente
						-- sia terminato (DSINHIBS='0')
						if DRLTC = '0' and DSINHIBS = '0' then
							if nW_R_CYC = '1' and ADDACK /= '1' then
								lb_rdata_i			<= VDLTC(31 downto 0);
								--lb_rdy_i      		<= '1' and not(C_TYPE);
								lb_endpkt_i   		<= '0';
								vme_to_gbt_DTI 		<= '0' & VDLTC(31 downto 0);
								vme_to_gbt_WR  		<= '1';
								slow_ctrl_data		<= '1' and not(C_TYPE) and bltcyc;
								TEMPDT(31 downto 0) <= VDLTC(63 downto 32);
								if DSIZE = D64 then
									NWTEMP <= "001";  -- ancora 1 LWORD da scrivere su vme_to_gbt_fifo
								else
									NWTEMP <= "000";  -- scrittura su vme_to_gbt_fifo terminata
								end if;
							end if;
							WDOGRES   			<= '1';  -- resetto lo watchdog
							DTACKFLAG 			<= '1';
							DS        			<= '1';  	-- DS su
							fsm_roc 			<= S1_ENDCYC;    
						-- ricevuto BERR -> interrompo il ciclo
						elsif BERRBS = '0' and DSINHIBS = '0' then		
							-- in caso di read singolo con BERR, devo comunque inviare i dati (invio 0xFFFF)
							if nW_R_CYC = '1' and BLTCYC = '0' then
								TEMPDT <= (others => '1');
								if DSIZE = D16 then
								  NWTEMP <= "001";
								else
								  NWTEMP <= "010";
								end if;
							end if;
							
							-- Nuova feature del FW 2858: metto un filler se la TRM dà subito berr o non risponde (NCYC = 1).
							if ROMODE = '1' and NCYC = "0000000000000001" then  -- empty event from TRM during readout
								vme_to_gbt_WR  <= '1';
								if BERRL = '1' then
									vme_to_gbt_DTI <= '0' & "0111" & "111111111111111111110000" & RO_SLOT;
								else
									vme_to_gbt_DTI <= '0' & "0111" & "111111111111111111111111" & RO_SLOT;
								end if;
							end if;
							
							fsm_roc  <= S1_BREAK;
							DS       <= '1';  		-- DS su
							BERRFLAG <= '1';
							slow_ctrl_data	<= '0';
						else
							fsm_roc  <= S1_WAITDTK;  -- continuo ad aspettare
							slow_ctrl_data	<= '0';
						end if;
					end if;
				--------------------------------------------------------------------------------------
				when S1_ENDCYC =>				-- after receiving a DTACK

					  WDOGRES  <= '0';
					  
					  if NWTEMP /= "000" then
						  lb_rdata_i 			<= TEMPDT(31 downto 0);
						  --lb_rdy_i				<= '1' and not(C_TYPE);
						  vme_to_gbt_WR  		<= '1';
						  vme_to_gbt_DTI 		<= '0' & TEMPDT(31 downto 0);
						  slow_ctrl_data		<= '1' and not(C_TYPE) and bltcyc;
						  TEMPDT(31 downto 0) 	<= TEMPDT(63 downto 32);
						  NWTEMP 				<= NWTEMP - 1;
					  else

						vme_to_gbt_WR 			<= '0';
						lb_rdy_i				<= '0';
						slow_ctrl_data			<= '0';
						if DSIZE = D64 and nW_R_CYC = '1' then  -- BLT64 read
						  NOEADWi <= '1';  						-- cambia direzione al bus indirizzi
						  NOEADRi <= '0';
						end if;

						if BLTCYC = '1' and (NCYC /= BLT_SIZE or ADDACK = '1') then 	-- BLT ancora da terminare
						  if ADDACK = '0' then
							NCYC <= NCYC + 1;
						  end if;
						  ADDACK 	<= '0';  -- azzero il flag di addr ack (ormai e' stato eseguito)
						  DS 		<= '0';	 -- Anticipo il DS. Se OP va full, non attivo il DS e fermo il ciclo in corso.					  
						  fsm_roc 	<= S1_WAITDTK;

						else  				-- ciclo terminato
						  if PBLTCYC = '1' then -- c'e' stato un BERR durante un BLT
							fsm_roc   <= ROC_IDLE;
						  else
							fsm_roc   <= S1_WRSTAT;
						  end if;
						  ASL      <= '1';
						  WRITEL   <= '1';
						  IACKL    <= '1';
						  INTLWORD <= '1';
						  NOEADWi  <= '1';
						  NOEADRi  <= '1';
						  NOEDTWi  <= '1';
						  NOEDTRi  <= '1';
						end if;
					  end if;
				--------------------------------------------------------------------------------------
				when S1_BREAK  =>				-- after receiving a BERR

				  if(NWTEMP /= "000") then  
					--lb_rdy_i  		<= '1' and not(C_TYPE);			-- DAV 06/02/2018
					lb_rdata_i 		<= TEMPDT(31 downto 0);
					vme_to_gbt_WR  	<= '1';
					vme_to_gbt_DTI 	<= '0' & TEMPDT(31 downto 0);
					slow_ctrl_data	<= '1'  and not(C_TYPE) and bltcyc;
					NWTEMP 			<= NWTEMP - 1;
					--fsm_roc   	<= S1_WRSTAT;	-- DAV 06/02/2018
				  else
					
					vme_to_gbt_WR  	<= '0';
					slow_ctrl_data	<= '0';
					if(BERRBS = '1') then    -- aspetto la fine del BERR
						if(ROMODE = '0' or C_TYPE = SLOW_CTRL_CYCLE) then
							if(PBLTCYC = '1' and BERRFLAG = '1') then -- c'e' stato un BERR durante un BLT
								fsm_roc <= ROC_IDLE;
							else
								fsm_roc <= S1_WRSTAT;
							end if;
						else
							NOEDRDY <= '0';
							WAITC   <= "000";
							fsm_roc <= S1_WAITTRM;
						end if;

					  ASL      <= '1';
					  WRITEL   <= '1';
					  IACKL    <= '1';
					  INTLWORD <= '1';
					  NOEADWi  <= '1';
					  NOEADRi  <= '1';
					  NOEDTWi  <= '1';
					  NOEDTRi  <= '1';
					end if;
				  end if;

				--------------------------------------------------------------------------------------
				when S1_2ESST_ADDACK => WAITC <= WAITC + 1;
										if WAITC = "100" then
										  fsm_roc <= S1_2ESST_DATA0A;
										  NOEADWi <= '1';  -- cambia direzione al bus indirizzi
										  NOEADRi <= '0';
										end if;
                            
				--------------------------------------------------------------------------------------
				when S1_2ESST_DATA0A => if(DTACKS = '0') then		-- DAV 21/09/2020: was DTACKS1
										  vme_to_gbt_WR  		<= '1';
										  vme_to_gbt_DTI		<= '0' & VAD_d1(31 downto 1) & LWORDB_d1; 
										  TEMPDT(31 downto 0) 	<= VDB_d1;
										  SSTLAST   			<= not BERRBS1;
										  fsm_roc   			<= S1_2ESST_DATA0B;
										  WDOGRES   			<= '1';  -- resetting the watchdog
										  DTACKFLAG 			<= '1';
										end if;
                                
				--------------------------------------------------------------------------------------
				when S1_2ESST_DATA0B => vme_to_gbt_WR  <= '1';
										vme_to_gbt_DTI <= '0' & TEMPDT(31 downto 0);
										if(SSTLAST = '0') then
										  fsm_roc <= S1_2ESST_DATA1A;
										else
										  ASL    <= '1';
										  DS     <= '1';
										  fsm_roc <= S1_2ESST_END;
										end if;                                
                                
				--------------------------------------------------------------------------------------
				when S1_2ESST_DATA1A => if(DTACKS = '1') then		-- DAV 21/09/2020: was DTACKS1
										  vme_to_gbt_WR  <= '1';
										  vme_to_gbt_DTI <= '0' & VAD_d1(31 downto 1) & LWORDB_d1; 
										  TEMPDT(31 downto 0) <= VDB_d1;
										  SSTLAST   <= not BERRBS1;
										  fsm_roc   <= S1_2ESST_DATA1B;
										  WDOGRES   <= '1';  -- resetto lo watchdog
										  DTACKFLAG <= '1';
										end if;
                                
				--------------------------------------------------------------------------------------
				when S1_2ESST_DATA1B => vme_to_gbt_WR  <= '1';
										vme_to_gbt_DTI <= '0' & TEMPDT(31 downto 0);
										if(SSTLAST = '0') then
										  fsm_roc <= S1_2ESST_DATA0A;
										else
										  ASL    <= '1';
										  DS     <= '1';
										  fsm_roc <= S1_2ESST_END;
										end if;                                
                                
				--------------------------------------------------------------------------------------
				when S1_2ESST_END    => vme_to_gbt_WR  <= '0';
										if(BERRBS = '1') then
										  NOEDRDY  <= '0';
										  WAITC    <= "000";
										  WRITEL   <= '1';
										  IACKL    <= '1';
										  INTLWORD <= '1';
										  NOEADWi  <= '1';
										  NOEADRi  <= '1';
										  NOEDTWi  <= '1';
										  NOEDTRi  <= '1';
										  if(regs.ctrl2(CTRL2_TRMWAIT_6 downto CTRL2_TRMWAIT_4) = "000") then
											fsm_roc <= S1_READOUT;
										  else  
											fsm_roc <= S1_WAITTRM;
										  end if;  
										  CYC2ESST <= '0';
										end if;

				--------------------------------------------------------------------------------------
				when S1_WAITTRM  => WAITC <= WAITC + 1;
									if(WAITC = regs.ctrl2(CTRL2_TRMWAIT_6 downto CTRL2_TRMWAIT_4)) then
									  FSM_TIMEOUT <= (others => '1');
									  RO_TOUT <= '0';
									  fsm_roc <= S1_READOUT;
									end if;
			
				--------------------------------------------------------------------------------------
				when S1_WRSTAT  =>
				
				  if(PBLTCYC /= '1') then  			-- se non è un Packed BLT => azzero i flag
					--BERRFLAG  <= '0';		-- DAV
					DTACKFLAG <= '0';
				  end if;
				  vme_to_gbt_DTI 	<= '1' & BERRFLAG & DTACKFLAG & "000000000000000000000000000000"; -- lastcmd ...
				  if(lb_wr = '0' AND lb_rd = '0') then
						lb_rdy_i    	<= '0';
						lb_endpkt_i 	<= '0';
						vme_to_gbt_WR  	<= '1';
						slow_ctrl_data	<= '1' and not(c_type) and bltcyc;
						WDOGRES   		<= '1';
						fsm_roc			<= ROC_IDLE;
				  else
						lb_rdy_i  		<= '1';
						lb_endpkt_i		<= '1';
						vme_to_gbt_WR  	<= '0';
						fsm_roc			<= S1_WRSTAT;
				  end if;
				  				
				-- ###################################################################################
				-- Readout Mode
				-- --------------------------------------------
				-- Sequenza dei dati verso vme_to_gbt:
				-- VME_DATA[0]
				-- VME_DATA[1]
				-- ...
				-- VME_DATA[N]
				-- DRM_Trailer
				-- ex CDH[0]: block length
				-- DRM_Global_Header
				-- DRM_Status1
				-- DRM_Status2
				-- DRM_Status3
				-- DRM_Status4
				-- DRM_CRC
				--------------------------------------------------------------------------------------
				when S1_RO_IDLE  =>
				  -- Preparo i parametri per il readout in MBLT
				  BLT_SIZE 			<= (others => '1'); -- Max Size (ci pensa il BERR a fermare il ciclo)
				  nW_R_CYC 			<= '1';
				  VMECYC   			<= '1';
				  BLTCYC   			<= '1';
				  DSIZE    			<= D64;
				  INTAM    			<= A32_U_MBLT;
				  FSM_TIMEOUT  		<= (others => '1');  -- azzero timeout counter

				  RES_EV_WCNT 		<= '1';

				  L1MSG_RD  		<= '0';
				  L1MSG_RDY 		<= L1MSG_RD;
				  NOEDRDY 			<= '0';  -- Abilito l'uscita dei DRDY (resta attivo fino a quando non devo accedere al VME)
				  vme_to_gbt_wr		<= '0';
				  local_bcid_rd		<= '0';
				  slow_ctrl_data	<= '0';
					
				  if(rodata = '0') then  -- readout end
					ROMODE    <= '0';
					NOEDRDY   <= '1';
					fsm_roc   <= ROC_IDLE;
					
				  -- I have data in L1MSG FIFO => one event is ready to be read out
				  elsif(L1MSG_EMPTY = '0' and EV_BUILDING = '0' and isram_full = '0') then
					L1MSG_RD 		<= '1';  -- reading L1MSG FIFO (data is ready at the next clock cycle)
					EV_BUILDING  	<= '1';

				  -- command from local bus => being executed
				  elsif((lb_rd = '1' or lb_wr = '1') and L1MSG_RDY = '0') then
					NOEDRDY   <= '1';
					fsm_roc   <= ROC_IDLE;
				  end if;

				  -- Adesso in uscita alle FIFO ho BCID di L0 e L1 e lo STATUS
				  if(L1MSG_RDY = '1') then
					RES_EV_WCNT <= '0';  -- Tolgo il reset del contatore

					if(regs.ctrl(CTRL_TEST_EVENT)) = '1' then
					  fsm_roc  	<= S1_TEST_EVENT;
					  test_word <= (others => '0');
					else
					  RO_DONE 	<= not regs.ro_enable(RO_ENABLE_11 downto RO_ENABLE_1);  -- Le TRM non attive le segnala come gia' fatte (RO_DONE=1)
					  RO_DRDY 	<= not VDB(11 downto 1);  -- Legge i DRDY (attivi bassi)
					  RO_SLOT 	<= "0010"; -- comincio a leggere dalla slot 2
					  RO_TOUT 	<= '0';
					  fsm_roc  	<= S1_READOUT;
					end if;

				  end if;
				
				--------------------------------------------------------------------------------------
				when S1_TEST_EVENT =>
				  vme_to_gbt_DTI 	<= '0' & "1110" & "00000000" & test_word & test_word & "1111";  -- test words
				  vme_to_gbt_WR  	<= '1';
				  test_word 		<= test_word + 1;
				  test_wait 		<= "0011";
				  fsm_roc    		<= S1_TEST_WAIT;
				  
				--------------------------------------------------------------------------------------
				when S1_TEST_WAIT =>
				  vme_to_gbt_WR  	<= '0';
				  test_wait 		<= test_wait - 1;
				  if(test_word = regs.roc_tdata(7 downto 0)) then
					fsm_roc 	<= S1_WR_TRAILER;
				  elsif test_wait = "0000" then
					fsm_roc 	<= S1_TEST_EVENT;
				  end if;
		  
				--------------------------------------------------------------------------------------
				when S1_READOUT =>
				  if(FSM_TIMEOUT = regs.trmro_to(7 downto 0)) then
					RO_TOUT <= '1';
					NOEDRDY <= '1';
				  end if;
				  if rodata = '0' then  		-- Fine Readout
					ROMODE   <= '0';
					NOEDRDY  <= '1';
					fsm_roc  <= ROC_IDLE;
				  else

					-- scandisce i DRDY con gli shift register
					if(RO_DRDY(0) = '1' and RO_DONE(0) = '0') then
					  NOEDRDY <= '1';
					  INTAD   <= RO_SLOT & "0000000000000000000000000000";
					  NCYC    <= "0000000000000001";
					  if(SLOTBIT(ROBLT32, RO_SLOT) = '1') then		-- BLT32 !!
						ADDACK  <= '0';		
						DSIZE   <= D32;		
						INTAM   <= A32_U_BLT;	
					  elsif(SLOTBIT(RO2ESST, RO_SLOT) = '1') then	-- 2esst !!
						ADDACK  <= '1';								
						DSIZE   <= D64;
						INTAM   <= A32_U_2ESST;
					  else											-- MBLT !!
						ADDACK  <= '1';								
						DSIZE   <= D64;
						INTAM   <= A32_U_MBLT;
					  end if;
					  PBLTCYC 	<= '0';
					  fsm_roc  	<= S1_STARTCYC;
					  RO_DONE 	<= '1' & RO_DONE(10 downto 1);  -- Segnala come fatta

					else
					  RO_DONE <= RO_DONE(0) & RO_DONE(10 downto 1);
					  -- se ho letto tutto (tranne la LTM in slot 2 che può non aver dati), passo a scrivere la header di DRM
					  -- NOTA: RO_DONE non è stato ancora shiftato, quindi la slot 2 (LTM) corrisponde al bit 1 
					  if(RO_SLOT = "1100" and (RO_DONE = "11111111111" or RO_DONE = "11111111101" or RO_TOUT = '1')) then
						MSG_WCNT 	<= "00000";
						NOEDRDY  	<= '1';
						NOEFAULT 	<= '0';
						-- Azzero i Flag che si sono settati durante il readout
						BERRFLAG  	<= '0';
						DTACKFLAG 	<= '0';
						PBLTCYC   	<= '0';
						fsm_roc    	<= S1_WR_TRAILER;
						if(RO_TOUT = '1') then
						  regs.status(STATUS_ERO_TO) 	<= '1';
						  RTO_FLAG 						<= '1';
						end if;
					  end if;

					end if;

					-- aggiorna gli indici e gli shift register
					if(RO_SLOT = "1100") then  -- giro completato
					  RO_DRDY <= not VDB(11 downto 1);  -- rilegge i DRDY   VERIFICARE TIMING CON ACTEL???
					  RO_SLOT <= "0010";
					else
					  RO_DRDY <= RO_DRDY(0) & RO_DRDY(10 downto 1);
					  RO_SLOT <= RO_SLOT + 1;
					end if;
				  end if;
		  
				--------------------------------------------------------------------------------------
				when S1_WR_TRAILER  =>
				  vme_to_gbt_DTI 	<= '1' & "0101" & "000000000000" & loc_evcnt & "0001";  -- DRM Trailer
				  vme_to_gbt_WR 	<= '1';
				  MSG_WCNT 			<= (others => '0');
				  fsm_roc 			<= S1_WR_HEADER;
		  
				--------------------------------------------------------------------------------------
				when S1_WR_HEADER  =>
				  vme_to_gbt_WR   <= '0';
				  if(rodata = '0') then  	-- Fine Readout
					ROMODE   <= '0';
					fsm_roc  <= ROC_IDLE;
				  else
					case conv_integer(MSG_WCNT) is
					
					  when 0 =>  -- block length (TDH[0])
						vme_to_gbt_DTI 	<= '0' & x"4" & "00000000" & EV_WCNT & "00";
						vme_to_gbt_WR 	<= '1';
						
						if(temper_address = x"58") then
							temper_address	<= x"52"; 
						else
							temper_address	<= temper_address + 1;
						end if;
						temper_en		<= '1';
						local_bcid_rd	<= '1';
					
					  when 1 =>  -- orbit number (TDH[1])
						vme_to_gbt_DTI 	<= '0' & orbit_number;
						vme_to_gbt_WR 	<= '1';
						
						temper_en		<= '0';
						local_bcid_rd	<= '0';

					  -- DRM_HEADER = "0100" & DRM_ID(7) & EVENT_WORDS(17) & "0001"
					  when 2 =>
						vme_to_gbt_DTI 	<= '0' & "0100" & regs.drm_id(7 downto 0) & DRM_WCNT & "0001";
						vme_to_gbt_WR 	<= '1';
						
						temper_en		<= '0';
						local_bcid_rd	<= '0';

					  -- DRM_STATUS1 = "0100" & reserved(3) & DRMH_size(4) & DRMH_Vers(5) & EXTCLK_LOSS(2) & PARTECIPATING_TRM(11) & "0001"
					  when 3 =>
						vme_to_gbt_DTI 	<= '0' & "0100" & '0' & DRMHS & DRMHV & ECLKLOSS & '0' & (RO_DONE and regs.ro_enable(10 downto 0)) & "0001";
						vme_to_gbt_WR 	<= '1'; 

					  -- DRM_STATUS2 = "0100" & ERO_TIMEOUT & FAULT(11) & '0' & TRM_ENABLE_MASK(11) & "0001"
					  when 4 =>
						vme_to_gbt_DTI 	<= '0' & "0100" & RTO_FLAG & not VDB(11 downto 1) & '0' & regs.ro_enable(10 downto 0) & "0001";
						vme_to_gbt_WR 	<= '1';
						NOEFAULT 		<= '1';
						RTO_FLAG 		<= '0';

					  -- DRM_STATUS3 = "0100" & RUNTIME_INFO(12) & trg_bc(12) & "0001"
					  when 5 =>
						vme_to_gbt_DTI 	<= '0' & "0100" & DRM_BUNCHID & trg_bc & "0001"; 
						vme_to_gbt_WR 	<= '1';
						NOEDRDY 		<= '1';

					  -- DRM_STATUS4 = "0100" & reserved(8) & SENSOR(3) & I2C_ACK(1) & '0' & TEMPERATURE(10) & "0001"
					  when 6 =>
						vme_to_gbt_DTI 	<= '0' & "0100" & "00000000" & (temper_address(3 downto 0) - 2) & "00" & ("00" & GDI) & "0001";
						vme_to_gbt_WR 	<= '1';

					  -- DRM_EVENT_CRC = "0100" & reserved(8) & CRC(16) & "0001"
					  when 7 =>
						vme_to_gbt_DTI 	<= '0' & "0100" & "0000000" & IRQB1 & CRC & "0001";
						vme_to_gbt_WR 	<= '1';
						NOEDRDY 		<= '1';
						EV_BUILDING  	<= '0';
						fsm_roc 		<= S1_RO_IDLE;

					  when others => null;
					end case;
		  
					MSG_WCNT <= MSG_WCNT + 1;
				end if;

			  end case;
        end if;
    end process; 

	-----------------------------------------------------------------------------------------------------------------------------------------
	--- GBTx I2C configuration --------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	GDO			<= lb_wdata(7 downto 0);
	GADD		<= temper_address when (fsm_roc = S1_WR_HEADER) else lb_address(7 downto 0);
	
	-- GBTx control signals process
	process(FPGACK_40MHz, clear, soft_clear)
	begin
	if(clear = '1' or soft_clear = '1') then
		state_gbtx_config	<= '0';
		GWR					<= '0';
	elsif(rising_edge(FPGACK_40MHz)) then
		if(state_gbtx_config = '0') then
			if(lb_address(31 downto 28) = "0001" and lb_address(23 downto 20) = "0000" and (lb_address(7 downto 0) >= x"20" and lb_address(7 downto 0) <= x"5F")) then
				if(lb_wr = '1') then
					GWR					<= '1';
					state_gbtx_config	<= '1';
				else	
					GWR					<= '0';
					state_gbtx_config	<= '0';
				end if;
			else	
				GWR					<= '0';
				state_gbtx_config	<= '0';
			end if;
		else	
			if(lb_wr = '0') then
				state_gbtx_config	<= '0';
			end if;
			GWR			<= '1';
		end if;
	end if;
	end process;
	
	process(FPGACK_40MHz, clear, soft_clear)
	begin
	if(clear = '1' or soft_clear = '1') then
		state_gbtx_en		<= "00";
		GEN					<= '0';
	elsif(rising_edge(FPGACK_40MHz)) then
		if(state_gbtx_en = "00") then
			if(fsm_roc = S1_WR_HEADER) then
				GEN 	<= temper_en;
			elsif(fsm_roc = ROC_IDLE and lb_address(31 downto 28) = "0001" and lb_address(23 downto 20) = "0000" and (lb_address(7 downto 0) >= x"20" and lb_address(7 downto 0) <= x"5F")) then
				if(lb_rd = '1') then
					GEN				<= '1';
					state_gbtx_en	<= "01";
				elsif(lb_wr = '1') then
					GEN				<= '0';
					state_gbtx_en	<= "10";
				else	
					GEN				<= '0';
					state_gbtx_en	<= "00";
				end if;
			else	
				GEN				<= '0';
				state_gbtx_en	<= "00";
			end if;
		elsif(state_gbtx_en = "01") then	
			if(lb_rd = '0') then
				state_gbtx_en	<= "00";
			end if;
			GEN			<= '0';
		elsif(state_gbtx_en = "10") then	
			if(lb_wr = '0') then
				state_gbtx_en	<= "00";
				GEN				<= '1';
			else	
				GEN				<= '0';
			end if;	
		end if;
	end if;
	end process;
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------------------------------------
	--- VME related processes (begin) -------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	-- syncing VME asynchronous signals (can I leave just one flip-flop ?)

	process(FPGACK_40MHz)
	  begin
		if rising_edge(FPGACK_40MHz) then
		  DTACKS1 <= DTACKB;
		  DTACKS  <= DTACKS1;
		  BERRBS1 <= BERRB and BERRL;  -- risente il suo BERR
		  BERRBS  <= BERRBS1;
		end if;
	end process;
	  
	-- pilotaggio DS0/1: la FSM1 genera DS. Esso viene poi messo in OR con DRLTC per anticipare la
	-- chiusura del DS (appena ho lecciato i dati). Inoltre va in OR con DSINHIB per evitare che
	-- riparta prima che lo slave abbia tolto il DTACK (infatti la FSM riparte subito senza
	-- verificare la chiusura del DTACK per risparmiare un ciclo di CLK).
	DS0L <= DS or DSINHIB or not DRLTC;
	DS1L <= DS or DSINHIB or not DRLTC;
	  
	-- DS inhibit va alto sul fronte in salita del DS (ciclo precedente) e torna basso quando
	-- DTACK va alto; questo consente di ripartire con il ciclo successivo (la FSM potrebbe
	-- aver gia' rimesso basso il DS generato da lei)
	process(DTACKS, DS)				
	begin
		if(DTACKS = '1') then	
		  DSINHIB <= '0';
		elsif rising_edge(DS) then
		  if(CYC2ESST = '0') then  -- con 2esst, il DS resta basso fisso, quindi DSINHIB viene lasciato a 0
			DSINHIB <= '1';
		  end if;  
		end if;
	 end process;

	-- DSINHIB sincronizzato per la FSM
	process(active_high_reset,FPGACK_40MHz)
	begin
		if(active_high_reset = '1') then
		  DSINHIBS <= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
		  DSINHIBS <= DSINHIB;
		end if;
	 end process;
	  
	-- --------------------------------------------------------------------------------------
	-- Latch dei dati dal bus VME in lettura: i dati del VME (64 bit, VAD+VDB) vengono strobati
	-- dentro il registro VDLTC finche' DRLTC sta alto; DRLTC va basso (congelando i dati) appena
	-- si attiva DTACKS (va basso) e torna alto quando la FSM1 trasferisce i dati in TEMPDT.
	process(active_high_reset,FPGACK_40MHz)
	begin
		if(active_high_reset = '1') then
			VDLTC <= (others => '0');
		elsif(rising_edge(FPGACK_40MHz)) then
			if(DRLTC = '1') then
				if(DSIZE = D64) then
				  VDLTC(31 downto  0) <= VAD(31 downto 1) & LWORDB;
				  VDLTC(63 downto 32) <= VDB;
				else
				  VDLTC(31 downto  0) <= VDB;
				  VDLTC(63 downto 32) <= (others => '-');
				end if;
			end if;
		end if;
	end process;

	-- DRLCT viene resettato durante il primo semiperiodo di clock quando DTACKS va basso
	-- e torna alto quando la FSM1 scrive i dati in TEMPDT (cioe' DSINHIBS = '0' and NWTEMP = "000")
	process(active_high_reset, DTACKS, DTACKSN, FPGACK_40MHz)
	begin
		if active_high_reset = '1' or (DTACKS = '0' and DTACKSN = '1') then
		  DRLTC <= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
		  if(DSINHIBS = '0' and NWTEMP = "000") then
			DRLTC <= '1';
		  end if;
		end if;
	end process;

	-- DTACKSN e' DTACKS cloccato con CLK negato e serve per fare il reset di DRLTC che dura
	-- mezzo periodo di CLK
	process(active_high_reset,FPGACK_40MHz)
	begin
		if(active_high_reset = '1') then
		  DTACKSN <= '0';
		elsif(falling_edge(FPGACK_40MHz)) then
		  if(CYC2ESST = '0') then  -- con 2esst non si usa DRLTC, quindi tengo DTACKSN=0 per lasciare DRLTC alto fisso
			DTACKSN <= DTACKS;
		  else  
			DTACKSN <= '0';
		  end if;  
		end if;
	end process;
	-----------------------------------------------------------------------------------------------------------------------------------------
	  
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- Bus Timer (generates a BERR after a (1.6us x 32 = 51.2 us) timeout) ------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	berr_process: process(active_high_reset, FPGACK_40MHz)
	  begin
		if(active_high_reset = '1') then
		  BERRL 	<= '1';
		  VTIMEOUT 	<= (others => '0');
		elsif(rising_edge(FPGACK_40MHz)) then
		  if(DS = '0') then
			if(TICK(T64)) = '1' then
			  VTIMEOUT 	<= VTIMEOUT + 1;
			  if(VTIMEOUT = "11111") then
				BERRL 	<= '0';
			  end if;
			end if;
		  else
			BERRL    <= '1';
			VTIMEOUT <= (others => '0');
		  end if;
		end if;
	end process berr_process;
  
  	-----------------------------------------------------------------------------------------------------------------------------------------
	--- VME related processes (end) ---------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
  
  	-----------------------------------------------------------------------------------------------------------------------------------------
	-- Event Word Counters ------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	EV_WCNT_process: process(FPGACK_40MHz, clear, soft_clear)
	  begin
		if(clear = '1' or soft_clear = '1') then
		  EV_WCNT 		<= (others => '0');
		  INC_EVWCNTH 	<= '0';
		elsif(rising_edge(FPGACK_40MHz)) then
		  INC_EVWCNTH 	<= '0';
		  if(RES_EV_WCNT = '1') then
			EV_WCNT <= conv_std_logic_vector(NW_DRM_HT, EV_WCNT'high+1);
		  else
			-- breaking the counter to improve the timing
			-- NOTE: the counter is read at least 2 clock cycles after it is incremented, so there are no problems
			if(vme_to_gbt_valid = '1') then
			  EV_WCNT(9 downto 0) <= EV_WCNT(9 downto 0) + 1;
			  if EV_WCNT(9 downto 0) = "1111111111" then
				INC_EVWCNTH <= '1';
			  end if;
			end if;
			if INC_EVWCNTH = '1' then
			  EV_WCNT(EV_WCNT'high downto 10) <= EV_WCNT(EV_WCNT'high downto 10) + 1;
			end if;
		  end if;
		end if;
	end process EV_WCNT_process;

	DRM_WCNT_process: process(FPGACK_40MHz, clear, soft_clear)
	  begin
		if(clear = '1' or soft_clear = '1') then
		  DRM_WCNT <= (others => '0');
		elsif(rising_edge(FPGACK_40MHz)) then
		  if(RES_EV_WCNT = '1') then
			DRM_WCNT <= conv_std_logic_vector(-1, DRM_WCNT'high+1);
		  elsif(vme_to_gbt_valid = '1') then
			DRM_WCNT <= DRM_WCNT + 1;
		  end if;
		end if;
	end process DRM_WCNT_process;
	  
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- CRC ----------------------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
	CRC_process: process(FPGACK_40MHz, clear, soft_clear)
	  begin
		if(clear = '1' or soft_clear = '1') then
			CRC <= (others => '0');
		elsif(rising_edge(FPGACK_40MHz)) then
		  if(fsm_roc = S1_RO_IDLE) then
			CRC <= (others => '0');
		  elsif(vme_to_gbt_valid = '1') then
			CRC <= CRC xor vme_to_gbt_DTI(15 downto 0) xor vme_to_gbt_DTI(31 downto 16);
		  end if;
		end if;
	end process CRC_process;	  
	  

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- P2 bus signals  ----------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------

	  -- FSM2 to provide the test pulses
	  -- -----------------------------------------------------------------------------
	  -- Genero tre segnali: TEST_PULSE subito dopo che ho ricevuto un PULSEP da pannello
	  -- e dura 2 cicli. Dopo un tempo programmabile (25ns * N, dove N e' il contenuto del registro
	  -- ROC_TDATA, si attiva il segnale TEST_TRIGGER. Dopo altri 1.6us (tempo fisso) si attiva
	  -- TEST_TRIGGER1. Entrambi i trigger durano 2 cicli. Il primo genera L1 e il secondo L2.
	  -- Nota: siccome PULSEP sta alto se non pilotato (fail-safe), allora rendo il sistema
	  -- sensibile alla transazione basso-alto.
	  test_pulse_process: process(active_high_reset, FPGACK_40MHz)
	  begin
		if(active_high_reset = '1') then
		  TEST_TRIGGER  		<= '0';
		  TEST_TRIGGER1 		<= '0';
		  PULSEPS1      		<= '1';
		  PULSEOFF      		<= '1';
		  PULSE2        		<= '0';
		  PREPULSES     		<= '0';
		  STATE2        		<= S2_INIT;
		  TESTP_CNT     		<= (others => '0');
		  regs.pulsecnt			<= D_PULSECNT;
		elsif(rising_edge(FPGACK_40MHz)) then
		  PULSEPS1  <= PULSEP;
		  PREPULSES <= PREPULSE;

		  if(PULSECNT_RES = '1') then
			regs.pulsecnt  <= D_PULSECNT;
		  end if;

		  case STATE2 is

			--------------------------------------------------------------------------------------
			when S2_INIT  =>
			  TEST_TRIGGER1 <= '0';
			  if WPULSE(SHOT_TEST) = '1' or PREPULSES = '1' then
				PULSE2 <= '1';
				STATE2 <= S2_TP;
				TESTP_CNT <= conv_std_logic_vector(1,TESTP_CNT'high+1);
			  elsif PULSEPS1 = '0' then
				PULSEOFF <= '0';
				STATE2 <= S2_IDLE;
			  end if;

			--------------------------------------------------------------------------------------
			when S2_IDLE  =>
			  if PULSEPS1 = '1' or WPULSE(SHOT_TEST) = '1' or PREPULSES = '1' then
				regs.pulsecnt <= regs.pulsecnt + 1;
				PULSE2 <= '1';
				STATE2 <= S2_TP;
				TESTP_CNT <= conv_std_logic_vector(1,TESTP_CNT'high+1);
			  end if;

			--------------------------------------------------------------------------------------
			when S2_TP  =>
			  TESTP_CNT <= TESTP_CNT - 1;
			  PULSEOFF <= '1';
			  if conv_integer(TESTP_CNT) = 0 then
				PULSE2 <= '0';
				TESTP_CNT  <= regs.tdelay;
				STATE2 <= S2_TR;
			  end if;

			--------------------------------------------------------------------------------------
			when S2_TR  =>
			  TESTP_CNT <= TESTP_CNT - 1;
			  if conv_integer(TESTP_CNT) = 1 then
				TEST_TRIGGER <= '1';
			  elsif conv_integer(TESTP_CNT) = 0 then
				TESTP_CNT  <= conv_std_logic_vector(64, TESTP_CNT'high+1);
				STATE2 <= S2_TR1;
			  end if;

			--------------------------------------------------------------------------------------
			when S2_TR1  =>
			  TESTP_CNT <= TESTP_CNT - 1;
			  TEST_TRIGGER <= '0';
			  if conv_integer(TESTP_CNT) = 1 then
				TEST_TRIGGER1 <= '1';
			  elsif conv_integer(TESTP_CNT) = 0 then
				STATE2 <= S2_INIT;
			  end if;

		  end case;

		end if;
	  end process test_pulse_process;

	  -- TEST_PULSE deve partire con PULSEP in modo asincrono ma poi, dopo il primo fronte di clk,
	  -- deve durare 2 cicli. PULSE2 dura 2 cicli e va in OR con PULSEP opportunamente inibito
	  -- da PULSEOFF dopo il primo ciclo.
	  TEST_PULSE <= ((PULSEP or PULSEPS1) and not PULSEOFF) or PULSE2A;

	  -- SPULSE sono impulsati da TEST_PULSE (con maschera) oppure controllati da TDATA in IO_TEST mode
	  SPULSEL0i <= TEST_PULSE and regs.ts_mask(TS_MASK_CPDM_P0) when regs.ctrl(CTRL_IO_TEST) = '0' else regs.roc_tdata(TDATA_PULSE0);
	  SPULSEL1i <= TEST_PULSE and regs.ts_mask(TS_MASK_CPDM_P1) when regs.ctrl(CTRL_IO_TEST) = '0' else regs.roc_tdata(TDATA_PULSE1);
	  SPULSEL2i <= TEST_PULSE and regs.ts_mask(TS_MASK_CPDM_P2) when regs.ctrl(CTRL_IO_TEST) = '0' else regs.roc_tdata(TDATA_PULSE2);
	  -- NOTA: ci può essere una inversione per recuperare quella nella CPDM
	  SPULSEL0 <= SPULSEL0i xor not regs.ctrl(CTRL_PULSE_POLARITY);
	  SPULSEL1 <= SPULSEL1i xor not regs.ctrl(CTRL_PULSE_POLARITY);
	  SPULSEL2 <= SPULSEL2i xor not regs.ctrl(CTRL_PULSE_POLARITY);


	 p2_trigger_signals_process:  process(FPGACK_40MHz, clear, soft_clear)
	  begin
		if(clear = '1' or soft_clear = '1') then
		  L0  		<= '0';
		  L1A 		<= '0';
		  L1R 		<= '0';
		  L2A 		<= '0';
		  L2R 		<= '0';
		  EVENT_RES <= '1';
		  BUNCH_RES <= '0';
		  PULSE2A 	<= '0';
		elsif(rising_edge(FPGACK_40MHz)) then		
		  L0        <= (TEST_TRIGGER  and regs.ts_mask(TS_MASK_L0));     
		  if(regs.ts_mask(TS_MASK_L1A) = '1') then
			L1A     <= TEST_TRIGGER;   
		  else 
			L1A		<= l1a_ttc_delay; 			-- new busy is irqb1 		
		  end if;
		  L1R       <= (TEST_TRIGGER  and regs.ts_mask(TS_MASK_L1R))    or L1R_TTC;
		  if(regs.ts_mask(TS_MASK_L2A) = '1') then
			L2A     <= TEST_TRIGGER1;  	
		  else
			L2A		<= l1a_ttc_delay;			-- new busy is irqb1
		  end if;
		  L2R       <= (TEST_TRIGGER1 and regs.ts_mask(TS_MASK_L2R))    or L2R_TTC;
		  EVENT_RES <= (TEST_TRIGGER  and regs.ts_mask(TS_MASK_EVRES))  or EVENT_RES_TTC; -- DAV 11/09/2018
		  if(regs.ts_mask(TS_MASK_BNCRES) = '1') then
			BUNCH_RES 	<= TEST_TRIGGER;
		  else
			BUNCH_RES	<= bunch_reset_delay;
		  end if;
		  PULSE2A   <= PULSE2;
		end if;
	end process p2_trigger_signals_process;
	  
	loc_evcnt_process: process(FPGACK_40MHz, clear, soft_clear)
	  begin
		if(clear = '1' or soft_clear = '1') then
			loc_evcnt	<= (others => '0');
		elsif(rising_edge(FPGACK_40MHz)) then
			if(acq_on = '1') then
				if(regs.ts_mask(TS_MASK_EVRES) = '1') then
					loc_evcnt	<= (others => '0');
				elsif(fsm_roc = S1_WR_TRAILER) then
					loc_evcnt 	<= loc_evcnt + 1;
				end if;
			else	
				loc_evcnt	<= (others => '0');
			end if;
		end if;
	end process loc_evcnt_process;
	    
	DRM_BCNT_process: process(FPGACK_40MHz, clear, soft_clear)
	  begin
		if(clear = '1' or soft_clear = '1') then
			DRM_BCNT    <= x"000";
		elsif(rising_edge(FPGACK_40MHz)) then   
		  if(bunch_reset_delay = '1') then
			DRM_BCNT <= x"001";
		  else
			if(DRM_BCNT = x"DEB") then
				DRM_BCNT	<= (others => '0');
			else
				DRM_BCNT <= DRM_BCNT + 1;
			end if;
		  end if;
		end if;
	end process DRM_BCNT_process;
	  
	local_bcid_instance: local_bcid
	port map
		(
		CLK   => FPGACK_40MHz,
		RESET => fifo_clear,
		DATA  => DRM_BCNT,
		WE    => l1a_ttc_delay,
		EMPTY => open,
		FULL  => open,
		RE    => local_bcid_rd,
		Q     => DRM_BUNCHID
		);

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- P2 and front panel service signals ---------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------

	-- differential spare output on P2
	SPDO <= regs.ctrl(CTRL_SPDO);
	
	-- input and output spare
	SPSEOL <= '0' when regs.ctrl(CTRL_IO_TEST) = '0' else regs.roc_tdata(TDATA_SPSEO);
	regs.status(STATUS_SPSEI) <= SPSEIB;

	-- local / remote CPDM clock
	CPDM_FCLKL <= regs.ctrl(CTRL_CPDM_FCLK);
	regs.status(STATUS_CPDM_SCLK) <= CPDM_SCLKB when regs.drm_id(0)= '0' else '0';

	-- LTM signals
	regs.status(STATUS_LTM_LTRG) <= LTMLTB;
	PULSETGLL <= WPULSE(SHOT_LTM_PT) when regs.ctrl(CTRL_IO_TEST) = '0' else regs.roc_tdata(TDATA_LTM_PTGL);

	-- front panel busy
	BUSYP <= regs.status(STATUS_BUSY) when regs.ctrl(CTRL_IO_TEST) = '0' else regs.roc_tdata(TDATA_BUSYP);

	-- front panel pulse
	regs.status(STATUS_PULSEP) <= PULSEP;

	-- PROGL: enabling Microsemi programming mode
	-- PROG on P2 is active high => PROGL is active low => if CTRL_PROG = 1, then PROG is active
	PROGL <= not regs.ctrl(CTRL_PROG);
	-----------------------------------------------------------------------------------------------------------------------------------------

	  
	-----------------------------------------------------------------------------------------------------------------------------------------
	--- front panel LEDs --------------------------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------

	  -- VME LED monostable: it asserts with DS and deasserts at the second TICK(T4M)
	  VMELED_process: process(FPGACK_40MHz, active_high_reset, DS)
	  variable MON : std_logic;
	  begin
		if(active_high_reset = '1' or DS = '0') then
		  VMELED <= '0';
		  MON := '1';
		elsif(rising_edge(FPGACK_40MHz)) then
		  if TICK(T4M) = '1' then
			if MON = '1' then   -- first TICK
			  MON := '0';
			else                -- second TICK
			  VMELED <= '1';
			end if;
		  end if;
		end if;
	  end process VMELED_process;

	  -- l1a_ttc LED monostable: it asserts with l1a_ttc and deasserts at the second TICK(T4M)
	  DRDYLED_process: process(FPGACK_40MHz, active_high_reset, l1a_ttc_delay)
	  variable MON : std_logic;
	  begin
		if(active_high_reset = '1' or l1a_ttc_delay = '1') then
		  DRDYLED <= '0';
		  MON := '1';
		elsif(rising_edge(FPGACK_40MHz)) then
		  if(TICK(T4M)) = '1' then
			if(MON = '1') then   -- first TICK
			  MON := '0';
			else                -- second TICK
			  DRDYLED <= '1';
			end if;
		  end if;
		end if;
	  end process DRDYLED_process;
	-----------------------------------------------------------------------------------------------------------------------------------------
	
	-----------------------------------------------------------------------------------------------------------------------------------------
	-- internal SRAM (int_sram) management --------------------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------------------------------------------------------
  	int_sram_instance: int_sram
    port map
		(
        -- inputs
        ARST   => fifo_clear,
        CLK    => FPGACK_40MHz,
        RADDR  => isram_raddr,
        REN    => isram_REi,
        WADDR  => isram_waddr,
        WD     => isram_Di,
        WEN    => isram_WEi,
        -- outputs
        RD     => isram_dout
        );
	
	bus_extender_instance: bus_extender
	port map
	(
		FPGACK_40MHz		=> FPGACK_40MHz,
		clear				=> fifo_clear,
		drm_data			=> drm_data,
		drm_valid			=> drm_valid,
		GBTx_data_fifo_dti	=> GBTx_data_fifo_dti,
		GBTx_fifo_wr		=> GBTx_data_fifo_wr
	);
	
	-- Data coming from vme_int are not in the correct order (header is written last).
	-- The correct order is restored when writing int_sram by setting the writing address.
	-- int_sram reading is done sequentially
    int_sram_process: process(clear, soft_clear, FPGACK_40MHz)
    begin
		if(clear = '1' or soft_clear = '1') then
		  r_pnt           		<= (others => '0');
		  w_pnt           		<= conv_std_logic_vector(NW_DRM_HT - 1, w_pnt'high + 1);  -- the header is written in the end
		  w_jump          		<= (others => '0');
		  isram_WEi          	<= '0';
		  isram_REi          	<= '0';
		  isram_read         	<= '0';
		  isram_read1        	<= '0';
		  isram_out_valid       <= '0';
		  isram_read_first   	<= '0';
		  isram_read_first1  	<= '0';
		  isram_out_valid_first <= '0';
		  isram_Di           	<= (others => '0');
		  isram_waddr        	<= (others => '0');
		  isram_raddr        	<= (others => '0');
		  drm_data 				<= (others => '0');
		  drm_valid  			<= '0';
		  sniff_data			<= (others => '0');
		  sniff_valid			<= '0';
		  sniff_ctrl			<= '0';
		  sniff_data_temp		<= (others => '0');
		  sniff_valid_temp		<= '0';
		  sniff_ctrl_temp		<= '0';
		  isram_full     	 	<= '0';
		  ne_af           	 	<= '0';
		  isram_nev         	<= (others => '0');
		  evhead_cnt      		<= (others => '0');
		  wr_evhead       		<= '0';
		  rwcnt           		<= "000000000000000001";	  

		elsif(rising_edge(FPGACK_40MHz)) then

		  if(rodata = '0') then
			
			r_pnt           		<= (others => '0');
			w_pnt           		<= conv_std_logic_vector(NW_DRM_HT - 1, w_pnt'high + 1);  -- the header is written in the end
			w_jump          		<= (others => '0');
			isram_WEi          		<= '0';
			isram_REi          		<= '0';
			isram_read         		<= '0';
			isram_read1        		<= '0';
			isram_out_valid       	<= '0';
			isram_read_first   		<= '0';
			isram_read_first1  		<= '0';
			isram_out_valid_first 	<= '0';
			isram_Di           		<= (others => '0');
			isram_waddr        		<= (others => '0');
			isram_raddr        		<= (others => '0');
			drm_data		 		<= (others => '0');
			drm_valid		  		<= '0';
			isram_full     	 		<= '0';
			ne_af           	 	<= '0';
			isram_nev         		<= (others => '0');
			evhead_cnt      		<= (others => '0');
			wr_evhead       		<= '0';
			rwcnt           		<= "000000000000000001";
			if(slow_ctrl_data = '1') then
				if(vme_to_gbt_DTI(32) = '1') then
					sniff_data				<= '1' & sniff_data_temp(31 downto 0);
					sniff_valid				<= sniff_valid_temp;
					sniff_ctrl				<= sniff_ctrl_temp;
					sniff_valid_temp		<= '0';
					sniff_ctrl_temp			<= '0';
				else	
					sniff_data_temp			<= vme_to_gbt_DTI(32 downto 0);
					sniff_valid_temp		<= '1';
					sniff_ctrl_temp			<= '1';
					--------------------------------------------------------
					sniff_data				<= sniff_data_temp;
					sniff_valid				<= sniff_valid_temp;
					sniff_ctrl				<= sniff_ctrl_temp;
				end if;
			else	
				sniff_valid		<= '0';
				sniff_ctrl		<= '0';
			end if;
		  
		  else						
			isram_read        	<= '0';
			isram_read_first  	<= '0';
			isram_full     		<= ne_af or nw_af;
			
			-- writing on internal_sram
			if(vme_to_gbt_valid = '1') then
				isram_WEi 		<= '1';
				isram_waddr 	<= w_pnt;
				isram_Di 		<= '0' & vme_to_gbt_DTI(32) & vme_to_gbt_DTI(32) & vme_to_gbt_DTI(32 downto 0);  -- bit 32 is triplicated

				if(vme_to_gbt_DTI(32) = '1') then 			-- last word: trailer of the event
					w_pnt  		<= w_jump; 						-- going back to write the header words
					w_jump 		<= w_pnt + NW_DRM_HT;  			-- pointing to the initial offset to write the next event
					wr_evhead 	<= '1';
				elsif(conv_integer(evhead_cnt) = NW_DRM_HT-2) then
					w_pnt  		<= w_jump;
					w_jump 		<= w_jump - NW_DRM_HT + 1;
					isram_nev 	<= isram_nev + 1;
					if(conv_integer(isram_nev) = isram_nev_aflev) then
					ne_af <= '1';
					end if;
					wr_evhead <= '0';
					evhead_cnt <= (others => '0');  			-- reset header word count
				else
					w_pnt <= w_pnt + 1;
					if(wr_evhead = '1') then
						evhead_cnt <= evhead_cnt + 1;
					end if;
				end if;
			else
				isram_WEi <= '0';
			end if;
			
			-- reading data from internal_ssram towards GBTx_data_fifo (data are OK at the next clock cycle)
			isram_REi 		<= '1';
			isram_raddr  	<= r_pnt;  -- address to be read
			if(isram_nev /= "00000000" and GBTx_data_fifo_almfull = '0' and isram_read_first = '0' and isram_read_first1 = '0' and isram_out_valid_first = '0') then
				isram_read 	<= '1';
				r_pnt 		<= r_pnt + 1;
				if(conv_integer(rwcnt) = 1) then
				  isram_read_first <= '1';
				end if;
				if(conv_integer(rwcnt) = 2) then
				  isram_nev <= isram_nev - 1;
				  if(conv_integer(isram_nev) = isram_nev_aflev) then
					ne_af <= '0';
				  end if;
				end if;
				rwcnt <= rwcnt - 1;
			end if;

			isram_read1  			<= isram_read;
			isram_out_valid  		<= isram_read1;
			isram_read_first1 		<= isram_read_first;
			isram_out_valid_first	<= isram_read_first1;

			if(isram_out_valid = '1') then
				drm_data		 	<= isram_dout(32 downto 0);
				drm_valid		 	<= '1' and not(regs.ctrl2(CTRL2_MANDRAKE));
				sniff_data			<= isram_dout(32 downto 0);
				sniff_valid			<= '1' and regs.ctrl2(CTRL2_SR_IRQEN);
				sniff_ctrl			<= '0';
				if(isram_out_valid_first = '1') then
					rwcnt <= isram_dout(rwcnt'high+2 downto 2);  			-- event size (in bytes => divided by 4)
				end if;
			else
				drm_valid		 	<= '0';
				sniff_valid			<= '0';
			end if;
			
		  end if;
		end if;
    end process int_sram_process;
	
	isram_nw_process: process(clear, soft_clear, FPGACK_40MHz)
    begin
		if(clear = '1' or soft_clear = '1') then
			nw_af          			<= '0';
			isram_NW          		<= (others => '0');
		elsif(rising_edge(FPGACK_40MHz)) then
			if(vme_to_gbt_valid = '1' and isram_nev /= "00000000" and GBTx_data_fifo_almfull = '0' and isram_read_first = '0' and isram_read_first1 = '0' and isram_out_valid_first = '0') then		-- writing and reading
				isram_NW  	<= isram_NW;
				nw_af		<= nw_af;
			elsif(vme_to_gbt_valid = '1') then																																						-- writing but not reading
				isram_NW  	<= isram_NW + 1;
				if(isram_NW = isram_AFLEV) then
					nw_af 	<= '1';
				end if;
			elsif(isram_nev /= "00000000" and GBTx_data_fifo_almfull = '0' and isram_read_first = '0' and isram_read_first1 = '0' and isram_out_valid_first = '0') then								-- reading but not writing
				isram_NW 	<= isram_NW - 1;
				if(isram_NW = isram_AFLEV) then
				  nw_af 	<= '0';
				end if;
			end if;
		end if;
	end process isram_nw_process;
	-----------------------------------------------------------------------------------------------------------------------------------------

end RTL;
