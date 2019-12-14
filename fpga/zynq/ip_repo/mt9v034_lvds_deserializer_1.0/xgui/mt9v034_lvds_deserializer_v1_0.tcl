# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "IBUF_LOW_PWR" -widget comboBox
  ipgui::add_param $IPINST -name "DIFF_TERM" -widget comboBox
  ipgui::add_param $IPINST -name "IOSTANDARD"

}

proc update_PARAM_VALUE.DIFF_TERM { PARAM_VALUE.DIFF_TERM } {
	# Procedure called to update DIFF_TERM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIFF_TERM { PARAM_VALUE.DIFF_TERM } {
	# Procedure called to validate DIFF_TERM
	return true
}

proc update_PARAM_VALUE.IBUF_LOW_PWR { PARAM_VALUE.IBUF_LOW_PWR } {
	# Procedure called to update IBUF_LOW_PWR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IBUF_LOW_PWR { PARAM_VALUE.IBUF_LOW_PWR } {
	# Procedure called to validate IBUF_LOW_PWR
	return true
}

proc update_PARAM_VALUE.IOSTANDARD { PARAM_VALUE.IOSTANDARD } {
	# Procedure called to update IOSTANDARD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IOSTANDARD { PARAM_VALUE.IOSTANDARD } {
	# Procedure called to validate IOSTANDARD
	return true
}


proc update_MODELPARAM_VALUE.IBUF_LOW_PWR { MODELPARAM_VALUE.IBUF_LOW_PWR PARAM_VALUE.IBUF_LOW_PWR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IBUF_LOW_PWR}] ${MODELPARAM_VALUE.IBUF_LOW_PWR}
}

proc update_MODELPARAM_VALUE.DIFF_TERM { MODELPARAM_VALUE.DIFF_TERM PARAM_VALUE.DIFF_TERM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIFF_TERM}] ${MODELPARAM_VALUE.DIFF_TERM}
}

proc update_MODELPARAM_VALUE.IOSTANDARD { MODELPARAM_VALUE.IOSTANDARD PARAM_VALUE.IOSTANDARD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IOSTANDARD}] ${MODELPARAM_VALUE.IOSTANDARD}
}

