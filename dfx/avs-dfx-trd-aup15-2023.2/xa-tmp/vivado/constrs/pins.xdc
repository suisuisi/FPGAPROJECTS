
#set_property IOSTANDARD LVCMOS33 [get_ports mgtclk_i2c_scl_io]
#set_property IOSTANDARD LVCMOS33 [get_ports mgtclk_i2c_sda_io]
#set_property PACKAGE_PIN B9 [get_ports mgtclk_i2c_scl_io]
#set_property PACKAGE_PIN A9 [get_ports mgtclk_i2c_sda_io]

set_property PACKAGE_PIN AE15 [get_ports {led_rgb_1[2]}]
set_property PACKAGE_PIN AD15 [get_ports {led_rgb_1[1]}]
set_property PACKAGE_PIN AF13 [get_ports {led_rgb_1[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led_rgb_1[*]}]
set_property SLEW SLOW [get_ports {led_rgb_1[*]}]
set_property DRIVE 4 [get_ports {led_rgb_1[*]}]

set_property PACKAGE_PIN U26 [get_ports {led_rgb_2[0]}]
set_property PACKAGE_PIN P24 [get_ports {led_rgb_2[1]}]
set_property PACKAGE_PIN N24 [get_ports {led_rgb_2[2]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led_rgb_2[*]}]
set_property SLEW SLOW [get_ports {led_rgb_2[*]}]
set_property DRIVE 4 [get_ports {led_rgb_2[*]}]




set_property IOSTANDARD LVCMOS18 [get_ports {led_rgb_1[*]}]
set_property SLEW SLOW [get_ports {led_rgb_1[*]}]
set_property DRIVE 4 [get_ports {led_rgb_1[*]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led_rgb_2[*]}]
set_property SLEW SLOW [get_ports {led_rgb_2[*]}]
set_property DRIVE 4 [get_ports {led_rgb_2[*]}]

####################################################################################
# Constraints from file : 'system_auto_cc_0_clocks.xdc'
####################################################################################


