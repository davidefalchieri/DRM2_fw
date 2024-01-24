# Microsemi Corp.
# Date: 2023-Apr-13 16:13:10
# This file was generated based on the following SDC source files:
#   E:/alicetof/firmware/DRM2_rev2.0/DRM2_Zvtwelfth_fw/component/work/EPCS_Demo_sb/CCC_0/EPCS_Demo_sb_CCC_0_FCCC.sdc
#   C:/Microsemi/Libero_SoC_v2021.3/Designer/data/aPA4M/cores/constraints/PA4M7500/coreconfigp.sdc
#   C:/Microsemi/Libero_SoC_v2021.3/Designer/data/aPA4M/cores/constraints/coreresetp.sdc
#   E:/alicetof/firmware/DRM2_rev2.0/DRM2_Zvtwelfth_fw/component/work/EPCS_Demo_sb_HPMS/EPCS_Demo_sb_HPMS.sdc
#   E:/alicetof/firmware/DRM2_rev2.0/DRM2_Zvtwelfth_fw/component/work/EPCS_Demo_sb/FABOSC_0/EPCS_Demo_sb_FABOSC_0_OSC.sdc
#   E:/alicetof/firmware/DRM2_rev2.0/DRM2_Zvtwelfth_fw/component/work/EPCS_SERDES_IF/EPCS_SERDES_IF_0/EPCS_SERDES_IF_EPCS_SERDES_IF_0_SERDES_IF2.sdc
#   C:/Microsemi/Libero_SoC_v2021.3/Designer/data/aPA4M/cores/constraints/sysreset.sdc
#

