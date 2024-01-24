open_project -project {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\DRM2_top_fp\DRM2_top.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2GL090T} \
    -fpga {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\DRM2_top.map} \
    -header {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\DRM2_top.hdr} \
    -envm {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\DRM2_top.efc} \
    -spm {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\DRM2_top.spm} \
    -dca {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\DRM2_top.dca}
export_single_stapl \
    -name {M2GL090T} \
    -file {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\export\DRM2_20230413.stp} \
    -secured

export_single_dat \
    -name {M2GL090T} \
    -file {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\export\DRM2_20230413.dat} \
    -secured

save_project
close_project
