
################################################################
# This is a generated script based on design: base_zynq_design
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source base_zynq_design_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z045ffg900-2
#    set_property BOARD_PART xilinx.com:zc706:part0:1.2 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name base_zynq_design

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: NSD_CHAN_15
proc create_hier_cell_NSD_CHAN_15 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_15() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_14
proc create_hier_cell_NSD_CHAN_14 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_14() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_13
proc create_hier_cell_NSD_CHAN_13 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_13() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_12
proc create_hier_cell_NSD_CHAN_12 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_12() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_11
proc create_hier_cell_NSD_CHAN_11 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_11() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_10
proc create_hier_cell_NSD_CHAN_10 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_10() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_9
proc create_hier_cell_NSD_CHAN_9 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_9() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_8
proc create_hier_cell_NSD_CHAN_8 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_8() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_7
proc create_hier_cell_NSD_CHAN_7 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_7() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_6
proc create_hier_cell_NSD_CHAN_6 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_6() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_5
proc create_hier_cell_NSD_CHAN_5 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_5() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_4
proc create_hier_cell_NSD_CHAN_4 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_4() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_3
proc create_hier_cell_NSD_CHAN_3 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_3() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_2
proc create_hier_cell_NSD_CHAN_2 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_2() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_1
proc create_hier_cell_NSD_CHAN_1 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_1() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {50} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {32} \
 ] $Select_ABS

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins Select_ABS/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Resize_to_16_bits1_M_AXIS_DATA [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CHAN_0
proc create_hier_cell_NSD_CHAN_0 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CHAN_0() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_CORDIC
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_FFT
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_CONFIG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: FFT_Tone_Det, and set properties
  set FFT_Tone_Det [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 FFT_Tone_Det ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_luts} \
CONFIG.complex_mult_type {use_mults_resources} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {12} \
CONFIG.memory_options_reorder {distributed_ram} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {0} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {12} \
CONFIG.rounding_modes {convergent_rounding} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {100} \
CONFIG.transform_length {16} \
CONFIG.xk_index {false} \
 ] $FFT_Tone_Det

  # Create instance: Magnitude_Phase, and set properties
  set Magnitude_Phase [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 Magnitude_Phase ]
  set_property -dict [ list \
CONFIG.ARESETN {true} \
CONFIG.Coarse_Rotation {true} \
CONFIG.Compensation_Scaling {No_Scale_Compensation} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Translate} \
CONFIG.Output_Width {16} \
CONFIG.cartesian_has_tuser {false} \
CONFIG.cartesian_tuser_width {1} \
CONFIG.flow_control {Blocking} \
CONFIG.optimize_goal {Resources} \
CONFIG.out_tready {true} \
 ] $Magnitude_Phase

  # Create instance: Resize_to_16_bits, and set properties
  set Resize_to_16_bits [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Resize_to_16_bits ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $Resize_to_16_bits

  # Create instance: Select_ABS, and set properties
  set Select_ABS [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 Select_ABS ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {16} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
 ] $Select_ABS

  # Create instance: axis_broadcaster_0, and set properties
  set axis_broadcaster_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_0 ]
  set_property -dict [ list \
CONFIG.M00_TDATA_REMAP {tdata[31:0]} \
CONFIG.M01_TDATA_REMAP {tdata[31:0]} \
CONFIG.M_TDATA_NUM_BYTES {4} \
CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_broadcaster_0

  # Create instance: axis_broadcaster_1, and set properties
  set axis_broadcaster_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_1 ]
  set_property -dict [ list \
CONFIG.M00_TDATA_REMAP {tdata[31:0]} \
CONFIG.M01_TDATA_REMAP {tdata[31:0]} \
CONFIG.M_TDATA_NUM_BYTES {4} \
CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_broadcaster_1

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA1 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins Select_ABS/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_CONFIG] [get_bd_intf_pins FFT_Tone_Det/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXIS_FFT] [get_bd_intf_pins axis_broadcaster_0/M00_AXIS]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXIS_CORDIC] [get_bd_intf_pins axis_broadcaster_1/M00_AXIS]
  connect_bd_intf_net -intf_net FFT_Tone_Det_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/M_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_0/S_AXIS]
  connect_bd_intf_net -intf_net Magnitude_Phase_M_AXIS_DOUT [get_bd_intf_pins Magnitude_Phase/M_AXIS_DOUT] [get_bd_intf_pins axis_broadcaster_1/S_AXIS]
  connect_bd_intf_net -intf_net Resize_to_16_bits_M_AXIS_DATA [get_bd_intf_pins FFT_Tone_Det/S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Resize_to_16_bits/S_AXIS_DATA]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins Magnitude_Phase/S_AXIS_CARTESIAN] [get_bd_intf_pins axis_broadcaster_0/M01_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M01_AXIS [get_bd_intf_pins Select_ABS/S_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_1/M01_AXIS]

  # Create port connections
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Tone_Det/aclk] [get_bd_pins Magnitude_Phase/aclk] [get_bd_pins Resize_to_16_bits/aclk] [get_bd_pins Select_ABS/aclk] [get_bd_pins axis_broadcaster_0/aclk] [get_bd_pins axis_broadcaster_1/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins fft_resetn] [get_bd_pins FFT_Tone_Det/aresetn] [get_bd_pins Resize_to_16_bits/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins Magnitude_Phase/aresetn] [get_bd_pins Select_ABS/aresetn] [get_bd_pins axis_broadcaster_0/aresetn] [get_bd_pins axis_broadcaster_1/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_Channels
proc create_hier_cell_NSD_Channels { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_Channels() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M02_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M03_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M04_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M05_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M06_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M07_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M08_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M09_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M10_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M11_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M12_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M13_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M14_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M15_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_CORDIC
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_FFT
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S00_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S00_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S01_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S01_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S02_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S02_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S03_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S03_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S04_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S04_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S05_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S05_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S06_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S06_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S07_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S07_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S08_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S08_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S09_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S09_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S10_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S10_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S11_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S11_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S12_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S12_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S13_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S13_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S14_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S14_AXIS_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S15_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S15_AXIS_FFT_CFG

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst fft_resetn

  # Create instance: NSD_CHAN_0
  create_hier_cell_NSD_CHAN_0 $hier_obj NSD_CHAN_0

  # Create instance: NSD_CHAN_1
  create_hier_cell_NSD_CHAN_1 $hier_obj NSD_CHAN_1

  # Create instance: NSD_CHAN_2
  create_hier_cell_NSD_CHAN_2 $hier_obj NSD_CHAN_2

  # Create instance: NSD_CHAN_3
  create_hier_cell_NSD_CHAN_3 $hier_obj NSD_CHAN_3

  # Create instance: NSD_CHAN_4
  create_hier_cell_NSD_CHAN_4 $hier_obj NSD_CHAN_4

  # Create instance: NSD_CHAN_5
  create_hier_cell_NSD_CHAN_5 $hier_obj NSD_CHAN_5

  # Create instance: NSD_CHAN_6
  create_hier_cell_NSD_CHAN_6 $hier_obj NSD_CHAN_6

  # Create instance: NSD_CHAN_7
  create_hier_cell_NSD_CHAN_7 $hier_obj NSD_CHAN_7

  # Create instance: NSD_CHAN_8
  create_hier_cell_NSD_CHAN_8 $hier_obj NSD_CHAN_8

  # Create instance: NSD_CHAN_9
  create_hier_cell_NSD_CHAN_9 $hier_obj NSD_CHAN_9

  # Create instance: NSD_CHAN_10
  create_hier_cell_NSD_CHAN_10 $hier_obj NSD_CHAN_10

  # Create instance: NSD_CHAN_11
  create_hier_cell_NSD_CHAN_11 $hier_obj NSD_CHAN_11

  # Create instance: NSD_CHAN_12
  create_hier_cell_NSD_CHAN_12 $hier_obj NSD_CHAN_12

  # Create instance: NSD_CHAN_13
  create_hier_cell_NSD_CHAN_13 $hier_obj NSD_CHAN_13

  # Create instance: NSD_CHAN_14
  create_hier_cell_NSD_CHAN_14 $hier_obj NSD_CHAN_14

  # Create instance: NSD_CHAN_15
  create_hier_cell_NSD_CHAN_15 $hier_obj NSD_CHAN_15

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M00_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_0/M_AXIS]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXIS_FFT] [get_bd_intf_pins NSD_CHAN_0/M_AXIS_FFT]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M_AXIS_CORDIC] [get_bd_intf_pins NSD_CHAN_0/M_AXIS_CORDIC]
  connect_bd_intf_net -intf_net Conn33 [get_bd_intf_pins S00_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_0/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net NSD_CHAN_10_M_AXIS [get_bd_intf_pins M10_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_10/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_11_M_AXIS [get_bd_intf_pins M11_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_11/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_12_M_AXIS [get_bd_intf_pins M12_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_12/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_13_M_AXIS [get_bd_intf_pins M13_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_13/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_14_M_AXIS [get_bd_intf_pins M14_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_14/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_15_M_AXIS [get_bd_intf_pins M15_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_15/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_1_M_AXIS [get_bd_intf_pins M01_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_1/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_2_M_AXIS [get_bd_intf_pins M02_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_2/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_3_M_AXIS [get_bd_intf_pins M03_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_3/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_4_M_AXIS [get_bd_intf_pins M04_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_4/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_5_M_AXIS [get_bd_intf_pins M05_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_5/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_6_M_AXIS [get_bd_intf_pins M06_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_6/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_7_M_AXIS [get_bd_intf_pins M07_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_7/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_8_M_AXIS [get_bd_intf_pins M08_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_8/M_AXIS]
  connect_bd_intf_net -intf_net NSD_CHAN_9_M_AXIS [get_bd_intf_pins M09_AXIS_ABS] [get_bd_intf_pins NSD_CHAN_9/M_AXIS]
  connect_bd_intf_net -intf_net S01_AXIS_DATA_1 [get_bd_intf_pins S01_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_1/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S01_AXIS_FFT_CFG_1 [get_bd_intf_pins S01_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_1/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S02_AXIS_DATA_1 [get_bd_intf_pins S02_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_2/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S02_AXIS_FFT_CFG_1 [get_bd_intf_pins S02_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_2/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S03_AXIS_DATA_1 [get_bd_intf_pins S03_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_3/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S03_AXIS_FFT_CFG_1 [get_bd_intf_pins S03_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_3/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S04_AXIS_DATA_1 [get_bd_intf_pins S04_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_4/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S04_AXIS_FFT_CFG_1 [get_bd_intf_pins S04_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_4/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S05_AXIS_DATA_1 [get_bd_intf_pins S05_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_5/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S05_AXIS_FFT_CFG_1 [get_bd_intf_pins S05_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_5/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S06_AXIS_DATA_1 [get_bd_intf_pins S06_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_6/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S06_AXIS_FFT_CFG_1 [get_bd_intf_pins S06_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_6/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S07_AXIS_DATA_1 [get_bd_intf_pins S07_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_7/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S07_AXIS_FFT_CFG_1 [get_bd_intf_pins S07_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_7/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S08_AXIS_DATA_1 [get_bd_intf_pins S08_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_8/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S08_AXIS_FFT_CFG_1 [get_bd_intf_pins S08_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_8/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S09_AXIS_DATA_1 [get_bd_intf_pins S09_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_9/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S09_AXIS_FFT_CFG_1 [get_bd_intf_pins S09_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_9/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S10_AXIS_DATA_1 [get_bd_intf_pins S10_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_10/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S10_AXIS_FFT_CFG_1 [get_bd_intf_pins S10_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_10/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S11_AXIS_DATA_1 [get_bd_intf_pins S11_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_11/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S11_AXIS_FFT_CFG_1 [get_bd_intf_pins S11_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_11/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S12_AXIS_DATA_1 [get_bd_intf_pins S12_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_12/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S12_AXIS_FFT_CFG_1 [get_bd_intf_pins S12_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_12/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S13_AXIS_DATA_1 [get_bd_intf_pins S13_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_13/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S13_AXIS_FFT_CFG_1 [get_bd_intf_pins S13_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_13/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S14_AXIS_DATA_1 [get_bd_intf_pins S14_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_14/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S14_AXIS_FFT_CFG_1 [get_bd_intf_pins S14_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_14/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S15_AXIS_DATA_1 [get_bd_intf_pins S15_AXIS_DATA] [get_bd_intf_pins NSD_CHAN_15/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S15_AXIS_FFT_CFG_1 [get_bd_intf_pins S15_AXIS_FFT_CFG] [get_bd_intf_pins NSD_CHAN_15/S_AXIS_CONFIG]

  # Create port connections
  connect_bd_net -net aclk_2 [get_bd_pins aclk] [get_bd_pins NSD_CHAN_0/aclk] [get_bd_pins NSD_CHAN_1/aclk] [get_bd_pins NSD_CHAN_10/aclk] [get_bd_pins NSD_CHAN_11/aclk] [get_bd_pins NSD_CHAN_12/aclk] [get_bd_pins NSD_CHAN_13/aclk] [get_bd_pins NSD_CHAN_14/aclk] [get_bd_pins NSD_CHAN_15/aclk] [get_bd_pins NSD_CHAN_2/aclk] [get_bd_pins NSD_CHAN_3/aclk] [get_bd_pins NSD_CHAN_4/aclk] [get_bd_pins NSD_CHAN_5/aclk] [get_bd_pins NSD_CHAN_6/aclk] [get_bd_pins NSD_CHAN_7/aclk] [get_bd_pins NSD_CHAN_8/aclk] [get_bd_pins NSD_CHAN_9/aclk]
  connect_bd_net -net aresetn_2 [get_bd_pins aresetn] [get_bd_pins NSD_CHAN_0/aresetn] [get_bd_pins NSD_CHAN_1/aresetn] [get_bd_pins NSD_CHAN_10/aresetn] [get_bd_pins NSD_CHAN_11/aresetn] [get_bd_pins NSD_CHAN_12/aresetn] [get_bd_pins NSD_CHAN_13/aresetn] [get_bd_pins NSD_CHAN_14/aresetn] [get_bd_pins NSD_CHAN_15/aresetn] [get_bd_pins NSD_CHAN_2/aresetn] [get_bd_pins NSD_CHAN_3/aresetn] [get_bd_pins NSD_CHAN_4/aresetn] [get_bd_pins NSD_CHAN_5/aresetn] [get_bd_pins NSD_CHAN_6/aresetn] [get_bd_pins NSD_CHAN_7/aresetn] [get_bd_pins NSD_CHAN_8/aresetn] [get_bd_pins NSD_CHAN_9/aresetn]
  connect_bd_net -net fft_resetn_1 [get_bd_pins fft_resetn] [get_bd_pins NSD_CHAN_0/fft_resetn] [get_bd_pins NSD_CHAN_1/fft_resetn] [get_bd_pins NSD_CHAN_10/fft_resetn] [get_bd_pins NSD_CHAN_11/fft_resetn] [get_bd_pins NSD_CHAN_12/fft_resetn] [get_bd_pins NSD_CHAN_13/fft_resetn] [get_bd_pins NSD_CHAN_14/fft_resetn] [get_bd_pins NSD_CHAN_15/fft_resetn] [get_bd_pins NSD_CHAN_2/fft_resetn] [get_bd_pins NSD_CHAN_3/fft_resetn] [get_bd_pins NSD_CHAN_4/fft_resetn] [get_bd_pins NSD_CHAN_5/fft_resetn] [get_bd_pins NSD_CHAN_6/fft_resetn] [get_bd_pins NSD_CHAN_7/fft_resetn] [get_bd_pins NSD_CHAN_8/fft_resetn] [get_bd_pins NSD_CHAN_9/fft_resetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_MOVING_MAG_SQUARED
proc create_hier_cell_NSD_MOVING_MAG_SQUARED { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_MOVING_MAG_SQUARED() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS_BCAST
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_BCAST
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M02_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M03_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M04_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M05_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M06_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M07_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M08_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M09_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M10_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M11_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M12_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M13_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M14_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M15_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M15_AXIS_BCAST
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_CORDIC
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_FFT
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_FFT_CFG

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn
  create_bd_pin -dir O config_done
  create_bd_pin -dir I config_in
  create_bd_pin -dir I -type rst fft_resetn
  create_bd_pin -dir I -type rst sys_resetn

  # Create instance: BCAST_FFT_CFG, and set properties
  set BCAST_FFT_CFG [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Broadcast_Delayed:1.0 BCAST_FFT_CFG ]
  set_property -dict [ list \
CONFIG.C_AXIS_DATA_TDATA_WIDTH {8} \
CONFIG.C_HAS_DELAY {false} \
CONFIG.C_HAS_TLAST {false} \
CONFIG.C_N_PORTS_MASTER {16} \
 ] $BCAST_FFT_CFG

  # Create instance: BCAST_RXD_DELAYED, and set properties
  set BCAST_RXD_DELAYED [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Broadcast_Delayed:1.0 BCAST_RXD_DELAYED ]
  set_property -dict [ list \
CONFIG.C_AXIS_DATA_TDATA_WIDTH {24} \
CONFIG.C_HAS_DELAY {true} \
CONFIG.C_HAS_TLAST {true} \
CONFIG.C_N_PORTS_MASTER {16} \
 ] $BCAST_RXD_DELAYED

  # Create instance: FFT_Controller_0, and set properties
  set FFT_Controller_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:FFT_Controller:2.0 FFT_Controller_0 ]
  set_property -dict [ list \
CONFIG.CFG_EXT_EN {true} \
CONFIG.C_HAS_DIAGS {false} \
CONFIG.C_M_AXIS_CONFIG_TDATA_WIDTH {8} \
 ] $FFT_Controller_0

  # Create instance: NSD_Channels
  create_hier_cell_NSD_Channels $hier_obj NSD_Channels

  # Create instance: axis_broadcaster_0, and set properties
  set axis_broadcaster_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_0 ]
  set_property -dict [ list \
CONFIG.HAS_TLAST {1} \
CONFIG.M00_TDATA_REMAP {tdata[23:0]} \
CONFIG.M01_TDATA_REMAP {tdata[23:0]} \
CONFIG.M_TDATA_NUM_BYTES {3} \
CONFIG.S_TDATA_NUM_BYTES {3} \
 ] $axis_broadcaster_0

  # Create instance: axis_broadcaster_1, and set properties
  set axis_broadcaster_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_1 ]
  set_property -dict [ list \
CONFIG.HAS_TLAST {1} \
CONFIG.M00_TDATA_REMAP {tdata[23:0]} \
CONFIG.M01_TDATA_REMAP {tdata[23:0]} \
CONFIG.M_TDATA_NUM_BYTES {3} \
CONFIG.S_TDATA_NUM_BYTES {3} \
 ] $axis_broadcaster_1

  # Create instance: axis_broadcaster_2, and set properties
  set axis_broadcaster_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_2 ]
  set_property -dict [ list \
CONFIG.HAS_TLAST {1} \
CONFIG.M00_TDATA_REMAP {tdata[23:0]} \
CONFIG.M01_TDATA_REMAP {tdata[23:0]} \
CONFIG.M_TDATA_NUM_BYTES {3} \
CONFIG.S_TDATA_NUM_BYTES {3} \
 ] $axis_broadcaster_2

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M02_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M02_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S02_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M03_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M03_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S03_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M04_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M04_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S04_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M05_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M05_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S05_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M06_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M06_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S06_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M07_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M07_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S07_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M08_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M08_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S08_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M09_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M09_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S09_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M10_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M10_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S10_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M11_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M11_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S11_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M12_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M12_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S12_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M13_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M13_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S13_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_0_M14_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M14_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S14_AXIS_DATA]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M00_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M00_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S00_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M01_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M01_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S01_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M02_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M02_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S02_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M03_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M03_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S03_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M04_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M04_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S04_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M05_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M05_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S05_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M06_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M06_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S06_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M07_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M07_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S07_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M08_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M08_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S08_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M09_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M09_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S09_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M10_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M10_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S10_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M11_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M11_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S11_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M12_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M12_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S12_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M13_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M13_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S13_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M14_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M14_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S14_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net AXI4_Stream_Broadcast_Delayed_1_M15_AXIS_DATA [get_bd_intf_pins BCAST_FFT_CFG/M15_AXIS_DATA] [get_bd_intf_pins NSD_Channels/S15_AXIS_FFT_CFG]
  connect_bd_intf_net -intf_net BCAST_RXD_DELAYED_M00_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M00_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_0/S_AXIS]
  connect_bd_intf_net -intf_net BCAST_RXD_DELAYED_M01_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M01_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_1/S_AXIS]
  connect_bd_intf_net -intf_net BCAST_RXD_DELAYED_M15_AXIS_DATA [get_bd_intf_pins BCAST_RXD_DELAYED/M15_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_2/S_AXIS]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins BCAST_RXD_DELAYED/S_AXIS_DATA]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_FFT_CFG] [get_bd_intf_pins FFT_Controller_0/S00_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M00_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M00_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M01_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M01_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M02_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M02_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M03_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M03_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M04_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M04_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M05_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M05_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M06_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M06_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M07_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M07_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn11 [get_bd_intf_pins M08_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M08_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn12 [get_bd_intf_pins M09_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M09_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn13 [get_bd_intf_pins M10_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M10_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn14 [get_bd_intf_pins M11_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M11_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn15 [get_bd_intf_pins M12_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M12_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn16 [get_bd_intf_pins M13_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M13_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn17 [get_bd_intf_pins M14_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M14_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn18 [get_bd_intf_pins M15_AXIS_ABS] [get_bd_intf_pins NSD_Channels/M15_AXIS_ABS]
  connect_bd_intf_net -intf_net Conn19 [get_bd_intf_pins M_AXIS_FFT] [get_bd_intf_pins NSD_Channels/M_AXIS_FFT]
  connect_bd_intf_net -intf_net Conn20 [get_bd_intf_pins M_AXIS_CORDIC] [get_bd_intf_pins NSD_Channels/M_AXIS_CORDIC]
  connect_bd_intf_net -intf_net Conn22 [get_bd_intf_pins M00_AXIS_BCAST] [get_bd_intf_pins axis_broadcaster_0/M00_AXIS]
  connect_bd_intf_net -intf_net Conn23 [get_bd_intf_pins M01_AXIS_BCAST] [get_bd_intf_pins axis_broadcaster_1/M00_AXIS]
  connect_bd_intf_net -intf_net Conn24 [get_bd_intf_pins M15_AXIS_BCAST] [get_bd_intf_pins axis_broadcaster_2/M00_AXIS]
  connect_bd_intf_net -intf_net FFT_Controller_0_M_AXIS_CONFIG [get_bd_intf_pins BCAST_FFT_CFG/S_AXIS_DATA] [get_bd_intf_pins FFT_Controller_0/M_AXIS_CONFIG]
  connect_bd_intf_net -intf_net axis_broadcaster_0_M01_AXIS [get_bd_intf_pins NSD_Channels/S00_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_0/M01_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M01_AXIS [get_bd_intf_pins NSD_Channels/S01_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_1/M01_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_2_M01_AXIS [get_bd_intf_pins NSD_Channels/S15_AXIS_DATA] [get_bd_intf_pins axis_broadcaster_2/M01_AXIS]

  # Create port connections
  connect_bd_net -net FFT_Controller_0_config_done [get_bd_pins config_done] [get_bd_pins FFT_Controller_0/config_done]
  connect_bd_net -net aclk_2 [get_bd_pins aclk] [get_bd_pins BCAST_FFT_CFG/aclk] [get_bd_pins BCAST_RXD_DELAYED/aclk] [get_bd_pins FFT_Controller_0/aclk] [get_bd_pins NSD_Channels/aclk] [get_bd_pins axis_broadcaster_0/aclk] [get_bd_pins axis_broadcaster_1/aclk] [get_bd_pins axis_broadcaster_2/aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins aresetn] [get_bd_pins FFT_Controller_0/aresetn]
  connect_bd_net -net aresetn_1 [get_bd_pins sys_resetn] [get_bd_pins BCAST_RXD_DELAYED/aresetn] [get_bd_pins NSD_Channels/aresetn] [get_bd_pins axis_broadcaster_0/aresetn] [get_bd_pins axis_broadcaster_1/aresetn] [get_bd_pins axis_broadcaster_2/aresetn]
  connect_bd_net -net config_in_1 [get_bd_pins config_in] [get_bd_pins FFT_Controller_0/config_in]
  connect_bd_net -net fft_resetn_1 [get_bd_pins fft_resetn] [get_bd_pins BCAST_FFT_CFG/aresetn] [get_bd_pins NSD_Channels/fft_resetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: TX_DATA_SOURCE
proc create_hier_cell_TX_DATA_SOURCE { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_TX_DATA_SOURCE() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI1

  # Create pins
  create_bd_pin -dir O -type intr irq
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst s00_axi_aresetn

  # Create instance: AXI4_Stream_Data_Source, and set properties
  set AXI4_Stream_Data_Source [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Source:2.0 AXI4_Stream_Data_Source ]
  set_property -dict [ list \
CONFIG.C_M00_AXIS_TDATA_WIDTH {32} \
CONFIG.C_TX_BUF_ADDR_WIDTH {16} \
 ] $AXI4_Stream_Data_Source

  # Create instance: GM_AXI_BRAM_Controller_0, and set properties
  set GM_AXI_BRAM_Controller_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:GM_AXI_BRAM_Controller:1.0 GM_AXI_BRAM_Controller_0 ]
  set_property -dict [ list \
CONFIG.C_BUF_ADDR_WIDTH {16} \
 ] $GM_AXI_BRAM_Controller_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0 ]
  set_property -dict [ list \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Use_RSTB_Pin {false} \
CONFIG.Write_Depth_A {65536} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Source_M00_AXIS [get_bd_intf_pins M00_AXIS] [get_bd_intf_pins AXI4_Stream_Data_Source/M00_AXIS]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins AXI4_Stream_Data_Source/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins S00_AXI1] [get_bd_intf_pins GM_AXI_BRAM_Controller_0/S00_AXI]

  # Create port connections
  connect_bd_net -net AXI4_Stream_Data_Source_data_buf_in_data [get_bd_pins AXI4_Stream_Data_Source/data_buf_in_data] [get_bd_pins blk_mem_gen_0/dinb]
  connect_bd_net -net AXI4_Stream_Data_Source_data_buf_in_we [get_bd_pins AXI4_Stream_Data_Source/data_buf_in_we] [get_bd_pins blk_mem_gen_0/web]
  connect_bd_net -net AXI4_Stream_Data_Source_data_buf_out_addr [get_bd_pins AXI4_Stream_Data_Source/data_buf_out_addr] [get_bd_pins blk_mem_gen_0/addrb]
  connect_bd_net -net AXI4_Stream_Data_Source_data_buf_out_en [get_bd_pins AXI4_Stream_Data_Source/data_buf_out_en] [get_bd_pins blk_mem_gen_0/enb]
  connect_bd_net -net AXI4_Stream_Data_Source_irq [get_bd_pins irq] [get_bd_pins AXI4_Stream_Data_Source/irq]
  connect_bd_net -net GM_AXI_BRAM_Controller_0_bram_addr [get_bd_pins GM_AXI_BRAM_Controller_0/bram_addr] [get_bd_pins blk_mem_gen_0/addra]
  connect_bd_net -net GM_AXI_BRAM_Controller_0_bram_din [get_bd_pins GM_AXI_BRAM_Controller_0/bram_din] [get_bd_pins blk_mem_gen_0/dina]
  connect_bd_net -net GM_AXI_BRAM_Controller_0_bram_en [get_bd_pins GM_AXI_BRAM_Controller_0/bram_en] [get_bd_pins blk_mem_gen_0/ena]
  connect_bd_net -net GM_AXI_BRAM_Controller_0_bram_we [get_bd_pins GM_AXI_BRAM_Controller_0/bram_we] [get_bd_pins blk_mem_gen_0/wea]
  connect_bd_net -net blk_mem_gen_0_douta [get_bd_pins GM_AXI_BRAM_Controller_0/bram_dout] [get_bd_pins blk_mem_gen_0/douta]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins AXI4_Stream_Data_Source/data_buf_out_data] [get_bd_pins blk_mem_gen_0/doutb]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins s00_axi_aclk] [get_bd_pins AXI4_Stream_Data_Source/aclk] [get_bd_pins GM_AXI_BRAM_Controller_0/s00_axi_aclk] [get_bd_pins blk_mem_gen_0/clka] [get_bd_pins blk_mem_gen_0/clkb]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins s00_axi_aresetn] [get_bd_pins AXI4_Stream_Data_Source/aresetn] [get_bd_pins GM_AXI_BRAM_Controller_0/s00_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: TX_DATA_FFT
proc create_hier_cell_TX_DATA_FFT { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_TX_DATA_FFT() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: FFT_Controller_0, and set properties
  set FFT_Controller_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:FFT_Controller:2.0 FFT_Controller_0 ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_CONFIG_TDATA_WIDTH {24} \
 ] $FFT_Controller_0

  # Create instance: xfft_0, and set properties
  set xfft_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xfft:9.0 xfft_0 ]
  set_property -dict [ list \
CONFIG.aresetn {true} \
CONFIG.butterfly_type {use_xtremedsp_slices} \
CONFIG.complex_mult_type {use_mults_performance} \
CONFIG.cyclic_prefix_insertion {false} \
CONFIG.data_format {fixed_point} \
CONFIG.implementation_options {pipelined_streaming_io} \
CONFIG.input_width {16} \
CONFIG.number_of_stages_using_block_ram_for_data_and_phase_factors {4} \
CONFIG.output_ordering {natural_order} \
CONFIG.phase_factor_width {16} \
CONFIG.run_time_configurable_transform_length {true} \
CONFIG.target_clock_frequency {100} \
CONFIG.target_data_throughput {100} \
CONFIG.transform_length {2048} \
CONFIG.xk_index {true} \
 ] $xfft_0

  # Create interface connections
  connect_bd_intf_net -intf_net FFT_Controller_0_M00_AXIS [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins xfft_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net FFT_Controller_0_M01_AXIS [get_bd_intf_pins FFT_Controller_0/M_AXIS_CONFIG] [get_bd_intf_pins xfft_0/S_AXIS_CONFIG]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins FFT_Controller_0/S00_AXI]
  connect_bd_intf_net -intf_net xfft_0_M_AXIS_DATA [get_bd_intf_pins M_AXIS_DATA] [get_bd_intf_pins xfft_0/M_AXIS_DATA]

  # Create port connections
  connect_bd_net -net FFT_Controller_0_fftresetn [get_bd_pins FFT_Controller_0/fft_resetn] [get_bd_pins xfft_0/aresetn]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins FFT_Controller_0/aclk] [get_bd_pins xfft_0/aclk]
  connect_bd_net -net aresetn_1 [get_bd_pins aresetn] [get_bd_pins FFT_Controller_0/aresetn]
  connect_bd_net -net xfft_0_event_data_in_channel_halt [get_bd_pins FFT_Controller_0/event_data_in_channel_halt] [get_bd_pins xfft_0/event_data_in_channel_halt]
  connect_bd_net -net xfft_0_event_data_out_channel_halt [get_bd_pins FFT_Controller_0/event_data_out_channel_halt] [get_bd_pins xfft_0/event_data_out_channel_halt]
  connect_bd_net -net xfft_0_event_frame_started [get_bd_pins FFT_Controller_0/event_frame_started] [get_bd_pins xfft_0/event_frame_started]
  connect_bd_net -net xfft_0_event_status_channel_halt [get_bd_pins FFT_Controller_0/event_status_channel_halt] [get_bd_pins xfft_0/event_status_channel_halt]
  connect_bd_net -net xfft_0_event_tlast_missing [get_bd_pins FFT_Controller_0/event_tlast_missing] [get_bd_pins xfft_0/event_tlast_missing]
  connect_bd_net -net xfft_0_event_tlast_unexpected [get_bd_pins FFT_Controller_0/event_tlast_unexpected] [get_bd_pins xfft_0/event_tlast_unexpected]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: TRAINING_SYMB_INJECTOR
proc create_hier_cell_TRAINING_SYMB_INJECTOR { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_TRAINING_SYMB_INJECTOR() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn
  create_bd_pin -dir I clka
  create_bd_pin -dir O -type intr irq

  # Create instance: AXI4_Stream_Data_Slicer_0, and set properties
  set AXI4_Stream_Data_Slicer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 AXI4_Stream_Data_Slicer_0 ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_M_AXIS_TDATA_WIDTH {24} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
 ] $AXI4_Stream_Data_Slicer_0

  # Create instance: Rx_Buf_Sel, and set properties
  set Rx_Buf_Sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 Rx_Buf_Sel ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {11} \
CONFIG.IN1_WIDTH {1} \
 ] $Rx_Buf_Sel

  # Create instance: TS_Buf_Sel, and set properties
  set TS_Buf_Sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 TS_Buf_Sel ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {11} \
CONFIG.IN1_WIDTH {2} \
 ] $TS_Buf_Sel

  # Create instance: Training_Symbol_Injector_0, and set properties
  set Training_Symbol_Injector_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:Training_Symbol_Injector:1.1 Training_Symbol_Injector_0 ]
  set_property -dict [ list \
CONFIG.C_BUF_ADDR_WIDTH {11} \
CONFIG.C_S_AXIS_DATA_TDATA_WIDTH {32} \
 ] $Training_Symbol_Injector_0

  # Create instance: Tx_Buf_Sel, and set properties
  set Tx_Buf_Sel [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 Tx_Buf_Sel ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {11} \
CONFIG.IN1_WIDTH {1} \
 ] $Tx_Buf_Sel

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0 ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Read_Width_A {32} \
CONFIG.Read_Width_B {32} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {4096} \
CONFIG.Write_Width_A {32} \
CONFIG.Write_Width_B {32} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_0

  # Create instance: blk_mem_gen_1, and set properties
  set blk_mem_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_1 ]
  set_property -dict [ list \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_1

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins M_AXIS_DATA] [get_bd_intf_pins AXI4_Stream_Data_Slicer_0/M_AXIS_DATA]
  connect_bd_intf_net -intf_net Training_Symbol_Injector_0_M_AXIS_DATA [get_bd_intf_pins AXI4_Stream_Data_Slicer_0/S_AXIS_DATA] [get_bd_intf_pins Training_Symbol_Injector_0/M_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins Training_Symbol_Injector_0/S00_AXI]
  connect_bd_intf_net -intf_net xfft_0_M_AXIS_DATA [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins Training_Symbol_Injector_0/S_AXIS_DATA]

  # Create port connections
  connect_bd_net -net Rx_Buf_Sel_dout [get_bd_pins Rx_Buf_Sel/dout] [get_bd_pins blk_mem_gen_0/addra]
  connect_bd_net -net TS_Buf_Sel_dout [get_bd_pins TS_Buf_Sel/dout] [get_bd_pins blk_mem_gen_1/addra]
  connect_bd_net -net Training_Symbol_Injector_0_irq [get_bd_pins irq] [get_bd_pins Training_Symbol_Injector_0/irq]
  connect_bd_net -net Training_Symbol_Injector_0_rx_buf_addr [get_bd_pins Rx_Buf_Sel/In0] [get_bd_pins Training_Symbol_Injector_0/rx_buf_addr]
  connect_bd_net -net Training_Symbol_Injector_0_rx_buf_din [get_bd_pins Training_Symbol_Injector_0/rx_buf_din] [get_bd_pins blk_mem_gen_0/dina]
  connect_bd_net -net Training_Symbol_Injector_0_rx_buf_sel [get_bd_pins Rx_Buf_Sel/In1] [get_bd_pins Training_Symbol_Injector_0/rx_buf_sel]
  connect_bd_net -net Training_Symbol_Injector_0_rx_buf_we [get_bd_pins Training_Symbol_Injector_0/rx_buf_we] [get_bd_pins blk_mem_gen_0/wea]
  connect_bd_net -net Training_Symbol_Injector_0_ts_buf_addr [get_bd_pins TS_Buf_Sel/In0] [get_bd_pins Training_Symbol_Injector_0/ts_buf_addr]
  connect_bd_net -net Training_Symbol_Injector_0_ts_buf_din [get_bd_pins Training_Symbol_Injector_0/ts_buf_din] [get_bd_pins blk_mem_gen_1/dina]
  connect_bd_net -net Training_Symbol_Injector_0_ts_buf_en [get_bd_pins Training_Symbol_Injector_0/ts_buf_en] [get_bd_pins blk_mem_gen_1/ena]
  connect_bd_net -net Training_Symbol_Injector_0_ts_buf_sel [get_bd_pins TS_Buf_Sel/In1] [get_bd_pins Training_Symbol_Injector_0/ts_buf_sel]
  connect_bd_net -net Training_Symbol_Injector_0_ts_buf_we [get_bd_pins Training_Symbol_Injector_0/ts_buf_we] [get_bd_pins blk_mem_gen_1/wea]
  connect_bd_net -net Training_Symbol_Injector_0_tx_buf_addr [get_bd_pins Training_Symbol_Injector_0/tx_buf_addr] [get_bd_pins Tx_Buf_Sel/In0]
  connect_bd_net -net Training_Symbol_Injector_0_tx_buf_en [get_bd_pins Training_Symbol_Injector_0/tx_buf_en] [get_bd_pins blk_mem_gen_0/enb]
  connect_bd_net -net Training_Symbol_Injector_0_tx_buf_sel [get_bd_pins Training_Symbol_Injector_0/tx_buf_sel] [get_bd_pins Tx_Buf_Sel/In1]
  connect_bd_net -net Tx_Buf_Sel_dout [get_bd_pins Tx_Buf_Sel/dout] [get_bd_pins blk_mem_gen_0/addrb]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins Training_Symbol_Injector_0/tx_buf_dout] [get_bd_pins blk_mem_gen_0/doutb]
  connect_bd_net -net blk_mem_gen_1_douta [get_bd_pins Training_Symbol_Injector_0/ts_buf_dout] [get_bd_pins blk_mem_gen_1/douta]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins clka] [get_bd_pins AXI4_Stream_Data_Slicer_0/aclk] [get_bd_pins Training_Symbol_Injector_0/aclk] [get_bd_pins blk_mem_gen_0/clka] [get_bd_pins blk_mem_gen_0/clkb] [get_bd_pins blk_mem_gen_1/clka]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins AXI4_Stream_Data_Slicer_0/aresetn] [get_bd_pins Training_Symbol_Injector_0/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: TIME_DOMAIN_DATA_SINK
proc create_hier_cell_TIME_DOMAIN_DATA_SINK { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_TIME_DOMAIN_DATA_SINK() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: AXI4_Stream_Data_Slicer_0, and set properties
  set AXI4_Stream_Data_Slicer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 AXI4_Stream_Data_Slicer_0 ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $AXI4_Stream_Data_Slicer_0

  # Create instance: RX_RAW_DATA_SINK, and set properties
  set RX_RAW_DATA_SINK [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 RX_RAW_DATA_SINK ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {16} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {16} \
 ] $RX_RAW_DATA_SINK

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0 ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {65536} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins AXI4_Stream_Data_Slicer_0/M_AXIS_DATA] [get_bd_intf_pins RX_RAW_DATA_SINK/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins AXI4_Stream_Data_Slicer_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M17_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins RX_RAW_DATA_SINK/S00_AXI]

  # Create port connections
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_in_addr [get_bd_pins RX_RAW_DATA_SINK/data_buf_in_addr] [get_bd_pins blk_mem_gen_0/addra]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_in_data [get_bd_pins RX_RAW_DATA_SINK/data_buf_in_data] [get_bd_pins blk_mem_gen_0/dina]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_in_we [get_bd_pins RX_RAW_DATA_SINK/data_buf_in_we] [get_bd_pins blk_mem_gen_0/wea]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_out_addr [get_bd_pins RX_RAW_DATA_SINK/data_buf_out_addr] [get_bd_pins blk_mem_gen_0/addrb]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_out_en [get_bd_pins RX_RAW_DATA_SINK/data_buf_out_en] [get_bd_pins blk_mem_gen_0/enb]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins RX_RAW_DATA_SINK/data_buf_out_data] [get_bd_pins blk_mem_gen_0/doutb]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins AXI4_Stream_Data_Slicer_0/aclk] [get_bd_pins RX_RAW_DATA_SINK/aclk] [get_bd_pins blk_mem_gen_0/clka] [get_bd_pins blk_mem_gen_0/clkb]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins AXI4_Stream_Data_Slicer_0/aresetn] [get_bd_pins RX_RAW_DATA_SINK/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: RF_INTERFACE
proc create_hier_cell_RF_INTERFACE { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_RF_INTERFACE() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RXD
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_TXD
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_AD9364
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_ADC_FRQ_CTR
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CLK_FRQ_CTR
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_DAC_FRQ_CTR

  # Create pins
  create_bd_pin -dir O -from 63 -to 0 GPIO_I
  create_bd_pin -dir I -from 63 -to 0 GPIO_O
  create_bd_pin -dir IO -from 39 -to 32 GPIO_P00
  create_bd_pin -dir IO -from 43 -to 40 GPIO_P01
  create_bd_pin -dir IO -from 44 -to 44 GPIO_P02
  create_bd_pin -dir IO -from 45 -to 45 GPIO_P03
  create_bd_pin -dir IO -from 46 -to 46 GPIO_P04
  create_bd_pin -dir I -from 63 -to 0 GPIO_T
  create_bd_pin -dir I delay_clk
  create_bd_pin -dir O enable
  create_bd_pin -dir I rx_clk_in_n
  create_bd_pin -dir I rx_clk_in_p
  create_bd_pin -dir I -from 5 -to 0 rx_data_in_n
  create_bd_pin -dir I -from 5 -to 0 rx_data_in_p
  create_bd_pin -dir I rx_frame_in_n
  create_bd_pin -dir I rx_frame_in_p
  create_bd_pin -dir I -from 0 -to 0 -type rst s00_axi_aresetn
  create_bd_pin -dir I -type clk s_axis_aclk
  create_bd_pin -dir O tx_clk_out_n
  create_bd_pin -dir O tx_clk_out_p
  create_bd_pin -dir O -from 5 -to 0 tx_data_out_n
  create_bd_pin -dir O -from 5 -to 0 tx_data_out_p
  create_bd_pin -dir O tx_frame_out_n
  create_bd_pin -dir O tx_frame_out_p
  create_bd_pin -dir O txnrx

  # Create instance: AD9361_Reset_sync, and set properties
  set AD9361_Reset_sync [ create_bd_cell -type ip -vlnv xilinx.com:user:Reset_Sync:1.0 AD9361_Reset_sync ]
  set_property -dict [ list \
CONFIG.C_EN_RSTN_I {false} \
CONFIG.C_EN_RSTP_O {false} \
 ] $AD9361_Reset_sync

  # Create instance: AXI4_STREAM_FROM_AD9361_0, and set properties
  set AXI4_STREAM_FROM_AD9361_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_STREAM_FROM_AD9361:1.0 AXI4_STREAM_FROM_AD9361_0 ]

  # Create instance: AXI4_Stream_to_AD9361_0, and set properties
  set AXI4_Stream_to_AD9361_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_to_AD9361:1.0 AXI4_Stream_to_AD9361_0 ]
  set_property -dict [ list \
CONFIG.C_N_CHANS {1} \
CONFIG.C_S_AXIS_DAC_DATA_TDATA_WIDTH {24} \
 ] $AXI4_Stream_to_AD9361_0

  # Create instance: Logic_1, and set properties
  set Logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Logic_1 ]

  # Create instance: Rx_FIFO, and set properties
  set Rx_FIFO [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 Rx_FIFO ]
  set_property -dict [ list \
CONFIG.HAS_TLAST {0} \
CONFIG.HAS_TSTRB {0} \
CONFIG.IS_ACLK_ASYNC {1} \
CONFIG.SYNCHRONIZATION_STAGES {3} \
CONFIG.TDATA_NUM_BYTES {3} \
 ] $Rx_FIFO

  # Create instance: Tx_FIFO, and set properties
  set Tx_FIFO [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 Tx_FIFO ]
  set_property -dict [ list \
CONFIG.HAS_TLAST {0} \
CONFIG.HAS_TSTRB {0} \
CONFIG.IS_ACLK_ASYNC {1} \
CONFIG.SYNCHRONIZATION_STAGES {3} \
CONFIG.TDATA_NUM_BYTES {3} \
 ] $Tx_FIFO

  # Create instance: X_IOBUF_0, and set properties
  set X_IOBUF_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:X_IOBUF:1.0 X_IOBUF_0 ]
  set_property -dict [ list \
CONFIG.CFG_01 {"001"} \
CONFIG.CFG_03 {"001"} \
CONFIG.GPIO_WIDTH {64} \
CONFIG.IN00_LEFT {39} \
CONFIG.IN00_RIGHT {32} \
CONFIG.IN01_LEFT {43} \
CONFIG.IN01_RIGHT {40} \
CONFIG.IN02_LEFT {44} \
CONFIG.IN02_RIGHT {44} \
CONFIG.IN03_LEFT {45} \
CONFIG.IN03_RIGHT {45} \
CONFIG.IN04_LEFT {46} \
CONFIG.IN04_RIGHT {46} \
CONFIG.N_PORTS {5} \
 ] $X_IOBUF_0

  # Create instance: ad9364_adc_frq_ctr, and set properties
  set ad9364_adc_frq_ctr [ create_bd_cell -type ip -vlnv xilinx.com:user:Freq_Ctr:1.0 ad9364_adc_frq_ctr ]

  # Create instance: ad9364_clk_frq_ctr, and set properties
  set ad9364_clk_frq_ctr [ create_bd_cell -type ip -vlnv xilinx.com:user:Freq_Ctr:1.0 ad9364_clk_frq_ctr ]

  # Create instance: ad9364_dac_frq_ctr, and set properties
  set ad9364_dac_frq_ctr [ create_bd_cell -type ip -vlnv xilinx.com:user:Freq_Ctr:1.0 ad9364_dac_frq_ctr ]

  # Create instance: axi_ad9361_0, and set properties
  set axi_ad9361_0 [ create_bd_cell -type ip -vlnv analog.com:user:axi_ad9361:1.0 axi_ad9361_0 ]
  set_property -dict [ list \
CONFIG.MODE_1R1T {1} \
 ] $axi_ad9361_0

  # Create instance: bitsel_0, and set properties
  set bitsel_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:bitsel:1.0 bitsel_0 ]
  set_property -dict [ list \
CONFIG.C_BIT_EN_0 {false} \
CONFIG.C_BIT_EN_47 {true} \
CONFIG.C_BIT_EN_48 {true} \
CONFIG.C_BUS_0_LEFT {0} \
CONFIG.C_BUS_0_SEL {false} \
CONFIG.C_BUS_1_LEFT {0} \
CONFIG.C_BUS_1_RIGHT {0} \
CONFIG.C_BUS_1_SEL {false} \
CONFIG.C_BUS_2_LEFT {0} \
CONFIG.C_BUS_2_RIGHT {0} \
CONFIG.C_BUS_2_SEL {false} \
CONFIG.C_BUS_3_LEFT {0} \
CONFIG.C_BUS_3_RIGHT {0} \
CONFIG.C_BUS_3_SEL {false} \
CONFIG.C_INPUT_SIZE {64} \
 ] $bitsel_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_STREAM_FROM_AD9361_0_M_AXIS_ADC_DATA [get_bd_intf_pins AXI4_STREAM_FROM_AD9361_0/M_AXIS_ADC_DATA] [get_bd_intf_pins Rx_FIFO/S_AXIS]
  connect_bd_intf_net -intf_net RF_CHANNEL_EMULATOR_M_AXIS_DEVICE_IN [get_bd_intf_pins S_AXIS_TXD] [get_bd_intf_pins Tx_FIFO/S_AXIS]
  connect_bd_intf_net -intf_net Rx_FIFO_M_AXIS [get_bd_intf_pins M_AXIS_RXD] [get_bd_intf_pins Rx_FIFO/M_AXIS]
  connect_bd_intf_net -intf_net Tx_FIFO_M_AXIS [get_bd_intf_pins AXI4_Stream_to_AD9361_0/S_AXIS_DAC_DATA] [get_bd_intf_pins Tx_FIFO/M_AXIS]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins S_AXI_CLK_FRQ_CTR] [get_bd_intf_pins ad9364_clk_frq_ctr/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins S_AXI_DAC_FRQ_CTR] [get_bd_intf_pins ad9364_dac_frq_ctr/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI_AD9364] [get_bd_intf_pins axi_ad9361_0/s_axi]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M18_AXI [get_bd_intf_pins S_AXI_ADC_FRQ_CTR] [get_bd_intf_pins ad9364_adc_frq_ctr/S00_AXI]

  # Create port connections
  connect_bd_net -net AXI4_STREAM_FROM_AD9361_0_adc_valid_out [get_bd_pins AXI4_STREAM_FROM_AD9361_0/adc_valid_out] [get_bd_pins ad9364_adc_frq_ctr/ext_clk_in]
  connect_bd_net -net AXI4_Stream_to_AD9361_0_dac_data_i0 [get_bd_pins AXI4_Stream_to_AD9361_0/dac_data_i0] [get_bd_pins axi_ad9361_0/dac_data_i0]
  connect_bd_net -net AXI4_Stream_to_AD9361_0_dac_data_i1 [get_bd_pins AXI4_Stream_to_AD9361_0/dac_data_i1] [get_bd_pins axi_ad9361_0/dac_data_i1]
  connect_bd_net -net AXI4_Stream_to_AD9361_0_dac_data_q0 [get_bd_pins AXI4_Stream_to_AD9361_0/dac_data_q0] [get_bd_pins axi_ad9361_0/dac_data_q0]
  connect_bd_net -net AXI4_Stream_to_AD9361_0_dac_data_q1 [get_bd_pins AXI4_Stream_to_AD9361_0/dac_data_q1] [get_bd_pins axi_ad9361_0/dac_data_q1]
  connect_bd_net -net AXI4_Stream_to_AD9361_0_dac_valid_out [get_bd_pins AXI4_Stream_to_AD9361_0/dac_valid_out] [get_bd_pins ad9364_dac_frq_ctr/ext_clk_in]
  connect_bd_net -net Net [get_bd_pins GPIO_P00] [get_bd_pins X_IOBUF_0/GPIO_P00]
  connect_bd_net -net Net1 [get_bd_pins GPIO_P01] [get_bd_pins X_IOBUF_0/GPIO_P01]
  connect_bd_net -net Net2 [get_bd_pins GPIO_P02] [get_bd_pins X_IOBUF_0/GPIO_P02]
  connect_bd_net -net Net3 [get_bd_pins GPIO_P03] [get_bd_pins X_IOBUF_0/GPIO_P03]
  connect_bd_net -net Net4 [get_bd_pins GPIO_P04] [get_bd_pins X_IOBUF_0/GPIO_P04]
  connect_bd_net -net X_IOBUF_0_GPIO_I [get_bd_pins GPIO_I] [get_bd_pins X_IOBUF_0/GPIO_I]
  connect_bd_net -net axi_ad9361_0_adc_data_i0 [get_bd_pins AXI4_STREAM_FROM_AD9361_0/adc_data_i0] [get_bd_pins axi_ad9361_0/adc_data_i0]
  connect_bd_net -net axi_ad9361_0_adc_data_i1 [get_bd_pins AXI4_STREAM_FROM_AD9361_0/adc_data_i1] [get_bd_pins axi_ad9361_0/adc_data_i1]
  connect_bd_net -net axi_ad9361_0_adc_data_q0 [get_bd_pins AXI4_STREAM_FROM_AD9361_0/adc_data_q0] [get_bd_pins axi_ad9361_0/adc_data_q0]
  connect_bd_net -net axi_ad9361_0_adc_data_q1 [get_bd_pins AXI4_STREAM_FROM_AD9361_0/adc_data_q1] [get_bd_pins axi_ad9361_0/adc_data_q1]
  connect_bd_net -net axi_ad9361_0_adc_valid_i0 [get_bd_pins AXI4_STREAM_FROM_AD9361_0/adc_valid_i0] [get_bd_pins axi_ad9361_0/adc_valid_i0]
  connect_bd_net -net axi_ad9361_0_adc_valid_i1 [get_bd_pins AXI4_STREAM_FROM_AD9361_0/adc_valid_i1] [get_bd_pins axi_ad9361_0/adc_valid_i1]
  connect_bd_net -net axi_ad9361_0_adc_valid_q0 [get_bd_pins AXI4_STREAM_FROM_AD9361_0/adc_valid_q0] [get_bd_pins axi_ad9361_0/adc_valid_q0]
  connect_bd_net -net axi_ad9361_0_adc_valid_q1 [get_bd_pins AXI4_STREAM_FROM_AD9361_0/adc_valid_q1] [get_bd_pins axi_ad9361_0/adc_valid_q1]
  connect_bd_net -net axi_ad9361_0_dac_valid_i0 [get_bd_pins AXI4_Stream_to_AD9361_0/dac_valid_i0] [get_bd_pins axi_ad9361_0/dac_valid_i0]
  connect_bd_net -net axi_ad9361_0_dac_valid_i1 [get_bd_pins AXI4_Stream_to_AD9361_0/dac_valid_i1] [get_bd_pins axi_ad9361_0/dac_valid_i1]
  connect_bd_net -net axi_ad9361_0_dac_valid_q0 [get_bd_pins AXI4_Stream_to_AD9361_0/dac_valid_q0] [get_bd_pins axi_ad9361_0/dac_valid_q0]
  connect_bd_net -net axi_ad9361_0_dac_valid_q1 [get_bd_pins AXI4_Stream_to_AD9361_0/dac_valid_q1] [get_bd_pins axi_ad9361_0/dac_valid_q1]
  connect_bd_net -net axi_ad9361_0_enable [get_bd_pins enable] [get_bd_pins axi_ad9361_0/enable]
  connect_bd_net -net axi_ad9361_0_l_clk [get_bd_pins AD9361_Reset_sync/aclk] [get_bd_pins Rx_FIFO/s_axis_aclk] [get_bd_pins Tx_FIFO/m_axis_aclk] [get_bd_pins ad9364_clk_frq_ctr/ext_clk_in] [get_bd_pins axi_ad9361_0/clk] [get_bd_pins axi_ad9361_0/l_clk]
  connect_bd_net -net axi_ad9361_0_rst [get_bd_pins AD9361_Reset_sync/resetp_in] [get_bd_pins axi_ad9361_0/rst]
  connect_bd_net -net axi_ad9361_0_tx_clk_out_n [get_bd_pins tx_clk_out_n] [get_bd_pins axi_ad9361_0/tx_clk_out_n]
  connect_bd_net -net axi_ad9361_0_tx_clk_out_p [get_bd_pins tx_clk_out_p] [get_bd_pins axi_ad9361_0/tx_clk_out_p]
  connect_bd_net -net axi_ad9361_0_tx_data_out_n [get_bd_pins tx_data_out_n] [get_bd_pins axi_ad9361_0/tx_data_out_n]
  connect_bd_net -net axi_ad9361_0_tx_data_out_p [get_bd_pins tx_data_out_p] [get_bd_pins axi_ad9361_0/tx_data_out_p]
  connect_bd_net -net axi_ad9361_0_tx_frame_out_n [get_bd_pins tx_frame_out_n] [get_bd_pins axi_ad9361_0/tx_frame_out_n]
  connect_bd_net -net axi_ad9361_0_tx_frame_out_p [get_bd_pins tx_frame_out_p] [get_bd_pins axi_ad9361_0/tx_frame_out_p]
  connect_bd_net -net axi_ad9361_0_txnrx [get_bd_pins txnrx] [get_bd_pins axi_ad9361_0/txnrx]
  connect_bd_net -net axi_ad9364_cmos_0_rstn [get_bd_pins AD9361_Reset_sync/resetn_out] [get_bd_pins Rx_FIFO/s_axis_aresetn] [get_bd_pins Tx_FIFO/m_axis_aresetn]
  connect_bd_net -net bitsel_0_d47 [get_bd_pins axi_ad9361_0/up_enable] [get_bd_pins bitsel_0/d47]
  connect_bd_net -net bitsel_0_d48 [get_bd_pins axi_ad9361_0/up_txnrx] [get_bd_pins bitsel_0/d48]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins s_axis_aclk] [get_bd_pins Rx_FIFO/m_axis_aclk] [get_bd_pins Tx_FIFO/s_axis_aclk] [get_bd_pins ad9364_adc_frq_ctr/s00_axi_aclk] [get_bd_pins ad9364_clk_frq_ctr/s00_axi_aclk] [get_bd_pins ad9364_dac_frq_ctr/s00_axi_aclk] [get_bd_pins axi_ad9361_0/s_axi_aclk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins delay_clk] [get_bd_pins axi_ad9361_0/delay_clk]
  connect_bd_net -net processing_system7_0_GPIO_O [get_bd_pins GPIO_O] [get_bd_pins X_IOBUF_0/GPIO_O] [get_bd_pins bitsel_0/d]
  connect_bd_net -net processing_system7_0_GPIO_T [get_bd_pins GPIO_T] [get_bd_pins X_IOBUF_0/GPIO_T]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins s00_axi_aresetn] [get_bd_pins Rx_FIFO/m_axis_aresetn] [get_bd_pins Tx_FIFO/s_axis_aresetn] [get_bd_pins ad9364_adc_frq_ctr/s00_axi_aresetn] [get_bd_pins ad9364_clk_frq_ctr/s00_axi_aresetn] [get_bd_pins ad9364_dac_frq_ctr/s00_axi_aresetn] [get_bd_pins axi_ad9361_0/s_axi_aresetn]
  connect_bd_net -net rx_clk_in_n_1 [get_bd_pins rx_clk_in_n] [get_bd_pins axi_ad9361_0/rx_clk_in_n]
  connect_bd_net -net rx_clk_in_p_1 [get_bd_pins rx_clk_in_p] [get_bd_pins axi_ad9361_0/rx_clk_in_p]
  connect_bd_net -net rx_data_in_n_1 [get_bd_pins rx_data_in_n] [get_bd_pins axi_ad9361_0/rx_data_in_n]
  connect_bd_net -net rx_data_in_p_1 [get_bd_pins rx_data_in_p] [get_bd_pins axi_ad9361_0/rx_data_in_p]
  connect_bd_net -net rx_frame_in_n_1 [get_bd_pins rx_frame_in_n] [get_bd_pins axi_ad9361_0/rx_frame_in_n]
  connect_bd_net -net rx_frame_in_p_1 [get_bd_pins rx_frame_in_p] [get_bd_pins axi_ad9361_0/rx_frame_in_p]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins Logic_1/dout] [get_bd_pins ad9364_adc_frq_ctr/ext_clk_lock] [get_bd_pins ad9364_clk_frq_ctr/ext_clk_lock] [get_bd_pins ad9364_dac_frq_ctr/ext_clk_lock]

  # Perform GUI Layout
  regenerate_bd_layout -hierarchy [get_bd_cells /RF_INTERFACE] -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port enable -pg 1 -y 360 -defaultsOSRD
preplace port rx_clk_in_p -pg 1 -y 370 -defaultsOSRD
preplace port tx_frame_out_n -pg 1 -y 300 -defaultsOSRD
preplace port rx_frame_in_n -pg 1 -y 430 -defaultsOSRD
preplace port tx_clk_out_n -pg 1 -y 260 -defaultsOSRD
preplace port M_AXIS_RXD -pg 1 -y 590 -defaultsOSRD
preplace port tx_frame_out_p -pg 1 -y 280 -defaultsOSRD
preplace port rx_frame_in_p -pg 1 -y 410 -defaultsOSRD
preplace port S_AXIS_TXD -pg 1 -y 600 -defaultsOSRD
preplace port tx_clk_out_p -pg 1 -y 240 -defaultsOSRD
preplace port s_axis_aclk -pg 1 -y 640 -defaultsOSRD
preplace port S_AXI_AD9364 -pg 1 -y 350 -defaultsOSRD
preplace port S_AXI_DAC_FRQ_CTR -pg 1 -y 1310 -defaultsOSRD
preplace port delay_clk -pg 1 -y 510 -defaultsOSRD
preplace port rx_clk_in_n -pg 1 -y 390 -defaultsOSRD
preplace port S_AXI_ADC_FRQ_CTR -pg 1 -y 990 -defaultsOSRD
preplace port txnrx -pg 1 -y 380 -defaultsOSRD
preplace port S_AXI_CLK_FRQ_CTR -pg 1 -y 1150 -defaultsOSRD
preplace portBus s00_axi_aresetn -pg 1 -y 620 -defaultsOSRD
preplace portBus rx_data_in_p -pg 1 -y 450 -defaultsOSRD
preplace portBus GPIO_T -pg 1 -y 90 -defaultsOSRD
preplace portBus GPIO_I -pg 1 -y 170 -defaultsOSRD
preplace portBus tx_data_out_n -pg 1 -y 340 -defaultsOSRD
preplace portBus GPIO_P00 -pg 1 -y 40 -defaultsOSRD
preplace portBus GPIO_P01 -pg 1 -y 60 -defaultsOSRD
preplace portBus tx_data_out_p -pg 1 -y 320 -defaultsOSRD
preplace portBus GPIO_P02 -pg 1 -y 80 -defaultsOSRD
preplace portBus GPIO_O -pg 1 -y 490 -defaultsOSRD
preplace portBus GPIO_P03 -pg 1 -y 100 -defaultsOSRD
preplace portBus GPIO_P04 -pg 1 -y 120 -defaultsOSRD
preplace portBus rx_data_in_n -pg 1 -y 470 -defaultsOSRD
preplace inst axi_ad9361_0 -pg 1 -lvl 4 -y 590 -defaultsOSRD
preplace inst ad9364_adc_frq_ctr -pg 1 -lvl 6 -y 1030 -defaultsOSRD
preplace inst Rx_FIFO -pg 1 -lvl 6 -y 620 -defaultsOSRD
preplace inst bitsel_0 -pg 1 -lvl 3 -y 780 -defaultsOSRD
preplace inst AXI4_Stream_to_AD9361_0 -pg 1 -lvl 3 -y 650 -defaultsOSRD
preplace inst AD9361_Reset_sync -pg 1 -lvl 1 -y 540 -defaultsOSRD
preplace inst Logic_1 -pg 1 -lvl 5 -y 1360 -defaultsOSRD
preplace inst ad9364_dac_frq_ctr -pg 1 -lvl 6 -y 1350 -defaultsOSRD
preplace inst X_IOBUF_0 -pg 1 -lvl 7 -y 80 -defaultsOSRD
preplace inst ad9364_clk_frq_ctr -pg 1 -lvl 6 -y 1190 -defaultsOSRD
preplace inst AXI4_STREAM_FROM_AD9361_0 -pg 1 -lvl 5 -y 590 -defaultsOSRD
preplace inst Tx_FIFO -pg 1 -lvl 2 -y 640 -defaultsOSRD
preplace netloc Net4 1 7 1 NJ
preplace netloc axi_ad9361_0_adc_data_q1 1 4 1 1380
preplace netloc axi_ad9361_0_l_clk 1 0 6 20 420 210 490 NJ 490 960 190 1370 440 1700
preplace netloc axi_ad9361_0_tx_data_out_p 1 4 4 NJ 320 NJ 320 NJ 320 NJ
preplace netloc axi_ad9361_0_tx_clk_out_n 1 4 4 NJ 260 NJ 260 NJ 260 NJ
preplace netloc rx_clk_in_n_1 1 0 4 NJ 390 NJ 390 NJ 390 NJ
preplace netloc xlconstant_2_dout 1 5 1 1710
preplace netloc axi_ad9361_0_adc_valid_i0 1 4 1 1370
preplace netloc X_IOBUF_0_GPIO_I 1 6 2 2060 170 NJ
preplace netloc processing_system7_0_GPIO_O 1 0 7 NJ 460 NJ 460 560 70 NJ 70 NJ 70 NJ 70 NJ
preplace netloc AXI4_Stream_to_AD9361_0_dac_valid_out 1 3 3 NJ 130 NJ 130 1720
preplace netloc axi_ad9361_0_dac_valid_q0 1 2 3 610 140 NJ 140 1310
preplace netloc axi_ad9361_0_adc_valid_i1 1 4 1 1350
preplace netloc axi_ad9361_0_adc_data_i0 1 4 1 1360
preplace netloc processing_system7_0_axi_periph_M18_AXI 1 0 6 NJ 990 NJ 990 NJ 990 NJ 990 NJ 990 NJ
preplace netloc axi_ad9361_0_tx_clk_out_p 1 4 4 NJ 240 NJ 240 NJ 240 NJ
preplace netloc axi_ad9361_0_dac_valid_q1 1 2 3 600 150 NJ 150 1320
preplace netloc AXI4_Stream_to_AD9361_0_dac_data_q0 1 3 1 N
preplace netloc axi_ad9361_0_adc_data_i1 1 4 1 1360
preplace netloc processing_system7_0_axi_periph_M05_AXI 1 0 6 NJ 1310 NJ 1310 NJ 1310 NJ 1310 NJ 1310 NJ
preplace netloc AXI4_STREAM_FROM_AD9361_0_M_AXIS_ADC_DATA 1 5 1 N
preplace netloc axi_ad9361_0_enable 1 4 4 NJ 360 NJ 360 NJ 360 NJ
preplace netloc AXI4_Stream_to_AD9361_0_dac_data_q1 1 3 1 N
preplace netloc Tx_FIFO_M_AXIS 1 2 1 N
preplace netloc rst_processing_system7_0_50M_peripheral_aresetn 1 0 6 NJ 620 220 550 NJ 550 940 180 NJ 180 1680
preplace netloc rx_clk_in_p_1 1 0 4 NJ 370 NJ 370 NJ 370 NJ
preplace netloc AXI4_STREAM_FROM_AD9361_0_adc_valid_out 1 5 1 1690
preplace netloc rx_data_in_p_1 1 0 4 NJ 480 NJ 480 NJ 460 NJ
preplace netloc AXI4_Stream_to_AD9361_0_dac_data_i0 1 3 1 N
preplace netloc processing_system7_0_axi_periph_M06_AXI 1 0 4 NJ 350 NJ 350 NJ 350 NJ
preplace netloc processing_system7_0_GPIO_T 1 0 7 NJ 90 NJ 90 NJ 120 NJ 120 NJ 90 NJ 90 NJ
preplace netloc axi_ad9364_cmos_0_rstn 1 1 5 230 160 NJ 160 NJ 160 NJ 160 1740
preplace netloc AXI4_Stream_to_AD9361_0_dac_data_i1 1 3 1 N
preplace netloc axi_ad9361_0_adc_valid_q0 1 4 1 N
preplace netloc Rx_FIFO_M_AXIS 1 6 2 NJ 590 NJ
preplace netloc axi_ad9361_0_adc_valid_q1 1 4 1 1370
preplace netloc rx_data_in_n_1 1 0 4 NJ 470 NJ 470 NJ 470 NJ
preplace netloc rx_frame_in_n_1 1 0 4 NJ 430 NJ 430 NJ 430 NJ
preplace netloc axi_ad9361_0_dac_valid_i0 1 2 3 590 90 NJ 90 1330
preplace netloc Net1 1 7 1 NJ
preplace netloc Net 1 7 1 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 0 6 NJ 640 240 540 NJ 540 930 50 NJ 50 1730
preplace netloc axi_ad9361_0_tx_frame_out_n 1 4 4 NJ 300 NJ 300 NJ 300 NJ
preplace netloc bitsel_0_d47 1 3 1 N
preplace netloc axi_ad9361_0_dac_valid_i1 1 2 3 580 100 NJ 100 1340
preplace netloc axi_ad9361_0_rst 1 0 5 10 110 NJ 110 NJ 110 NJ 110 1300
preplace netloc Net2 1 7 1 NJ
preplace netloc processing_system7_0_FCLK_CLK1 1 0 4 NJ 450 NJ 450 NJ 450 NJ
preplace netloc axi_ad9361_0_txnrx 1 4 4 NJ 380 NJ 380 NJ 380 NJ
preplace netloc rx_frame_in_p_1 1 0 4 NJ 400 NJ 400 NJ 400 NJ
preplace netloc bitsel_0_d48 1 3 1 N
preplace netloc processing_system7_0_axi_periph_M04_AXI 1 0 6 NJ 1150 NJ 1150 NJ 1150 NJ 1150 NJ 1150 NJ
preplace netloc RF_CHANNEL_EMULATOR_M_AXIS_DEVICE_IN 1 0 2 NJ 600 NJ
preplace netloc Net3 1 7 1 NJ
preplace netloc axi_ad9361_0_tx_data_out_n 1 4 4 NJ 340 NJ 340 NJ 340 NJ
preplace netloc axi_ad9361_0_tx_frame_out_p 1 4 4 NJ 280 NJ 280 NJ 280 NJ
preplace netloc axi_ad9361_0_adc_data_q0 1 4 1 N
levelinfo -pg 1 -40 120 400 760 1140 1530 1910 2190 2340 -top 0 -bot 1440
",
}

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: RF_CHANNEL_EMULATOR
proc create_hier_cell_RF_CHANNEL_EMULATOR { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_RF_CHANNEL_EMULATOR() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS_TIME_DOMAIN
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_TIME_DOMAIN
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_RF_TX
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_RF_RX
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_TXD
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CLK_GEN
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_EMUL
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_FREQ_MON
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SWITCH

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: EMUL_Rx_FIFO, and set properties
  set EMUL_Rx_FIFO [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 EMUL_Rx_FIFO ]
  set_property -dict [ list \
CONFIG.IS_ACLK_ASYNC {1} \
CONFIG.SYNCHRONIZATION_STAGES {3} \
CONFIG.TDATA_NUM_BYTES {3} \
 ] $EMUL_Rx_FIFO

  # Create instance: EMUL_Tx_FIFO, and set properties
  set EMUL_Tx_FIFO [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 EMUL_Tx_FIFO ]
  set_property -dict [ list \
CONFIG.IS_ACLK_ASYNC {1} \
CONFIG.SYNCHRONIZATION_STAGES {3} \
CONFIG.TDATA_NUM_BYTES {3} \
 ] $EMUL_Tx_FIFO

  # Create instance: EmulLUT, and set properties
  set EmulLUT [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 EmulLUT ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Read_Width_A {12} \
CONFIG.Read_Width_B {12} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {4096} \
CONFIG.Write_Width_A {12} \
CONFIG.Write_Width_B {12} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $EmulLUT

  # Create instance: Emul_Clk_Freq_Ctr, and set properties
  set Emul_Clk_Freq_Ctr [ create_bd_cell -type ip -vlnv xilinx.com:user:Freq_Ctr:1.0 Emul_Clk_Freq_Ctr ]

  # Create instance: Emul_Clk_Gen, and set properties
  set Emul_Clk_Gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 Emul_Clk_Gen ]
  set_property -dict [ list \
CONFIG.CLKOUT1_DRIVES {BUFGCE} \
CONFIG.CLKOUT1_JITTER {270.598} \
CONFIG.CLKOUT1_PHASE_ERROR {301.601} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {61.44} \
CONFIG.CLKOUT2_DRIVES {BUFGCE} \
CONFIG.CLKOUT3_DRIVES {BUFGCE} \
CONFIG.CLKOUT4_DRIVES {BUFGCE} \
CONFIG.CLKOUT5_DRIVES {BUFGCE} \
CONFIG.CLKOUT6_DRIVES {BUFGCE} \
CONFIG.CLKOUT7_DRIVES {BUFGCE} \
CONFIG.CLK_IN1_BOARD_INTERFACE {Custom} \
CONFIG.CLK_IN2_BOARD_INTERFACE {Custom} \
CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
CONFIG.INTERFACE_SELECTION {Enable_AXI} \
CONFIG.MMCM_CLKFBOUT_MULT_F {48.000} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {15.625} \
CONFIG.MMCM_DIVCLK_DIVIDE {5} \
CONFIG.PHASE_DUTY_CONFIG {false} \
CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
CONFIG.RESET_BOARD_INTERFACE {Custom} \
CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
CONFIG.USE_BOARD_FLOW {true} \
CONFIG.USE_DYN_RECONFIG {true} \
CONFIG.USE_PHASE_ALIGNMENT {false} \
CONFIG.USE_SAFE_CLOCK_STARTUP {true} \
 ] $Emul_Clk_Gen

  # Create instance: RF_CHAN_EMULATOR, and set properties
  set RF_CHAN_EMULATOR [ create_bd_cell -type ip -vlnv xilinx.com:user:DEMODULATOR:1.0 RF_CHAN_EMULATOR ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_TDATA_WIDTH {24} \
CONFIG.C_NEG_ADDR_B {false} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $RF_CHAN_EMULATOR

  # Create instance: RX_RAW_DATA_BCAST, and set properties
  set RX_RAW_DATA_BCAST [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 RX_RAW_DATA_BCAST ]
  set_property -dict [ list \
CONFIG.M00_TDATA_REMAP {tdata[23:0]} \
CONFIG.M01_TDATA_REMAP {tdata[23:0]} \
CONFIG.M_TDATA_NUM_BYTES {3} \
CONFIG.S_TDATA_NUM_BYTES {3} \
 ] $RX_RAW_DATA_BCAST

  # Create instance: Tx_Rx_Emulator_Switch, and set properties
  set Tx_Rx_Emulator_Switch [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Device_Bypass:1.0 Tx_Rx_Emulator_Switch ]
  set_property -dict [ list \
CONFIG.C_AXIS_TDATA_WIDTH {24} \
 ] $Tx_Rx_Emulator_Switch

  # Create instance: axis_clock_converter_0, and set properties
  set axis_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_0 ]
  set_property -dict [ list \
CONFIG.SYNCHRONIZATION_STAGES {3} \
CONFIG.TDATA_NUM_BYTES {3} \
 ] $axis_clock_converter_0

  # Create instance: axis_clock_converter_1, and set properties
  set axis_clock_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_clock_converter:1.1 axis_clock_converter_1 ]
  set_property -dict [ list \
CONFIG.TDATA_NUM_BYTES {3} \
 ] $axis_clock_converter_1

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_SWITCH] [get_bd_intf_pins Tx_Rx_Emulator_Switch/S00_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXIS_RF_TX] [get_bd_intf_pins Tx_Rx_Emulator_Switch/M_AXIS_DEVICE_IN]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXIS_RF_RX] [get_bd_intf_pins Tx_Rx_Emulator_Switch/S_AXIS_DEVICE_OUT]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXIS_TXD] [get_bd_intf_pins Tx_Rx_Emulator_Switch/S_AXIS_IN]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M00_AXIS_TIME_DOMAIN] [get_bd_intf_pins RX_RAW_DATA_BCAST/M00_AXIS]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M01_AXIS_TIME_DOMAIN] [get_bd_intf_pins RX_RAW_DATA_BCAST/M01_AXIS]
  connect_bd_intf_net -intf_net EMUL_Rx_FIFO_M_AXIS [get_bd_intf_pins EMUL_Rx_FIFO/M_AXIS] [get_bd_intf_pins Tx_Rx_Emulator_Switch/S_AXIS_EMUL_OUT]
  connect_bd_intf_net -intf_net EMUL_Tx_FIFO_M_AXIS [get_bd_intf_pins EMUL_Tx_FIFO/M_AXIS] [get_bd_intf_pins axis_clock_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net RF_CHAN_EMULATOR_M_AXIS [get_bd_intf_pins EMUL_Rx_FIFO/S_AXIS] [get_bd_intf_pins axis_clock_converter_1/M_AXIS]
  connect_bd_intf_net -intf_net RF_CHAN_EMULATOR_M_AXIS_DATA [get_bd_intf_pins RF_CHAN_EMULATOR/M_AXIS_DATA] [get_bd_intf_pins axis_clock_converter_1/S_AXIS]
  connect_bd_intf_net -intf_net Tx_Rx_Emulator_Switch_M_AXIS_EMUL_IN [get_bd_intf_pins EMUL_Tx_FIFO/S_AXIS] [get_bd_intf_pins Tx_Rx_Emulator_Switch/M_AXIS_EMUL_IN]
  connect_bd_intf_net -intf_net Tx_Rx_Emulator_Switch_M_AXIS_OUT [get_bd_intf_pins RX_RAW_DATA_BCAST/S_AXIS] [get_bd_intf_pins Tx_Rx_Emulator_Switch/M_AXIS_OUT]
  connect_bd_intf_net -intf_net axis_clock_converter_0_M_AXIS [get_bd_intf_pins RF_CHAN_EMULATOR/S_AXIS_DATA] [get_bd_intf_pins axis_clock_converter_0/M_AXIS]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M06_AXI [get_bd_intf_pins S_AXI_CLK_GEN] [get_bd_intf_pins Emul_Clk_Gen/s_axi_lite]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M07_AXI [get_bd_intf_pins S_AXI_FREQ_MON] [get_bd_intf_pins Emul_Clk_Freq_Ctr/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M15_AXI [get_bd_intf_pins S_AXI_EMUL] [get_bd_intf_pins RF_CHAN_EMULATOR/S00_AXI]

  # Create port connections
  connect_bd_net -net EmulLUT_douta [get_bd_pins EmulLUT/douta] [get_bd_pins RF_CHAN_EMULATOR/demod_douta]
  connect_bd_net -net EmulLUT_doutb [get_bd_pins EmulLUT/doutb] [get_bd_pins RF_CHAN_EMULATOR/demod_doutb]
  connect_bd_net -net Net5 [get_bd_pins EMUL_Rx_FIFO/s_axis_aresetn] [get_bd_pins EMUL_Tx_FIFO/m_axis_aresetn] [get_bd_pins Tx_Rx_Emulator_Switch/fifo_aresetn] [get_bd_pins axis_clock_converter_0/s_axis_aresetn] [get_bd_pins axis_clock_converter_1/m_axis_aresetn]
  connect_bd_net -net RF_CHAN_EMULATOR_demod_addra [get_bd_pins EmulLUT/addra] [get_bd_pins RF_CHAN_EMULATOR/demod_addra]
  connect_bd_net -net RF_CHAN_EMULATOR_demod_addrb [get_bd_pins EmulLUT/addrb] [get_bd_pins RF_CHAN_EMULATOR/demod_addrb]
  connect_bd_net -net RF_CHAN_EMULATOR_demod_dina [get_bd_pins EmulLUT/dina] [get_bd_pins RF_CHAN_EMULATOR/demod_dina]
  connect_bd_net -net RF_CHAN_EMULATOR_demod_dinb [get_bd_pins EmulLUT/dinb] [get_bd_pins RF_CHAN_EMULATOR/demod_dinb]
  connect_bd_net -net RF_CHAN_EMULATOR_demod_ena [get_bd_pins EmulLUT/ena] [get_bd_pins RF_CHAN_EMULATOR/demod_ena]
  connect_bd_net -net RF_CHAN_EMULATOR_demod_enb [get_bd_pins EmulLUT/enb] [get_bd_pins RF_CHAN_EMULATOR/demod_enb]
  connect_bd_net -net RF_CHAN_EMULATOR_demod_wea [get_bd_pins EmulLUT/wea] [get_bd_pins RF_CHAN_EMULATOR/demod_wea]
  connect_bd_net -net RF_CHAN_EMULATOR_demod_web [get_bd_pins EmulLUT/web] [get_bd_pins RF_CHAN_EMULATOR/demod_web]
  connect_bd_net -net Tx_Rx_Emulator_Switch_emul_aresetn [get_bd_pins RF_CHAN_EMULATOR/aresetn] [get_bd_pins Tx_Rx_Emulator_Switch/emul_aresetn] [get_bd_pins axis_clock_converter_0/m_axis_aresetn] [get_bd_pins axis_clock_converter_1/s_axis_aresetn]
  connect_bd_net -net clk_wiz_1_clk_out1 [get_bd_pins EMUL_Rx_FIFO/s_axis_aclk] [get_bd_pins EMUL_Tx_FIFO/m_axis_aclk] [get_bd_pins Emul_Clk_Freq_Ctr/ext_clk_in] [get_bd_pins Emul_Clk_Gen/clk_out1] [get_bd_pins Tx_Rx_Emulator_Switch/fifo_clk_in] [get_bd_pins axis_clock_converter_0/s_axis_aclk] [get_bd_pins axis_clock_converter_1/m_axis_aclk]
  connect_bd_net -net clk_wiz_1_locked [get_bd_pins Emul_Clk_Freq_Ctr/ext_clk_lock] [get_bd_pins Emul_Clk_Gen/locked] [get_bd_pins Tx_Rx_Emulator_Switch/fifo_clk_lock]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins EMUL_Rx_FIFO/m_axis_aclk] [get_bd_pins EMUL_Tx_FIFO/s_axis_aclk] [get_bd_pins EmulLUT/clka] [get_bd_pins EmulLUT/clkb] [get_bd_pins Emul_Clk_Freq_Ctr/s00_axi_aclk] [get_bd_pins Emul_Clk_Gen/clk_in1] [get_bd_pins Emul_Clk_Gen/s_axi_aclk] [get_bd_pins RF_CHAN_EMULATOR/aclk] [get_bd_pins RX_RAW_DATA_BCAST/aclk] [get_bd_pins Tx_Rx_Emulator_Switch/aclk] [get_bd_pins axis_clock_converter_0/m_axis_aclk] [get_bd_pins axis_clock_converter_1/s_axis_aclk]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins EMUL_Rx_FIFO/m_axis_aresetn] [get_bd_pins EMUL_Tx_FIFO/s_axis_aresetn] [get_bd_pins Emul_Clk_Freq_Ctr/s00_axi_aresetn] [get_bd_pins Emul_Clk_Gen/s_axi_aresetn] [get_bd_pins RX_RAW_DATA_BCAST/aresetn] [get_bd_pins Tx_Rx_Emulator_Switch/aresetn]

  # Perform GUI Layout
  regenerate_bd_layout -hierarchy [get_bd_cells /RF_CHANNEL_EMULATOR] -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port M00_AXIS_TIME_DOMAIN -pg 1 -y 640 -defaultsOSRD
preplace port S_AXI_SWITCH -pg 1 -y 640 -defaultsOSRD
preplace port S_AXI_CLK_GEN -pg 1 -y 520 -defaultsOSRD
preplace port S_AXIS_TXD -pg 1 -y 660 -defaultsOSRD
preplace port S_AXIS_RF_RX -pg 1 -y 680 -defaultsOSRD
preplace port M01_AXIS_TIME_DOMAIN -pg 1 -y 660 -defaultsOSRD
preplace port S_AXI_FREQ_MON -pg 1 -y 860 -defaultsOSRD
preplace port S_AXI_EMUL -pg 1 -y 380 -defaultsOSRD
preplace port aclk -pg 1 -y 540 -defaultsOSRD
preplace port M_AXIS_RF_TX -pg 1 -y 720 -defaultsOSRD
preplace portBus aresetn -pg 1 -y 560 -defaultsOSRD
preplace inst EmulLUT -pg 1 -lvl 5 -y 170 -defaultsOSRD
preplace inst Tx_Rx_Emulator_Switch -pg 1 -lvl 4 -y 710 -defaultsOSRD
preplace inst axis_clock_converter_0 -pg 1 -lvl 3 -y 500 -defaultsOSRD
preplace inst EMUL_Rx_FIFO -pg 1 -lvl 6 -y 490 -defaultsOSRD
preplace inst axis_clock_converter_1 -pg 1 -lvl 5 -y 420 -defaultsOSRD
preplace inst RF_CHAN_EMULATOR -pg 1 -lvl 4 -y 430 -defaultsOSRD
preplace inst Emul_Clk_Gen -pg 1 -lvl 1 -y 550 -defaultsOSRD
preplace inst EMUL_Tx_FIFO -pg 1 -lvl 2 -y 500 -defaultsOSRD
preplace inst Emul_Clk_Freq_Ctr -pg 1 -lvl 4 -y 900 -defaultsOSRD
preplace inst RX_RAW_DATA_BCAST -pg 1 -lvl 5 -y 650 -defaultsOSRD
preplace netloc Conn1 1 0 4 NJ 640 NJ 640 NJ 640 NJ
preplace netloc Tx_Rx_Emulator_Switch_emul_aresetn 1 2 3 650 410 900 290 1320
preplace netloc Conn2 1 4 3 NJ 720 NJ 720 NJ
preplace netloc Net5 1 1 5 330 410 640 270 NJ 270 1340 510 NJ
preplace netloc Conn3 1 0 4 NJ 680 NJ 680 NJ 680 NJ
preplace netloc processing_system7_0_axi_periph_M15_AXI 1 0 4 NJ 380 NJ 380 NJ 380 NJ
preplace netloc Tx_Rx_Emulator_Switch_M_AXIS_OUT 1 4 1 1410
preplace netloc RF_CHAN_EMULATOR_demod_wea 1 4 1 1330
preplace netloc Conn4 1 0 4 NJ 660 NJ 660 NJ 660 NJ
preplace netloc processing_system7_0_axi_periph_M07_AXI 1 0 4 NJ 860 NJ 860 NJ 860 NJ
preplace netloc RF_CHAN_EMULATOR_M_AXIS_DATA 1 4 1 1380
preplace netloc RF_CHAN_EMULATOR_demod_web 1 4 1 1400
preplace netloc Conn5 1 5 2 NJ 640 NJ
preplace netloc EMUL_Tx_FIFO_M_AXIS 1 2 1 630
preplace netloc Conn6 1 5 2 NJ 660 NJ
preplace netloc axis_clock_converter_0_M_AXIS 1 3 1 890
preplace netloc rst_processing_system7_0_50M_peripheral_aresetn 1 0 6 20 630 310 610 NJ 610 900 590 1420 540 NJ
preplace netloc RF_CHAN_EMULATOR_M_AXIS 1 5 1 1700
preplace netloc RF_CHAN_EMULATOR_demod_dina 1 4 1 1300
preplace netloc processing_system7_0_axi_periph_M06_AXI 1 0 1 NJ
preplace netloc RF_CHAN_EMULATOR_demod_dinb 1 4 1 1370
preplace netloc clk_wiz_1_locked 1 1 3 NJ 620 NJ 620 870
preplace netloc clk_wiz_1_clk_out1 1 1 5 320 590 630 590 890 580 1410 520 NJ
preplace netloc EmulLUT_douta 1 3 2 920 120 NJ
preplace netloc EMUL_Rx_FIFO_M_AXIS 1 3 4 910 -10 NJ -10 NJ -10 2020
preplace netloc Tx_Rx_Emulator_Switch_M_AXIS_EMUL_IN 1 1 4 310 280 NJ 280 NJ 280 1280
preplace netloc EmulLUT_doutb 1 3 2 930 250 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 0 6 30 650 330 600 650 600 880 240 1360 530 NJ
preplace netloc RF_CHAN_EMULATOR_demod_addra 1 4 1 1290
preplace netloc RF_CHAN_EMULATOR_demod_addrb 1 4 1 1350
preplace netloc RF_CHAN_EMULATOR_demod_ena 1 4 1 1310
preplace netloc RF_CHAN_EMULATOR_demod_enb 1 4 1 1390
levelinfo -pg 1 0 200 480 760 1110 1560 1870 2040 -top -20 -bot 990
",
}

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NULL_SYMBOL_DET
proc create_hier_cell_NULL_SYMBOL_DET { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NULL_SYMBOL_DET() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS_BCAST
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS_CORDIC
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M00_AXIS_FFT
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M01_AXIS_BCAST
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M15_AXIS_ABS
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M15_AXIS_BCAST
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_DTA
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS_PRS
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_FFT_CFG
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_NSD

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: NSD_MOVING_MAG_SQUARED
  create_hier_cell_NSD_MOVING_MAG_SQUARED $hier_obj NSD_MOVING_MAG_SQUARED

  # Create instance: NULL_SYMBOL_DETECTOR_0, and set properties
  set NULL_SYMBOL_DETECTOR_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:NULL_SYMBOL_DETECTOR:1.0 NULL_SYMBOL_DETECTOR_0 ]

  # Create instance: axis_broadcaster_1, and set properties
  set axis_broadcaster_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_1 ]
  set_property -dict [ list \
CONFIG.M00_TDATA_REMAP {tdata[15:0]} \
CONFIG.M01_TDATA_REMAP {tdata[15:0]} \
CONFIG.M_TDATA_NUM_BYTES {2} \
CONFIG.S_TDATA_NUM_BYTES {2} \
 ] $axis_broadcaster_1

  # Create instance: axis_broadcaster_2, and set properties
  set axis_broadcaster_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_2 ]
  set_property -dict [ list \
CONFIG.M00_TDATA_REMAP {tdata[15:0]} \
CONFIG.M01_TDATA_REMAP {tdata[15:0]} \
CONFIG.M_TDATA_NUM_BYTES {2} \
CONFIG.S_TDATA_NUM_BYTES {2} \
 ] $axis_broadcaster_2

  # Create instance: axis_broadcaster_3, and set properties
  set axis_broadcaster_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_broadcaster:1.1 axis_broadcaster_3 ]
  set_property -dict [ list \
CONFIG.M00_TDATA_REMAP {tdata[15:0]} \
CONFIG.M01_TDATA_REMAP {tdata[15:0]} \
CONFIG.M_TDATA_NUM_BYTES {2} \
CONFIG.S_TDATA_NUM_BYTES {2} \
 ] $axis_broadcaster_3

  # Create instance: axis_data_fifo_0, and set properties
  set axis_data_fifo_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:1.1 axis_data_fifo_0 ]
  set_property -dict [ list \
CONFIG.FIFO_DEPTH {2048} \
CONFIG.TDATA_NUM_BYTES {3} \
 ] $axis_data_fifo_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXIS_PRS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/M_AXIS_PRS]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M00_AXIS_FFT] [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M_AXIS_FFT]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXIS_DTA] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/M_AXIS_DTA]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M00_AXIS_CORDIC] [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M_AXIS_CORDIC]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M01_AXIS_ABS] [get_bd_intf_pins axis_broadcaster_2/M00_AXIS]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M15_AXIS_ABS] [get_bd_intf_pins axis_broadcaster_3/M00_AXIS]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M00_AXIS_BCAST] [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M00_AXIS_BCAST]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M01_AXIS_BCAST] [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M01_AXIS_BCAST]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M15_AXIS_BCAST] [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M15_AXIS_BCAST]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M00_AXIS_ABS_SQ [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M00_AXIS_ABS] [get_bd_intf_pins axis_broadcaster_1/S_AXIS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M01_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M01_AXIS_ABS] [get_bd_intf_pins axis_broadcaster_2/S_AXIS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M02_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M02_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S02_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M03_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M03_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S03_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M04_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M04_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S04_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M05_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M05_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S05_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M06_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M06_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S06_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M07_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M07_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S07_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M08_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M08_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S08_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M09_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M09_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S09_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M10_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M10_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S10_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M11_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M11_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S11_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M12_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M12_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S12_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M13_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M13_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S13_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M14_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M14_AXIS_ABS] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S14_AXIS_ABS]
  connect_bd_intf_net -intf_net NSD_MOVING_MAG_SQUARED_M15_AXIS_ABS [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/M15_AXIS_ABS] [get_bd_intf_pins axis_broadcaster_3/S_AXIS]
  connect_bd_intf_net -intf_net NULL_SYMBOL_DETECTOR_0_M_AXIS_FFT [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/M_AXIS_FFT]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins S_AXI_FFT_CFG] [get_bd_intf_pins NSD_MOVING_MAG_SQUARED/S_AXI_FFT_CFG]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins axis_data_fifo_0/S_AXIS]
  connect_bd_intf_net -intf_net S_AXI_NSD_1 [get_bd_intf_pins S_AXI_NSD] [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S00_AXI]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M00_AXIS [get_bd_intf_pins M00_AXIS_ABS] [get_bd_intf_pins axis_broadcaster_1/M00_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_1_M01_AXIS [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S00_AXIS_ABS] [get_bd_intf_pins axis_broadcaster_1/M01_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_2_M01_AXIS [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S01_AXIS_ABS] [get_bd_intf_pins axis_broadcaster_2/M01_AXIS]
  connect_bd_intf_net -intf_net axis_broadcaster_3_M01_AXIS [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S15_AXIS_ABS] [get_bd_intf_pins axis_broadcaster_3/M01_AXIS]
  connect_bd_intf_net -intf_net axis_data_fifo_0_M_AXIS [get_bd_intf_pins NULL_SYMBOL_DETECTOR_0/S_AXIS_RXD] [get_bd_intf_pins axis_data_fifo_0/M_AXIS]

  # Create port connections
  connect_bd_net -net NSD_MOVING_MAG_SQUARED_config_done [get_bd_pins NSD_MOVING_MAG_SQUARED/config_done] [get_bd_pins NULL_SYMBOL_DETECTOR_0/fft_cfg_done]
  connect_bd_net -net NULL_SYMBOL_DETECTOR_0_fft_cfg_rqst [get_bd_pins NSD_MOVING_MAG_SQUARED/config_in] [get_bd_pins NULL_SYMBOL_DETECTOR_0/fft_cfg_rqst]
  connect_bd_net -net NULL_SYMBOL_DETECTOR_0_fft_resetn [get_bd_pins NSD_MOVING_MAG_SQUARED/fft_resetn] [get_bd_pins NULL_SYMBOL_DETECTOR_0/fft_resetn]
  connect_bd_net -net NULL_SYMBOL_DETECTOR_0_fifo_resetn [get_bd_pins NULL_SYMBOL_DETECTOR_0/fifo_resetn] [get_bd_pins axis_data_fifo_0/s_axis_aresetn]
  connect_bd_net -net NULL_SYMBOL_DETECTOR_0_sys_resetn [get_bd_pins NSD_MOVING_MAG_SQUARED/sys_resetn] [get_bd_pins NULL_SYMBOL_DETECTOR_0/sys_resetn]
  connect_bd_net -net aclk_2 [get_bd_pins aclk] [get_bd_pins NSD_MOVING_MAG_SQUARED/aclk] [get_bd_pins NULL_SYMBOL_DETECTOR_0/aclk] [get_bd_pins axis_broadcaster_1/aclk] [get_bd_pins axis_broadcaster_2/aclk] [get_bd_pins axis_broadcaster_3/aclk] [get_bd_pins axis_data_fifo_0/s_axis_aclk]
  connect_bd_net -net aresetn1_1 [get_bd_pins aresetn] [get_bd_pins NSD_MOVING_MAG_SQUARED/aresetn] [get_bd_pins NULL_SYMBOL_DETECTOR_0/aresetn] [get_bd_pins axis_broadcaster_1/aresetn] [get_bd_pins axis_broadcaster_2/aresetn] [get_bd_pins axis_broadcaster_3/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_PRS_DATA_SINK
proc create_hier_cell_NSD_PRS_DATA_SINK { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_PRS_DATA_SINK() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: AXI4_Stream_Data_Slicer_0, and set properties
  set AXI4_Stream_Data_Slicer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 AXI4_Stream_Data_Slicer_0 ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $AXI4_Stream_Data_Slicer_0

  # Create instance: RX_RAW_DATA_SINK, and set properties
  set RX_RAW_DATA_SINK [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 RX_RAW_DATA_SINK ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {13} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {13} \
 ] $RX_RAW_DATA_SINK

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0 ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins AXI4_Stream_Data_Slicer_0/M_AXIS_DATA] [get_bd_intf_pins RX_RAW_DATA_SINK/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins AXI4_Stream_Data_Slicer_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M17_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins RX_RAW_DATA_SINK/S00_AXI]

  # Create port connections
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_in_addr [get_bd_pins RX_RAW_DATA_SINK/data_buf_in_addr] [get_bd_pins blk_mem_gen_0/addra]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_in_data [get_bd_pins RX_RAW_DATA_SINK/data_buf_in_data] [get_bd_pins blk_mem_gen_0/dina]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_in_we [get_bd_pins RX_RAW_DATA_SINK/data_buf_in_we] [get_bd_pins blk_mem_gen_0/wea]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_out_addr [get_bd_pins RX_RAW_DATA_SINK/data_buf_out_addr] [get_bd_pins blk_mem_gen_0/addrb]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_out_en [get_bd_pins RX_RAW_DATA_SINK/data_buf_out_en] [get_bd_pins blk_mem_gen_0/enb]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins RX_RAW_DATA_SINK/data_buf_out_data] [get_bd_pins blk_mem_gen_0/doutb]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins AXI4_Stream_Data_Slicer_0/aclk] [get_bd_pins RX_RAW_DATA_SINK/aclk] [get_bd_pins blk_mem_gen_0/clka] [get_bd_pins blk_mem_gen_0/clkb]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins AXI4_Stream_Data_Slicer_0/aresetn] [get_bd_pins RX_RAW_DATA_SINK/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_FFT_DATA_SINK
proc create_hier_cell_NSD_FFT_DATA_SINK { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_FFT_DATA_SINK() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn
  create_bd_pin -dir I clkb

  # Create instance: AXI4_Stream_Data_Sink_1, and set properties
  set AXI4_Stream_Data_Sink_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 AXI4_Stream_Data_Sink_1 ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {16} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {16} \
 ] $AXI4_Stream_Data_Sink_1

  # Create instance: AXI4_Stream_Data_Slicer_0, and set properties
  set AXI4_Stream_Data_Slicer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 AXI4_Stream_Data_Slicer_0 ]

  # Create instance: blk_mem_gen_2, and set properties
  set blk_mem_gen_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_2 ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {65536} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_2

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins AXI4_Stream_Data_Sink_1/S_AXIS_DATA] [get_bd_intf_pins AXI4_Stream_Data_Slicer_0/M_AXIS_DATA]
  connect_bd_intf_net -intf_net NULL_SYMBOL_DET_M_AXIS_FFT [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins AXI4_Stream_Data_Slicer_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M20_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins AXI4_Stream_Data_Sink_1/S00_AXI]

  # Create port connections
  connect_bd_net -net AXI4_Stream_Data_Sink_1_data_buf_in_addr [get_bd_pins AXI4_Stream_Data_Sink_1/data_buf_in_addr] [get_bd_pins blk_mem_gen_2/addra]
  connect_bd_net -net AXI4_Stream_Data_Sink_1_data_buf_in_data [get_bd_pins AXI4_Stream_Data_Sink_1/data_buf_in_data] [get_bd_pins blk_mem_gen_2/dina]
  connect_bd_net -net AXI4_Stream_Data_Sink_1_data_buf_in_we [get_bd_pins AXI4_Stream_Data_Sink_1/data_buf_in_we] [get_bd_pins blk_mem_gen_2/wea]
  connect_bd_net -net AXI4_Stream_Data_Sink_1_data_buf_out_addr [get_bd_pins AXI4_Stream_Data_Sink_1/data_buf_out_addr] [get_bd_pins blk_mem_gen_2/addrb]
  connect_bd_net -net AXI4_Stream_Data_Sink_1_data_buf_out_en [get_bd_pins AXI4_Stream_Data_Sink_1/data_buf_out_en] [get_bd_pins blk_mem_gen_2/enb]
  connect_bd_net -net blk_mem_gen_2_doutb [get_bd_pins AXI4_Stream_Data_Sink_1/data_buf_out_data] [get_bd_pins blk_mem_gen_2/doutb]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins clkb] [get_bd_pins AXI4_Stream_Data_Sink_1/aclk] [get_bd_pins AXI4_Stream_Data_Slicer_0/aclk] [get_bd_pins blk_mem_gen_2/clka] [get_bd_pins blk_mem_gen_2/clkb]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins AXI4_Stream_Data_Sink_1/aresetn] [get_bd_pins AXI4_Stream_Data_Slicer_0/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_DTA_DATA_SINK
proc create_hier_cell_NSD_DTA_DATA_SINK { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_DTA_DATA_SINK() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: AXI4_Stream_Data_Slicer_0, and set properties
  set AXI4_Stream_Data_Slicer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 AXI4_Stream_Data_Slicer_0 ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $AXI4_Stream_Data_Slicer_0

  # Create instance: RX_RAW_DATA_SINK, and set properties
  set RX_RAW_DATA_SINK [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 RX_RAW_DATA_SINK ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {16} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {16} \
 ] $RX_RAW_DATA_SINK

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0 ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {65536} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_0

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins AXI4_Stream_Data_Slicer_0/M_AXIS_DATA] [get_bd_intf_pins RX_RAW_DATA_SINK/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins AXI4_Stream_Data_Slicer_0/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M17_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins RX_RAW_DATA_SINK/S00_AXI]

  # Create port connections
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_in_addr [get_bd_pins RX_RAW_DATA_SINK/data_buf_in_addr] [get_bd_pins blk_mem_gen_0/addra]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_in_data [get_bd_pins RX_RAW_DATA_SINK/data_buf_in_data] [get_bd_pins blk_mem_gen_0/dina]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_in_we [get_bd_pins RX_RAW_DATA_SINK/data_buf_in_we] [get_bd_pins blk_mem_gen_0/wea]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_out_addr [get_bd_pins RX_RAW_DATA_SINK/data_buf_out_addr] [get_bd_pins blk_mem_gen_0/addrb]
  connect_bd_net -net RX_RAW_DATA_SINK_data_buf_out_en [get_bd_pins RX_RAW_DATA_SINK/data_buf_out_en] [get_bd_pins blk_mem_gen_0/enb]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins RX_RAW_DATA_SINK/data_buf_out_data] [get_bd_pins blk_mem_gen_0/doutb]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins AXI4_Stream_Data_Slicer_0/aclk] [get_bd_pins RX_RAW_DATA_SINK/aclk] [get_bd_pins blk_mem_gen_0/clka] [get_bd_pins blk_mem_gen_0/clkb]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins AXI4_Stream_Data_Slicer_0/aresetn] [get_bd_pins RX_RAW_DATA_SINK/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_CORDIC_DATA_SINK
proc create_hier_cell_NSD_CORDIC_DATA_SINK { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_CORDIC_DATA_SINK() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: AXI4_Stream_Data_Sink_0, and set properties
  set AXI4_Stream_Data_Sink_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 AXI4_Stream_Data_Sink_0 ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {16} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {16} \
 ] $AXI4_Stream_Data_Sink_0

  # Create instance: AXI4_Stream_Data_Slicer_1, and set properties
  set AXI4_Stream_Data_Slicer_1 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 AXI4_Stream_Data_Slicer_1 ]

  # Create instance: blk_mem_gen_1, and set properties
  set blk_mem_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_1 ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {65536} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_1

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_1_M_AXIS_DATA [get_bd_intf_pins AXI4_Stream_Data_Sink_0/S_AXIS_DATA] [get_bd_intf_pins AXI4_Stream_Data_Slicer_1/M_AXIS_DATA]
  connect_bd_intf_net -intf_net NULL_SYMBOL_DET_M_AXIS_CORDIC [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins AXI4_Stream_Data_Slicer_1/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M19_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins AXI4_Stream_Data_Sink_0/S00_AXI]

  # Create port connections
  connect_bd_net -net AXI4_Stream_Data_Sink_0_data_buf_in_addr [get_bd_pins AXI4_Stream_Data_Sink_0/data_buf_in_addr] [get_bd_pins blk_mem_gen_1/addra]
  connect_bd_net -net AXI4_Stream_Data_Sink_0_data_buf_in_data [get_bd_pins AXI4_Stream_Data_Sink_0/data_buf_in_data] [get_bd_pins blk_mem_gen_1/dina]
  connect_bd_net -net AXI4_Stream_Data_Sink_0_data_buf_in_we [get_bd_pins AXI4_Stream_Data_Sink_0/data_buf_in_we] [get_bd_pins blk_mem_gen_1/wea]
  connect_bd_net -net AXI4_Stream_Data_Sink_0_data_buf_out_addr [get_bd_pins AXI4_Stream_Data_Sink_0/data_buf_out_addr] [get_bd_pins blk_mem_gen_1/addrb]
  connect_bd_net -net AXI4_Stream_Data_Sink_0_data_buf_out_en [get_bd_pins AXI4_Stream_Data_Sink_0/data_buf_out_en] [get_bd_pins blk_mem_gen_1/enb]
  connect_bd_net -net blk_mem_gen_1_doutb [get_bd_pins AXI4_Stream_Data_Sink_0/data_buf_out_data] [get_bd_pins blk_mem_gen_1/doutb]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins AXI4_Stream_Data_Sink_0/aclk] [get_bd_pins AXI4_Stream_Data_Slicer_1/aclk] [get_bd_pins blk_mem_gen_1/clka] [get_bd_pins blk_mem_gen_1/clkb]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins AXI4_Stream_Data_Sink_0/aresetn] [get_bd_pins AXI4_Stream_Data_Slicer_1/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_BCAST_DATA_SINK_2
proc create_hier_cell_NSD_BCAST_DATA_SINK_2 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_BCAST_DATA_SINK_2() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: BRAM, and set properties
  set BRAM [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 BRAM ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $BRAM

  # Create instance: DATA_SINK, and set properties
  set DATA_SINK [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 DATA_SINK ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {13} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {13} \
 ] $DATA_SINK

  # Create instance: DATA_SLICER, and set properties
  set DATA_SLICER [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 DATA_SLICER ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $DATA_SLICER

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins DATA_SINK/S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M17_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins DATA_SINK/S00_AXI]

  # Create port connections
  connect_bd_net -net DATA_SINK_data_buf_in_addr [get_bd_pins BRAM/addra] [get_bd_pins DATA_SINK/data_buf_in_addr]
  connect_bd_net -net DATA_SINK_data_buf_in_data [get_bd_pins BRAM/dina] [get_bd_pins DATA_SINK/data_buf_in_data]
  connect_bd_net -net DATA_SINK_data_buf_in_we [get_bd_pins BRAM/wea] [get_bd_pins DATA_SINK/data_buf_in_we]
  connect_bd_net -net DATA_SINK_data_buf_out_addr [get_bd_pins BRAM/addrb] [get_bd_pins DATA_SINK/data_buf_out_addr]
  connect_bd_net -net DATA_SINK_data_buf_out_en [get_bd_pins BRAM/enb] [get_bd_pins DATA_SINK/data_buf_out_en]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins BRAM/doutb] [get_bd_pins DATA_SINK/data_buf_out_data]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins BRAM/clka] [get_bd_pins BRAM/clkb] [get_bd_pins DATA_SINK/aclk] [get_bd_pins DATA_SLICER/aclk]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins DATA_SINK/aresetn] [get_bd_pins DATA_SLICER/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_BCAST_DATA_SINK_1
proc create_hier_cell_NSD_BCAST_DATA_SINK_1 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_BCAST_DATA_SINK_1() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: BRAM, and set properties
  set BRAM [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 BRAM ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $BRAM

  # Create instance: DATA_SINK, and set properties
  set DATA_SINK [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 DATA_SINK ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {13} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {13} \
 ] $DATA_SINK

  # Create instance: DATA_SLICER, and set properties
  set DATA_SLICER [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 DATA_SLICER ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $DATA_SLICER

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins DATA_SINK/S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M17_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins DATA_SINK/S00_AXI]

  # Create port connections
  connect_bd_net -net DATA_SINK_data_buf_in_addr [get_bd_pins BRAM/addra] [get_bd_pins DATA_SINK/data_buf_in_addr]
  connect_bd_net -net DATA_SINK_data_buf_in_data [get_bd_pins BRAM/dina] [get_bd_pins DATA_SINK/data_buf_in_data]
  connect_bd_net -net DATA_SINK_data_buf_in_we [get_bd_pins BRAM/wea] [get_bd_pins DATA_SINK/data_buf_in_we]
  connect_bd_net -net DATA_SINK_data_buf_out_addr [get_bd_pins BRAM/addrb] [get_bd_pins DATA_SINK/data_buf_out_addr]
  connect_bd_net -net DATA_SINK_data_buf_out_en [get_bd_pins BRAM/enb] [get_bd_pins DATA_SINK/data_buf_out_en]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins BRAM/doutb] [get_bd_pins DATA_SINK/data_buf_out_data]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins BRAM/clka] [get_bd_pins BRAM/clkb] [get_bd_pins DATA_SINK/aclk] [get_bd_pins DATA_SLICER/aclk]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins DATA_SINK/aresetn] [get_bd_pins DATA_SLICER/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_BCAST_DATA_SINK_0
proc create_hier_cell_NSD_BCAST_DATA_SINK_0 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_BCAST_DATA_SINK_0() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: BRAM, and set properties
  set BRAM [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 BRAM ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $BRAM

  # Create instance: DATA_SINK, and set properties
  set DATA_SINK [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 DATA_SINK ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {13} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {13} \
 ] $DATA_SINK

  # Create instance: DATA_SLICER, and set properties
  set DATA_SLICER [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 DATA_SLICER ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000FFF0FFF} \
CONFIG.C_S_AXIS_MAP {0x00000000000000000000000000FFFFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {24} \
 ] $DATA_SLICER

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins DATA_SINK/S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M17_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins DATA_SINK/S00_AXI]

  # Create port connections
  connect_bd_net -net DATA_SINK_data_buf_in_addr [get_bd_pins BRAM/addra] [get_bd_pins DATA_SINK/data_buf_in_addr]
  connect_bd_net -net DATA_SINK_data_buf_in_data [get_bd_pins BRAM/dina] [get_bd_pins DATA_SINK/data_buf_in_data]
  connect_bd_net -net DATA_SINK_data_buf_in_we [get_bd_pins BRAM/wea] [get_bd_pins DATA_SINK/data_buf_in_we]
  connect_bd_net -net DATA_SINK_data_buf_out_addr [get_bd_pins BRAM/addrb] [get_bd_pins DATA_SINK/data_buf_out_addr]
  connect_bd_net -net DATA_SINK_data_buf_out_en [get_bd_pins BRAM/enb] [get_bd_pins DATA_SINK/data_buf_out_en]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins BRAM/doutb] [get_bd_pins DATA_SINK/data_buf_out_data]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins BRAM/clka] [get_bd_pins BRAM/clkb] [get_bd_pins DATA_SINK/aclk] [get_bd_pins DATA_SLICER/aclk]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins DATA_SINK/aresetn] [get_bd_pins DATA_SLICER/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_ABS_DATA_SINK_2
proc create_hier_cell_NSD_ABS_DATA_SINK_2 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_ABS_DATA_SINK_2() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: BRAM, and set properties
  set BRAM [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 BRAM ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $BRAM

  # Create instance: DATA_SINK, and set properties
  set DATA_SINK [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 DATA_SINK ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {13} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {13} \
 ] $DATA_SINK

  # Create instance: DATA_SLICER, and set properties
  set DATA_SLICER [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 DATA_SLICER ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {16} \
 ] $DATA_SLICER

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins DATA_SINK/S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M17_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins DATA_SINK/S00_AXI]

  # Create port connections
  connect_bd_net -net DATA_SINK_data_buf_in_addr [get_bd_pins BRAM/addra] [get_bd_pins DATA_SINK/data_buf_in_addr]
  connect_bd_net -net DATA_SINK_data_buf_in_data [get_bd_pins BRAM/dina] [get_bd_pins DATA_SINK/data_buf_in_data]
  connect_bd_net -net DATA_SINK_data_buf_in_we [get_bd_pins BRAM/wea] [get_bd_pins DATA_SINK/data_buf_in_we]
  connect_bd_net -net DATA_SINK_data_buf_out_addr [get_bd_pins BRAM/addrb] [get_bd_pins DATA_SINK/data_buf_out_addr]
  connect_bd_net -net DATA_SINK_data_buf_out_en [get_bd_pins BRAM/enb] [get_bd_pins DATA_SINK/data_buf_out_en]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins BRAM/doutb] [get_bd_pins DATA_SINK/data_buf_out_data]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins BRAM/clka] [get_bd_pins BRAM/clkb] [get_bd_pins DATA_SINK/aclk] [get_bd_pins DATA_SLICER/aclk]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins DATA_SINK/aresetn] [get_bd_pins DATA_SLICER/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_ABS_DATA_SINK_1
proc create_hier_cell_NSD_ABS_DATA_SINK_1 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_ABS_DATA_SINK_1() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: BRAM, and set properties
  set BRAM [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 BRAM ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $BRAM

  # Create instance: DATA_SINK, and set properties
  set DATA_SINK [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 DATA_SINK ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {13} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {13} \
 ] $DATA_SINK

  # Create instance: DATA_SLICER, and set properties
  set DATA_SLICER [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 DATA_SLICER ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {16} \
 ] $DATA_SLICER

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins DATA_SINK/S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M17_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins DATA_SINK/S00_AXI]

  # Create port connections
  connect_bd_net -net DATA_SINK_data_buf_in_addr [get_bd_pins BRAM/addra] [get_bd_pins DATA_SINK/data_buf_in_addr]
  connect_bd_net -net DATA_SINK_data_buf_in_data [get_bd_pins BRAM/dina] [get_bd_pins DATA_SINK/data_buf_in_data]
  connect_bd_net -net DATA_SINK_data_buf_in_we [get_bd_pins BRAM/wea] [get_bd_pins DATA_SINK/data_buf_in_we]
  connect_bd_net -net DATA_SINK_data_buf_out_addr [get_bd_pins BRAM/addrb] [get_bd_pins DATA_SINK/data_buf_out_addr]
  connect_bd_net -net DATA_SINK_data_buf_out_en [get_bd_pins BRAM/enb] [get_bd_pins DATA_SINK/data_buf_out_en]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins BRAM/doutb] [get_bd_pins DATA_SINK/data_buf_out_data]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins BRAM/clka] [get_bd_pins BRAM/clkb] [get_bd_pins DATA_SINK/aclk] [get_bd_pins DATA_SLICER/aclk]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins DATA_SINK/aresetn] [get_bd_pins DATA_SLICER/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: NSD_ABS_DATA_SINK_0
proc create_hier_cell_NSD_ABS_DATA_SINK_0 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_NSD_ABS_DATA_SINK_0() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS_DATA

  # Create pins
  create_bd_pin -dir I aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst aresetn

  # Create instance: BRAM, and set properties
  set BRAM [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 BRAM ]
  set_property -dict [ list \
CONFIG.Assume_Synchronous_Clk {true} \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Operating_Mode_B {READ_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $BRAM

  # Create instance: DATA_SINK, and set properties
  set DATA_SINK [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Sink:4.0 DATA_SINK ]
  set_property -dict [ list \
CONFIG.C_IN_BUF_ADDR_WIDTH {13} \
CONFIG.C_OUT_BUF_ADDR_WIDTH {13} \
 ] $DATA_SINK

  # Create instance: DATA_SLICER, and set properties
  set DATA_SLICER [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI4_Stream_Data_Slicer:1.0 DATA_SLICER ]
  set_property -dict [ list \
CONFIG.C_M_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_MAP {0x0000000000000000000000000000FFFF} \
CONFIG.C_S_AXIS_TDATA_WIDTH {16} \
 ] $DATA_SLICER

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Slicer_0_M_AXIS_DATA [get_bd_intf_pins DATA_SINK/S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/M_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins S_AXIS_DATA] [get_bd_intf_pins DATA_SLICER/S_AXIS_DATA]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M17_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins DATA_SINK/S00_AXI]

  # Create port connections
  connect_bd_net -net DATA_SINK_data_buf_in_addr [get_bd_pins BRAM/addra] [get_bd_pins DATA_SINK/data_buf_in_addr]
  connect_bd_net -net DATA_SINK_data_buf_in_data [get_bd_pins BRAM/dina] [get_bd_pins DATA_SINK/data_buf_in_data]
  connect_bd_net -net DATA_SINK_data_buf_in_we [get_bd_pins BRAM/wea] [get_bd_pins DATA_SINK/data_buf_in_we]
  connect_bd_net -net DATA_SINK_data_buf_out_addr [get_bd_pins BRAM/addrb] [get_bd_pins DATA_SINK/data_buf_out_addr]
  connect_bd_net -net DATA_SINK_data_buf_out_en [get_bd_pins BRAM/enb] [get_bd_pins DATA_SINK/data_buf_out_en]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins BRAM/doutb] [get_bd_pins DATA_SINK/data_buf_out_data]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins aclk] [get_bd_pins BRAM/clka] [get_bd_pins BRAM/clkb] [get_bd_pins DATA_SINK/aclk] [get_bd_pins DATA_SLICER/aclk]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins aresetn] [get_bd_pins DATA_SINK/aresetn] [get_bd_pins DATA_SLICER/aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set enable [ create_bd_port -dir O enable ]
  set gpio_ctl [ create_bd_port -dir IO -from 3 -to 0 gpio_ctl ]
  set gpio_en_agc [ create_bd_port -dir IO gpio_en_agc ]
  set gpio_resetb [ create_bd_port -dir IO gpio_resetb ]
  set gpio_status [ create_bd_port -dir IO -from 7 -to 0 gpio_status ]
  set gpio_sync [ create_bd_port -dir IO gpio_sync ]
  set rx_clk_in_n [ create_bd_port -dir I rx_clk_in_n ]
  set rx_clk_in_p [ create_bd_port -dir I -type clk rx_clk_in_p ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {250000000} \
 ] $rx_clk_in_p
  set rx_data_in_n [ create_bd_port -dir I -from 5 -to 0 rx_data_in_n ]
  set rx_data_in_p [ create_bd_port -dir I -from 5 -to 0 rx_data_in_p ]
  set rx_frame_in_n [ create_bd_port -dir I rx_frame_in_n ]
  set rx_frame_in_p [ create_bd_port -dir I rx_frame_in_p ]
  set spi_clk [ create_bd_port -dir O spi_clk ]
  set spi_csn [ create_bd_port -dir O spi_csn ]
  set spi_miso [ create_bd_port -dir I spi_miso ]
  set spi_mosi [ create_bd_port -dir O spi_mosi ]
  set tx_clk_out_n [ create_bd_port -dir O tx_clk_out_n ]
  set tx_clk_out_p [ create_bd_port -dir O tx_clk_out_p ]
  set tx_data_out_n [ create_bd_port -dir O -from 5 -to 0 tx_data_out_n ]
  set tx_data_out_p [ create_bd_port -dir O -from 5 -to 0 tx_data_out_p ]
  set tx_frame_out_n [ create_bd_port -dir O -type clk tx_frame_out_n ]
  set tx_frame_out_p [ create_bd_port -dir O tx_frame_out_p ]
  set txnrx [ create_bd_port -dir O txnrx ]

  # Create instance: GM_Simple_Timer_0, and set properties
  set GM_Simple_Timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:GM_Simple_Timer:1.0 GM_Simple_Timer_0 ]

  # Create instance: NSD_ABS_DATA_SINK_0
  create_hier_cell_NSD_ABS_DATA_SINK_0 [current_bd_instance .] NSD_ABS_DATA_SINK_0

  # Create instance: NSD_ABS_DATA_SINK_1
  create_hier_cell_NSD_ABS_DATA_SINK_1 [current_bd_instance .] NSD_ABS_DATA_SINK_1

  # Create instance: NSD_ABS_DATA_SINK_2
  create_hier_cell_NSD_ABS_DATA_SINK_2 [current_bd_instance .] NSD_ABS_DATA_SINK_2

  # Create instance: NSD_BCAST_DATA_SINK_0
  create_hier_cell_NSD_BCAST_DATA_SINK_0 [current_bd_instance .] NSD_BCAST_DATA_SINK_0

  # Create instance: NSD_BCAST_DATA_SINK_1
  create_hier_cell_NSD_BCAST_DATA_SINK_1 [current_bd_instance .] NSD_BCAST_DATA_SINK_1

  # Create instance: NSD_BCAST_DATA_SINK_2
  create_hier_cell_NSD_BCAST_DATA_SINK_2 [current_bd_instance .] NSD_BCAST_DATA_SINK_2

  # Create instance: NSD_CORDIC_DATA_SINK
  create_hier_cell_NSD_CORDIC_DATA_SINK [current_bd_instance .] NSD_CORDIC_DATA_SINK

  # Create instance: NSD_DTA_DATA_SINK
  create_hier_cell_NSD_DTA_DATA_SINK [current_bd_instance .] NSD_DTA_DATA_SINK

  # Create instance: NSD_FFT_DATA_SINK
  create_hier_cell_NSD_FFT_DATA_SINK [current_bd_instance .] NSD_FFT_DATA_SINK

  # Create instance: NSD_PRS_DATA_SINK
  create_hier_cell_NSD_PRS_DATA_SINK [current_bd_instance .] NSD_PRS_DATA_SINK

  # Create instance: NULL_SYMBOL_DET
  create_hier_cell_NULL_SYMBOL_DET [current_bd_instance .] NULL_SYMBOL_DET

  # Create instance: RF_CHANNEL_EMULATOR
  create_hier_cell_RF_CHANNEL_EMULATOR [current_bd_instance .] RF_CHANNEL_EMULATOR

  # Create instance: RF_INTERFACE
  create_hier_cell_RF_INTERFACE [current_bd_instance .] RF_INTERFACE

  # Create instance: TIME_DOMAIN_DATA_SINK
  create_hier_cell_TIME_DOMAIN_DATA_SINK [current_bd_instance .] TIME_DOMAIN_DATA_SINK

  # Create instance: TRAINING_SYMB_INJECTOR
  create_hier_cell_TRAINING_SYMB_INJECTOR [current_bd_instance .] TRAINING_SYMB_INJECTOR

  # Create instance: TX_DATA_FFT
  create_hier_cell_TX_DATA_FFT [current_bd_instance .] TX_DATA_FFT

  # Create instance: TX_DATA_SOURCE
  create_hier_cell_TX_DATA_SOURCE [current_bd_instance .] TX_DATA_SOURCE

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SD1_SD1_IO {<Select>} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SPI1_SPI1_IO {<Select>} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.preset {ZC706} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {1} \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.M15_HAS_REGSLICE {0} \
CONFIG.NUM_MI {27} \
CONFIG.SYNCHRONIZATION_STAGES {3} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_50M, and set properties
  set rst_processing_system7_0_50M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_50M ]

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]

  # Create interface connections
  connect_bd_intf_net -intf_net AXI4_Stream_Data_Source_M00_AXIS [get_bd_intf_pins TX_DATA_FFT/S_AXIS_DATA] [get_bd_intf_pins TX_DATA_SOURCE/M00_AXIS]
  connect_bd_intf_net -intf_net NULL_SYMBOL_DET_M00_AXIS_BCAST [get_bd_intf_pins NSD_BCAST_DATA_SINK_0/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DET/M00_AXIS_BCAST]
  connect_bd_intf_net -intf_net NULL_SYMBOL_DET_M01_AXIS_BCAST [get_bd_intf_pins NSD_BCAST_DATA_SINK_1/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DET/M01_AXIS_BCAST]
  connect_bd_intf_net -intf_net NULL_SYMBOL_DET_M15_AXIS_BCAST [get_bd_intf_pins NSD_BCAST_DATA_SINK_2/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DET/M15_AXIS_BCAST]
  connect_bd_intf_net -intf_net NULL_SYMBOL_DET_M_AXIS_CORDIC [get_bd_intf_pins NSD_CORDIC_DATA_SINK/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DET/M00_AXIS_CORDIC]
  connect_bd_intf_net -intf_net NULL_SYMBOL_DET_M_AXIS_DATA [get_bd_intf_pins NSD_DTA_DATA_SINK/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DET/M_AXIS_DTA]
  connect_bd_intf_net -intf_net NULL_SYMBOL_DET_M_AXIS_FFT [get_bd_intf_pins NSD_FFT_DATA_SINK/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DET/M00_AXIS_FFT]
  connect_bd_intf_net -intf_net NULL_SYMBOL_DET_M_AXIS_PRS [get_bd_intf_pins NSD_PRS_DATA_SINK/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DET/M_AXIS_PRS]
  connect_bd_intf_net -intf_net RF_CHANNEL_EMULATOR_M_AXIS_DEVICE_IN [get_bd_intf_pins RF_CHANNEL_EMULATOR/M_AXIS_RF_TX] [get_bd_intf_pins RF_INTERFACE/S_AXIS_TXD]
  connect_bd_intf_net -intf_net Rx_FIFO_M_AXIS [get_bd_intf_pins RF_CHANNEL_EMULATOR/S_AXIS_RF_RX] [get_bd_intf_pins RF_INTERFACE/M_AXIS_RXD]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins NSD_ABS_DATA_SINK_0/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DET/M00_AXIS_ABS]
  connect_bd_intf_net -intf_net S_AXIS_2 [get_bd_intf_pins RF_CHANNEL_EMULATOR/M01_AXIS_TIME_DOMAIN] [get_bd_intf_pins TIME_DOMAIN_DATA_SINK/S_AXIS_DATA]
  connect_bd_intf_net -intf_net S_AXIS_DATA_1 [get_bd_intf_pins NULL_SYMBOL_DET/S_AXIS_DATA] [get_bd_intf_pins RF_CHANNEL_EMULATOR/M00_AXIS_TIME_DOMAIN]
  connect_bd_intf_net -intf_net S_AXIS_DATA_2 [get_bd_intf_pins NSD_ABS_DATA_SINK_1/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DET/M01_AXIS_ABS]
  connect_bd_intf_net -intf_net S_AXIS_DATA_3 [get_bd_intf_pins NSD_ABS_DATA_SINK_2/S_AXIS_DATA] [get_bd_intf_pins NULL_SYMBOL_DET/M15_AXIS_ABS]
  connect_bd_intf_net -intf_net TRAINING_SYMB_INJECTOR_M_AXIS_DATA [get_bd_intf_pins RF_CHANNEL_EMULATOR/S_AXIS_TXD] [get_bd_intf_pins TRAINING_SYMB_INJECTOR/M_AXIS_DATA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins TX_DATA_SOURCE/S00_AXI1] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins TX_DATA_SOURCE/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins GM_Simple_Timer_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M04_AXI [get_bd_intf_pins RF_INTERFACE/S_AXI_CLK_FRQ_CTR] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M05_AXI [get_bd_intf_pins RF_INTERFACE/S_AXI_DAC_FRQ_CTR] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M06_AXI [get_bd_intf_pins RF_INTERFACE/S_AXI_AD9364] [get_bd_intf_pins processing_system7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M07_AXI [get_bd_intf_pins TX_DATA_FFT/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M08_AXI [get_bd_intf_pins TRAINING_SYMB_INJECTOR/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M09_AXI [get_bd_intf_pins RF_CHANNEL_EMULATOR/S_AXI_EMUL] [get_bd_intf_pins processing_system7_0_axi_periph/M09_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M10_AXI [get_bd_intf_pins RF_CHANNEL_EMULATOR/S_AXI_CLK_GEN] [get_bd_intf_pins processing_system7_0_axi_periph/M10_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M11_AXI [get_bd_intf_pins RF_CHANNEL_EMULATOR/S_AXI_FREQ_MON] [get_bd_intf_pins processing_system7_0_axi_periph/M11_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M12_AXI [get_bd_intf_pins RF_CHANNEL_EMULATOR/S_AXI_SWITCH] [get_bd_intf_pins processing_system7_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M13_AXI [get_bd_intf_pins NULL_SYMBOL_DET/S_AXI_NSD] [get_bd_intf_pins processing_system7_0_axi_periph/M13_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M14_AXI [get_bd_intf_pins NULL_SYMBOL_DET/S_AXI_FFT_CFG] [get_bd_intf_pins processing_system7_0_axi_periph/M14_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M15_AXI [get_bd_intf_pins TIME_DOMAIN_DATA_SINK/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M15_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M16_AXI [get_bd_intf_pins NSD_DTA_DATA_SINK/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M16_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M17_AXI [get_bd_intf_pins NSD_ABS_DATA_SINK_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M17_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M18_AXI [get_bd_intf_pins RF_INTERFACE/S_AXI_ADC_FRQ_CTR] [get_bd_intf_pins processing_system7_0_axi_periph/M18_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M19_AXI [get_bd_intf_pins NSD_CORDIC_DATA_SINK/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M19_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M20_AXI [get_bd_intf_pins NSD_FFT_DATA_SINK/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M20_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M21_AXI [get_bd_intf_pins NSD_BCAST_DATA_SINK_0/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M21_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M22_AXI [get_bd_intf_pins NSD_ABS_DATA_SINK_1/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M22_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M23_AXI [get_bd_intf_pins NSD_ABS_DATA_SINK_2/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M23_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M24_AXI [get_bd_intf_pins NSD_BCAST_DATA_SINK_1/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M24_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M25_AXI [get_bd_intf_pins NSD_BCAST_DATA_SINK_2/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M25_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M26_AXI [get_bd_intf_pins NSD_PRS_DATA_SINK/S00_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M26_AXI]
  connect_bd_intf_net -intf_net xfft_0_M_AXIS_DATA [get_bd_intf_pins TRAINING_SYMB_INJECTOR/S_AXIS_DATA] [get_bd_intf_pins TX_DATA_FFT/M_AXIS_DATA]

  # Create port connections
  connect_bd_net -net AXI4_Stream_Data_Source_irq [get_bd_pins TX_DATA_SOURCE/irq] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net GM_Simple_Timer_0_irq [get_bd_pins GM_Simple_Timer_0/irq] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net Net [get_bd_ports gpio_status] [get_bd_pins RF_INTERFACE/GPIO_P00]
  connect_bd_net -net Net1 [get_bd_ports gpio_ctl] [get_bd_pins RF_INTERFACE/GPIO_P01]
  connect_bd_net -net Net2 [get_bd_ports gpio_en_agc] [get_bd_pins RF_INTERFACE/GPIO_P02]
  connect_bd_net -net Net3 [get_bd_ports gpio_sync] [get_bd_pins RF_INTERFACE/GPIO_P03]
  connect_bd_net -net Net4 [get_bd_ports gpio_resetb] [get_bd_pins RF_INTERFACE/GPIO_P04]
  connect_bd_net -net SPI0_MISO_I_1 [get_bd_ports spi_miso] [get_bd_pins processing_system7_0/SPI0_MISO_I]
  connect_bd_net -net TRAINING_SYMB_INJECTOR_irq [get_bd_pins TRAINING_SYMB_INJECTOR/irq] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net X_IOBUF_0_GPIO_I [get_bd_pins RF_INTERFACE/GPIO_I] [get_bd_pins processing_system7_0/GPIO_I]
  connect_bd_net -net axi_ad9361_0_enable [get_bd_ports enable] [get_bd_pins RF_INTERFACE/enable]
  connect_bd_net -net axi_ad9361_0_tx_clk_out_n [get_bd_ports tx_clk_out_n] [get_bd_pins RF_INTERFACE/tx_clk_out_n]
  connect_bd_net -net axi_ad9361_0_tx_clk_out_p [get_bd_ports tx_clk_out_p] [get_bd_pins RF_INTERFACE/tx_clk_out_p]
  connect_bd_net -net axi_ad9361_0_tx_data_out_n [get_bd_ports tx_data_out_n] [get_bd_pins RF_INTERFACE/tx_data_out_n]
  connect_bd_net -net axi_ad9361_0_tx_data_out_p [get_bd_ports tx_data_out_p] [get_bd_pins RF_INTERFACE/tx_data_out_p]
  connect_bd_net -net axi_ad9361_0_tx_frame_out_n [get_bd_ports tx_frame_out_n] [get_bd_pins RF_INTERFACE/tx_frame_out_n]
  connect_bd_net -net axi_ad9361_0_tx_frame_out_p [get_bd_ports tx_frame_out_p] [get_bd_pins RF_INTERFACE/tx_frame_out_p]
  connect_bd_net -net axi_ad9361_0_txnrx [get_bd_ports txnrx] [get_bd_pins RF_INTERFACE/txnrx]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins GM_Simple_Timer_0/aclk] [get_bd_pins NSD_ABS_DATA_SINK_0/aclk] [get_bd_pins NSD_ABS_DATA_SINK_1/aclk] [get_bd_pins NSD_ABS_DATA_SINK_2/aclk] [get_bd_pins NSD_BCAST_DATA_SINK_0/aclk] [get_bd_pins NSD_BCAST_DATA_SINK_1/aclk] [get_bd_pins NSD_BCAST_DATA_SINK_2/aclk] [get_bd_pins NSD_CORDIC_DATA_SINK/aclk] [get_bd_pins NSD_DTA_DATA_SINK/aclk] [get_bd_pins NSD_FFT_DATA_SINK/clkb] [get_bd_pins NSD_PRS_DATA_SINK/aclk] [get_bd_pins NULL_SYMBOL_DET/aclk] [get_bd_pins RF_CHANNEL_EMULATOR/aclk] [get_bd_pins RF_INTERFACE/s_axis_aclk] [get_bd_pins TIME_DOMAIN_DATA_SINK/aclk] [get_bd_pins TRAINING_SYMB_INJECTOR/clka] [get_bd_pins TX_DATA_FFT/aclk] [get_bd_pins TX_DATA_SOURCE/s00_axi_aclk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/M06_ACLK] [get_bd_pins processing_system7_0_axi_periph/M07_ACLK] [get_bd_pins processing_system7_0_axi_periph/M08_ACLK] [get_bd_pins processing_system7_0_axi_periph/M09_ACLK] [get_bd_pins processing_system7_0_axi_periph/M10_ACLK] [get_bd_pins processing_system7_0_axi_periph/M11_ACLK] [get_bd_pins processing_system7_0_axi_periph/M12_ACLK] [get_bd_pins processing_system7_0_axi_periph/M13_ACLK] [get_bd_pins processing_system7_0_axi_periph/M14_ACLK] [get_bd_pins processing_system7_0_axi_periph/M15_ACLK] [get_bd_pins processing_system7_0_axi_periph/M16_ACLK] [get_bd_pins processing_system7_0_axi_periph/M17_ACLK] [get_bd_pins processing_system7_0_axi_periph/M18_ACLK] [get_bd_pins processing_system7_0_axi_periph/M19_ACLK] [get_bd_pins processing_system7_0_axi_periph/M20_ACLK] [get_bd_pins processing_system7_0_axi_periph/M21_ACLK] [get_bd_pins processing_system7_0_axi_periph/M22_ACLK] [get_bd_pins processing_system7_0_axi_periph/M23_ACLK] [get_bd_pins processing_system7_0_axi_periph/M24_ACLK] [get_bd_pins processing_system7_0_axi_periph/M25_ACLK] [get_bd_pins processing_system7_0_axi_periph/M26_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_50M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins RF_INTERFACE/delay_clk] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_50M/ext_reset_in]
  connect_bd_net -net processing_system7_0_GPIO_O [get_bd_pins RF_INTERFACE/GPIO_O] [get_bd_pins processing_system7_0/GPIO_O]
  connect_bd_net -net processing_system7_0_GPIO_T [get_bd_pins RF_INTERFACE/GPIO_T] [get_bd_pins processing_system7_0/GPIO_T]
  connect_bd_net -net processing_system7_0_SPI0_MOSI_O [get_bd_ports spi_mosi] [get_bd_pins processing_system7_0/SPI0_MOSI_O]
  connect_bd_net -net processing_system7_0_SPI0_SCLK_O [get_bd_ports spi_clk] [get_bd_pins processing_system7_0/SPI0_SCLK_O]
  connect_bd_net -net processing_system7_0_SPI0_SS_O [get_bd_ports spi_csn] [get_bd_pins processing_system7_0/SPI0_SS_O]
  connect_bd_net -net rst_processing_system7_0_50M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_50M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins GM_Simple_Timer_0/aresetn] [get_bd_pins NSD_ABS_DATA_SINK_0/aresetn] [get_bd_pins NSD_ABS_DATA_SINK_1/aresetn] [get_bd_pins NSD_ABS_DATA_SINK_2/aresetn] [get_bd_pins NSD_BCAST_DATA_SINK_0/aresetn] [get_bd_pins NSD_BCAST_DATA_SINK_1/aresetn] [get_bd_pins NSD_BCAST_DATA_SINK_2/aresetn] [get_bd_pins NSD_CORDIC_DATA_SINK/aresetn] [get_bd_pins NSD_DTA_DATA_SINK/aresetn] [get_bd_pins NSD_FFT_DATA_SINK/aresetn] [get_bd_pins NSD_PRS_DATA_SINK/aresetn] [get_bd_pins NULL_SYMBOL_DET/aresetn] [get_bd_pins RF_CHANNEL_EMULATOR/aresetn] [get_bd_pins RF_INTERFACE/s00_axi_aresetn] [get_bd_pins TIME_DOMAIN_DATA_SINK/aresetn] [get_bd_pins TRAINING_SYMB_INJECTOR/aresetn] [get_bd_pins TX_DATA_FFT/aresetn] [get_bd_pins TX_DATA_SOURCE/s00_axi_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M06_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M07_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M08_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M09_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M10_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M11_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M12_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M13_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M14_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M15_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M16_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M17_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M18_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M19_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M20_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M21_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M22_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M23_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M24_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M25_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M26_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_50M/peripheral_aresetn]
  connect_bd_net -net rx_clk_in_n_1 [get_bd_ports rx_clk_in_n] [get_bd_pins RF_INTERFACE/rx_clk_in_n]
  connect_bd_net -net rx_clk_in_p_1 [get_bd_ports rx_clk_in_p] [get_bd_pins RF_INTERFACE/rx_clk_in_p]
  connect_bd_net -net rx_data_in_n_1 [get_bd_ports rx_data_in_n] [get_bd_pins RF_INTERFACE/rx_data_in_n]
  connect_bd_net -net rx_data_in_p_1 [get_bd_ports rx_data_in_p] [get_bd_pins RF_INTERFACE/rx_data_in_p]
  connect_bd_net -net rx_frame_in_n_1 [get_bd_ports rx_frame_in_n] [get_bd_pins RF_INTERFACE/rx_frame_in_n]
  connect_bd_net -net rx_frame_in_p_1 [get_bd_ports rx_frame_in_p] [get_bd_pins RF_INTERFACE/rx_frame_in_p]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_2_dout1 [get_bd_pins processing_system7_0/SPI0_SS_I] [get_bd_pins xlconstant_2/dout]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43D20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NSD_CORDIC_DATA_SINK/AXI4_Stream_Data_Sink_0/S00_AXI/S00_AXI_reg] SEG_AXI4_Stream_Data_Sink_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43D30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NSD_FFT_DATA_SINK/AXI4_Stream_Data_Sink_1/S00_AXI/S00_AXI_reg] SEG_AXI4_Stream_Data_Sink_1_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TX_DATA_SOURCE/AXI4_Stream_Data_Source/S00_AXI/S00_AXI_reg] SEG_AXI4_Stream_Data_Source_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43D50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NSD_ABS_DATA_SINK_1/DATA_SINK/S00_AXI/S00_AXI_reg] SEG_DATA_SINK_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43D60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NSD_ABS_DATA_SINK_2/DATA_SINK/S00_AXI/S00_AXI_reg] SEG_DATA_SINK_S00_AXI_reg1
  create_bd_addr_seg -range 0x10000 -offset 0x43D40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NSD_BCAST_DATA_SINK_0/DATA_SINK/S00_AXI/S00_AXI_reg] SEG_DATA_SINK_S00_AXI_reg2
  create_bd_addr_seg -range 0x10000 -offset 0x43D70000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NSD_BCAST_DATA_SINK_1/DATA_SINK/S00_AXI/S00_AXI_reg] SEG_DATA_SINK_S00_AXI_reg3
  create_bd_addr_seg -range 0x10000 -offset 0x43D80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NSD_BCAST_DATA_SINK_2/DATA_SINK/S00_AXI/S00_AXI_reg] SEG_DATA_SINK_S00_AXI_reg4
  create_bd_addr_seg -range 0x10000 -offset 0x43CA0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs RF_CHANNEL_EMULATOR/Emul_Clk_Freq_Ctr/S00_AXI/S00_AXI_reg] SEG_Emul_Clk_Freq_Ctr_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C90000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs RF_CHANNEL_EMULATOR/Emul_Clk_Gen/s_axi_lite/Reg] SEG_Emul_Clk_Gen_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C60000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TX_DATA_FFT/FFT_Controller_0/S00_AXI/S00_AXI_reg] SEG_FFT_Controller_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43CD0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NULL_SYMBOL_DET/NSD_MOVING_MAG_SQUARED/FFT_Controller_0/S00_AXI/S00_AXI_reg] SEG_FFT_Controller_0_S00_AXI_reg1
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TX_DATA_SOURCE/GM_AXI_BRAM_Controller_0/S00_AXI/S00_AXI_reg] SEG_GM_AXI_BRAM_Controller_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs GM_Simple_Timer_0/S00_AXI/S00_AXI_reg] SEG_GM_Simple_Timer_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43CC0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NULL_SYMBOL_DET/NULL_SYMBOL_DETECTOR_0/S00_AXI/S00_AXI_reg] SEG_NULL_SYMBOL_DETECTOR_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C80000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs RF_CHANNEL_EMULATOR/RF_CHAN_EMULATOR/S00_AXI/S00_AXI_reg] SEG_RF_CHAN_EMULATOR_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43D90000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NSD_PRS_DATA_SINK/RX_RAW_DATA_SINK/S00_AXI/S00_AXI_reg] SEG_RX_RAW_DATA_SINK_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43CE0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TIME_DOMAIN_DATA_SINK/RX_RAW_DATA_SINK/S00_AXI/S00_AXI_reg] SEG_RX_RAW_DATA_SINK_S00_AXI_reg1
  create_bd_addr_seg -range 0x10000 -offset 0x43CF0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NSD_DTA_DATA_SINK/RX_RAW_DATA_SINK/S00_AXI/S00_AXI_reg] SEG_RX_RAW_DATA_SINK_S00_AXI_reg2
  create_bd_addr_seg -range 0x10000 -offset 0x43D00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs NSD_ABS_DATA_SINK_0/DATA_SINK/S00_AXI/S00_AXI_reg] SEG_RX_RAW_DATA_SINK_S00_AXI_reg3
  create_bd_addr_seg -range 0x10000 -offset 0x43C70000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs TRAINING_SYMB_INJECTOR/Training_Symbol_Injector_0/S00_AXI/S00_AXI_reg] SEG_Training_Symbol_Injector_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43CB0000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs RF_CHANNEL_EMULATOR/Tx_Rx_Emulator_Switch/S00_AXI/S00_AXI_reg] SEG_Tx_Rx_Emulator_Switch_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C30000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs RF_INTERFACE/ad9364_clk_frq_ctr/S00_AXI/S00_AXI_reg] SEG_ad9364_clk_frq_ctr_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43D10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs RF_INTERFACE/ad9364_adc_frq_ctr/S00_AXI/S00_AXI_reg] SEG_ad9364_dac_frq_ctr1_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C40000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs RF_INTERFACE/ad9364_dac_frq_ctr/S00_AXI/S00_AXI_reg] SEG_ad9364_dac_frq_ctr_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C50000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs RF_INTERFACE/axi_ad9361_0/s_axi/axi_lite] SEG_axi_ad9361_0_axi_lite
  create_bd_addr_seg -range 0x2000 -offset 0x40000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   commentid: "",
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port gpio_resetb -pg 1 -y 2100 -defaultsOSRD
preplace port gpio_en_agc -pg 1 -y 2060 -defaultsOSRD
preplace port enable -pg 1 -y 1960 -defaultsOSRD
preplace port rx_clk_in_p -pg 1 -y 1780 -defaultsOSRD -right
preplace port DDR -pg 1 -y 1660 -defaultsOSRD
preplace port rx_frame_in_n -pg 1 -y 2160 -defaultsOSRD -right
preplace port tx_frame_out_n -pg 1 -y 1900 -defaultsOSRD
preplace port tx_clk_out_n -pg 1 -y 1860 -defaultsOSRD
preplace port rx_frame_in_p -pg 1 -y 1820 -defaultsOSRD -right
preplace port tx_frame_out_p -pg 1 -y 1880 -defaultsOSRD
preplace port gpio_sync -pg 1 -y 2080 -defaultsOSRD
preplace port tx_clk_out_p -pg 1 -y 1840 -defaultsOSRD
preplace port spi_clk -pg 1 -y 1700 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 1680 -defaultsOSRD
preplace port spi_miso -pg 1 -y 1740 -defaultsOSRD -right
preplace port spi_csn -pg 1 -y 1760 -defaultsOSRD
preplace port spi_mosi -pg 1 -y 1720 -defaultsOSRD
preplace port rx_clk_in_n -pg 1 -y 1800 -defaultsOSRD -right
preplace port txnrx -pg 1 -y 1980 -defaultsOSRD
preplace portBus rx_data_in_p -pg 1 -y 2180 -defaultsOSRD -right
preplace portBus gpio_status -pg 1 -y 2020 -defaultsOSRD
preplace portBus gpio_ctl -pg 1 -y 2040 -defaultsOSRD
preplace portBus tx_data_out_n -pg 1 -y 1940 -defaultsOSRD
preplace portBus tx_data_out_p -pg 1 -y 1920 -defaultsOSRD
preplace portBus rx_data_in_n -pg 1 -y 2200 -defaultsOSRD -right
preplace inst NSD_PRS_DATA_SINK -pg 1 -lvl 10 -y 980 -defaultsOSRD -resize 140 136
preplace inst NSD_BCAST_DATA_SINK_0 -pg 1 -lvl 10 -y 530 -defaultsOSRD -resize 140 136
preplace inst TIME_DOMAIN_DATA_SINK -pg 1 -lvl 10 -y 1580 -defaultsOSRD -resize 140 136
preplace inst NSD_BCAST_DATA_SINK_1 -pg 1 -lvl 10 -y 680 -defaultsOSRD -resize 140 136
preplace inst NSD_BCAST_DATA_SINK_2 -pg 1 -lvl 10 -y 830 -defaultsOSRD -resize 140 136
preplace inst NSD_CORDIC_DATA_SINK -pg 1 -lvl 10 -y 1430 -defaultsOSRD
preplace inst xlconstant_2 -pg 1 -lvl 4 -y 1760 -defaultsOSRD -orient R180
preplace inst RF_INTERFACE -pg 1 -lvl 8 -y 1960 -defaultsOSRD
preplace inst NSD_ABS_DATA_SINK_0 -pg 1 -lvl 10 -y 80 -defaultsOSRD -resize 140 136
preplace inst xlconcat_0 -pg 1 -lvl 2 -y 1850 -defaultsOSRD
preplace inst NSD_ABS_DATA_SINK_1 -pg 1 -lvl 10 -y 230 -defaultsOSRD -resize 140 136
preplace inst NSD_FFT_DATA_SINK -pg 1 -lvl 10 -y 1280 -defaultsOSRD
preplace inst NULL_SYMBOL_DET -pg 1 -lvl 9 -y 1220 -defaultsOSRD
preplace inst TRAINING_SYMB_INJECTOR -pg 1 -lvl 7 -y 1240 -defaultsOSRD
preplace inst blk_mem_gen_0 -pg 1 -lvl 6 -y 1580 -defaultsOSRD
preplace inst rst_processing_system7_0_50M -pg 1 -lvl 3 -y 1410 -defaultsOSRD
preplace inst NSD_ABS_DATA_SINK_2 -pg 1 -lvl 10 -y 380 -defaultsOSRD -resize 140 136
preplace inst TX_DATA_SOURCE -pg 1 -lvl 5 -y 1350 -defaultsOSRD
preplace inst GM_Simple_Timer_0 -pg 1 -lvl 5 -y 1180 -defaultsOSRD
preplace inst TX_DATA_FFT -pg 1 -lvl 6 -y 1230 -defaultsOSRD
preplace inst RF_CHANNEL_EMULATOR -pg 1 -lvl 8 -y 1200 -defaultsOSRD
preplace inst NSD_DTA_DATA_SINK -pg 1 -lvl 10 -y 1130 -defaultsOSRD -resize 140 136
preplace inst axi_bram_ctrl_0 -pg 1 -lvl 5 -y 1580 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 4 -y 980 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 3 -y 1710 -defaultsOSRD
preplace netloc axi_ad9361_0_tx_frame_out_n 1 8 3 NJ 1900 NJ 1900 NJ
preplace netloc axi_ad9361_0_tx_frame_out_p 1 8 3 NJ 1880 NJ 1880 NJ
preplace netloc processing_system7_0_GPIO_T 1 3 5 NJ 2110 NJ 2110 NJ 2110 NJ 2110 N
preplace netloc processing_system7_0_axi_periph_M08_AXI 1 4 3 NJ 880 NJ 880 1920
preplace netloc processing_system7_0_FIXED_IO 1 3 8 NJ 1680 NJ 1680 NJ 1680 NJ 1680 NJ 1680 NJ 1680 NJ 1680 NJ
preplace netloc processing_system7_0_axi_periph_M17_AXI 1 4 6 1180 50 NJ 50 NJ 50 NJ 50 NJ 50 NJ
preplace netloc processing_system7_0_axi_periph_M26_AXI 1 4 6 NJ 960 NJ 960 NJ 960 NJ 950 NJ 950 N
preplace netloc processing_system7_0_axi_periph_M24_AXI 1 4 6 1250 650 NJ 650 NJ 650 NJ 650 NJ 650 NJ
preplace netloc xlconcat_0_dout 1 2 1 400
preplace netloc processing_system7_0_axi_periph_M18_AXI 1 4 4 NJ 1070 NJ 1070 NJ 1070 2200
preplace netloc rx_frame_in_n_1 1 7 4 2310 2160 NJ 2160 NJ 2160 NJ
preplace netloc NULL_SYMBOL_DET_M_AXIS_DATA 1 9 1 3060
preplace netloc processing_system7_0_axi_periph_M16_AXI 1 4 6 NJ 1040 NJ 1040 NJ 1040 NJ 1040 NJ 1040 3150
preplace netloc processing_system7_0_axi_periph_M06_AXI 1 4 4 NJ 840 NJ 840 NJ 840 2270
preplace netloc processing_system7_0_DDR 1 3 8 NJ 1670 NJ 1670 NJ 1670 NJ 1670 NJ 1670 NJ 1670 NJ 1670 NJ
preplace netloc X_IOBUF_0_GPIO_I 1 3 6 NJ 1620 NJ 1510 NJ 1510 NJ 1510 NJ 1510 2670
preplace netloc GM_Simple_Timer_0_irq 1 1 5 NJ 1920 NJ 1920 NJ 1920 NJ 1920 1630
preplace netloc NULL_SYMBOL_DET_M15_AXIS_BCAST 1 9 1 3020
preplace netloc S_AXIS_1 1 9 1 3010
preplace netloc rx_clk_in_p_1 1 7 4 2330 1740 NJ 1740 NJ 1740 NJ
preplace netloc S_AXIS_2 1 8 2 2690 1570 NJ
preplace netloc processing_system7_0_axi_periph_M05_AXI 1 4 4 NJ 820 NJ 820 NJ 820 2240
preplace netloc rst_processing_system7_0_50M_interconnect_aresetn 1 3 1 780
preplace netloc rx_clk_in_n_1 1 7 4 2300 1730 NJ 1730 NJ 1730 NJ
preplace netloc processing_system7_0_axi_periph_M21_AXI 1 4 6 1210 500 NJ 500 NJ 500 NJ 500 NJ 500 NJ
preplace netloc processing_system7_0_axi_periph_M20_AXI 1 4 6 NJ 1110 NJ 1110 NJ 1110 NJ 1360 NJ 1360 3150
preplace netloc processing_system7_0_FCLK_RESET0_N 1 2 2 400 1500 780
preplace netloc NULL_SYMBOL_DET_M_AXIS_PRS 1 9 1 3040
preplace netloc axi_ad9361_0_tx_data_out_n 1 8 3 NJ 1940 NJ 1940 NJ
preplace netloc xfft_0_M_AXIS_DATA 1 6 1 N
preplace netloc NULL_SYMBOL_DET_M_AXIS_FFT 1 9 1 3100
preplace netloc processing_system7_0_axi_periph_M10_AXI 1 4 4 NJ 920 NJ 920 NJ 920 2310
preplace netloc processing_system7_0_axi_periph_M02_AXI 1 4 1 1240
preplace netloc axi_bram_ctrl_0_BRAM_PORTA 1 5 1 NJ
preplace netloc processing_system7_0_axi_periph_M03_AXI 1 4 1 1270
preplace netloc axi_ad9361_0_txnrx 1 8 3 NJ 1980 NJ 1980 NJ
preplace netloc processing_system7_0_SPI0_SS_O 1 3 8 NJ 1710 NJ 1710 NJ 1710 NJ 1710 NJ 1710 NJ 1710 NJ 1710 NJ
preplace netloc processing_system7_0_axi_periph_M07_AXI 1 4 2 NJ 860 1660
preplace netloc axi_ad9361_0_tx_data_out_p 1 8 3 NJ 1920 NJ 1920 NJ
preplace netloc processing_system7_0_axi_periph_M09_AXI 1 4 4 NJ 900 NJ 900 NJ 900 2330
preplace netloc AXI4_Stream_Data_Source_irq 1 1 5 NJ 1310 NJ 1310 NJ 1650 NJ 1650 1620
preplace netloc processing_system7_0_axi_periph_M11_AXI 1 4 4 NJ 930 NJ 930 NJ 930 2260
preplace netloc processing_system7_0_axi_periph_M13_AXI 1 4 5 NJ 980 NJ 980 NJ 980 NJ 980 2710
preplace netloc AXI4_Stream_Data_Source_M00_AXIS 1 5 1 1640
preplace netloc processing_system7_0_axi_periph_M22_AXI 1 4 6 1200 200 NJ 200 NJ 200 NJ 200 NJ 200 NJ
preplace netloc processing_system7_0_axi_periph_M19_AXI 1 4 6 NJ 1080 NJ 1080 NJ 1080 NJ 1070 NJ 1070 3090
preplace netloc processing_system7_0_SPI0_MOSI_O 1 3 8 NJ 1690 NJ 1690 NJ 1690 NJ 1690 NJ 1690 NJ 1690 NJ 1690 NJ
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 4 1 1280
preplace netloc xlconstant_2_dout1 1 3 1 NJ
preplace netloc S_AXIS_DATA_1 1 8 1 2690
preplace netloc processing_system7_0_axi_periph_M12_AXI 1 4 4 NJ 950 NJ 950 NJ 950 2220
preplace netloc S_AXIS_DATA_2 1 9 1 3030
preplace netloc Net 1 8 3 NJ 2020 NJ 2020 NJ
preplace netloc SPI0_MISO_I_1 1 3 8 NJ 1660 NJ 1660 NJ 1660 NJ 1660 NJ 1660 NJ 1660 NJ 1660 NJ
preplace netloc processing_system7_0_axi_periph_M25_AXI 1 4 6 1310 800 NJ 800 NJ 800 NJ 800 NJ 800 NJ
preplace netloc S_AXIS_DATA_3 1 9 1 3050
preplace netloc NULL_SYMBOL_DET_M_AXIS_CORDIC 1 9 1 3070
preplace netloc Net1 1 8 3 NJ 2040 NJ 2040 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 2 8 390 1320 850 1640 1340 1250 1660 1320 1920 1330 2280 1340 2710 1370 3130
preplace netloc Net2 1 8 3 NJ 2060 NJ 2060 NJ
preplace netloc processing_system7_0_FCLK_CLK1 1 3 5 NJ 1850 NJ 1850 NJ 1850 NJ 1850 2210
preplace netloc Net3 1 8 3 NJ 2080 NJ 2080 NJ
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 4 1 1290
preplace netloc Net4 1 8 3 NJ 2100 NJ 2100 NJ
preplace netloc rx_frame_in_p_1 1 7 4 2320 1750 NJ 1750 NJ 1750 NJ
preplace netloc processing_system7_0_SPI0_SCLK_O 1 3 8 NJ 1700 NJ 1700 NJ 1700 NJ 1700 NJ 1700 NJ 1700 NJ 1700 NJ
preplace netloc rst_processing_system7_0_50M_peripheral_aresetn 1 3 7 880 1630 1350 1260 1650 1310 1930 1320 2290 1370 2700 1380 3140
preplace netloc axi_ad9361_0_tx_clk_out_n 1 8 3 NJ 1860 NJ 1860 NJ
preplace netloc processing_system7_0_axi_periph_M14_AXI 1 4 5 NJ 1000 NJ 1000 NJ 1000 NJ 1000 2700
preplace netloc RF_CHANNEL_EMULATOR_M_AXIS_DEVICE_IN 1 7 2 2310 1320 2680
preplace netloc rx_data_in_n_1 1 7 4 2330 2200 NJ 2200 NJ 2200 NJ
preplace netloc axi_ad9361_0_tx_clk_out_p 1 8 3 NJ 1840 NJ 1840 NJ
preplace netloc NULL_SYMBOL_DET_M01_AXIS_BCAST 1 9 1 3120
preplace netloc processing_system7_0_M_AXI_GP0 1 3 1 830
preplace netloc axi_ad9361_0_enable 1 8 3 NJ 1960 NJ 1960 NJ
preplace netloc TRAINING_SYMB_INJECTOR_M_AXIS_DATA 1 7 1 N
preplace netloc TRAINING_SYMB_INJECTOR_irq 1 1 7 NJ 1930 NJ 1930 NJ 1930 NJ 1930 NJ 1930 NJ 1930 2190
preplace netloc processing_system7_0_GPIO_O 1 3 5 NJ 2090 NJ 2090 NJ 2090 NJ 2090 N
preplace netloc processing_system7_0_axi_periph_M23_AXI 1 4 6 1230 350 NJ 350 NJ 350 NJ 350 NJ 350 NJ
preplace netloc processing_system7_0_axi_periph_M04_AXI 1 4 4 NJ 790 NJ 790 NJ 790 2250
preplace netloc Rx_FIFO_M_AXIS 1 7 2 2300 1330 2680
preplace netloc rx_data_in_p_1 1 7 4 2320 2180 NJ 2180 NJ 2180 NJ
preplace netloc processing_system7_0_axi_periph_M15_AXI 1 4 6 NJ 1020 NJ 1020 NJ 1020 NJ 1020 NJ 1020 3110
preplace netloc NULL_SYMBOL_DET_M00_AXIS_BCAST 1 9 1 3080
levelinfo -pg 1 0 100 300 590 1030 1490 1790 2060 2500 2860 3260 3450 -top 0 -bot 2220
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


