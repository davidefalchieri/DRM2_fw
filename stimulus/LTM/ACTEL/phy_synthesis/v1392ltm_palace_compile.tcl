new_design -name v1392ltm_palace  -family "PA" -path {.}
set_device -die "APA600" -package "676 FBGA" 
import_source -format "edif" -edif_flavor "GENERIC" "v1392ltm_palace.edn"  -format "gcf" v1392ltm_palace.gcf  -format "sdc" v1392ltm_palace.sdc 
set_defvar ENABLE_SHADOWED_FEATURES_FOR_MAGMA 1
compile
layout --no_warn_args-- -place on -place_incremental off -route_incremental off -timing_driven 
export -format "log" v1392ltm_palace.log 
report -type "timer" -sortby "actual" -maxpaths "1000" -case "worst" -path_selection "critical" -setup_hold "off" -expand_failed "off" -clkpinbreak "on" -clrpinbreak "on" -latchdatapinbreak "on" -slack v1392ltm_palace.rpt 
save_design v1392ltm_palace.adb 