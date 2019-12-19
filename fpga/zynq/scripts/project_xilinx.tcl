## Define the supported tool version
if {![info exists REQUIRED_VIVADO_VERSION]} {
  set REQUIRED_VIVADO_VERSION "2019.2"
}

## Define the NO_BITSTREAM_COMPRESSION environment variable to disable
#  bitstream compression
if {[info exists ::env(NO_BITSTREAM_COMPRESSION)]} {
  set NO_BITSTREAM_COMPRESSION 1
} elseif {![info exists NO_BITSTREAM_COMPRESSION]} {
  set NO_BITSTREAM_COMPRESSION 0
}

## Define the USE_OOC_SYNTHESIS environment variable to enable out of context
#  synthesis
if {[info exists ::env(USE_OOC_SYNTHESIS)]} {
  set USE_OOC_SYNTHESIS 1
} elseif {![info exists USE_OOC_SYNTHESIS]} {
  set USE_OOC_SYNTHESIS 0
}

## Set to enable incremental compilation
set USE_INCR_COMP 1

## Set to enable power optimization
set POWER_OPTIMIZATION 0


proc project_create {project_name source_dir part board {mode 0} {parameter_list {}} } {
  global root_dir
  global REQUIRED_VIVADO_VERSION
  global USE_OOC_SYNTHESIS
  global USE_INCR_COMP

  # Check Vivado version
  set VIVADO_VERSION [version -short]
  if {[string compare $VIVADO_VERSION $REQUIRED_VIVADO_VERSION] != 0} {
    puts -nonewline "CRITICAL WARNING: vivado version mismatch; "
    puts -nonewline "expected $REQUIRED_VIVADO_VERSION, "
    puts -nonewline "got $VIVADO_VERSION.\n"
  }

  # Create project
  set project_system_dir "$root_dir/build/$project_name/$project_name.srcs/sources_1/bd/system"
  create_project $project_name "$root_dir/build/$project_name" -part $part -force

  if {$board ne "not-applicable"} {
    set_property board_part $board [current_project]
  }

  # Set a common IP cache for all projects
  if {$USE_OOC_SYNTHESIS == 1} {
    if {[file exists $root_dir/build/ipcache] == 0} {
      file mkdir $root_dir/build/ipcache
    }
    config_ip_cache -import_from_project -use_cache_location $root_dir/build/ipcache
  }

  # Set IP core directories
  set ipcore_lib_dirs $root_dir/ip_repo
  lappend ipcore_lib_dirs $root_dir/third_party/adi/library
  set_property ip_repo_paths $ipcore_lib_dirs [current_fileset]
  update_ip_catalog

  # Load custom message severity definitions
  source $root_dir/scripts/xilinx_msg.tcl

  # In Vivado there is a limit for the number of warnings and errors which are
  # displayed by the tool for a particular error or warning; the default value
  # of this limit is 100.
  # Overrides the default limit to 2000.
  set_param messaging.defaultLimit 2000

  # Set parameters of the top level file
  # Make the same parameters available to system_bd.tcl
  set proj_params [get_property generic [current_fileset]]
  foreach {param value} $parameter_list {
    lappend proj_params $param=$value
  }
  set_property generic $proj_params [current_fileset]

  # Create block design
  create_bd_design "system"
  source $source_dir/system_bd.tcl
  create_root_design ""


  if {$USE_OOC_SYNTHESIS == 1} {
    set_property synth_checkpoint_mode Hierarchical [get_files  $project_system_dir/system.bd]
  } else {
    set_property synth_checkpoint_mode None [get_files  $project_system_dir/system.bd]
  }

  generate_target {synthesis implementation} [get_files  $project_system_dir/system.bd]

  if {$USE_OOC_SYNTHESIS == 1} {
    export_ip_user_files -of_objects [get_files  $project_system_dir/system.bd] -no_script -sync -force -quiet
    create_ip_run [get_files  $project_system_dir/system.bd]
  }

  #make_wrapper -files [get_files $project_system_dir/system.bd] -top
  #import_files -force -norecurse -fileset sources_1 $project_system_dir/hdl/system_wrapper.v

  if {$USE_INCR_COMP == 1} {
    if {[file exists ./reference.dcp]} {
      set_property incremental_checkpoint ./reference.dcp [get_runs impl_1]
    }
  }
}


proc project_add_files {project_name source_dir project_files} {
  foreach pfile $project_files {
    if {[file pathtype $pfile] != "absolute"} {
        set pfile [file join $source_dir $pfile]
    }

    if {[string range $pfile [expr 1 + [string last . $pfile]] end] == "xdc"} {
      add_files -norecurse -fileset constrs_1 $pfile
    } else {
      add_files -norecurse -fileset sources_1 $pfile
    }
  }

  # NOTE: top file name is always system_top
  set_property top system_top [current_fileset]
}


proc project_run {project_name} {
  global NO_BITSTREAM_COMPRESSION
  global POWER_OPTIMIZATION
  global USE_OOC_SYNTHESIS

  if {$USE_OOC_SYNTHESIS == 1} {
    launch_runs -jobs 4 system_*_synth_1 synth_1
  } else {
    launch_runs synth_1
  }
  wait_on_run synth_1
  open_run synth_1
  report_timing_summary -file timing_synth.log

  if {$NO_BITSTREAM_COMPRESSION == 0} {
    set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
  }

  if {$POWER_OPTIMIZATION == 1} {
    set_property STEPS.POWER_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
    set_property STEPS.POST_PLACE_POWER_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
  }

  launch_runs impl_1 -to_step write_bitstream
  wait_on_run impl_1
  open_run impl_1
  report_timing_summary -file timing_impl.log

  # Look for undefined clocks which do not show up in the timing summary
  set timing_check [check_timing -override_defaults no_clock -no_header -return_string]
  if {[regexp { (\d+) register} $timing_check -> num_regs]} {

    if {[info exist num_regs]} {
      if {$num_regs > 0} {
        puts "CRITICAL WARNING: There are $num_regs registers with no clocks !!! See no_clock.log for details."
        check_timing -override_defaults no_clock -verbose -file no_clock.log
      }
    }

  } else {
    puts "CRITICAL WARNING: The search for undefined clocks failed !!!"
  }

  write_hw_platform -fixed -force -include_bit -file $project_name.xsa
}
