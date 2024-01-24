proc hex_to_bin {val} \
{
  if     { $val == "0" }  { return "0000" } \
  elseif { $val == "1" }  { return "0001" } \
  elseif { $val == "2" }  { return "0010" } \
  elseif { $val == "3" }  { return "0011" } \
  elseif { $val == "4" }  { return "0100" } \
  elseif { $val == "5" }  { return "0101" } \
  elseif { $val == "6" }  { return "0110" } \
  elseif { $val == "7" }  { return "0111" } \
  elseif { $val == "8" }  { return "1000" } \
  elseif { $val == "9" }  { return "1001" } \
  elseif { $val == "A" || $val == "a" }  { return "1010" } \
  elseif { $val == "B" || $val == "b" }  { return "1011" } \
  elseif { $val == "C" || $val == "c" }  { return "1100" } \
  elseif { $val == "D" || $val == "d" }  { return "1101" } \
  elseif { $val == "E" || $val == "e" }  { return "1110" } \
  elseif { $val == "F" || $val == "f" }  { return "1111" } 
}

proc y_is_func_of_A { init_bin } \
{
    foreach i { 0 1 2 3 4 5 6 7 } \
    {
        set lpos [expr [string length $init_bin] - 1]
        set k0 [expr $lpos - $i]
        set k1 [expr $k0 - 8]
        if { [string index $init_bin $k0] != [string index $init_bin $k1] } { return 1 }
    }
    return 0
}
proc y_is_func_of_B { init_bin } \
{
    foreach i { 0 2 4 6 8 10 12 14 } \
    {
        set lpos [expr [string length $init_bin] - 1]
        set k0 [expr $lpos - $i]
        set k1 [expr $k0 - 1]
        if { [string index $init_bin $k0] != [string index $init_bin $k1] } { return 1 }
    }
    return 0
}
proc f0_is_func_of_B { init_bin } \
{
    foreach i { 0 2 4 6 } \
    {
        set lpos [expr [string length $init_bin] - 1]
        set k0 [expr $lpos - $i]
        set k1 [expr $k0 - 1]
        if { [string index $init_bin $k0] != [string index $init_bin $k1] } { return 1 }
    }
    return 0
}
proc f1_is_func_of_B { init_bin } \
{
    foreach i { 8 10 12 14 } \
    {
        set lpos [expr [string length $init_bin] - 1]
        set k0 [expr $lpos - $i]
        set k1 [expr $k0 - 1]
        if { [string index $init_bin $k0] != [string index $init_bin $k1] } { return 1 }
    }
    return 0
}
proc y_is_func_of_C { init_bin } \
{
    foreach i { 0 1 4 5 8 9 12 13 } \
    {
        set lpos [expr [string length $init_bin] - 1]
        set k0 [expr $lpos - $i]
        set k1 [expr $k0 - 2]
        if { [string index $init_bin $k0] != [string index $init_bin $k1] } { return 1 }
    }
    return 0
}
proc f0_is_func_of_C { init_bin } \
{
    foreach i { 0 1 4 5 } \
    {
        set lpos [expr [string length $init_bin] - 1]
        set k0 [expr $lpos - $i]
        set k1 [expr $k0 - 2]
        if { [string index $init_bin $k0] != [string index $init_bin $k1] } { return 1 }
    }
    return 0
}
proc f1_is_func_of_C { init_bin } \
{
    foreach i { 8 9 12 13 } \
    {
        set lpos [expr [string length $init_bin] - 1]
        set k0 [expr $lpos - $i]
        set k1 [expr $k0 - 2]
        if { [string index $init_bin $k0] != [string index $init_bin $k1] } { return 1 }
    }
    return 0
}
proc y_is_func_of_D { init_bin } \
{
    foreach i { 0 1 2 3 8 9 10 11 } \
    {
        set lpos [expr [string length $init_bin] - 1]
        set k0 [expr $lpos - $i]
        set k1 [expr $k0 - 4]
        if { [string index $init_bin $k0] != [string index $init_bin $k1] } { return 1 }
    }
    return 0
}
proc f0_is_func_of_D { init_bin } \
{
    foreach i { 0 1 2 3 } \
    {
        set lpos [expr [string length $init_bin] - 1]
        set k0 [expr $lpos - $i]
        set k1 [expr $k0 - 4]
        if { [string index $init_bin $k0] != [string index $init_bin $k1] } { return 1 }
    }
    return 0
}
proc f1_is_func_of_D { init_bin } \
{
    foreach i { 8 9 10 11 } \
    {
        set lpos [expr [string length $init_bin] - 1]
        set k0 [expr $lpos - $i]
        set k1 [expr $k0 - 4]
        if { [string index $init_bin $k0] != [string index $init_bin $k1] } { return 1 }
    }
    return 0
}
proc p_is_func_of_ABCD { init_bin port } \
{
    # P function of bit 19-18
    if { [string index $init_bin 0] == "0" && [string index $init_bin 1] == "1" } \
    {
        if { $port == "A" } { return [y_is_func_of_A $init_bin] }
        if { $port == "B" } { return [y_is_func_of_B $init_bin] }
        if { $port == "C" } { return [y_is_func_of_C $init_bin] }
        if { $port == "D" } { return [y_is_func_of_D $init_bin] }
    } \
    else \
    {
        return 0
    }
}
proc u_is_func_of_BCD { init_bin port } \
{
    # UB function of bit 17-16
    if { ( [string index $init_bin 2] == "0" && [string index $init_bin 3] == "1" ) } \
    {
        if { $port == "B" } { return [f0_is_func_of_B $init_bin] }
        if { $port == "C" } { return [f0_is_func_of_C $init_bin] }
        if { $port == "D" } { return [f0_is_func_of_D $init_bin] }
    } \
    elseif { ( [string index $init_bin 2] == "1" && [string index $init_bin 3] == "1" ) } \
    {
        if { $port == "B" } { return [f1_is_func_of_B $init_bin] }
        if { $port == "C" } { return [f1_is_func_of_C $init_bin] }
        if { $port == "D" } { return [f1_is_func_of_D $init_bin] }
    } \
    else \
    {
        return 0
    }
}

