LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY MICRO IS
   PORT( 
      Finished   : IN     std_logic;
      MRES       : IN     std_logic;
      NOEMIC     : IN     std_logic;
      RMIC       : IN     std_logic;
      STBMIC     : IN     std_logic;
      WMIC       : IN     std_logic;
      CHAINA_ERR : OUT    std_logic;
      CHAINB_ERR : OUT    std_logic;
      COM_SER    : OUT    std_logic;
      INT_ERRA   : OUT    std_logic;
      INT_ERRB   : OUT    std_logic;
      MROK       : OUT    std_logic;
      MSERCLK    : OUT    std_logic;
      MTDI       : OUT    std_logic;
      MWOK       : OUT    std_logic;
      VDB        : INOUT  std_logic_vector (15 DOWNTO 0)
   );

-- Declarations

END MICRO ;
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_Logic_unsigned.all;


ARCHITECTURE struct OF MICRO IS

   -- Architecture declarations

   -- Internal signal declarations
   SIGNAL GND    : std_logic;
   SIGNAL MICD   : std_logic_vector(7 DOWNTO 0);
   SIGNAL NOEABH : std_logic;
   SIGNAL NOEABL : std_logic;
   SIGNAL STRBAH : std_logic;
   SIGNAL STRBAL : std_logic;


   -- Component Declarations
   COMPONENT ATMEGA16
   PORT (
      Finished   : IN     std_logic;
      MRES       : IN     std_logic;
      RMIC       : IN     std_logic;
      WMIC       : IN     std_logic;
      CHAINA_ERR : OUT    std_logic;
      CHAINB_ERR : OUT    std_logic;
      COM_SER    : OUT    std_logic;
      INT_ERRA   : OUT    std_logic;
      INT_ERRB   : OUT    std_logic;
      MROK       : OUT    std_logic;
      MSERCLK    : OUT    std_logic;
      MTDI       : OUT    std_logic;
      MWOK       : OUT    std_logic;
      NOEABH     : OUT    std_logic;
      NOEABL     : OUT    std_logic;
      STRBAH     : OUT    std_logic;
      STRBAL     : OUT    std_logic;
      MICD       : INOUT  std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;
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

   -- ModuleWare code(v1.1) for instance 'I8' of 'gnd'
   GND <= '0';

   -- Instance port mappings.
   I3 : ATMEGA16
      PORT MAP (
         MRES       => MRES,
         MICD       => MICD,
         MROK       => MROK,
         WMIC       => WMIC,
         MWOK       => MWOK,
         RMIC       => RMIC,
         NOEABL     => NOEABL,
         NOEABH     => NOEABH,
         STRBAL     => STRBAL,
         STRBAH     => STRBAH,
         COM_SER    => COM_SER,
         MSERCLK    => MSERCLK,
         MTDI       => MTDI,
         Finished   => Finished,
         INT_ERRA   => INT_ERRA,
         CHAINA_ERR => CHAINA_ERR,
         INT_ERRB   => INT_ERRB,
         CHAINB_ERR => CHAINB_ERR
      );
   I1 : FCT16543
      PORT MAP (
         A0    => VDB(0),
         A1    => VDB(1),
         A2    => VDB(2),
         A3    => VDB(3),
         A4    => VDB(4),
         A5    => VDB(5),
         A6    => VDB(6),
         A7    => VDB(7),
         B0    => MICD(0),
         B1    => MICD(1),
         B2    => MICD(2),
         B3    => MICD(3),
         B4    => MICD(4),
         B5    => MICD(5),
         B6    => MICD(6),
         B7    => MICD(7),
         NOEAB => NOEABL,
         NOEBA => NOEMIC,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => STBMIC,
         NLEBA => STRBAL
      );
   I2 : FCT16543
      PORT MAP (
         A0    => VDB(8),
         A1    => VDB(9),
         A2    => VDB(10),
         A3    => VDB(11),
         A4    => VDB(12),
         A5    => VDB(13),
         A6    => VDB(14),
         A7    => VDB(15),
         B0    => MICD(0),
         B1    => MICD(1),
         B2    => MICD(2),
         B3    => MICD(3),
         B4    => MICD(4),
         B5    => MICD(5),
         B6    => MICD(6),
         B7    => MICD(7),
         NOEAB => NOEABH,
         NOEBA => NOEMIC,
         NCEAB => GND,
         NCEBA => GND,
         NLEAB => STBMIC,
         NLEBA => STRBAH
      );

END struct;
