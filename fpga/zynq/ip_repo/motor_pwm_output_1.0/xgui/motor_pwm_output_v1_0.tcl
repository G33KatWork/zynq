# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {IP Configuration}]
  set_property tooltip {IP Configuration} ${Page_0}
  #Adding Group
  set Parameters [ipgui::add_group $IPINST -name "Parameters" -parent ${Page_0} -display_name {AXI Motor PWM Output}]
  set_property tooltip {AXI Motor PWM Output} ${Parameters}
  ipgui::add_param $IPINST -name "C_S_AXI_ACLK_FREQ_HZ" -parent ${Parameters}
  ipgui::add_param $IPINST -name "NUMBER_OF_MOTORS" -parent ${Parameters}



}

proc update_PARAM_VALUE.C_S_AXI_ACLK_FREQ_HZ { PARAM_VALUE.C_S_AXI_ACLK_FREQ_HZ } {
	# Procedure called to update C_S_AXI_ACLK_FREQ_HZ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ACLK_FREQ_HZ { PARAM_VALUE.C_S_AXI_ACLK_FREQ_HZ } {
	# Procedure called to validate C_S_AXI_ACLK_FREQ_HZ
	return true
}

proc update_PARAM_VALUE.NUMBER_OF_MOTORS { PARAM_VALUE.NUMBER_OF_MOTORS } {
	# Procedure called to update NUMBER_OF_MOTORS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUMBER_OF_MOTORS { PARAM_VALUE.NUMBER_OF_MOTORS } {
	# Procedure called to validate NUMBER_OF_MOTORS
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXI_ACLK_FREQ_HZ { MODELPARAM_VALUE.C_S_AXI_ACLK_FREQ_HZ PARAM_VALUE.C_S_AXI_ACLK_FREQ_HZ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ACLK_FREQ_HZ}] ${MODELPARAM_VALUE.C_S_AXI_ACLK_FREQ_HZ}
}

proc update_MODELPARAM_VALUE.NUMBER_OF_MOTORS { MODELPARAM_VALUE.NUMBER_OF_MOTORS PARAM_VALUE.NUMBER_OF_MOTORS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUMBER_OF_MOTORS}] ${MODELPARAM_VALUE.NUMBER_OF_MOTORS}
}

