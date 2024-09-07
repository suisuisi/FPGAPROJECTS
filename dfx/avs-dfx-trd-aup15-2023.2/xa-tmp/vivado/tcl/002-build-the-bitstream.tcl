#******************************************************************************
# Avnet-Silica Demo
# Author: Marco Höfle
# Date: 2024-03-13
# Purpose: Builds the bitstream
#******************************************************************************

set BUILD_DIR [pwd]
set PROJ_NAME "avs-au15p"
set PROJ_PATH $BUILD_DIR/$PROJ_NAME.xpr
set BITDIR_PATH  "$BUILD_DIR/../bitstreams"
set N_JOBS 8

open_project $PROJ_PATH
update_compile_order -fileset sources_1

# with default implementation settings timing might not be met.
set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]
set_property strategy Performance_ExtraTimingOpt [get_runs child_0_impl_1]

launch_runs impl_1 -to_step write_bitstream -jobs $N_JOBS
wait_on_run -timeout 90 impl_1

launch_runs child_0_impl_1 -jobs $N_JOBS
wait_on_run -timeout 90 child_0_impl_1


if { ![file exists "$BITDIR_PATH"]} { 
   file mkdir $BITDIR_PATH
}


file copy -force $BUILD_DIR/$PROJ_NAME.runs/impl_1/top.bit $BITDIR_PATH/
open_checkpoint $BUILD_DIR/$PROJ_NAME.runs/impl_1/top_routed.dcp
set_property bitstream.general.compress false [current_design]
set_property CONFIG_MODE "S_SELECTMAP32" [current_design]
write_bitstream -force -cell u_count $BITDIR_PATH/u_count_count_up_partial.bit
write_bitstream -force -cell u_shift $BITDIR_PATH/u_shift_shift_right_partial.bit
write_cfgmem -force -format bin -interface SMAPx32 -disablebitswap -loadbit "up 0 $BITDIR_PATH/u_count_count_up_partial.bit" $BITDIR_PATH/up.bin
write_cfgmem -force -format bin -interface SMAPx32 -disablebitswap -loadbit "up 0 $BITDIR_PATH/u_shift_shift_right_partial.bit" $BITDIR_PATH/right.bin
write_debug_probes -force $BITDIR_PATH/top_count_up_shift_right.ltx
close_project


open_checkpoint $BUILD_DIR/$PROJ_NAME.runs/child_0_impl_1/top_routed.dcp
set_property bitstream.general.compress false [current_design]
set_property CONFIG_MODE "S_SELECTMAP32" [current_design]
write_bitstream -force -cell u_count $BITDIR_PATH/u_count_count_down_partial.bit
write_bitstream -force -cell u_shift $BITDIR_PATH/u_shift_shift_left_partial.bit
write_cfgmem -force -format bin -interface SMAPx32 -disablebitswap -loadbit "up 0 $BITDIR_PATH/u_count_count_down_partial.bit" $BITDIR_PATH/down.bin
write_cfgmem -force -format bin -interface SMAPx32 -disablebitswap -loadbit "up 0 $BITDIR_PATH/u_shift_shift_left_partial.bit" $BITDIR_PATH/left.bin
write_debug_probes -force $BITDIR_PATH/top_count_down_shift_left.ltx
close_project