# @TODO: is the special character list complete?
proc convert_v_name_to_sdf {name} \
{
  set new_name ""
  for { set i 0 } { $i < [string length $name]} { incr i } \
  {
      if { $i == 0 && [string index $name 0] == "\\" } { continue } \
      elseif { [string index $name $i] == "\/" || \
               [string index $name $i] == "\[" || \
               [string index $name $i] == "\]" || \
               [string index $name $i] == "\\" || \
               [string index $name $i] == "$" || \
               [string index $name $i] == "." } \
      {
          append new_name "\\"
          append new_name [string index $name $i]
      } \
      else \
      {
          append new_name [string index $name $i]
      }
  }
  return $new_name
}
proc convert_sdf_name_to_v {name} \
{
  set new_name ""
  if { [string first "\\" $name] == -1 } \
  {
      set new_name $name
  } else \
  {
      set new_name "\\"
      for { set i 0 } { $i < [string length $name]} { incr i } \
      {
          if { [string index $name $i] == "\\" } { incr i }
          append new_name [string index $name $i]
      }
  }
  return $new_name
}

proc process_ba_v { v_file } \
{
    global ari1_cc_info_map

    # open v file
    set fs_v [open ${v_file} "r"]
    set d_v  [read ${fs_v}]
    set l_v  [split ${d_v} "\n\r"]

    set start_cell 0
    set use_y  1
    set use_s  1
    set use_p  1
    set use_ub 1
    set init_depend ""
    set init_bin    ""
    set inst_name   ""

    foreach line ${l_v} \
    {
        if { [string first "ARI1_CC" $line] != -1 } \
        {
            # beginning of ARI1_CC instance
            set start_cell 1
            set init_depend ""
            set ports ""

            set init_pos [expr [string first "'h" $line] + 2 ]
            set init_bin     [hex_to_bin [string index $line $init_pos] ] 
            append init_bin [hex_to_bin [string index $line [expr $init_pos + 1] ] ] 
            append init_bin [hex_to_bin [string index $line [expr $init_pos + 2] ] ]
            append init_bin [hex_to_bin [string index $line [expr $init_pos + 3] ] ]
            append init_bin [hex_to_bin [string index $line [expr $init_pos + 4] ] ]
            if { [y_is_func_of_A $init_bin] == 1 } { append init_depend YA }
            if { [y_is_func_of_B $init_bin] == 1 } { append init_depend YB }
            if { [y_is_func_of_C $init_bin] == 1 } { append init_depend YC }
            if { [y_is_func_of_D $init_bin] == 1 } { append init_depend YD }
            if { [p_is_func_of_ABCD $init_bin "A"] == 1 } { append init_depend PA }
            if { [p_is_func_of_ABCD $init_bin "B"] == 1 } { append init_depend PB }
            if { [p_is_func_of_ABCD $init_bin "C"] == 1 } { append init_depend PC }
            if { [p_is_func_of_ABCD $init_bin "D"] == 1 } { append init_depend PD }
            if { [u_is_func_of_BCD  $init_bin "B"] == 1 } { append init_depend UB }
            if { [u_is_func_of_BCD  $init_bin "C"] == 1 } { append init_depend UC }
            if { [u_is_func_of_BCD  $init_bin "D"] == 1 } { append init_depend UD }

            # need to handle case where instance name of same line
            set pos [expr $init_pos + 10]
            set inst_name_tmp [string range $line $pos 100000]
            if { $inst_name_tmp != "" } \
            {
                # get instance name
                incr start_cell
                set pos_space [string first " " $inst_name_tmp]
                set inst_name [string range $inst_name_tmp 0 [expr $pos_space -1]]
            }
        } \
        elseif { $start_cell == 1 } \
        {
            # get instance name
            incr start_cell
            set l_split [split [string trimleft $line " "] " "] 
            set inst_name [lindex $l_split 0]
        } \
        elseif { $start_cell > 1 && [string first ";" $line] != -1 } \
        {
            # end of ARI1_CC instance
            append ports $line

            set start_cell 0

            set y_pos_begin [expr [string first ".Y(" $ports] + 3]
            set y_dangling 1
            for { set i $y_pos_begin } { $i < 10000 } { incr i } \
            {
                 if { [string index $ports $i] == ")" } { break }

                 if { [string index $ports $i] != " " } \
                 { 
                     set y_dangling 0
                     break 
                 }
            }
            if { $y_dangling == 1} { append init_depend YY }

            set s_pos_begin [expr [string first ".S(" $ports] + 3]
            set s_dangling 1
            for { set i $s_pos_begin } { $i < 10000 } { incr i } \
            {
                 if { [string index $ports $i] == ")" } { break }

                 if { [string index $ports $i] != " " } \
                 { 
                     set s_dangling 0
                     break 
                 }
            }
            if { $s_dangling == 1} { append init_depend SS }

            #puts "[convert_v_name_to_sdf $inst_name] $init_depend"
            set  ari1_cc_info_map([convert_v_name_to_sdf $inst_name]) $init_depend
        } \
        elseif { $start_cell > 1 } \
        {
            # middle of ARI1_CC instance
            append ports $line
            incr start_cell
        }
    }
}

