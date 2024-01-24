new_project \
         -name {DRM2_top} \
         -location {C:\telelavoro2020\tof\DRM2_Ztenth_fw_trm_12.4\designer\DRM2_top\DRM2_top_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {M2GL090T} \
         -name {M2GL090T}
enable_device \
         -name {M2GL090T} \
         -enable {TRUE}
save_project
close_project
