
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/mt9v034_deserializer_unit_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  #Adding Group
  set I/O_Configuration [ipgui::add_group $IPINST -name "I/O Configuration" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "IDELAYCTRL_REFCLK" -parent ${I/O_Configuration}
  set IOSTANDARD [ipgui::add_param $IPINST -name "IOSTANDARD" -parent ${I/O_Configuration}]
  set_property tooltip {IOSTANDARD} ${IOSTANDARD}
  ipgui::add_param $IPINST -name "DIFF_TERM" -parent ${I/O_Configuration} -widget comboBox
  ipgui::add_param $IPINST -name "IBUF_LOW_PWR" -parent ${I/O_Configuration} -widget comboBox
  set C_IdlyCntVal_M [ipgui::add_param $IPINST -name "C_IdlyCntVal_M" -parent ${I/O_Configuration}]
  set_property tooltip {Delay count for positive input pin} ${C_IdlyCntVal_M}
  set C_IdlyCntVal_S [ipgui::add_param $IPINST -name "C_IdlyCntVal_S" -parent ${I/O_Configuration}]
  set_property tooltip {Delay count for negative input pin} ${C_IdlyCntVal_S}

  #Adding Group
  set Deserializer_Configuration [ipgui::add_group $IPINST -name "Deserializer Configuration" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "GUI_STEREO_MODE" -parent ${Deserializer_Configuration}
  ipgui::add_param $IPINST -name "GUI_USE_EMBEDDED_SYNCS" -parent ${Deserializer_Configuration}
  ipgui::add_param $IPINST -name "GUI_VIDEO_BIT_WIDTH" -parent ${Deserializer_Configuration} -layout horizontal

  #Adding Group
  set Resulting_Configuration [ipgui::add_group $IPINST -name "Resulting Configuration" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "STEREO_MODE" -parent ${Resulting_Configuration}
  ipgui::add_param $IPINST -name "USE_EMBEDDED_SYNCS" -parent ${Resulting_Configuration}
  ipgui::add_param $IPINST -name "VIDEO_BIT_WIDTH" -parent ${Resulting_Configuration}



}

proc update_PARAM_VALUE.GUI_USE_EMBEDDED_SYNCS { PARAM_VALUE.GUI_USE_EMBEDDED_SYNCS PARAM_VALUE.GUI_STEREO_MODE } {
	# Procedure called to update GUI_USE_EMBEDDED_SYNCS when any of the dependent parameters in the arguments change
	
	set GUI_USE_EMBEDDED_SYNCS ${PARAM_VALUE.GUI_USE_EMBEDDED_SYNCS}
	set GUI_STEREO_MODE ${PARAM_VALUE.GUI_STEREO_MODE}
	set values(GUI_STEREO_MODE) [get_property value $GUI_STEREO_MODE]
	if { [gen_USERPARAMETER_GUI_USE_EMBEDDED_SYNCS_ENABLEMENT $values(GUI_STEREO_MODE)] } {
		set_property enabled true $GUI_USE_EMBEDDED_SYNCS
	} else {
		set_property enabled false $GUI_USE_EMBEDDED_SYNCS
	}
}

proc validate_PARAM_VALUE.GUI_USE_EMBEDDED_SYNCS { PARAM_VALUE.GUI_USE_EMBEDDED_SYNCS } {
	# Procedure called to validate GUI_USE_EMBEDDED_SYNCS
	return true
}

proc update_PARAM_VALUE.GUI_VIDEO_BIT_WIDTH { PARAM_VALUE.GUI_VIDEO_BIT_WIDTH PARAM_VALUE.USE_EMBEDDED_SYNCS PARAM_VALUE.STEREO_MODE } {
	# Procedure called to update GUI_VIDEO_BIT_WIDTH when any of the dependent parameters in the arguments change
	
	set GUI_VIDEO_BIT_WIDTH ${PARAM_VALUE.GUI_VIDEO_BIT_WIDTH}
	set USE_EMBEDDED_SYNCS ${PARAM_VALUE.USE_EMBEDDED_SYNCS}
	set STEREO_MODE ${PARAM_VALUE.STEREO_MODE}
	set values(USE_EMBEDDED_SYNCS) [get_property value $USE_EMBEDDED_SYNCS]
	set values(STEREO_MODE) [get_property value $STEREO_MODE]
	if { [gen_USERPARAMETER_GUI_VIDEO_BIT_WIDTH_ENABLEMENT $values(USE_EMBEDDED_SYNCS) $values(STEREO_MODE)] } {
		set_property enabled true $GUI_VIDEO_BIT_WIDTH
	} else {
		set_property enabled false $GUI_VIDEO_BIT_WIDTH
	}
}

proc validate_PARAM_VALUE.GUI_VIDEO_BIT_WIDTH { PARAM_VALUE.GUI_VIDEO_BIT_WIDTH } {
	# Procedure called to validate GUI_VIDEO_BIT_WIDTH
	return true
}

proc update_PARAM_VALUE.STEREO_MODE { PARAM_VALUE.STEREO_MODE PARAM_VALUE.GUI_STEREO_MODE } {
	# Procedure called to update STEREO_MODE when any of the dependent parameters in the arguments change
	
	set STEREO_MODE ${PARAM_VALUE.STEREO_MODE}
	set GUI_STEREO_MODE ${PARAM_VALUE.GUI_STEREO_MODE}
	set values(GUI_STEREO_MODE) [get_property value $GUI_STEREO_MODE]
	set_property value [gen_USERPARAMETER_STEREO_MODE_VALUE $values(GUI_STEREO_MODE)] $STEREO_MODE
}

proc validate_PARAM_VALUE.STEREO_MODE { PARAM_VALUE.STEREO_MODE } {
	# Procedure called to validate STEREO_MODE
	return true
}

proc update_PARAM_VALUE.USE_EMBEDDED_SYNCS { PARAM_VALUE.USE_EMBEDDED_SYNCS PARAM_VALUE.GUI_STEREO_MODE PARAM_VALUE.GUI_USE_EMBEDDED_SYNCS } {
	# Procedure called to update USE_EMBEDDED_SYNCS when any of the dependent parameters in the arguments change
	
	set USE_EMBEDDED_SYNCS ${PARAM_VALUE.USE_EMBEDDED_SYNCS}
	set GUI_STEREO_MODE ${PARAM_VALUE.GUI_STEREO_MODE}
	set GUI_USE_EMBEDDED_SYNCS ${PARAM_VALUE.GUI_USE_EMBEDDED_SYNCS}
	set values(GUI_STEREO_MODE) [get_property value $GUI_STEREO_MODE]
	set values(GUI_USE_EMBEDDED_SYNCS) [get_property value $GUI_USE_EMBEDDED_SYNCS]
	set_property value [gen_USERPARAMETER_USE_EMBEDDED_SYNCS_VALUE $values(GUI_STEREO_MODE) $values(GUI_USE_EMBEDDED_SYNCS)] $USE_EMBEDDED_SYNCS
}

proc validate_PARAM_VALUE.USE_EMBEDDED_SYNCS { PARAM_VALUE.USE_EMBEDDED_SYNCS } {
	# Procedure called to validate USE_EMBEDDED_SYNCS
	return true
}

proc update_PARAM_VALUE.VIDEO_BIT_WIDTH { PARAM_VALUE.VIDEO_BIT_WIDTH PARAM_VALUE.USE_EMBEDDED_SYNCS PARAM_VALUE.STEREO_MODE PARAM_VALUE.GUI_VIDEO_BIT_WIDTH } {
	# Procedure called to update VIDEO_BIT_WIDTH when any of the dependent parameters in the arguments change
	
	set VIDEO_BIT_WIDTH ${PARAM_VALUE.VIDEO_BIT_WIDTH}
	set USE_EMBEDDED_SYNCS ${PARAM_VALUE.USE_EMBEDDED_SYNCS}
	set STEREO_MODE ${PARAM_VALUE.STEREO_MODE}
	set GUI_VIDEO_BIT_WIDTH ${PARAM_VALUE.GUI_VIDEO_BIT_WIDTH}
	set values(USE_EMBEDDED_SYNCS) [get_property value $USE_EMBEDDED_SYNCS]
	set values(STEREO_MODE) [get_property value $STEREO_MODE]
	set values(GUI_VIDEO_BIT_WIDTH) [get_property value $GUI_VIDEO_BIT_WIDTH]
	set_property value [gen_USERPARAMETER_VIDEO_BIT_WIDTH_VALUE $values(USE_EMBEDDED_SYNCS) $values(STEREO_MODE) $values(GUI_VIDEO_BIT_WIDTH)] $VIDEO_BIT_WIDTH
}

proc validate_PARAM_VALUE.VIDEO_BIT_WIDTH { PARAM_VALUE.VIDEO_BIT_WIDTH } {
	# Procedure called to validate VIDEO_BIT_WIDTH
	return true
}

proc update_PARAM_VALUE.C_IdlyCntVal_M { PARAM_VALUE.C_IdlyCntVal_M } {
	# Procedure called to update C_IdlyCntVal_M when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_IdlyCntVal_M { PARAM_VALUE.C_IdlyCntVal_M } {
	# Procedure called to validate C_IdlyCntVal_M
	return true
}

proc update_PARAM_VALUE.C_IdlyCntVal_S { PARAM_VALUE.C_IdlyCntVal_S } {
	# Procedure called to update C_IdlyCntVal_S when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_IdlyCntVal_S { PARAM_VALUE.C_IdlyCntVal_S } {
	# Procedure called to validate C_IdlyCntVal_S
	return true
}

proc update_PARAM_VALUE.DIFF_TERM { PARAM_VALUE.DIFF_TERM } {
	# Procedure called to update DIFF_TERM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIFF_TERM { PARAM_VALUE.DIFF_TERM } {
	# Procedure called to validate DIFF_TERM
	return true
}

proc update_PARAM_VALUE.GUI_STEREO_MODE { PARAM_VALUE.GUI_STEREO_MODE } {
	# Procedure called to update GUI_STEREO_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.GUI_STEREO_MODE { PARAM_VALUE.GUI_STEREO_MODE } {
	# Procedure called to validate GUI_STEREO_MODE
	return true
}

proc update_PARAM_VALUE.IBUF_LOW_PWR { PARAM_VALUE.IBUF_LOW_PWR } {
	# Procedure called to update IBUF_LOW_PWR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IBUF_LOW_PWR { PARAM_VALUE.IBUF_LOW_PWR } {
	# Procedure called to validate IBUF_LOW_PWR
	return true
}

proc update_PARAM_VALUE.IDELAYCTRL_REFCLK { PARAM_VALUE.IDELAYCTRL_REFCLK } {
	# Procedure called to update IDELAYCTRL_REFCLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IDELAYCTRL_REFCLK { PARAM_VALUE.IDELAYCTRL_REFCLK } {
	# Procedure called to validate IDELAYCTRL_REFCLK
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

proc update_MODELPARAM_VALUE.IDELAYCTRL_REFCLK { MODELPARAM_VALUE.IDELAYCTRL_REFCLK PARAM_VALUE.IDELAYCTRL_REFCLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IDELAYCTRL_REFCLK}] ${MODELPARAM_VALUE.IDELAYCTRL_REFCLK}
}

proc update_MODELPARAM_VALUE.USE_EMBEDDED_SYNCS { MODELPARAM_VALUE.USE_EMBEDDED_SYNCS PARAM_VALUE.USE_EMBEDDED_SYNCS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USE_EMBEDDED_SYNCS}] ${MODELPARAM_VALUE.USE_EMBEDDED_SYNCS}
}

proc update_MODELPARAM_VALUE.VIDEO_BIT_WIDTH { MODELPARAM_VALUE.VIDEO_BIT_WIDTH PARAM_VALUE.VIDEO_BIT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VIDEO_BIT_WIDTH}] ${MODELPARAM_VALUE.VIDEO_BIT_WIDTH}
}

proc update_MODELPARAM_VALUE.STEREO_MODE { MODELPARAM_VALUE.STEREO_MODE PARAM_VALUE.STEREO_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STEREO_MODE}] ${MODELPARAM_VALUE.STEREO_MODE}
}

proc update_MODELPARAM_VALUE.C_IdlyCntVal_M { MODELPARAM_VALUE.C_IdlyCntVal_M PARAM_VALUE.C_IdlyCntVal_M } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_IdlyCntVal_M}] ${MODELPARAM_VALUE.C_IdlyCntVal_M}
}

proc update_MODELPARAM_VALUE.C_IdlyCntVal_S { MODELPARAM_VALUE.C_IdlyCntVal_S PARAM_VALUE.C_IdlyCntVal_S } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_IdlyCntVal_S}] ${MODELPARAM_VALUE.C_IdlyCntVal_S}
}

