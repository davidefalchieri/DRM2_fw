library IEEE, APA;
use IEEE.std_logic_1164.all;

entity event_fifo is

   port(DO : out std_logic_vector (31 downto 0);
      RCLOCK : in std_logic;
      WCLOCK : in std_logic;
      DI : in std_logic_vector (31 downto 0);
      WRB : in std_logic;
      RDB : in std_logic;
      RESET : in std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic);

end event_fifo;

architecture STRUCT_event_fifo of event_fifo is
component PWR
   port(Y : out std_logic);
end component;

component GND
   port(Y : out std_logic);
end component;

component FIFO256x9SST
   port(RCLKS : in std_logic;
      WCLKS : in std_logic;
      DO8 : out std_logic;
      DO7 : out std_logic;
      DO6 : out std_logic;
      DO5 : out std_logic;
      DO4 : out std_logic;
      DO3 : out std_logic;
      DO2 : out std_logic;
      DO1 : out std_logic;
      DO0 : out std_logic;
      DOS : out std_logic;
      FULL : out std_logic;
      EMPTY : out std_logic;
      EQTH : out std_logic;
      GEQTH : out std_logic;
      WPE : out std_logic;
      RPE : out std_logic;
      LGDEP2 : in std_logic;
      LGDEP1 : in std_logic;
      LGDEP0 : in std_logic;
      RESET : in std_logic;
      LEVEL7 : in std_logic;
      LEVEL6 : in std_logic;
      LEVEL5 : in std_logic;
      LEVEL4 : in std_logic;
      LEVEL3 : in std_logic;
      LEVEL2 : in std_logic;
      LEVEL1 : in std_logic;
      LEVEL0 : in std_logic;
      DI8 : in std_logic;
      DI7 : in std_logic;
      DI6 : in std_logic;
      DI5 : in std_logic;
      DI4 : in std_logic;
      DI3 : in std_logic;
      DI2 : in std_logic;
      DI1 : in std_logic;
      DI0 : in std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WBLKB : in std_logic;
      RBLKB : in std_logic;
      PARODD : in std_logic;
      DIS : in std_logic);
end component;

component INV
   port(Y : out std_logic;
      A : in std_logic);
end component;

component OR3
   port(Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      C : in std_logic);
end component;

component OR2
   port(Y : out std_logic;
      A : in std_logic;
      B : in std_logic);
end component;

signal net00000, net00001, net00002, net00003, net00004, net00005, net00006, net00007, 
      net00008, net00009, net00010, net00011, net00012, net00013, net00014, net00015, 
      net00016, net00017, net00018, net00019, net00020, net00021, net00022, net00023, 
      net00024, net00025, net00026, net00027, net00028, net00029, net00030, net00031, 
      net00032, net00033, net00034, net00035, net00036, net00037, net00038, net00039, 
      net00040, net00041, net00042, net00043, net00044, net00045, net00046, net00047, 
      net00048, net00049, net00050, net00051, net00052, net00053, net00054, net00055, 
      net00056, net00057, net00058, net00059, net00060, net00061, net00062, net00063, 
      net00064, net00065, net00066, net00067, net00068, net00069, net00070, net00071 : std_logic;

