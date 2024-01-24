## Generated SDC file "VX1392_TEST.sdc"

## Copyright (C) 1991-2007 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 7.0 Build 33 02/05/2007 SJ Full Version"

## DATE    "Mon Dec 03 12:14:45 2007"

##
## DEVICE  "EP1C20F400C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name SCLK -period 25.000 -waveform { 0.000 12.500 } [get_ports {SCLK}] 
create_clock -name DPCLK[0] -period 25.000 -waveform { 0.000 12.500 } [get_ports {DPCLK[0]}] 
create_clock -name DPCLK[2] -period 25.000 -waveform { 0.000 12.500 } [get_ports {DPCLK[2]}] 
create_clock -name DPCLK[5] -period 25.000 -waveform { 0.000 12.500 } [get_ports {DPCLK[5]}] 
create_clock -name DPCLK[1] -period 25.000 -waveform { 0.000 12.500 } [get_ports {DPCLK[1]}] 
create_clock -name DPCLK[6] -period 25.000 -waveform { 0.000 12.500 } [get_ports {DPCLK[6]}] 
create_clock -name DPCLK[7] -period 25.000 -waveform { 0.000 12.500 } [get_ports {DPCLK[7]}] 
create_clock -name DPCLK[3] -period 25.000 -waveform { 0.000 12.500 } [get_ports {DPCLK[3]}] 
create_clock -name DPCLK[4] -period 25.000 -waveform { 0.000 12.500 } [get_ports {DPCLK[4]}] 


