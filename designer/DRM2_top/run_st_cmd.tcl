read_sdc -scenario "timing_analysis" -netlist "optimized" -pin_separator "/" -ignore_errors {E:/alicetof/firmware/DRM2_rev2.0/DRM2_Zueleventh_fw/designer/DRM2_top/timing_analysis.sdc}
set_options -analysis_scenario "timing_analysis" 
save
