onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Literal /vx1392sim/i36/ae_pdl
add wave -noupdate -format Logic /vx1392sim/i36/md_pdl
add wave -noupdate -format Literal /vx1392sim/i36/p_pdl
add wave -noupdate -format Literal /vx1392sim/i36/pdl_value
add wave -noupdate -format Logic /vx1392sim/i36/sc_pdl
add wave -noupdate -format Logic /vx1392sim/i36/si_pdl
add wave -noupdate -format Literal /vx1392sim/i36/sp_pdl
add wave -noupdate -divider PDLCFG
add wave -noupdate -format Literal /vx1392sim/i1/i3/sstate
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i11/raddr
add wave -noupdate -format Logic /vx1392sim/i1/i11/rclock
add wave -noupdate -format Logic /vx1392sim/i1/i11/rdb
add wave -noupdate -format Literal /vx1392sim/i1/i11/waddr
add wave -noupdate -format Logic /vx1392sim/i1/i11/wclock
add wave -noupdate -format Logic /vx1392sim/i1/i11/wrb
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i11/di
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i11/do
add wave -noupdate -divider CROM
add wave -noupdate -format Literal /vx1392sim/i1/i5/sstate
add wave -noupdate -format Literal /vx1392sim/i1/i6/di
add wave -noupdate -format Literal /vx1392sim/i1/i6/do
add wave -noupdate -format Literal /vx1392sim/i1/i6/raddr
add wave -noupdate -format Logic /vx1392sim/i1/i6/rclock
add wave -noupdate -format Logic /vx1392sim/i1/i6/rdb
add wave -noupdate -format Literal /vx1392sim/i1/i6/waddr
add wave -noupdate -format Logic /vx1392sim/i1/i6/wclock
add wave -noupdate -format Logic /vx1392sim/i1/i6/wrb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
configure wave -namecolwidth 346
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {302003843 ps}
