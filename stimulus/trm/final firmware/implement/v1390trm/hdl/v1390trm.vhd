-- **************************************************************************
-- Company:         CAEN SpA - Viareggio - Italy
-- Model:           V1390 - TRM Alice TOF
-- FPGA Proj. Name: V1390trm
-- Device:          ACTEL APA750
-- Author:          Annalisa Mati
-- Date:            21/06/13
-- --------------------------------------------------------------------------
-- Module:          V1390trm
-- Description:     RTL module: TOP
-- **************************************************************************

-- ##########################################################################
-- Revision History:
-- NUOVA RELEASE 2013:
-- eliminati il componente LEADING_FLUSH
-- ##########################################################################

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY V1390trm IS
	GENERIC( 
		SIM_MODE     : boolean := FALSE     -- Enable simulation mode 
	);
   PORT( 
      AMB          : IN     std_logic_vector ( 5 DOWNTO 0);
      ASB          : IN     std_logic;
      BERRVME      : IN     std_logic;
      BNC_RESIN    : IN     std_logic;
      CHAINA_ERR   : IN     std_logic;
      CHAINB_ERR   : IN     std_logic;
      CLK          : IN     std_logic;
      COM_SER      : IN     std_logic;
      DPR          : IN     std_logic_vector (31 DOWNTO 0);
      DPR_P        : IN     std_logic;
      DS0B         : IN     std_logic;
      DS1B         : IN     std_logic;
      EF           : IN     std_logic;
      EV_RESIN     : IN     std_logic;
      F_SO         : IN     std_logic;
      GA           : IN     std_logic_vector ( 4 DOWNTO 0);
      IACKB        : IN     std_logic;
      IACKINB      : IN     std_logic;
      INT_ERRA     : IN     std_logic;
      INT_ERRB     : IN     std_logic;
      L0           : IN     std_logic;
      L1A          : IN     std_logic;
      L1R          : IN     std_logic;
      L2A          : IN     std_logic;
      L2R          : IN     std_logic;
      MROK         : IN     std_logic;
      MSERCLK      : IN     std_logic;
      MTDIA        : IN     std_logic;
      MWOK         : IN     std_logic;
      NPWON        : IN     std_logic;
      PAE          : IN     std_logic;
      PAF          : IN     std_logic;
      SYSRESB      : IN     std_logic;
      TDCDA        : IN     std_logic_vector (31 DOWNTO 0);
      TDCDB        : IN     std_logic_vector (31 DOWNTO 0);
      TDCDRYA      : IN     std_logic;
      TDCDRYB      : IN     std_logic;
      TOKOUTA      : IN     std_logic;
      TOKOUTA_BP   : IN     std_logic;
      TOKOUTB      : IN     std_logic;
      TOKOUTB_BP   : IN     std_logic;
      WRITEB       : IN     std_logic;
      ff           : IN     std_logic;
      ADE          : OUT    std_logic_vector (15 DOWNTO 0);
      ADLTC        : OUT    std_logic;
      ADO          : OUT    std_logic_vector (15 DOWNTO 0);
      BNC_RES      : OUT    std_logic;
      CHAINA_EN244 : OUT    std_logic;
      CHAINB_EN244 : OUT    std_logic;
      EV_RES       : OUT    std_logic;
      FCS          : OUT    std_logic;
      FID          : OUT    std_logic_vector (31 DOWNTO 0);
      FID_P        : OUT    std_logic;
      F_SCK        : OUT    std_logic;
      F_SI         : OUT    std_logic;
      IACKOUTB     : OUT    std_logic;
      INTR1        : OUT    std_logic;
      INTR2        : OUT    std_logic;
      LED_G        : OUT    std_logic;
      LED_R        : OUT    std_logic;
      MTDCRESA     : OUT    std_logic;
      MTDCRESB     : OUT    std_logic;
      MYBERR       : OUT    std_logic;
      NDTKIN       : OUT    std_logic;
      NLD          : OUT    std_logic;
      NMRSFIF      : OUT    std_logic;
      NOE16R       : OUT    std_logic;
      NOE16W       : OUT    std_logic;
      NOE32R       : OUT    std_logic;
      NOE32W       : OUT    std_logic;
      NOE64R       : OUT    std_logic;
      NOEAD        : OUT    std_logic;
      NOEDTK       : OUT    std_logic;
      NOELUT       : OUT    std_logic;
      NOEMIC       : OUT    std_logic;
      NOESRAME     : OUT    std_logic;
      NOESRAMO     : OUT    std_logic;
      NPRSFIF      : OUT    std_logic;
      NRDMEB       : OUT    std_logic;
      NWEN         : OUT    std_logic;
      NWRLUT       : OUT    std_logic;
      NWRSRAME     : OUT    std_logic;
      NWRSRAMO     : OUT    std_logic;
      RAMAD        : OUT    std_logic_vector (17 DOWNTO 0);
      RMIC         : OUT    std_logic;
      SCLA         : OUT    std_logic;
      SCLB         : OUT    std_logic;
      STBMIC       : OUT    std_logic;
      TDCGDA       : OUT    std_logic;
      TDCGDB       : OUT    std_logic;
      TDCTRG       : OUT    std_logic;
      TDC_RESA     : OUT    std_logic;
      TDC_RESB     : OUT    std_logic;
      TOKINA       : OUT    std_logic;
      TOKINB       : OUT    std_logic;
      TRM_BUSY     : OUT    std_logic;
      TRM_DRDY     : OUT    std_logic;
      WMIC         : OUT    std_logic;
      DTE          : INOUT  std_logic_vector (31 DOWNTO 0);
      DTO          : INOUT  std_logic_vector (31 DOWNTO 0);
      LWORDB       : INOUT  std_logic;
      RAMDT        : INOUT  std_logic_vector (13 DOWNTO 0);
      SDAA         : INOUT  std_logic;
      SDAB         : INOUT  std_logic;
      SP0          : INOUT  std_logic;
      SP1          : INOUT  std_logic;
      SP2          : INOUT  std_logic;
      SP3          : INOUT  std_logic;
      SP4          : INOUT  std_logic;
      SP5          : INOUT  std_logic;
      VAD          : INOUT  std_logic_vector (31 DOWNTO 1);
      VDB          : INOUT  std_logic_vector (31 DOWNTO 0)
   );

