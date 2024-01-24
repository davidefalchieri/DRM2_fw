-- Version: 8.3 8.3.0.22

library ieee;
use ieee.std_logic_1164.all;
library APA;
use APA.all;

entity PLL_sram is 
    port(GLB, LOCK : out std_logic;  CLK : in std_logic) ;
end PLL_sram;


architecture DEF_ARCH of  PLL_sram is

    component PLLCORE
        port(SDOUT : out std_logic;  SCLK, SDIN, SSHIFT, SUPDATE : 
        in std_logic := 'U'; GLB : out std_logic;  CLK : in 
        std_logic := 'U'; GLA : out std_logic;  CLKA : in 
        std_logic := 'U'; LOCK : out std_logic;  MODE, FBDIV5, 
        EXTFB, FBSEL0, FBSEL1, FINDIV0, FINDIV1, FINDIV2, FINDIV3, 
        FINDIV4, FBDIV0, FBDIV1, FBDIV2, FBDIV3, FBDIV4, STATBSEL, 
        DLYB0, DLYB1, OBDIV0, OBDIV1, STATASEL, DLYA0, DLYA1, 
        OADIV0, OADIV1, OAMUX0, OAMUX1, OBMUX0, OBMUX1, OBMUX2, 
        FBDLY0, FBDLY1, FBDLY2, FBDLY3, XDLYSEL : in std_logic := 
        'U') ;
    end component;

    component PWR
        port( Y : out std_logic);
    end component;

    component GND
        port( Y : out std_logic);
    end component;

    signal VCC, GND_1_net : std_logic ;
    begin   

    PWR_1_net : PWR port map(Y => VCC);
    GND_2_net : GND port map(Y => GND_1_net);
    Core : PLLCORE
      port map(SDOUT => OPEN , SCLK => GND_1_net, SDIN => 
        GND_1_net, SSHIFT => GND_1_net, SUPDATE => GND_1_net, 
        GLB => GLB, CLK => CLK, GLA => OPEN , CLKA => GND_1_net, 
        LOCK => LOCK, MODE => GND_1_net, FBDIV5 => GND_1_net, 
        EXTFB => GND_1_net, FBSEL0 => VCC, FBSEL1 => GND_1_net, 
        FINDIV0 => GND_1_net, FINDIV1 => GND_1_net, FINDIV2 => 
        GND_1_net, FINDIV3 => GND_1_net, FINDIV4 => GND_1_net, 
        FBDIV0 => VCC, FBDIV1 => GND_1_net, FBDIV2 => GND_1_net, 
        FBDIV3 => GND_1_net, FBDIV4 => GND_1_net, STATBSEL => 
        GND_1_net, DLYB0 => GND_1_net, DLYB1 => GND_1_net, 
        OBDIV0 => GND_1_net, OBDIV1 => GND_1_net, STATASEL => 
        GND_1_net, DLYA0 => GND_1_net, DLYA1 => GND_1_net, 
        OADIV0 => GND_1_net, OADIV1 => GND_1_net, OAMUX0 => 
        GND_1_net, OAMUX1 => GND_1_net, OBMUX0 => GND_1_net, 
        OBMUX1 => GND_1_net, OBMUX2 => VCC, FBDLY0 => GND_1_net, 
        FBDLY1 => GND_1_net, FBDLY2 => GND_1_net, FBDLY3 => 
        GND_1_net, XDLYSEL => GND_1_net);
end DEF_ARCH;

-- _Disclaimer: Please leave the following comments in the file, they are for internal purposes only._


-- _GEN_File_Contents_

-- Version:8.3.0.22
-- ACTGENU_CALL:1
-- BATCH:T
-- FAM:PA
-- OUTFORMAT:VHDL
-- LPMTYPE:LPM_PLL_NEW
-- LPM_HINT:NONE
-- INSERT_PAD:NO
-- INSERT_IOREG:NO
-- GEN_BHV_VHDL_VAL:F
-- GEN_BHV_VERILOG_VAL:F
-- MGNTIMER:F
-- MGNCMPL:F
-- "DESDIR:C:/FrontEnd/Annalisa/work/v1390/FPGA/V1390LIB/v1390trm/smartgen\PLL_sram"
-- GEN_BEHV_MODULE:T
-- SMARTGEN_DIE:750
-- SMARTGEN_PACKAGE:fg676
--  CLKS:1
--  FIN:40.000000
--  PRIMFREQ:80.000000
--  PDELAYVAL:0 
--  PDELAYSIGN:0
--  PBYPASS:0
--  PPHASESHIFT:0
--  FB:INTERNAL
--  CONF:STATIC

-- _End_Comments_