begin

   U0 : PWR
 port map(Y => net00000);
   U1 : GND
 port map(Y => net00001);
   M0 : FIFO256x9SST
 port map(RCLKS => RCLOCK, WCLKS => WCLOCK, DO8 => DO(8), DO7 => DO(7), DO6 => DO(6), 
      DO5 => DO(5), DO4 => DO(4), DO3 => DO(3), DO2 => DO(2), DO1 => DO(1), 
      DO0 => DO(0), DOS => net00056, FULL => net00003, EMPTY => net00008, EQTH => net00013, GEQTH => net00018, 
      WPE => net00057, RPE => net00058, LGDEP2 => net00000, LGDEP1 => net00000, LGDEP0 => net00000, RESET => RESET, 
      LEVEL7 => net00001, LEVEL6 => net00001, LEVEL5 => net00001, LEVEL4 => net00001, LEVEL3 => net00001, 
      LEVEL2 => net00001, LEVEL1 => net00001, LEVEL0 => net00000, DI8 => DI(8), DI7 => DI(7), 
      DI6 => DI(6), DI5 => DI(5), DI4 => DI(4), DI3 => DI(3), DI2 => DI(2), 
      DI1 => DI(1), DI0 => DI(0), WRB => WRB, RDB => RDB, WBLKB => net00001, RBLKB => net00001, 
      PARODD => net00001, DIS => net00001);
   M1 : FIFO256x9SST
 port map(RCLKS => RCLOCK, WCLKS => WCLOCK, DO8 => DO(17), DO7 => DO(16), DO6 => DO(15), 
      DO5 => DO(14), DO4 => DO(13), DO3 => DO(12), DO2 => DO(11), DO1 => DO(10), 
      DO0 => DO(9), DOS => net00059, FULL => net00004, EMPTY => net00009, EQTH => net00014, GEQTH => net00019, 
      WPE => net00060, RPE => net00061, LGDEP2 => net00000, LGDEP1 => net00000, LGDEP0 => net00000, RESET => RESET, 
      LEVEL7 => net00001, LEVEL6 => net00001, LEVEL5 => net00001, LEVEL4 => net00001, LEVEL3 => net00001, 
      LEVEL2 => net00001, LEVEL1 => net00001, LEVEL0 => net00000, DI8 => DI(17), DI7 => DI(16), 
      DI6 => DI(15), DI5 => DI(14), DI4 => DI(13), DI3 => DI(12), DI2 => DI(11), 
      DI1 => DI(10), DI0 => DI(9), WRB => WRB, RDB => RDB, WBLKB => net00001, RBLKB => net00001, 
      PARODD => net00001, DIS => net00001);
   M2 : FIFO256x9SST
 port map(RCLKS => RCLOCK, WCLKS => WCLOCK, DO8 => DO(26), DO7 => DO(25), DO6 => DO(24), 
      DO5 => DO(23), DO4 => DO(22), DO3 => DO(21), DO2 => DO(20), DO1 => DO(19), 
      DO0 => DO(18), DOS => net00062, FULL => net00005, EMPTY => net00010, EQTH => net00015, GEQTH => net00020, 
      WPE => net00063, RPE => net00064, LGDEP2 => net00000, LGDEP1 => net00000, LGDEP0 => net00000, RESET => RESET, 
      LEVEL7 => net00001, LEVEL6 => net00001, LEVEL5 => net00001, LEVEL4 => net00001, LEVEL3 => net00001, 
      LEVEL2 => net00001, LEVEL1 => net00001, LEVEL0 => net00000, DI8 => DI(26), DI7 => DI(25), 
      DI6 => DI(24), DI5 => DI(23), DI4 => DI(22), DI3 => DI(21), DI2 => DI(20), 
      DI1 => DI(19), DI0 => DI(18), WRB => WRB, RDB => RDB, WBLKB => net00001, RBLKB => net00001, 
      PARODD => net00001, DIS => net00001);
   M3 : FIFO256x9SST
 port map(RCLKS => RCLOCK, WCLKS => WCLOCK, DO8 => net00065, DO7 => net00066, DO6 => net00067, 
      DO5 => net00068, DO4 => DO(31), DO3 => DO(30), DO2 => DO(29), DO1 => DO(28), DO0 => DO(27), 
      DOS => net00069, FULL => net00006, EMPTY => net00011, EQTH => net00016, GEQTH => net00021, WPE => net00070, 
      RPE => net00071, LGDEP2 => net00000, LGDEP1 => net00000, LGDEP0 => net00000, RESET => RESET, LEVEL7 => net00001, 
      LEVEL6 => net00001, LEVEL5 => net00001, LEVEL4 => net00001, LEVEL3 => net00001, LEVEL2 => net00001, 
      LEVEL1 => net00001, LEVEL0 => net00000, DI8 => net00001, DI7 => net00001, DI6 => net00001, DI5 => net00001, 
      DI4 => DI(31), DI3 => DI(30), DI2 => DI(29), DI1 => DI(28), DI0 => DI(27), 
      WRB => WRB, RDB => RDB, WBLKB => net00001, RBLKB => net00001, PARODD => net00001, DIS => net00001);
   U3 : OR3
 port map(Y => net00007, A => net00005, B => net00004, C => net00003);
   U4 : OR2
 port map(Y => FULL, A => net00006, B => net00007);
   U5 : OR3
 port map(Y => net00012, A => net00010, B => net00009, C => net00008);
   U6 : OR2
 port map(Y => EMPTY, A => net00011, B => net00012);
   U7 : OR3
 port map(Y => net00017, A => net00015, B => net00014, C => net00013);
   U8 : OR2
 port map(Y => EQTH, A => net00016, B => net00017);
   U9 : OR3
 port map(Y => net00022, A => net00020, B => net00019, C => net00018);
   U10 : OR2
 port map(Y => GEQTH, A => net00021, B => net00022);

end STRUCT_event_fifo;



-- _Disclaimer: Please leave the following comments in the file, they are for internal purposes only._


-- _GEN_File_Contents_

-- Version:7.3.0.29
-- ACTGENU_CALL:1
-- BATCH:T
-- FAM:PA
-- OUTFORMAT:VHDL
-- LPMTYPE:LPM_FIFO_DQ
-- LPM_HINT:FIFO_STATIC
-- INSERT_PAD:NO
-- INSERT_IOREG:NO
-- GEN_BHV_VHDL_VAL:F
-- GEN_BHV_VERILOG_VAL:F
-- MGNTIMER:F
-- MGNCMPL:F
-- "DESDIR:C:/FrontEnd/Annalisa/work/vx1392/smartgen\event_fifo"
-- GEN_BEHV_MODULE:F
--  WIDTH:32
--  DEPTH:256
--  RDA:transparent
--  WRA:sync
--  OPT:area
--  PARITY:none
--  STAT_FIFO_LEVEL:1

-- _End_Comments_