#**************************************************************
# Create Generated Clock
#**************************************************************
create_generated_clock -name cttm_pll:I1|altpll:altpll_component|_clk0 -source [get_pins {I1|altpll_component|pll|inclk[0]}] -multiply_by 15 -divide_by 2 -master_clock SCLK [get_pins {I1|altpll_component|pll|clk[0]}]
create_generated_clock -name cttm_pll:I1|altpll:altpll_component|_extclk0 -source [get_pins {I1|altpll_component|pll|inclk[0]}] -master_clock SCLK [get_pins {I1|altpll_component|pll|extclk[0]}]


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -clock [get_clocks {DPCLK[0]}] 20.000 [get_ports {nLBAS nLBCLR nLBCS nLBLAST  nLBRD nLBRES nLBWAIT}]
set_input_delay -add_delay -clock [get_clocks {DPCLK[0]}] 20.000 [get_ports {nLBAS nLBCLR nLBCS nLBLAST nLBPCKE nLBPCKR nLBRD nLBRDY nLBRES nLBWAIT}]
set_input_delay -add_delay -clock [get_clocks {DPCLK[0]}] 20.000 [get_ports {LB[0] LB[1] LB[2] LB[3] LB[4] LB[5] LB[6] LB[7] LB[8] LB[9] LB[10] LB[11] LB[12] LB[13] LB[14] LB[15] LB[16] LB[17] LB[18] LB[19] LB[20] LB[21] LB[22] LB[23] LB[24] LB[25] LB[26] LB[27] LB[28] LB[29] LB[30] LB[31] nLBAS nLBCLR nLBCS nLBLAST nLBPCKE nLBPCKR nLBRD nLBRDY nLBRES nLBWAIT}]
set_input_delay -add_delay -clock [get_clocks {DPCLK[0]}] 5.000 [get_ports {*OR_DEL*}]
set_input_delay -add_delay -clock [get_clocks {DPCLK[0]}] 5.000 [get_ports {PULSE_TOGGLE}]
set_input_delay -add_delay -clock [get_clocks {DPCLK[0]}] 5.000 [get_ports {LBSP[0] LBSP[1] LBSP[2] LBSP[3] LBSP[4] LBSP[5] LBSP[6] LBSP[7] LBSP[8] LBSP[9] LBSP[10] LBSP[11] LBSP[12] LBSP[13] LBSP[14] LBSP[15] LBSP[16] LBSP[17] LBSP[18] LBSP[19] LBSP[20] LBSP[21] LBSP[22] LBSP[23] LBSP[24] LBSP[25] LBSP[26] LBSP[27] LBSP[28] LBSP[29] LBSP[30] LBSP[31]}]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -clock [get_clocks {DPCLK[0]}] 20.000 [get_ports {LB[0] LB[1] LB[2] LB[3] LB[4] LB[5] LB[6] LB[7] LB[8] LB[9] LB[10] LB[11] LB[12] LB[13] LB[14] LB[15] LB[16] LB[17] LB[18] LB[19] LB[20] LB[21] LB[22] LB[23] LB[24] LB[25] LB[26] LB[27] LB[28] LB[29] LB[30] LB[31] nLBAS nLBCLR nLBCS nLBLAST nLBPCKE nLBPCKR nLBRD nLBRDY nLBRES nLBWAIT}]
set_output_delay -add_delay -clock [get_clocks {DPCLK[0]}] 5.000 [get_ports {LBSP[0] LBSP[1] LBSP[2] LBSP[3] LBSP[4] LBSP[5] LBSP[6] LBSP[7] LBSP[8] LBSP[9] LBSP[10] LBSP[11] LBSP[12] LBSP[13] LBSP[14] LBSP[15] LBSP[16] LBSP[17] LBSP[18] LBSP[19] LBSP[20] LBSP[21] LBSP[22] LBSP[23] LBSP[24] LBSP[25] LBSP[26] LBSP[27] LBSP[28] LBSP[29] LBSP[30] LBSP[31] LB[0] LB[1] LB[2] LB[3] LB[4] LB[5] LB[6] LB[7] LB[8] LB[9] LB[10] LB[11] LB[12] LB[13] LB[14] LB[15] LB[16] LB[17] LB[18] LB[19] LB[20] LB[21] LB[22] LB[23] LB[24] LB[25] LB[26] LB[27] LB[28] LB[29] LB[30] LB[31] nLBAS nLBCLR nLBCS nLBLAST nLBPCKE nLBPCKR nLBRD nLBRDY nLBRES nLBWAIT}]
set_output_delay -add_delay -clock [get_clocks {DPCLK[0]}] 5.000 [get_ports {LTM_LOCAL_TRG}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_ports {F_SCK F_SI}] -to [get_keepers *]
set_false_path -from [get_ports {F_SCK F_SI}] -to [get_keepers *]
set_false_path -from [get_ports {F_SCK F_SI}] -to [get_keepers *]
set_false_path -from [get_ports {F_SCK F_SI}] -to [get_keepers *]
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {TRD[0] TRD[1] TRD[2] TRD[3] TRD[4] TRD[5] TRD[6] TRD[7]}]
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {TRM[0] TRM[1] TRM[2] TRM[3] TRM[4] TRM[5] TRM[6] TRM[7] TRM[8] TRM[9] TRM[10] TRM[11] TRM[12] TRM[13] TRM[14] TRM[15] TRM[16] TRM[17] TRM[18] TRM[19] TRM[20] TRM[21] TRM[22] TRM[23]}]
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {SP_CTTM[0] SP_CTTM[1] SP_CTTM[2] SP_CTTM[3] SP_CTTM[4] SP_CTTM[5] SP_CTTM[6]}]
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {D_CTTM[0] D_CTTM[1] D_CTTM[2] D_CTTM[3] D_CTTM[4] D_CTTM[5] D_CTTM[6] D_CTTM[7] D_CTTM[8] D_CTTM[9] D_CTTM[10] D_CTTM[11] D_CTTM[12] D_CTTM[13] D_CTTM[14] D_CTTM[15] D_CTTM[16] D_CTTM[17] D_CTTM[18] D_CTTM[19] D_CTTM[20] D_CTTM[21] D_CTTM[22] D_CTTM[23]}]
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {RAMDT[0] RAMDT[1] RAMDT[2] RAMDT[3] RAMDT[4] RAMDT[5] RAMDT[6] RAMDT[7] RAMDT[8] RAMDT[9] RAMDT[10] RAMDT[11] RAMDT[12] RAMDT[13] RAMDT[14] RAMDT[15] RAMDT[16] RAMDT[17] RAMDT[18] RAMDT[19] RAMDT[20] RAMDT[21] RAMDT[22] RAMDT[23] RAMDT[24] RAMDT[25] RAMDT[26] RAMDT[27] RAMDT[28] RAMDT[29] RAMDT[30] RAMDT[31] RAMDT[32] RAMDT[33] RAMDT[34] RAMDT[35] RAMDT[36] RAMDT[37] RAMDT[38] RAMDT[39] RAMDT[40] RAMDT[41] RAMDT[42] RAMDT[43] RAMDT[44] RAMDT[45] RAMDT[46] RAMDT[47]}]
set_false_path -from [get_ports {RAMDT[0] RAMDT[1] RAMDT[2] RAMDT[3] RAMDT[4] RAMDT[5] RAMDT[6] RAMDT[7] RAMDT[8] RAMDT[9] RAMDT[10] RAMDT[11] RAMDT[12] RAMDT[13] RAMDT[14] RAMDT[15] RAMDT[16] RAMDT[17] RAMDT[18] RAMDT[19] RAMDT[20] RAMDT[21] RAMDT[22] RAMDT[23] RAMDT[24] RAMDT[25] RAMDT[26] RAMDT[27] RAMDT[28] RAMDT[29] RAMDT[30] RAMDT[31] RAMDT[32] RAMDT[33] RAMDT[34] RAMDT[35] RAMDT[36] RAMDT[37] RAMDT[38] RAMDT[39] RAMDT[40] RAMDT[41] RAMDT[42] RAMDT[43] RAMDT[44] RAMDT[45] RAMDT[46] RAMDT[47]}] -to [get_clocks {DPCLK[0]}]
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {*RAMAD*}]
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {LBSP[0] LBSP[1] LBSP[2] LBSP[3] LBSP[4] LBSP[5] LBSP[6] LBSP[7] LBSP[8] LBSP[9] LBSP[10] LBSP[11] LBSP[12] LBSP[13] LBSP[14] LBSP[15] LBSP[16] LBSP[17] LBSP[18] LBSP[19] LBSP[20] LBSP[21] LBSP[22] LBSP[23] LBSP[24] LBSP[25] LBSP[26] LBSP[27] LBSP[28] LBSP[29] LBSP[30] LBSP[31]}]
set_false_path -from [get_ports {LBSP[0] LBSP[1] LBSP[2] LBSP[3] LBSP[4] LBSP[5] LBSP[6] LBSP[7] LBSP[8] LBSP[9] LBSP[10] LBSP[11] LBSP[12] LBSP[13] LBSP[14] LBSP[15] LBSP[16] LBSP[17] LBSP[18] LBSP[19] LBSP[20] LBSP[21] LBSP[22] LBSP[23] LBSP[24] LBSP[25] LBSP[26] LBSP[27] LBSP[28] LBSP[29] LBSP[30] LBSP[31]}] -to [get_clocks {DPCLK[0]}]
set_false_path -from [get_clocks {SCLK}] -to [get_clocks *]
set_false_path -from [get_clocks *] -to [get_ports {D_CTTM[0] D_CTTM[1] D_CTTM[2] D_CTTM[3] D_CTTM[4] D_CTTM[5] D_CTTM[6] D_CTTM[7] D_CTTM[8] D_CTTM[9] D_CTTM[10] D_CTTM[11] D_CTTM[12] D_CTTM[13] D_CTTM[14] D_CTTM[15] D_CTTM[16] D_CTTM[17] D_CTTM[18] D_CTTM[19] D_CTTM[20] D_CTTM[21] D_CTTM[22] D_CTTM[23]}]
set_false_path -from [get_ports {*OR_DEL*}] -to [get_clocks {cttm_pll:I1|altpll:altpll_component|_extclk0}]
set_false_path  -through [get_pins *] -to [get_keepers {*TST*}]
set_false_path  -through [get_pins *] -to [get_keepers {*RAMDT*}]
set_false_path -from [get_ports {LBSP[0] LBSP[1] LBSP[2] LBSP[3] LBSP[4] LBSP[5] LBSP[6] LBSP[7] LBSP[8] LBSP[9] LBSP[10] LBSP[11] LBSP[12] LBSP[13] LBSP[14] LBSP[15] LBSP[16] LBSP[17] LBSP[18] LBSP[19] LBSP[20] LBSP[21] LBSP[22] LBSP[23] LBSP[24] LBSP[25] LBSP[26] LBSP[27] LBSP[28] LBSP[29] LBSP[30] LBSP[31]}] -to [get_ports *]
set_false_path -from [get_clocks {SCLK}] -to [get_keepers {CLK_CTTM}]
set_false_path -from [get_clocks {SCLK}] -to [get_keepers {CLK_CTTM}]
set_false_path -from [get_ports {SCLK}] -to [get_ports {CLK_CTTM}]
set_false_path -from [get_clocks {cttm_pll:I1|altpll:altpll_component|_clk0}] -to [get_clocks {DPCLK[0]}]
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_clocks {cttm_pll:I1|altpll:altpll_component|_clk0}]

set_false_path -from {nLBRES} -to {test:I0|RDEN_r}
set_false_path -from {nLBRES} -to {test:I0|DATAOUT[0]}
set_false_path -from {nLBRES} -to {test:I0|CTTM_DATA_REG[0]}

# Il pin nLBCS è tenuto sempre basso dal master
set_false_path -from {nLBCS} -to {test:I0|DATAOUT[*]}

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************

