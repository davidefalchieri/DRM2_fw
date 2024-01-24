set_defvar -name {SPEED}   -value {-1}
set_defvar -name {VOLTAGE} -value {1.2}
set_defvar -name {TEMPR}   -value {COM}
set_defvar -name {PART_RANGE}   -value {COM}
set_defvar -name {IO_DEFT_STD} -value {LVCMOS25}
set_defvar -name {PACOMP_PARPT_MAX_NET} -value {10}
set_defvar -name {PA4_GB_MAX_RCLKINT_INSERTION} -value {16}
set_defvar -name {PA4_GB_MIN_GB_FANOUT_TO_USE_RCLKINT} -value {300}
set_defvar -name {PA4_GB_MAX_FANOUT_DATA_MOVE} -value {5000}
set_defvar -name {PA4_GB_HIGH_FANOUT_THRESHOLD} -value {5000}
set_defvar -name {PA4_GB_COUNT} -value {16}
set_defvar -name {RESTRICTPROBEPINS} -value {0}
set_defvar -name {RESTRICTSPIPINS} -value {0}
set_defvar -name {PDC_IMPORT_HARDERROR} -value {1}
set_defvar -name {PA4_IDDQ_FF_FIX} -value {1}
set_defvar -name {BLOCK_PLACEMENT_CONFLICTS} -value {ERROR}
set_defvar -name {BLOCK_ROUTING_CONFLICTS} -value {LOCK}
set_defvar -name {RTG4_MITIGATION_ON} -value {0}
set_defvar -name {USE_CONSTRAINT_FLOW} -value True
set_defvar -name {FHB_AUTO_INSTANTIATION} -value {0}

set_compile_info \
    -category {"Device Selection"} \
    -name {"Family"} \
    -value {"IGLOO2"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"Device"} \
    -value {"M2GL090T"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"Package"} \
    -value {"676 FBGA"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"Speed Grade"} \
    -value {"-1"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"Temp"} \
    -value {"0:25:85"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"Voltage"} \
    -value {"1.26:1.20:1.14"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"Core Voltage"} \
    -value {"1.2V"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"Ramp Rate"} \
    -value {"100ms Minimum"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"System Controller Suspend Mode"} \
    -value {"No"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"PLL Supply Voltage"} \
    -value {"2.5V"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"Default I/O technology"} \
    -value {"LVCMOS 2.5V"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"Restrict Probe Pins"} \
    -value {"No"}
set_compile_info \
    -category {"Device Selection"} \
    -name {"Restrict SPI Pins"} \
    -value {"No"}
set_compile_info \
    -category {"Source Files"} \
    -name {"Topcell"} \
    -value {"DRM2_top"}
set_compile_info \
    -category {"Source Files"} \
    -name {"Format"} \
    -value {"EDIF"}
set_compile_info \
    -category {"Source Files"} \
    -name {"Source"} \
    -value {"E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\synthesis\synthesis_idc\DRM2_top.edn"}
set_compile_info \
    -category {"Source Files"} \
    -name {"Source"} \
    -value {"E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\constraint\netlist_attrib.ndc"}
set_compile_info \
    -category {"Options"} \
    -name {"Enable Single Event Transient mitigation"} \
    -value {"false"}
set_compile_info \
    -category {"Options"} \
    -name {"Enable Design Separation Methodology"} \
    -value {"false"}
set_compile_info \
    -category {"Options"} \
    -name {"Limit the number of high fanout nets to display to"} \
    -value {"10"}
compile \
    -desdir {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top} \
    -design DRM2_top \
    -fam IGLOO2 \
    -die PA4MGL7500 \
    -pkg fg676 \
    -pdc_file {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\constraint\netlist_attrib.ndc} \
    -merge_pdc 0
