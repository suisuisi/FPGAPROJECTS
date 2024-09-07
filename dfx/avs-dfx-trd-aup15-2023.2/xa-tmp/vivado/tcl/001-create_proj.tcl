#******************************************************************************
# Avnet-Silica Demo
# Author: Marco Höfle
# Date: 2024-03-13
# Purpose: Vivado project generation
#******************************************************************************

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir [pwd]
set proj_name "avs-au15p"
set bd_name "system"
set build_dir $origin_dir
set tcl_dir $origin_dir/../../tcl
set constr_dir $origin_dir/../../constrs
set hdl_dir $origin_dir/../../sources/hdl
set ip_dir $origin_dir/../../sources/ip

# Create project
create_project ${proj_name} $build_dir -part xcau15p-ffvb676-2-e


# Set project properties
set obj [current_project]
set_property -name "board_part" -value "avnet.com:auboard_15p:part0:1.0" -objects $obj
set_property -name "target_language" -value "VHDL" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "pr_flow" -value "1" -objects $obj


# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

add_files -fileset constrs_1 -norecurse $constr_dir/pins.xdc
add_files -fileset constrs_1 -norecurse $constr_dir/config.xdc
add_files -fileset constrs_1 -norecurse $constr_dir/target.xdc
add_files -fileset constrs_1 -norecurse $constr_dir/pblocks.xdc


# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files_hdl [list \
 [file normalize "${hdl_dir}/top.vhd"] \
 [file normalize "${hdl_dir}/icap_wrapper.vhd"] \
]
add_files -norecurse -fileset $obj $files_hdl


# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files_ip [list \
 [file normalize "${ip_dir}/dfx_decoupler/dfx_decoupler.xci"] \
]
add_files -norecurse -fileset $obj $files_ip


# creating block designs (top one and bock design containers)
source $tcl_dir/create_bd.tcl


make_wrapper -files [get_files $build_dir/$proj_name.srcs/sources_1/bd/system/system.bd] -top

add_files -norecurse $build_dir/$proj_name.gen/sources_1/bd/$bd_name/hdl/${bd_name}_wrapper.vhd

generate_target all [get_files $build_dir/$proj_name.srcs/sources_1/bd/system/system.bd]

update_compile_order -fileset sources_1
validate_bd_design





## Enabling DXF


# Create 'count' partition definition
create_partition_def -name count -module count
set obj [get_partition_defs count]
set_property -name "name" -value "count" -objects $obj
set_property -name "use_blackbox_stub" -value "1" -objects $obj

# Create 'shift' partition definition
create_partition_def -name shift -module shift
set obj [get_partition_defs shift]
set_property -name "name" -value "shift" -objects $obj
set_property -name "use_blackbox_stub" -value "1" -objects $obj


# Create 'count_down' reconfigurable module
set partitionDef [get_partition_defs count]
create_reconfig_module -name count_down -partition_def $partitionDef
set obj [get_reconfig_modules count_down]
set_property -name "module_name" -value "count" -objects $obj

set files [list \
 "[file normalize "$ip_dir/ila_count_down/ila_count_down.xci"]"\
 "[file normalize "$hdl_dir/count/count_down/count_down.vhd"]"\
]
add_files -norecurse -of_objects [get_reconfig_modules count_down] $files



# Create 'count_up' reconfigurable module

set obj [get_reconfig_modules count_down]
# Create 'count_up' reconfigurable module
set partitionDef [get_partition_defs count]
create_reconfig_module -name count_up -partition_def $partitionDef
set_property default_rm count_up $partitionDef
set obj [get_reconfig_modules count_up]
set_property -name "module_name" -value "count" -objects $obj

set files [list \
 "[file normalize "$ip_dir/ila_count_up/ila_count_up.xci"]"\
 "[file normalize "$hdl_dir/count/count_up/count_up.vhd"]"\
]
add_files -norecurse -of_objects [get_reconfig_modules count_up] $files



# Create 'shift_left' reconfigurable module
set partitionDef [get_partition_defs shift]
create_reconfig_module -name shift_left -partition_def $partitionDef
set_property default_rm shift_left $partitionDef
set obj [get_reconfig_modules shift_left]
set_property -name "module_name" -value "shift" -objects $obj

set files [list \
 "[file normalize "$hdl_dir/shift/shift_left/shift_left.v"]"\
]
add_files -norecurse -of_objects [get_reconfig_modules shift_left] $files



create_reconfig_module -name shift_right -partition_def $partitionDef
set obj [get_reconfig_modules shift_right]
set_property -name "module_name" -value "shift" -objects $obj

set files [list \
 "[file normalize "$hdl_dir/shift/shift_right/shift_right.v"]"\
]
add_files -norecurse -of_objects [get_reconfig_modules shift_right] $files




# Create 'config_1' pr configurations
create_pr_configuration -name config_1 -partitions [list u_count:count_up u_shift:shift_left ]
set obj [get_pr_configurations config_1]
set_property -name "auto_import" -value "1" -objects $obj
set_property -name "partition_cell_rms" -value "u_count:count_up u_shift:shift_left" -objects $obj
set_property -name "use_blackbox" -value "1" -objects $obj

# Create 'config_2' pr configurations
create_pr_configuration -name config_2 -partitions [list u_count:count_down u_shift:shift_right ]
set obj [get_pr_configurations config_2]
set_property -name "auto_import" -value "1" -objects $obj
set_property -name "partition_cell_rms" -value "u_count:count_down u_shift:shift_right" -objects $obj
set_property -name "use_blackbox" -value "1" -objects $obj


# Create 'child_0_impl_1' run (if not found)
if {[string equal [get_runs -quiet child_0_impl_1] ""]} {
      create_run -name child_0_impl_1 -part xcau15p-ffvb676-2-e -flow {Vivado Implementation 2023} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -pr_config config_2 -constrset constrs_1 -parent_run impl_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs child_0_impl_1]
  set_property flow "Vivado Implementation 2023" [get_runs child_0_impl_1]
}

