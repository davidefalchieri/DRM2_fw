onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {TRIGGER FPGA}
add wave -noupdate -format Logic /vx1392sim/i17/clk_cttm
add wave -noupdate -format Logic /vx1392sim/i17/clk_test
add wave -noupdate -format Logic /vx1392sim/i17/config
add wave -noupdate -format Literal /vx1392sim/i17/d_cttm
add wave -noupdate -format Literal /vx1392sim/i17/dpclk
add wave -noupdate -format Logic /vx1392sim/i17/f_sck
add wave -noupdate -format Logic /vx1392sim/i17/f_si
add wave -noupdate -format Logic /vx1392sim/i17/f_so
add wave -noupdate -format Logic /vx1392sim/i17/fcs
add wave -noupdate -format Literal /vx1392sim/i17/lb
add wave -noupdate -format Literal /vx1392sim/i17/lbsp
add wave -noupdate -format Logic /vx1392sim/i17/ltm_local_trg
add wave -noupdate -format Logic /vx1392sim/i17/ncsram
add wave -noupdate -format Logic /vx1392sim/i17/nlbas
add wave -noupdate -format Logic /vx1392sim/i17/nlbclr
add wave -noupdate -format Logic /vx1392sim/i17/nlbcs
add wave -noupdate -format Logic /vx1392sim/i17/nlblast
add wave -noupdate -format Logic /vx1392sim/i17/nlbpcke
add wave -noupdate -format Logic /vx1392sim/i17/nlbpckr
add wave -noupdate -format Logic /vx1392sim/i17/nlbrd
add wave -noupdate -format Logic /vx1392sim/i17/nlbrdy
add wave -noupdate -format Logic /vx1392sim/i17/nlbres
add wave -noupdate -format Logic /vx1392sim/i17/nlbwait
add wave -noupdate -format Logic /vx1392sim/i17/noeram
add wave -noupdate -format Logic /vx1392sim/i17/nwrram
add wave -noupdate -format Literal /vx1392sim/i17/or_del
add wave -noupdate -format Logic /vx1392sim/i17/pll_res
add wave -noupdate -format Logic /vx1392sim/i17/pulse_toggle
add wave -noupdate -format Literal /vx1392sim/i17/ramad
add wave -noupdate -format Literal /vx1392sim/i17/ramdt
add wave -noupdate -format Logic /vx1392sim/i17/sclk
add wave -noupdate -format Literal /vx1392sim/i17/sp_cttm
add wave -noupdate -format Literal /vx1392sim/i17/trd
add wave -noupdate -format Literal /vx1392sim/i17/trm
add wave -noupdate -format Literal /vx1392sim/i17/tst
add wave -noupdate -divider {VME MASTER}
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i0/a
add wave -noupdate -format Literal /vx1392sim/i0/am
add wave -noupdate -format Logic /vx1392sim/i0/as
add wave -noupdate -format Logic /vx1392sim/i0/bbsy
add wave -noupdate -format Logic /vx1392sim/i0/bclr
add wave -noupdate -format Logic /vx1392sim/i0/berr
add wave -noupdate -format Logic /vx1392sim/i0/bgi
add wave -noupdate -format Logic /vx1392sim/i0/bgo
add wave -noupdate -format Literal /vx1392sim/i0/blt_data
add wave -noupdate -format Literal /vx1392sim/i0/br
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i0/d
add wave -noupdate -format Logic /vx1392sim/i0/ds0
add wave -noupdate -format Logic /vx1392sim/i0/ds1
add wave -noupdate -format Logic /vx1392sim/i0/dtack
add wave -noupdate -format Logic /vx1392sim/i0/iack
add wave -noupdate -format Logic /vx1392sim/i0/iackin
add wave -noupdate -format Logic /vx1392sim/i0/iackout
add wave -noupdate -format Logic /vx1392sim/i0/lword
add wave -noupdate -format Logic /vx1392sim/i0/sysres
add wave -noupdate -format Logic /vx1392sim/i0/write
add wave -noupdate -divider VINTERF
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbvalid
add wave -noupdate -format Literal /vx1392sim/i1/i2/state1
add wave -noupdate -format Literal /vx1392sim/i1/i2/state2
add wave -noupdate -format Literal /vx1392sim/i1/i2/state5
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/lb
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/lb_i
add wave -noupdate -format Logic /vx1392sim/i1/i2/lb_noe
add wave -noupdate -format Literal /vx1392sim/i1/i2/lb_s
add wave -noupdate -format Literal /vx1392sim/i1/i2/lbsp
add wave -noupdate -format Logic /vx1392sim/i1/i2/lbstart
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbas
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbrdy
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbrdy_s
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlblast
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbclr
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbcs
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbpcke
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbpckr
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbrd
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbres
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbvalid
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbwait
add wave -noupdate -divider {RAM ACCESS}
add wave -noupdate -format Logic /vx1392sim/i17/ncsram
add wave -noupdate -format Logic /vx1392sim/i17/noeram
add wave -noupdate -format Logic /vx1392sim/i17/nwrram
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i17/ramad
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i17/ramdt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {59278498 ps} 0}
configure wave -namecolwidth 187
configure wave -valuecolwidth 82
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
WaveRestoreZoom {49860053 ps} {65665322 ps}
