
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
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:util_vector_logic:2.0\
analog.com:user:axi_clkgen:1.0\
analog.com:user:axi_hdmi_tx:1.0\
analog.com:user:axi_dmac:1.0\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axi_10g_ethernet:3.1\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:ip:axis_data_fifo:2.0\
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


# Hierarchical cell: sfp1
proc create_hier_cell_sfp1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sfp1() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SFP1_DMA

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SFP1_MAC


  # Create pins
  create_bd_pin -dir I -type rst areset_coreclk
  create_bd_pin -dir I -type clk coreclk
  create_bd_pin -dir I -type rst gtrxreset
  create_bd_pin -dir I -type rst gttxreset
  create_bd_pin -dir I qplllock
  create_bd_pin -dir I -type clk qplloutclk
  create_bd_pin -dir I -type clk qplloutrefclk
  create_bd_pin -dir I reset_counter_done
  create_bd_pin -dir I -type rst rx_path_aresetn
  create_bd_pin -dir I -type clk s_axi_clk_peripherals
  create_bd_pin -dir I -type rst s_axi_resetn_peripherals
  create_bd_pin -dir O -type intr sfp1_dma_rx_introut
  create_bd_pin -dir O -type intr sfp1_dma_tx_introut
  create_bd_pin -dir I sfp1_rxn
  create_bd_pin -dir I sfp1_rxp
  create_bd_pin -dir O sfp1_txn
  create_bd_pin -dir O sfp1_txp
  create_bd_pin -dir I -type rst tx_path_aresetn
  create_bd_pin -dir I txuserrdy
  create_bd_pin -dir I -type clk txusrclk
  create_bd_pin -dir I -type clk txusrclk2

  # Create instance: gnd, and set properties
  set gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $gnd

  # Create instance: sfp1_10gbe, and set properties
  set sfp1_10gbe [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_10g_ethernet:3.1 sfp1_10gbe ]
  set_property -dict [ list \
   CONFIG.DClkRate {150.00} \
   CONFIG.Management_Frequency {150.00} \
   CONFIG.Statistics_Gathering {false} \
   CONFIG.SupportLevel {0} \
 ] $sfp1_10gbe

  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rx:s_axis_pause:s_axis_tx} \
   CONFIG.ASSOCIATED_ASYNC_RESET {rx_axis_aresetn:tx_axis_aresetn} \
 ] [get_bd_pins /ethernet_10gbe/sfp1/sfp1_10gbe/coreclk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
 ] [get_bd_pins /ethernet_10gbe/sfp1/sfp1_10gbe/qplloutrefclk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
 ] [get_bd_pins /ethernet_10gbe/sfp1/sfp1_10gbe/rxrecclk_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
 ] [get_bd_pins /ethernet_10gbe/sfp1/sfp1_10gbe/txoutclk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
 ] [get_bd_pins /ethernet_10gbe/sfp1/sfp1_10gbe/txusrclk]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
 ] [get_bd_pins /ethernet_10gbe/sfp1/sfp1_10gbe/txusrclk2]

  # Create instance: sfp1_dma, and set properties
  set sfp1_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 sfp1_dma ]
  set_property -dict [ list \
   CONFIG.c_m_axi_mm2s_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {64} \
   CONFIG.c_mm2s_burst_size {256} \
   CONFIG.c_s2mm_burst_size {256} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
 ] $sfp1_dma

  # Create instance: sfp1_rx_fifo, and set properties
  set sfp1_rx_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 sfp1_rx_fifo ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {32768} \
   CONFIG.FIFO_MODE {2} \
 ] $sfp1_rx_fifo

  # Create instance: sfp1_tx_fifo, and set properties
  set sfp1_tx_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 sfp1_tx_fifo ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {32768} \
   CONFIG.FIFO_MODE {2} \
 ] $sfp1_tx_fifo

  # Create instance: vcc, and set properties
  set vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins sfp1_dma/M_AXI_SG]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins sfp1_dma/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins sfp1_dma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_SFP1_MAC] [get_bd_intf_pins sfp1_10gbe/s_axi]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_SFP1_DMA] [get_bd_intf_pins sfp1_dma/S_AXI_LITE]
  connect_bd_intf_net -intf_net sfp1_10gbe_m_axis_rx [get_bd_intf_pins sfp1_10gbe/m_axis_rx] [get_bd_intf_pins sfp1_rx_fifo/S_AXIS]
  connect_bd_intf_net -intf_net sfp1_dma_M_AXIS_MM2S [get_bd_intf_pins sfp1_dma/M_AXIS_MM2S] [get_bd_intf_pins sfp1_tx_fifo/S_AXIS]
  connect_bd_intf_net -intf_net sfp1_rx_fifo1_M_AXIS [get_bd_intf_pins sfp1_10gbe/s_axis_tx] [get_bd_intf_pins sfp1_tx_fifo/M_AXIS]
  connect_bd_intf_net -intf_net sfp1_rx_fifo_M_AXIS [get_bd_intf_pins sfp1_dma/S_AXIS_S2MM] [get_bd_intf_pins sfp1_rx_fifo/M_AXIS]

  # Create port connections
  connect_bd_net -net areset_coreclk_1 [get_bd_pins areset_coreclk] [get_bd_pins sfp1_10gbe/areset_coreclk]
  connect_bd_net -net coreclk_1 [get_bd_pins coreclk] [get_bd_pins sfp1_10gbe/coreclk] [get_bd_pins sfp1_dma/m_axi_mm2s_aclk] [get_bd_pins sfp1_dma/m_axi_s2mm_aclk] [get_bd_pins sfp1_rx_fifo/s_axis_aclk] [get_bd_pins sfp1_tx_fifo/s_axis_aclk]
  connect_bd_net -net gnd_dout [get_bd_pins gnd/dout] [get_bd_pins sfp1_10gbe/tx_fault]
  connect_bd_net -net gtrxreset_1 [get_bd_pins gtrxreset] [get_bd_pins sfp1_10gbe/gtrxreset]
  connect_bd_net -net gttxreset_1 [get_bd_pins gttxreset] [get_bd_pins sfp1_10gbe/gttxreset]
  connect_bd_net -net qplllock_1 [get_bd_pins qplllock] [get_bd_pins sfp1_10gbe/qplllock]
  connect_bd_net -net qplloutclk_1 [get_bd_pins qplloutclk] [get_bd_pins sfp1_10gbe/qplloutclk]
  connect_bd_net -net qplloutrefclk_1 [get_bd_pins qplloutrefclk] [get_bd_pins sfp1_10gbe/qplloutrefclk]
  connect_bd_net -net reset_counter_done_1 [get_bd_pins reset_counter_done] [get_bd_pins sfp1_10gbe/reset_counter_done]
  connect_bd_net -net s_axi_clk_peripherals_1 [get_bd_pins s_axi_clk_peripherals] [get_bd_pins sfp1_10gbe/dclk] [get_bd_pins sfp1_10gbe/s_axi_aclk] [get_bd_pins sfp1_dma/m_axi_sg_aclk] [get_bd_pins sfp1_dma/s_axi_lite_aclk]
  connect_bd_net -net s_axi_resetn_peripherals_1 [get_bd_pins s_axi_resetn_peripherals] [get_bd_pins sfp1_10gbe/s_axi_aresetn] [get_bd_pins sfp1_dma/axi_resetn]
  connect_bd_net -net s_axis_aresetn_1 [get_bd_pins tx_path_aresetn] [get_bd_pins sfp1_tx_fifo/s_axis_aresetn]
  connect_bd_net -net s_axis_aresetn_2 [get_bd_pins rx_path_aresetn] [get_bd_pins sfp1_rx_fifo/s_axis_aresetn]
  connect_bd_net -net sfp1_10gbe_txn [get_bd_pins sfp1_txn] [get_bd_pins sfp1_10gbe/txn]
  connect_bd_net -net sfp1_10gbe_txp [get_bd_pins sfp1_txp] [get_bd_pins sfp1_10gbe/txp]
  connect_bd_net -net sfp1_dma_mm2s_introut [get_bd_pins sfp1_dma_tx_introut] [get_bd_pins sfp1_dma/mm2s_introut]
  connect_bd_net -net sfp1_dma_mm2s_prmry_reset_out_n [get_bd_pins sfp1_10gbe/tx_axis_aresetn] [get_bd_pins sfp1_dma/mm2s_prmry_reset_out_n]
  connect_bd_net -net sfp1_dma_s2mm_introut [get_bd_pins sfp1_dma_rx_introut] [get_bd_pins sfp1_dma/s2mm_introut]
  connect_bd_net -net sfp1_dma_s2mm_prmry_reset_out_n [get_bd_pins sfp1_10gbe/rx_axis_aresetn] [get_bd_pins sfp1_dma/s2mm_prmry_reset_out_n]
  connect_bd_net -net sfp1_rxn_1 [get_bd_pins sfp1_rxn] [get_bd_pins sfp1_10gbe/rxn]
  connect_bd_net -net sfp1_rxp_1 [get_bd_pins sfp1_rxp] [get_bd_pins sfp1_10gbe/rxp]
  connect_bd_net -net txuserrdy_1 [get_bd_pins txuserrdy] [get_bd_pins sfp1_10gbe/txuserrdy]
  connect_bd_net -net txusrclk2_1 [get_bd_pins txusrclk2] [get_bd_pins sfp1_10gbe/txusrclk2]
  connect_bd_net -net txusrclk_1 [get_bd_pins txusrclk] [get_bd_pins sfp1_10gbe/txusrclk]
  connect_bd_net -net vcc_dout [get_bd_pins sfp1_10gbe/signal_detect] [get_bd_pins vcc/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: sfp0
proc create_hier_cell_sfp0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_sfp0() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_SG

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SFP0_DMA

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SFP0_MAC


  # Create pins
  create_bd_pin -dir O -type rst areset_datapathclk_out
  create_bd_pin -dir O -type clk coreclk_out
  create_bd_pin -dir O -type rst gtrxreset_out
  create_bd_pin -dir O -type rst gttxreset_out
  create_bd_pin -dir I phy_refclk_n
  create_bd_pin -dir I phy_refclk_p
  create_bd_pin -dir O qplllock
  create_bd_pin -dir O -type clk qplloutclk_out
  create_bd_pin -dir O -type clk qplloutrefclk_out
  create_bd_pin -dir O reset_counter_done_out
  create_bd_pin -dir I -type rst rx_path_aresetn
  create_bd_pin -dir I -type clk s_axi_clk_peripherals
  create_bd_pin -dir I -type rst s_axi_resetn_peripherals
  create_bd_pin -dir O -type intr sfp0_dma_rx_introut
  create_bd_pin -dir O -type intr sfp0_dma_tx_introut
  create_bd_pin -dir I sfp0_rxn
  create_bd_pin -dir I sfp0_rxp
  create_bd_pin -dir O sfp0_txn
  create_bd_pin -dir O sfp0_txp
  create_bd_pin -dir I -type rst tx_path_aresetn
  create_bd_pin -dir O txuserrdy_out
  create_bd_pin -dir O -type clk txusrclk2_out
  create_bd_pin -dir O -type clk txusrclk_out

  # Create instance: gnd, and set properties
  set gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $gnd

  # Create instance: reset_n, and set properties
  set reset_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 reset_n ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $reset_n

  # Create instance: sfp0_10gbe, and set properties
  set sfp0_10gbe [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_10g_ethernet:3.1 sfp0_10gbe ]
  set_property -dict [ list \
   CONFIG.DClkRate {150.00} \
   CONFIG.Management_Frequency {150.00} \
   CONFIG.Management_Interface {true} \
   CONFIG.Statistics_Gathering {false} \
   CONFIG.SupportLevel {1} \
   CONFIG.TransceiverControl {false} \
 ] $sfp0_10gbe

  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
   CONFIG.ASSOCIATED_BUSIF {m_axis_rx:s_axis_pause:s_axis_tx} \
   CONFIG.ASSOCIATED_ASYNC_RESET {tx_axis_aresetn:rx_axis_aresetn} \
 ] [get_bd_pins /ethernet_10gbe/sfp0/sfp0_10gbe/coreclk_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {156250000} \
 ] [get_bd_pins /ethernet_10gbe/sfp0/sfp0_10gbe/qplloutrefclk_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
 ] [get_bd_pins /ethernet_10gbe/sfp0/sfp0_10gbe/rxrecclk_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
 ] [get_bd_pins /ethernet_10gbe/sfp0/sfp0_10gbe/txusrclk2_out]

  set_property -dict [ list \
   CONFIG.FREQ_HZ {322265625} \
 ] [get_bd_pins /ethernet_10gbe/sfp0/sfp0_10gbe/txusrclk_out]

  # Create instance: sfp0_dma, and set properties
  set sfp0_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 sfp0_dma ]
  set_property -dict [ list \
   CONFIG.c_m_axi_mm2s_data_width {64} \
   CONFIG.c_m_axis_mm2s_tdata_width {64} \
   CONFIG.c_mm2s_burst_size {256} \
   CONFIG.c_s2mm_burst_size {256} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
 ] $sfp0_dma

  # Create instance: sfp0_rx_fifo, and set properties
  set sfp0_rx_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 sfp0_rx_fifo ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {32768} \
   CONFIG.FIFO_MODE {2} \
 ] $sfp0_rx_fifo

  # Create instance: sfp0_tx_fifo, and set properties
  set sfp0_tx_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_data_fifo:2.0 sfp0_tx_fifo ]
  set_property -dict [ list \
   CONFIG.FIFO_DEPTH {32768} \
   CONFIG.FIFO_MODE {2} \
 ] $sfp0_tx_fifo

  # Create instance: vcc, and set properties
  set vcc [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_SFP0_DMA] [get_bd_intf_pins sfp0_dma/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M_AXI_SG] [get_bd_intf_pins sfp0_dma/M_AXI_SG]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_SFP0_MAC] [get_bd_intf_pins sfp0_10gbe/s_axi]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins sfp0_dma/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins sfp0_dma/M_AXI_S2MM]
  connect_bd_intf_net -intf_net sfp0_10gbe_m_axis_rx [get_bd_intf_pins sfp0_10gbe/m_axis_rx] [get_bd_intf_pins sfp0_rx_fifo/S_AXIS]
  connect_bd_intf_net -intf_net sfp0_dma_M_AXIS_MM2S [get_bd_intf_pins sfp0_dma/M_AXIS_MM2S] [get_bd_intf_pins sfp0_tx_fifo/S_AXIS]
  connect_bd_intf_net -intf_net sfp0_rx_fifo_M_AXIS [get_bd_intf_pins sfp0_dma/S_AXIS_S2MM] [get_bd_intf_pins sfp0_rx_fifo/M_AXIS]
  connect_bd_intf_net -intf_net sfp0_tx_fifo_M_AXIS [get_bd_intf_pins sfp0_10gbe/s_axis_tx] [get_bd_intf_pins sfp0_tx_fifo/M_AXIS]

  # Create port connections
  connect_bd_net -net gnd_dout [get_bd_pins gnd/dout] [get_bd_pins sfp0_10gbe/tx_fault]
  connect_bd_net -net gtrxreset_n_Res [get_bd_pins rx_path_aresetn] [get_bd_pins sfp0_rx_fifo/s_axis_aresetn]
  connect_bd_net -net gttxreset_n_Res [get_bd_pins tx_path_aresetn] [get_bd_pins sfp0_tx_fifo/s_axis_aresetn]
  connect_bd_net -net phy_refclk_n_1 [get_bd_pins phy_refclk_n] [get_bd_pins sfp0_10gbe/refclk_n]
  connect_bd_net -net phy_refclk_p_1 [get_bd_pins phy_refclk_p] [get_bd_pins sfp0_10gbe/refclk_p]
  connect_bd_net -net reset_n_Res [get_bd_pins reset_n/Res] [get_bd_pins sfp0_10gbe/reset]
  connect_bd_net -net s_axi_clk_peripherals_1 [get_bd_pins s_axi_clk_peripherals] [get_bd_pins sfp0_10gbe/dclk] [get_bd_pins sfp0_10gbe/s_axi_aclk] [get_bd_pins sfp0_dma/m_axi_sg_aclk] [get_bd_pins sfp0_dma/s_axi_lite_aclk]
  connect_bd_net -net s_axi_resetn_peripherals_1 [get_bd_pins s_axi_resetn_peripherals] [get_bd_pins reset_n/Op1] [get_bd_pins sfp0_10gbe/s_axi_aresetn] [get_bd_pins sfp0_dma/axi_resetn]
  connect_bd_net -net sfp0_10gbe_areset_datapathclk_out [get_bd_pins areset_datapathclk_out] [get_bd_pins sfp0_10gbe/areset_datapathclk_out]
  connect_bd_net -net sfp0_10gbe_coreclk_out [get_bd_pins coreclk_out] [get_bd_pins sfp0_10gbe/coreclk_out] [get_bd_pins sfp0_dma/m_axi_mm2s_aclk] [get_bd_pins sfp0_dma/m_axi_s2mm_aclk] [get_bd_pins sfp0_rx_fifo/s_axis_aclk] [get_bd_pins sfp0_tx_fifo/s_axis_aclk]
  connect_bd_net -net sfp0_10gbe_gtrxreset_out [get_bd_pins gtrxreset_out] [get_bd_pins sfp0_10gbe/gtrxreset_out]
  connect_bd_net -net sfp0_10gbe_gttxreset_out [get_bd_pins gttxreset_out] [get_bd_pins sfp0_10gbe/gttxreset_out]
  connect_bd_net -net sfp0_10gbe_qplllock_out [get_bd_pins qplllock] [get_bd_pins sfp0_10gbe/qplllock_out]
  connect_bd_net -net sfp0_10gbe_qplloutclk_out [get_bd_pins qplloutclk_out] [get_bd_pins sfp0_10gbe/qplloutclk_out]
  connect_bd_net -net sfp0_10gbe_qplloutrefclk_out [get_bd_pins qplloutrefclk_out] [get_bd_pins sfp0_10gbe/qplloutrefclk_out]
  connect_bd_net -net sfp0_10gbe_reset_counter_done_out [get_bd_pins reset_counter_done_out] [get_bd_pins sfp0_10gbe/reset_counter_done_out]
  connect_bd_net -net sfp0_10gbe_txn [get_bd_pins sfp0_txn] [get_bd_pins sfp0_10gbe/txn]
  connect_bd_net -net sfp0_10gbe_txp [get_bd_pins sfp0_txp] [get_bd_pins sfp0_10gbe/txp]
  connect_bd_net -net sfp0_10gbe_txuserrdy_out [get_bd_pins txuserrdy_out] [get_bd_pins sfp0_10gbe/txuserrdy_out]
  connect_bd_net -net sfp0_10gbe_txusrclk2_out [get_bd_pins txusrclk2_out] [get_bd_pins sfp0_10gbe/txusrclk2_out]
  connect_bd_net -net sfp0_10gbe_txusrclk_out [get_bd_pins txusrclk_out] [get_bd_pins sfp0_10gbe/txusrclk_out]
  connect_bd_net -net sfp0_dma_mm2s_introut [get_bd_pins sfp0_dma_tx_introut] [get_bd_pins sfp0_dma/mm2s_introut]
  connect_bd_net -net sfp0_dma_mm2s_prmry_reset_out_n [get_bd_pins sfp0_10gbe/tx_axis_aresetn] [get_bd_pins sfp0_dma/mm2s_prmry_reset_out_n]
  connect_bd_net -net sfp0_dma_s2mm_introut [get_bd_pins sfp0_dma_rx_introut] [get_bd_pins sfp0_dma/s2mm_introut]
  connect_bd_net -net sfp0_dma_s2mm_prmry_reset_out_n [get_bd_pins sfp0_10gbe/rx_axis_aresetn] [get_bd_pins sfp0_dma/s2mm_prmry_reset_out_n]
  connect_bd_net -net sfp0_rxn_1 [get_bd_pins sfp0_rxn] [get_bd_pins sfp0_10gbe/rxn]
  connect_bd_net -net sfp0_rxp_1 [get_bd_pins sfp0_rxp] [get_bd_pins sfp0_10gbe/rxp]
  connect_bd_net -net vcc_dout [get_bd_pins sfp0_10gbe/signal_detect] [get_bd_pins vcc/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: hdmi_out
proc create_hier_cell_hdmi_out { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_hdmi_out() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_CLKGEN

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_HDMI_TX

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_VDMA


  # Create pins
  create_bd_pin -dir I -type clk clk200M
  create_bd_pin -dir O -from 15 -to 0 hdmi_data
  create_bd_pin -dir O hdmi_data_e
  create_bd_pin -dir O hdmi_hsync
  create_bd_pin -dir O -type clk hdmi_out_clk
  create_bd_pin -dir O -type intr hdmi_out_vdma_intr
  create_bd_pin -dir O hdmi_vsync
  create_bd_pin -dir I -type clk s_axi_clk_peripherals
  create_bd_pin -dir I -type rst s_axi_resetn_peripherals

  # Create instance: clkgen_pixelclk, and set properties
  set clkgen_pixelclk [ create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 clkgen_pixelclk ]

  # Create instance: hdmi_tx, and set properties
  set hdmi_tx [ create_bd_cell -type ip -vlnv analog.com:user:axi_hdmi_tx:1.0 hdmi_tx ]
  set_property -dict [ list \
   CONFIG.INTERFACE {16_BIT} \
 ] $hdmi_tx

  # Create instance: vdma_hdmi_out, and set properties
  set vdma_hdmi_out [ create_bd_cell -type ip -vlnv analog.com:user:axi_dmac:1.0 vdma_hdmi_out ]
  set_property -dict [ list \
   CONFIG.CYCLIC {true} \
   CONFIG.DMA_2D_TRANSFER {true} \
   CONFIG.DMA_TYPE_DEST {1} \
   CONFIG.DMA_TYPE_SRC {0} \
 ] $vdma_hdmi_out

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_CLKGEN] [get_bd_intf_pins clkgen_pixelclk/s_axi]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_HDMI_TX] [get_bd_intf_pins hdmi_tx/s_axi]
  connect_bd_intf_net -intf_net S_AXI_VDMA_1 [get_bd_intf_pins S_AXI_VDMA] [get_bd_intf_pins vdma_hdmi_out/s_axi]
  connect_bd_intf_net -intf_net axi_dmac_0_m_axis [get_bd_intf_pins hdmi_tx/s_axis] [get_bd_intf_pins vdma_hdmi_out/m_axis]
  connect_bd_intf_net -intf_net axi_dmac_0_m_src_axi [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins vdma_hdmi_out/m_src_axi]

  # Create port connections
  connect_bd_net -net axi_dmac_0_irq [get_bd_pins hdmi_out_vdma_intr] [get_bd_pins vdma_hdmi_out/irq]
  connect_bd_net -net clk_1 [get_bd_pins clk200M] [get_bd_pins clkgen_pixelclk/clk]
  connect_bd_net -net clkgen_pixelclk_clk_0 [get_bd_pins clkgen_pixelclk/clk_0] [get_bd_pins hdmi_tx/hdmi_clk]
  connect_bd_net -net hdmi_tx_hdmi_16_data [get_bd_pins hdmi_data] [get_bd_pins hdmi_tx/hdmi_16_data]
  connect_bd_net -net hdmi_tx_hdmi_16_data_e [get_bd_pins hdmi_data_e] [get_bd_pins hdmi_tx/hdmi_16_data_e]
  connect_bd_net -net hdmi_tx_hdmi_16_hsync [get_bd_pins hdmi_hsync] [get_bd_pins hdmi_tx/hdmi_16_hsync]
  connect_bd_net -net hdmi_tx_hdmi_16_vsync [get_bd_pins hdmi_vsync] [get_bd_pins hdmi_tx/hdmi_16_vsync]
  connect_bd_net -net hdmi_tx_hdmi_out_clk [get_bd_pins hdmi_out_clk] [get_bd_pins hdmi_tx/hdmi_out_clk]
  connect_bd_net -net s_axi_aclk_0_1 [get_bd_pins s_axi_clk_peripherals] [get_bd_pins clkgen_pixelclk/s_axi_aclk] [get_bd_pins hdmi_tx/s_axi_aclk] [get_bd_pins hdmi_tx/vdma_clk] [get_bd_pins vdma_hdmi_out/m_axis_aclk] [get_bd_pins vdma_hdmi_out/m_src_axi_aclk] [get_bd_pins vdma_hdmi_out/s_axi_aclk]
  connect_bd_net -net s_axi_aresetn_1 [get_bd_pins s_axi_resetn_peripherals] [get_bd_pins clkgen_pixelclk/s_axi_aresetn] [get_bd_pins hdmi_tx/s_axi_aresetn] [get_bd_pins vdma_hdmi_out/m_src_axi_aresetn] [get_bd_pins vdma_hdmi_out/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ethernet_10gbe
proc create_hier_cell_ethernet_10gbe { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_ethernet_10gbe() - Empty argument(s)!"}
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
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_DMA_10GBE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SFP0_DMA

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SFP0_MAC

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SFP1_DMA

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_SFP1_MAC


  # Create pins
  create_bd_pin -dir I phy_refclk_n
  create_bd_pin -dir I phy_refclk_p
  create_bd_pin -dir O qplllock
  create_bd_pin -dir I -type clk s_axi_clk_peripherals
  create_bd_pin -dir I -type rst s_axi_resetn_peripherals
  create_bd_pin -dir O -type intr sfp0_dma_rx_introut
  create_bd_pin -dir O -type intr sfp0_dma_tx_introut
  create_bd_pin -dir I sfp0_rxn
  create_bd_pin -dir I sfp0_rxp
  create_bd_pin -dir O sfp0_txn
  create_bd_pin -dir O sfp0_txp
  create_bd_pin -dir O -type intr sfp1_dma_rx_introut
  create_bd_pin -dir O -type intr sfp1_dma_tx_introut
  create_bd_pin -dir I sfp1_rxn
  create_bd_pin -dir I sfp1_rxp
  create_bd_pin -dir O sfp1_txn
  create_bd_pin -dir O sfp1_txp

  # Create instance: dma_interconnect, and set properties
  set dma_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 dma_interconnect ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {6} \
 ] $dma_interconnect

  # Create instance: gtrxreset_n, and set properties
  set gtrxreset_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 gtrxreset_n ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $gtrxreset_n

  # Create instance: gttxreset_n, and set properties
  set gttxreset_n [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 gttxreset_n ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $gttxreset_n

  # Create instance: sfp0
  create_hier_cell_sfp0 $hier_obj sfp0

  # Create instance: sfp1
  create_hier_cell_sfp1 $hier_obj sfp1

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_DMA_10GBE] [get_bd_intf_pins dma_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins dma_interconnect/S00_AXI] [get_bd_intf_pins sfp0/M_AXI_SG]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins dma_interconnect/S01_AXI] [get_bd_intf_pins sfp0/M_AXI_MM2S]
  connect_bd_intf_net -intf_net S02_AXI_1 [get_bd_intf_pins dma_interconnect/S02_AXI] [get_bd_intf_pins sfp0/M_AXI_S2MM]
  connect_bd_intf_net -intf_net S03_AXI_1 [get_bd_intf_pins dma_interconnect/S03_AXI] [get_bd_intf_pins sfp1/M_AXI_SG]
  connect_bd_intf_net -intf_net S04_AXI_1 [get_bd_intf_pins dma_interconnect/S04_AXI] [get_bd_intf_pins sfp1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net S05_AXI_1 [get_bd_intf_pins dma_interconnect/S05_AXI] [get_bd_intf_pins sfp1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net S_AXI_SFP0_DMA_1 [get_bd_intf_pins S_AXI_SFP0_DMA] [get_bd_intf_pins sfp0/S_AXI_SFP0_DMA]
  connect_bd_intf_net -intf_net S_AXI_SFP0_MAC_1 [get_bd_intf_pins S_AXI_SFP0_MAC] [get_bd_intf_pins sfp0/S_AXI_SFP0_MAC]
  connect_bd_intf_net -intf_net S_AXI_SFP1_DMA_1 [get_bd_intf_pins S_AXI_SFP1_DMA] [get_bd_intf_pins sfp1/S_AXI_SFP1_DMA]
  connect_bd_intf_net -intf_net S_AXI_SFP1_MAC_1 [get_bd_intf_pins S_AXI_SFP1_MAC] [get_bd_intf_pins sfp1/S_AXI_SFP1_MAC]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins s_axi_clk_peripherals] [get_bd_pins dma_interconnect/ACLK] [get_bd_pins dma_interconnect/M00_ACLK] [get_bd_pins dma_interconnect/S00_ACLK] [get_bd_pins dma_interconnect/S03_ACLK] [get_bd_pins sfp0/s_axi_clk_peripherals] [get_bd_pins sfp1/s_axi_clk_peripherals]
  connect_bd_net -net S01_ACLK_1 [get_bd_pins dma_interconnect/S01_ACLK] [get_bd_pins dma_interconnect/S02_ACLK] [get_bd_pins dma_interconnect/S04_ACLK] [get_bd_pins dma_interconnect/S05_ACLK] [get_bd_pins sfp0/coreclk_out] [get_bd_pins sfp1/coreclk]
  connect_bd_net -net gtrxreset_n_Res [get_bd_pins dma_interconnect/S02_ARESETN] [get_bd_pins dma_interconnect/S05_ARESETN] [get_bd_pins gtrxreset_n/Res] [get_bd_pins sfp0/rx_path_aresetn] [get_bd_pins sfp1/rx_path_aresetn]
  connect_bd_net -net gttxreset_n_Res [get_bd_pins dma_interconnect/S01_ARESETN] [get_bd_pins dma_interconnect/S04_ARESETN] [get_bd_pins gttxreset_n/Res] [get_bd_pins sfp0/tx_path_aresetn] [get_bd_pins sfp1/tx_path_aresetn]
  connect_bd_net -net phy_refclk_n_1 [get_bd_pins phy_refclk_n] [get_bd_pins sfp0/phy_refclk_n]
  connect_bd_net -net phy_refclk_p_1 [get_bd_pins phy_refclk_p] [get_bd_pins sfp0/phy_refclk_p]
  connect_bd_net -net s_axi_resetn_peripherals_1 [get_bd_pins s_axi_resetn_peripherals] [get_bd_pins dma_interconnect/ARESETN] [get_bd_pins dma_interconnect/M00_ARESETN] [get_bd_pins dma_interconnect/S00_ARESETN] [get_bd_pins dma_interconnect/S03_ARESETN] [get_bd_pins sfp0/s_axi_resetn_peripherals] [get_bd_pins sfp1/s_axi_resetn_peripherals]
  connect_bd_net -net sfp0_areset_datapathclk_out [get_bd_pins sfp0/areset_datapathclk_out] [get_bd_pins sfp1/areset_coreclk]
  connect_bd_net -net sfp0_gtrxreset_out [get_bd_pins gtrxreset_n/Op1] [get_bd_pins sfp0/gtrxreset_out] [get_bd_pins sfp1/gtrxreset]
  connect_bd_net -net sfp0_gttxreset_out [get_bd_pins gttxreset_n/Op1] [get_bd_pins sfp0/gttxreset_out] [get_bd_pins sfp1/gttxreset]
  connect_bd_net -net sfp0_qplllock [get_bd_pins qplllock] [get_bd_pins sfp0/qplllock] [get_bd_pins sfp1/qplllock]
  connect_bd_net -net sfp0_qplloutclk_out [get_bd_pins sfp0/qplloutclk_out] [get_bd_pins sfp1/qplloutclk]
  connect_bd_net -net sfp0_qplloutrefclk_out [get_bd_pins sfp0/qplloutrefclk_out] [get_bd_pins sfp1/qplloutrefclk]
  connect_bd_net -net sfp0_reset_counter_done_out [get_bd_pins sfp0/reset_counter_done_out] [get_bd_pins sfp1/reset_counter_done]
  connect_bd_net -net sfp0_rxn_1 [get_bd_pins sfp0_rxn] [get_bd_pins sfp0/sfp0_rxn]
  connect_bd_net -net sfp0_rxp_1 [get_bd_pins sfp0_rxp] [get_bd_pins sfp0/sfp0_rxp]
  connect_bd_net -net sfp0_sfp0_dma_rx_introut [get_bd_pins sfp0_dma_rx_introut] [get_bd_pins sfp0/sfp0_dma_rx_introut]
  connect_bd_net -net sfp0_sfp0_dma_tx_introut [get_bd_pins sfp0_dma_tx_introut] [get_bd_pins sfp0/sfp0_dma_tx_introut]
  connect_bd_net -net sfp0_sfp0_txn [get_bd_pins sfp0_txn] [get_bd_pins sfp0/sfp0_txn]
  connect_bd_net -net sfp0_sfp0_txp [get_bd_pins sfp0_txp] [get_bd_pins sfp0/sfp0_txp]
  connect_bd_net -net sfp0_txuserrdy_out [get_bd_pins sfp0/txuserrdy_out] [get_bd_pins sfp1/txuserrdy]
  connect_bd_net -net sfp0_txusrclk2_out [get_bd_pins sfp0/txusrclk2_out] [get_bd_pins sfp1/txusrclk2]
  connect_bd_net -net sfp0_txusrclk_out [get_bd_pins sfp0/txusrclk_out] [get_bd_pins sfp1/txusrclk]
  connect_bd_net -net sfp1_rxn_1 [get_bd_pins sfp1_rxn] [get_bd_pins sfp1/sfp1_rxn]
  connect_bd_net -net sfp1_rxp_1 [get_bd_pins sfp1_rxp] [get_bd_pins sfp1/sfp1_rxp]
  connect_bd_net -net sfp1_sfp1_dma_rx_introut [get_bd_pins sfp1_dma_rx_introut] [get_bd_pins sfp1/sfp1_dma_rx_introut]
  connect_bd_net -net sfp1_sfp1_dma_tx_introut [get_bd_pins sfp1_dma_tx_introut] [get_bd_pins sfp1/sfp1_dma_tx_introut]
  connect_bd_net -net sfp1_sfp1_txn [get_bd_pins sfp1_txn] [get_bd_pins sfp1/sfp1_txn]
  connect_bd_net -net sfp1_sfp1_txp [get_bd_pins sfp1_txp] [get_bd_pins sfp1/sfp1_txp]

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
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]

  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]


  # Create ports
  set hdmi_data [ create_bd_port -dir O -from 15 -to 0 hdmi_data ]
  set hdmi_data_e [ create_bd_port -dir O hdmi_data_e ]
  set hdmi_hsync [ create_bd_port -dir O hdmi_hsync ]
  set hdmi_out_clk [ create_bd_port -dir O -type clk hdmi_out_clk ]
  set hdmi_vsync [ create_bd_port -dir O hdmi_vsync ]
  set phy_refclk_n [ create_bd_port -dir I phy_refclk_n ]
  set phy_refclk_p [ create_bd_port -dir I phy_refclk_p ]
  set qplllock [ create_bd_port -dir O qplllock ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset
  set sfp0_rxn [ create_bd_port -dir I sfp0_rxn ]
  set sfp0_rxp [ create_bd_port -dir I sfp0_rxp ]
  set sfp0_txn [ create_bd_port -dir O sfp0_txn ]
  set sfp0_txp [ create_bd_port -dir O sfp0_txp ]
  set sfp1_rxn [ create_bd_port -dir I sfp1_rxn ]
  set sfp1_rxp [ create_bd_port -dir I sfp1_rxp ]
  set sfp1_txn [ create_bd_port -dir O sfp1_txn ]
  set sfp1_txp [ create_bd_port -dir O sfp1_txp ]

  # Create instance: ethernet_10gbe
  create_hier_cell_ethernet_10gbe [current_bd_instance .] ethernet_10gbe

  # Create instance: hdmi_out
  create_hier_cell_hdmi_out [current_bd_instance .] hdmi_out

  # Create instance: int_concat, and set properties
  set int_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 int_concat ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {5} \
 ] $int_concat

  # Create instance: interconnect_peripherals, and set properties
  set interconnect_peripherals [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_peripherals ]
  set_property -dict [ list \
   CONFIG.NUM_MI {7} \
 ] $interconnect_peripherals

  # Create instance: interconnect_peripherals_dma, and set properties
  set interconnect_peripherals_dma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_peripherals_dma ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
 ] $interconnect_peripherals_dma

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {800.000000} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {142.857132} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {133.333344} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {800} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {48} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CLK0_FREQ {142857132} \
   CONFIG.PCW_CLK1_FREQ {200000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1600.000} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_DUAL_PARALLEL_QSPI_DATA_MODE {x8} \
   CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {1} \
   CONFIG.PCW_ENET0_RESET_IO {MIO 47} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {1} \
   CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {0} \
   CONFIG.PCW_EN_EMIO_GPIO {0} \
   CONFIG.PCW_EN_EMIO_I2C0 {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO0 {1} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_GPIO {1} \
   CONFIG.PCW_EN_I2C0 {1} \
   CONFIG.PCW_EN_QSPI {1} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_UART1 {1} \
   CONFIG.PCW_EN_USB0 {1} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {7} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {150} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {<Select>} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {64} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_I2C0_IO {MIO 50 .. 51} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_ENABLE {1} \
   CONFIG.PCW_I2C0_RESET_IO {MIO 46} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {133.333328} \
   CONFIG.PCW_I2C_RESET_ENABLE {1} \
   CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_MIO_0_DIRECTION {out} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {inout} \
   CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_15_PULLUP {enabled} \
   CONFIG.PCW_MIO_15_SLEW {slow} \
   CONFIG.PCW_MIO_16_DIRECTION {out} \
   CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_16_PULLUP {enabled} \
   CONFIG.PCW_MIO_16_SLEW {slow} \
   CONFIG.PCW_MIO_17_DIRECTION {out} \
   CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_17_PULLUP {enabled} \
   CONFIG.PCW_MIO_17_SLEW {slow} \
   CONFIG.PCW_MIO_18_DIRECTION {out} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {out} \
   CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_1_PULLUP {enabled} \
   CONFIG.PCW_MIO_1_SLEW {slow} \
   CONFIG.PCW_MIO_20_DIRECTION {out} \
   CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_20_PULLUP {enabled} \
   CONFIG.PCW_MIO_20_SLEW {slow} \
   CONFIG.PCW_MIO_21_DIRECTION {out} \
   CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_21_PULLUP {enabled} \
   CONFIG.PCW_MIO_21_SLEW {slow} \
   CONFIG.PCW_MIO_22_DIRECTION {in} \
   CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_22_PULLUP {enabled} \
   CONFIG.PCW_MIO_22_SLEW {slow} \
   CONFIG.PCW_MIO_23_DIRECTION {in} \
   CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_23_PULLUP {enabled} \
   CONFIG.PCW_MIO_23_SLEW {slow} \
   CONFIG.PCW_MIO_24_DIRECTION {in} \
   CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_24_PULLUP {enabled} \
   CONFIG.PCW_MIO_24_SLEW {slow} \
   CONFIG.PCW_MIO_25_DIRECTION {in} \
   CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_25_PULLUP {enabled} \
   CONFIG.PCW_MIO_25_SLEW {slow} \
   CONFIG.PCW_MIO_26_DIRECTION {in} \
   CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_26_PULLUP {enabled} \
   CONFIG.PCW_MIO_26_SLEW {slow} \
   CONFIG.PCW_MIO_27_DIRECTION {in} \
   CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_27_PULLUP {enabled} \
   CONFIG.PCW_MIO_27_SLEW {slow} \
   CONFIG.PCW_MIO_28_DIRECTION {inout} \
   CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_28_PULLUP {enabled} \
   CONFIG.PCW_MIO_28_SLEW {slow} \
   CONFIG.PCW_MIO_29_DIRECTION {in} \
   CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_29_PULLUP {enabled} \
   CONFIG.PCW_MIO_29_SLEW {slow} \
   CONFIG.PCW_MIO_2_DIRECTION {inout} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {out} \
   CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_30_PULLUP {enabled} \
   CONFIG.PCW_MIO_30_SLEW {slow} \
   CONFIG.PCW_MIO_31_DIRECTION {in} \
   CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_31_PULLUP {enabled} \
   CONFIG.PCW_MIO_31_SLEW {slow} \
   CONFIG.PCW_MIO_32_DIRECTION {inout} \
   CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_32_PULLUP {enabled} \
   CONFIG.PCW_MIO_32_SLEW {slow} \
   CONFIG.PCW_MIO_33_DIRECTION {inout} \
   CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_33_PULLUP {enabled} \
   CONFIG.PCW_MIO_33_SLEW {slow} \
   CONFIG.PCW_MIO_34_DIRECTION {inout} \
   CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_34_PULLUP {enabled} \
   CONFIG.PCW_MIO_34_SLEW {slow} \
   CONFIG.PCW_MIO_35_DIRECTION {inout} \
   CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_35_PULLUP {enabled} \
   CONFIG.PCW_MIO_35_SLEW {slow} \
   CONFIG.PCW_MIO_36_DIRECTION {in} \
   CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_36_PULLUP {enabled} \
   CONFIG.PCW_MIO_36_SLEW {slow} \
   CONFIG.PCW_MIO_37_DIRECTION {inout} \
   CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_37_PULLUP {enabled} \
   CONFIG.PCW_MIO_37_SLEW {slow} \
   CONFIG.PCW_MIO_38_DIRECTION {inout} \
   CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_38_PULLUP {enabled} \
   CONFIG.PCW_MIO_38_SLEW {slow} \
   CONFIG.PCW_MIO_39_DIRECTION {inout} \
   CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_39_PULLUP {enabled} \
   CONFIG.PCW_MIO_39_SLEW {slow} \
   CONFIG.PCW_MIO_3_DIRECTION {inout} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {out} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {out} \
   CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_47_PULLUP {enabled} \
   CONFIG.PCW_MIO_47_SLEW {slow} \
   CONFIG.PCW_MIO_48_DIRECTION {out} \
   CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_48_PULLUP {enabled} \
   CONFIG.PCW_MIO_48_SLEW {slow} \
   CONFIG.PCW_MIO_49_DIRECTION {in} \
   CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_49_PULLUP {enabled} \
   CONFIG.PCW_MIO_49_SLEW {slow} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {inout} \
   CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_50_PULLUP {enabled} \
   CONFIG.PCW_MIO_50_SLEW {slow} \
   CONFIG.PCW_MIO_51_DIRECTION {inout} \
   CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_51_PULLUP {enabled} \
   CONFIG.PCW_MIO_51_SLEW {slow} \
   CONFIG.PCW_MIO_52_DIRECTION {out} \
   CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_52_PULLUP {enabled} \
   CONFIG.PCW_MIO_52_SLEW {slow} \
   CONFIG.PCW_MIO_53_DIRECTION {inout} \
   CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_53_PULLUP {enabled} \
   CONFIG.PCW_MIO_53_SLEW {slow} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {out} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {out} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 1.8V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#USB Reset#GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#SD 0#GPIO#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#I2C Reset#ENET Reset#UART 1#UART 1#I2C 0#I2C 0#Enet 0#Enet 0} \
   CONFIG.PCW_MIO_TREE_SIGNALS {qspi1_ss_b#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]/HOLD_B#qspi0_sclk#reset#gpio[8]#qspi1_sclk#qspi1_io[0]#qspi1_io[1]#qspi1_io[2]#qspi1_io[3]#cd#gpio[15]#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#reset#reset#tx#rx#scl#sda#mdc#mdio} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {1} \
   CONFIG.PCW_QSPI_GRP_IO1_IO {MIO 0 9 .. 13} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFDFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {5} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 14} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_WP_IO {EMIO} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART1_UART1_IO {MIO 48 .. 49} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {10} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.482} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.484} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.418} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.416} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {5.000000} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {8192 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.077} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.074} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {-0.058} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {-0.054} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {32 Bits} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {Custom} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {45} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {36} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {49.5} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
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
   CONFIG.PCW_USE_S_AXI_GP0 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {1} \
   CONFIG.PCW_USE_S_AXI_HP2 {1} \
 ] $processing_system7_0

  # Create instance: reset_peripherals, and set properties
  set reset_peripherals [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_peripherals ]

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins interconnect_peripherals/S00_AXI] [get_bd_intf_pins processing_system7_0/M_AXI_GP0]
  connect_bd_intf_net -intf_net S00_AXI_2 [get_bd_intf_pins hdmi_out/M_AXI_MM2S] [get_bd_intf_pins interconnect_peripherals_dma/S00_AXI]
  connect_bd_intf_net -intf_net S_AXI_CLKGEN_1 [get_bd_intf_pins hdmi_out/S_AXI_CLKGEN] [get_bd_intf_pins interconnect_peripherals/M00_AXI]
  connect_bd_intf_net -intf_net S_AXI_HDMI_TX_1 [get_bd_intf_pins hdmi_out/S_AXI_HDMI_TX] [get_bd_intf_pins interconnect_peripherals/M01_AXI]
  connect_bd_intf_net -intf_net S_AXI_SFP0_DMA_1 [get_bd_intf_pins ethernet_10gbe/S_AXI_SFP0_DMA] [get_bd_intf_pins interconnect_peripherals/M03_AXI]
  connect_bd_intf_net -intf_net S_AXI_SFP0_MAC_1 [get_bd_intf_pins ethernet_10gbe/S_AXI_SFP0_MAC] [get_bd_intf_pins interconnect_peripherals/M04_AXI]
  connect_bd_intf_net -intf_net S_AXI_SFP1_DMA_1 [get_bd_intf_pins ethernet_10gbe/S_AXI_SFP1_DMA] [get_bd_intf_pins interconnect_peripherals/M05_AXI]
  connect_bd_intf_net -intf_net S_AXI_SFP1_MAC_1 [get_bd_intf_pins ethernet_10gbe/S_AXI_SFP1_MAC] [get_bd_intf_pins interconnect_peripherals/M06_AXI]
  connect_bd_intf_net -intf_net S_AXI_VDMA_1 [get_bd_intf_pins hdmi_out/S_AXI_VDMA] [get_bd_intf_pins interconnect_peripherals/M02_AXI]
  connect_bd_intf_net -intf_net ethernet_10gbe_M00_AXI [get_bd_intf_pins ethernet_10gbe/M_DMA_10GBE] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net interconnect_peripherals_dma_M00_AXI [get_bd_intf_pins interconnect_peripherals_dma/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP2]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]

  # Create port connections
  connect_bd_net -net ethernet_10gbe_qplllock [get_bd_ports qplllock] [get_bd_pins ethernet_10gbe/qplllock]
  connect_bd_net -net ethernet_10gbe_s2mm_introut [get_bd_pins ethernet_10gbe/sfp0_dma_rx_introut] [get_bd_pins int_concat/In2]
  connect_bd_net -net ethernet_10gbe_sfp0_dma_tx_introut [get_bd_pins ethernet_10gbe/sfp0_dma_tx_introut] [get_bd_pins int_concat/In1]
  connect_bd_net -net ethernet_10gbe_sfp1_dma_rx_introut [get_bd_pins ethernet_10gbe/sfp1_dma_rx_introut] [get_bd_pins int_concat/In4]
  connect_bd_net -net ethernet_10gbe_sfp1_dma_tx_introut [get_bd_pins ethernet_10gbe/sfp1_dma_tx_introut] [get_bd_pins int_concat/In3]
  connect_bd_net -net ethernet_10gbe_sfp1_txn [get_bd_ports sfp1_txn] [get_bd_pins ethernet_10gbe/sfp1_txn]
  connect_bd_net -net ethernet_10gbe_sfp1_txp [get_bd_ports sfp1_txp] [get_bd_pins ethernet_10gbe/sfp1_txp]
  connect_bd_net -net ethernet_10gbe_txn [get_bd_ports sfp0_txn] [get_bd_pins ethernet_10gbe/sfp0_txn]
  connect_bd_net -net ethernet_10gbe_txp [get_bd_ports sfp0_txp] [get_bd_pins ethernet_10gbe/sfp0_txp]
  connect_bd_net -net ext_reset_in_0_1 [get_bd_ports reset] [get_bd_pins reset_peripherals/ext_reset_in]
  connect_bd_net -net hdmi_out_hdmi_16_data_0 [get_bd_ports hdmi_data] [get_bd_pins hdmi_out/hdmi_data]
  connect_bd_net -net hdmi_out_hdmi_16_data_e_0 [get_bd_ports hdmi_data_e] [get_bd_pins hdmi_out/hdmi_data_e]
  connect_bd_net -net hdmi_out_hdmi_16_hsync_0 [get_bd_ports hdmi_hsync] [get_bd_pins hdmi_out/hdmi_hsync]
  connect_bd_net -net hdmi_out_hdmi_16_vsync_0 [get_bd_ports hdmi_vsync] [get_bd_pins hdmi_out/hdmi_vsync]
  connect_bd_net -net hdmi_out_hdmi_out_clk_0 [get_bd_ports hdmi_out_clk] [get_bd_pins hdmi_out/hdmi_out_clk]
  connect_bd_net -net hdmi_out_hdmi_out_vdma_intr [get_bd_pins hdmi_out/hdmi_out_vdma_intr] [get_bd_pins int_concat/In0]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins interconnect_peripherals/ARESETN] [get_bd_pins interconnect_peripherals_dma/ARESETN] [get_bd_pins reset_peripherals/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins ethernet_10gbe/s_axi_resetn_peripherals] [get_bd_pins hdmi_out/s_axi_resetn_peripherals] [get_bd_pins interconnect_peripherals/M00_ARESETN] [get_bd_pins interconnect_peripherals/M01_ARESETN] [get_bd_pins interconnect_peripherals/M02_ARESETN] [get_bd_pins interconnect_peripherals/M03_ARESETN] [get_bd_pins interconnect_peripherals/M04_ARESETN] [get_bd_pins interconnect_peripherals/M05_ARESETN] [get_bd_pins interconnect_peripherals/M06_ARESETN] [get_bd_pins interconnect_peripherals/S00_ARESETN] [get_bd_pins interconnect_peripherals_dma/M00_ARESETN] [get_bd_pins interconnect_peripherals_dma/S00_ARESETN] [get_bd_pins reset_peripherals/peripheral_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins ethernet_10gbe/s_axi_clk_peripherals] [get_bd_pins hdmi_out/s_axi_clk_peripherals] [get_bd_pins interconnect_peripherals/ACLK] [get_bd_pins interconnect_peripherals/M00_ACLK] [get_bd_pins interconnect_peripherals/M01_ACLK] [get_bd_pins interconnect_peripherals/M02_ACLK] [get_bd_pins interconnect_peripherals/M03_ACLK] [get_bd_pins interconnect_peripherals/M04_ACLK] [get_bd_pins interconnect_peripherals/M05_ACLK] [get_bd_pins interconnect_peripherals/M06_ACLK] [get_bd_pins interconnect_peripherals/S00_ACLK] [get_bd_pins interconnect_peripherals_dma/ACLK] [get_bd_pins interconnect_peripherals_dma/M00_ACLK] [get_bd_pins interconnect_peripherals_dma/S00_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP2_ACLK] [get_bd_pins reset_peripherals/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins hdmi_out/clk200M] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins reset_peripherals/aux_reset_in]
  connect_bd_net -net refclk_n_1 [get_bd_ports phy_refclk_n] [get_bd_pins ethernet_10gbe/phy_refclk_n]
  connect_bd_net -net refclk_p_1 [get_bd_ports phy_refclk_p] [get_bd_pins ethernet_10gbe/phy_refclk_p]
  connect_bd_net -net rxn_1 [get_bd_ports sfp0_rxn] [get_bd_pins ethernet_10gbe/sfp0_rxn]
  connect_bd_net -net rxp_1 [get_bd_ports sfp0_rxp] [get_bd_pins ethernet_10gbe/sfp0_rxp]
  connect_bd_net -net sfp1_rxn_0_1 [get_bd_ports sfp1_rxn] [get_bd_pins ethernet_10gbe/sfp1_rxn]
  connect_bd_net -net sfp1_rxp_0_1 [get_bd_ports sfp1_rxp] [get_bd_pins ethernet_10gbe/sfp1_rxp]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins int_concat/dout] [get_bd_pins processing_system7_0/IRQ_F2P]

  # Create address segments
  assign_bd_address -offset 0x41000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs hdmi_out/clkgen_pixelclk/s_axi/axi_lite] -force
  assign_bd_address -offset 0x41020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs hdmi_out/hdmi_tx/s_axi/axi_lite] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ethernet_10gbe/sfp0/sfp0_10gbe/s_axi/Reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ethernet_10gbe/sfp0/sfp0_dma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x40030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ethernet_10gbe/sfp1/sfp1_10gbe/s_axi/Reg0] -force
  assign_bd_address -offset 0x40020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs ethernet_10gbe/sfp1/sfp1_dma/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs hdmi_out/vdma_hdmi_out/s_axi/axi_lite] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces hdmi_out/vdma_hdmi_out/m_src_axi] [get_bd_addr_segs processing_system7_0/S_AXI_HP2/HP2_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces ethernet_10gbe/sfp0/sfp0_dma/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces ethernet_10gbe/sfp0/sfp0_dma/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces ethernet_10gbe/sfp0/sfp0_dma/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces ethernet_10gbe/sfp1/sfp1_dma/Data_SG] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces ethernet_10gbe/sfp1/sfp1_dma/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force
  assign_bd_address -offset 0x00000000 -range 0x40000000 -target_address_space [get_bd_addr_spaces ethernet_10gbe/sfp1/sfp1_dma/Data_S2MM] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] -force


  # Restore current instance
  current_bd_instance $oldCurInst

}
# End of create_root_design()




proc available_tcl_procs { } {
   puts "##################################################################"
   puts "# Available Tcl procedures to recreate hierarchical blocks:"
   puts "#"
   puts "#    create_hier_cell_ethernet_10gbe parentCell nameHier"
   puts "#    create_hier_cell_hdmi_out parentCell nameHier"
   puts "#    create_hier_cell_sfp0 parentCell nameHier"
   puts "#    create_hier_cell_sfp1 parentCell nameHier"
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
