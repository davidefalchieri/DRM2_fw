
# (C) 2001-2012 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.



# ----------------------------------------
# Initialize the variable
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
} 

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "v1390sim"
} elseif { ![ string match "" $TOP_LEVEL_NAME ] } { 
  set TOP_LEVEL_NAME "$TOP_LEVEL_NAME"
} 

# ----------------------------------------


if ![info exists SRC_DIR] { 
  set SRC_DIR "./../implement/v1390trm/hdl"
} elseif { ![ string match "" $SRC_DIR ] } { 
  set SRC_DIR "$SRC_DIR"
} 
if ![info exists PKG_DIR] { 
  set PKG_DIR "./../implement/v1390trm/package"
} elseif { ![ string match "" $PKG_DIR ] } { 
  set PKG_DIR "$PKG_DIR"
} 

if ![info exists TB_DIR] { 
  set TB_DIR "./../implement/v1390trm/stimulus"
} elseif { ![ string match "" $TB_DIR ] } { 
  set TB_DIR "$TB_DIR"
} 

if ![info exists IP_DIR] { 
  set IP_DIR "./../implement/v1390trm/smartgen"
} elseif { ![ string match "" $IP_DIR ] } { 
  set IP_DIR "$IP_DIR"
} 


# ----------------------------------------
# Copy ROM/RAM files to simulation directory


# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib      ./libraries/     
ensure_lib      ./libraries/work/
vmap       work ./libraries/work/
#if { ![ string match "*ModelSim ACTEL*" [ vsim -version ] ] } {
  ensure_lib                        ./libraries/apa/            
  vmap       apa                    ./libraries/apa/            
#}

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  vcom     "C:/Actel/Libero_v9.1/Designer/lib/modelsim/precompiled/vhdl/src/apa.vhd"        -work apa              
#  if { ![ string match "*ModelSim ACTEL*" [ vsim -version ] ] } {
#    vcom     "C:/Actel/Libero_v9.1/Designer/lib/modelsim/precompiled/vhdl/src/apa.vhd"        -work apa            
#  }
}


# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vcom                                           "$IP_DIR/PLL_tdc/PLL_tdc.vhd"      
  vcom                                           "$IP_DIR/PLL_sram/PLL_sram.vhd"      
  vcom                                           "$SRC_DIR/V1390pkg.vhd"      
  vcom                                           "$SRC_DIR/reset_mod.vhd"      
  vcom                                           "$SRC_DIR/roc32.vhd"      
  vcom                                           "$SRC_DIR/spi_interf.vhd"      
  vcom                                           "$SRC_DIR/I2C_interf.vhd"      
  vcom                                           "$SRC_DIR/vinterf.vhd"      
  vcom                                           "$SRC_DIR/v1390trm.vhd"      
  vcom                                           "$TB_DIR/io_utils.vhd"      
  vcom                                           "$TB_DIR/atmega16.vhd"      
  vcom                                           "$TB_DIR/fct244.vhd"      
  vcom                                           "$TB_DIR/fct16543.vhd"      
  vcom                                           "$TB_DIR/flash.vhd"      
  vcom                                           "$TB_DIR/iopan.vhd"      
  vcom                                           "$TB_DIR/master.vhd"      
  vcom                                           "$TB_DIR/osc.vhd"      
  vcom                                           "$TB_DIR/sram.vhd"      
  vcom                                           "$TB_DIR/syncfifo.vhd"      
  vcom                                           "$TB_DIR/tdc.vhd"      
  vcom                                           "$TB_DIR/tdcchaines.vhd"      
  vcom                                           "$TB_DIR/micro.vhd"      
  vcom                                           "$TB_DIR/vme.vhd"      
  vcom                                           "$TB_DIR/v1390sim.vhd"      
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  vsim -t ps -L work \
  $TOP_LEVEL_NAME
}


# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  com
  elab
"

#alias ld "
#  dev_com
#  com
#  elab
#"


# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
}
h
