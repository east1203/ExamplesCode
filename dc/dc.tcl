#2019-01-15
#dyk
#description:
#		design compiler scripts
#
remove_design -design

source ./scripts/synopsys_dc.setup
set CLOCK_NAME  blif_clk_net
#set CLOCK_NAME iccad_clk
#set DESIGN_NAME s38584_bench 
set DESIGN_NAME sequencial_fsm
##design name is same with top module's name
set DESIGN $DESIGN_NAME
set HAVCLK "True"
set DC_PATH ["pwd"]
set TF_PATH "./../ref/tf"
set TLUPLUS_PATH "./../ref/tluplus"
set MW_LIB_PATH "./../ref/mw_lib"
set LEF_PATH "./../lef"
set DC_OUTPUTS "./outputs"
set OUTPUTS_PATH $DC_PATH/outputs/$DESIGN_NAME
set LOGS_PATH $DC_PATH/logs/$DESIGN_NAME
set REPORTS_PATH $DC_PATH/reports/$DESIGN_NAME
################################################
## mkdir for design
################################################
if {![file exists $OUTPUTS_PATH]} { file mkdir $OUTPUTS_PATH }
if {![file exists $LOGS_PATH]} { file mkdir $LOGS_PATH }
if {![file exists $REPORTS_PATH]} { file mkdir $REPORTS_PATH }




set hdlin_translate_off_skip_text "true"
set verilogout_no_tri             "true"
set default_schematic_options     "-size infinite"
set write_name_nets_same_as_ports "true"

#set INPUT_PIN "ZN"
set DRIVE_CELL "scc40nll_hdc40_hvt_tt_v1p1_25c_basic/CLKBUFV20_8TH40"
set DRIVE_PIN "Z"

set REF_LOAD "scc40nll_hdc40_hvt_tt_v1p1_25c_basic/CLKBUFV20_8TH40/I"

set MAX_INPUT_DELAY 0.2
set MIN_INPUT_DELAY 0.1
set MAX_OUTPUT_DELAY 0.2
set MIN_OUTPUT_DELAY 0.1
set CLOCK_UNCERTAINTY 0.1

set MAX_TRANSITION 0.15
set MAX_FANOUT 10
set PERIOD 1
### read design 
analyze -format verilog ./files/filelist.v
elaborate $DESIGN   > $LOGS_PATH/read_design.log

current_design $DESIGN
link

#set MAX_TRANSITION [get_attribute $DRIVING_CELL/$DRIVE_PIN max_transition]
set MAX_CAPACITANCE [get_attribute  $DRIVE_CELL/$DRIVE_PIN max_capacitance]


### set operating condition
#
#set_min_library  scc018ug_uhd_rvt_ff_v1p32_0c_basic.db -min_version \
#						scc018ug_uhd_rvt_ss_v1p08_125c_basic.db
#set_operating_conditions -min ff_v1p32_0c 							\
#				-min_library scc018ug_uhd_rvt_ff_v1p32_0c_basic		\
#				-max ss_v1p08_125c									\
#				-max_library scc018ug_uhd_rvt_ss_v1p08_125c_basic	\
#				-analysis_type bc_wc
set_operating_conditions tt_v1p1_25c -lib scc40nll_hdc40_hvt_tt_v1p1_25c_basic			
###setting wire load model
#
#set auto_wire_load_selection false
#set_wire_load_mode top
#set_wire_load_model -name "4000" [current_design]

###setting I/O characteristic
#

set_load [expr [load_of $REF_LOAD]*30] [all_outputs]
#set_load 10 [all_outputs]
set_fanout 10 [all_outputs]

###setting design constraint
#

set_max_capacitance [expr $MAX_CAPACITANCE/2] [current_design]
set_max_fanout $MAX_FANOUT [current_design]
set_max_transition $MAX_TRANSITION [current_design]

if { $HAVCLK } {
	set all_in_exc_clk [remove_from_collection [all_inputs] [get_ports blif_clk_net]]
	#set_driving_cell -lib_cell $DRIVE_CELL $all_in_exc_clk
	#set_driving_cell -lib_cell scc018ug_uhd_rvt_ff_v1p32_0c_basic/BUFUHDV8 $all_in_exc_clk
	#set_driving_cell -library scc018ug_uhd_rvt_ff_v1p32_0c_basic 	\
	#				-lib_cell BUFUHDV8 $all_in_exc_clk
	set_input_transition 0.1 $all_in_exc_clk
	set_drive 0 [get_ports blif_clk_net]
###setting timing constraint
#
	create_clock -period $PERIOD -name CLK [get_ports blif_clk_net]
	set_input_delay -max $MAX_INPUT_DELAY -clock CLK [all_inputs]
	set_input_delay -min $MIN_INPUT_DELAY -clock CLK [all_inputs]
	set_output_delay -max $MAX_OUTPUT_DELAY -clock CLK [all_outputs]
	set_output_delay -min $MIN_OUTPUT_DELAY -clock CLK [all_outputs]
	set_clock_uncertainty $CLOCK_UNCERTAINTY [get_ports $CLOCK_NAME]
}
set_max_area 0


#ungroup -all -flatten

set_flatten false -design [get_designs $DESIGN ]
##compile
#
#compile -map_effort medium
set_flatten false
set_structure true
compile_ultra  -no_autoungroup
#compile -map_effort high 

#remove_attribute [current_design ] flatten
#remove_attribute [current_design ] ungroup
#set_ungroup [current_design] false



# For XG mode portability to back-end tools:
set_fix_multiple_port_nets -all -buffer_constant

###set timing analyze path group
#group_path -name INPUTS -from [all_inputs]
#group_path -name OUTPUTS -from [all_outputs]
#group_path -name COMBO -from [all_inputs] -to [all_outputs]

check_design > $REPORTS_PATH/check_desing.log

###report design
#
report_constraint > $REPORTS_PATH/constraint.log
report_timing > $REPORTS_PATH/timing.log
report_area > $REPORTS_PATH/area.log
report_power > $REPORTS_PATH/power.log
###check
#
check_timing > $REPORTS_PATH/check_timing.log

### save design
#
write -format verilog -hierarchy -output $OUTPUTS_PATH/$DESIGN_NAME.v
write_sdc $OUTPUTS_PATH/$DESIGN_NAME.sdc
write -format ddc -hierarchy -output $OUTPUTS_PATH/$DESIGN_NAME.ddc
write_sdf $OUTPUTS_PATH/$DESIGN_NAME.sdf

read_file -format verilog $OUTPUTS_PATH/$DESIGN_NAME.v







