create_timing_netlist
read_sdc
update_timing_netlist;
report_clock_fmax_summary -panel_name "Fmax Summary"
create_timing_summary -setup -panel_name "Summary (Setup)"
create_slack_histogram -clock_name {DPCLK[0]} -num_bins 30 -setup -panel_name {Setup Slack Histogram (DPCLK[0])}
qsta_utility::generate_top_failures_per_clock 200
locate {test:I0|PDL_DELAY_REG[2]} {test:I0|DATAOUT[2]}
report_timing -from_clock [get_clocks {cttm_pll:I1|altpll:altpll_component|_clk0}] -to_clock [get_clocks {DPCLK[0]}] -from {test:I0|PDL_DELAY_REG[2]} -to {test:I0|DATAOUT[2]} -setup -npaths 1 -detail path_only -panel_name "Report Timing"
locate {launch edge time}
qsta_utility::generate_all_io_timing_reports
qsta_utility::generate_all_io_timing_reports
qsta_utility::generate_all_core_timing_reports
qsta_utility::generate_all_histograms
qsta_utility::generate_all_summary_tables
report_ucp -panel_name "Unconstrained Paths"
set_input_delay -clock DPCLK[0] 3 [get_ports {nLBAS nLBCLR nLBCS nLBLAST nLBPCKE nLBPCKR nLBRD nLBRDY nLBRES nLBWAIT}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_false_path -from [get_ports {F_SCK F_SI}] -to *
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
write_sdc "VX1392_TEST.sdc"
reset_design
read_sdc
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_input_delay -clock DPCLK[0] 3 nLBAS
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
read_sdc "VX1392_TEST.sdc"
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_input_delay -add_delay -clock [get_clocks {DPCLK[0]}] 3.000 [get_ports {nLBAS nLBCLR nLBCS nLBLAST nLBPCKE nLBPCKR nLBRD nLBRDY nLBRES nLBWAIT}]
set_input_delay -add_delay -clock [get_clocks {DPCLK[0]}] 3.000 [get_ports {nLBAS nLBCLR nLBCS nLBLAST  nLBRD nLBRES nLBWAIT}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
report_path -from nLBAS -to * -npaths 1 -panel_name "Report Path"
report_timing -to_clock DPCLK[0] -from [get_keepers {nLBAS}] -setup -npaths 1 -detail path_only -panel_name "Report Timing"
locate {test:I0|DATAOUT[26]}
report_clock_transfers -panel_name "Clock Transfers"
report_clocks -panel_name "Clocks Summary"
report_min_pulse_width -nworst 100 -panel_name "Minimum Pulse Width"
report_sdc
report_sdc -ignored -panel_name "Ignored Constraints"
report_sdc -ignored -panel_name "Ignored Constraints"
report_sdc -ignored -panel_name "Ignored Constraints"
report_datasheet -panel_name "Datasheet Report"
check_timing -panel_name "Check Timing"
report_sdc -ignored -panel_name "Ignored Constraints"
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {TRD[0] TRD[1] TRD[2] TRD[3] TRD[4] TRD[5] TRD[6] TRD[7]}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
report_datasheet -panel_name "Datasheet Report"
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {TRM[0] TRM[1] TRM[2] TRM[3] TRM[4] TRM[5] TRM[6] TRM[7] TRM[8] TRM[9] TRM[10] TRM[11] TRM[12] TRM[13] TRM[14] TRM[15] TRM[16] TRM[17] TRM[18] TRM[19] TRM[20] TRM[21] TRM[22] TRM[23]}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
report_path -from test:I0|RDEN_r -to LB[9]
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {SP_CTTM[0] SP_CTTM[1] SP_CTTM[2] SP_CTTM[3] SP_CTTM[4] SP_CTTM[5] SP_CTTM[6]}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {D_CTTM[0] D_CTTM[1] D_CTTM[2] D_CTTM[3] D_CTTM[4] D_CTTM[5] D_CTTM[6] D_CTTM[7] D_CTTM[8] D_CTTM[9] D_CTTM[10] D_CTTM[11] D_CTTM[12] D_CTTM[13] D_CTTM[14] D_CTTM[15] D_CTTM[16] D_CTTM[17] D_CTTM[18] D_CTTM[19] D_CTTM[20] D_CTTM[21] D_CTTM[22] D_CTTM[23]}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {RAMDT[0] RAMDT[1] RAMDT[2] RAMDT[3] RAMDT[4] RAMDT[5] RAMDT[6] RAMDT[7] RAMDT[8] RAMDT[9] RAMDT[10] RAMDT[11] RAMDT[12] RAMDT[13] RAMDT[14] RAMDT[15] RAMDT[16] RAMDT[17] RAMDT[18] RAMDT[19] RAMDT[20] RAMDT[21] RAMDT[22] RAMDT[23] RAMDT[24] RAMDT[25] RAMDT[26] RAMDT[27] RAMDT[28] RAMDT[29] RAMDT[30] RAMDT[31] RAMDT[32] RAMDT[33] RAMDT[34] RAMDT[35] RAMDT[36] RAMDT[37] RAMDT[38] RAMDT[39] RAMDT[40] RAMDT[41] RAMDT[42] RAMDT[43] RAMDT[44] RAMDT[45] RAMDT[46] RAMDT[47]}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_false_path -from [get_ports {RAMDT[0] RAMDT[1] RAMDT[2] RAMDT[3] RAMDT[4] RAMDT[5] RAMDT[6] RAMDT[7] RAMDT[8] RAMDT[9] RAMDT[10] RAMDT[11] RAMDT[12] RAMDT[13] RAMDT[14] RAMDT[15] RAMDT[16] RAMDT[17] RAMDT[18] RAMDT[19] RAMDT[20] RAMDT[21] RAMDT[22] RAMDT[23] RAMDT[24] RAMDT[25] RAMDT[26] RAMDT[27] RAMDT[28] RAMDT[29] RAMDT[30] RAMDT[31] RAMDT[32] RAMDT[33] RAMDT[34] RAMDT[35] RAMDT[36] RAMDT[37] RAMDT[38] RAMDT[39] RAMDT[40] RAMDT[41] RAMDT[42] RAMDT[43] RAMDT[44] RAMDT[45] RAMDT[46] RAMDT[47]}] -to [get_clocks {DPCLK[0]}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports *RAMAD*]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_false_path -from [get_clocks {DPCLK[0]}] -to [get_ports {LBSP[0] LBSP[1] LBSP[2] LBSP[3] LBSP[4] LBSP[5] LBSP[6] LBSP[7] LBSP[8] LBSP[9] LBSP[10] LBSP[11] LBSP[12] LBSP[13] LBSP[14] LBSP[15] LBSP[16] LBSP[17] LBSP[18] LBSP[19] LBSP[20] LBSP[21] LBSP[22] LBSP[23] LBSP[24] LBSP[25] LBSP[26] LBSP[27] LBSP[28] LBSP[29] LBSP[30] LBSP[31]}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_false_path -from [get_ports {LBSP[0] LBSP[1] LBSP[2] LBSP[3] LBSP[4] LBSP[5] LBSP[6] LBSP[7] LBSP[8] LBSP[9] LBSP[10] LBSP[11] LBSP[12] LBSP[13] LBSP[14] LBSP[15] LBSP[16] LBSP[17] LBSP[18] LBSP[19] LBSP[20] LBSP[21] LBSP[22] LBSP[23] LBSP[24] LBSP[25] LBSP[26] LBSP[27] LBSP[28] LBSP[29] LBSP[30] LBSP[31]}] -to [get_clocks {DPCLK[0]}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
report_datasheet -panel "Datasheet Report" 
set_false_path -from [get_clocks {SCLK}] -to *
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
report_datasheet -panel "Datasheet Report" 
set_false_path -from [get_clocks *] -to [get_ports {D_CTTM[0] D_CTTM[1] D_CTTM[2] D_CTTM[3] D_CTTM[4] D_CTTM[5] D_CTTM[6] D_CTTM[7] D_CTTM[8] D_CTTM[9] D_CTTM[10] D_CTTM[11] D_CTTM[12] D_CTTM[13] D_CTTM[14] D_CTTM[15] D_CTTM[16] D_CTTM[17] D_CTTM[18] D_CTTM[19] D_CTTM[20] D_CTTM[21] D_CTTM[22] D_CTTM[23]}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
report_clock_transfers -panel_name "Clock Transfers"
report_clocks -panel_name "Clocks Summary"
create_generated_clock -name CLK_CTTM -master_clock SCLK -source I1|altpll_component|pll|inclk[0] -divide_by 1 -multiply_by 1  I1|altpll_component|pll|extclk[0] 
create_generated_clock -name CLK_TEST -master_clock SCLK -source I1|altpll_component|pll|inclk[0] -divide_by 2 -multiply_by 15  I1|altpll_component|pll|clk[0] 
set_false_path -from [get_ports *OR_DEL*] -to [get_clocks {cttm_pll:I1|altpll:altpll_component|_extclk0}]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_input_delay -clock DPCLK[0] 5 [get_ports *OR_DEL*]
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
set_false_path -through * -to *TST*
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
report_clocks -panel_name "Clocks Summary"
report_path -from * -to SCLK -npaths 1 -panel_name "Report Path"
update_timing_netlist;
report_ucp -panel_name "Unconstrained Paths"
