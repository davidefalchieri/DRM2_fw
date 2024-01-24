read_sdc -scenario "place_and_route" -netlist "optimized" -pin_separator "/" -ignore_errors {E:/alicetof/firmware/DRM2_rev2.0/DRM2_Zvtwelfth_fw/designer/DRM2_top/place_route.sdc}
set_options -tdpr_scenario "place_and_route" 
save
set_options -analysis_scenario "place_and_route"
report -type combinational_loops -format xml {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\DRM2_top_layout_combinational_loops.xml}
report -type slack {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\pinslacks.txt}
set coverage [report \
    -type     constraints_coverage \
    -format   xml \
    -slacks   no \
    {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\DRM2_top_place_and_route_constraint_coverage.xml}]
set reportfile {E:\alicetof\firmware\DRM2_rev2.0\DRM2_Zvtwelfth_fw\designer\DRM2_top\coverage_placeandroute}
set fp [open $reportfile w]
puts $fp $coverage
close $fp