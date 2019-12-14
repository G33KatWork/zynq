
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:processing_system7:5.5\
andy:andy:mt9v034_deserializer_clock_infrastructure:1.0\
andy:andy:mt9v034_deserializer_unit:1.0\
xilinx.com:ip:axi_iic:2.0\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:ip:v_vid_in_axi4s:4.0\
xilinx.com:ip:util_vector_logic:2.0\
andy:andy:motor_pwm_output:1.0\
xilinx.com:ip:axis_combiner:1.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: cam4
proc create_hier_cell_cam4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cam4() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Monitor -vlnv andy:andy:MT9V034DeserializerClocks_rtl:1.0 DeserializerUnitClocks

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_VDMA


  # Create pins
  create_bd_pin -dir I STEREO_CAM_n
  create_bd_pin -dir I STEREO_CAM_p
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir O -type intr int_vdma
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: cam_stereo_combiner, and set properties
  set cam_stereo_combiner [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_combiner:1.1 cam_stereo_combiner ]
  set_property -dict [ list \
   CONFIG.HAS_TLAST {1} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TUSER_WIDTH {1} \
 ] $cam_stereo_combiner

  # Create instance: cam_stereo_deserializer, and set properties
  set cam_stereo_deserializer [ create_bd_cell -type ip -vlnv andy:andy:mt9v034_deserializer_unit:1.0 cam_stereo_deserializer ]
  set_property -dict [ list \
   CONFIG.GUI_STEREO_MODE {true} \
   CONFIG.GUI_USE_EMBEDDED_SYNCS {false} \
   CONFIG.IDELAYCTRL_REFCLK {300} \
   CONFIG.IOSTANDARD {LVDS} \
   CONFIG.STEREO_MODE {true} \
   CONFIG.USE_EMBEDDED_SYNCS {true} \
 ] $cam_stereo_deserializer

  # Create instance: cam_stereo_vdma, and set properties
  set cam_stereo_vdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 cam_stereo_vdma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_num_fstores {1} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {128} \
 ] $cam_stereo_vdma

  # Create instance: cam_stereo_vid_in1, and set properties
  set cam_stereo_vid_in1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 cam_stereo_vid_in1 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {5} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {8} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
   CONFIG.C_NATIVE_COMPONENT_WIDTH {8} \
 ] $cam_stereo_vid_in1

  # Create instance: cam_stereo_vid_in2, and set properties
  set cam_stereo_vid_in2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 cam_stereo_vid_in2 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {5} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {8} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
   CONFIG.C_NATIVE_COMPONENT_WIDTH {8} \
 ] $cam_stereo_vid_in2

  # Create instance: cam_stereo_vid_in_reset, and set properties
  set cam_stereo_vid_in_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 cam_stereo_vid_in_reset ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $cam_stereo_vid_in_reset

  # Create instance: vcc, and set properties
  set vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins cam_stereo_vdma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE_VDMA] [get_bd_intf_pins cam_stereo_vdma/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins DeserializerUnitClocks] [get_bd_intf_pins cam_stereo_deserializer/DeserializerUnitClocks]
  connect_bd_intf_net -intf_net cam_stereo_combiner1_M_AXIS [get_bd_intf_pins cam_stereo_combiner/M_AXIS] [get_bd_intf_pins cam_stereo_vdma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net cam_stereo_deserializer1_VideoOut [get_bd_intf_pins cam_stereo_deserializer/VideoOut] [get_bd_intf_pins cam_stereo_vid_in1/vid_io_in]
  connect_bd_intf_net -intf_net cam_stereo_deserializer1_VideoOut2 [get_bd_intf_pins cam_stereo_deserializer/VideoOut2] [get_bd_intf_pins cam_stereo_vid_in2/vid_io_in]
  connect_bd_intf_net -intf_net cam_stereo_vid_in1_1_video_out [get_bd_intf_pins cam_stereo_combiner/S00_AXIS] [get_bd_intf_pins cam_stereo_vid_in1/video_out]
  connect_bd_intf_net -intf_net cam_stereo_vid_in1_2_video_out [get_bd_intf_pins cam_stereo_combiner/S01_AXIS] [get_bd_intf_pins cam_stereo_vid_in2/video_out]

  # Create port connections
  connect_bd_net -net STEREO_CAM1_n_1 [get_bd_pins STEREO_CAM_n] [get_bd_pins cam_stereo_deserializer/cam_n]
  connect_bd_net -net STEREO_CAM1_p_1 [get_bd_pins STEREO_CAM_p] [get_bd_pins cam_stereo_deserializer/cam_p]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins cam_stereo_combiner/aclk] [get_bd_pins cam_stereo_vdma/m_axi_s2mm_aclk] [get_bd_pins cam_stereo_vdma/s_axis_s2mm_aclk] [get_bd_pins cam_stereo_vid_in1/aclk] [get_bd_pins cam_stereo_vid_in2/aclk]
  connect_bd_net -net cam_single_deserializer1_pixel_data_valid [get_bd_pins cam_stereo_deserializer/pixel_data_valid] [get_bd_pins cam_stereo_vid_in1/vid_io_in_ce] [get_bd_pins cam_stereo_vid_in2/vid_io_in_ce]
  connect_bd_net -net cam_single_deserializer1_pxclk [get_bd_pins cam_stereo_deserializer/pxclk] [get_bd_pins cam_stereo_vid_in1/vid_io_in_clk] [get_bd_pins cam_stereo_vid_in2/vid_io_in_clk]
  connect_bd_net -net cam_single_deserializer1_receiver_locked [get_bd_pins cam_stereo_deserializer/receiver_locked] [get_bd_pins cam_stereo_vid_in1/axis_enable] [get_bd_pins cam_stereo_vid_in2/axis_enable] [get_bd_pins cam_stereo_vid_in_reset/Op1]
  connect_bd_net -net cam_single_vid_in_reset1_Res [get_bd_pins cam_stereo_vid_in1/vid_io_in_reset] [get_bd_pins cam_stereo_vid_in2/vid_io_in_reset] [get_bd_pins cam_stereo_vid_in_reset/Res]
  connect_bd_net -net cam_stereo_vdma1_s2mm_introut [get_bd_pins int_vdma] [get_bd_pins cam_stereo_vdma/s2mm_introut]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins cam_stereo_vdma/s_axi_lite_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins cam_stereo_vdma/axi_resetn]
  connect_bd_net -net vcc_dout [get_bd_pins cam_stereo_combiner/aresetn] [get_bd_pins vcc/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cam3
proc create_hier_cell_cam3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cam3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Monitor -vlnv andy:andy:MT9V034DeserializerClocks_rtl:1.0 DeserializerUnitClocks

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_VDMA


  # Create pins
  create_bd_pin -dir I STEREO_CAM_n
  create_bd_pin -dir I STEREO_CAM_p
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir O -type intr int_vdma
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: cam_stereo_combiner, and set properties
  set cam_stereo_combiner [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_combiner:1.1 cam_stereo_combiner ]
  set_property -dict [ list \
   CONFIG.HAS_TLAST {1} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TUSER_WIDTH {1} \
 ] $cam_stereo_combiner

  # Create instance: cam_stereo_deserializer, and set properties
  set cam_stereo_deserializer [ create_bd_cell -type ip -vlnv andy:andy:mt9v034_deserializer_unit:1.0 cam_stereo_deserializer ]
  set_property -dict [ list \
   CONFIG.GUI_STEREO_MODE {true} \
   CONFIG.GUI_USE_EMBEDDED_SYNCS {false} \
   CONFIG.IDELAYCTRL_REFCLK {300} \
   CONFIG.IOSTANDARD {LVDS} \
   CONFIG.STEREO_MODE {true} \
   CONFIG.USE_EMBEDDED_SYNCS {true} \
 ] $cam_stereo_deserializer

  # Create instance: cam_stereo_vdma, and set properties
  set cam_stereo_vdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 cam_stereo_vdma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_num_fstores {1} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {128} \
 ] $cam_stereo_vdma

  # Create instance: cam_stereo_vid_in1, and set properties
  set cam_stereo_vid_in1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 cam_stereo_vid_in1 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {5} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {8} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
   CONFIG.C_NATIVE_COMPONENT_WIDTH {8} \
 ] $cam_stereo_vid_in1

  # Create instance: cam_stereo_vid_in2, and set properties
  set cam_stereo_vid_in2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 cam_stereo_vid_in2 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {5} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {8} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
   CONFIG.C_NATIVE_COMPONENT_WIDTH {8} \
 ] $cam_stereo_vid_in2

  # Create instance: cam_stereo_vid_in_reset, and set properties
  set cam_stereo_vid_in_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 cam_stereo_vid_in_reset ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $cam_stereo_vid_in_reset

  # Create instance: vcc, and set properties
  set vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins cam_stereo_vdma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE_VDMA] [get_bd_intf_pins cam_stereo_vdma/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins DeserializerUnitClocks] [get_bd_intf_pins cam_stereo_deserializer/DeserializerUnitClocks]
  connect_bd_intf_net -intf_net cam_stereo_combiner1_M_AXIS [get_bd_intf_pins cam_stereo_combiner/M_AXIS] [get_bd_intf_pins cam_stereo_vdma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net cam_stereo_deserializer1_VideoOut [get_bd_intf_pins cam_stereo_deserializer/VideoOut] [get_bd_intf_pins cam_stereo_vid_in1/vid_io_in]
  connect_bd_intf_net -intf_net cam_stereo_deserializer1_VideoOut2 [get_bd_intf_pins cam_stereo_deserializer/VideoOut2] [get_bd_intf_pins cam_stereo_vid_in2/vid_io_in]
  connect_bd_intf_net -intf_net cam_stereo_vid_in1_1_video_out [get_bd_intf_pins cam_stereo_combiner/S00_AXIS] [get_bd_intf_pins cam_stereo_vid_in1/video_out]
  connect_bd_intf_net -intf_net cam_stereo_vid_in1_2_video_out [get_bd_intf_pins cam_stereo_combiner/S01_AXIS] [get_bd_intf_pins cam_stereo_vid_in2/video_out]

  # Create port connections
  connect_bd_net -net STEREO_CAM1_n_1 [get_bd_pins STEREO_CAM_n] [get_bd_pins cam_stereo_deserializer/cam_n]
  connect_bd_net -net STEREO_CAM1_p_1 [get_bd_pins STEREO_CAM_p] [get_bd_pins cam_stereo_deserializer/cam_p]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins cam_stereo_combiner/aclk] [get_bd_pins cam_stereo_vdma/m_axi_s2mm_aclk] [get_bd_pins cam_stereo_vdma/s_axis_s2mm_aclk] [get_bd_pins cam_stereo_vid_in1/aclk] [get_bd_pins cam_stereo_vid_in2/aclk]
  connect_bd_net -net cam_single_deserializer1_pixel_data_valid [get_bd_pins cam_stereo_deserializer/pixel_data_valid] [get_bd_pins cam_stereo_vid_in1/vid_io_in_ce] [get_bd_pins cam_stereo_vid_in2/vid_io_in_ce]
  connect_bd_net -net cam_single_deserializer1_pxclk [get_bd_pins cam_stereo_deserializer/pxclk] [get_bd_pins cam_stereo_vid_in1/vid_io_in_clk] [get_bd_pins cam_stereo_vid_in2/vid_io_in_clk]
  connect_bd_net -net cam_single_deserializer1_receiver_locked [get_bd_pins cam_stereo_deserializer/receiver_locked] [get_bd_pins cam_stereo_vid_in1/axis_enable] [get_bd_pins cam_stereo_vid_in2/axis_enable] [get_bd_pins cam_stereo_vid_in_reset/Op1]
  connect_bd_net -net cam_single_vid_in_reset1_Res [get_bd_pins cam_stereo_vid_in1/vid_io_in_reset] [get_bd_pins cam_stereo_vid_in2/vid_io_in_reset] [get_bd_pins cam_stereo_vid_in_reset/Res]
  connect_bd_net -net cam_stereo_vdma1_s2mm_introut [get_bd_pins int_vdma] [get_bd_pins cam_stereo_vdma/s2mm_introut]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins cam_stereo_vdma/s_axi_lite_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins cam_stereo_vdma/axi_resetn]
  connect_bd_net -net vcc_dout [get_bd_pins cam_stereo_combiner/aresetn] [get_bd_pins vcc/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cam2
proc create_hier_cell_cam2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cam2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Monitor -vlnv andy:andy:MT9V034DeserializerClocks_rtl:1.0 DeserializerUnitClocks

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_VDMA


  # Create pins
  create_bd_pin -dir I STEREO_CAM_n
  create_bd_pin -dir I STEREO_CAM_p
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir O -type intr int_vdma
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: cam_stereo_combiner, and set properties
  set cam_stereo_combiner [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_combiner:1.1 cam_stereo_combiner ]
  set_property -dict [ list \
   CONFIG.HAS_TLAST {1} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TUSER_WIDTH {1} \
 ] $cam_stereo_combiner

  # Create instance: cam_stereo_deserializer, and set properties
  set cam_stereo_deserializer [ create_bd_cell -type ip -vlnv andy:andy:mt9v034_deserializer_unit:1.0 cam_stereo_deserializer ]
  set_property -dict [ list \
   CONFIG.GUI_STEREO_MODE {true} \
   CONFIG.GUI_USE_EMBEDDED_SYNCS {false} \
   CONFIG.IDELAYCTRL_REFCLK {300} \
   CONFIG.IOSTANDARD {LVDS} \
   CONFIG.STEREO_MODE {true} \
   CONFIG.USE_EMBEDDED_SYNCS {true} \
 ] $cam_stereo_deserializer

  # Create instance: cam_stereo_vdma, and set properties
  set cam_stereo_vdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 cam_stereo_vdma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_num_fstores {1} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {128} \
 ] $cam_stereo_vdma

  # Create instance: cam_stereo_vid_in1, and set properties
  set cam_stereo_vid_in1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 cam_stereo_vid_in1 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {5} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {8} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
   CONFIG.C_NATIVE_COMPONENT_WIDTH {8} \
 ] $cam_stereo_vid_in1

  # Create instance: cam_stereo_vid_in2, and set properties
  set cam_stereo_vid_in2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 cam_stereo_vid_in2 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {5} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {8} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
   CONFIG.C_NATIVE_COMPONENT_WIDTH {8} \
 ] $cam_stereo_vid_in2

  # Create instance: cam_stereo_vid_in_reset, and set properties
  set cam_stereo_vid_in_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 cam_stereo_vid_in_reset ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $cam_stereo_vid_in_reset

  # Create instance: vcc, and set properties
  set vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins cam_stereo_vdma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE_VDMA] [get_bd_intf_pins cam_stereo_vdma/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins DeserializerUnitClocks] [get_bd_intf_pins cam_stereo_deserializer/DeserializerUnitClocks]
  connect_bd_intf_net -intf_net cam_stereo_combiner1_M_AXIS [get_bd_intf_pins cam_stereo_combiner/M_AXIS] [get_bd_intf_pins cam_stereo_vdma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net cam_stereo_deserializer1_VideoOut [get_bd_intf_pins cam_stereo_deserializer/VideoOut] [get_bd_intf_pins cam_stereo_vid_in1/vid_io_in]
  connect_bd_intf_net -intf_net cam_stereo_deserializer1_VideoOut2 [get_bd_intf_pins cam_stereo_deserializer/VideoOut2] [get_bd_intf_pins cam_stereo_vid_in2/vid_io_in]
  connect_bd_intf_net -intf_net cam_stereo_vid_in1_1_video_out [get_bd_intf_pins cam_stereo_combiner/S00_AXIS] [get_bd_intf_pins cam_stereo_vid_in1/video_out]
  connect_bd_intf_net -intf_net cam_stereo_vid_in1_2_video_out [get_bd_intf_pins cam_stereo_combiner/S01_AXIS] [get_bd_intf_pins cam_stereo_vid_in2/video_out]

  # Create port connections
  connect_bd_net -net STEREO_CAM1_n_1 [get_bd_pins STEREO_CAM_n] [get_bd_pins cam_stereo_deserializer/cam_n]
  connect_bd_net -net STEREO_CAM1_p_1 [get_bd_pins STEREO_CAM_p] [get_bd_pins cam_stereo_deserializer/cam_p]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins cam_stereo_combiner/aclk] [get_bd_pins cam_stereo_vdma/m_axi_s2mm_aclk] [get_bd_pins cam_stereo_vdma/s_axis_s2mm_aclk] [get_bd_pins cam_stereo_vid_in1/aclk] [get_bd_pins cam_stereo_vid_in2/aclk]
  connect_bd_net -net cam_single_deserializer1_pixel_data_valid [get_bd_pins cam_stereo_deserializer/pixel_data_valid] [get_bd_pins cam_stereo_vid_in1/vid_io_in_ce] [get_bd_pins cam_stereo_vid_in2/vid_io_in_ce]
  connect_bd_net -net cam_single_deserializer1_pxclk [get_bd_pins cam_stereo_deserializer/pxclk] [get_bd_pins cam_stereo_vid_in1/vid_io_in_clk] [get_bd_pins cam_stereo_vid_in2/vid_io_in_clk]
  connect_bd_net -net cam_single_deserializer1_receiver_locked [get_bd_pins cam_stereo_deserializer/receiver_locked] [get_bd_pins cam_stereo_vid_in1/axis_enable] [get_bd_pins cam_stereo_vid_in2/axis_enable] [get_bd_pins cam_stereo_vid_in_reset/Op1]
  connect_bd_net -net cam_single_vid_in_reset1_Res [get_bd_pins cam_stereo_vid_in1/vid_io_in_reset] [get_bd_pins cam_stereo_vid_in2/vid_io_in_reset] [get_bd_pins cam_stereo_vid_in_reset/Res]
  connect_bd_net -net cam_stereo_vdma1_s2mm_introut [get_bd_pins int_vdma] [get_bd_pins cam_stereo_vdma/s2mm_introut]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins cam_stereo_vdma/s_axi_lite_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins cam_stereo_vdma/axi_resetn]
  connect_bd_net -net vcc_dout [get_bd_pins cam_stereo_combiner/aresetn] [get_bd_pins vcc/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cam1
proc create_hier_cell_cam1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cam1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Monitor -vlnv andy:andy:MT9V034DeserializerClocks_rtl:1.0 DeserializerUnitClocks

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_VDMA


  # Create pins
  create_bd_pin -dir I STEREO_CAM_n
  create_bd_pin -dir I STEREO_CAM_p
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir O -type intr int_vdma
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: cam_stereo_combiner, and set properties
  set cam_stereo_combiner [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_combiner:1.1 cam_stereo_combiner ]
  set_property -dict [ list \
   CONFIG.HAS_TLAST {1} \
   CONFIG.TDATA_NUM_BYTES {1} \
   CONFIG.TUSER_WIDTH {1} \
 ] $cam_stereo_combiner

  # Create instance: cam_stereo_deserializer, and set properties
  set cam_stereo_deserializer [ create_bd_cell -type ip -vlnv andy:andy:mt9v034_deserializer_unit:1.0 cam_stereo_deserializer ]
  set_property -dict [ list \
   CONFIG.GUI_STEREO_MODE {true} \
   CONFIG.GUI_USE_EMBEDDED_SYNCS {false} \
   CONFIG.IDELAYCTRL_REFCLK {300} \
   CONFIG.IOSTANDARD {LVDS} \
   CONFIG.STEREO_MODE {true} \
   CONFIG.USE_EMBEDDED_SYNCS {true} \
 ] $cam_stereo_deserializer

  # Create instance: cam_stereo_vdma, and set properties
  set cam_stereo_vdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 cam_stereo_vdma ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_num_fstores {1} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {128} \
 ] $cam_stereo_vdma

  # Create instance: cam_stereo_vid_in1, and set properties
  set cam_stereo_vid_in1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 cam_stereo_vid_in1 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {5} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {8} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
   CONFIG.C_NATIVE_COMPONENT_WIDTH {8} \
 ] $cam_stereo_vid_in1

  # Create instance: cam_stereo_vid_in2, and set properties
  set cam_stereo_vid_in2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 cam_stereo_vid_in2 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {5} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_DATA_WIDTH {8} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
   CONFIG.C_NATIVE_COMPONENT_WIDTH {8} \
 ] $cam_stereo_vid_in2

  # Create instance: cam_stereo_vid_in_reset, and set properties
  set cam_stereo_vid_in_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 cam_stereo_vid_in_reset ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $cam_stereo_vid_in_reset

  # Create instance: vcc, and set properties
  set vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins cam_stereo_vdma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE_VDMA] [get_bd_intf_pins cam_stereo_vdma/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins DeserializerUnitClocks] [get_bd_intf_pins cam_stereo_deserializer/DeserializerUnitClocks]
  connect_bd_intf_net -intf_net cam_stereo_combiner1_M_AXIS [get_bd_intf_pins cam_stereo_combiner/M_AXIS] [get_bd_intf_pins cam_stereo_vdma/S_AXIS_S2MM]
  connect_bd_intf_net -intf_net cam_stereo_deserializer1_VideoOut [get_bd_intf_pins cam_stereo_deserializer/VideoOut] [get_bd_intf_pins cam_stereo_vid_in1/vid_io_in]
  connect_bd_intf_net -intf_net cam_stereo_deserializer1_VideoOut2 [get_bd_intf_pins cam_stereo_deserializer/VideoOut2] [get_bd_intf_pins cam_stereo_vid_in2/vid_io_in]
  connect_bd_intf_net -intf_net cam_stereo_vid_in1_1_video_out [get_bd_intf_pins cam_stereo_combiner/S00_AXIS] [get_bd_intf_pins cam_stereo_vid_in1/video_out]
  connect_bd_intf_net -intf_net cam_stereo_vid_in1_2_video_out [get_bd_intf_pins cam_stereo_combiner/S01_AXIS] [get_bd_intf_pins cam_stereo_vid_in2/video_out]

  # Create port connections
  connect_bd_net -net STEREO_CAM1_n_1 [get_bd_pins STEREO_CAM_n] [get_bd_pins cam_stereo_deserializer/cam_n]
  connect_bd_net -net STEREO_CAM1_p_1 [get_bd_pins STEREO_CAM_p] [get_bd_pins cam_stereo_deserializer/cam_p]
  connect_bd_net -net aclk_1 [get_bd_pins aclk] [get_bd_pins cam_stereo_combiner/aclk] [get_bd_pins cam_stereo_vdma/m_axi_s2mm_aclk] [get_bd_pins cam_stereo_vdma/s_axis_s2mm_aclk] [get_bd_pins cam_stereo_vid_in1/aclk] [get_bd_pins cam_stereo_vid_in2/aclk]
  connect_bd_net -net cam_single_deserializer1_pixel_data_valid [get_bd_pins cam_stereo_deserializer/pixel_data_valid] [get_bd_pins cam_stereo_vid_in1/vid_io_in_ce] [get_bd_pins cam_stereo_vid_in2/vid_io_in_ce]
  connect_bd_net -net cam_single_deserializer1_pxclk [get_bd_pins cam_stereo_deserializer/pxclk] [get_bd_pins cam_stereo_vid_in1/vid_io_in_clk] [get_bd_pins cam_stereo_vid_in2/vid_io_in_clk]
  connect_bd_net -net cam_single_deserializer1_receiver_locked [get_bd_pins cam_stereo_deserializer/receiver_locked] [get_bd_pins cam_stereo_vid_in1/axis_enable] [get_bd_pins cam_stereo_vid_in2/axis_enable] [get_bd_pins cam_stereo_vid_in_reset/Op1]
  connect_bd_net -net cam_single_vid_in_reset1_Res [get_bd_pins cam_stereo_vid_in1/vid_io_in_reset] [get_bd_pins cam_stereo_vid_in2/vid_io_in_reset] [get_bd_pins cam_stereo_vid_in_reset/Res]
  connect_bd_net -net cam_stereo_vdma1_s2mm_introut [get_bd_pins int_vdma] [get_bd_pins cam_stereo_vdma/s2mm_introut]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins cam_stereo_vdma/s_axi_lite_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins cam_stereo_vdma/axi_resetn]
  connect_bd_net -net vcc_dout [get_bd_pins cam_stereo_combiner/aresetn] [get_bd_pins vcc/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: copter_peripherals
proc create_hier_cell_copter_peripherals { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_copter_peripherals() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI


  # Create pins
  create_bd_pin -dir O -from 5 -to 0 MOTOR_OUT_0
  create_bd_pin -dir I -type clk S_AXI_ACLK
  create_bd_pin -dir I -type rst S_AXI_ARESETN

  # Create instance: motor_pwm_output_0, and set properties
  set motor_pwm_output_0 [ create_bd_cell -type ip -vlnv andy:andy:motor_pwm_output:1.0 motor_pwm_output_0 ]
  set_property -dict [ list \
   CONFIG.NUMBER_OF_MOTORS {6} \
 ] $motor_pwm_output_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI] [get_bd_intf_pins motor_pwm_output_0/S_AXI]

  # Create port connections
  connect_bd_net -net S_AXI_ACLK_1 [get_bd_pins S_AXI_ACLK] [get_bd_pins motor_pwm_output_0/S_AXI_ACLK]
  connect_bd_net -net S_AXI_ARESETN_1 [get_bd_pins S_AXI_ARESETN] [get_bd_pins motor_pwm_output_0/S_AXI_ARESETN]
  connect_bd_net -net motor_pwm_output_0_MOTOR_OUT [get_bd_pins MOTOR_OUT_0] [get_bd_pins motor_pwm_output_0/MOTOR_OUT]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cams_stereo
proc create_hier_cell_cams_stereo { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cams_stereo() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_CAMS_STEREO

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_IIC

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_VDMA1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_VDMA2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_VDMA3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_VDMA4


  # Create pins
  create_bd_pin -dir I STEREO_CAM1_n
  create_bd_pin -dir I STEREO_CAM1_p
  create_bd_pin -dir I STEREO_CAM2_n
  create_bd_pin -dir I STEREO_CAM2_p
  create_bd_pin -dir I STEREO_CAM3_n
  create_bd_pin -dir I STEREO_CAM3_p
  create_bd_pin -dir I STEREO_CAM4_n
  create_bd_pin -dir I STEREO_CAM4_p
  create_bd_pin -dir I aclk
  create_bd_pin -dir O -type intr int_iic
  create_bd_pin -dir O -type intr int_vdma1
  create_bd_pin -dir O -type intr int_vdma2
  create_bd_pin -dir O -type intr int_vdma3
  create_bd_pin -dir O -type intr int_vdma4
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: cam1
  create_hier_cell_cam1 $hier_obj cam1

  # Create instance: cam2
  create_hier_cell_cam2 $hier_obj cam2

  # Create instance: cam3
  create_hier_cell_cam3 $hier_obj cam3

  # Create instance: cam4
  create_hier_cell_cam4 $hier_obj cam4

  # Create instance: cam_stereo_clk_infra, and set properties
  set cam_stereo_clk_infra [ create_bd_cell -type ip -vlnv andy:andy:mt9v034_deserializer_clock_infrastructure:1.0 cam_stereo_clk_infra ]
  set_property -dict [ list \
   CONFIG.C_BufioClk0Loc {BUFIO_X1Y11} \
   CONFIG.C_BufioClk90Loc {BUFIO_X1Y10} \
   CONFIG.C_ClkFboutMult {48.0} \
   CONFIG.C_ClkinPeriod {10.0} \
   CONFIG.C_Clkout0_Divide {3.2} \
   CONFIG.C_Clkout1_Divide {4} \
   CONFIG.C_Clkout2_Divide {4} \
   CONFIG.C_Clkout3_Divide {8} \
   CONFIG.C_Clkout4_Divide {4} \
   CONFIG.C_DivClkDivide {5} \
   CONFIG.C_IdlyCtrlLoc {IDELAYCTRL_X1Y2} \
   CONFIG.C_MmcmLoc {MMCME2_ADV_X1Y2} \
 ] $cam_stereo_clk_infra

  # Create instance: cam_stereo_iic, and set properties
  set cam_stereo_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 cam_stereo_iic ]
  set_property -dict [ list \
   CONFIG.C_SCL_INERTIAL_DELAY {5} \
   CONFIG.C_SDA_INERTIAL_DELAY {5} \
 ] $cam_stereo_iic

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE_IIC] [get_bd_intf_pins cam_stereo_iic/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins IIC_CAMS_STEREO] [get_bd_intf_pins cam_stereo_iic/IIC]
  connect_bd_intf_net -intf_net S_AXI_LITE_VDMA1_1 [get_bd_intf_pins S_AXI_LITE_VDMA1] [get_bd_intf_pins cam1/S_AXI_LITE_VDMA]
  connect_bd_intf_net -intf_net S_AXI_LITE_VDMA2_1 [get_bd_intf_pins S_AXI_LITE_VDMA2] [get_bd_intf_pins cam2/S_AXI_LITE_VDMA]
  connect_bd_intf_net -intf_net S_AXI_LITE_VDMA3_1 [get_bd_intf_pins S_AXI_LITE_VDMA3] [get_bd_intf_pins cam3/S_AXI_LITE_VDMA]
  connect_bd_intf_net -intf_net S_AXI_LITE_VDMA4_1 [get_bd_intf_pins S_AXI_LITE_VDMA4] [get_bd_intf_pins cam4/S_AXI_LITE_VDMA]
  connect_bd_intf_net -intf_net cam1_M_AXI_S2MM1 [get_bd_intf_pins M_AXI_S2MM1] [get_bd_intf_pins cam1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net cam2_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM2] [get_bd_intf_pins cam2/M_AXI_S2MM]
  connect_bd_intf_net -intf_net cam3_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM3] [get_bd_intf_pins cam3/M_AXI_S2MM]
  connect_bd_intf_net -intf_net cam4_M_AXI_S2MM [get_bd_intf_pins M_AXI_S2MM4] [get_bd_intf_pins cam4/M_AXI_S2MM]
  connect_bd_intf_net -intf_net mt9v034_deserializer_clock_infrastructure_0_DeserializerUnitClocks [get_bd_intf_pins cam1/DeserializerUnitClocks] [get_bd_intf_pins cam_stereo_clk_infra/DeserializerUnitClocks]
  connect_bd_intf_net -intf_net [get_bd_intf_nets mt9v034_deserializer_clock_infrastructure_0_DeserializerUnitClocks] [get_bd_intf_pins cam2/DeserializerUnitClocks] [get_bd_intf_pins cam_stereo_clk_infra/DeserializerUnitClocks]
  connect_bd_intf_net -intf_net [get_bd_intf_nets mt9v034_deserializer_clock_infrastructure_0_DeserializerUnitClocks] [get_bd_intf_pins cam4/DeserializerUnitClocks] [get_bd_intf_pins cam_stereo_clk_infra/DeserializerUnitClocks]
  connect_bd_intf_net -intf_net [get_bd_intf_nets mt9v034_deserializer_clock_infrastructure_0_DeserializerUnitClocks] [get_bd_intf_pins cam3/DeserializerUnitClocks] [get_bd_intf_pins cam_stereo_clk_infra/DeserializerUnitClocks]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins aclk] [get_bd_pins cam1/aclk] [get_bd_pins cam2/aclk] [get_bd_pins cam3/aclk] [get_bd_pins cam4/aclk]
  connect_bd_net -net STEREO_CAM1_n_1 [get_bd_pins STEREO_CAM1_n] [get_bd_pins cam1/STEREO_CAM_n]
  connect_bd_net -net STEREO_CAM1_p_1 [get_bd_pins STEREO_CAM1_p] [get_bd_pins cam1/STEREO_CAM_p]
  connect_bd_net -net STEREO_CAM2_n_1 [get_bd_pins STEREO_CAM2_n] [get_bd_pins cam2/STEREO_CAM_n]
  connect_bd_net -net STEREO_CAM2_p_1 [get_bd_pins STEREO_CAM2_p] [get_bd_pins cam2/STEREO_CAM_p]
  connect_bd_net -net STEREO_CAM3_n_1 [get_bd_pins STEREO_CAM3_n] [get_bd_pins cam3/STEREO_CAM_n]
  connect_bd_net -net STEREO_CAM3_p_1 [get_bd_pins STEREO_CAM3_p] [get_bd_pins cam3/STEREO_CAM_p]
  connect_bd_net -net STEREO_CAM4_n_1 [get_bd_pins STEREO_CAM4_n] [get_bd_pins cam4/STEREO_CAM_n]
  connect_bd_net -net STEREO_CAM4_p_1 [get_bd_pins STEREO_CAM4_p] [get_bd_pins cam4/STEREO_CAM_p]
  connect_bd_net -net cam1_int_vdma1 [get_bd_pins int_vdma1] [get_bd_pins cam1/int_vdma]
  connect_bd_net -net cam2_int_vdma [get_bd_pins int_vdma2] [get_bd_pins cam2/int_vdma]
  connect_bd_net -net cam3_int_vdma [get_bd_pins int_vdma3] [get_bd_pins cam3/int_vdma]
  connect_bd_net -net cam4_int_vdma [get_bd_pins int_vdma4] [get_bd_pins cam4/int_vdma]
  connect_bd_net -net cam_single_iic_iic2intc_irpt [get_bd_pins int_iic] [get_bd_pins cam_stereo_iic/iic2intc_irpt]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins cam1/s_axi_aclk] [get_bd_pins cam2/s_axi_aclk] [get_bd_pins cam3/s_axi_aclk] [get_bd_pins cam4/s_axi_aclk] [get_bd_pins cam_stereo_clk_infra/ClkIn] [get_bd_pins cam_stereo_iic/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins cam1/s_axi_aresetn] [get_bd_pins cam2/s_axi_aresetn] [get_bd_pins cam3/s_axi_aresetn] [get_bd_pins cam4/s_axi_aresetn] [get_bd_pins cam_stereo_iic/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: cams_single
proc create_hier_cell_cams_single { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_cams_single() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_CAMS_SINGLE

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_IIC

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_VDMA1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE_VDMA2


  # Create pins
  create_bd_pin -dir I SINGLE_CAM1_n
  create_bd_pin -dir I SINGLE_CAM1_p
  create_bd_pin -dir I SINGLE_CAM2_n
  create_bd_pin -dir I SINGLE_CAM2_p
  create_bd_pin -dir I aclk
  create_bd_pin -dir O -type intr int_iic
  create_bd_pin -dir O -type intr int_vdma1
  create_bd_pin -dir O -type intr int_vdma2
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir I -type rst s_axi_aresetn

  # Create instance: cam_single_clk_infra, and set properties
  set cam_single_clk_infra [ create_bd_cell -type ip -vlnv andy:andy:mt9v034_deserializer_clock_infrastructure:1.0 cam_single_clk_infra ]
  set_property -dict [ list \
   CONFIG.C_BufioClk0Loc {BUFIO_X1Y15} \
   CONFIG.C_BufioClk90Loc {BUFIO_X1Y14} \
   CONFIG.C_IdlyCtrlLoc {IDELAYCTRL_X1Y3} \
   CONFIG.C_MmcmLoc {MMCME2_ADV_X1Y3} \
 ] $cam_single_clk_infra

  # Create instance: cam_single_deserializer1, and set properties
  set cam_single_deserializer1 [ create_bd_cell -type ip -vlnv andy:andy:mt9v034_deserializer_unit:1.0 cam_single_deserializer1 ]
  set_property -dict [ list \
   CONFIG.GUI_USE_EMBEDDED_SYNCS {true} \
   CONFIG.IOSTANDARD {LVDS} \
   CONFIG.USE_EMBEDDED_SYNCS {true} \
 ] $cam_single_deserializer1

  # Create instance: cam_single_deserializer2, and set properties
  set cam_single_deserializer2 [ create_bd_cell -type ip -vlnv andy:andy:mt9v034_deserializer_unit:1.0 cam_single_deserializer2 ]
  set_property -dict [ list \
   CONFIG.GUI_USE_EMBEDDED_SYNCS {true} \
   CONFIG.IOSTANDARD {LVDS} \
   CONFIG.USE_EMBEDDED_SYNCS {true} \
 ] $cam_single_deserializer2

  # Create instance: cam_single_iic, and set properties
  set cam_single_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.0 cam_single_iic ]
  set_property -dict [ list \
   CONFIG.C_SCL_INERTIAL_DELAY {5} \
   CONFIG.C_SDA_INERTIAL_DELAY {5} \
 ] $cam_single_iic

  # Create instance: cam_single_vdma1, and set properties
  set cam_single_vdma1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 cam_single_vdma1 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_num_fstores {1} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {128} \
 ] $cam_single_vdma1

  # Create instance: cam_single_vdma2, and set properties
  set cam_single_vdma2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 cam_single_vdma2 ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_mm2s_genlock_mode {0} \
   CONFIG.c_num_fstores {1} \
   CONFIG.c_s2mm_genlock_mode {0} \
   CONFIG.c_s2mm_linebuffer_depth {128} \
 ] $cam_single_vdma2

  # Create instance: cam_single_vid_in1, and set properties
  set cam_single_vid_in1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 cam_single_vid_in1 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {5} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
 ] $cam_single_vid_in1

  # Create instance: cam_single_vid_in2, and set properties
  set cam_single_vid_in2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 cam_single_vid_in2 ]
  set_property -dict [ list \
   CONFIG.C_ADDR_WIDTH {5} \
   CONFIG.C_HAS_ASYNC_CLK {1} \
   CONFIG.C_M_AXIS_VIDEO_FORMAT {12} \
 ] $cam_single_vid_in2

  # Create instance: cam_single_vid_in_reset1, and set properties
  set cam_single_vid_in_reset1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 cam_single_vid_in_reset1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $cam_single_vid_in_reset1

  # Create instance: cam_single_vid_in_reset2, and set properties
  set cam_single_vid_in_reset2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 cam_single_vid_in_reset2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $cam_single_vid_in_reset2

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE_IIC] [get_bd_intf_pins cam_single_iic/S_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins IIC_CAMS_SINGLE] [get_bd_intf_pins cam_single_iic/IIC]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE_VDMA1] [get_bd_intf_pins cam_single_vdma1/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE_VDMA2] [get_bd_intf_pins cam_single_vdma2/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins cam_single_vdma1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_S2MM1] [get_bd_intf_pins cam_single_vdma2/M_AXI_S2MM]
  connect_bd_intf_net -intf_net cam_single_vid_in1_video_out [get_bd_intf_pins cam_single_vdma1/S_AXIS_S2MM] [get_bd_intf_pins cam_single_vid_in1/video_out]
  connect_bd_intf_net -intf_net cam_single_vid_in2_video_out [get_bd_intf_pins cam_single_vdma2/S_AXIS_S2MM] [get_bd_intf_pins cam_single_vid_in2/video_out]
  connect_bd_intf_net -intf_net mt9v034_deserializer_clock_infrastructure_0_DeserializerUnitClocks [get_bd_intf_pins cam_single_clk_infra/DeserializerUnitClocks] [get_bd_intf_pins cam_single_deserializer1/DeserializerUnitClocks]
  connect_bd_intf_net -intf_net [get_bd_intf_nets mt9v034_deserializer_clock_infrastructure_0_DeserializerUnitClocks] [get_bd_intf_pins cam_single_clk_infra/DeserializerUnitClocks] [get_bd_intf_pins cam_single_deserializer2/DeserializerUnitClocks]
  connect_bd_intf_net -intf_net mt9v034_deserializer_single1_VideoOut [get_bd_intf_pins cam_single_deserializer1/VideoOut] [get_bd_intf_pins cam_single_vid_in1/vid_io_in]
  connect_bd_intf_net -intf_net mt9v034_deserializer_single2_VideoOut [get_bd_intf_pins cam_single_deserializer2/VideoOut] [get_bd_intf_pins cam_single_vid_in2/vid_io_in]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins aclk] [get_bd_pins cam_single_vdma1/m_axi_s2mm_aclk] [get_bd_pins cam_single_vdma1/s_axis_s2mm_aclk] [get_bd_pins cam_single_vdma2/m_axi_s2mm_aclk] [get_bd_pins cam_single_vdma2/s_axis_s2mm_aclk] [get_bd_pins cam_single_vid_in1/aclk] [get_bd_pins cam_single_vid_in2/aclk]
  connect_bd_net -net cam_n_0_1 [get_bd_pins SINGLE_CAM1_n] [get_bd_pins cam_single_deserializer1/cam_n]
  connect_bd_net -net cam_n_1_1 [get_bd_pins SINGLE_CAM2_n] [get_bd_pins cam_single_deserializer2/cam_n]
  connect_bd_net -net cam_p_0_1 [get_bd_pins SINGLE_CAM1_p] [get_bd_pins cam_single_deserializer1/cam_p]
  connect_bd_net -net cam_p_1_1 [get_bd_pins SINGLE_CAM2_p] [get_bd_pins cam_single_deserializer2/cam_p]
  connect_bd_net -net cam_single_deserializer1_pixel_data_valid [get_bd_pins cam_single_deserializer1/pixel_data_valid] [get_bd_pins cam_single_vid_in1/vid_io_in_ce]
  connect_bd_net -net cam_single_deserializer1_pxclk [get_bd_pins cam_single_deserializer1/pxclk] [get_bd_pins cam_single_vid_in1/vid_io_in_clk]
  connect_bd_net -net cam_single_deserializer1_receiver_locked [get_bd_pins cam_single_deserializer1/receiver_locked] [get_bd_pins cam_single_vid_in1/axis_enable] [get_bd_pins cam_single_vid_in_reset1/Op1]
  connect_bd_net -net cam_single_deserializer2_pixel_data_valid [get_bd_pins cam_single_deserializer2/pixel_data_valid] [get_bd_pins cam_single_vid_in2/vid_io_in_ce]
  connect_bd_net -net cam_single_deserializer2_pxclk [get_bd_pins cam_single_deserializer2/pxclk] [get_bd_pins cam_single_vid_in2/vid_io_in_clk]
  connect_bd_net -net cam_single_deserializer2_receiver_locked [get_bd_pins cam_single_deserializer2/receiver_locked] [get_bd_pins cam_single_vid_in2/axis_enable] [get_bd_pins cam_single_vid_in_reset2/Op1]
  connect_bd_net -net cam_single_iic_iic2intc_irpt [get_bd_pins int_iic] [get_bd_pins cam_single_iic/iic2intc_irpt]
  connect_bd_net -net cam_single_vdma1_s2mm_introut [get_bd_pins int_vdma1] [get_bd_pins cam_single_vdma1/s2mm_introut]
  connect_bd_net -net cam_single_vdma2_s2mm_introut [get_bd_pins int_vdma2] [get_bd_pins cam_single_vdma2/s2mm_introut]
  connect_bd_net -net cam_single_vid_in_reset1_Res [get_bd_pins cam_single_vid_in1/vid_io_in_reset] [get_bd_pins cam_single_vid_in_reset1/Res]
  connect_bd_net -net cam_single_vid_in_reset2_Res [get_bd_pins cam_single_vid_in2/vid_io_in_reset] [get_bd_pins cam_single_vid_in_reset2/Res]
  connect_bd_net -net s_axi_aclk_1 [get_bd_pins s_axi_aclk] [get_bd_pins cam_single_clk_infra/ClkIn] [get_bd_pins cam_single_iic/s_axi_aclk] [get_bd_pins cam_single_vdma1/s_axi_lite_aclk] [get_bd_pins cam_single_vdma2/s_axi_lite_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_aresetn] [get_bd_pins cam_single_iic/s_axi_aresetn] [get_bd_pins cam_single_vdma1/axi_resetn] [get_bd_pins cam_single_vdma2/axi_resetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CAM_SINGLE_IIC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 CAM_SINGLE_IIC ]

  set CAM_STEREO_IIC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 CAM_STEREO_IIC ]

  set COPTER_CAN [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:can_rtl:1.0 COPTER_CAN ]

  set COPTER_I2C [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 COPTER_I2C ]

  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  set HDMIO_IIC [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 HDMIO_IIC ]


  # Create ports
  set CAM_SINGLE1_SYSCLK [ create_bd_port -dir O -type clk CAM_SINGLE1_SYSCLK ]
  set CAM_SINGLE2_SYSCLK [ create_bd_port -dir O -type clk CAM_SINGLE2_SYSCLK ]
  set CAM_STEREO1_SYSCLK [ create_bd_port -dir O -type clk CAM_STEREO1_SYSCLK ]
  set CAM_STEREO2_SYSCLK [ create_bd_port -dir O -type clk CAM_STEREO2_SYSCLK ]
  set CAM_STEREO3_SYSCLK [ create_bd_port -dir O -type clk CAM_STEREO3_SYSCLK ]
  set CAM_STEREO4_SYSCLK [ create_bd_port -dir O -type clk CAM_STEREO4_SYSCLK ]
  set COPTER_MOTOR_PWM [ create_bd_port -dir O -from 5 -to 0 COPTER_MOTOR_PWM ]
  set COPTER_SERIAL2_cts [ create_bd_port -dir I COPTER_SERIAL2_cts ]
  set COPTER_SERIAL2_rts [ create_bd_port -dir O COPTER_SERIAL2_rts ]
  set COPTER_SERIAL2_rx [ create_bd_port -dir I COPTER_SERIAL2_rx ]
  set COPTER_SERIAL2_tx [ create_bd_port -dir O COPTER_SERIAL2_tx ]
  set COPTER_SPI_IMU_cs_mpu [ create_bd_port -dir O COPTER_SPI_IMU_cs_mpu ]
  set COPTER_SPI_IMU_cs_ms5611 [ create_bd_port -dir O COPTER_SPI_IMU_cs_ms5611 ]
  set COPTER_SPI_IMU_miso [ create_bd_port -dir I COPTER_SPI_IMU_miso ]
  set COPTER_SPI_IMU_mosi [ create_bd_port -dir O COPTER_SPI_IMU_mosi ]
  set COPTER_SPI_IMU_sclk [ create_bd_port -dir O COPTER_SPI_IMU_sclk ]
  set COPTER_SPI_cs [ create_bd_port -dir O COPTER_SPI_cs ]
  set COPTER_SPI_miso [ create_bd_port -dir I COPTER_SPI_miso ]
  set COPTER_SPI_mosi [ create_bd_port -dir O COPTER_SPI_mosi ]
  set COPTER_SPI_sclk [ create_bd_port -dir O COPTER_SPI_sclk ]
  set SINGLE_CAM_1_n [ create_bd_port -dir I SINGLE_CAM_1_n ]
  set SINGLE_CAM_1_p [ create_bd_port -dir I SINGLE_CAM_1_p ]
  set SINGLE_CAM_2_n [ create_bd_port -dir I SINGLE_CAM_2_n ]
  set SINGLE_CAM_2_p [ create_bd_port -dir I SINGLE_CAM_2_p ]
  set STEREO_CAM_1_n [ create_bd_port -dir I STEREO_CAM_1_n ]
  set STEREO_CAM_1_p [ create_bd_port -dir I STEREO_CAM_1_p ]
  set STEREO_CAM_2_n [ create_bd_port -dir I STEREO_CAM_2_n ]
  set STEREO_CAM_2_p [ create_bd_port -dir I STEREO_CAM_2_p ]
  set STEREO_CAM_3_n [ create_bd_port -dir I STEREO_CAM_3_n ]
  set STEREO_CAM_3_p [ create_bd_port -dir I STEREO_CAM_3_p ]
  set STEREO_CAM_4_n [ create_bd_port -dir I STEREO_CAM_4_n ]
  set STEREO_CAM_4_p [ create_bd_port -dir I STEREO_CAM_4_p ]

  # Create instance: cams_single
  create_hier_cell_cams_single [current_bd_instance .] cams_single

  # Create instance: cams_stereo
  create_hier_cell_cams_stereo [current_bd_instance .] cams_stereo

  # Create instance: clk_cams, and set properties
  set clk_cams [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_cams ]
  set_property -dict [ list \
   CONFIG.CLKIN2_JITTER_PS {112.49000000000001} \
   CONFIG.CLKOUT1_DRIVES {BUFG} \
   CONFIG.CLKOUT1_JITTER {351.904} \
   CONFIG.CLKOUT1_PHASE_ERROR {307.118} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {26.66666666} \
   CONFIG.CLKOUT2_DRIVES {BUFG} \
   CONFIG.CLKOUT2_JITTER {137.681} \
   CONFIG.CLKOUT2_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT2_USED {false} \
   CONFIG.CLKOUT3_DRIVES {BUFG} \
   CONFIG.CLKOUT3_JITTER {137.681} \
   CONFIG.CLKOUT3_PHASE_ERROR {105.461} \
   CONFIG.CLKOUT3_USED {false} \
   CONFIG.CLKOUT4_DRIVES {BUFG} \
   CONFIG.CLKOUT5_DRIVES {BUFG} \
   CONFIG.CLKOUT6_DRIVES {BUFG} \
   CONFIG.CLKOUT7_DRIVES {BUFG} \
   CONFIG.CLK_OUT1_PORT {clk_cams} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {44} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.000} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {33} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
   CONFIG.MMCM_COMPENSATION {ZHOLD} \
   CONFIG.MMCM_DIVCLK_DIVIDE {5} \
   CONFIG.NUM_OUT_CLKS {1} \
   CONFIG.PRIMITIVE {PLL} \
   CONFIG.PRIM_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
   CONFIG.USE_FREQ_SYNTH {true} \
   CONFIG.USE_INCLK_SWITCHOVER {false} \
   CONFIG.USE_LOCKED {false} \
   CONFIG.USE_PHASE_ALIGNMENT {false} \
   CONFIG.USE_RESET {false} \
 ] $clk_cams

  # Create instance: concat_int, and set properties
  set concat_int [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_int ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {8} \
 ] $concat_int

  # Create instance: copter_peripherals
  create_hier_cell_copter_peripherals [current_bd_instance .] copter_peripherals

  # Create instance: interconnect_cam_membus, and set properties
  set interconnect_cam_membus [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_cam_membus ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {6} \
 ] $interconnect_cam_membus

  # Create instance: interconnect_peripherals, and set properties
  set interconnect_peripherals [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_peripherals ]
  set_property -dict [ list \
   CONFIG.NUM_MI {9} \
 ] $interconnect_peripherals

  # Create instance: rst_zynq_cams_membus, and set properties
  set rst_zynq_cams_membus [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_zynq_cams_membus ]

  # Create instance: rst_zynq_peripherals, and set properties
  set rst_zynq_peripherals [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_zynq_peripherals ]

  # Create instance: vcc, and set properties
  set vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc ]

  # Create instance: zynq, and set properties
  set zynq [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 zynq ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {142.857132} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {25.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {166.666672} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {50.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {667} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN0_CAN0_IO {EMIO} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {1} \
   CONFIG.PCW_CLK0_FREQ {100000000} \
   CONFIG.PCW_CLK1_FREQ {142857132} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_CAN0 {1} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_CAN0 {1} \
   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_I2C0 {1} \
   CONFIG.PCW_EN_EMIO_I2C1 {1} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {1} \
   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {1} \
   CONFIG.PCW_EN_EMIO_SPI1 {1} \
   CONFIG.PCW_EN_EMIO_TTC0 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {1} \
   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {1} \
   CONFIG.PCW_EN_I2C1 {1} \
   CONFIG.PCW_EN_MODEM_UART0 {1} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SDIO1 {1} \
   CONFIG.PCW_EN_SPI0 {1} \
   CONFIG.PCW_EN_SPI1 {1} \
   CONFIG.PCW_EN_TTC0 {0} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {2} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {7} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {150} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {1} \
   CONFIG.PCW_I2C0_GRP_INT_IO {EMIO} \
   CONFIG.PCW_I2C0_I2C0_IO {EMIO} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {1} \
   CONFIG.PCW_I2C1_GRP_INT_IO {EMIO} \
   CONFIG.PCW_I2C1_I2C1_IO {EMIO} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_I2C_RESET_ENABLE {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_MIO_0_DIRECTION {inout} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {disabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {disabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {disabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {disabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {disabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {inout} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {disabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_15_PULLUP {disabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {disabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {disabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {disabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {disabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_1_PULLUP {disabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {disabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {disabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {disabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {disabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {disabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {disabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {disabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {disabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {disabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {disabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {disabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {disabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {disabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {disabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {disabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {disabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {disabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {disabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {disabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {disabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {disabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {disabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {disabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {disabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {disabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {disabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {in} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {disabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {inout} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {disabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {disabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {disabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {disabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {disabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {disabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {disabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {disabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#USB Reset#Quad SPI Flash#GPIO#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#GPIO#UART 1#UART 1#GPIO#GPIO#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#reset#qspi_fbclk#gpio[9]#data[0]#cmd#clk#data[1]#data[2]#data[3]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#cd#gpio[47]#tx#rx#gpio[50]#gpio[51]#mdc#mdio} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.301} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.308} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.357} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.361} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.033} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.029} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {0.057} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {0.038} \
   CONFIG.PCW_PACKAGE_NAME {sbg485} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_FBCLK_IO {MIO 8} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD1_SD1_IO {MIO 10 .. 15} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {40} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SINGLE_QSPI_DATA_MODE {x4} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS0_IO {EMIO} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS1_IO {EMIO} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {1} \
   CONFIG.PCW_SPI0_GRP_SS2_IO {EMIO} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SPI0_SPI0_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS0_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS1_IO {EMIO} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {1} \
   CONFIG.PCW_SPI1_GRP_SS2_IO {EMIO} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SPI1_SPI1_IO {EMIO} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {6} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC0_TTC0_IO {<Select>} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {1} \
   CONFIG.PCW_UART0_GRP_FULL_IO {EMIO} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {EMIO} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {20} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.240} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.238} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.283} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.284} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {33.621} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {33.621} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {48.166} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {48.166} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {38.200} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {38.692} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {38.778} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {38.635} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.036} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.036} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.058} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.057} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {38.671} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {38.635} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {38.671} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {38.679} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3 (Low Voltage)} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {1} \
   CONFIG.PCW_USB0_RESET_IO {MIO 7} \
   CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {1} \
   CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP1 {0} \
 ] $zynq

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins cams_single/M_AXI_S2MM] [get_bd_intf_pins interconnect_cam_membus/S00_AXI]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins cams_single/M_AXI_S2MM1] [get_bd_intf_pins interconnect_cam_membus/S01_AXI]
  connect_bd_intf_net -intf_net cams_single_iic_rtl_0 [get_bd_intf_ports CAM_SINGLE_IIC] [get_bd_intf_pins cams_single/IIC_CAMS_SINGLE]
  connect_bd_intf_net -intf_net cams_stereo_IIC_CAMS_STEREO [get_bd_intf_ports CAM_STEREO_IIC] [get_bd_intf_pins cams_stereo/IIC_CAMS_STEREO]
  connect_bd_intf_net -intf_net cams_stereo_M_AXI_S2MM [get_bd_intf_pins cams_stereo/M_AXI_S2MM1] [get_bd_intf_pins interconnect_cam_membus/S02_AXI]
  connect_bd_intf_net -intf_net cams_stereo_M_AXI_S2MM1 [get_bd_intf_pins cams_stereo/M_AXI_S2MM2] [get_bd_intf_pins interconnect_cam_membus/S03_AXI]
  connect_bd_intf_net -intf_net cams_stereo_M_AXI_S2MM3 [get_bd_intf_pins cams_stereo/M_AXI_S2MM3] [get_bd_intf_pins interconnect_cam_membus/S04_AXI]
  connect_bd_intf_net -intf_net cams_stereo_M_AXI_S2MM4 [get_bd_intf_pins cams_stereo/M_AXI_S2MM4] [get_bd_intf_pins interconnect_cam_membus/S05_AXI]
  connect_bd_intf_net -intf_net interconnect_cam_membus_M00_AXI [get_bd_intf_pins interconnect_cam_membus/M00_AXI] [get_bd_intf_pins zynq/S_AXI_HP0]
  connect_bd_intf_net -intf_net interconnect_peripherals_M01_AXI [get_bd_intf_pins cams_single/S_AXI_LITE_IIC] [get_bd_intf_pins interconnect_peripherals/M01_AXI]
  connect_bd_intf_net -intf_net interconnect_peripherals_M02_AXI [get_bd_intf_pins cams_single/S_AXI_LITE_VDMA1] [get_bd_intf_pins interconnect_peripherals/M02_AXI]
  connect_bd_intf_net -intf_net interconnect_peripherals_M03_AXI [get_bd_intf_pins cams_single/S_AXI_LITE_VDMA2] [get_bd_intf_pins interconnect_peripherals/M03_AXI]
  connect_bd_intf_net -intf_net interconnect_peripherals_M04_AXI [get_bd_intf_pins cams_stereo/S_AXI_LITE_IIC] [get_bd_intf_pins interconnect_peripherals/M04_AXI]
  connect_bd_intf_net -intf_net interconnect_peripherals_M05_AXI [get_bd_intf_pins cams_stereo/S_AXI_LITE_VDMA1] [get_bd_intf_pins interconnect_peripherals/M05_AXI]
  connect_bd_intf_net -intf_net interconnect_peripherals_M06_AXI [get_bd_intf_pins cams_stereo/S_AXI_LITE_VDMA2] [get_bd_intf_pins interconnect_peripherals/M06_AXI]
  connect_bd_intf_net -intf_net interconnect_peripherals_M07_AXI [get_bd_intf_pins cams_stereo/S_AXI_LITE_VDMA3] [get_bd_intf_pins interconnect_peripherals/M07_AXI]
  connect_bd_intf_net -intf_net interconnect_peripherals_M08_AXI [get_bd_intf_pins cams_stereo/S_AXI_LITE_VDMA4] [get_bd_intf_pins interconnect_peripherals/M08_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_CAN_0 [get_bd_intf_ports COPTER_CAN] [get_bd_intf_pins zynq/CAN_0]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins zynq/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins zynq/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins interconnect_peripherals/S00_AXI] [get_bd_intf_pins zynq/M_AXI_GP0]
  connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins copter_peripherals/S_AXI] [get_bd_intf_pins interconnect_peripherals/M00_AXI]
  connect_bd_intf_net -intf_net zynq_IIC_0 [get_bd_intf_ports HDMIO_IIC] [get_bd_intf_pins zynq/IIC_0]
  connect_bd_intf_net -intf_net zynq_IIC_1 [get_bd_intf_ports COPTER_I2C] [get_bd_intf_pins zynq/IIC_1]

  # Create port connections
  connect_bd_net -net ARESETN_1 [get_bd_pins interconnect_cam_membus/ARESETN] [get_bd_pins rst_zynq_cams_membus/interconnect_aresetn]
  connect_bd_net -net S01_ARESETN_1 [get_bd_pins interconnect_cam_membus/M00_ARESETN] [get_bd_pins interconnect_cam_membus/S00_ARESETN] [get_bd_pins interconnect_cam_membus/S01_ARESETN] [get_bd_pins interconnect_cam_membus/S02_ARESETN] [get_bd_pins interconnect_cam_membus/S03_ARESETN] [get_bd_pins interconnect_cam_membus/S04_ARESETN] [get_bd_pins interconnect_cam_membus/S05_ARESETN] [get_bd_pins rst_zynq_cams_membus/peripheral_aresetn]
  connect_bd_net -net SINGLE_CAM_1_p [get_bd_ports SINGLE_CAM_1_p] [get_bd_pins cams_single/SINGLE_CAM1_p]
  connect_bd_net -net SPI0_MISO_I_0_1 [get_bd_ports COPTER_SPI_IMU_miso] [get_bd_pins zynq/SPI0_MISO_I]
  connect_bd_net -net SPI1_MISO_I_0_1 [get_bd_ports COPTER_SPI_miso] [get_bd_pins zynq/SPI1_MISO_I]
  connect_bd_net -net STEREO_CAM1_n_0_1 [get_bd_ports STEREO_CAM_1_n] [get_bd_pins cams_stereo/STEREO_CAM1_n]
  connect_bd_net -net STEREO_CAM1_p_0_1 [get_bd_ports STEREO_CAM_1_p] [get_bd_pins cams_stereo/STEREO_CAM1_p]
  connect_bd_net -net STEREO_CAM2_n_0_1 [get_bd_ports STEREO_CAM_2_n] [get_bd_pins cams_stereo/STEREO_CAM2_n]
  connect_bd_net -net STEREO_CAM2_p_0_1 [get_bd_ports STEREO_CAM_2_p] [get_bd_pins cams_stereo/STEREO_CAM2_p]
  connect_bd_net -net STEREO_CAM_3_n_1 [get_bd_ports STEREO_CAM_3_n] [get_bd_pins cams_stereo/STEREO_CAM3_n]
  connect_bd_net -net STEREO_CAM_3_p_1 [get_bd_ports STEREO_CAM_3_p] [get_bd_pins cams_stereo/STEREO_CAM3_p]
  connect_bd_net -net STEREO_CAM_4_n_1 [get_bd_ports STEREO_CAM_4_n] [get_bd_pins cams_stereo/STEREO_CAM4_n]
  connect_bd_net -net STEREO_CAM_4_p_1 [get_bd_ports STEREO_CAM_4_p] [get_bd_pins cams_stereo/STEREO_CAM4_p]
  connect_bd_net -net UART0_CTSN_0_1 [get_bd_ports COPTER_SERIAL2_cts] [get_bd_pins zynq/UART0_CTSN]
  connect_bd_net -net UART0_RX_0_1 [get_bd_ports COPTER_SERIAL2_rx] [get_bd_pins zynq/UART0_RX]
  connect_bd_net -net cam_n_0_1 [get_bd_ports SINGLE_CAM_1_n] [get_bd_pins cams_single/SINGLE_CAM1_n]
  connect_bd_net -net cam_n_1_1 [get_bd_ports SINGLE_CAM_2_n] [get_bd_pins cams_single/SINGLE_CAM2_n]
  connect_bd_net -net cam_p_1_1 [get_bd_ports SINGLE_CAM_2_p] [get_bd_pins cams_single/SINGLE_CAM2_p]
  connect_bd_net -net cams_single_iic2intc_irpt [get_bd_pins cams_single/int_iic] [get_bd_pins concat_int/In0]
  connect_bd_net -net cams_single_s2mm_introut [get_bd_pins cams_single/int_vdma1] [get_bd_pins concat_int/In1]
  connect_bd_net -net cams_single_s2mm_introut1 [get_bd_pins cams_single/int_vdma2] [get_bd_pins concat_int/In2]
  connect_bd_net -net cams_stereo_int_iic [get_bd_pins cams_stereo/int_iic] [get_bd_pins concat_int/In3]
  connect_bd_net -net cams_stereo_int_vdma1 [get_bd_pins cams_stereo/int_vdma1] [get_bd_pins concat_int/In4]
  connect_bd_net -net cams_stereo_int_vdma2 [get_bd_pins cams_stereo/int_vdma2] [get_bd_pins concat_int/In5]
  connect_bd_net -net cams_stereo_int_vdma3 [get_bd_pins cams_stereo/int_vdma3] [get_bd_pins concat_int/In6]
  connect_bd_net -net cams_stereo_int_vdma4 [get_bd_pins cams_stereo/int_vdma4] [get_bd_pins concat_int/In7]
  connect_bd_net -net clk_cams_clk_cams [get_bd_ports CAM_SINGLE1_SYSCLK] [get_bd_ports CAM_SINGLE2_SYSCLK] [get_bd_ports CAM_STEREO1_SYSCLK] [get_bd_ports CAM_STEREO2_SYSCLK] [get_bd_ports CAM_STEREO3_SYSCLK] [get_bd_ports CAM_STEREO4_SYSCLK] [get_bd_pins clk_cams/clk_cams]
  connect_bd_net -net concat_int_dout [get_bd_pins concat_int/dout] [get_bd_pins zynq/IRQ_F2P]
  connect_bd_net -net copter_peripherals_MOTOR_OUT_0 [get_bd_ports COPTER_MOTOR_PWM] [get_bd_pins copter_peripherals/MOTOR_OUT_0]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins cams_single/s_axi_aclk] [get_bd_pins cams_stereo/s_axi_aclk] [get_bd_pins clk_cams/clk_in1] [get_bd_pins copter_peripherals/S_AXI_ACLK] [get_bd_pins interconnect_peripherals/ACLK] [get_bd_pins interconnect_peripherals/M00_ACLK] [get_bd_pins interconnect_peripherals/M01_ACLK] [get_bd_pins interconnect_peripherals/M02_ACLK] [get_bd_pins interconnect_peripherals/M03_ACLK] [get_bd_pins interconnect_peripherals/M04_ACLK] [get_bd_pins interconnect_peripherals/M05_ACLK] [get_bd_pins interconnect_peripherals/M06_ACLK] [get_bd_pins interconnect_peripherals/M07_ACLK] [get_bd_pins interconnect_peripherals/M08_ACLK] [get_bd_pins interconnect_peripherals/S00_ACLK] [get_bd_pins rst_zynq_peripherals/slowest_sync_clk] [get_bd_pins zynq/FCLK_CLK0] [get_bd_pins zynq/M_AXI_GP0_ACLK]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins rst_zynq_cams_membus/ext_reset_in] [get_bd_pins rst_zynq_peripherals/ext_reset_in] [get_bd_pins zynq/FCLK_RESET0_N]
  connect_bd_net -net processing_system7_0_SPI0_MOSI_O [get_bd_ports COPTER_SPI_IMU_mosi] [get_bd_pins zynq/SPI0_MOSI_O]
  connect_bd_net -net processing_system7_0_SPI0_SCLK_O [get_bd_ports COPTER_SPI_IMU_sclk] [get_bd_pins zynq/SPI0_SCLK_O]
  connect_bd_net -net processing_system7_0_SPI0_SS1_O [get_bd_ports COPTER_SPI_IMU_cs_ms5611] [get_bd_pins zynq/SPI0_SS1_O]
  connect_bd_net -net processing_system7_0_SPI0_SS_O [get_bd_ports COPTER_SPI_IMU_cs_mpu] [get_bd_pins zynq/SPI0_SS_O]
  connect_bd_net -net processing_system7_0_SPI1_MOSI_O [get_bd_ports COPTER_SPI_mosi] [get_bd_pins zynq/SPI1_MOSI_O]
  connect_bd_net -net processing_system7_0_SPI1_SCLK_O [get_bd_ports COPTER_SPI_sclk] [get_bd_pins zynq/SPI1_SCLK_O]
  connect_bd_net -net processing_system7_0_SPI1_SS_O [get_bd_ports COPTER_SPI_cs] [get_bd_pins zynq/SPI1_SS_O]
  connect_bd_net -net processing_system7_0_UART0_RTSN [get_bd_ports COPTER_SERIAL2_rts] [get_bd_pins zynq/UART0_RTSN]
  connect_bd_net -net processing_system7_0_UART0_TX [get_bd_ports COPTER_SERIAL2_tx] [get_bd_pins zynq/UART0_TX]
  connect_bd_net -net rst_ps7_0_100M_interconnect_aresetn [get_bd_pins interconnect_peripherals/ARESETN] [get_bd_pins rst_zynq_peripherals/interconnect_aresetn]
  connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins cams_single/s_axi_aresetn] [get_bd_pins cams_stereo/s_axi_aresetn] [get_bd_pins copter_peripherals/S_AXI_ARESETN] [get_bd_pins interconnect_peripherals/M00_ARESETN] [get_bd_pins interconnect_peripherals/M01_ARESETN] [get_bd_pins interconnect_peripherals/M02_ARESETN] [get_bd_pins interconnect_peripherals/M03_ARESETN] [get_bd_pins interconnect_peripherals/M04_ARESETN] [get_bd_pins interconnect_peripherals/M05_ARESETN] [get_bd_pins interconnect_peripherals/M06_ARESETN] [get_bd_pins interconnect_peripherals/M07_ARESETN] [get_bd_pins interconnect_peripherals/M08_ARESETN] [get_bd_pins interconnect_peripherals/S00_ARESETN] [get_bd_pins rst_zynq_peripherals/peripheral_aresetn]
  connect_bd_net -net vcc_dout [get_bd_pins vcc/dout] [get_bd_pins zynq/SPI0_SS_I] [get_bd_pins zynq/SPI1_SS_I]
  connect_bd_net -net zynq_FCLK_CLK1 [get_bd_pins cams_single/aclk] [get_bd_pins cams_stereo/aclk] [get_bd_pins interconnect_cam_membus/ACLK] [get_bd_pins interconnect_cam_membus/M00_ACLK] [get_bd_pins interconnect_cam_membus/S00_ACLK] [get_bd_pins interconnect_cam_membus/S01_ACLK] [get_bd_pins interconnect_cam_membus/S02_ACLK] [get_bd_pins interconnect_cam_membus/S03_ACLK] [get_bd_pins interconnect_cam_membus/S04_ACLK] [get_bd_pins interconnect_cam_membus/S05_ACLK] [get_bd_pins rst_zynq_cams_membus/slowest_sync_clk] [get_bd_pins zynq/FCLK_CLK1] [get_bd_pins zynq/S_AXI_HP0_ACLK]

  # Create address segments
  assign_bd_address -offset 0x41000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq/Data] [get_bd_addr_segs cams_single/cam_single_iic/S_AXI/Reg] -force
  assign_bd_address -offset 0x41010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq/Data] [get_bd_addr_segs cams_single/cam_single_vdma1/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq/Data] [get_bd_addr_segs cams_single/cam_single_vdma2/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x42000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq/Data] [get_bd_addr_segs cams_stereo/cam_stereo_iic/S_AXI/Reg] -force
  assign_bd_address -offset 0x42010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq/Data] [get_bd_addr_segs cams_stereo/cam1/cam_stereo_vdma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x42020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq/Data] [get_bd_addr_segs cams_stereo/cam2/cam_stereo_vdma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x42030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq/Data] [get_bd_addr_segs cams_stereo/cam3/cam_stereo_vdma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x43040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq/Data] [get_bd_addr_segs cams_stereo/cam4/cam_stereo_vdma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq/Data] [get_bd_addr_segs copter_peripherals/motor_pwm_output_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces cams_single/cam_single_vdma1/Data_S2MM] [get_bd_addr_segs zynq/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces cams_single/cam_single_vdma2/Data_S2MM] [get_bd_addr_segs zynq/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces cams_stereo/cam1/cam_stereo_vdma/Data_S2MM] [get_bd_addr_segs zynq/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces cams_stereo/cam2/cam_stereo_vdma/Data_S2MM] [get_bd_addr_segs zynq/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces cams_stereo/cam3/cam_stereo_vdma/Data_S2MM] [get_bd_addr_segs zynq/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces cams_stereo/cam4/cam_stereo_vdma/Data_S2MM] [get_bd_addr_segs zynq/S_AXI_HP0/HP0_DDR_LOWOCM] -force


  # Restore current instance
  current_bd_instance $oldCurInst

}
# End of create_root_design()




proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_cams_single parentCell nameHier"
   puts "#    create_hier_cell_cams_stereo parentCell nameHier"
   puts "#    create_hier_cell_copter_peripherals parentCell nameHier"
   puts "#    create_hier_cell_cam1 parentCell nameHier"
   puts "#    create_hier_cell_cam2 parentCell nameHier"
   puts "#    create_hier_cell_cam3 parentCell nameHier"
   puts "#    create_hier_cell_cam4 parentCell nameHier"
   puts "#    create_root_design"
   puts "#"
   puts "#"
   puts "# The following procedures will create hiearchical blocks with addressing "
   puts "# for IPs within those blocks and their sub-hierarchical blocks. Addressing "
   puts "# will not be handled outside those blocks:"
   puts "#"
   puts "#    create_root_design"
   puts "#"
   puts "##################################################################"
}

available_tcl_procs