-- Declarations

END V1390trm ;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.v1390pkg.all;


ARCHITECTURE struct OF V1390trm IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL BNC_RES_E      : std_logic;
   SIGNAL CLEAR_STAT     : std_logic;
   SIGNAL COM_SERS       : std_logic;
   SIGNAL DTEST_FIFO     : std_logic;
   SIGNAL EVRDY          : std_logic;
   SIGNAL EVREAD         : std_logic;
   SIGNAL FBOUT          : std_logic_vector(7 DOWNTO 0);
   SIGNAL HWCLEAR        : std_logic;
   SIGNAL HWRES          : std_logic;
   SIGNAL LOAD_RES       : std_logic;
   SIGNAL PLL_LOCK       : std_logic;
   SIGNAL PULSE          : reg_pulse;
   SIGNAL RAMAD_SPI      : std_logic_vector(17 DOWNTO 0);
   SIGNAL RAMAD_VME      : std_logic_vector(17 DOWNTO 0);
   SIGNAL TDC_RES        : std_logic;
   SIGNAL TDC_RES_ERR    : std_logic;
   SIGNAL TICK           : tick_pulses;

   SIGNAL REGS : VME_REG_RECORD;  

   -- Implicit buffer signal declarations
   SIGNAL BNC_RES_internal : std_logic;
   SIGNAL EV_RES_internal  : std_logic;


   -- Component Declarations
   ------------------------------------
   COMPONENT I2C_INTERF
	GENERIC( 
		SIM_MODE     : boolean := FALSE     -- Enable simulation mode 
	);   
   PORT (
      CLK   : IN     std_logic;
      HWRES : IN     std_logic;
      PULSE : IN     reg_pulse;
      TICK  : IN     tick_pulses;
      SCLA  : OUT    std_logic;
      SCLB  : OUT    std_logic;
      REGS  : INOUT  VME_REG_RECORD;
      SDAA  : INOUT  std_logic;
      SDAB  : INOUT  std_logic;
      SP0   : INOUT  std_logic;
      SP1   : INOUT  std_logic;
      SP2   : INOUT  std_logic;
      SP3   : INOUT  std_logic;
      SP4   : INOUT  std_logic;
      SP5   : INOUT  std_logic
   );
   END COMPONENT;
   ------------------------------------
   COMPONENT RESET_MOD
   PORT (
      BNC_RESIN   : IN     std_logic;
      CLK         : IN     std_logic;
      COM_SER     : IN     std_logic;
      EV_RESIN    : IN     std_logic;
      LOAD_RES    : IN     std_logic;
      NPWON       : IN     std_logic;
      PLL_LOCK    : IN     std_logic;
      PULSE       : IN     reg_pulse;
      SYSRESB     : IN     std_logic;
      TDC_RES_ERR : IN     std_logic;
      TICK        : IN     tick_pulses;
      BNC_RES     : OUT    std_logic;
      BNC_RES_E   : OUT    std_logic;
      CLEAR_STAT  : OUT    std_logic;
      COM_SERS    : OUT    std_logic;
      EV_RES      : OUT    std_logic;
      HWCLEAR     : OUT    std_logic;
      HWRES       : OUT    std_logic;
      TDC_RES     : OUT    std_logic;
      TDC_RESA    : OUT    std_logic;
      TDC_RESB    : OUT    std_logic;
      REGS        : INOUT  VME_REG_RECORD;	  
      SP0         : INOUT  std_logic;
      SP1         : INOUT  std_logic;
      SP2         : INOUT  std_logic;
      SP3         : INOUT  std_logic;
      SP4         : INOUT  std_logic;
      SP5         : INOUT  std_logic
   );
   END COMPONENT;
   ------------------------------------
   COMPONENT ROC32
   PORT (
       CLK       : IN    std_logic; -- CLOCK
       PLL_LOCK  : OUT   std_logic;

       HWRES     : IN    std_logic;
       CLEAR_STAT: IN    std_logic; -- tiene in CLEAR il ROC
       GA        : IN    std_logic_vector (4 downto 0);

       -- Signals from/to P2
       L0        : IN    std_logic; -- level 0 trigger
       L1A       : IN    std_logic; -- level 1 trigger, accept
       L1R       : IN    std_logic; -- level 1 trigger, reject
       L2A       : IN    std_logic; -- level 2 trigger, accept
       L2R       : IN    std_logic; -- level 2 trigger, reject
       BNC_RES_E : IN    std_logic; -- arriva 2 cicli di clock prima del BNC_RES inviato su P2:
                                    -- fa uscire le catene dalla condizione di errore
       BNC_RES   : IN    std_logic; -- TDCs counters reset (to TDCs)
       TDC_RES   : IN    std_logic; -- TDCs master reset
       EV_RES    : IN    std_logic; -- TDCs event reset

       TRM_DRDY  : OUT   std_logic; -- TRM data ready = Event ready
       TRM_BUSY  : OUT   std_logic; -- TRM busy       = Mem Full

       -- Firs level SRAM signals
       -- Sram EVEN
       ADE       : OUT   std_logic_vector(15 downto 0); -- SRAM address
       DTE       : INOUT std_logic_vector(31 downto 0); -- SRAM data
       NWRSRAME  : OUT   std_logic; -- Write enable
       NOESRAME  : OUT   std_logic; -- Output enable
       -- Sram ODD
       ADO       : OUT   std_logic_vector(15 downto 0); -- SRAM address
       DTO       : INOUT std_logic_vector(31 downto 0); -- SRAM data
       NWRSRAMO  : OUT   std_logic; -- Write enable
       NOESRAMO  : OUT   std_logic; -- Output enable


       -- Second level FIFO signals
       FID       : OUT   std_logic_vector(31 downto 0); -- Data input
       FID_P     : OUT   std_logic; -- Parity bit (not used)
       NWEN      : OUT   std_logic; -- Write enable
       NLD       : OUT   std_logic; -- Load
       NPRSFIF   : OUT   std_logic; -- Partial reset
       NMRSFIF   : OUT   std_logic; -- Master reset
       PAF       : IN    std_logic;

       EVRDY     : OUT   std_logic; -- almeno un evento pronto nel MEB
       EVREAD    : IN    std_logic; -- segnala che è stato riletto un evento dal MEB

       DTEST_FIFO: OUT   std_logic; -- segnala che è stato scritto un dato di test nella FIFO

       -- Compensation SRAM signals
       RAMAD     : OUT   std_logic_vector(17 downto 0); -- LUT address
       RAMDT     : IN    std_logic_vector(13 downto 0); -- LUT data

       RAMAD_SPI : IN    std_logic_vector(17 downto 0); -- LUT address from SPI interf.
       RAMAD_VME : IN    std_logic_vector(17 downto 0); -- LUT address from VME interf.

       LOAD_RES  : IN    std_logic;

       -- TDC signals
       TDCTRG    : OUT   std_logic; -- TDCs trigger
       -- chain A
       CHAINA_EN244 : OUT   std_logic; -- TDCs chain A enable
       TDCDA     : IN    std_logic_vector (31 downto 0); -- TDC Data
       TDCDRYA   : IN    std_logic; -- TDCs data ready
       TDCGDA    : OUT   std_logic; -- TDCs get data
       TOKINA    : OUT   std_logic; -- TDCs Token input
       TOKOUTA   : IN    std_logic; -- TDCs Token output
       TOKOUTA_BP: IN    std_logic; -- TDCs Token output Bypass
       INT_ERRA  : IN    std_logic; -- Chain A error (from I2C)
       CHAINA_ERR: IN    std_logic; -- Chain A error (from uC)
       -- chain B
       CHAINB_EN244 : OUT   std_logic; -- TDCs chain B enable
       TDCDB     : IN    std_logic_vector (31 downto 0); -- TDC Data
       TDCDRYB   : IN    std_logic; -- TDCs data ready
       TDCGDB    : OUT   std_logic; -- TDCs get data
       TOKINB    : OUT   std_logic; -- TDCs Token input
       TOKOUTB   : IN    std_logic; -- TDCs Token output
       TOKOUTB_BP: IN    std_logic; -- TDCs Token output Bypass
       INT_ERRB  : IN    std_logic; -- Chain B error (from I2C)
       CHAINB_ERR: IN    std_logic; -- Chain B error (from uC)

       TDC_RES_ERR: OUT std_logic; -- TDC_RES che deve essere dato quando le catene escono dall'errore

       -- MICRO signals
       COM_SERS  : IN    std_logic; -- COM_SER sincronizzato (in RESET_MOD)
       MSERCLK   : IN    std_logic; -- serial communication with the MICRO,
       MTDIA     : IN    std_logic; -- (to know TDC progr.)

       RMIC      : OUT   std_logic; -- HS signals for VME accesses
       MROK      : IN    std_logic;
       WMIC      : OUT   std_logic;
       MWOK      : IN    std_logic;

       MTDCRESA  : OUT   std_logic; -- avverte il uC che c'è stato un timout per TOKOUTA
       MTDCRESB  : OUT   std_logic; -- avverte il uC che c'è stato un timout per TOKOUTB

       -- SPARE
       SP0       : INOUT std_logic;
       SP1       : INOUT std_logic;
       SP2       : INOUT std_logic;
       SP3       : INOUT std_logic;
       SP4       : INOUT std_logic;
       SP5       : INOUT std_logic;

       REGS      : INOUT VME_REG_RECORD;
       PULSE     : IN    reg_pulse;
       TICK      : IN    tick_pulses
       );
   END COMPONENT;
   ------------------------------------
   COMPONENT SPI_INTERF
   	GENERIC( 
		SIM_MODE     : boolean := FALSE     -- Enable simulation mode 
	);
   PORT (
      CLK       : IN     std_logic;
      F_SO      : IN     std_logic;
      HWRES     : IN     std_logic;
      PULSE     : IN     reg_pulse;
      FBOUT     : OUT    std_logic_vector (7 DOWNTO 0);
      FCS       : OUT    std_logic;
      F_SCK     : OUT    std_logic;
      F_SI      : OUT    std_logic;
      LOAD_RES  : OUT    std_logic;
      NOELUT    : OUT    std_logic;
      NWRLUT    : OUT    std_logic;
      RAMAD_SPI : OUT    std_logic_vector (17 DOWNTO 0);
      RAMDT_SPI : OUT    std_logic_vector (13 DOWNTO 0);
      REGS      : INOUT  VME_REG_RECORD;	  
      SP0       : INOUT  std_logic;
      SP1       : INOUT  std_logic;
      SP2       : INOUT  std_logic;
      SP3       : INOUT  std_logic;
      SP4       : INOUT  std_logic;
      SP5       : INOUT  std_logic
   );
   END COMPONENT;
   ------------------------------------
   COMPONENT VINTERF
   PORT (
      AMB        : IN     std_logic_vector ( 5 DOWNTO 0);
      ASB        : IN     std_logic;
      BERRVME    : IN     std_logic;
      CLEAR_STAT : IN     std_logic;
      CLK        : IN     std_logic;
      DPR        : IN     std_logic_vector (31 DOWNTO 0);
      DPR_P      : IN     std_logic;
      DS0B       : IN     std_logic;
      DS1B       : IN     std_logic;
      DTEST_FIFO : IN     std_logic;
      EF         : IN     std_logic;
      EVRDY      : IN     std_logic;
      FBOUT      : IN     std_logic_vector (7 DOWNTO 0);
      GA         : IN     std_logic_vector ( 4 DOWNTO 0);
      HWCLEAR    : IN     std_logic;
      HWRES      : IN     std_logic;
      IACKB      : IN     std_logic;
      IACKINB    : IN     std_logic;
      PAE        : IN     std_logic;
      PAF        : IN     std_logic;
      RAMDT      : IN     std_logic_vector (13 DOWNTO 0);
      WRITEB     : IN     std_logic;
      ff         : IN     std_logic;
      ADLTC      : OUT    std_logic;
      EVREAD     : OUT    std_logic;
      IACKOUTB   : OUT    std_logic;
      INTR1      : OUT    std_logic;
      INTR2      : OUT    std_logic;
      LED_G      : OUT    std_logic;
      LED_R      : OUT    std_logic;
      MYBERR     : OUT    std_logic;
      NDTKIN     : OUT    std_logic;
      NOE16R     : OUT    std_logic;
      NOE16W     : OUT    std_logic;
      NOE32R     : OUT    std_logic;
      NOE32W     : OUT    std_logic;
      NOE64R     : OUT    std_logic;
      NOEAD      : OUT    std_logic;
      NOEDTK     : OUT    std_logic;
      NOEMIC     : OUT    std_logic;
      NRDMEB     : OUT    std_logic;
      PULSE      : OUT    reg_pulse;
      RAMAD_VME  : OUT    std_logic_vector (17 DOWNTO 0);
      STBMIC     : OUT    std_logic;
      TICK       : OUT    tick_pulses;
      LWORDB     : INOUT  std_logic;
      REGS       : INOUT  VME_REG_RECORD;	  
      SP0        : INOUT  std_logic;
      SP1        : INOUT  std_logic;
      SP2        : INOUT  std_logic;
      SP3        : INOUT  std_logic;
      SP4        : INOUT  std_logic;
      SP5        : INOUT  std_logic;
      VAD        : INOUT  std_logic_vector (31 DOWNTO 1);
      VDB        : INOUT  std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;


BEGIN

   -- Instance port mappings.
   U_I2C_INTERF : I2C_INTERF
   	GENERIC MAP( 
		SIM_MODE     => SIM_MODE     -- Enable simulation mode 
	)
      PORT MAP (
         CLK   => CLK,
         HWRES => HWRES,
         SDAA  => SDAA,
         SCLA  => SCLA,
         SDAB  => SDAB,
         SCLB  => SCLB,
         REGS  => REGS,
         PULSE => PULSE,
         TICK  => TICK,
         SP0   => SP0,
         SP1   => SP1,
         SP2   => SP2,
         SP3   => SP3,
         SP4   => SP4,
         SP5   => SP5
      );
   U_RESET_MOD : RESET_MOD
      PORT MAP (
         CLK         => CLK,
         NPWON       => NPWON,
         SYSRESB     => SYSRESB,
         COM_SER     => COM_SER,
         COM_SERS    => COM_SERS,
         LOAD_RES    => LOAD_RES,
         PLL_LOCK    => PLL_LOCK,
         HWRES       => HWRES,
         CLEAR_STAT  => CLEAR_STAT,
         HWCLEAR     => HWCLEAR,
         BNC_RESIN   => BNC_RESIN,
         EV_RESIN    => EV_RESIN,
         BNC_RES     => BNC_RES_internal,
         BNC_RES_E   => BNC_RES_E,
         EV_RES      => EV_RES_internal,
         TDC_RES     => TDC_RES,
         TDC_RESA    => TDC_RESA,
         TDC_RESB    => TDC_RESB,
         TDC_RES_ERR => TDC_RES_ERR,
         SP0         => SP0,
         SP1         => SP1,
         SP2         => SP2,
         SP3         => SP3,
         SP4         => SP4,
         SP5         => SP5,
         REGS        => REGS,
         PULSE       => PULSE,
         TICK        => TICK
      );
   U_ROC32 : ROC32
      PORT MAP (
         CLK            => CLK,
         PLL_LOCK       => PLL_LOCK,
         HWRES          => HWRES,
         CLEAR_STAT     => CLEAR_STAT,
         GA             => GA,
         L0             => L0,
         L1A            => L1A,
         L1R            => L1R,
         L2A            => L2A,
         L2R            => L2R,
         BNC_RES_E      => BNC_RES_E,
         BNC_RES        => BNC_RES_internal,
         TDC_RES        => TDC_RES,
         EV_RES         => EV_RES_internal,
         TRM_DRDY       => TRM_DRDY,
         TRM_BUSY       => TRM_BUSY,
         ADE            => ADE,
         DTE            => DTE,
         NWRSRAME       => NWRSRAME,
         NOESRAME       => NOESRAME,
         ADO            => ADO,
         DTO            => DTO,
         NWRSRAMO       => NWRSRAMO,
         NOESRAMO       => NOESRAMO,
         FID            => FID,
         FID_P          => FID_P,
         NWEN           => NWEN,
         NLD            => NLD,
         NPRSFIF        => NPRSFIF,
         NMRSFIF        => NMRSFIF,
         PAF            => PAF,
         EVRDY          => EVRDY,
         EVREAD         => EVREAD,
         DTEST_FIFO     => DTEST_FIFO,
         RAMAD          => RAMAD,
         RAMDT          => RAMDT,
         RAMAD_SPI      => RAMAD_SPI,
         RAMAD_VME      => RAMAD_VME,
         LOAD_RES       => LOAD_RES,
         TDCTRG         => TDCTRG,
         CHAINA_EN244   => CHAINA_EN244,
         TDCDA          => TDCDA,
         TDCDRYA        => TDCDRYA,
         TDCGDA         => TDCGDA,
         TOKINA         => TOKINA,
         TOKOUTA        => TOKOUTA,
         TOKOUTA_BP     => TOKOUTA_BP,
         INT_ERRA       => INT_ERRA,
         CHAINA_ERR     => CHAINA_ERR,
         CHAINB_EN244   => CHAINB_EN244,
         TDCDB          => TDCDB,
         TDCDRYB        => TDCDRYB,
         TDCGDB         => TDCGDB,
         TOKINB         => TOKINB,
         TOKOUTB        => TOKOUTB,
         TOKOUTB_BP     => TOKOUTB_BP,
         INT_ERRB       => INT_ERRB,
         CHAINB_ERR     => CHAINB_ERR,
         TDC_RES_ERR    => TDC_RES_ERR,
         COM_SERS       => COM_SERS,
         MSERCLK        => MSERCLK,
         MTDIA          => MTDIA,
         RMIC           => RMIC,
         MROK           => MROK,
         WMIC           => WMIC,
         MWOK           => MWOK,
         MTDCRESA       => MTDCRESA,
         MTDCRESB       => MTDCRESB,
         SP0            => SP0,
         SP1            => SP1,
         SP2            => SP2,
         SP3            => SP3,
         SP4            => SP4,
         SP5            => SP5,
         REGS           => REGS,
         PULSE          => PULSE,
         TICK           => TICK
      );
   U_SPI_INTERF : SPI_INTERF
   	GENERIC MAP( 
		SIM_MODE     => SIM_MODE     -- Enable simulation mode 
	)
      PORT MAP (
         CLK       => CLK,
         HWRES     => HWRES,
         FCS       => FCS,
         F_SI      => F_SI,
         F_SO      => F_SO,
         F_SCK     => F_SCK,
         FBOUT     => FBOUT,
         RAMAD_SPI => RAMAD_SPI,
         RAMDT_SPI => RAMDT,
         NWRLUT    => NWRLUT,
         NOELUT    => NOELUT,
         LOAD_RES  => LOAD_RES,
         REGS      => REGS,
         PULSE     => PULSE,
         SP0       => SP0,
         SP1       => SP1,
         SP2       => SP2,
         SP3       => SP3,
         SP4       => SP4,
         SP5       => SP5
      );
   U_VINTERF : VINTERF
      PORT MAP (
         CLK        => CLK,
         HWRES      => HWRES,
         CLEAR_STAT => CLEAR_STAT,
         HWCLEAR    => HWCLEAR,
         ASB        => ASB,
         DS0B       => DS0B,
         DS1B       => DS1B,
         WRITEB     => WRITEB,
         IACKB      => IACKB,
         IACKINB    => IACKINB,
         IACKOUTB   => IACKOUTB,
         NDTKIN     => NDTKIN,
         NOEDTK     => NOEDTK,
         BERRVME    => BERRVME,
         MYBERR     => MYBERR,
         LWORDB     => LWORDB,
         VAD        => VAD,
         VDB        => VDB,
         AMB        => AMB,
         GA         => GA,
         INTR1      => INTR1,
         INTR2      => INTR2,
         ADLTC      => ADLTC,
         NOE16R     => NOE16R,
         NOE16W     => NOE16W,
         NOE32R     => NOE32R,
         NOE32W     => NOE32W,
         NOE64R     => NOE64R,
         NOEAD      => NOEAD,
         NOEMIC     => NOEMIC,
         STBMIC     => STBMIC,
         DPR        => DPR,
         DPR_P      => DPR_P,
         NRDMEB     => NRDMEB,
         PAF        => PAF,
         PAE        => PAE,
         EF         => EF,
         ff         => ff,
         RAMDT      => RAMDT,
         RAMAD_VME  => RAMAD_VME,
         EVRDY      => EVRDY,
         EVREAD     => EVREAD,
         DTEST_FIFO => DTEST_FIFO,
         FBOUT      => FBOUT,
         SP0        => SP0,
         SP1        => SP1,
         SP2        => SP2,
         SP3        => SP3,
         SP4        => SP4,
         SP5        => SP5,
         LED_R      => LED_R,
         LED_G      => LED_G,
         REGS       => REGS,
         PULSE      => PULSE,
         TICK       => TICK
      );

   -- Implicit buffered output assignments
   BNC_RES <= BNC_RES_internal;
   EV_RES  <= EV_RES_internal;

END struct;