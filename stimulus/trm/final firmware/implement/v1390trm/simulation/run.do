quietly set ACTELLIBNAME apa
quietly set PROJECT_DIR "E:/Annalisa/work/V1390/FPGA/implement/v1390trm"

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   vlib presynth
}
vmap presynth presynth
vmap apa "C:/Actel/Libero_v9.1/Designer/lib/modelsim/precompiled/vhdl/apa"

vcom -93 -explicit -work presynth "${PROJECT_DIR}/hdl/V1390pkg.vhd"
vcom -93 -explicit -work presynth "${PROJECT_DIR}/hdl/I2C_interf.vhd"
vcom -93 -explicit -work presynth "${PROJECT_DIR}/hdl/leading_flush.vhd"
vcom -93 -explicit -work presynth "${PROJECT_DIR}/hdl/reset_mod.vhd"
vcom -93 -explicit -work presynth "${PROJECT_DIR}/smartgen/PLL_tdc/PLL_tdc.vhd"
vcom -93 -explicit -work presynth "${PROJECT_DIR}/smartgen/LEAD_SRAM/LEAD_SRAM.vhd"
vcom -93 -explicit -work presynth "${PROJECT_DIR}/smartgen/PLL_sram/PLL_sram.vhd"
vcom -93 -explicit -work presynth "${PROJECT_DIR}/hdl/roc32.vhd"
vcom -93 -explicit -work presynth "${PROJECT_DIR}/hdl/spi_interf.vhd"
vcom -93 -explicit -work presynth "${PROJECT_DIR}/hdl/vinterf.vhd"
vcom -93 -explicit -work presynth "${PROJECT_DIR}/hdl/v1390trm.vhd"

vsim -L apa -L presynth  -t 1ps presynth.V1390trm
# The following lines are commented because no testbench is associated with the project
# add wave /testbench/*
# run 1000ns
