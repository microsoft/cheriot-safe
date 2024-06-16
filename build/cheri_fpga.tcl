
#==================================================
# Get Netlist Dir
#==================================================
set DesignRoot [lindex $argv 0 ]
set netlistDir [lindex $argv 1 ]
set files      [lindex $argv 2 ]
set xdcfiles   [lindex $argv 3 ]


set SysclkFreq [lindex $argv 4 ]

switch $SysclkFreq {
  20 { 
   set SysclkDiv1GHz 50
   }
  25 { 
   set SysclkDiv1GHz 40 
   }
  30 { 
   set SysclkDiv1GHz 33 
   }
  33 { 
   set SysclkDiv1GHz 30 
   }
  default { 
   set SysclkDiv1GHz 50
   }
}

 # give a little extra margin
set SysclkPeriod [expr $SysclkDiv1GHz - 0.5] 
set SysclkWaveform [list 0 [expr $SysclkPeriod/2.0]]

puts "--> SysclkPeriod is $SysclkPeriod ns, waveform is {$SysclkWaveform}"

#==================================================
# FPGA Build
#==================================================
set TOPLEVEL "msftDvIp_cheri_arty7_fpga"
#set PART "xcku115-flvb1760-1-c"
set PART "XC7A100TCSG324-1"
set SIMTOOL "vivado"
set FPGA_BUILD 1
set FPGA_NAME "cheri_arty7"

#==================================================
# Extra TCL commands from subsystem YAML
#==================================================
set_msg_config -id {[Synth 8-2490]} -new_severity "WARNING"

#==================================================
# Get Start Time
#==================================================
set begin_time [clock seconds]

#==================================================
# Create Project
#==================================================
create_project -in_memory $TOPLEVEL -part $PART
set_param general.maxThreads 8
set_param synth.elaboration.rodinMoreOptions "rt::set_parameter allowIndexedDefparam true"

#==================================================
# Create ethernet MAC IP
#==================================================
#exec rm -rf ./.srcs/ ./.gen/ ./.ip_user_files
#create_ip -name axi_ethernetlite -vendor xilinx.com -library ip -version 3.0 -module_name axi_ethernetlite_csafe0
#set_property -dict [list \
#  CONFIG.AXI_ACLK_FREQ_MHZ {20} \
#  CONFIG.C_INCLUDE_INTERNAL_LOOPBACK {1} \
#] [get_ips axi_ethernetlite_csafe0] 

#synth_ip [get_ips axi_ethernetlite_csafe0]

#generate_target all [get_ips axi_ethernetlite_csafe0]
#update_compile_order -fileset sources_1
#export_ip_user_files -of_objects [get_files ./.srcs/sources_1/ip/axi_ethernetlite_csafe0/axi_ethernetlite_csafe0.xci] -no_script -sync -force -quiet

#==================================================
# Source RTL
#==================================================
source $files

#==================================================
# Load Memory Init Files
#==================================================

#==================================================
# Set Additional Defines
#==================================================

#==================================================
# Create Directories
#==================================================
file mkdir ./$netlistDir/post-syn_reports
file mkdir ./$netlistDir/post-opt_reports
file mkdir ./$netlistDir/post-place_reports
file mkdir ./$netlistDir/post-route_reports
exec rm -f current_netlist
exec ln -sf $netlistDir current_netlist

#==================================================
# Synthesize Design
#==================================================
synth_design\
  -top $TOPLEVEL\
  -keep_equivalent_registers\
  -part $PART\
  -gated_clock_conversion on\
  -verilog_define PLAT__FPGA\
  -verilog_define LOAD_FPGA_MEMORIES\
  -verilog_define SYNTHESIS\
  -include_dirs $STITCH_INCLUDE_LIST\
  -generic SysclkDiv1GHz=$SysclkDiv1GHz

write_checkpoint -force ./$netlistDir/${TOPLEVEL}_synthesized.dcp
report_utilization -file ./$netlistDir/post-syn_reports/${TOPLEVEL}_utilization_synth.rpt
report_utilization -hierarchical -file ./$netlistDir/post-syn_reports/${TOPLEVEL}_utilization_synth.hier.rpt

#==================================================
# Read In Constraints
#==================================================
read_xdc $xdcfiles

#==================================================
# Optimize Design
#==================================================
opt_design

write_checkpoint -force ./$netlistDir/${TOPLEVEL}_optimized.dcp
report_drc -fail_on error -file ./$netlistDir/post-opt_reports/${TOPLEVEL}_drc_opt.rpt

