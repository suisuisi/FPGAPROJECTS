
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# icap_wrapper

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcau15p-ffvb676-2-e
   set_property BOARD_PART avnet.com:auboard_15p:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

  # Add USER_COMMENTS on $design_name
  set_property USER_COMMENTS.comment_0 "Avnet-Silica DXF TRD
Date: 2024-04-25" [get_bd_designs $design_name]

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_timer:2.0\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:axi_ethernetlite:3.0\
xilinx.com:ip:axi_iic:2.1\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:dfx_controller:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:blk_mem_gen:8.4\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
icap_wrapper\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property CONFIG.C_ECC {0} $dlmb_bram_if_cntlr


  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property CONFIG.C_ECC {0} $ilmb_bram_if_cntlr


  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.use_bram_block {BRAM_Controller} \
  ] $lmb_bram


  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins dlmb_v10/LMB_M] [get_bd_intf_pins DLMB]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ilmb_v10/LMB_M] [get_bd_intf_pins ILMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: mb_system
proc create_hier_cell_mb_system { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_mb_system() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_DC

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_IC

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_DP

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:mbinterrupt_rtl:1.0 INTERRUPT


  # Create pins
  create_bd_pin -dir I -type rst rst_cpu
  create_bd_pin -dir I -type clk clk_cpu
  create_bd_pin -dir O -type rst dbg_sys_rst
  create_bd_pin -dir I -type rst rst_cpu_lmb

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [list \
    CONFIG.C_CACHE_BYTE_SIZE {16384} \
    CONFIG.C_DCACHE_BYTE_SIZE {16384} \
    CONFIG.C_DEBUG_ENABLED {1} \
    CONFIG.C_D_AXI {1} \
    CONFIG.C_D_LMB {1} \
    CONFIG.C_I_LMB {1} \
    CONFIG.C_USE_DCACHE {1} \
    CONFIG.C_USE_ICACHE {1} \
    CONFIG.G_TEMPLATE_LIST {4} \
  ] $microblaze_0


  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]

  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory $hier_obj microblaze_0_local_memory

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins microblaze_0/M_AXI_DC] [get_bd_intf_pins M_AXI_DC]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins microblaze_0/M_AXI_IC] [get_bd_intf_pins M_AXI_IC]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins M_AXI_DP]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins microblaze_0/INTERRUPT] [get_bd_intf_pins INTERRUPT]
  connect_bd_intf_net -intf_net mdm_1_MBDEBUG_0 [get_bd_intf_pins microblaze_0/DEBUG] [get_bd_intf_pins mdm_1/MBDEBUG_0]
  connect_bd_intf_net -intf_net microblaze_0_DLMB [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ILMB [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]

  # Create port connections
  connect_bd_net -net Clk_1 [get_bd_pins clk_cpu] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_local_memory/LMB_Clk]
  connect_bd_net -net Reset_1 [get_bd_pins rst_cpu] [get_bd_pins microblaze_0/Reset]
  connect_bd_net -net mdm_1_Debug_SYS_Rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins dbg_sys_rst]
  connect_bd_net -net rst_ddr4_0_300M_bus_struct_reset [get_bd_pins rst_cpu_lmb] [get_bd_pins microblaze_0_local_memory/SYS_Rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ddr_rst_clk
proc create_hier_cell_ddr_rst_clk { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_ddr_rst_clk() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_DC

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_IC

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 system_clock_300mhz

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_sdram

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_DFX


  # Create pins
  create_bd_pin -dir O -type rst rst_cpu
  create_bd_pin -dir I -type rst mb_debug_sys_rst
  create_bd_pin -dir O -from 0 -to 0 -type rst sys_aresetn
  create_bd_pin -dir O -type clk clk_sys
  create_bd_pin -dir I -from 0 -to 0 system_resetn
  create_bd_pin -dir O clk_cpu
  create_bd_pin -dir O -from 0 -to 0 rstn_cpu_arstn
  create_bd_pin -dir O -from 0 -to 0 rst_cpu_lmb

  # Create instance: rst_ddr4_0_100M, and set properties
  set rst_ddr4_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ddr4_0_100M ]
  set_property -dict [list \
    CONFIG.RESET_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $rst_ddr4_0_100M


  # Create instance: rst_ddr4_0_300M, and set properties
  set rst_ddr4_0_300M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ddr4_0_300M ]

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_SI {3} \
  ] $axi_smc


  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]
  set_property -dict [list \
    CONFIG.ADDN_UI_CLKOUT1_FREQ_HZ {150} \
    CONFIG.ADDN_UI_CLKOUT2_FREQ_HZ {None} \
    CONFIG.C0_CLOCK_BOARD_INTERFACE {system_clock_300mhz} \
    CONFIG.C0_DDR4_BOARD_INTERFACE {ddr4_sdram} \
    CONFIG.RESET_BOARD_INTERFACE {system_resetn} \
  ] $ddr4_0


  # Create instance: system_resetn_inv_0, and set properties
  set system_resetn_inv_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 system_resetn_inv_0 ]
  set_property -dict [list \
    CONFIG.C_OPERATION {not} \
    CONFIG.C_SIZE {1} \
  ] $system_resetn_inv_0


  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ddr4_0/C0_SYS_CLK] [get_bd_intf_pins system_clock_300mhz]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axi_smc/S00_AXI] [get_bd_intf_pins S_AXI_DC]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins axi_smc/S01_AXI] [get_bd_intf_pins S_AXI_IC]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins ddr4_0/C0_DDR4] [get_bd_intf_pins ddr4_sdram]
  connect_bd_intf_net -intf_net S02_AXI_1 [get_bd_intf_pins S_AXI_DFX] [get_bd_intf_pins axi_smc/S02_AXI]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]

  # Create port connections
  connect_bd_net -net ddr4_0_addn_ui_clkout1 [get_bd_pins ddr4_0/addn_ui_clkout1] [get_bd_pins clk_sys] [get_bd_pins rst_ddr4_0_100M/slowest_sync_clk] [get_bd_pins axi_smc/aclk1]
  connect_bd_net -net ext_reset_in_1 [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst] [get_bd_pins rst_ddr4_0_100M/ext_reset_in] [get_bd_pins rst_ddr4_0_300M/ext_reset_in]
  connect_bd_net -net mb_debug_sys_rst_1 [get_bd_pins mb_debug_sys_rst] [get_bd_pins rst_ddr4_0_100M/mb_debug_sys_rst]
  connect_bd_net -net rst_ddr4_0_100M_peripheral_aresetn [get_bd_pins rst_ddr4_0_100M/peripheral_aresetn] [get_bd_pins sys_aresetn] [get_bd_pins axi_smc/aresetn]
  connect_bd_net -net rst_ddr4_0_300M_bus_struct_reset [get_bd_pins rst_ddr4_0_300M/bus_struct_reset] [get_bd_pins rst_cpu_lmb]
  connect_bd_net -net rst_ddr4_0_300M_mb_reset [get_bd_pins rst_ddr4_0_300M/mb_reset] [get_bd_pins rst_cpu]
  connect_bd_net -net rst_ddr4_0_300M_peripheral_aresetn [get_bd_pins rst_ddr4_0_300M/peripheral_aresetn] [get_bd_pins ddr4_0/c0_ddr4_aresetn] [get_bd_pins rstn_cpu_arstn]
  connect_bd_net -net slowest_sync_clk1_1 [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins rst_ddr4_0_300M/slowest_sync_clk] [get_bd_pins axi_smc/aclk] [get_bd_pins clk_cpu]
  connect_bd_net -net system_resetn_1 [get_bd_pins system_resetn] [get_bd_pins system_resetn_inv_0/Op1]
  connect_bd_net -net system_resetn_inv_0_Res [get_bd_pins system_resetn_inv_0/Res] [get_bd_pins ddr4_0/sys_rst]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: peripherals
