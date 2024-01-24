library IEEE, APA;
use IEEE.std_logic_1164.all;

entity DACCFG is

   port(DO : out std_logic_vector (15 downto 0);
      RCLOCK : in std_logic;
      WCLOCK : in std_logic;
      DI : in std_logic_vector (15 downto 0);
      PO : out std_logic_vector (1 downto 0);
      WRB : in std_logic;
      RDB : in std_logic;
      WADDR : in std_logic_vector (3 downto 0);
      RADDR : in std_logic_vector (3 downto 0));

end DACCFG;

architecture STRUCT_DACCFG of DACCFG is
component PWR
   port(Y : out std_logic);
end component;

component GND
   port(Y : out std_logic);
end component;

component RAM256x9SSTP
   generic (MEMORYFILE:string := "");
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
      WADDR7 : in std_logic;
      WADDR6 : in std_logic;
      WADDR5 : in std_logic;
      WADDR4 : in std_logic;
      WADDR3 : in std_logic;
      WADDR2 : in std_logic;
      WADDR1 : in std_logic;
      WADDR0 : in std_logic;
      RADDR7 : in std_logic;
      RADDR6 : in std_logic;
      RADDR5 : in std_logic;
      RADDR4 : in std_logic;
      RADDR3 : in std_logic;
      RADDR2 : in std_logic;
      RADDR1 : in std_logic;
      RADDR0 : in std_logic;
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

signal net00000, net00001, net00002, net00003, net00004, net00005, net00006, net00007, 
      net00008, net00009, net00010, net00011, net00012, net00013, net00014, net00015, 
      net00016, net00017, net00018, net00019, net00020 : std_logic;

begin

   U1 : GND
 port map(Y => net00001);
   M0 : RAM256x9SSTP
 generic map(MEMORYFILE => "DACCFG_M0.mem")
 port map(RCLKS => RCLOCK, WCLKS => WCLOCK, DO8 => PO(0), DO7 => DO(7), DO6 => DO(6), 
      DO5 => DO(5), DO4 => DO(4), DO3 => DO(3), DO2 => DO(2), DO1 => DO(1), 
      DO0 => DO(0), DOS => net00019, WADDR7 => net00001, WADDR6 => net00001, WADDR5 => net00001, 
      WADDR4 => net00001, WADDR3 => WADDR(3), WADDR2 => WADDR(2), WADDR1 => WADDR(1), 
      WADDR0 => WADDR(0), RADDR7 => net00001, RADDR6 => net00001, RADDR5 => net00001, RADDR4 => net00001, 
      RADDR3 => RADDR(3), RADDR2 => RADDR(2), RADDR1 => RADDR(1), RADDR0 => RADDR(0), 
      DI8 => net00001, DI7 => DI(7), DI6 => DI(6), DI5 => DI(5), DI4 => DI(4), DI3 => DI(3), 
      DI2 => DI(2), DI1 => DI(1), DI0 => DI(0), WRB => WRB, RDB => RDB, WBLKB => net00001, 
      RBLKB => net00001, PARODD => net00001, DIS => net00001);
   M1 : RAM256x9SSTP
 generic map(MEMORYFILE => "DACCFG_M1.mem")
 port map(RCLKS => RCLOCK, WCLKS => WCLOCK, DO8 => PO(1), DO7 => DO(15), DO6 => DO(14), 
      DO5 => DO(13), DO4 => DO(12), DO3 => DO(11), DO2 => DO(10), DO1 => DO(9), 
      DO0 => DO(8), DOS => net00020, WADDR7 => net00001, WADDR6 => net00001, WADDR5 => net00001, 
      WADDR4 => net00001, WADDR3 => WADDR(3), WADDR2 => WADDR(2), WADDR1 => WADDR(1), 
      WADDR0 => WADDR(0), RADDR7 => net00001, RADDR6 => net00001, RADDR5 => net00001, RADDR4 => net00001, 
      RADDR3 => RADDR(3), RADDR2 => RADDR(2), RADDR1 => RADDR(1), RADDR0 => RADDR(0), 
      DI8 => net00001, DI7 => DI(15), DI6 => DI(14), DI5 => DI(13), DI4 => DI(12), DI3 => DI(11), 
      DI2 => DI(10), DI1 => DI(9), DI0 => DI(8), WRB => WRB, RDB => RDB, WBLKB => net00001, 
      RBLKB => net00001, PARODD => net00001, DIS => net00001);

end STRUCT_DACCFG;



-- _Disclaimer: Please leave the following comments in the file, they are for internal purposes only._


-- _GEN_File_Contents_

-- Version:7.3.0.29
-- ACTGENU_CALL:1
-- BATCH:T
-- FAM:PA
-- OUTFORMAT:VHDL
-- LPMTYPE:LPM_RAM_DQ
-- LPM_HINT:NONE
-- INSERT_PAD:NO
-- INSERT_IOREG:NO
-- GEN_BHV_VHDL_VAL:F
-- GEN_BHV_VERILOG_VAL:F
-- MGNTIMER:F
-- MGNCMPL:F
-- "DESDIR:C:/FrontEnd/Annalisa/work/vx1392/smartgen\DACCFG"
-- GEN_BEHV_MODULE:F
--  WIDTH:16
--  DEPTH:16
--  RDA:transparent
--  WRA:sync
--  OPT:speed
--  PARITY:geneven

-- _End_Comments_

