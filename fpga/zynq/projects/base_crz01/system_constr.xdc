#######################################################
# Clock/period constraints                            #
#######################################################

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

# Main transmit clock/period constraints
set_property PACKAGE_PIN AA8 [get_ports phy_refclk_p]
#create_clock -period 6.400 -name gtx_refclk -waveform {0.000 3.200} [get_ports phy_refclk_p]

# Aux system related signals

set_property PACKAGE_PIN B6 [get_ports reset]
set_property IOSTANDARD LVCMOS15 [get_ports reset]

# SFP 0

set_property PACKAGE_PIN AE8 [get_ports sfp0_rxp]
set_property PACKAGE_PIN AK2 [get_ports sfp0_txp]

set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVCMOS15} [get_ports sfp0_tx_disable]

#WARNING: SFP0_RX_LOSS and SFP1_RX_LOSS are switched on the level shifter according to the schematic
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS18} [get_ports sfp0_rx_loss]

#WARNING: SFP0_TX_FAULT and SFP1_TX_FAULT are switched on the level shifter according to the schematic
set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS18} [get_ports sfp0_tx_fault]

#WARNING: moddef0 is broken on the board! It is an SFP output and FPGA input and wired wrong on a levelshifter
#The only reason why nothing is burning yet is that inside an SFP this pin gets pulled to GND via a 100 Ohm resistor
#set_property -dict {PACKAGE_PIN A7 IOSTANDARD LVCMOS15} [get_ports sfp0_moddef]

# SFP 1

set_property PACKAGE_PIN AG8 [get_ports sfp1_rxp]
set_property PACKAGE_PIN AJ4 [get_ports sfp1_txp]

set_property -dict {PACKAGE_PIN A9 IOSTANDARD LVCMOS15} [get_ports sfp1_tx_disable]

#WARNING: SFP0_RX_LOSS and SFP1_RX_LOSS are switched on the level shifter according to the schematic
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS18} [get_ports sfp1_rx_loss]

#WARNING: SFP0_TX_FAULT and SFP1_TX_FAULT are switched on the level shifter according to the schematic
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18} [get_ports sfp1_tx_fault]

#WARNING: moddef0 is broken on the board! It is an SFP output and FPGA input and wired wrong on a levelshifter
#The only reason why nothing is burning yet is that inside an SFP this pin gets pulled to GND via a 100 Ohm resistor
#set_property -dict {PACKAGE_PIN B9 IOSTANDARD LVCMOS15} [get_ports sfp1_moddef]

# HDMI

set_property -dict {PACKAGE_PIN  L13  IOSTANDARD LVCMOS18} [get_ports hdmi_out_clk]
set_property -dict {PACKAGE_PIN  D15  IOSTANDARD LVCMOS18} [get_ports hdmi_vsync]
set_property -dict {PACKAGE_PIN  B12  IOSTANDARD LVCMOS18} [get_ports hdmi_hsync]
set_property -dict {PACKAGE_PIN  C12  IOSTANDARD LVCMOS18} [get_ports hdmi_data_e]
set_property -dict {PACKAGE_PIN  C13  IOSTANDARD LVCMOS18} [get_ports hdmi_data[0]]
set_property -dict {PACKAGE_PIN  C14  IOSTANDARD LVCMOS18} [get_ports hdmi_data[1]]
set_property -dict {PACKAGE_PIN  A12  IOSTANDARD LVCMOS18} [get_ports hdmi_data[2]]
set_property -dict {PACKAGE_PIN  A13  IOSTANDARD LVCMOS18} [get_ports hdmi_data[3]]
set_property -dict {PACKAGE_PIN  A14  IOSTANDARD LVCMOS18} [get_ports hdmi_data[4]]
set_property -dict {PACKAGE_PIN  B14  IOSTANDARD LVCMOS18} [get_ports hdmi_data[5]]
set_property -dict {PACKAGE_PIN  H13  IOSTANDARD LVCMOS18} [get_ports hdmi_data[6]]
set_property -dict {PACKAGE_PIN  J13  IOSTANDARD LVCMOS18} [get_ports hdmi_data[7]]
set_property -dict {PACKAGE_PIN  H14  IOSTANDARD LVCMOS18} [get_ports hdmi_data[8]]
set_property -dict {PACKAGE_PIN  J14  IOSTANDARD LVCMOS18} [get_ports hdmi_data[9]]
set_property -dict {PACKAGE_PIN  L14  IOSTANDARD LVCMOS18} [get_ports hdmi_data[10]]
set_property -dict {PACKAGE_PIN  L15  IOSTANDARD LVCMOS18} [get_ports hdmi_data[11]]
set_property -dict {PACKAGE_PIN  K13  IOSTANDARD LVCMOS18} [get_ports hdmi_data[12]]
set_property -dict {PACKAGE_PIN  B11  IOSTANDARD LVCMOS18} [get_ports hdmi_data[13]]
set_property -dict {PACKAGE_PIN  C11  IOSTANDARD LVCMOS18} [get_ports hdmi_data[14]]
set_property -dict {PACKAGE_PIN  E17  IOSTANDARD LVCMOS18} [get_ports hdmi_data[15]]
#set_property -dict {PACKAGE_PIN  F17  IOSTANDARD LVCMOS18} [get_ports hdmi_int]
#set_property -dict {PACKAGE_PIN  D14  IOSTANDARD LVCMOS18} [get_ports spdif]

# LEDs
set_property -dict {PACKAGE_PIN  C17  IOSTANDARD LVCMOS18} [get_ports led1]
#set_property -dict {PACKAGE_PIN  B16  IOSTANDARD LVCMOS18} [get_ports led2]
#set_property -dict {PACKAGE_PIN  G12  IOSTANDARD LVCMOS18} [get_ports led3]
#set_property -dict {PACKAGE_PIN  F12  IOSTANDARD LVCMOS18} [get_ports led4]

# User input

#set_property PACKAGE_PIN L10 [get_ports {start[0]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {start[0]}]
#set_property PACKAGE_PIN L9 [get_ports {start[1]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {start[1]}]
#set_property PACKAGE_PIN C6 [get_ports {start[2]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {start[2]}]

#set_property PACKAGE_PIN K12 [get_ports {dip_switches[0]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {dip_switches[0]}]
#set_property PULLDOWN true [get_ports {dip_switches[0]}]
#set_property PACKAGE_PIN L12 [get_ports {dip_switches[1]}]
#set_property IOSTANDARD LVCMOS15 [get_ports {dip_switches[1]}]
#set_property PULLDOWN true [get_ports {dip_switches[1]}]



