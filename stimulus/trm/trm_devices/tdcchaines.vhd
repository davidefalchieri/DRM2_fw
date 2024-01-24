LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY TDCchaines IS
   PORT( 
      BNC_RES    : IN     std_logic;
      CHAINA_EN  : IN     std_logic;
      CHAINB_EN  : IN     std_logic;
      CLK        : IN     std_logic;
      EV_RES     : IN     std_logic;
      Finished   : IN     std_logic;
      HITA       : IN     std_logic_vector (23 DOWNTO 0);
      HITB       : IN     std_logic_vector (23 DOWNTO 0);
      TDCGDA     : IN     std_logic;
      TDCGDB     : IN     std_logic;
      TDCTRG     : IN     std_logic;
      TDC_RES    : IN     std_logic;
      TOKINA     : IN     std_logic;
      TOKINB     : IN     std_logic;
      TDCDA      : OUT    std_logic_vector (31 DOWNTO 0);
      TDCDB      : OUT    std_logic_vector (31 DOWNTO 0);
      TDCDRYA    : OUT    std_logic;
      TDCDRYB    : OUT    std_logic;
      TOKOUTA    : OUT    std_logic;
      TOKOUTA_BP : OUT    std_logic;
      TOKOUTB    : OUT    std_logic;
      TOKOUTB_BP : OUT    std_logic
   );

-- Declarations

END TDCchaines ;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
LIBRARY std;
USE std.textio.all;


ARCHITECTURE struct OF TDCchaines IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL BNC_RES_A : std_logic;
   SIGNAL BNC_RES_B : std_logic;
   SIGNAL EV_RES_A  : std_logic;
   SIGNAL EV_RES_B  : std_logic;
   SIGNAL GND       : std_logic;
   SIGNAL TDC_RES_A : std_logic;
   SIGNAL TDC_RES_B : std_logic;
   SIGNAL TOKOUTA1  : std_logic;
   SIGNAL TOKOUTA2  : std_logic;
   SIGNAL TOKOUTA2_1: std_logic;
   SIGNAL TOKOUTA2_2: std_logic;
   SIGNAL TOKOUTA2_3: std_logic;
   SIGNAL TOKOUTA2_4: std_logic;
   SIGNAL TOKOUTA2_5: std_logic;
   SIGNAL TOKOUTA2_6: std_logic;
   SIGNAL TOKOUTA2_7: std_logic;
   SIGNAL TOKOUTA2_8: std_logic;
   SIGNAL TOKOUTB1  : std_logic;
   SIGNAL TOKOUTB2  : std_logic;
   SIGNAL TOKOUTB2_1: std_logic;
   SIGNAL TOKOUTB2_2: std_logic;
   SIGNAL TOKOUTB2_3: std_logic;
   SIGNAL TOKOUTB2_4: std_logic;
   SIGNAL TOKOUTB2_5: std_logic;
   SIGNAL TOKOUTB2_6: std_logic;
   SIGNAL TOKOUTB2_7: std_logic;
   SIGNAL TOKOUTB2_8: std_logic;
   SIGNAL TRIGGER_A : std_logic;
   SIGNAL TRIGGER_B : std_logic;
   SIGNAL VCC       : std_logic;


   -- Component Declarations
   COMPONENT FCT244
   PORT (
      A0    : IN     std_logic;
      A1    : IN     std_logic;
      A2    : IN     std_logic;
      A3    : IN     std_logic;
      A4    : IN     std_logic;
      A5    : IN     std_logic;
      A6    : IN     std_logic;
      A7    : IN     std_logic;
      NOEAB : IN     std_logic;
      B0    : OUT    std_logic;
      B1    : OUT    std_logic;
      B2    : OUT    std_logic;
      B3    : OUT    std_logic;
      B4    : OUT    std_logic;
      B5    : OUT    std_logic;
      B6    : OUT    std_logic;
      B7    : OUT    std_logic
   );
   END COMPONENT;
   COMPONENT TDC
   GENERIC (
      tdc_id      : integer;
      chain       : integer;
      num_test_dt : integer
   );
   PORT (
      BNC_RES   : IN     std_logic;
      CLK       : IN     std_logic;
      EV_RES    : IN     std_logic;
      Finished  : IN     std_logic;
      GET_DATA  : IN     std_logic;
      HIT       : IN     std_logic_vector (7 DOWNTO 0);
      RESET     : IN     std_logic;
      TOKEN_IN  : IN     std_logic;
      TRIGGER   : IN     std_logic;
      DATA_RDY  : OUT    std_logic;
      DOUT      : OUT    std_logic_vector (31 DOWNTO 0);
      TOKEN_OUT : OUT    std_logic;
      error     : OUT    std_logic
   );
   END COMPONENT;


