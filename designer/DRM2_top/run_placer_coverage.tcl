set_family {IGLOO2}
read_adl {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Ztenth_fw_trm_12.5\designer\DRM2_top\DRM2_top.adl}
read_afl {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Ztenth_fw_trm_12.5\designer\DRM2_top\DRM2_top.afl}
map_netlist
read_sdc {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Ztenth_fw_trm_12.5\constraint\DRM2_top_derived_constraints.sdc}
check_constraints -ignore_errors {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Ztenth_fw_trm_12.5\designer\DRM2_top\placer_coverage.log}
write_sdc -strict -afl {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Ztenth_fw_trm_12.5\designer\DRM2_top\place_route.sdc}
