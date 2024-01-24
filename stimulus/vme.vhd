LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY VME IS
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

-- Declarations

END VME ;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ARCHITECTURE struct OF VME IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL A     : std_logic_vector(31 DOWNTO 0);
   SIGNAL AM    : std_logic_vector(5 DOWNTO 0);
   SIGNAL D     : std_logic_vector(31 DOWNTO 0);
   SIGNAL GND   : std_logic;
   SIGNAL LWORD : std_logic;
   SIGNAL NC    : std_logic;
   SIGNAL VCC   : std_logic;

   -- Implicit buffer signal declarations
   SIGNAL BA_internal       : std_logic_vector (3 DOWNTO 0);
   --SIGNAL Finished_internal : std_logic;

   SIGNAL ena     : std_logic;
   SIGNAL ena1    : std_logic;
   SIGNAL BERR    : std_logic;

   -- Component Declarations
   COMPONENT FCT16543
   PORT (
      A0    : INOUT  std_logic ;
      A1    : INOUT  std_logic ;
      A2    : INOUT  std_logic ;
      A3    : INOUT  std_logic ;
      A4    : INOUT  std_logic ;
      A5    : INOUT  std_logic ;
      A6    : INOUT  std_logic ;
      A7    : INOUT  std_logic ;
      B0    : INOUT  std_logic ;
      B1    : INOUT  std_logic ;
      B2    : INOUT  std_logic ;
      B3    : INOUT  std_logic ;
      B4    : INOUT  std_logic ;
      B5    : INOUT  std_logic ;
      B6    : INOUT  std_logic ;
      B7    : INOUT  std_logic ;
      NOEAB : IN     std_logic ;
      NOEBA : IN     std_logic ;
      NCEAB : IN     std_logic ;
      NCEBA : IN     std_logic ;
      NLEAB : IN     std_logic ;
      NLEBA : IN     std_logic 
   );
   END COMPONENT;


