onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /v1390sim/i1/regs
add wave -noupdate /v1390sim/i1/u_roc32/clear_stat
add wave -noupdate /v1390sim/i1/u_reset_mod/load_res
add wave -noupdate /v1390sim/i1/u_roc32/clk
add wave -noupdate -divider ROC
add wave -noupdate /v1390sim/i1/u_roc32/clk_sram
add wave -noupdate /v1390sim/i1/u_roc32/clk_tdc
add wave -noupdate /v1390sim/i1/u_roc32/l0
add wave -noupdate /v1390sim/i1/u_roc32/l1a
add wave -noupdate /v1390sim/i1/u_roc32/l1r
add wave -noupdate /v1390sim/i1/u_roc32/l2a
add wave -noupdate /v1390sim/i1/u_roc32/l2r
add wave -noupdate /v1390sim/i1/u_roc32/triggers
add wave -noupdate /v1390sim/i1/u_roc32/tdctrgi
add wave -noupdate /v1390sim/i1/u_roc32/tdcda
add wave -noupdate /v1390sim/i1/u_roc32/tdcdrya
add wave -noupdate /v1390sim/i1/u_roc32/tdcgda
add wave -noupdate /v1390sim/i1/u_roc32/tokina
add wave -noupdate /v1390sim/i1/u_roc32/tokouta
add wave -noupdate /v1390sim/i1/u_roc32/tdcdb
add wave -noupdate /v1390sim/i1/u_roc32/tdcdryb
add wave -noupdate /v1390sim/i1/u_roc32/tdcgdb
add wave -noupdate /v1390sim/i1/u_roc32/tokinb
add wave -noupdate /v1390sim/i1/u_roc32/tokoutb
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_roc32/pipe1_dt
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_roc32/pipe2_dt
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_roc32/pipe3_dt
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_roc32/pipe4_dt
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_roc32/pipe5_dt
add wave -noupdate /v1390sim/i1/u_roc32/dte
add wave -noupdate /v1390sim/i1/u_roc32/wrei
add wave -noupdate /v1390sim/i1/u_roc32/dto
add wave -noupdate /v1390sim/i1/u_roc32/wroi
add wave -noupdate /v1390sim/i1/u_roc32/nwrsramei
add wave -noupdate /v1390sim/i1/u_roc32/nwrsramoi
add wave -noupdate /v1390sim/i1/u_roc32/state2
add wave -noupdate /v1390sim/i1/u_roc32/u_sram_write_fsm/chaina_dis
add wave -noupdate /v1390sim/i1/u_roc32/u_sram_write_fsm/chainb_dis
add wave -noupdate /v1390sim/i1/u_roc32/u_sram_write_fsm/chaina_empty
add wave -noupdate /v1390sim/i1/u_roc32/u_sram_write_fsm/chainb_empty
add wave -noupdate /v1390sim/i1/u_roc32/u_sram_write_fsm/chaina_data
add wave -noupdate /v1390sim/i1/u_roc32/u_sram_write_fsm/chainb_data
add wave -noupdate /v1390sim/i1/u_roc32/u_sram_write_fsm/chaina_evnt_word
add wave -noupdate /v1390sim/i1/u_roc32/u_sram_write_fsm/chainb_evnt_word
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_roc32/u_sram_write_fsm/data_to_write
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_roc32/g_evnt_num
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_roc32/crc32
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_roc32/fid
add wave -noupdate /v1390sim/i1/u_roc32/nwen
add wave -noupdate /v1390sim/i1/u_roc32/state1
add wave -noupdate /v1390sim/i1/u_roc32/state3
add wave -noupdate /v1390sim/i1/u_roc32/state4
add wave -noupdate /v1390sim/i1/u_roc32/state5
add wave -noupdate /v1390sim/i1/u_roc32/statee
add wave -noupdate -divider VME
add wave -noupdate /v1390sim/i1/u_roc32/clk
add wave -noupdate /v1390sim/i1/u_vinterf/asb
add wave -noupdate /v1390sim/i1/u_vinterf/ds1b
add wave -noupdate /v1390sim/i1/u_vinterf/ds0b
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_vinterf/amb
add wave -noupdate /v1390sim/i1/u_vinterf/asbs
add wave -noupdate /v1390sim/i1/u_vinterf/cycs
add wave -noupdate /v1390sim/i1/u_vinterf/dss
add wave -noupdate /v1390sim/i1/u_vinterf/vsel
add wave -noupdate /v1390sim/i1/u_vinterf/v2esstcyc
add wave -noupdate /v1390sim/i1/u_vinterf/start_2esstcyc
add wave -noupdate /v1390sim/i1/u_vinterf/vme_slave_fsm
add wave -noupdate /v1390sim/i1/u_vinterf/read_fifo_fsm
add wave -noupdate /v1390sim/i1/u_vinterf/ndtkin
add wave -noupdate /v1390sim/i1/u_vinterf/anycyc
add wave -noupdate -radix unsigned /v1390sim/i1/u_vinterf/u_read_fifo_fsm/cnt_data
add wave -noupdate /v1390sim/i1/u_vinterf/purged
add wave -noupdate /v1390sim/i1/u_vinterf/evreadi
add wave -noupdate /v1390sim/i1/u_vinterf/evread_ds
add wave -noupdate /v1390sim/i1/u_vinterf/evread
add wave -noupdate /v1390sim/i1/u_vinterf/end_pk
add wave -noupdate /v1390sim/i1/u_vinterf/end_2esstcyc
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_vinterf/dpr
add wave -noupdate /v1390sim/i1/u_vinterf/nrdmeb
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_vinterf/pipea1
add wave -noupdate -color Salmon -radix hexadecimal /v1390sim/i1/u_vinterf/pipea
add wave -noupdate -color Salmon -radix hexadecimal /v1390sim/i1/u_vinterf/pipeb
add wave -noupdate /v1390sim/i1/u_vinterf/noedtk
add wave -noupdate /v1390sim/i1/u_vinterf/mydtacki
add wave -noupdate /v1390sim/myberr
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_vinterf/vadm
add wave -noupdate -radix hexadecimal /v1390sim/i1/u_vinterf/vdbm
add wave -noupdate -divider SPI
add wave -noupdate /v1390sim/i1/u_vinterf/ds0b
add wave -noupdate /v1390sim/i1/u_vinterf/noedtki
add wave -noupdate /v1390sim/i1/u_vinterf/ndtkini
add wave -noupdate /v1390sim/i1/u_vinterf/noedtk
add wave -noupdate /v1390sim/i1/u_vinterf/ndtkin
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {393688500 ps} 1} {{Cursor 2} {393063501 ps} 0}
configure wave -namecolwidth 268
configure wave -valuecolwidth 90
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {392928446 ps} {393236273 ps}
