set source_dir [file dirname [info script]]
source [file join $source_dir "../../scripts/env.tcl"]
source $root_dir/scripts/project_xilinx.tcl

project_create base_picozed $source_dir "xc7z030sbg485-1" "not-applicable"

project_add_files base_picozed $source_dir [list \
  "system_top.v" \
  "system_constr.xdc" \
]
