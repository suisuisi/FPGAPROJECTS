

create_pblock pblock_count
add_cells_to_pblock [get_pblocks pblock_count] [get_cells -quiet [list u_count]]
resize_pblock [get_pblocks pblock_count] -add {SLICE_X20Y1:SLICE_X27Y29}
resize_pblock [get_pblocks pblock_count] -add {DSP48E2_X1Y2:DSP48E2_X1Y11}
resize_pblock [get_pblocks pblock_count] -add {RAMB18_X1Y2:RAMB18_X1Y11}
resize_pblock [get_pblocks pblock_count] -add {RAMB36_X1Y1:RAMB36_X1Y5}
set_property SNAPPING_MODE ON [get_pblocks pblock_count]

create_pblock pblock_shift
add_cells_to_pblock [get_pblocks pblock_shift] [get_cells -quiet [list u_shift]]
resize_pblock [get_pblocks pblock_shift] -add {SLICE_X40Y16:SLICE_X41Y29}
resize_pblock [get_pblocks pblock_shift] -add {RAMB18_X2Y8:RAMB18_X2Y11}
resize_pblock [get_pblocks pblock_shift] -add {RAMB36_X2Y4:RAMB36_X2Y5}
set_property SNAPPING_MODE ON [get_pblocks pblock_shift]

create_pblock pblock_rp1rm1
add_cells_to_pblock [get_pblocks pblock_rp1rm1] [get_cells -quiet [list system_i/rp1rm1_0]]
resize_pblock [get_pblocks pblock_rp1rm1] -add {SLICE_X44Y16:SLICE_X45Y29}
resize_pblock [get_pblocks pblock_rp1rm1] -add {RAMB18_X3Y8:RAMB18_X3Y11}
resize_pblock [get_pblocks pblock_rp1rm1] -add {RAMB36_X3Y4:RAMB36_X3Y5}


create_pblock pblock_cpu
add_cells_to_pblock [get_pblocks pblock_cpu] [get_cells -quiet [list system_i/mb_system/microblaze_0 system_i/mb_system/microblaze_0_local_memory]]
resize_pblock [get_pblocks pblock_cpu] -add {SLICE_X22Y60:SLICE_X51Y119}
resize_pblock [get_pblocks pblock_cpu] -add {CONFIG_SITE_X0Y0:CONFIG_SITE_X0Y0}
resize_pblock [get_pblocks pblock_cpu] -add {DSP48E2_X1Y24:DSP48E2_X7Y47}
resize_pblock [get_pblocks pblock_cpu] -add {RAMB18_X1Y24:RAMB18_X3Y47}
resize_pblock [get_pblocks pblock_cpu] -add {RAMB36_X1Y12:RAMB36_X3Y23}
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores u_count/dbg_hub_1]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores u_count/dbg_hub_1]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores u_count/dbg_hub_1]
connect_debug_port u_count/dbg_hub_1/clk [get_nets u_count/clk]