# 
# Main Function
# 

# Get sdf/v file (mandatory)
if { $argc == 0 } \
{
    puts "ERROR: No SDF file passed"
    return 1
}
set sdf_file [lindex $argv 0]
set v_file   "[file rootname $sdf_file].v"

# optional parameters
set verbosity    0
set name_style   verilog
set line_summary 0
for { set i 1 } { $i < $argc } { set i [expr $i + 2] } \
{
    if {     [lindex $argv $i] == "-verbosity"    } { set verbosity    [lindex $argv [expr $i + 1]] } \
    elseif { [lindex $argv $i] == "-name_style"   } { set name_style   [lindex $argv [expr $i + 1]] } \
    elseif { [lindex $argv $i] == "-line_summary" } { set line_summary [lindex $argv [expr $i + 1]] } \
    else \
    {
      puts "Usage: <path_to_libero_install>/bin/acttclsh <script> <sdf file> \[-name_style <name_style>\] \[-verbosity <verbosity>\] and re-direct the output to a text file such as > sdf_missing_path.rpt"
      puts ""
      puts "verbosity = 0 --> Summary Only - DEFAULT if not specified"
      puts "verbosity = 1 --> Detailed error list with instance/pin name + Summary"
      puts ""
      puts "name_style = verilog --> instance names use the names from the Verilog netlist - DEFAULT if not specified"
      puts "name_style = sdf     --> instance names use the names from the SDF file"
      exit
  }
}

