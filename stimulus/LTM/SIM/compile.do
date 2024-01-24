set LibName work
# Source path
set VX1392LibPath "../SRC/vx1392_lib/hdl"

vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/V1392pkg.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/lbspare.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/monostable.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/clk_interf.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/ctrl.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/dac_interf.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/event_fifo.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/fct1bit543.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/fct16543p.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/I2C_interf.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/lvc16244.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/lvt125.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/osc.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/pdl_interf.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/PLL_aclk.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/PLL_lclk.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/reset_mod.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/roc32.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/spi_interf.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/vbuf.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/vinterf.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/v1392ltm.vhd
vcom -work $LibName -87 -explicit -no1164 -quiet -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/VME_Master.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -source -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/vx1392sim.vhd
vcom -work $LibName -93 -explicit -no1164 -quiet -source -nowarn 1 -nowarn 2 -nowarn 3 -nowarn 4 -nowarn 5 $VX1392LibPath/vx1392sim_config.vhd
