# Synopsys, Inc. constraint file
# E:/Annalisa/work/V1390/FPGA/implement/v1390trm/synthesis/V1390trm_syn.sdc
# Written on Fri Jul 05 11:48:36 2013
# by Synplify Pro, E-2010.09A-1 Scope Editor

#
# Collections
#

#
# Clocks
#
define_clock   {CLK} -name {CLK}  -freq 40 -clockgroup default_clkgroup_0
define_clock   {n:U_ROC32.PLL_tdc_del.GLB} -name {CLK_tdc}  -freq 40 -clockgroup default_clkgroup_2
define_clock   {n:U_ROC32.PLL_sram_del.GLB} -name {CLK_sram}  -freq 80 -clockgroup default_clkgroup_1
define_clock   {MWOK} -name {MWOK}  -freq 10 -clockgroup default_clkgroup_3
define_clock   {MROK} -name {MROK}  -freq 10 -clockgroup default_clkgroup_4
define_clock   {ASB} -name {ASB}  -freq 10 -clockgroup default_clkgroup_5

#
# Clock to Clock
#

#
# Inputs/Outputs
#
define_output_delay              {ADE[15:0]}  16.00 -improve 0.00 -route 0.00 -ref {CLK:r}
define_output_delay              {ADO[15:0]}  16.00 -improve 0.00 -route 0.00 -ref {CLK:r}
define_input_delay               {DTE[31:0]}  20.00 -improve 0.00 -route 0.00 -ref {CLK:r}
define_output_delay              {DTE[31:0]}  6.00 -improve 0.00 -route 0.00 -ref {CLK:r}
define_input_delay               {DTO[31:0]}  20.00 -improve 0.00 -route 0.00 -ref {CLK:r}
define_output_delay              {DTO[31:0]}  6.00 -improve 0.00 -route 0.00 -ref {CLK:r}
define_output_delay              {NWRSRAME}  7.00 -improve 0.00 -route 0.00 -ref {CLK_sram:f}
define_output_delay              {NWRSRAMO}  7.00 -improve 0.00 -route 0.00 -ref {CLK_sram:f}
define_output_delay              {NOESRAME}  11.00 -improve 0.00 -route 0.00 -ref {CLK:r}
define_output_delay              {NOESRAMO}  11.00 -improve 0.00 -route 0.00 -ref {CLK:r}

#
# Registers
#

#
# Delay Paths
#
define_false_path  -comment {bit comunicati dal micro: sono statici durante l'acquisizione}  -from {{i:U_ROC32.MIC_REG*}}  -to {{i:U_ROC32.PIPE1_DT[31:0]}} 
define_false_path  -from {{i:U_ROC32.MIC_REG*}}  -to {{i:U_ROC32.NWPIPE1}} 
define_false_path  -from {{i:U_ROC32.MIC_REG*}}  -to {{i:U_ROC32.END_EVNT1}} 
define_false_path  -from {{i:U_ROC32.MIC_REG*}}  -to {{p:DTE[31:0]}} 
define_false_path  -from {{i:U_ROC32.MIC_REG*}}  -to {{p:DTO[31:0]}} 
define_false_path  -from {{i:U_ROC32.MIC_REG*}}  -to {{i:U_ROC32.RAMAD1[17:0]}} 
define_false_path  -from {{i:U_VINTERF.CONTROL1[7:0]}} 
define_false_path  -from {{i:U_VINTERF.CONTROL2[7:0]}} 
define_false_path  -from {{i:U_VINTERF.CONTROL3[7:0]}} 

#
# Attributes
#

#
# I/O Standards
#

#
# Compile Points
#

#
# Other
#
