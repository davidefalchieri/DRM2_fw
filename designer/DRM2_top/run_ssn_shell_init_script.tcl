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
set_def {PLL_SUPPLY} {PLL_SUPPLY_25}
set_netlist -afl {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Ztenth_fw_trm_12.5\designer\DRM2_top\DRM2_top.afl} -adl {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Ztenth_fw_trm_12.5\designer\DRM2_top\DRM2_top.adl}
set_constraints   {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Ztenth_fw_trm_12.5\designer\DRM2_top\DRM2_top.tcml}
set_placement   {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Ztenth_fw_trm_12.5\designer\DRM2_top\DRM2_top.loc}
set_routing     {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Ztenth_fw_trm_12.5\designer\DRM2_top\DRM2_top.seg}