BEGIN

   -- ModuleWare code(v1.1) for instance 'I7' of 'gnd'
   GND <= '0';

   -- ModuleWare code(v1.1) for instance 'I8' of 'vdd'
   VCC <= '1';

   ena  <= NOT(NOEDTK);
   ena1 <= NOT(MYBERR);
   
   --BERRVME	<= MYBERR;		-- DAV
   BERRVME	<= BERR;		-- DAV

   i0combo_proc: PROCESS (NDTKIN, ena)
   BEGIN
      IF (ena = '0' OR ena = 'L') THEN
         DTACK <= 'H';  -- pull up
      ELSIF (ena = '1' OR ena = 'H') THEN
         DTACK <= NDTKIN;
      ELSE
         DTACK <= 'X';
      END IF;
   END PROCESS i0combo_proc;
   
   i15combo_proc: PROCESS (MYBERR, ena1)
   BEGIN
      IF (ena1 = '0' OR ena1 = 'L') THEN
         BERR <= 'H';
      ELSIF (ena1 = '1' OR ena1 = 'H') THEN
         BERR <= '0';
      ELSE
         BERR <= 'X';
      END IF;
   END PROCESS i15combo_proc;
   
   -- Instance port mappings.
   I1 : FCT16543
      PORT MAP (
         A0    => D(0),
         A1    => D(1),
         A2    => D(2),
         A3    => D(3),
         A4    => D(4),
         A5    => D(5),
         A6    => D(6),
         A7    => D(7),
         B0    => VDB(0),
         B1    => VDB(1),
         B2    => VDB(2),
         B3    => VDB(3),
         B4    => VDB(4),
         B5    => VDB(5),
         B6    => VDB(6),
         B7    => VDB(7),
         NOEAB => NOE16W,
         NOEBA => NOE16R,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND
      );
	  
   I2 : FCT16543
      PORT MAP (
         A0    => D(8),
         A1    => D(9),
         A2    => D(10),
         A3    => D(11),
         A4    => D(12),
         A5    => D(13),
         A6    => D(14),
         A7    => D(15),
         B0    => VDB(8),
         B1    => VDB(9),
         B2    => VDB(10),
         B3    => VDB(11),
         B4    => VDB(12),
         B5    => VDB(13),
         B6    => VDB(14),
         B7    => VDB(15),
         NOEAB => NOE16W,
         NOEBA => NOE16R,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND
      );
	  
   I3 : FCT16543
      PORT MAP (
         A0    => LWORD,
         A1    => A(1),
         A2    => A(2),
         A3    => A(3),
         A4    => A(4),
         A5    => A(5),
         A6    => A(6),
         A7    => A(7),
         B0    => LWORDB,
         B1    => VAD(1),
         B2    => VAD(2),
         B3    => VAD(3),
         B4    => VAD(4),
         B5    => VAD(5),
         B6    => VAD(6),
         B7    => VAD(7),
         NOEAB => NOEAD,
         NOEBA => NOE64R,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => ADLTC,
         NLEBA => GND
      );
	  
   I4 : FCT16543
      PORT MAP (
         A0    => GND,
         A1    => GND,
         A2    => GND,
         A3    => GND,
         A4    => GND,
         A5    => GND,
         A6    => GND,
         A7    => GND,
         B0    => NC,
         B1    => NC,
         B2    => NC,
         B3    => NC,
         B4    => NC,
         B5    => NC,
         B6    => NC,
         B7    => NC,
         NOEAB => GND,
         NOEBA => VCC,
         NCEAB => GND,
         NCEBA => VCC,
         NLEAB => ADLTC,
         NLEBA => VCC
      );
	  
   I9 : FCT16543
      PORT MAP (
         A0    => D(16),
         A1    => D(17),
         A2    => D(18),
         A3    => D(19),
         A4    => D(20),
         A5    => D(21),
         A6    => D(22),
         A7    => D(23),
         B0    => VDB(16),
         B1    => VDB(17),
         B2    => VDB(18),
         B3    => VDB(19),
         B4    => VDB(20),
         B5    => VDB(21),
         B6    => VDB(22),
         B7    => VDB(23),
         NOEAB => NOE32W,
         NOEBA => NOE32R,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND
      );
	  
   I10 : FCT16543
      PORT MAP (
         A0    => D(24),
         A1    => D(25),
         A2    => D(26),
         A3    => D(27),
         A4    => D(28),
         A5    => D(29),
         A6    => D(30),
         A7    => D(31),
         B0    => VDB(24),
         B1    => VDB(25),
         B2    => VDB(26),
         B3    => VDB(27),
         B4    => VDB(28),
         B5    => VDB(29),
         B6    => VDB(30),
         B7    => VDB(31),
         NOEAB => NOE32W,
         NOEBA => NOE32R,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => GND,
         NLEBA => GND
      );
	  
   I11 : FCT16543
      PORT MAP (
         A0    => A(8),
         A1    => A(9),
         A2    => A(10),
         A3    => A(11),
         A4    => A(12),
         A5    => A(13),
         A6    => A(14),
         A7    => A(15),
         B0    => VAD(8),
         B1    => VAD(9),
         B2    => VAD(10),
         B3    => VAD(11),
         B4    => VAD(12),
         B5    => VAD(13),
         B6    => VAD(14),
         B7    => VAD(15),
         NOEAB => NOEAD,
         NOEBA => NOE64R,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => ADLTC,
         NLEBA => GND
      );
	  
   I12 : FCT16543
      PORT MAP (
         A0    => A(16),
         A1    => A(17),
         A2    => A(18),
         A3    => A(19),
         A4    => A(20),
         A5    => A(21),
         A6    => A(22),
         A7    => A(23),
         B0    => VAD(16),
         B1    => VAD(17),
         B2    => VAD(18),
         B3    => VAD(19),
         B4    => VAD(20),
         B5    => VAD(21),
         B6    => VAD(22),
         B7    => VAD(23),
         NOEAB => NOEAD,
         NOEBA => NOE64R,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => ADLTC,
         NLEBA => GND
      );
	  
   I13 : FCT16543
      PORT MAP (
         A0    => A(24),
         A1    => A(25),
         A2    => A(26),
         A3    => A(27),
         A4    => A(28),
         A5    => A(29),
         A6    => A(30),
         A7    => A(31),
         B0    => VAD(24),
         B1    => VAD(25),
         B2    => VAD(26),
         B3    => VAD(27),
         B4    => VAD(28),
         B5    => VAD(29),
         B6    => VAD(30),
         B7    => VAD(31),
         NOEAB => NOEAD,
         NOEBA => NOE64R,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => ADLTC,
         NLEBA => GND
      );


   -- Implicit buffered output assignments
   BA       <= BA_internal;
   Finished <= '0';		

END struct;
