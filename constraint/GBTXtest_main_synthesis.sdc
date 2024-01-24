# APB CONFIG CLOCK
#create_clock -name {CLK_CONFIG_APB} -period 20 -waveform {0 10 } -add  [ get_nets { EPCS_Demo_INIT_APB_S_PCLK } ]
# GBTx clock
# create_clock -name {FPGACK40} -period 25 -waveform {0 12.5 } -add  [ get_ports { FPGACK40_P } ]
# Clocks for Lanes 0 and 2
#create_clock -name {tx_clk} -period 8 -waveform {0 4 } -add  [ get_nets { CAEN_LINK_instance/EPCS_SERDES_Lane0_TX_CLK } ]
#create_clock -name {rx_clk} -period 8 -waveform {0 4 } -add  [ get_nets { CAEN_LINK_instance/EPCS_SERDES_Lane0_RX_CLK } ]