create_clock -name {EPCS_Demo_instance/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT} -period 20 [ get_pins { EPCS_Demo_instance/FABOSC_0/I_RCOSC_25_50MHZ/CLKOUT } ]
create_clock -name {EPCS_Demo_instance/EPCS_Demo_sb_HPMS_0/CLK_CONFIG_APB} -period 200 [ get_pins { EPCS_Demo_instance/EPCS_Demo_sb_HPMS_0/MSS_ADLIB_INST/CLK_CONFIG_APB } ]
create_clock -name {CAEN_LINK_instance/I_EPCS_SERDES/EPCS_SERDES_IF_0/EPCS_SERDES_IF_0/SERDESIF_INST/EPCS_RXCLK_0} -period 8 [ get_pins { CAEN_LINK_instance/I_EPCS_SERDES/EPCS_SERDES_IF_0/EPCS_SERDES_IF_0/SERDESIF_INST/EPCS_RXCLK_0 } ]
create_clock -name {CAEN_LINK_instance/I_EPCS_SERDES/EPCS_SERDES_IF_0/EPCS_SERDES_IF_0/SERDESIF_INST/EPCS_TXCLK_0} -period 8 [ get_pins { CAEN_LINK_instance/I_EPCS_SERDES/EPCS_SERDES_IF_0/EPCS_SERDES_IF_0/SERDESIF_INST/EPCS_TXCLK_0 } ]
create_clock -name {CAEN_LINK_instance/I_EPCS_SERDES/EPCS_SERDES_IF_0/EPCS_SERDES_IF_0/SERDESIF_INST/EPCS_RXCLK[0]} -period 8 [ get_pins { CAEN_LINK_instance/I_EPCS_SERDES/EPCS_SERDES_IF_0/EPCS_SERDES_IF_0/SERDESIF_INST/EPCS_RXCLK[0] } ]
create_clock -name {CAEN_LINK_instance/I_EPCS_SERDES/EPCS_SERDES_IF_0/EPCS_SERDES_IF_0/SERDESIF_INST/EPCS_TXCLK[0]} -period 8 [ get_pins { CAEN_LINK_instance/I_EPCS_SERDES/EPCS_SERDES_IF_0/EPCS_SERDES_IF_0/SERDESIF_INST/EPCS_TXCLK[0] } ]
create_generated_clock -name {EPCS_Demo_instance/CCC_0/GL0} -multiply_by 4 -divide_by 10 -source [ get_pins { EPCS_Demo_instance/CCC_0/CCC_INST/RCOSC_25_50MHZ } ] -phase 0 [ get_pins { EPCS_Demo_instance/CCC_0/CCC_INST/GL0 } ]
create_generated_clock -name {EPCS_Demo_instance/CCC_0/GL1} -multiply_by 4 -divide_by 5 -source [ get_pins { EPCS_Demo_instance/CCC_0/CCC_INST/RCOSC_25_50MHZ } ] -phase 0 [ get_pins { EPCS_Demo_instance/CCC_0/CCC_INST/GL1 } ]
set_false_path -ignore_errors -through [ get_nets { EPCS_Demo_instance/CORECONFIGP_0/INIT_DONE EPCS_Demo_instance/CORECONFIGP_0/SDIF_RELEASED } ]
set_false_path -ignore_errors -through [ get_nets { EPCS_Demo_instance/CORERESETP_0/ddr_settled EPCS_Demo_instance/CORERESETP_0/count_ddr_enable EPCS_Demo_instance/CORERESETP_0/release_sdif*_core EPCS_Demo_instance/CORERESETP_0/count_sdif*_enable } ]
set_false_path -ignore_errors -from [ get_cells { EPCS_Demo_instance/CORERESETP_0/MSS_HPMS_READY_int } ] -to [ get_cells { EPCS_Demo_instance/CORERESETP_0/sm0_areset_n_rcosc EPCS_Demo_instance/CORERESETP_0/sm0_areset_n_rcosc_q1 } ]
set_false_path -ignore_errors -from [ get_cells { EPCS_Demo_instance/CORERESETP_0/MSS_HPMS_READY_int EPCS_Demo_instance/CORERESETP_0/SDIF*_PERST_N_re } ] -to [ get_cells { EPCS_Demo_instance/CORERESETP_0/sdif*_areset_n_rcosc* } ]
set_false_path -ignore_errors -through [ get_nets { EPCS_Demo_instance/CORERESETP_0/CONFIG1_DONE EPCS_Demo_instance/CORERESETP_0/CONFIG2_DONE EPCS_Demo_instance/CORERESETP_0/SDIF*_PERST_N EPCS_Demo_instance/CORERESETP_0/SDIF*_PSEL EPCS_Demo_instance/CORERESETP_0/SDIF*_PWRITE EPCS_Demo_instance/CORERESETP_0/SDIF*_PRDATA[*] EPCS_Demo_instance/CORERESETP_0/SOFT_EXT_RESET_OUT EPCS_Demo_instance/CORERESETP_0/SOFT_RESET_F2M EPCS_Demo_instance/CORERESETP_0/SOFT_M3_RESET EPCS_Demo_instance/CORERESETP_0/SOFT_MDDR_DDR_AXI_S_CORE_RESET EPCS_Demo_instance/CORERESETP_0/SOFT_FDDR_CORE_RESET EPCS_Demo_instance/CORERESETP_0/SOFT_SDIF*_PHY_RESET EPCS_Demo_instance/CORERESETP_0/SOFT_SDIF*_CORE_RESET EPCS_Demo_instance/CORERESETP_0/SOFT_SDIF0_0_CORE_RESET EPCS_Demo_instance/CORERESETP_0/SOFT_SDIF0_1_CORE_RESET } ]
set_false_path -ignore_errors -through [ get_pins { EPCS_Demo_instance/EPCS_Demo_sb_HPMS_0/MSS_ADLIB_INST/CONFIG_PRESET_N } ]
set_false_path -ignore_errors -through [ get_pins { EPCS_Demo_instance/SYSRESET_POR/POWER_ON_RESET_N } ]
set_max_delay 0 -through [ get_nets { EPCS_Demo_instance/CORECONFIGP_0/FIC_2_APB_M_PSEL EPCS_Demo_instance/CORECONFIGP_0/FIC_2_APB_M_PENABLE } ] -to [ get_cells { EPCS_Demo_instance/CORECONFIGP_0/FIC_2_APB_M_PREADY* EPCS_Demo_instance/CORECONFIGP_0/state[0] } ]
set_min_delay -24 -through [ get_nets { EPCS_Demo_instance/CORECONFIGP_0/FIC_2_APB_M_PWRITE EPCS_Demo_instance/CORECONFIGP_0/FIC_2_APB_M_PADDR[*] EPCS_Demo_instance/CORECONFIGP_0/FIC_2_APB_M_PWDATA[*] EPCS_Demo_instance/CORECONFIGP_0/FIC_2_APB_M_PSEL EPCS_Demo_instance/CORECONFIGP_0/FIC_2_APB_M_PENABLE } ]
