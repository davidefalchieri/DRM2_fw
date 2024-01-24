################################################################################
#  SDC WRITER VERSION "3";
#  DESIGN "V1390trm";
#  Timing constraints scenario: "Primary";
#  DATE "Tue Jun 17 12:52:58 2008";
#  VENDOR "Actel";
#  PROGRAM "Actel Designer Software Release v8.3";
#  VERSION "8.3.0.22"  Copyright (C) 1989-2008 Actel Corp. 
################################################################################


set sdc_version 1.7


########  Clock Constraints  ########

create_clock  -name {CLK} -period 25.000 -waveform { 0.000 12.500 }  { CLK  } 

########  Generated Clock Constraints  ########

create_generated_clock -name {clk_tdc}  -source [get_pins {U_ROC32.PLL_tdc_del.Core:CLK}]   -multiply_by 1 -divide_by 1 [get_pins {U_ROC32.PLL_tdc_del.Core:GLB}] 
create_generated_clock -name {clk_sram} -source [get_pins {U_ROC32.PLL_sram_del.Core:CLK}]  -multiply_by 2 -divide_by 1 [get_pins {U_ROC32.PLL_sram_del.Core:GLB}] 


########  Input Delay Constraints  ########

set_input_delay  -max 20.000 -clock { CLK } { DTE[0] DTE[10] DTE[11] DTE[12] DTE[13] DTE[14] DTE[15] DTE[16] DTE[17] DTE[18] DTE[19] DTE[1] DTE[20] DTE[21] DTE[22] DTE[23] DTE[24] DTE[25] DTE[26] DTE[27] DTE[28] DTE[29] DTE[2] DTE[30] DTE[31] DTE[3] DTE[4] DTE[5] DTE[6] DTE[7] DTE[8] DTE[9] }
set_input_delay  -max 20.000 -clock { CLK } { DTO[0] DTO[10] DTO[11] DTO[12] DTO[13] DTO[14] DTO[15] DTO[16] DTO[17] DTO[18] DTO[19] DTO[1] DTO[20] DTO[21] DTO[22] DTO[23] DTO[24] DTO[25] DTO[26] DTO[27] DTO[28] DTO[29] DTO[2] DTO[30] DTO[31] DTO[3] DTO[4] DTO[5] DTO[6] DTO[7] DTO[8] DTO[9] }


########  Output Delay Constraints  ########

set_output_delay  -max 16.000 -clock { CLK } { ADE[0] ADE[10] ADE[11] ADE[12] ADE[13] ADE[14] ADE[15] ADE[1] ADE[2] ADE[3] ADE[4] ADE[5] ADE[6] ADE[7] ADE[8] ADE[9] }
set_output_delay  -max 16.000 -clock { CLK } { ADO[0] ADO[10] ADO[11] ADO[12] ADO[13] ADO[14] ADO[15] ADO[1] ADO[2] ADO[3] ADO[4] ADO[5] ADO[6] ADO[7] ADO[8] ADO[9] }
set_output_delay  -max 6.000  -clock { CLK } { DTE[0] DTE[10] DTE[11] DTE[12] DTE[13] DTE[14] DTE[15] DTE[16] DTE[17] DTE[18] DTE[19] DTE[1] DTE[20] DTE[21] DTE[22] DTE[23] DTE[24] DTE[25] DTE[26] DTE[27] DTE[28] DTE[29] DTE[2] DTE[30] DTE[31] DTE[3] DTE[4] DTE[5] DTE[6] DTE[7] DTE[8] DTE[9] }
set_output_delay  -max 6.000  -clock { CLK } { DTO[0] DTO[10] DTO[11] DTO[12] DTO[13] DTO[14] DTO[15] DTO[16] DTO[17] DTO[18] DTO[19] DTO[1] DTO[20] DTO[21] DTO[22] DTO[23] DTO[24] DTO[25] DTO[26] DTO[27] DTO[28] DTO[29] DTO[2] DTO[30] DTO[31] DTO[3] DTO[4] DTO[5] DTO[6] DTO[7] DTO[8] DTO[9] }

set_output_delay  -max 11.000 -clock { CLK } { NOESRAME NOESRAMO }
set_output_delay  -clock_fall  -max 7.000 -clock { clk_sram } { NWRSRAME NWRSRAMO }


########   False Path Constraints  ########

# i bit di MIC_REG sono statici durante l'acquisizione
# segnali della sram_write_fsm
set_false_path -from [get_pins { U_ROC32.MIC_REG* }] -to [get_pins { U_ROC32.* }]	


#set_false_path -from [get_pins { U_ROC32.MIC_REG* }] -to [get_pins {U_ROC32.STATE2*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/DTE*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/DTO*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/WREi*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/WROi*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/TEMPF*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/DT_TEMP*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/ENDF*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/WOFFSET*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/EVNT_WORD*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/CRC32*} ]	

#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/U_sram_write_fsm.chaina_evnt_word*} ]	
#set_false_path -from [get_pins { U_ROC32/MIC_REG* }] -to [get_pins {U_ROC32/U_sram_write_fsm.chainb_evnt_word*} ]	


