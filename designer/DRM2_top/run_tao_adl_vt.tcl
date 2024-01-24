set_device -family {IGLOO2} -die {M2GL090T} -speed {-1}
read_adl {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zueleventh_fw\designer\DRM2_top\DRM2_top.adl}
read_afl {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zueleventh_fw\designer\DRM2_top\DRM2_top.afl}
map_netlist
read_sdc {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zueleventh_fw\constraint\user.sdc}
read_sdc {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zueleventh_fw\constraint\DRM2_top_derived_constraints.sdc}
read_sdc {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zueleventh_fw\constraint\GBTXtest_main_compile.sdc}
read_sdc {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zueleventh_fw\constraint\GBTXtest_main_synthesis.sdc}
check_constraints -ignore_errors {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zueleventh_fw\constraint\timing_sdc_errors.log}
write_sdc -mode smarttime {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zueleventh_fw\designer\DRM2_top\timing_analysis.sdc}