# process .v file
# - extract ARI1_CC INIT string and A/B/C/D to Y/P/UB relationships
# - extract whether Y and S are used .Y(), .S() for ARI1_CC instances
global ari1_cc_info_map
process_ba_v $v_file

# DEBUG
#set j 0
#foreach {key val} [array get ari1_cc_info_map] {
#   puts "Key: $key val: $val" 
#   incr j
#   if { $j > 20 } { break }
#}

# open sdf file
set fs_sdf [open ${sdf_file} "r"]
set d_sdf  [read ${fs_sdf}]
set l_sdf  [split ${d_sdf} "\n\r"]

# variables
set err_pins 0
set wrn_cells 0
set version ""
set design_cells 0
set design_pins 0
set design_pins_not_found 0
set rtg4_apb_if 0
set start_cell 0
set used_cell 1
set encrypted_cell 0
set inst_name ""
set cell_type ""
set cell_is_ari1 0
set ports     ""
array set io_paths {}

puts "Start of Tcl script for CN20022 to detect missing timing paths in SDF versus back-annotated Verilog netlist"
puts "================================================================"
puts ""
puts "Requirements: Verilog back-annotated netlist and corresponding SDF file generated by Libero version used to complete P&R."
puts ""
puts "Usage: <path_to_libero_install>/bin/acttclsh <script> <sdf file> \[-name_style <name_style>\] \[-verbosity <verbosity>\] and re-direct the output to a text file such as > sdf_missing_path.rpt"
puts ""
puts "verbosity = 0 --> Summary Only - DEFAULT if not specified"
puts "verbosity = 1 --> Detailed error list with instance/pin name + Summary"
puts ""
puts "name_style = verilog --> instance names use the names from the Verilog netlist - DEFAULT if not specified"
puts "name_style = sdf     --> instance names use the names from the SDF file"
puts ""

