#set revision "0100"
set century "20"

# Creates a register bank in a VHDL file with the specified hex value
proc generate_vhdl { hex_value } {

    set num_digits [string length $hex_value]
    set bit_width [expr { 4 * $num_digits } ]
    set high_index [expr { $bit_width - 1 } ]
    set reset_value [string repeat "0" $num_digits]

    if { [catch {
        set fh [open "../hdl/version_reg.vhd" w ]
        puts $fh "library ieee; "
        puts $fh "use ieee.std_logic_1164.all; "
        puts $fh "entity version_reg is "
        puts $fh "port ( "
        puts $fh "    data_out : out std_logic_vector($high_index downto 0)"
        puts $fh ");"
        puts $fh "end entity version_reg;"
        puts $fh "architecture rtl of version_reg is"
        puts $fh "begin"
        puts $fh "  data_out <= X\"${hex_value}\";"
        puts $fh "end rtl;"
        close $fh
    } res ] } {
        return -code error $res
    } else {
        return 1
    }
}


# This line accommodates script automation
#foreach { flow project revision } $quartus(args) { break }
# YEAR field MUST be a single HEX digit!
# So 2015 will yield F
# So 2016 will yield 0, not 10
# set year  [expr 0x[format %x [clock format [clock seconds] -format %y]] & 0xF]
# set month [format %x [string trimleft [clock format [clock seconds] -format %m] 0]]
# set day   [clock format [clock seconds] -format %d]
# set revision_number [concat $year$month$day$revision]
set day   [clock format [clock seconds] -format %d]
set month [format %02d [string trimleft [clock format [clock seconds] -format %m] 0]]
set year  [expr 0x[format %04x [clock format [clock seconds] -format %y]] & 0xFFFF]

#set revision_number [concat $day$month$century$year]
set revision_number [concat $century$year$month$day]

# Call procedure to store the number
if { [catch { generate_vhdl $revision_number } res] } {
    puts stdout "Couldn't generate VHDL file. $res"
} else {
    puts stdout "Successfully updated version number to version 0x${revision_number}"
}