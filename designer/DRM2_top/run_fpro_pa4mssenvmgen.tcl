set_device \
    -fam IGLOO2 \
    -die PA4MGL7500 \
    -pkg fg676
set_serdesif0_reg \
	-path {E:/alicetof/firmware/DRM2_rev2.0/DRM2_Zvtwelfth_fw/component/work/EPCS_SERDES_IF/EPCS_SERDES_IF_0/SERDESIF_0_init.reg}
set_output_efc \
    -path {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\DRM2_top.efc}
set_proj_dir \
    -path {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw}
set_is_relative_path \
    -value {FALSE}
set_root_path_dir \
    -path {}
gen_prg -use_init true
