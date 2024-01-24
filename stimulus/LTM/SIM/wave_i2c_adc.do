onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {CHAIN 0}
add wave -noupdate -format Logic /vx1392sim/i18/a0
add wave -noupdate -format Logic /vx1392sim/i18/a1
add wave -noupdate -format Logic /vx1392sim/i18/a2
add wave -noupdate -format Literal /vx1392sim/i18/bit_ptr
add wave -noupdate -format Logic /vx1392sim/i18/byte_ptr
add wave -noupdate -format Literal /vx1392sim/i18/device
add wave -noupdate -format Logic /vx1392sim/i18/device_sel
add wave -noupdate -format Logic /vx1392sim/i18/rd_mode
add wave -noupdate -format Literal /vx1392sim/i18/recv_byte
add wave -noupdate -format Logic /vx1392sim/i18/scl
add wave -noupdate -format Logic /vx1392sim/i18/scl_in
add wave -noupdate -format Logic /vx1392sim/i18/scl_old
add wave -noupdate -format Logic /vx1392sim/i18/scl_out
add wave -noupdate -format Logic /vx1392sim/i18/sda
add wave -noupdate -format Logic /vx1392sim/i18/sda_in
add wave -noupdate -format Logic /vx1392sim/i18/sda_out
add wave -noupdate -format Logic /vx1392sim/i18/start_det
add wave -noupdate -format Logic /vx1392sim/i18/stop_det
add wave -noupdate -format Literal /vx1392sim/i18/stretch
add wave -noupdate -format Literal /vx1392sim/i18/next_state
add wave -noupdate -format Literal /vx1392sim/i18/this_state
add wave -noupdate -format Logic /vx1392sim/i18/write_en
add wave -noupdate -format Literal /vx1392sim/i18/xmit_byte
add wave -noupdate -format Literal /vx1392sim/i18/ap_reg
add wave -noupdate -format Literal /vx1392sim/i18/temp_reg
add wave -noupdate -format Literal /vx1392sim/i18/cfg_reg
add wave -noupdate -format Literal /vx1392sim/i18/thyst_reg
add wave -noupdate -format Literal /vx1392sim/i18/toti_reg
add wave -noupdate -format Literal /vx1392sim/i18/adc_reg
add wave -noupdate -format Literal /vx1392sim/i18/cfg2_reg
add wave -noupdate -divider {CHAIN 1}
add wave -noupdate -format Logic /vx1392sim/i19/a0
add wave -noupdate -format Logic /vx1392sim/i19/a1
add wave -noupdate -format Logic /vx1392sim/i19/a2
add wave -noupdate -format Literal /vx1392sim/i19/bit_ptr
add wave -noupdate -format Logic /vx1392sim/i19/byte_ptr
add wave -noupdate -format Literal /vx1392sim/i19/device
add wave -noupdate -format Logic /vx1392sim/i19/device_sel
add wave -noupdate -format Literal /vx1392sim/i19/next_state
add wave -noupdate -format Logic /vx1392sim/i19/rd_mode
add wave -noupdate -format Literal /vx1392sim/i19/recv_byte
add wave -noupdate -format Logic /vx1392sim/i19/scl
add wave -noupdate -format Logic /vx1392sim/i19/scl_in
add wave -noupdate -format Logic /vx1392sim/i19/scl_old
add wave -noupdate -format Logic /vx1392sim/i19/scl_out
add wave -noupdate -format Logic /vx1392sim/i19/sda
add wave -noupdate -format Logic /vx1392sim/i19/sda_in
add wave -noupdate -format Logic /vx1392sim/i19/sda_out
add wave -noupdate -format Logic /vx1392sim/i19/start_det
add wave -noupdate -format Logic /vx1392sim/i19/stop_det
add wave -noupdate -format Literal /vx1392sim/i19/stretch
add wave -noupdate -format Literal /vx1392sim/i19/this_state
add wave -noupdate -format Logic /vx1392sim/i19/write_en
add wave -noupdate -format Literal /vx1392sim/i19/xmit_byte
add wave -noupdate -format Literal /vx1392sim/i19/adc_reg
add wave -noupdate -format Literal /vx1392sim/i19/ap_reg
add wave -noupdate -format Literal /vx1392sim/i19/cfg2_reg
add wave -noupdate -format Literal /vx1392sim/i19/cfg_reg
add wave -noupdate -format Literal /vx1392sim/i19/temp_reg
add wave -noupdate -format Literal /vx1392sim/i19/thyst_reg
add wave -noupdate -format Literal /vx1392sim/i19/toti_reg
add wave -noupdate -divider {I2C MASTER}
add wave -noupdate -format Literal /vx1392sim/i1/i1/bitcnt
add wave -noupdate -format Logic /vx1392sim/i1/i1/chain_select
add wave -noupdate -format Literal /vx1392sim/i1/i1/channel
add wave -noupdate -format Literal /vx1392sim/i1/i1/chip_addr
add wave -noupdate -format Logic /vx1392sim/i1/i1/clk
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i1/command
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i1/data
add wave -noupdate -format Literal /vx1392sim/i1/i1/debug
add wave -noupdate -format Logic /vx1392sim/i1/i1/hwres
add wave -noupdate -format Logic /vx1392sim/i1/i1/i2c_chain
add wave -noupdate -format Literal /vx1392sim/i1/i1/i2c_rdata
add wave -noupdate -format Logic /vx1392sim/i1/i1/i2c_rreq
add wave -noupdate -format Logic /vx1392sim/i1/i1/i2c_rvalid
add wave -noupdate -format Literal /vx1392sim/i1/i1/pulse
add wave -noupdate -format Logic /vx1392sim/i1/i1/pulse_fl
add wave -noupdate -format Logic /vx1392sim/i1/i1/pulse_i2c
add wave -noupdate -height 15 -expand -group {I2CCOM REGISTER}
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(104)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(103)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(102)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(101)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(100)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(99)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(98)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(97)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(96)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(95)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(94)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(93)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(92)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(91)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(90)
add wave -noupdate -group {I2CCOM REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(89)
add wave -noupdate -height 15 -group {I2CDAT REGISTER}
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(120)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(119)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(118)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(117)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(116)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(115)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(114)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(113)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(112)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(111)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(110)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(109)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(108)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(107)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(106)
add wave -noupdate -group {I2CDAT REGISTER} -format Logic -height 15 /vx1392sim/i1/i1/reg(105)
add wave -noupdate -format Literal /vx1392sim/i1/i1/reg
add wave -noupdate -format Literal /vx1392sim/i1/i1/sbyte
add wave -noupdate -format Logic /vx1392sim/i1/i1/scl
add wave -noupdate -format Logic /vx1392sim/i1/i1/scla
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdaa
add wave -noupdate -format Logic /vx1392sim/i1/i1/sclb
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdab
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdain
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdanoe
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdanoe_del
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdanoe_del1
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdanoe_del2
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdaout
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdaout_del
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdaout_del1
add wave -noupdate -format Logic /vx1392sim/i1/i1/sdaout_del2
add wave -noupdate -format Literal /vx1392sim/i1/i1/sstate
add wave -noupdate -format Literal /vx1392sim/i1/i1/sstate2
add wave -noupdate -format Logic /vx1392sim/i1/i1/start_i2c
add wave -noupdate -format Literal /vx1392sim/i1/i1/tick
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10436633 ps} 0}
configure wave -namecolwidth 218
configure wave -valuecolwidth 110
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
update
WaveRestoreZoom {0 ps} {366696750 ps}
