//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2005-2020 Xilinx, Inc.
// This design is confidential and proprietary of Xilinx, Inc.
// All Rights Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor: Xilinx
// \   \   \/    Version: 2020.1
//  \   \        Application: Dynamic Function eXchange tutorial
//  /   /        Filename: sem_command.v
// /___/   /\    Date Last Modified: 14 FEB 2020
// \   \  /  \
//  \___\/\___\
//
//
//
// Board:  VCU118 or KCU116
// Device: xcvu9p or xcku5p
// Design Name: dfxc_usp
// Purpose: Dynamic Function eXchange Tutorial

module sem_command (
  input         clk,
  input         command_busy,
  output [43:0] command_code,
  output reg    command_strobe,
  output        vio_sem_en
  );


reg  [1:0] vio_write_rise;
wire [3:0] vio_command;
wire [6:0] vio_word;
wire [4:0] vio_bit;

//For UltraScale+
assign command_code = {vio_command[3:0], 8'h00, 2'b00, 18'h3ffff, vio_word[6:0], vio_bit[4:0]};

always @(posedge clk)
begin
  vio_write_rise <= {vio_write_rise[0], vio_write};
  if (vio_write_rise == 2'b01 && command_busy == 1'b0)
    command_strobe <= 1'b1;
  else
    command_strobe <= 1'b0;
end

vio_sem_command u_vio_sem_command (
  .clk(clk),                // input wire clk
  .probe_in0(command_busy),    // input wire [0 : 0] probe_in0
  .probe_out0(vio_command),  // output wire [3 : 0] probe_out0
  .probe_out1(vio_word),  // output wire [6 : 0] probe_out1
  .probe_out2(vio_bit),  // output wire [4 : 0] probe_out2
  .probe_out3(vio_write),
  .probe_out4(vio_sem_en)
);

endmodule