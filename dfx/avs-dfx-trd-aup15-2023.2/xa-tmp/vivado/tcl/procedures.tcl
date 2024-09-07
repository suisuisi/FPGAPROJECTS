#******************************************************************************
# Avnet-Silica Demo
# Author: Marco Höfle
# Date: 2024-03-13
# Purpose: Flash generation and JTAG download functions
#******************************************************************************


set BUILD_DIR [pwd]
set TRD_HOME $BUILD_DIR/../../..
set PROJ_NAME avs-au15p
set PROJ_PATH $BUILD_DIR/$PROJ_NAME.xpr
set IMAGE_DIR $BUILD_DIR/../flash_images
set PLNX_IMAGE_DIR $TRD_HOME/plnx/work/aup15/images/linux/
set DEVICE xcau15p_0
set FLASH_TYPE is25wp512m-spi-x1_x2_x4


file mkdir $IMAGE_DIR

namespace eval jtag {
}


proc gen_flash_image_ubi {} {
	variable ::PLNX_IMAGE_DIR
	variable ::IMAGE_DIR

	set FLASH_ADDR 0x000001700000
	set FLASH_SIZE 64
	set UBI_IMAGE rootfs.ubi

	puts "writing out mcs file"
	write_cfgmem -format MCS -size $FLASH_SIZE -interface spix1 -loaddata "up $FLASH_ADDR $PLNX_IMAGE_DIR/$UBI_IMAGE" -force $IMAGE_DIR/$UBI_IMAGE.mcs
}

proc gen_flash_image_uboot {} {
	variable ::PLNX_IMAGE_DIR
	variable ::IMAGE_DIR

	set FLASH_ADDR 0x000000600000
	set FLASH_SIZE 64
	set UBOOT_IMAGE u-boot.bin

	puts "writing out mcs file"
	write_cfgmem -format MCS -size $FLASH_SIZE -interface spix1 -loaddata "up $FLASH_ADDR $PLNX_IMAGE_DIR/$UBOOT_IMAGE" -force $IMAGE_DIR/$UBOOT_IMAGE.mcs
}

proc gen_flash_image_kernel {} {
	variable ::PLNX_IMAGE_DIR
	variable ::IMAGE_DIR

	set FLASH_ADDR 0x000000700000
	set FLASH_SIZE 64
	set KERNEL_IMAGE image.ub


	puts "writing out mcs file"
	write_cfgmem -format MCS -size $FLASH_SIZE -interface spix1 -loaddata "up $FLASH_ADDR $PLNX_IMAGE_DIR/$KERNEL_IMAGE" -force $IMAGE_DIR/$KERNEL_IMAGE.mcs
}

# This procedure generates a flash (mcs) file containing bitsream and elf
# type is golden or appl
# path_to_elf should point to the MicroBlaze elf
proc gen_flash_image_fpga {path_to_elf} {

	if { [file exist $path_to_elf] == 1 } {
		set ELF_PATH $path_to_elf
	} else {
		puts "provided elf path does not exist!"
		return
	}

	puts "Using MicroBlaze application $ELF_PATH"

	variable PROJ_PATH
	variable IMAGE_DIR

	open_project $PROJ_PATH

	set IMPL_DIR [get_property DIRECTORY [current_run]]
	set BITFILE_NAME system_wrapper.bit
	set IMAGE_NAME "fpga"

    # defaults to application image
	set FLASH_ADDR 0x0
	set FLASH_SIZE 64

	add_files -norecurse $ELF_PATH
	set_property used_in_simulation 0 [get_files $ELF_PATH]
	set_property SCOPED_TO_REF system [get_files -all -of_objects [get_fileset sources_1] $ELF_PATH]
	set_property SCOPED_TO_CELLS { mb_system/microblaze_0 } [get_files -all -of_objects [get_fileset sources_1] $ELF_PATH]


	open_run impl_1

	puts "generating $IMAGE_NAME"
	write_bitstream $IMPL_DIR/$BITFILE_NAME -force

	puts "writing out mcs file"
	write_cfgmem -format MCS -size $FLASH_SIZE -interface spix1 -loadbit "up $FLASH_ADDR $IMPL_DIR/$BITFILE_NAME" -force $IMAGE_DIR/$IMAGE_NAME

	# We remove the file again to avoid that the Vivado project is exported with the binary file
	remove_files $ELF_PATH

	close_project
}
# this procedure downloads a mcs file to the spi flash connected to the fpga unsing JTAG.
# argument to the mcs file is needed
proc jtag::flash {mcs_image} {
	variable ::BUILD_DIR
	variable ::DEVICE
	variable ::FLASH_TYPE

	if { [file exists $mcs_image] != 1} {
		puts "$mcs_image does not exist!"
		return
	}

	open_hw_manager
	connect_hw_server -allow_non_jtag
	open_hw_target

	current_hw_device [get_hw_devices $DEVICE]
	refresh_hw_device [lindex [get_hw_devices $DEVICE] 0]

	create_hw_cfgmem -hw_device [lindex [get_hw_devices $DEVICE] 0] [lindex [get_cfgmem_parts $FLASH_TYPE] 0]
	set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	refresh_hw_device [lindex [get_hw_devices $DEVICE] 0]

	set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.FILES [list $mcs_image ] [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.PRM_FILE {} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]

	startgroup
	create_hw_bitstream -hw_device [lindex [get_hw_devices $DEVICE] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices $DEVICE] 0]]; 
	program_hw_devices [lindex [get_hw_devices $DEVICE] 0]; 
	refresh_hw_device [lindex [get_hw_devices $DEVICE] 0];
	program_hw_cfgmem -verbose -hw_cfgmem [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices $DEVICE] 0]]
	endgroup

	close_hw_manager
}


# Download the project bitstream from the tcl console
proc jtag::dow_bitstream {bitstream} {
	variable ::PROJ_PATH
	variable ::BUILD_DIR
	variable ::DEVICE

	if { [file exists $bitstream] != 1} {
		puts "$bitfile does not exist!"
		return
	}

	puts "programming $bitstream"
	puts ""

	open_hw_manager
	connect_hw_server -allow_non_jtag
	open_hw_target

	current_hw_device [get_hw_devices $DEVICE]
	refresh_hw_device [lindex [get_hw_devices $DEVICE] 0]

	set_property PROGRAM.FILE $bitstream [get_hw_devices $DEVICE]

	current_hw_device [get_hw_devices $DEVICE]
	refresh_hw_device [lindex [get_hw_devices $DEVICE] 0]
	program_hw_devices [get_hw_devices $DEVICE]

	close_hw_manager
}
