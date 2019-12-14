# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {Location Constraints}]
  set_property tooltip {Location Constraints} ${Page_0}
  ipgui::add_param $IPINST -name "C_MmcmLoc" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_BufioClk0Loc" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_BufioClk90Loc" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_IdlyCtrlLoc" -parent ${Page_0}

  #Adding Page
  set Clock_Dividers [ipgui::add_page $IPINST -name "Clock Dividers" -display_name {Clock Configuration}]
  set_property tooltip {Clock Configuration} ${Clock_Dividers}
  ipgui::add_param $IPINST -name "C_ClkinPeriod" -parent ${Clock_Dividers}
  ipgui::add_param $IPINST -name "C_DivClkDivide" -parent ${Clock_Dividers}
  ipgui::add_param $IPINST -name "C_ClkFboutMult" -parent ${Clock_Dividers}
  set C_Clkout0_Divide [ipgui::add_param $IPINST -name "C_Clkout0_Divide" -parent ${Clock_Dividers}]
  set_property tooltip {MMCM clock output 0 divider (Refclk for IDELAYCTRL, usually 200MHz)} ${C_Clkout0_Divide}
  set C_Clkout4_Divide [ipgui::add_param $IPINST -name "C_Clkout4_Divide" -parent ${Clock_Dividers}]
  set_property tooltip {MMCM clock output 4 divider (BUFG DRU Clk, goes to DRU with 160MHz or 270MHz)} ${C_Clkout4_Divide}
  set C_Clkout3_Divide [ipgui::add_param $IPINST -name "C_Clkout3_Divide" -parent ${Clock_Dividers}]
  set_property tooltip {MMCM clock output 3 divider (BUFG DRU Divclk, goes to DRU with 89MHz or 135MHz)} ${C_Clkout3_Divide}
  set C_Clkout2_Divide [ipgui::add_param $IPINST -name "C_Clkout2_Divide" -parent ${Clock_Dividers}]
  set_property tooltip {MMCM clock output 2 divider (Receiver clock with IOBUF and 90 deg phase shift, goes to ISERDES with 160MHz or 270MHz)} ${C_Clkout2_Divide}
  set C_Clkout1_Divide [ipgui::add_param $IPINST -name "C_Clkout1_Divide" -parent ${Clock_Dividers}]
  set_property tooltip {MMCM clock output 1 divider (Receiver clock with IOBUF and 0 deg phase shift, goes to ISERDES with 160MHz or 270MHz)} ${C_Clkout1_Divide}


}

proc update_PARAM_VALUE.C_BufioClk0Loc { PARAM_VALUE.C_BufioClk0Loc } {
	# Procedure called to update C_BufioClk0Loc when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_BufioClk0Loc { PARAM_VALUE.C_BufioClk0Loc } {
	# Procedure called to validate C_BufioClk0Loc
	return true
}

proc update_PARAM_VALUE.C_BufioClk90Loc { PARAM_VALUE.C_BufioClk90Loc } {
	# Procedure called to update C_BufioClk90Loc when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_BufioClk90Loc { PARAM_VALUE.C_BufioClk90Loc } {
	# Procedure called to validate C_BufioClk90Loc
	return true
}

proc update_PARAM_VALUE.C_ClkFboutMult { PARAM_VALUE.C_ClkFboutMult } {
	# Procedure called to update C_ClkFboutMult when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ClkFboutMult { PARAM_VALUE.C_ClkFboutMult } {
	# Procedure called to validate C_ClkFboutMult
	return true
}

proc update_PARAM_VALUE.C_ClkinPeriod { PARAM_VALUE.C_ClkinPeriod } {
	# Procedure called to update C_ClkinPeriod when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ClkinPeriod { PARAM_VALUE.C_ClkinPeriod } {
	# Procedure called to validate C_ClkinPeriod
	return true
}

proc update_PARAM_VALUE.C_Clkout0_Divide { PARAM_VALUE.C_Clkout0_Divide } {
	# Procedure called to update C_Clkout0_Divide when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_Clkout0_Divide { PARAM_VALUE.C_Clkout0_Divide } {
	# Procedure called to validate C_Clkout0_Divide
	return true
}

proc update_PARAM_VALUE.C_Clkout1_Divide { PARAM_VALUE.C_Clkout1_Divide } {
	# Procedure called to update C_Clkout1_Divide when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_Clkout1_Divide { PARAM_VALUE.C_Clkout1_Divide } {
	# Procedure called to validate C_Clkout1_Divide
	return true
}

proc update_PARAM_VALUE.C_Clkout2_Divide { PARAM_VALUE.C_Clkout2_Divide } {
	# Procedure called to update C_Clkout2_Divide when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_Clkout2_Divide { PARAM_VALUE.C_Clkout2_Divide } {
	# Procedure called to validate C_Clkout2_Divide
	return true
}