# iterate over each line of the sdf file
# - only process CFGx and ARI1_CC (combinational cells)
foreach line ${l_sdf} \
{
    if { [string first "(VERSION" $line] != -1 } \
    {
       set start [string first "\"" $line]
       set end   [string last  "\"" $line]
       set version [string range $line $start $end] 

       puts "Libero Version : $version"
       puts "SDF file       : $sdf_file"
       puts "Netlist        : $v_file"
       puts "Verbosity      : $verbosity"
       puts "Name style     : $name_style"
       puts ""
       puts "Analyzing SDF..."
       puts ""
    } \
    elseif { $line == " (CELLTYPE \"CFG2\")" || \
             $line == " (CELLTYPE \"CFG3\")" || \
             $line == " (CELLTYPE \"CFG4\")" || \
             $line == " (CELLTYPE \"ARI1_CC\")" } \
    {
        set start_cell 1
        incr design_cells
        set l_split [split [string trimleft $line " "] " "] 
        set cell_type [lindex ${l_split} 1]
        set cell_is_ari1 1
        if { [string first "ARI1" $cell_type] == -1 } {set cell_is_ari1 0 }
    } \
    elseif { $start_cell == 1 } \
    {
        set l_split [split [string trimleft $line " "] " "] 
        if { [lindex ${l_split} 0] == "(INSTANCE" } \
        {
            set inst_name [string trim [lindex ${l_split} 1] "()"]
            set ports     ""
            array unset   io_paths
            set used_cell 1

            # check if unused cell fr m netlist info
            # - Check is only done for ARI1_CC at this time
            set port_info ""
            if { $cell_is_ari1 == 1 } \
            {
                set tmp [array names ari1_cc_info_map -exact $inst_name]
                if { $tmp != "" } \
                { 
                    set port_info $ari1_cc_info_map($inst_name)
                } \
                else \
                { 
                    # exclude instances that are part of an encrypted block
                    # it is expected to not find them in the map
                    if { [string first "MSC_i_" $inst_name] == -1 } \
                    {
                        # unexplained mismatch between sdf and v file
                        puts "  ERROR_INST_NOT_FOUND = $inst_name"
                    }
                }

                # cell is unused if in instance port information:
                # 1. Y is dangling (YY)
                # 2. S is dangling (SS)
                # 3. U is not present (UA/UB/UC/UD)
                # 4. P is not present (PA/PB/PC/PD)
                if { ( ( [string first "YY" $port_info] != -1 || [string first "Y" $port_info] == -1 ) && \
                       [string first "SS" $port_info] != -1 && \
                       [string first "U"  $port_info] == -1 && \
                       [string first "P"  $port_info] == -1 ) } \
                {
                    set used_cell 0
                }
            }
        } \
        elseif { $used_cell == 1 && [lindex ${l_split} 0] == "(PORT" } \
        {
            # collect cell ports except for FCI and CC that are not considered for this analysis
            set port [lindex ${l_split} 1]
            if { $port != "FCI" && $port != "CC" } \
            {
              lappend ports $port
            }
        } \
        elseif { $used_cell == 1 && [lindex ${l_split} 0] == "(IOPATH" } \
        {
            # collect IOPATH for this cell
            set io_paths([lindex ${l_split} 1]) [lindex ${l_split} 2]
        } \
        elseif { $line == "  )" || $line == " )" } \
        {
            # analyse cell at the end of the cell information

            if { $used_cell == 0 } \
            {
                if { [string first "MSC_i_" $inst_name] != -1 } \
                {
                    # count the number of encrypted cell
                    incr encrypted_cell
                } \
                else \
                {
                    if { $verbosity >= 2 } \
                    {
                        puts "  INFO_UNUSED_CELL: (${cell_type}) unused inst ${inst_name}"
                    }
                }
            } \
            else \
            {
                set ports_not_found ""
                incr design_pins [llength $ports]
                foreach port $ports \
                {
                    if { [array names io_paths $port] == "" } \
                    {
                        if { $cell_is_ari1 == 1 } \
                        {
                            if { ( [string first "Y$port" $port_info] == -1 && \
                                   [string first "U$port" $port_info] == -1 && \
                                   [string first "P$port" $port_info] == -1 ) } \
                            {
                                if { $verbosity >= 3 } \
                                {
                                    puts "  INFO_CELL_PORT: (${cell_type}) Expected missing IOPATH for port $port for inst ${inst_name}"
                                }
                            } \
                            else \
                            {
                                lappend ports_not_found $port
                            }
                        } else \
                        {
                            lappend ports_not_found $port
                        }
                    }
                }

                if { [llength $ports] == 0 } \
                {
                    # No ports defined for SDF cells (typical case is that all ports have tie-offs)
                    incr wrn_cells
                    if { $verbosity >= 2 } \
                    {
                        puts "  WARNING_NO_PORT: (${cell_type}) No ports for inst ${inst_name}"
                    }
                } \
                elseif { $ports_not_found != "" } \
                {
                    incr design_pins_not_found [llength $ports_not_found]
                    foreach port $ports_not_found \
                    {
                        if { [string first "NPSS_SERDES_IF" $inst_name] != -1 || \
                             [string first "PCIE_SERDES_IF" $inst_name] != -1 || \
                             [string first "FDDRC"          $inst_name] != -1 } \
                        {
                            # Special RTG4 APB interfaces
                            incr rtg4_apb_if
                            if { $verbosity >= 1 } \
                            {
                                set o_inst_name $inst_name
                                if { $name_style == "verilog" } { set o_inst_name [convert_sdf_name_to_v $inst_name] }
                                puts "  ERROR_CELL_PORT_RTG4_APB_IF: (${cell_type}) Missing IOPATH for port $port for inst ${o_inst_name}"
                            }
                        } \
                        else \
                        {
                            if { $verbosity >= 1 } \
                            {
                                set o_inst_name $inst_name
                                if { $name_style == "verilog" } { set o_inst_name [convert_sdf_name_to_v $inst_name] }
                                puts "  ERROR_CELL_PORT: (${cell_type}) Missing IOPATH for port $port for inst ${o_inst_name}"
                            }
                        }
                    }
                }
            }

            # reset variables before starting the next cell
            set ports ""
            array unset io_paths
            set start_cell 0
        }
    }
}

