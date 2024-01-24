onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /v1390sim/i2/clk
add wave -noupdate -format Logic {/v1390sim/i1/\I2.PLL_tdc_del.Core\/clk}
add wave -noupdate -format Logic {/v1390sim/i1/\I2.PLL_tdc_del.Core\/gla}
add wave -noupdate -format Logic {/v1390sim/i1/\I2.PLL_tdc_del.Core\/glb}
add wave -noupdate -format Logic {/v1390sim/i1/\I2.PLL_LOCK\/y}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2513600 ps} 0} {{Cursor 2} {2515300 ps} 0}
configure wave -namecolwidth 262
configure wave -valuecolwidth 102
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
WaveRestoreZoom {2508338 ps} {2518863 ps}
