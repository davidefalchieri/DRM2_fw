library IEEE, APA;
use IEEE.std_logic_1164.all;

entity CROM is

   port(DO : out std_logic_vector (7 downto 0);
      RCLOCK : in std_logic;
      WCLOCK : in std_logic;
      DI : in std_logic_vector (7 downto 0);
      PO : out std_logic;
      WRB : in std_logic;
      RDB : in std_logic;
      WADDR : in std_logic_vector (8 downto 0);
      RADDR : in std_logic_vector (8 downto 0));

end CROM;

architecture STRUCT_CROM of CROM is
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

component MUX2H
   port(Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      S : in std_logic);
end component;

component DFF
   port(Q : out std_logic;
      CLK : in std_logic;
      D : in std_logic);
end component;

component INV
   port(Y : out std_logic;
      A : in std_logic);
end component;

component DMUX
   port(Y : out std_logic;
      A : in std_logic;
      B : in std_logic;
      S : in std_logic);
end component;

signal net00000, net00001, net00002, net00003, net00004, net00005, net00006, net00007, 
      net00008, net00009, net00010, net00011, net00012, net00013, net00014, net00015, 
      net00016, net00017, net00018, net00019, net00020, net00021, net00022, net00023, 
      net00024, net00025, net00026, net00027, net00028, net00029, net00030, net00031, 
      net00032, net00033, net00034, net00035, net00036, net00037, net00038, net00039, 
      net00040, net00041, net00042, net00043, net00044, net00045, net00046, net00047, 
      net00048, net00049, net00050, net00051, net00052 : std_logic;

begin

   U1 : GND
 port map(Y => net00001);
   M0 : RAM256x9SSTP
 generic map(MEMORYFILE => "CROM_M0.mem")
 port map(RCLKS => RCLOCK, WCLKS => WCLOCK, DO8 => net00050, DO7 => net00046, DO6 => net00041, 
      DO5 => net00036, DO4 => net00031, DO3 => net00026, DO2 => net00021, DO1 => net00016, DO0 => net00009, 
      DOS => net00011, WADDR7 => WADDR(7), WADDR6 => WADDR(6), WADDR5 => WADDR(5), 
      WADDR4 => WADDR(4), WADDR3 => WADDR(3), WADDR2 => WADDR(2), WADDR1 => WADDR(1), 
      WADDR0 => WADDR(0), RADDR7 => RADDR(7), RADDR6 => RADDR(6), RADDR5 => RADDR(5), 
      RADDR4 => RADDR(4), RADDR3 => RADDR(3), RADDR2 => RADDR(2), RADDR1 => RADDR(1), 
      RADDR0 => RADDR(0), DI8 => net00001, DI7 => DI(7), DI6 => DI(6), DI5 => DI(5), 
      DI4 => DI(4), DI3 => DI(3), DI2 => DI(2), DI1 => DI(1), DI0 => DI(0), 
      WRB => WRB, RDB => RDB, WBLKB => net00004, RBLKB => net00001, PARODD => net00001, DIS => net00001);
   M1 : RAM256x9SSTP
 generic map(MEMORYFILE => "CROM_M1.mem")
 port map(RCLKS => RCLOCK, WCLKS => WCLOCK, DO8 => net00052, DO7 => net00048, DO6 => net00043, 
      DO5 => net00038, DO4 => net00033, DO3 => net00028, DO2 => net00023, DO1 => net00018, DO0 => net00012, 
      DOS => net00013, WADDR7 => WADDR(7), WADDR6 => WADDR(6), WADDR5 => WADDR(5), 
      WADDR4 => WADDR(4), WADDR3 => WADDR(3), WADDR2 => WADDR(2), WADDR1 => WADDR(1), 
      WADDR0 => WADDR(0), RADDR7 => RADDR(7), RADDR6 => RADDR(6), RADDR5 => RADDR(5), 
      RADDR4 => RADDR(4), RADDR3 => RADDR(3), RADDR2 => RADDR(2), RADDR1 => RADDR(1), 
      RADDR0 => RADDR(0), DI8 => net00001, DI7 => DI(7), DI6 => DI(6), DI5 => DI(5), 
      DI4 => DI(4), DI3 => DI(3), DI2 => DI(2), DI1 => DI(1), DI0 => DI(0), 
      WRB => WRB, RDB => RDB, WBLKB => WADDR(8), RBLKB => net00001, PARODD => net00001, DIS => net00002);
   U2 : MUX2H
 port map(Y => net00003, A => RADDR(8), B => net00002, S => RDB);
   U3 : DFF
 port map(Q => net00002, CLK => RCLOCK, D => net00003);
   U4 : INV
 port map(Y => net00004, A => WADDR(8));
   U6 : DMUX
 port map(Y => net00010, A => net00009, B => net00001, S => net00011);
   U7 : DMUX
 port map(Y => DO(0), A => net00012, B => net00010, S => net00013);
   U8 : DMUX
 port map(Y => net00017, A => net00016, B => net00001, S => net00011);
   U9 : DMUX
 port map(Y => DO(1), A => net00018, B => net00017, S => net00013);
   U10 : DMUX
 port map(Y => net00022, A => net00021, B => net00001, S => net00011);
   U11 : DMUX
 port map(Y => DO(2), A => net00023, B => net00022, S => net00013);
   U12 : DMUX
 port map(Y => net00027, A => net00026, B => net00001, S => net00011);
   U13 : DMUX
 port map(Y => DO(3), A => net00028, B => net00027, S => net00013);
   U14 : DMUX
 port map(Y => net00032, A => net00031, B => net00001, S => net00011);
   U15 : DMUX
 port map(Y => DO(4), A => net00033, B => net00032, S => net00013);
   U16 : DMUX
 port map(Y => net00037, A => net00036, B => net00001, S => net00011);
   U17 : DMUX
 port map(Y => DO(5), A => net00038, B => net00037, S => net00013);
   U18 : DMUX
 port map(Y => net00042, A => net00041, B => net00001, S => net00011);
   U19 : DMUX
 port map(Y => DO(6), A => net00043, B => net00042, S => net00013);
   U20 : DMUX
 port map(Y => net00047, A => net00046, B => net00001, S => net00011);
   U21 : DMUX
 port map(Y => DO(7), A => net00048, B => net00047, S => net00013);
   U22 : DMUX
 port map(Y => net00051, A => net00050, B => net00001, S => net00011);
   U23 : DMUX
 port map(Y => PO, A => net00052, B => net00051, S => net00013);

end STRUCT_CROM;



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
-- "DESDIR:C:/FrontEnd/Annalisa/work/vx1392/smartgen\CROM"
-- GEN_BEHV_MODULE:F
--  WIDTH:8
--  DEPTH:264
--  RDA:transparent
--  WRA:sync
--  OPT:speed
--  PARITY:geneven

-- _End_Comments_