if { $line_summary == 1 } \
{
  if { $verbosity <= 1 } \
  {
    puts "SUMMARY: $sdf_file CELLS= $design_cells PINS= $design_pins PINS_NO_IOPATHS= $design_pins_not_found PINS_NO_IO_PATH_RTG4_APB_IF= $rtg4_apb_if"
  } else \
  {
    puts "SUMMARY: $sdf_file CELLS= $design_cells CELLS_NO_IOPATHS= $wrn_cells PINS= $design_pins PINS_NO_IOPATHS= $design_pins_not_found PINS_NO_IO_PATH_RTG4_APB_IF= $rtg4_apb_if ENCRYPTED_ARI1=$encrypted_cell"
  }
}

puts ""
puts "SDF analysis complete."
puts ""
puts "=========================================================================================="
puts ""

if { $verbosity <= 1 } \
{
    puts "SUMMARY for $sdf_file :"
	puts "-----------------------------------------------------------"
	puts "Total number of CFGx (LUTs) and ARI1_CC (carry-chain) combinational cell instances = $design_cells"
	puts "Total number of input pins to CFGx and ARI1_CC instances                           = $design_pins"
	puts "Total number of combinational input pins that are missing timing paths             = $design_pins_not_found"
    if { $rtg4_apb_if > 0 } \
    {
	puts "Total number of combinational input pins with missing timing paths related to RTG4 SerDes or FDDR APB interface = $rtg4_apb_if"
    }
} else \
{
    puts "SUMMARY for $sdf_file :"
	puts "-----------------------------------------------------------"
	puts "Total number of CFGx (LUTs) and ARI1_CC (carry-chain) combinational cell instances = $design_cells"
	puts "Total number of combination cell instances  with no timing arc                     = $wrn_cells"
	puts "Total number of input pins to CFGx and ARI1_CC instances                           = $design_pins"
	puts "Total number of combinational input pins that are missing timing paths             = $design_pins_not_found"
	puts "Total number of combinational input pins with missing timing paths related to RTG4 SerDes or FDDR APB interface = $rtg4_apb_if"
	puts "Total number of ARI1_CC instances that could not be analyzed due to encryption (IEEE-1735) = $encrypted_cell"
}

puts ""

if { $design_pins_not_found > 0 } \
{
	puts "***** Missing timing paths have been detected in this design. *****"
	puts ""
	puts "Please re-verify the Static Timing Analysis using the appropriate Libero release:"
	puts "-Libero SoC v11.9 SP6 (RTG4, SmartFusion2, IGLOO2),"
	puts "-Libero SoC v12.5 (RTG4, PolarFire),"
	puts "-Libero SoC v12.5 SP1 (RTG4, SmartFusion2, IGLOO2, PolarFire)."
	puts ""
	puts "If your design's P&R state is invalidated with the releases above,"
	puts "Migrate designs still in development to the releases listed above or later."
	puts "If you are not permitted to migrate your existing design, please contact Technical Support and provide the Libero version used to complete your design."
} else \
{
	puts "***** No missing timing paths detected. *****"
	puts "This SDF and Netlist are not impacted by CN20022."
}
