set source_dir [file dirname [info script]]
source [file join $source_dir "../../scripts/env.tcl"]
source $root_dir/scripts/project_xilinx.tcl

project_create base_crz01 $source_dir "xc7z100ffg900-2" "not-applicable"

project_add_files base_crz01 $source_dir [list \
  "system_top.v" \
  "system_constr.xdc" \
]