proc create_hier_cell_peripherals { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_peripherals() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 sys_uart

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 red_leds_4bits

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mbinterrupt_rtl:1.0 interrupt

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mii_rtl:1.0 mii_ethernet

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_io

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 main_i2c

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 m_axi_mem

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 push_buttons_4bits


  # Create pins
  create_bd_pin -dir I -type clk S_ACLK
  create_bd_pin -dir I -type rst S_ARESETN
  create_bd_pin -dir I -type rst rst_cpu
  create_bd_pin -dir I -from 1 -to 0 dfxc_shift_hw_trig
  create_bd_pin -dir I -from 1 -to 0 dfxc_count_hw_trig
  create_bd_pin -dir O vs_shift_rm_reset
  create_bd_pin -dir O vs_count_rm_decouple
  create_bd_pin -dir O vs_shift_rm_decouple
  create_bd_pin -dir O vs_count_rm_reset
  create_bd_pin -dir I clk_cpu
  create_bd_pin -dir I rstn_cpu_arstn

  # Create instance: microblaze_0_axi_periph, and set properties
  set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]
  set_property CONFIG.NUM_MI {9} $microblaze_0_axi_periph


  # Create instance: axi_timer_0, and set properties
  set axi_timer_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0 ]

  # Create instance: axi_quad_spi_0, and set properties
  set axi_quad_spi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0 ]
  set_property -dict [list \
    CONFIG.C_BYTE_LEVEL_INTERRUPT_EN {0} \
    CONFIG.C_FIFO_DEPTH {256} \
    CONFIG.C_SCK_RATIO {4} \
    CONFIG.C_USE_STARTUP {1} \
    CONFIG.C_USE_STARTUP_INT {1} \
  ] $axi_quad_spi_0


  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]
  set_property -dict [list \
    CONFIG.C_BAUDRATE {115200} \
    CONFIG.UARTLITE_BOARD_INTERFACE {sys_uart} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_uartlite_0


  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.GPIO_BOARD_INTERFACE {red_leds_4bits} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_gpio_0


  # Create instance: microblaze_0_xlconcat, and set properties
  set microblaze_0_xlconcat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 microblaze_0_xlconcat ]
  set_property CONFIG.NUM_PORTS {6} $microblaze_0_xlconcat


  # Create instance: microblaze_0_axi_intc, and set properties
  set microblaze_0_axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 microblaze_0_axi_intc ]
  set_property CONFIG.C_HAS_FAST {1} $microblaze_0_axi_intc


  # Create instance: axi_ethernetlite_0, and set properties
  set axi_ethernetlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernetlite:3.0 axi_ethernetlite_0 ]
  set_property -dict [list \
    CONFIG.MDIO_BOARD_INTERFACE {mdio_io} \
    CONFIG.MII_BOARD_INTERFACE {mii_ethernet} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_ethernetlite_0


  # Create instance: axi_iic_0, and set properties
  set axi_iic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 axi_iic_0 ]
  set_property -dict [list \
    CONFIG.C_SCL_INERTIAL_DELAY {10} \
    CONFIG.C_SDA_INERTIAL_DELAY {10} \
    CONFIG.IIC_BOARD_INTERFACE {main_i2c} \
    CONFIG.IIC_FREQ_KHZ {400} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_iic_0


  # Create instance: axi_gpio_1, and set properties
  set axi_gpio_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1 ]
  set_property -dict [list \
    CONFIG.C_INTERRUPT_PRESENT {1} \
    CONFIG.GPIO_BOARD_INTERFACE {push_buttons_4bits} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $axi_gpio_1


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_NUM_MONITOR_SLOTS {2} \
    CONFIG.C_SLOT {1} \
    CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:icap_rtl:1.0} \
  ] $system_ila_0


  # Create instance: dfx_controller_0, and set properties
  set dfx_controller_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dfx_controller:1.0 dfx_controller_0 ]
  set_property -dict [list \
    CONFIG.ALL_PARAMS {HAS_AXI_LITE_IF 1 RESET_ACTIVE_LEVEL 0 CP_FIFO_DEPTH 32 CP_FIFO_TYPE lutram CDC_STAGES 6 VS {vs_shift {ID 0 NAME vs_shift RM {rm_shift_right {ID 0 NAME rm_shift_right BS {0 {ID 0\
ADDR 0 SIZE 0 CLEAR 0}} RESET_REQUIRED high} rm_shift_left {ID 1 NAME rm_shift_left BS {0 {ID 0 ADDR 0 SIZE 0 CLEAR 0}} RESET_REQUIRED high}} HAS_AXIS_STATUS 0 HAS_POR_RM 1 POR_RM rm_shift_right NUM_HW_TRIGGERS\
2} vs_count {ID 1 NAME vs_count RM {rm_count_up {ID 0 NAME rm_count_up BS {0 {ID 0 ADDR 0 SIZE 0 CLEAR 0}} RESET_REQUIRED high} rm_count_down {ID 1 NAME rm_count_down BS {0 {ID 0 ADDR 0 SIZE 0 CLEAR 0}}\
RESET_REQUIRED high}} HAS_AXIS_STATUS 0 HAS_POR_RM 1 POR_RM rm_count_up TRIGGER_TO_RM {} NUM_HW_TRIGGERS 2}} CP_FAMILY ultrascale_plus DIRTY 0} \
    CONFIG.GUI_LOCK_TRIGGER_0 {false} \
    CONFIG.GUI_RM_NEW_NAME {rm_shift_right} \
    CONFIG.GUI_RM_RESET_REQUIRED {high} \
    CONFIG.GUI_SELECT_RM {0} \
    CONFIG.GUI_SELECT_VS {0} \
    CONFIG.GUI_VS_NEW_NAME {vs_shift} \
    CONFIG.GUI_VS_NUM_HW_TRIGGERS {2} \
    CONFIG.GUI_VS_POR_RM {0} \
  ] $dfx_controller_0


  # Create instance: icap_wrapper_0, and set properties
  set block_name icap_wrapper
  set block_cell_name icap_wrapper_0
  if { [catch {set icap_wrapper_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $icap_wrapper_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins axi_gpio_0/GPIO] [get_bd_intf_pins red_leds_4bits]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins axi_uartlite_0/UART] [get_bd_intf_pins sys_uart]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins microblaze_0_axi_intc/interrupt] [get_bd_intf_pins interrupt]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins axi_ethernetlite_0/MII] [get_bd_intf_pins mii_ethernet]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI] [get_bd_intf_pins S_AXI]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins axi_ethernetlite_0/MDIO] [get_bd_intf_pins mdio_io]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins axi_iic_0/IIC] [get_bd_intf_pins main_i2c]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins axi_gpio_1/GPIO] [get_bd_intf_pins push_buttons_4bits]
  connect_bd_intf_net -intf_net dfx_controller_0_ICAP [get_bd_intf_pins dfx_controller_0/ICAP] [get_bd_intf_pins icap_wrapper_0/ICAP]
  connect_bd_intf_net -intf_net [get_bd_intf_nets dfx_controller_0_ICAP] [get_bd_intf_pins dfx_controller_0/ICAP] [get_bd_intf_pins system_ila_0/SLOT_1_ICAP]
  connect_bd_intf_net -intf_net dfx_controller_0_M_AXI_MEM [get_bd_intf_pins m_axi_mem] [get_bd_intf_pins dfx_controller_0/M_AXI_MEM]
  connect_bd_intf_net -intf_net [get_bd_intf_nets dfx_controller_0_M_AXI_MEM] [get_bd_intf_pins m_axi_mem] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI] [get_bd_intf_pins microblaze_0_axi_intc/s_axi]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M02_AXI [get_bd_intf_pins microblaze_0_axi_periph/M02_AXI] [get_bd_intf_pins axi_timer_0/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M03_AXI [get_bd_intf_pins microblaze_0_axi_periph/M03_AXI] [get_bd_intf_pins axi_uartlite_0/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M04_AXI [get_bd_intf_pins microblaze_0_axi_periph/M04_AXI] [get_bd_intf_pins axi_quad_spi_0/AXI_LITE]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M05_AXI [get_bd_intf_pins microblaze_0_axi_periph/M05_AXI] [get_bd_intf_pins axi_ethernetlite_0/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M06_AXI [get_bd_intf_pins microblaze_0_axi_periph/M06_AXI] [get_bd_intf_pins axi_iic_0/S_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M07_AXI [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net microblaze_0_axi_periph_M08_AXI [get_bd_intf_pins dfx_controller_0/s_axi_reg] [get_bd_intf_pins microblaze_0_axi_periph/M08_AXI]

  # Create port connections
  connect_bd_net -net S00_ACLK_1 [get_bd_pins S_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/M02_ACLK] [get_bd_pins microblaze_0_axi_periph/M03_ACLK] [get_bd_pins microblaze_0_axi_periph/M04_ACLK] [get_bd_pins axi_timer_0/s_axi_aclk] [get_bd_pins axi_quad_spi_0/s_axi_aclk] [get_bd_pins axi_quad_spi_0/ext_spi_clk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins microblaze_0_axi_intc/s_axi_aclk] [get_bd_pins axi_ethernetlite_0/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/M05_ACLK] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/M06_ACLK] [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins microblaze_0_axi_periph/M07_ACLK] [get_bd_pins microblaze_0_axi_periph/M08_ACLK] [get_bd_pins system_ila_0/clk] [get_bd_pins dfx_controller_0/clk] [get_bd_pins dfx_controller_0/icap_clk] [get_bd_pins icap_wrapper_0/clk]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins S_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/M02_ARESETN] [get_bd_pins microblaze_0_axi_periph/M03_ARESETN] [get_bd_pins microblaze_0_axi_periph/M04_ARESETN] [get_bd_pins axi_timer_0/s_axi_aresetn] [get_bd_pins axi_quad_spi_0/s_axi_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins microblaze_0_axi_intc/s_axi_aresetn] [get_bd_pins axi_ethernetlite_0/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M05_ARESETN] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M06_ARESETN] [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/M07_ARESETN] [get_bd_pins microblaze_0_axi_periph/M08_ARESETN] [get_bd_pins system_ila_0/resetn] [get_bd_pins dfx_controller_0/reset] [get_bd_pins dfx_controller_0/icap_reset]
  connect_bd_net -net axi_ethernetlite_0_ip2intc_irpt [get_bd_pins axi_ethernetlite_0/ip2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In3]
  connect_bd_net -net axi_gpio_1_ip2intc_irpt [get_bd_pins axi_gpio_1/ip2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In5]
  connect_bd_net -net axi_iic_0_iic2intc_irpt [get_bd_pins axi_iic_0/iic2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In4]
  connect_bd_net -net axi_quad_spi_0_ip2intc_irpt [get_bd_pins axi_quad_spi_0/ip2intc_irpt] [get_bd_pins microblaze_0_xlconcat/In2]
  connect_bd_net -net axi_timer_0_interrupt [get_bd_pins axi_timer_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In0]
  connect_bd_net -net axi_uartlite_0_interrupt [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In1]
  connect_bd_net -net clk_cpu_1 [get_bd_pins clk_cpu] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_intc/processor_clk]
  connect_bd_net -net dfx_controller_0_vsm_vs_count_rm_decouple [get_bd_pins dfx_controller_0/vsm_vs_count_rm_decouple] [get_bd_pins vs_count_rm_decouple]
  connect_bd_net -net dfx_controller_0_vsm_vs_count_rm_reset [get_bd_pins dfx_controller_0/vsm_vs_count_rm_reset] [get_bd_pins vs_count_rm_reset]
  connect_bd_net -net dfx_controller_0_vsm_vs_shift_rm_decouple [get_bd_pins dfx_controller_0/vsm_vs_shift_rm_decouple] [get_bd_pins vs_shift_rm_decouple]
  connect_bd_net -net dfx_controller_0_vsm_vs_shift_rm_reset [get_bd_pins dfx_controller_0/vsm_vs_shift_rm_reset] [get_bd_pins vs_shift_rm_reset]
  connect_bd_net -net dfxc_count_hw_trig_1 [get_bd_pins dfxc_count_hw_trig] [get_bd_pins dfx_controller_0/vsm_vs_count_hw_triggers]
  connect_bd_net -net dfxc_shift_hw_trig_1 [get_bd_pins dfxc_shift_hw_trig] [get_bd_pins dfx_controller_0/vsm_vs_shift_hw_triggers]
  connect_bd_net -net microblaze_0_xlconcat_dout [get_bd_pins microblaze_0_xlconcat/dout] [get_bd_pins microblaze_0_axi_intc/intr]
  connect_bd_net -net processor_rst_1 [get_bd_pins rst_cpu] [get_bd_pins microblaze_0_axi_intc/processor_rst]
  connect_bd_net -net rstn_clk_cpu_arstn_1 [get_bd_pins rstn_cpu_arstn] [get_bd_pins microblaze_0_axi_periph/ARESETN]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set sys_uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 sys_uart ]

  set red_leds_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 red_leds_4bits ]

  set ddr4_sdram [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr4_sdram ]

  set system_clock_300mhz [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 system_clock_300mhz ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $system_clock_300mhz

  set mii_ethernet [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mii_rtl:1.0 mii_ethernet ]

  set mdio_io [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_io ]

  set main_i2c [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 main_i2c ]

  set push_buttons_4bits [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 push_buttons_4bits ]


  # Create ports
  set system_resetn [ create_bd_port -dir I -type rst system_resetn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $system_resetn
  set dfxc_count_hw_trig [ create_bd_port -dir I -from 1 -to 0 dfxc_count_hw_trig ]
  set dfxc_shift_hw_trig [ create_bd_port -dir I -from 1 -to 0 dfxc_shift_hw_trig ]
  set vs_count_rm_decouple [ create_bd_port -dir O vs_count_rm_decouple ]
  set vs_count_rm_reset [ create_bd_port -dir O vs_count_rm_reset ]
  set vs_shift_rm_decouple [ create_bd_port -dir O vs_shift_rm_decouple ]
  set vs_shift_rm_reset [ create_bd_port -dir O vs_shift_rm_reset ]
  set clk_sys [ create_bd_port -dir O clk_sys ]

  # Create instance: peripherals
  create_hier_cell_peripherals [current_bd_instance .] peripherals

  # Create instance: ddr_rst_clk
  create_hier_cell_ddr_rst_clk [current_bd_instance .] ddr_rst_clk

  # Create instance: mb_system
  create_hier_cell_mb_system [current_bd_instance .] mb_system

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins peripherals/S_AXI] [get_bd_intf_pins mb_system/M_AXI_DP]
  connect_bd_intf_net -intf_net S02_AXI_1 [get_bd_intf_pins ddr_rst_clk/S_AXI_DFX] [get_bd_intf_pins peripherals/m_axi_mem]
  connect_bd_intf_net -intf_net S_AXI_DC_1 [get_bd_intf_pins ddr_rst_clk/S_AXI_DC] [get_bd_intf_pins mb_system/M_AXI_DC]
  connect_bd_intf_net -intf_net S_AXI_IC_1 [get_bd_intf_pins ddr_rst_clk/S_AXI_IC] [get_bd_intf_pins mb_system/M_AXI_IC]
  connect_bd_intf_net -intf_net ddr_mem_rst_clk_ddr4_sdram [get_bd_intf_ports ddr4_sdram] [get_bd_intf_pins ddr_rst_clk/ddr4_sdram]
  connect_bd_intf_net -intf_net peripherals_interrupt [get_bd_intf_pins peripherals/interrupt] [get_bd_intf_pins mb_system/INTERRUPT]
  connect_bd_intf_net -intf_net peripherals_main_i2c [get_bd_intf_ports main_i2c] [get_bd_intf_pins peripherals/main_i2c]
  connect_bd_intf_net -intf_net peripherals_mdio_io [get_bd_intf_ports mdio_io] [get_bd_intf_pins peripherals/mdio_io]
  connect_bd_intf_net -intf_net peripherals_mii_ethernet [get_bd_intf_ports mii_ethernet] [get_bd_intf_pins peripherals/mii_ethernet]
  connect_bd_intf_net -intf_net peripherals_push_buttons_4bits [get_bd_intf_ports push_buttons_4bits] [get_bd_intf_pins peripherals/push_buttons_4bits]
  connect_bd_intf_net -intf_net peripherals_red_leds_4bits [get_bd_intf_ports red_leds_4bits] [get_bd_intf_pins peripherals/red_leds_4bits]
  connect_bd_intf_net -intf_net peripherals_sys_uart [get_bd_intf_ports sys_uart] [get_bd_intf_pins peripherals/sys_uart]
  connect_bd_intf_net -intf_net system_clock_300mhz_1 [get_bd_intf_ports system_clock_300mhz] [get_bd_intf_pins ddr_rst_clk/system_clock_300mhz]

  # Create port connections
  connect_bd_net -net ddr_rst_clk_clk_cpu [get_bd_pins ddr_rst_clk/clk_cpu] [get_bd_pins mb_system/clk_cpu] [get_bd_pins peripherals/clk_cpu]
  connect_bd_net -net ddr_rst_clk_rst_cpu_lmb [get_bd_pins ddr_rst_clk/rst_cpu_lmb] [get_bd_pins mb_system/rst_cpu_lmb]
  connect_bd_net -net dfxc_count_hw_trig_1 [get_bd_ports dfxc_count_hw_trig] [get_bd_pins peripherals/dfxc_count_hw_trig]
  connect_bd_net -net dfxc_shift_hw_trig_1 [get_bd_ports dfxc_shift_hw_trig] [get_bd_pins peripherals/dfxc_shift_hw_trig]
  connect_bd_net -net mb_debug_sys_rst_1 [get_bd_pins mb_system/dbg_sys_rst] [get_bd_pins ddr_rst_clk/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins ddr_rst_clk/clk_sys] [get_bd_pins peripherals/S_ACLK] [get_bd_ports clk_sys]
  connect_bd_net -net peripherals_vs_count_rm_decouple [get_bd_pins peripherals/vs_count_rm_decouple] [get_bd_ports vs_count_rm_decouple]
  connect_bd_net -net peripherals_vs_count_rm_reset [get_bd_pins peripherals/vs_count_rm_reset] [get_bd_ports vs_count_rm_reset]
  connect_bd_net -net peripherals_vs_shift_rm_decouple [get_bd_pins peripherals/vs_shift_rm_decouple] [get_bd_ports vs_shift_rm_decouple]
  connect_bd_net -net peripherals_vs_shift_rm_reset [get_bd_pins peripherals/vs_shift_rm_reset] [get_bd_ports vs_shift_rm_reset]
  connect_bd_net -net rst_ddr4_0_100M_mb_reset [get_bd_pins ddr_rst_clk/rst_cpu] [get_bd_pins peripherals/rst_cpu] [get_bd_pins mb_system/rst_cpu]
  connect_bd_net -net rst_ddr4_0_100M_peripheral_aresetn [get_bd_pins ddr_rst_clk/sys_aresetn] [get_bd_pins peripherals/S_ARESETN]
  connect_bd_net -net rstn_cpu_arstn_1 [get_bd_pins ddr_rst_clk/rstn_cpu_arstn] [get_bd_pins peripherals/rstn_cpu_arstn]
  connect_bd_net -net system_resetn_1 [get_bd_ports system_resetn] [get_bd_pins ddr_rst_clk/system_resetn]

  # Create address segments
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces peripherals/dfx_controller_0/Data] [get_bd_addr_segs ddr_rst_clk/ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x40E00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs peripherals/axi_ethernetlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs peripherals/axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs peripherals/axi_gpio_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs peripherals/axi_iic_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs peripherals/axi_quad_spi_0/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x41C00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs peripherals/axi_timer_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs peripherals/axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs ddr_rst_clk/ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs peripherals/dfx_controller_0/s_axi_reg/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs mb_system/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Data] [get_bd_addr_segs peripherals/microblaze_0_axi_intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Instruction] [get_bd_addr_segs ddr_rst_clk/ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces mb_system/microblaze_0/Instruction] [get_bd_addr_segs mb_system/microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


