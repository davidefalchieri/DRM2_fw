set_device \
    -family  IGLOO2 \
    -die     PA4MGL7500 \
    -package fg676 \
    -speed   -1 \
    -tempr   {COM} \
    -voltr   {COM}
set_def {VOLTAGE} {1.2}
set_def {VCCI_1.2_VOLTR} {COM}
set_def {VCCI_1.5_VOLTR} {COM}
set_def {VCCI_1.8_VOLTR} {COM}
set_def {VCCI_2.5_VOLTR} {COM}
set_def {VCCI_3.3_VOLTR} {COM}
set_def {RTG4_MITIGATION_ON} {0}
set_def USE_CONSTRAINTS_FLOW 1
set_def NETLIST_TYPE EDIF
set_name DRM2_top
set_workdir {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top}
set_log     {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\DRM2_top_sdc.log}
set_design_state pre_layout
