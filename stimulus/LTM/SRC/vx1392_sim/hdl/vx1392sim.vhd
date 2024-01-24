
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY vx1392sim IS
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
END vx1392sim;

-- Generation properties:
--   Component declarations : yes
--   Configurations         : in separate file
--                          : include view name
--   
LIBRARY ieee;
LIBRARY work;
LIBRARY STD;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;
USE STD.textio.all;
USE work.v1392pkg.all;


ARCHITECTURE struct OF vx1392sim IS

   -- Architecture declarations

   -- Internal signal declarations
   --SIGNAL A            : std_logic_vector(31 DOWNTO 1);
   SIGNAL ADLTC        : std_logic;
   SIGNAL AE_PDL       : std_logic_vector(47 DOWNTO 0);
   SIGNAL ALICLK       : std_logic;
   --SIGNAL AM           : std_logic_vector(5 DOWNTO 0);
   SIGNAL AMB          : std_logic_vector( 5 DOWNTO 0);
   SIGNAL APACLK0      : std_logic;
   --SIGNAL AS           : std_logic;
   SIGNAL ASB          : std_logic;
   SIGNAL BBSY         : std_logic;
   SIGNAL BCLR         : std_logic;
   -- SIGNAL BERR         : std_logic;
   SIGNAL BERRVME      : std_logic;
   SIGNAL BGI          : std_logic;
   SIGNAL BGO          : std_logic;
   -- SIGNAL BNCRES       : std_logic;
   SIGNAL BR           : std_logic_vector(3 DOWNTO 0);
   -- SIGNAL CLK          : std_logic;
   --SIGNAL D            : std_logic_vector(31 DOWNTO 0);
   SIGNAL DIR_CTTM     : std_logic_vector(7 DOWNTO 0);
   SIGNAL DPCLK        : std_logic_vector(7 DOWNTO 0);
   -- SIGNAL DS0          : std_logic;
   SIGNAL DS0B         : std_logic;
   -- SIGNAL DS1          : std_logic;
   SIGNAL DS1B         : std_logic;
   -- SIGNAL DTACK        : std_logic;
   -- SIGNAL EVRES        : std_logic;
   SIGNAL FCS          : std_logic;
   SIGNAL F_SCK        : std_logic;
   SIGNAL F_SI         : std_logic;
   SIGNAL F_SO         : std_logic;
   -- SIGNAL GA           : std_logic_vector(3 DOWNTO 0);
   SIGNAL GND          : std_logic;
   SIGNAL GND1         : std_logic;
   --SIGNAL IACK         : std_logic;
   SIGNAL IACKB        : std_logic;
   --SIGNAL IACKIN       : std_logic;
   SIGNAL IACKINB      : std_logic;
   SIGNAL IACKOUT      : std_logic;
   SIGNAL IACKOUTB     : std_logic;
   SIGNAL INTR1        : std_logic;
   SIGNAL INTR2        : std_logic;
   SIGNAL IRQ1         : std_logic;
   SIGNAL IRQ2         : std_logic;
   -- SIGNAL L0           : std_logic;
   -- SIGNAL L1A          : std_logic;
   -- SIGNAL L1R          : std_logic;
   -- SIGNAL L2A          : std_logic;
   -- SIGNAL L2R          : std_logic;
   SIGNAL LB           : std_logic_vector(31 DOWNTO 0);
   SIGNAL LBSP         : std_logic_vector(31 DOWNTO 0);
   SIGNAL LED          : std_logic_vector(5 DOWNTO 0);
   SIGNAL LOS          : std_logic;
   -- SIGNAL LTM_BUSY     : std_logic;
   SIGNAL LTM_DRDY_active_high     : std_logic;
   -- SIGNAL LWORD        : std_logic;
   SIGNAL LWORDB       : std_logic;
   SIGNAL MD_PDL       : std_logic;
   SIGNAL MYBERR       : std_logic;
   SIGNAL NCYC_RELOAD  : std_logic;
   SIGNAL NDTKIN       : std_logic;
   SIGNAL NOE16R       : std_logic;
   SIGNAL NOE16W       : std_logic;
   SIGNAL NOE32R       : std_logic;
   SIGNAL NOE32W       : std_logic;
   SIGNAL NOE64R       : std_logic;
   SIGNAL NOEAD        : std_logic;
   SIGNAL NOEDTK       : std_logic;
   SIGNAL NPWON        : std_logic;
   SIGNAL NSELCLK      : std_logic;
   SIGNAL OR_DEL       : std_logic_vector(47 DOWNTO 0);
   SIGNAL PSM_RES      : std_logic;
   SIGNAL PSM_SP0      : std_logic;
   SIGNAL PSM_SP1      : std_logic;
   SIGNAL PSM_SP2      : std_logic;
   SIGNAL PSM_SP3      : std_logic;
   SIGNAL PSM_SP4      : std_logic;
   SIGNAL PSM_SP5      : std_logic;
   SIGNAL PULSE_TOGGLE : std_logic;
   SIGNAL P_PDL        : std_logic_vector(7 DOWNTO 1);
   SIGNAL RSELA0       : std_logic;
   SIGNAL RSELA1       : std_logic;
   SIGNAL RSELB0       : std_logic;
   SIGNAL RSELB1       : std_logic;
   SIGNAL RSELC0       : std_logic;
   SIGNAL RSELC1       : std_logic;
   SIGNAL RSELD0       : std_logic;
   SIGNAL RSELD1       : std_logic;
   SIGNAL SCL0         : std_logic;
   SIGNAL SCL1         : std_logic;
   SIGNAL SCLK_DAC     : std_logic;
   SIGNAL SC_PDL       : std_logic;
   SIGNAL SDA0         : std_logic;
   SIGNAL SDA1         : std_logic;
   SIGNAL SDIN_DAC     : std_logic;
   SIGNAL SELCLK       : std_logic;
   SIGNAL SI_PDL       : std_logic;
   SIGNAL SPSEI        : std_logic;
   SIGNAL SPSEIB       : std_logic;
   SIGNAL SPSEO        : std_logic;
   SIGNAL SPSEOB       : std_logic;
   SIGNAL SPULSE0      : std_logic;
   SIGNAL SPULSE0B     : std_logic;
   SIGNAL SPULSE1      : std_logic;
   SIGNAL SPULSE1B     : std_logic;
   SIGNAL SPULSE2      : std_logic;
   SIGNAL SPULSE2B     : std_logic;
   SIGNAL SP_PDL       : std_logic_vector(47 DOWNTO 0);
   SIGNAL SYNC         : std_logic_vector(15 DOWNTO 0);
   --SIGNAL SYSRES       : std_logic;
   SIGNAL SYSRESB      : std_logic;
   SIGNAL StopSim      : std_logic;
   SIGNAL TST          : std_logic_vector(15 DOWNTO 0);
   SIGNAL VAD          : std_logic_vector(31 DOWNTO 1);
   SIGNAL VDB          : std_logic_vector(31 DOWNTO 0);
   SIGNAL VDD          : std_logic := 'L';
   SIGNAL VDD1         : std_logic := 'L';
   -- SIGNAL WRITE        : std_logic;
   SIGNAL WRITEB       : std_logic;
   SIGNAL nLBAS        : std_logic;
   SIGNAL nLBCLR       : std_logic;
   SIGNAL nLBCS        : std_logic;
   SIGNAL nLBLAST      : std_logic;
   SIGNAL nLBPCKE      : std_logic;
   SIGNAL nLBPCKR      : std_logic;
   SIGNAL nLBRD        : std_logic;
   SIGNAL nLBRDY       : std_logic;
   SIGNAL nLBRES       : std_logic;
   SIGNAL nLBWAIT      : std_logic;


   -- Component Declarations
   COMPONENT FLASH
   PORT (
      NCS : IN     std_logic;
      SCK : IN     std_logic;
      si  : IN     std_logic;
      RDY : OUT    std_logic;
      so  : OUT    std_logic
   );
   END COMPONENT;
   COMPONENT I2C_ADC
   GENERIC (
      stretch     : time;                                        --pull SCL low for this time-value;
      temperature : std_logic_vector(15 downto 0);
      adc_value   : std_logic_vector(15 downto 0);
      device      : string(1 to 6)
   );
   PORT (
      A0  : IN     std_logic  := 'L';
      A1  : IN     std_logic  := 'L';
      A2  : IN     std_logic  := 'L';
      SCL : INOUT  std_logic;
      SDA : INOUT  std_logic
   );
   END COMPONENT;
   -- COMPONENT OSC
   -- PORT (
      -- Stopclk : IN     std_logic;
      -- CLK     : OUT    std_logic;
      -- RESET   : OUT    std_logic
   -- );
   -- END COMPONENT;
   -- COMPONENT VME_MASTER
   -- PORT (
      -- BGI     : IN     std_logic;
      -- DTACK   : IN     std_logic;
      -- IACKIN  : IN     std_logic;
      -- AS      : OUT    std_logic;
      -- BGO     : OUT    std_logic;
      -- DS0     : OUT    std_logic;
      -- DS1     : OUT    std_logic;
      -- IACK    : OUT    std_logic;
      -- IACKOUT : OUT    std_logic;
      -- SYSRES  : OUT    std_logic;
      -- WRITE   : OUT    std_logic;
      -- A       : INOUT  std_logic_vector (31 DOWNTO 1);
      -- BBSY    : INOUT  std_logic;
      -- BCLR    : INOUT  std_logic;
      -- BERR    : INOUT  std_logic;
      -- BR      : INOUT  std_logic_vector (3 DOWNTO 0);
      -- D       : INOUT  std_logic_vector (31 DOWNTO 0);
      -- LWORD   : INOUT  std_logic;
      -- AM      : BUFFER std_logic_vector (5 DOWNTO 0)
   -- );
   -- END COMPONENT;
   COMPONENT pdlmon
   PORT (
      AE_PDL : IN     std_logic_vector (47 DOWNTO 0);
      MD_PDL : IN     std_logic;
      P_PDL  : IN     std_logic_vector (7 DOWNTO 1);
      SC_PDL : IN     std_logic;
      SI_PDL : IN     std_logic;
      SP_PDL : IN     std_logic_vector (47 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT v1392ltm
   PORT (
      ALICLK      : IN     std_logic ;
      AMB         : IN     std_logic_vector ( 5 DOWNTO 0);
      ASB         : IN     std_logic ;
      BERRVME     : IN     std_logic ;
      BNCRES      : IN     std_logic ;
      DS0B        : IN     std_logic ;
      DS1B        : IN     std_logic ;
      EVRES       : IN     std_logic ;
      F_SO        : IN     std_logic ;
      GA          : IN     std_logic_vector ( 3 DOWNTO 0);
      IACKB       : IN     std_logic ;
      IACKINB     : IN     std_logic ;
      L0          : IN     std_logic ;
      L1A         : IN     std_logic ;
      L1R         : IN     std_logic ;
      L2A         : IN     std_logic ;
      L2R         : IN     std_logic ;
      LCLK        : IN     std_logic ;
      LOS         : IN     std_logic ;
      NLBPCKE     : IN     std_logic ;
      NLBPCKR     : IN     std_logic ;
      NPWON       : IN     std_logic ;
      PSM_SP0     : IN     std_logic ;
      PSM_SP1     : IN     std_logic ;
      PSM_SP2     : IN     std_logic ;
      PSM_SP3     : IN     std_logic ;
      PSM_SP4     : IN     std_logic ;
      PSM_SP5     : IN     std_logic ;
      SPULSE0     : IN     std_logic ;
      SPULSE1     : IN     std_logic ;
      SPULSE2     : IN     std_logic ;
      SYSRESB     : IN     std_logic ;
      WRITEB      : IN     std_logic ;
      nLBRDY      : IN     std_logic ;                   -- Pilotaggio led rosso vicino a conn. TDC (su pannello)
      ADLTC       : OUT    std_logic ;
      AE_PDL      : OUT    std_logic_vector (47 DOWNTO 0);
      APACLK0     : OUT    std_logic ;
      DIR_CTTM    : OUT    std_logic_vector (7 DOWNTO 0);
      FCS         : OUT    std_logic ;
      F_SCK       : OUT    std_logic ;
      F_SI        : OUT    std_logic ;
      IACKOUTB    : OUT    std_logic ;
      INTR1       : OUT    std_logic ;
      INTR2       : OUT    std_logic ;
      LED         : OUT    std_logic_vector(5 DOWNTO 0) ;
      LTM_BUSY    : OUT    std_logic ;
      LTM_DRDY    : OUT    std_logic ;
      MD_PDL      : OUT    std_logic ;
      MYBERR      : OUT    std_logic ;
      NDTKIN      : OUT    std_logic ;
      NLBCLR      : OUT    std_logic ;
      NLBCS       : OUT    std_logic ;
      NLBRD       : OUT    std_logic ;
      NLBRES      : OUT    std_logic ;
      NLBWAIT     : OUT    std_logic ;
      NOE16R      : OUT    std_logic ;
      NOE16W      : OUT    std_logic ;
      NOE32R      : OUT    std_logic ;
      NOE32W      : OUT    std_logic ;
      NOE64R      : OUT    std_logic ;
      NOEAD       : OUT    std_logic ;
      NOEDTK      : OUT    std_logic ;                   -- Pilotaggio led verde vicino a conn. TDC (su pannello)
      NSELCLK     : OUT    std_logic ;
      PSM_RES     : OUT    std_logic ;
      P_PDL       : OUT    std_logic_vector (7 DOWNTO 1);
      RSELA0      : OUT    std_logic ;
      RSELA1      : OUT    std_logic ;
      RSELB0      : OUT    std_logic ;
      RSELB1      : OUT    std_logic ;
      RSELC0      : OUT    std_logic ;
      RSELC1      : OUT    std_logic ;
      RSELD0      : OUT    std_logic ;
      RSELD1      : OUT    std_logic ;
      SCL0        : OUT    std_logic ;
      SCL1        : OUT    std_logic ;
      SCLK_DAC    : OUT    std_logic ;
      SCLK_PDL    : OUT    std_logic ;
      SDIN_DAC    : OUT    std_logic ;
      SELCLK      : OUT    std_logic ;
      SI_PDL      : OUT    std_logic ;
      SYNC        : OUT    std_logic_vector (15 DOWNTO 0);
      TST         : OUT    std_logic_vector (15 DOWNTO 0);
      nLBAS       : OUT    std_logic ;                   -- Pilotaggio led rosso vicino a conn. TDC (su pannello)
      LB          : INOUT  std_logic_vector (31 DOWNTO 0);
      LBSP        : INOUT  std_logic_vector (31 DOWNTO 0);
      LWORDB      : INOUT  std_logic ;
      NCYC_RELOAD : INOUT  std_logic ;
      NLBLAST     : INOUT  std_logic ;
      SDA0        : INOUT  std_logic ;
      SDA1        : INOUT  std_logic ;
      SP_PDL      : INOUT  std_logic_vector (47 DOWNTO 0);
      VAD         : INOUT  std_logic_vector (31 DOWNTO 1);
      VDB         : INOUT  std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT vbuf
   PORT (
      ADLTC    : IN     std_logic ;
      AM       : IN     std_logic_vector (5 DOWNTO 0);
      AS       : IN     std_logic ;
      DS0      : IN     std_logic ;
      DS1      : IN     std_logic ;
      IACK     : IN     std_logic ;
      IACKIN   : IN     std_logic ;
      IACKOUTB : IN     std_logic ;
      INTR1    : IN     std_logic ;
      INTR2    : IN     std_logic ;
      MYBERR   : IN     std_logic ;
      NDTKIN   : IN     std_logic ;
      NOE16R   : IN     std_logic ;
      NOE16W   : IN     std_logic ;
      NOE32R   : IN     std_logic ;
      NOE32W   : IN     std_logic ;
      NOE64R   : IN     std_logic ;
      NOEAD    : IN     std_logic ;
      NOEDTK   : IN     std_logic ;
      SPSEI    : IN     std_logic ;
      SPSEOB   : IN     std_logic ;
      SPULSE0  : IN     std_logic ;
      SPULSE1  : IN     std_logic ;
      SPULSE2  : IN     std_logic ;
      SYSRES   : IN     std_logic ;
      WRITE    : IN     std_logic ;
      AMB      : OUT    std_logic_vector (5 DOWNTO 0);
      ASB      : OUT    std_logic ;
      BERR     : OUT    std_logic ;
      BERRVME  : OUT    std_logic ;
      DS0B     : OUT    std_logic ;
      DS1B     : OUT    std_logic ;
      DTACK    : OUT    std_logic ;
      IACKB    : OUT    std_logic ;
      IACKINB  : OUT    std_logic ;
      IACKOUT  : OUT    std_logic ;
      IRQ1     : OUT    std_logic ;
      IRQ2     : OUT    std_logic ;
      SPSEIB   : OUT    std_logic ;
      SPSEO    : OUT    std_logic ;
      SPULSE0B : OUT    std_logic ;
      SPULSE1B : OUT    std_logic ;
      SPULSE2B : OUT    std_logic ;
      SYSRESB  : OUT    std_logic ;
      WRITEB   : OUT    std_logic ;
      A        : INOUT  std_logic_vector (31 DOWNTO 1);
      D        : INOUT  std_logic_vector (31 DOWNTO 0);
      LWORD    : INOUT  std_logic ;
      LWORDB   : INOUT  std_logic ;
      VAD      : INOUT  std_logic_vector (31 DOWNTO 1);
      VDB      : INOUT  std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT trigger_top
   PORT (
      DPCLK         : IN     std_logic_vector (7 DOWNTO 0);
      F_SO          : IN     std_logic;
      OR_DEL        : IN     std_logic_vector (47 DOWNTO 0);
      PULSE_TOGGLE  : IN     std_logic;
      SCLK          : IN     std_logic;
      nLBAS         : IN     std_logic;
      nLBCLR        : IN     std_logic;
      nLBCS         : IN     std_logic;
      nLBLAST       : IN     std_logic;
      nLBRD         : IN     std_logic;
      nLBRES        : IN     std_logic;
      nLBWAIT       : IN     std_logic;
      CLK_CTTM      : OUT    std_logic;
      CONFIG        : OUT    std_logic;
      D_CTTM        : OUT    std_logic_vector (23 DOWNTO 0);
      FCS           : OUT    std_logic;
      F_SCK         : OUT    std_logic;
      F_SI          : OUT    std_logic;
      LTM_LOCAL_TRG : OUT    std_logic;
      RAMAD         : OUT    std_logic_vector (17 DOWNTO 0);
      SP_CTTM       : OUT    std_logic_vector ( 6 DOWNTO 0);
      TRD           : OUT    std_logic_vector ( 7 DOWNTO 0);
      TRM           : OUT    std_logic_vector (23 DOWNTO 0);
      TST           : OUT    std_logic_vector (7 DOWNTO 0);
      nCSRAM        : OUT    std_logic;
      nLBPCKE       : OUT    std_logic;
      nLBPCKR       : OUT    std_logic;
      nLBRDY        : OUT    std_logic;
      nOERAM        : OUT    std_logic;
      nWRRAM        : OUT    std_logic;
      LB            : INOUT  std_logic_vector (31 DOWNTO 0);
      LBSP          : INOUT  std_logic_vector (31 DOWNTO 0);
      RAMDT         : INOUT  std_logic_vector (47 DOWNTO 0)
   );
   END COMPONENT;


BEGIN
   -- Architecture concurrent statements
   -- HDL Embedded Text Block 1 eb1
   -- eb1 1      
   StopSim <= '0', '1' after 200 ms;
   --GA <= "1000";
   LOS <= '1';
   
   LTM_DRDY     <= not(LTM_DRDY_active_high);   -- DAV
   
   PSM_SP3 <= '1', '0' after 200 us, '1' after 1 ms;
   PSM_SP4 <= '0', '1' after 0.5 ms;
   PSM_SP5 <='0', '1' after 100 us, '0' after 200 us, '1' after 0.6 ms, '0' after 0.7 ms;


   -- ModuleWare code(v1.7) for instance 'I11' of 'buff'
   DPCLK(0) <= CLK;

   -- ModuleWare code(v1.7) for instance 'I34' of 'buff'
   ALICLK <= CLK;

   -- ModuleWare code(v1.7) for instance 'I20' of 'gnd'
   GND <= '0';

   -- ModuleWare code(v1.7) for instance 'I27' of 'gnd'
   GND1 <= '0';

   -- ModuleWare code(v1.7) for instance 'I4' of 'ppullup'
   --AS <= 'H';

   -- ModuleWare code(v1.7) for instance 'I5' of 'ppullup'
   DTACK <= 'H';

   -- ModuleWare code(v1.7) for instance 'I6' of 'ppullup'
   -- DS0 <= 'H';

   -- ModuleWare code(v1.7) for instance 'I7' of 'ppullup'
   -- DS1 <= 'H';

   -- ModuleWare code(v1.7) for instance 'I8' of 'ppullup'
   --IACK <= 'H';

   -- ModuleWare code(v1.7) for instance 'I9' of 'ppullup'
   -- WRITE <= 'H';

   -- ModuleWare code(v1.7) for instance 'I10' of 'ppullup'
   BERR <= 'H';

   -- ModuleWare code(v1.7) for instance 'I12' of 'ppullup'
   --SYSRES <= 'H';

   -- ModuleWare code(v1.7) for instance 'I13' of 'ppullup'
   SDA0 <= 'H';

   -- ModuleWare code(v1.7) for instance 'I14' of 'ppullup'
   SCL0 <= 'H';

   -- ModuleWare code(v1.7) for instance 'I15' of 'ppullup'
   SDA1 <= 'H';

   -- ModuleWare code(v1.7) for instance 'I16' of 'ppullup'
   SCL1 <= 'H';

   -- ModuleWare code(v1.7) for instance 'I22' of 'vdd'
   VDD <= '1';

   -- ModuleWare code(v1.7) for instance 'I28' of 'vdd'
   VDD1 <= '1';

   -- Instance port mappings.
   I35 : FLASH
      PORT MAP (
         NCS => FCS,
         SCK => F_SCK,
         si  => F_SI,
         so  => F_SO,
         RDY => OPEN
      );
   I18 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000000000001",
         adc_value   => "0000000100000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => GND,
         A1  => GND,
         A2  => GND,
         SCL => SCL0,
         SDA => SDA0
      );
   I19 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000000010000",
         adc_value   => "0001000000000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => GND1,
         A1  => GND1,
         A2  => GND1,
         SCL => SCL1,
         SDA => SDA1
      );
   I21 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000000000010",
         adc_value   => "0000001000000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => VDD,
         A1  => GND,
         A2  => GND,
         SCL => SCL0,
         SDA => SDA0
      );
   I23 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000000000011",
         adc_value   => "0000001100000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => GND,
         A1  => VDD,
         A2  => GND,
         SCL => SCL0,
         SDA => SDA0
      );
   I24 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000000000100",
         adc_value   => "0000010000000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => VDD,
         A1  => VDD,
         A2  => GND,
         SCL => SCL0,
         SDA => SDA0
      );
   I25 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000000000101",
         adc_value   => "0000010100000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => GND,
         A1  => GND,
         A2  => VDD,
         SCL => SCL0,
         SDA => SDA0
      );
   I26 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000000000110",
         adc_value   => "0000011000000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => VDD,
         A1  => GND,
         A2  => VDD,
         SCL => SCL0,
         SDA => SDA0
      );
   I29 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000000100000",
         adc_value   => "0010000000000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => VDD1,
         A1  => GND1,
         A2  => GND1,
         SCL => SCL1,
         SDA => SDA1
      );
   I30 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000000110000",
         adc_value   => "0011000000000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => GND1,
         A1  => VDD1,
         A2  => GND1,
         SCL => SCL1,
         SDA => SDA1
      );
   I31 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000001000000",
         adc_value   => "0100000000000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => VDD1,
         A1  => VDD1,
         A2  => GND1,
         SCL => SCL1,
         SDA => SDA1
      );
   I32 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000001010000",
         adc_value   => "0101000000000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => GND1,
         A1  => GND1,
         A2  => VDD1,
         SCL => SCL1,
         SDA => SDA1
      );
   I33 : I2C_ADC
      GENERIC MAP (
         stretch     => 1 ns,             --pull SCL low for this time-value;
         temperature => "0000000001100000",
         adc_value   => "0110000000000000",
         device      => "AD7417"
      )
      PORT MAP (
         A0  => VDD1,
         A1  => GND1,
         A2  => VDD1,
         SCL => SCL1,
         SDA => SDA1
      );
   -- I3 : OSC
      -- PORT MAP (
         -- Stopclk => StopSim,
         -- CLK     => CLK,
         -- RESET   => NPWON
      -- );
      
      process 
      begin
        NPWON <= '0';
        wait for 20 ns;
        NPWON <= '1';
      wait;
      end process;
      
   -- I0 : VME_MASTER
      -- PORT MAP (
         -- A       => A,
         -- AM      => AM,
         -- D       => D,
         -- DS0     => DS0,
         -- DS1     => DS1,
         -- AS      => AS,
         -- DTACK   => DTACK,
         -- BERR    => BERR,
         -- LWORD   => LWORD,
         -- WRITE   => WRITE,
         -- IACK    => IACK,
         -- IACKIN  => IACKIN,
         -- IACKOUT => IACKOUT,
         -- SYSRES  => SYSRES,
         -- BR      => BR,
         -- BGI     => BGI,
         -- BGO     => BGO,
         -- BBSY    => BBSY,
         -- BCLR    => BCLR
      -- );
   I36 : pdlmon
      PORT MAP (
         AE_PDL => AE_PDL,
         MD_PDL => MD_PDL,
         P_PDL  => P_PDL,
         SC_PDL => SC_PDL,
         SI_PDL => SI_PDL,
         SP_PDL => SP_PDL
      );
   I1 : v1392ltm
      PORT MAP (
         ALICLK      => ALICLK,
         AMB         => AMB,
         ASB         => ASB,
         BERRVME     => BERRVME,
         BNCRES      => BNCRES,
         DS0B        => DS0B,
         DS1B        => DS1B,
         EVRES       => EVRES,
         F_SO        => F_SO,
         GA          => GA(3 downto 0),
         IACKB       => IACKB,
         IACKINB     => IACKINB,
         L0          => L0,
         L1A         => L1A,
         L1R         => L1R,
         L2A         => L2A,
         L2R         => L2R,
         LCLK        => CLK,
         LOS         => LOS,
         NLBPCKE     => nLBPCKE,
         NLBPCKR     => nLBPCKR,
         NPWON       => NPWON,
         PSM_SP0     => PSM_SP0,
         PSM_SP1     => PSM_SP1,
         PSM_SP2     => PSM_SP2,
         PSM_SP3     => PSM_SP3,
         PSM_SP4     => PSM_SP4,
         PSM_SP5     => PSM_SP5,
         SPULSE0     => SPULSE0B,
         SPULSE1     => SPULSE1B,
         SPULSE2     => SPULSE2B,
         SYSRESB     => SYSRESB,
         WRITEB      => WRITEB,
         nLBRDY      => nLBRDY,
         ADLTC       => ADLTC,
         AE_PDL      => AE_PDL,
         APACLK0     => APACLK0,
         DIR_CTTM    => DIR_CTTM,
         FCS         => FCS,
         F_SCK       => F_SCK,
         F_SI        => F_SI,
         IACKOUTB    => IACKOUTB,
         INTR1       => INTR1,
         INTR2       => INTR2,
         LED         => LED,
         LTM_BUSY    => LTM_BUSY,
         LTM_DRDY    => LTM_DRDY_active_high,
         MD_PDL      => MD_PDL,
         MYBERR      => MYBERR,
         NDTKIN      => NDTKIN,
         NLBCLR      => nLBCLR,
         NLBCS       => nLBCS,
         NLBRD       => nLBRD,
         NLBRES      => nLBRES,
         NLBWAIT     => nLBWAIT,
         NOE16R      => NOE16R,
         NOE16W      => NOE16W,
         NOE32R      => NOE32R,
         NOE32W      => NOE32W,
         NOE64R      => NOE64R,
         NOEAD       => NOEAD,
         NOEDTK      => NOEDTK,
         NSELCLK     => NSELCLK,
         PSM_RES     => PSM_RES,
         P_PDL       => P_PDL,
         RSELA0      => RSELA0,
         RSELA1      => RSELA1,
         RSELB0      => RSELB0,
         RSELB1      => RSELB1,
         RSELC0      => RSELC0,
         RSELC1      => RSELC1,
         RSELD0      => RSELD0,
         RSELD1      => RSELD1,
         SCL0        => SCL0,
         SCL1        => SCL1,
         SCLK_DAC    => SCLK_DAC,
         SCLK_PDL    => SC_PDL,
         SDIN_DAC    => SDIN_DAC,
         SELCLK      => SELCLK,
         SI_PDL      => SI_PDL,
         SYNC        => SYNC,
         TST         => TST,
         nLBAS       => nLBAS,
         LB          => LB,
         LBSP        => LBSP,
         LWORDB      => LWORDB,
         NCYC_RELOAD => NCYC_RELOAD,
         NLBLAST     => nLBLAST,
         SDA0        => SDA0,
         SDA1        => SDA1,
         SP_PDL      => SP_PDL,
         VAD         => VAD,
         VDB         => VDB
      );
   I2 : vbuf
      PORT MAP (
         ADLTC => ADLTC,
         AM => AM,
         AS => AS,
         DS0 => DS0,
         DS1 => DS1,
         IACK => IACK,
         IACKIN => IACKIN,
         IACKOUTB => IACKOUTB,
         INTR1 => INTR1,
         INTR2 => INTR2,
         MYBERR => MYBERR,
         NDTKIN => NDTKIN,
         NOE16R => NOE16R,
         NOE16W => NOE16W,
         NOE32R => NOE32R,
         NOE32W => NOE32W,
         NOE64R => NOE64R,
         NOEAD => NOEAD,
         NOEDTK => NOEDTK,
         SPSEI => SPSEI,
         SPSEOB => SPSEOB,
         SPULSE0 => SPULSE0,
         SPULSE1 => SPULSE1,
         SPULSE2 => SPULSE2,
         SYSRES => SYSRES,
         WRITE => WRITE,
         AMB => AMB,
         ASB => ASB,
         BERR => BERR,
         BERRVME => BERRVME,
         DS0B => DS0B,
         DS1B => DS1B,
         DTACK => DTACK,
         IACKB => IACKB,
         IACKINB => IACKINB,
         IACKOUT => IACKOUT,
         IRQ1 => IRQ1,
         IRQ2 => IRQ2,
         SPSEIB => SPSEIB,
         SPSEO => SPSEO,
         SPULSE0B => SPULSE0B,
         SPULSE1B => SPULSE1B,
         SPULSE2B => SPULSE2B,
         SYSRESB => SYSRESB,
         WRITEB => WRITEB,
         A => A,
         D => D,
         LWORD => LWORD,
         LWORDB => LWORDB,
         VAD => VAD,
         VDB => VDB
      );
   I17 : trigger_top
      PORT MAP (
         DPCLK         => DPCLK,
         F_SO          => F_SO,
         OR_DEL        => OR_DEL,
         PULSE_TOGGLE  => PULSE_TOGGLE,
         SCLK          => CLK,
         nLBAS         => nLBAS,
         nLBCLR        => nLBCLR,
         nLBCS         => nLBCS,
         nLBLAST       => nLBLAST,
         nLBRD         => nLBRD,
         nLBRES        => nLBRES,
         nLBWAIT       => nLBWAIT,
         CLK_CTTM      => OPEN,
         CONFIG        => OPEN,
         D_CTTM        => OPEN,
         FCS           => OPEN,
         F_SCK         => OPEN,
         F_SI          => OPEN,
         LTM_LOCAL_TRG => OPEN,
         RAMAD         => OPEN,
         SP_CTTM       => OPEN,
         TRD           => OPEN,
         TRM           => OPEN,
         TST           => OPEN,
         nCSRAM        => OPEN,
         nLBPCKE       => nLBPCKE,
         nLBPCKR       => nLBPCKR,
         nLBRDY        => nLBRDY,
         nOERAM        => OPEN,
         nWRRAM        => OPEN,
         LB            => LB,
         LBSP          => LBSP,
         RAMDT         => OPEN
      );

END struct;
