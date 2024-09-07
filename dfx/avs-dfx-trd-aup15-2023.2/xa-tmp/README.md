
Filename: README.md
Version: 1.0
Package: Avnet-Silica Demo Package
Description: Readme

Copyright (c) 2024 Avnet EMG GmbH, all rights reserved


# Introduction
This project is showing how to run a Linux Kernel on a MicroBlaze System as well as the DFX flow. The steps contain:

1) Initial steps
2) Building the Vivado Design + the partial bitstreams
3) Building the First Stage Bootloader for copying u-boot from flash to DDR4 RAM and starting it (Vitis Tcl flow)
4) Building the PetaLinux Linux Images
5) Updating the Vivado Bitstream with the FSBL (MicroBlaze). Generating the Flash (MCS) images.
6) Flash programming
7) Running the dfx example
8) Baremetal application example

The project file hierarchy:
```
.
├── doc
├── plnx
│   ├── bsp (PetaLinux BSP)
│   └── work (Generated)
├── vitis
│   ├── bobbyb
│   │   └── src (Custom FSBL)
│   ├── tcl (Tcl file for building the FSBL)
│   └── workspace (generated)
└── vivado
    ├── build (generated, all build file)
    │   ├── bitstreams (partial bit and bin files)
    │   ├── flash_images (SPI Flash images)
    │   ├── ip (IP build output)
    │   └── prj (The Vivado Project)
    ├── constrs (constraints, pins, pblocks and configuration)
    ├── sources
    │   ├── hdl
    │   └── ip
    └── tcl (Build Tcl files)
```



## 1. Initial
1) Set TRD_HOME, ensure that the current working directory is at the project root folder.
```
export TRD_HOME=$PWD
```

2) Source the AMD tools:
```
source /opt/Xilinx/Vivado/2023.2/settings64.sh
source /opt/Xilinx/Vitis/2023.2/settings64.sh
source /opt/Xilinx/petalinux/2023.2/settings.sh
```

## 2. Vivado Part 1: Creating the project and building bitstream + XSA file
 **Building the Vivado project**

1) change the directory to $TRD_HOME/vivado
```
cd $TRD_HOME/vivado
```

2) generate the project, build the Vivado platform and export the XSA file for PetaLinux as well as for the Vitis platform
```
make
```
 

**Note: The bitfile does not contain the MicroBlaze software at this stage.**

Next step is to proceed with the Vitis Software Built for the MicroBlaze. Afterwards the Vivado Bitstream can be updated with the elf file.


## 3. Vitis: Building Workspace and MicroBlaze Software (Bootloader)

 **Building the Vitis workspace (debug or release)**
The Xilinx Software Command Line Tool is used to build up the Vitis Workspace as well as the application.

1) change the directory to $TRD_HOME/vitis and launch xsct
```
cd $TRD_HOME/vitis
xsct
xsct% file mkdir workspace;cd workspace
xsct% source ../tcl/build.tcl
xsct% gen_app release
```

This will generate the workspace which can be opened with the Vitis GUI as well as the application elf located in the workspace build folder.  


## 4. Building the PetaLinux Linux Images

1) Create PetaLinux project with the AMD defaults for miroblaze
```
mkdir -p $TRD_HOME/plnx/work
cd $TRD_HOME/plnx/work
petalinux-create --type project --template microblaze --name aup15
```

2) Overwrite defaults. The Avnet-Silica layer is added to the project.
```
cd $TRD_HOME/plnx/work/aup15
ln -s $TRD_HOME/plnx/configs/meta-avs project-spec/
ln -sf $TRD_HOME/plnx/configs/config project-spec/configs/config
ln -sf $TRD_HOME/plnx/configs/rootfs_config project-spec/configs/rootfs_config
``` 

3) Import the XSA file from the Vivado built
`
petalinux-config --get-hw-description $TRD_HOME/vivado/build/prj/  --silentconfig
`

4) Copy over the partial bitstreams from the vivado built so that they are part of the rootfs (/usr/share/avs/bitstreams)
cp $TRD_HOME/vivado/build/bitstreams/*.bin project-spec/meta-avs/recipes-apps/dfx-demo/files/bitstreams/

5) build the project
`
petalinux-build
`

## 5. Vivado Part 2: Updating the Bitstream with the MicroBlaze FSBL and generating the MCS flash images from the PetaLinux build

 **1) Updating the bitstream with the MicroBlaze software and generating the flash image for the first partition**
 
     $ cd $TRD_HOME/vivado/build/prj
     $ vivado -mode tcl
     Vivado% source ../../tcl/procedures.tcl
     Vivado% gen_flash_image_fpga ../../../vitis/workspace/bobbyb/Release/bobbyb.elf

The bitfile contains now the MicoBlaze application. 

 **2) Generating MCS files (flash images with addresses). Note: The images need to reside in the PetaLinux path set in the procedures.tcl file**
 
     Vivado% source ../../tcl/procedures.tcl
     Vivado% gen_flash_image_uboot
     Vivado% gen_flash_image_kernel
     Vivado% gen_flash_image_ubi


## 6. Vivado Part 3: Downloading flash images via JTAG
**With the definition in procedures.tcl we can directly flash the images via JTAG**
 
     Vivado% source ../../tcl/procedures.tcl
     Vivado% jtag::flash ../flash_images/fpga.mcs
     Vivado% jtag::flash ../flash_images/u-boot.bin.mcs
     Vivado% jtag::flash ../flash_images/image.ub.mcs
     Vivado% jtag::flash ../flash_images/rootfs.ubi.mcs







# Debug / Development Notes

**converting elf to bin**
`microblazeel-xilinx-linux-gnu-objcopy -O binary /tmp/image.elf /tmp/image.bin`

# XSDB commands:
**Initialization**
`connect`
`targets`
`target 3`
`rst`

**download FPGA bitstream**
`fpga /tmp/arty_linux.bit`


**download and start u-boot**
`dow -data /tmp/u-boot.bin 0x84000000`
`con -addr 0x84000000`

or

`dow /tmp/u-boot.elf`
`con`

**download and start kernel**
`dow -data /tmp/image.bin 0x80000000`
`con -addr 0x80000000`

or
`dow -data /tmp/image.ub 0x87000000`
`dow -data /tmp/system.dtb 0x82000000`

In u-boot console:
U-Boot>`bootm 0x87000000 - 0x82000000`

**flash rootfs (UBI) via u-boot**
`xsdb% dow -data /tmp/rootfs.ubi 0x82000000`
`U-Boot>sf update 0x82000000 0x1700000 0x1000000`


**Usefull GCC commands**
`microblazeel-xilinx-linux-gnu-objcopy -O binary /tmp/image.elf /tmp/image.bin`
`microblazeel-xilinx-linux-gnu-objdump -S /tmp/u-boot.elf`


**UBI / UBIFS commands**
On target:
`ubiformat /dev/mtd3`
`ubiattach -p /dev/mtd3`
`ubimkvol /dev/ubi0 --name rootfs -s 10MiB`
`ubimkvol /dev/ubi0 --name rootfs --maxavsize`
`ubidetach -p /dev/mtd3`
`mount -t ubifs ubi0:rootfs /mnt/`

**Switch between initramfs and UBI as rootfs, usefull for setting up UBI**
In petalinux -> Image Packaging Configuration:
INITRAMFS

in the device-tree:
bootargs = "console=ttyUL0,115200 earlycon root=/dev/ram0 rw cma=32M"



