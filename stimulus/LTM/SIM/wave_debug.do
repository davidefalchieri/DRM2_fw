onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i6/rclock
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i6/raddr
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i6/rdb
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i6/do
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i6/wclock
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i6/waddr
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i6/wrb
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i6/di
add wave -noupdate -divider FLASH
add wave -noupdate -format Logic /vx1392sim/i1/i5/pon_load
add wave -noupdate -format Logic /vx1392sim/i1/f_sck
add wave -noupdate -format Logic /vx1392sim/i1/f_si
add wave -noupdate -format Logic /vx1392sim/i1/f_so
add wave -noupdate -format Logic /vx1392sim/i1/fcs
add wave -noupdate -format Literal /vx1392sim/i1/i5/sstate
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i5/bitcnt
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i5/bytecnt
add wave -noupdate -format Literal -radix hexadecimal -expand /vx1392sim/i1/i5/sbyte
add wave -noupdate -format Logic /vx1392sim/i1/i5/ncs0
add wave -noupdate -format Logic /vx1392sim/i1/i5/isi
add wave -noupdate -format Logic /vx1392sim/i1/i5/isck
add wave -noupdate -format Logic /vx1392sim/i1/i5/load_resi
add wave -noupdate -format Logic /vx1392sim/i1/i5/load_res
add wave -noupdate -format Logic /vx1392sim/i1/i5/drivecs
add wave -noupdate -divider MEB
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/reset
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i10/event_meb/do
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/rclock
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/wclock
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i10/event_meb/di
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/wrb
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/rdb
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/full
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/empty
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i10/event_meb/po
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i10/event_meb/pi
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/eqth
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/geqth
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/wpe
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i10/event_meb/rpe
add wave -noupdate -divider TRIGGERS
add wave -noupdate -format Logic /vx1392sim/i1/i10/l0
add wave -noupdate -format Logic /vx1392sim/i1/i10/l1a
add wave -noupdate -format Logic /vx1392sim/i1/i10/l1r
add wave -noupdate -format Logic /vx1392sim/i1/i10/l2a
add wave -noupdate -format Logic /vx1392sim/i1/i10/l2r
add wave -noupdate -format Logic /vx1392sim/i1/i10/bnc_res
add wave -noupdate -format Logic /vx1392sim/i1/i10/ltm_drdy
add wave -noupdate -format Logic /vx1392sim/i1/i10/ltm_busy
add wave -noupdate -divider VINTERF
add wave -noupdate -format Logic /vx1392sim/i1/i2/clk
add wave -noupdate -format Logic /vx1392sim/i1/i2/aliclk
add wave -noupdate -format Logic /vx1392sim/i1/i2/hwres
add wave -noupdate -format Logic /vx1392sim/i1/i2/clear
add wave -noupdate -format Logic /vx1392sim/i1/i2/hwclear
add wave -noupdate -format Logic /vx1392sim/i1/i2/wdogto
add wave -noupdate -format Logic /vx1392sim/i1/i2/asb
add wave -noupdate -format Logic /vx1392sim/i1/i2/ds0b
add wave -noupdate -format Logic /vx1392sim/i1/i2/ds1b
add wave -noupdate -format Logic /vx1392sim/i1/i2/ndtkin
add wave -noupdate -format Logic /vx1392sim/i1/i2/noedtk
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/vad
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/vdb
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/amb
add wave -noupdate -format Literal /vx1392sim/i1/i2/ga
add wave -noupdate -format Logic /vx1392sim/i1/i2/writeb
add wave -noupdate -format Logic /vx1392sim/i1/i2/iackb
add wave -noupdate -format Logic /vx1392sim/i1/i2/iackinb
add wave -noupdate -format Logic /vx1392sim/i1/i2/iackoutb
add wave -noupdate -format Logic /vx1392sim/i1/i2/berrvme
add wave -noupdate -format Logic /vx1392sim/i1/i2/myberr
add wave -noupdate -format Logic /vx1392sim/i1/i2/lwordb
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/vas
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/reg_ads
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/purged
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/closedtk
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/vdbi
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/vdbm
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/vadm
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/ramdts
add wave -noupdate -format Logic /vx1392sim/i1/i2/intr1
add wave -noupdate -format Logic /vx1392sim/i1/i2/intr2
add wave -noupdate -format Logic /vx1392sim/i1/i2/adltc
add wave -noupdate -format Logic /vx1392sim/i1/i2/noe16r
add wave -noupdate -format Logic /vx1392sim/i1/i2/noe16w
add wave -noupdate -format Logic /vx1392sim/i1/i2/noe32r
add wave -noupdate -format Logic /vx1392sim/i1/i2/noe32w
add wave -noupdate -format Logic /vx1392sim/i1/i2/noe64r
add wave -noupdate -format Logic /vx1392sim/i1/i2/noead
add wave -noupdate -format Literal /vx1392sim/i1/i2/dpr
add wave -noupdate -format Literal /vx1392sim/i1/i2/dpr_p
add wave -noupdate -format Logic /vx1392sim/i1/i2/nrdmeb
add wave -noupdate -format Logic /vx1392sim/i1/i2/paf
add wave -noupdate -format Logic /vx1392sim/i1/i2/pae
add wave -noupdate -format Logic /vx1392sim/i1/i2/ef
add wave -noupdate -format Logic /vx1392sim/i1/i2/ff
add wave -noupdate -format Literal /vx1392sim/i1/i2/or_rdata
add wave -noupdate -format Literal /vx1392sim/i1/i2/or_raddr
add wave -noupdate -format Logic /vx1392sim/i1/i2/or_rreq
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/ramdt
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/ramad_vme
add wave -noupdate -format Logic /vx1392sim/i1/i2/ramrd
add wave -noupdate -format Logic /vx1392sim/i1/i2/evrdy
add wave -noupdate -format Logic /vx1392sim/i1/i2/evread
add wave -noupdate -format Logic /vx1392sim/i1/i2/dtest_fifo
add wave -noupdate -format Literal /vx1392sim/i1/i2/state1
add wave -noupdate -format Literal /vx1392sim/i1/i2/state2
add wave -noupdate -format Literal /vx1392sim/i1/i2/state5
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbas
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbclr
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbcs
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlblast
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbrd
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbres
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbwait
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbpcke
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbpckr
add wave -noupdate -format Logic /vx1392sim/i1/i2/nlbrdy
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/lb
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/lbsp
add wave -noupdate -format Literal /vx1392sim/i1/i2/fbout
add wave -noupdate -format Literal /vx1392sim/i1/i2/debug
add wave -noupdate -format Literal /vx1392sim/i1/i2/reg
add wave -noupdate -format Literal /vx1392sim/i1/i2/pulse
add wave -noupdate -format Literal /vx1392sim/i1/i2/tick
add wave -noupdate -format Logic /vx1392sim/i1/i2/d32
add wave -noupdate -format Logic /vx1392sim/i1/i2/d16
add wave -noupdate -format Logic /vx1392sim/i1/i2/ronly
add wave -noupdate -format Logic /vx1392sim/i1/i2/wonly
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/regmap
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/asbs
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/dss
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/cycs
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/cycs1
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/vsel
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/asbsf1
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/dssf1
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/cycsf1
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/ds
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/writes
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/lwords
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/iackins
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/anycyc
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/singcyc
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/bltcyc
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/mbltcyc
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/adackcyc
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/selbase32
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/selgeo
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/noedtki
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/noe16ri
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/noe32ri
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/noe64ri
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/noe16wi
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/noe32wi
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/nrdmebi
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/evreadi
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/evread_ds
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/myberri
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/pipea1
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/pipea
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/pipeb
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/end_pk
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/wdog
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/wdogres
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/wdogres1
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/wdogres1cyc
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/wdogtoi
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/lb_req
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/lb_req_sync
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/lb_ack
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/lb_ack_sync
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/lb_write
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/lb_write_sync
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/lb_addr
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/lb_dout
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/lb_s
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/lb_noe
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/lb_i
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/tcnt
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/reg1
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/reg2
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/reg3
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/or_rreq_sync
add wave -noupdate -format Logic -radix hexadecimal /vx1392sim/i1/i2/requester
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/state1
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/state2
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i2/state5
add wave -noupdate -divider PDL_INTERF
add wave -noupdate -format Logic /vx1392sim/i1/i3/clk
add wave -noupdate -format Logic /vx1392sim/i1/i3/hwres
add wave -noupdate -format Logic /vx1392sim/i1/i3/clear
add wave -noupdate -format Logic /vx1392sim/i1/i3/load_res
add wave -noupdate -format Literal /vx1392sim/i1/i3/sp0
add wave -noupdate -format Literal /vx1392sim/i1/i3/ae
add wave -noupdate -format Logic /vx1392sim/i1/i3/si
add wave -noupdate -format Logic /vx1392sim/i1/i3/sc
add wave -noupdate -format Logic /vx1392sim/i1/i3/md
add wave -noupdate -format Literal /vx1392sim/i1/i3/p
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i3/pdl_rdata
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i3/pdl_raddr
add wave -noupdate -format Logic /vx1392sim/i1/i3/pdl_rreq
add wave -noupdate -format Logic /vx1392sim/i1/i3/pdl_rack
add wave -noupdate -format Logic /vx1392sim/i1/i3/pdlcfg_nrd
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i3/pdlcfg_rad
add wave -noupdate -format Literal -radix hexadecimal /vx1392sim/i1/i3/pdlcfg_dt
add wave -noupdate -format Literal /vx1392sim/i1/i3/sstate
add wave -noupdate -format Literal /vx1392sim/i1/i3/sbyte
add wave -noupdate -format Logic /vx1392sim/i1/i3/isi
add wave -noupdate -format Logic /vx1392sim/i1/i3/isck
add wave -noupdate -format Logic /vx1392sim/i1/i3/mode
add wave -noupdate -format Literal /vx1392sim/i1/i3/sel
add wave -noupdate -format Literal /vx1392sim/i1/i3/p0
add wave -noupdate -format Logic /vx1392sim/i1/i3/so
add wave -noupdate -format Literal /vx1392sim/i1/i3/byte
add wave -noupdate -format Literal /vx1392sim/i1/i3/bitcnt
add wave -noupdate -format Logic /vx1392sim/i1/i3/valid
add wave -noupdate -format Literal /vx1392sim/i1/i3/cnt
add wave -noupdate -divider ROC
add wave -noupdate -format Literal /vx1392sim/i1/i10/pdl_rdata
add wave -noupdate -format Literal /vx1392sim/i1/i10/pdl_raddr
add wave -noupdate -format Logic /vx1392sim/i1/i10/pdl_rreq
add wave -noupdate -format Logic /vx1392sim/i1/i10/pdl_rack
add wave -noupdate -format Logic /vx1392sim/i1/i10/pdl_rack_sync
add wave -noupdate -format Literal /vx1392sim/i1/i10/state1
add wave -noupdate -format Literal /vx1392sim/i1/i10/state2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3097642124 ps} 0} {{Cursor 2} {393922594 ps} 0}
configure wave -namecolwidth 314
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
WaveRestoreZoom {0 ps} {1575579031 ps}