BEGIN

   -- ModuleWare code(v1.1) for instance 'I7' of 'gnd'
   GND <= '0';

   -- ModuleWare code(v1.1) for instance 'I10' of 'ppulldown'
   TDCDRYA <= 'L';

   -- ModuleWare code(v1.1) for instance 'I11' of 'ppulldown'
   TDCDRYB <= 'L';

   -- ModuleWare code(v1.1) for instance 'I12' of 'ppulldown'
   TDC_RES_A <= 'L';

   -- ModuleWare code(v1.1) for instance 'I13' of 'ppulldown'
   EV_RES_A <= 'L';

   -- ModuleWare code(v1.1) for instance 'I14' of 'ppulldown'
   BNC_RES_A <= 'L';

   -- ModuleWare code(v1.1) for instance 'I15' of 'ppulldown'
   TRIGGER_A <= 'L';

   -- ModuleWare code(v1.1) for instance 'I16' of 'ppulldown'
   TDC_RES_B <= 'L';

   -- ModuleWare code(v1.1) for instance 'I17' of 'ppulldown'
   EV_RES_B <= 'L';

   -- ModuleWare code(v1.1) for instance 'I18' of 'ppulldown'
   BNC_RES_B <= 'L';

   -- ModuleWare code(v1.1) for instance 'I19' of 'ppulldown'
   TRIGGER_B <= 'L';

   -- ModuleWare code(v1.1) for instance 'I8' of 'vdd'
   VCC <= '1';

   -- Instance port mappings.
   I20 : FCT244
      PORT MAP (
         A0    => TDCTRG,
         A1    => BNC_RES,
         A2    => EV_RES,
         A3    => TDC_RES,
         A4    => GND,
         A5    => GND,
         A6    => GND,
         A7    => GND,
         B0    => TRIGGER_A,
         B1    => BNC_RES_A,
         B2    => EV_RES_A,
         B3    => TDC_RES_A,
         B4    => OPEN,
         B5    => OPEN,
         B6    => OPEN,
         B7    => OPEN,
         NOEAB => CHAINA_EN
      );
   I21 : FCT244
      PORT MAP (
         A0    => TDCTRG,
         A1    => BNC_RES,
         A2    => EV_RES,
         A3    => TDC_RES,
         A4    => GND,
         A5    => GND,
         A6    => GND,
         A7    => GND,
         B0    => TRIGGER_B,
         B1    => BNC_RES_B,
         B2    => EV_RES_B,
         B3    => TDC_RES_B,
         B4    => OPEN,
         B5    => OPEN,
         B6    => OPEN,
         B7    => OPEN,
         NOEAB => CHAINB_EN
      );
	  
   -- chain 0
   I6 : TDC
      GENERIC MAP (
         tdc_id      => 0,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKINA,
         TOKEN_OUT => TOKOUTA1,
         HIT       => HITA(7 DOWNTO 0),
         Finished  => Finished
      );
   I9 : TDC
      GENERIC MAP (
         tdc_id      => 1,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKOUTA1,
         TOKEN_OUT => TOKOUTA2,
         HIT       => HITA(15 DOWNTO 8),
         Finished  => Finished
      );
   
   I9_1 : TDC
      GENERIC MAP (
         tdc_id      => 2,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKOUTA2,
         TOKEN_OUT => TOKOUTA2_1,
         HIT       => HITA(15 DOWNTO 8),
         Finished  => Finished
      );
	
	I9_2 : TDC
      GENERIC MAP (
         tdc_id      => 3,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKOUTA2_1,
         TOKEN_OUT => TOKOUTA2_2,
         HIT       => HITA(15 DOWNTO 8),
         Finished  => Finished
      );
	
	I9_3 : TDC
      GENERIC MAP (
         tdc_id      => 4,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKOUTA2_2,
         TOKEN_OUT => TOKOUTA2_3,
         HIT       => HITA(15 DOWNTO 8),
         Finished  => Finished
      );
	  
	I9_4 : TDC
      GENERIC MAP (
         tdc_id      => 5,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKOUTA2_3,
         TOKEN_OUT => TOKOUTA2_4,
         HIT       => HITA(15 DOWNTO 8),
         Finished  => Finished
      );
	  
	I9_5 : TDC
      GENERIC MAP (
         tdc_id      => 6,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKOUTA2_4,
         TOKEN_OUT => TOKOUTA2_5,
         HIT       => HITA(15 DOWNTO 8),
         Finished  => Finished
      );
	  
	I9_6 : TDC
      GENERIC MAP (
         tdc_id      => 7,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKOUTA2_5,
         TOKEN_OUT => TOKOUTA2_6,
         HIT       => HITA(15 DOWNTO 8),
         Finished  => Finished
      );
	  
	I9_7 : TDC
      GENERIC MAP (
         tdc_id      => 8,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKOUTA2_6,
         TOKEN_OUT => TOKOUTA2_7,
         HIT       => HITA(15 DOWNTO 8),
         Finished  => Finished
      );
	  
	I9_8 : TDC
      GENERIC MAP (
         tdc_id      => 9,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKOUTA2_7,
         TOKEN_OUT => TOKOUTA2_8,
         HIT       => HITA(15 DOWNTO 8),
         Finished  => Finished
      );
	 
	  
   I22 : TDC
      GENERIC MAP (
         tdc_id      => 10,
         chain       => 0,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_A,
         BNC_RES   => BNC_RES_A,
         EV_RES    => EV_RES_A,
         TRIGGER   => TRIGGER_A,
         GET_DATA  => TDCGDA,
         DATA_RDY  => TDCDRYA,
         error     => OPEN,
         DOUT      => TDCDA,
         TOKEN_IN  => TOKOUTA2_8,
         TOKEN_OUT => TOKOUTA,
         HIT       => HITA(23 DOWNTO 16),
         Finished  => Finished
      );
   
   -- chain 1
   I23 : TDC
      GENERIC MAP (
         tdc_id      => 0,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKINB,
         TOKEN_OUT => TOKOUTB1,
         HIT       => HITB(7 DOWNTO 0),
         Finished  => Finished
      );
   I24 : TDC
      GENERIC MAP (
         tdc_id      => 1,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKOUTB1,
         TOKEN_OUT => TOKOUTB2,
         HIT       => HITB(15 DOWNTO 8),
         Finished  => Finished
      );

   I24_1 : TDC
      GENERIC MAP (
         tdc_id      => 2,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKOUTB2,
         TOKEN_OUT => TOKOUTB2_1,
         HIT       => HITB(15 DOWNTO 8),
         Finished  => Finished
      );
	
    I24_2 : TDC
      GENERIC MAP (
         tdc_id      => 3,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKOUTB2_1,
         TOKEN_OUT => TOKOUTB2_2,
         HIT       => HITB(15 DOWNTO 8),
         Finished  => Finished
      );	
	
	I24_3 : TDC
      GENERIC MAP (
         tdc_id      => 4,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKOUTB2_2,
         TOKEN_OUT => TOKOUTB2_3,
         HIT       => HITB(15 DOWNTO 8),
         Finished  => Finished
      );
	  
	I24_4 : TDC
      GENERIC MAP (
         tdc_id      => 5,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKOUTB2_3,
         TOKEN_OUT => TOKOUTB2_4,
         HIT       => HITB(15 DOWNTO 8),
         Finished  => Finished
      );
	  
	I24_5 : TDC
      GENERIC MAP (
         tdc_id      => 6,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKOUTB2_4,
         TOKEN_OUT => TOKOUTB2_5,
         HIT       => HITB(15 DOWNTO 8),
         Finished  => Finished
      );
	  
	I24_6 : TDC
      GENERIC MAP (
         tdc_id      => 7,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKOUTB2_5,
         TOKEN_OUT => TOKOUTB2_6,
         HIT       => HITB(15 DOWNTO 8),
         Finished  => Finished
      );
	  
	I24_7 : TDC
      GENERIC MAP (
         tdc_id      => 8,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKOUTB2_6,
         TOKEN_OUT => TOKOUTB2_7,
         HIT       => HITB(15 DOWNTO 8),
         Finished  => Finished
      );
	  
	I24_8 : TDC
      GENERIC MAP (
         tdc_id      => 9,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKOUTB2_7,
         TOKEN_OUT => TOKOUTB2_8,
         HIT       => HITB(15 DOWNTO 8),
         Finished  => Finished
      );
	  
   I25 : TDC
      GENERIC MAP (
         tdc_id      => 10,
         chain       => 1,
         num_test_dt => 32
      )
      PORT MAP (
         CLK       => CLK,
         RESET     => TDC_RES_B,
         BNC_RES   => BNC_RES_B,
         EV_RES    => EV_RES_B,
         TRIGGER   => TRIGGER_B,
         GET_DATA  => TDCGDB,
         DATA_RDY  => TDCDRYB,
         error     => OPEN,
         DOUT      => TDCDB,
         TOKEN_IN  => TOKOUTB2_8,
         TOKEN_OUT => TOKOUTB,
         HIT       => HITB(23 DOWNTO 16),
         Finished  => Finished
      );

END struct;
