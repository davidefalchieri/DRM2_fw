
LIBRARY ieee;
	USE ieee.std_logic_1164.all;
	USE ieee.std_logic_arith.all;

ENTITY V1390sim IS
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
END V1390sim ;

LIBRARY ieee;
	USE ieee.std_logic_1164.all;
	USE ieee.std_logic_arith.all;
	USE ieee.std_logic_unsigned.all;
LIBRARY std;
	USE std.textio.all;


ARCHITECTURE struct OF V1390sim IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL ADE         : std_logic_vector(15 DOWNTO 0);
   SIGNAL ADLTC       : std_logic;
   SIGNAL ADO         : std_logic_vector(15 DOWNTO 0);
   SIGNAL BA          : std_logic_vector(3 DOWNTO 0);
   SIGNAL BERRVME     : std_logic;
   SIGNAL BNC_RES     : std_logic;
   SIGNAL CHAINA_EN   : std_logic;
   SIGNAL CHAINA_ERR  : std_logic;
   SIGNAL CHAINB_EN   : std_logic;
   SIGNAL CHAINB_ERR  : std_logic;
   SIGNAL COM_SER     : std_logic;
   SIGNAL DPR         : std_logic_vector(31 DOWNTO 0);
   SIGNAL DPR_P       : std_logic;
   SIGNAL DTE         : std_logic_vector(31 DOWNTO 0);
   SIGNAL DTO         : std_logic_vector(31 DOWNTO 0);
   SIGNAL EF          : std_logic;
   SIGNAL EV_RES      : std_logic;
   SIGNAL FCS         : std_logic;
   SIGNAL FID         : std_logic_vector(31 DOWNTO 0);
   SIGNAL FID_P       : std_logic;
   SIGNAL F_SCK       : std_logic;
   SIGNAL F_SI        : std_logic;
   SIGNAL F_SO        : std_logic;
   SIGNAL Finished    : std_logic;
   SIGNAL Finished1   : std_logic;
   SIGNAL GND         : std_logic;
   SIGNAL HITA        : std_logic_vector(23 DOWNTO 0);
   SIGNAL HITB        : std_logic_vector(23 DOWNTO 0);
   SIGNAL IACKOUTB    : std_logic;
   SIGNAL INTR        : std_logic_vector(7 DOWNTO 1);
   SIGNAL INT_ERRA    : std_logic;
   SIGNAL INT_ERRB    : std_logic;
   SIGNAL LED_G       : std_logic;
   SIGNAL LED_R       : std_logic;
   SIGNAL MROK        : std_logic;
   SIGNAL MSERCLK     : std_logic;
   SIGNAL MTDCRESA    : std_logic;
   SIGNAL MTDCRESB    : std_logic;
   SIGNAL MTDIA       : std_logic;
   SIGNAL MWOK        : std_logic;
   SIGNAL MYBERR      : std_logic;
   SIGNAL NDTKIN      : std_logic;
   SIGNAL NLD         : std_logic;
   SIGNAL NMRSFIF     : std_logic;
   SIGNAL NOE16R      : std_logic;
   SIGNAL NOE16W      : std_logic;
   SIGNAL NOE32R      : std_logic;
   SIGNAL NOE32W      : std_logic;
   SIGNAL NOE64R      : std_logic;
   SIGNAL NOEAD       : std_logic;
   SIGNAL NOEDTK      : std_logic;
   SIGNAL NOELUT      : std_logic;
   SIGNAL NOEMIC      : std_logic;
   SIGNAL NOESRAME    : std_logic;
   SIGNAL NOESRAMO    : std_logic;
   SIGNAL NPRSFIF     : std_logic;
   SIGNAL NPWON       : std_logic;
   SIGNAL NRDMEB      : std_logic;
   SIGNAL NWEN        : std_logic;
   SIGNAL NWRLUT      : std_logic;
   SIGNAL NWRSRAME    : std_logic;
   SIGNAL NWRSRAMO    : std_logic;
   SIGNAL PAE         : std_logic;
   SIGNAL PAF         : std_logic;
   SIGNAL RAMAD       : std_logic_vector(17 DOWNTO 0);
   SIGNAL RAMDT       : std_logic_vector(15 DOWNTO 0);
   SIGNAL RDY         : std_logic;
   SIGNAL RMIC        : std_logic;
   SIGNAL SCLA        : std_logic;
   SIGNAL SCLB        : std_logic;
   SIGNAL SDAA        : std_logic;
   SIGNAL SDAB        : std_logic;
   SIGNAL SP0         : std_logic;
   SIGNAL SP1         : std_logic;
   SIGNAL SP2         : std_logic;
   SIGNAL SP3         : std_logic;
   SIGNAL SP4         : std_logic;
   SIGNAL SP5         : std_logic;
   SIGNAL STBMIC      : std_logic;
   SIGNAL TDCDA       : std_logic_vector(31 DOWNTO 0);
   SIGNAL TDCDB       : std_logic_vector(31 DOWNTO 0);
   SIGNAL TDCDRYA     : std_logic;
   SIGNAL TDCDRYB     : std_logic;
   SIGNAL TDCGDA      : std_logic;
   SIGNAL TDCGDB      : std_logic;
   SIGNAL TDCTRG      : std_logic;
   SIGNAL TDC_RESA    : std_logic;
   SIGNAL TDC_RESB    : std_logic;
   SIGNAL TOKINA      : std_logic;
   SIGNAL TOKINB      : std_logic;
   SIGNAL TOKOUTA     : std_logic;
   SIGNAL TOKOUTA_BP  : std_logic;
   SIGNAL TOKOUTB     : std_logic;
   SIGNAL TOKOUTB_BP  : std_logic;
   SIGNAL WMIC        : std_logic;
   SIGNAL dout        : std_logic_vector(18 DOWNTO 0);
   SIGNAL ff          : std_logic;
   signal TRM_DRDY    : std_logic;


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

   COMPONENT MICRO
   PORT (
      Finished   : IN     std_logic ;
      MRES       : IN     std_logic ;
      NOEMIC     : IN     std_logic ;
      RMIC       : IN     std_logic ;
      STBMIC     : IN     std_logic ;
      WMIC       : IN     std_logic ;
      CHAINA_ERR : OUT    std_logic ;
      CHAINB_ERR : OUT    std_logic ;
      COM_SER    : OUT    std_logic ;
      INT_ERRA   : OUT    std_logic ;
      INT_ERRB   : OUT    std_logic ;
      MROK       : OUT    std_logic ;
      MSERCLK    : OUT    std_logic ;
      MTDI       : OUT    std_logic ;
      MWOK       : OUT    std_logic ;
      VDB        : INOUT  std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT SRAM
   GENERIC (
      DEPTH : integer
   );
   PORT (
      NOERAM : IN     std_logic;
      NWRAM  : IN     std_logic;
      RAMAD  : IN     std_logic_vector;
      RAMDT  : INOUT  std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;
   COMPONENT SYNCFIFO
   PORT (
      DIN  : IN     std_logic_vector (31 DOWNTO 0);
      NLD  : IN     std_logic;
      NOE  : IN     std_logic;
      NREN : IN     std_logic;
      NRES : IN     std_logic;
      NWEN : IN     std_logic;
      RCLK : IN     std_logic;
      WCLK : IN     std_logic;
      DOUT : OUT    std_logic_vector (31 DOWNTO 0);
      EF   : OUT    std_logic;
      PAE  : OUT    std_logic;
      PAF  : OUT    std_logic;
      ff   : OUT    std_logic
   );
   END COMPONENT;
   COMPONENT TDCchaines
   generic	
		(
		hptc_in_sim : IN integer
		);
   PORT (
      BNC_RES    : IN     std_logic ;
      CHAINA_EN  : IN     std_logic ;
      CHAINB_EN  : IN     std_logic ;
      CLK        : IN     std_logic ;
      EV_RES     : IN     std_logic ;
      Finished   : IN     std_logic ;
      HITA       : IN     std_logic_vector (23 DOWNTO 0);
      HITB       : IN     std_logic_vector (23 DOWNTO 0);
      TDCGDA     : IN     std_logic ;
      TDCGDB     : IN     std_logic ;
      TDCTRG     : IN     std_logic ;
      TDC_RES    : IN     std_logic ;
      TOKINA     : IN     std_logic ;
      TOKINB     : IN     std_logic ;
      TDCDA      : OUT    std_logic_vector (31 DOWNTO 0);
      TDCDB      : OUT    std_logic_vector (31 DOWNTO 0);
      TDCDRYA    : OUT    std_logic ;
      TDCDRYB    : OUT    std_logic ;
      TOKOUTA    : OUT    std_logic ;
      TOKOUTA_BP : OUT    std_logic ;
      TOKOUTB    : OUT    std_logic ;
      TOKOUTB_BP : OUT    std_logic 
   );
   END COMPONENT;
   
   COMPONENT V1390trm
	GENERIC( 
		SIM_MODE     : boolean := FALSE     -- Enable simulation mode 
	);   
   PORT (
      AMB          : IN     std_logic_vector ( 5 DOWNTO 0);
      ASB          : IN     std_logic ;
      BERRVME      : IN     std_logic ;
      BNC_RESIN    : IN     std_logic ;
      CHAINA_ERR   : IN     std_logic ;
      CHAINB_ERR   : IN     std_logic ;
      CLK          : IN     std_logic ;
      COM_SER      : IN     std_logic ;
      DPR          : IN     std_logic_vector (31 DOWNTO 0);
      DPR_P        : IN     std_logic ;
      DS0B         : IN     std_logic ;
      DS1B         : IN     std_logic ;
      EF           : IN     std_logic ;
      EV_RESIN     : IN     std_logic ;
      F_SO         : IN     std_logic ;
      GA           : IN     std_logic_vector ( 4 DOWNTO 0);
      IACKB        : IN     std_logic ;
      IACKINB      : IN     std_logic ;
      INT_ERRA     : IN     std_logic ;
      INT_ERRB     : IN     std_logic ;
      L0           : IN     std_logic ;
      L1A          : IN     std_logic ;
      L1R          : IN     std_logic ;
      L2A          : IN     std_logic ;
      L2R          : IN     std_logic ;
      MROK         : IN     std_logic ;
      MSERCLK      : IN     std_logic ;
      MTDIA        : IN     std_logic ;
      MWOK         : IN     std_logic ;
      NPWON        : IN     std_logic ;
      PAE          : IN     std_logic ;
      PAF          : IN     std_logic ;
      SYSRESB      : IN     std_logic ;
      TDCDA        : IN     std_logic_vector (31 DOWNTO 0);
      TDCDB        : IN     std_logic_vector (31 DOWNTO 0);
      TDCDRYA      : IN     std_logic ;
      TDCDRYB      : IN     std_logic ;
      TOKOUTA      : IN     std_logic ;
      TOKOUTA_BP   : IN     std_logic ;
      TOKOUTB      : IN     std_logic ;
      TOKOUTB_BP   : IN     std_logic ;
      WRITEB       : IN     std_logic ;
      ff           : IN     std_logic ;
      ADE          : OUT    std_logic_vector (15 DOWNTO 0);
      ADLTC        : OUT    std_logic ;
      ADO          : OUT    std_logic_vector (15 DOWNTO 0);
      BNC_RES      : OUT    std_logic ;
      CHAINA_EN244 : OUT    std_logic ;
      CHAINB_EN244 : OUT    std_logic ;
      EV_RES       : OUT    std_logic ;
      FCS          : OUT    std_logic ;
      FID          : OUT    std_logic_vector (31 DOWNTO 0);
      FID_P        : OUT    std_logic ;
      F_SCK        : OUT    std_logic ;
      F_SI         : OUT    std_logic ;
      IACKOUTB     : OUT    std_logic ;
      INTR1        : OUT    std_logic ;
      INTR2        : OUT    std_logic ;
      LED_G        : OUT    std_logic ;
      LED_R        : OUT    std_logic ;
      MTDCRESA     : OUT    std_logic ;
      MTDCRESB     : OUT    std_logic ;
      MYBERR       : OUT    std_logic ;
      NDTKIN       : OUT    std_logic ;
      NLD          : OUT    std_logic ;
      NMRSFIF      : OUT    std_logic ;
      NOE16R       : OUT    std_logic ;
      NOE16W       : OUT    std_logic ;
      NOE32R       : OUT    std_logic ;
      NOE32W       : OUT    std_logic ;
      NOE64R       : OUT    std_logic ;
      NOEAD        : OUT    std_logic ;
      NOEDTK       : OUT    std_logic ;
      NOELUT       : OUT    std_logic ;
      NOEMIC       : OUT    std_logic ;
      NOESRAME     : OUT    std_logic ;
      NOESRAMO     : OUT    std_logic ;
      NPRSFIF      : OUT    std_logic ;
      NRDMEB       : OUT    std_logic ;
      NWEN         : OUT    std_logic ;
      NWRLUT       : OUT    std_logic ;
      NWRSRAME     : OUT    std_logic ;
      NWRSRAMO     : OUT    std_logic ;
      RAMAD        : OUT    std_logic_vector (17 DOWNTO 0);
      RMIC         : OUT    std_logic ;
      SCLA         : OUT    std_logic ;
      SCLB         : OUT    std_logic ;
      STBMIC       : OUT    std_logic ;
      TDCGDA       : OUT    std_logic ;
      TDCGDB       : OUT    std_logic ;
      TDCTRG       : OUT    std_logic ;
      TDC_RESA     : OUT    std_logic ;
      TDC_RESB     : OUT    std_logic ;
      TOKINA       : OUT    std_logic ;
      TOKINB       : OUT    std_logic ;
      TRM_BUSY     : OUT    std_logic ;
      TRM_DRDY     : OUT    std_logic ;
      WMIC         : OUT    std_logic ;
      DTE          : INOUT  std_logic_vector (31 DOWNTO 0);
      DTO          : INOUT  std_logic_vector (31 DOWNTO 0);
      LWORDB       : INOUT  std_logic ;
      RAMDT        : INOUT  std_logic_vector (13 DOWNTO 0);
      SDAA         : INOUT  std_logic ;
      SDAB         : INOUT  std_logic ;
      SP0          : INOUT  std_logic ;
      SP1          : INOUT  std_logic ;
      SP2          : INOUT  std_logic ;
      SP3          : INOUT  std_logic ;
      SP4          : INOUT  std_logic ;
      SP5          : INOUT  std_logic ;
      VAD          : INOUT  std_logic_vector (31 DOWNTO 1);
      VDB          : INOUT  std_logic_vector (31 DOWNTO 0)
   );
   END COMPONENT;
   
   COMPONENT VME
   PORT(
      CLK      : IN    std_logic;  -- la DRM è sincrona con la TRM
   
      ADLTC    : IN     std_logic;
      IACKOUTB : IN     std_logic;
      INTR     : IN     std_logic_vector (7 DOWNTO 1);
	  DTACK    : OUT    std_logic;
      MYBERR   : IN     std_logic;
      NDTKIN   : IN     std_logic;
      NOE16R   : IN     std_logic;
      NOE16W   : IN     std_logic;
      NOE32R   : IN     std_logic;
      NOE32W   : IN     std_logic;
      NOE64R   : IN     std_logic;
      NOEAD    : IN     std_logic;
      NOEDTK   : IN     std_logic;
      BA       : OUT    std_logic_vector (3 DOWNTO 0);
      BERRVME  : OUT    std_logic;
      Finished : OUT    std_logic;
      LWORDB   : INOUT  std_logic;
      VAD      : INOUT  std_logic_vector (31 DOWNTO 1);
      VDB      : INOUT  std_logic_vector (31 DOWNTO 0)
	);
   END COMPONENT;


BEGIN

	BERR	<= BERRVME;			-- DAV
	
	DRDY	<= not(TRM_DRDY);	-- DAV
	

   process begin
    NPWON <= '0';
    wait for 20 ns;
    NPWON <= '1';
  wait;
  end process;

   -- ModuleWare code(v1.1) for instance 'I15' of 'and'
   Finished <= Finished1;

   -- ModuleWare code(v1.1) for instance 'I7' of 'gnd'
   GND <= '0';

   -- ModuleWare code(v1.1) for instance 'I8' of 'merge'
   dout <= GND & RAMAD;

   -- ModuleWare code(v1.1) for instance 'I16' of 'ppullup'
   SCLA <= 'H';

   -- ModuleWare code(v1.1) for instance 'I17' of 'ppullup'
   SDAA <= 'H';

   -- ModuleWare code(v1.1) for instance 'I18' of 'ppullup'
   SCLB <= 'H';

   -- ModuleWare code(v1.1) for instance 'I19' of 'ppullup'
   SDAB <= 'H';

   -- Instance port mappings.
   I5 : FLASH
      PORT MAP (
         NCS => FCS,
         SCK => F_SCK,
         si  => F_SI,
         so  => F_SO,
         RDY => RDY
      );

   I4 : MICRO
      PORT MAP (
         Finished   => Finished,
         MRES       => NPWON,
         NOEMIC     => NOEMIC,
         RMIC       => RMIC,
         STBMIC     => STBMIC,
         WMIC       => WMIC,
         CHAINA_ERR => CHAINA_ERR,
         CHAINB_ERR => CHAINB_ERR,
         COM_SER    => COM_SER,
         INT_ERRA   => INT_ERRA,
         INT_ERRB   => INT_ERRB,
         MROK       => MROK,
         MSERCLK    => MSERCLK,
         MTDI       => MTDIA,
         MWOK       => MWOK,
         VDB        => VDB(15 DOWNTO 0)
      );

   I6 : SRAM
      GENERIC MAP (
         DEPTH => 256
      )
      PORT MAP (
         NOERAM => NOELUT,
         NWRAM  => NWRLUT,
         RAMAD  => dout,
         RAMDT  => RAMDT
      );
	  
   I9 : SRAM
      GENERIC MAP (
         DEPTH => 256
      )
      PORT MAP (
         NOERAM => NOESRAMO,
         NWRAM  => NWRSRAMO,
         RAMAD  => ADO,
         RAMDT  => DTO(15 DOWNTO 0)
      );
   I10 : SRAM
      GENERIC MAP (
         DEPTH => 256
      )
      PORT MAP (
         NOERAM => NOESRAMO,
         NWRAM  => NWRSRAMO,
         RAMAD  => ADO,
         RAMDT  => DTO(31 DOWNTO 16)
      );
   I11 : SRAM
      GENERIC MAP (
         DEPTH => 256
      )
      PORT MAP (
         NOERAM => NOESRAME,
         NWRAM  => NWRSRAME,
         RAMAD  => ADE,
         RAMDT  => DTE(15 DOWNTO 0)
      );
   I12 : SRAM
      GENERIC MAP (
         DEPTH => 256
      )
      PORT MAP (
         NOERAM => NOESRAME,
         NWRAM  => NWRSRAME,
         RAMAD  => ADE,
         RAMDT  => DTE(31 DOWNTO 16)
      );
   I3 : SYNCFIFO
      PORT MAP (
         DIN  => FID,
         WCLK => CLK,
         RCLK => CLK,
         NWEN => NWEN,
         NREN => NRDMEB,
         NOE  => GND,
         NRES => NPRSFIF,
         NLD  => NLD,
         DOUT => DPR,
         EF   => EF,
         ff   => ff,
         PAF  => PAF,
         PAE  => PAE
      );
   I13 : TDCchaines
      generic map
	  (
		hptc_in_sim => hptc_in_sim
	  )
      PORT MAP (
         BNC_RES    => BNC_RES,
         CHAINA_EN  => CHAINA_EN,
         CHAINB_EN  => CHAINB_EN,
         CLK        => CLK,
         EV_RES     => EV_RES,
         Finished   => Finished,
         HITA       => HITA,
         HITB       => HITB,
         TDCGDA     => TDCGDA,
         TDCGDB     => TDCGDB,
         TDCTRG     => TDCTRG,
         TDC_RES    => TDC_RESA,
         TOKINA     => TOKINA,
         TOKINB     => TOKINB,
         TDCDA      => TDCDA,
         TDCDB      => TDCDB,
         TDCDRYA    => TDCDRYA,
         TDCDRYB    => TDCDRYB,
         TOKOUTA    => TOKOUTA,
         TOKOUTA_BP => TOKOUTA_BP,
         TOKOUTB    => TOKOUTB,
         TOKOUTB_BP => TOKOUTB_BP
      );
   I1 : V1390trm
   	GENERIC MAP( 
		SIM_MODE     => TRUE
	)
      PORT MAP (
         AMB          => AM,
         ASB          => AS,
         BERRVME      => BERRVME,
         BNC_RESIN    => BNC_RESIN,
         CHAINA_ERR   => CHAINA_ERR,
         CHAINB_ERR   => CHAINB_ERR,
         CLK          => CLK,
         COM_SER      => COM_SER,
         DPR          => DPR,
         DPR_P        => DPR_P,
         DS0B         => DS0,
         DS1B         => DS1,
         EF           => EF,
         EV_RESIN     => EV_RESIN,
         F_SO         => F_SO,
         GA           => GA,
         IACKB        => IACKB,
         IACKINB      => IACKINB,
         INT_ERRA     => INT_ERRA,
         INT_ERRB     => INT_ERRB,
         L0           => L0,
         L1A          => L1A,
         L1R          => L1R,
         L2A          => L2A,
         L2R          => L2R,
         MROK         => MROK,
         MSERCLK      => MSERCLK,
         MTDIA        => MTDIA,
         MWOK         => MWOK,
         NPWON        => NPWON,
         PAE          => PAE,
         PAF          => PAF,
         SYSRESB      => SYSRESB,
         TDCDA        => TDCDA,
         TDCDB        => TDCDB,
         TDCDRYA      => TDCDRYA,
         TDCDRYB      => TDCDRYB,
         TOKOUTA      => TOKOUTA,
         TOKOUTA_BP   => TOKOUTA_BP,
         TOKOUTB      => TOKOUTB,
         TOKOUTB_BP   => TOKOUTB_BP,
         WRITEB       => WRITE,
         ff           => ff,
         ADE          => ADE,
         ADLTC        => ADLTC,
         ADO          => ADO,
         BNC_RES      => BNC_RES,
         CHAINA_EN244 => CHAINA_EN,
         CHAINB_EN244 => CHAINB_EN,
         EV_RES       => EV_RES,
         FCS          => FCS,
         FID          => FID,
         FID_P        => FID_P,
         F_SCK        => F_SCK,
         F_SI         => F_SI,
         IACKOUTB     => IACKOUTB,
         INTR1        => BUSY,   -- INTR(1),	DAV
         INTR2        => INTR(2),
         LED_G        => LED_G,
         LED_R        => LED_R,
         MTDCRESA     => MTDCRESA,
         MTDCRESB     => MTDCRESB,
         MYBERR       => MYBERR,
         NDTKIN       => NDTKIN,
         NLD          => NLD,
         NMRSFIF      => NMRSFIF,
         NOE16R       => NOE16R,
         NOE16W       => NOE16W,
         NOE32R       => NOE32R,
         NOE32W       => NOE32W,
         NOE64R       => NOE64R,
         NOEAD        => NOEAD,
         NOEDTK       => NOEDTK,
         NOELUT       => NOELUT,
         NOEMIC       => NOEMIC,
         NOESRAME     => NOESRAME,
         NOESRAMO     => NOESRAMO,
         NPRSFIF      => NPRSFIF,
         NRDMEB       => NRDMEB,
         NWEN         => NWEN,
         NWRLUT       => NWRLUT,
         NWRSRAME     => NWRSRAME,
         NWRSRAMO     => NWRSRAMO,
         RAMAD        => RAMAD,
         RMIC         => RMIC,
         SCLA         => SCLA,
         SCLB         => SCLB,
         STBMIC       => STBMIC,
         TDCGDA       => TDCGDA,
         TDCGDB       => TDCGDB,
         TDCTRG       => TDCTRG,
         TDC_RESA     => TDC_RESA,
         TDC_RESB     => TDC_RESB,
         TOKINA       => TOKINA,
         TOKINB       => TOKINB,
         TRM_BUSY     => open, 		-- BUSY,   	DAQ
         TRM_DRDY     => TRM_DRDY,
         WMIC         => WMIC,
         DTE          => DTE,
         DTO          => DTO,
         LWORDB       => LWORD,
         RAMDT        => RAMDT(13 DOWNTO 0),
         SDAA         => SDAA,
         SDAB         => SDAB,
         SP0          => SP0,
         SP1          => SP1,
         SP2          => SP2,
         SP3          => SP3,
         SP4          => SP4,
         SP5          => SP5,
         VAD          => VAD,
         VDB          => VDB
      );
   I0 : VME
      PORT MAP (
         CLK      => CLK,
         ADLTC    => ADLTC,
         IACKOUTB => IACKOUTB,
         INTR     => INTR,
		 DTACK	  => DTACK,
         MYBERR   => MYBERR,
         NDTKIN   => NDTKIN,
         NOE16R   => NOE16R,
         NOE16W   => NOE16W,
         NOE32R   => NOE32R,
         NOE32W   => NOE32W,
         NOE64R   => NOE64R,
         NOEAD    => NOEAD,
         NOEDTK   => NOEDTK,
         BA       => BA,
         BERRVME  => BERRVME,
         Finished => Finished1,	 
         LWORDB   => LWORD,
         VAD      => VAD,
         VDB      => VDB
      );

END struct;