#==================================================
# Place Design
#==================================================
place_design 
place_design -post_place_opt
catch { report_io                    -file ./$netlistDir/post-place_reports/${TOPLEVEL}_io_placed.rpt }
catch { report_clock_utilization     -file ./$netlistDir/post-place_reports/${TOPLEVEL}_clock_utilization_placed.rpt }
catch { report_utilization           -file ./$netlistDir/post-place_reports/${TOPLEVEL}_utilization_placed.rpt }
catch { report_utilization           -file ./$netlistDir/post-place_reports/${TOPLEVEL}_utilization_placed.hier.rpt -hierarchical }
catch { report_control_sets -verbose -file ./$netlistDir/post-place_reports/${TOPLEVEL}_control_sets_placed.rpt }
report_clocks                        -file ./$netlistDir/${TOPLEVEL}_clocks.rpt
report_clock_interaction             -file ./$netlistDir/${TOPLEVEL}_clocks.rpt -append
report_clock_networks                -file ./$netlistDir/${TOPLEVEL}_clocks.rpt -append
report_datasheet                     -file ./$netlistDir/${TOPLEVEL}_datasheet.rpt

if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]] < 0} {
    puts "place_design: Found setup timing violations => running physical optimization"
    phys_opt_design -directive ExploreWithAggressiveHoldFix
} else {puts "place_design: (setup) All user specified timing constraints are met"}

if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -hold]] < 0} {
    puts "place_design: Found hold timing violations => running physical optimization"
    phys_opt_design -directive ExploreWithAggressiveHoldFix
} else {puts "place_design: (hold) All user specified timing constraints are met"}

phys_opt_design -directive ExploreWithAggressiveHoldFix
phys_opt_design -directive ExploreWithAggressiveHoldFix

write_checkpoint -force ./$netlistDir/${TOPLEVEL}_placed.dcp

#==================================================
# Route Design
#==================================================
set_param route.enableHoldExpnBailout 0
set_param route.enableGlobalHoldIter 1
route_design -directive Explore

if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup -hold]] < 0} {
    puts "route_design: Timing Violations found"
} else { 
    puts "route_design: All user specified timing constraints are met"
}

phys_opt_design -directive ExploreWithAggressiveHoldFix

write_checkpoint -force ./$netlistDir/${TOPLEVEL}_routed.dcp

catch { report_drc            -file ./$netlistDir/post-route_reports/${TOPLEVEL}_drc_routed.rpt }
catch { report_power          -file ./$netlistDir/post-route_reports/${TOPLEVEL}_power_routed.rpt }
catch { report_route_status   -file ./$netlistDir/post-route_reports/${TOPLEVEL}_route_status_routed.rpt }
catch { report_timing_summary -file ./$netlistDir/post-route_reports/${TOPLEVEL}_timing_summary_routed.rpt }
catch { report_timing -max_paths 100 -nworst 100 -unique_pins -file ./$netlistDir/post-route_reports/${TOPLEVEL}_timing_nworst_setup_routed.rpt }
catch { report_timing -max_paths 100 -nworst 100 -unique_pins -hold -file ./$netlistDir/post-route_reports/${TOPLEVEL}_timing_nworst_hold_routed.rpt }


#==================================================
# Write Bitstream
#==================================================
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone [current_design]
set_property BITSTREAM.CONFIG.PERSIST No [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.STARTUP.MATCH_CYCLE Auto [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
# Write out .bit file using target bit file name and removing any intermediates.
# This file is timestamped
# This file should be put under version control in this directory
set systemTime [clock seconds]

#Create a unique timestamped reference for future use
set BIT_FILENAME "./$netlistDir/${TOPLEVEL}_${FPGA_NAME}_${netlistDir}"
write_bitstream -force ${BIT_FILENAME}.bit
write_cfgmem -force -format MCS -interface spix4 -size 64 -loadbit "up 0x0 ${BIT_FILENAME}.bit" -file ${BIT_FILENAME}.mcs

puts "FPGA Build - Vivado run completed successfully on [clock format [clock seconds]]."
puts "	Entire run took [expr ([clock seconds]-$begin_time)/3600] hour(s), [expr (([clock seconds]-$begin_time)%3600)/60] minute(s) and [expr (([clock seconds]-$begin_time)%3600)%60] second(s)."
puts "The script run_vivado.tcl completed successfully."
exec echo > build.passed

set PWD [exec pwd]
puts "
Bitfile location: ${PWD}/${BIT_FILENAME}.bit
"
