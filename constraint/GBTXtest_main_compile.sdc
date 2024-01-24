set_false_path -through [ get_nets { CAEN_LINK_instance/EPCS_SERDES_Lane0_RX_RESET_N } ]
set_false_path -through [ get_nets { CAEN_LINK_instance/EPCS_SERDES_Lane0_TX_RESET_N } ]
set_false_path -through { EPCS_Demo_instance/CORERESETP_0/INIT_DONE_int }
set_false_path -through { EPCS_Demo_instance/CORERESETP_0/SDIF_RELEASED_int }