proc update_PARAM_VALUE.C_Clkout3_Divide { PARAM_VALUE.C_Clkout3_Divide } {
	# Procedure called to update C_Clkout3_Divide when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_Clkout3_Divide { PARAM_VALUE.C_Clkout3_Divide } {
	# Procedure called to validate C_Clkout3_Divide
	return true
}

proc update_PARAM_VALUE.C_Clkout4_Divide { PARAM_VALUE.C_Clkout4_Divide } {
	# Procedure called to update C_Clkout4_Divide when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_Clkout4_Divide { PARAM_VALUE.C_Clkout4_Divide } {
	# Procedure called to validate C_Clkout4_Divide
	return true
}

proc update_PARAM_VALUE.C_DivClkDivide { PARAM_VALUE.C_DivClkDivide } {
	# Procedure called to update C_DivClkDivide when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DivClkDivide { PARAM_VALUE.C_DivClkDivide } {
	# Procedure called to validate C_DivClkDivide
	return true
}

proc update_PARAM_VALUE.C_IdlyCtrlLoc { PARAM_VALUE.C_IdlyCtrlLoc } {
	# Procedure called to update C_IdlyCtrlLoc when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_IdlyCtrlLoc { PARAM_VALUE.C_IdlyCtrlLoc } {
	# Procedure called to validate C_IdlyCtrlLoc
	return true
}

proc update_PARAM_VALUE.C_MmcmLoc { PARAM_VALUE.C_MmcmLoc } {
	# Procedure called to update C_MmcmLoc when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_MmcmLoc { PARAM_VALUE.C_MmcmLoc } {
	# Procedure called to validate C_MmcmLoc
	return true
}


proc update_MODELPARAM_VALUE.C_MmcmLoc { MODELPARAM_VALUE.C_MmcmLoc PARAM_VALUE.C_MmcmLoc } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_MmcmLoc}] ${MODELPARAM_VALUE.C_MmcmLoc}
}

proc update_MODELPARAM_VALUE.C_BufioClk0Loc { MODELPARAM_VALUE.C_BufioClk0Loc PARAM_VALUE.C_BufioClk0Loc } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_BufioClk0Loc}] ${MODELPARAM_VALUE.C_BufioClk0Loc}
}

proc update_MODELPARAM_VALUE.C_BufioClk90Loc { MODELPARAM_VALUE.C_BufioClk90Loc PARAM_VALUE.C_BufioClk90Loc } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_BufioClk90Loc}] ${MODELPARAM_VALUE.C_BufioClk90Loc}
}

proc update_MODELPARAM_VALUE.C_IdlyCtrlLoc { MODELPARAM_VALUE.C_IdlyCtrlLoc PARAM_VALUE.C_IdlyCtrlLoc } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_IdlyCtrlLoc}] ${MODELPARAM_VALUE.C_IdlyCtrlLoc}
}

proc update_MODELPARAM_VALUE.C_ClkinPeriod { MODELPARAM_VALUE.C_ClkinPeriod PARAM_VALUE.C_ClkinPeriod } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ClkinPeriod}] ${MODELPARAM_VALUE.C_ClkinPeriod}
}

proc update_MODELPARAM_VALUE.C_DivClkDivide { MODELPARAM_VALUE.C_DivClkDivide PARAM_VALUE.C_DivClkDivide } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DivClkDivide}] ${MODELPARAM_VALUE.C_DivClkDivide}
}

proc update_MODELPARAM_VALUE.C_ClkFboutMult { MODELPARAM_VALUE.C_ClkFboutMult PARAM_VALUE.C_ClkFboutMult } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ClkFboutMult}] ${MODELPARAM_VALUE.C_ClkFboutMult}
}

proc update_MODELPARAM_VALUE.C_Clkout0_Divide { MODELPARAM_VALUE.C_Clkout0_Divide PARAM_VALUE.C_Clkout0_Divide } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_Clkout0_Divide}] ${MODELPARAM_VALUE.C_Clkout0_Divide}
}

proc update_MODELPARAM_VALUE.C_Clkout1_Divide { MODELPARAM_VALUE.C_Clkout1_Divide PARAM_VALUE.C_Clkout1_Divide } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_Clkout1_Divide}] ${MODELPARAM_VALUE.C_Clkout1_Divide}
}

proc update_MODELPARAM_VALUE.C_Clkout2_Divide { MODELPARAM_VALUE.C_Clkout2_Divide PARAM_VALUE.C_Clkout2_Divide } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_Clkout2_Divide}] ${MODELPARAM_VALUE.C_Clkout2_Divide}
}

proc update_MODELPARAM_VALUE.C_Clkout3_Divide { MODELPARAM_VALUE.C_Clkout3_Divide PARAM_VALUE.C_Clkout3_Divide } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_Clkout3_Divide}] ${MODELPARAM_VALUE.C_Clkout3_Divide}
}

proc update_MODELPARAM_VALUE.C_Clkout4_Divide { MODELPARAM_VALUE.C_Clkout4_Divide PARAM_VALUE.C_Clkout4_Divide } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_Clkout4_Divide}] ${MODELPARAM_VALUE.C_Clkout4_Divide}
}

