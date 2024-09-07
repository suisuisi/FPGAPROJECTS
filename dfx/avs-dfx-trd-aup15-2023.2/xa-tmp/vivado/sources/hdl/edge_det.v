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
//  /   /        Filename: edge_det.v
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

module edge_det (
  input       clk,
  input       din,
  output reg  rise_edge,
  output reg  fall_edge
  );

reg [1:0] shift;

always @(posedge clk)
begin
  shift <= {shift[0], din};

  if (shift == 2'b01)
    rise_edge <= 1'b1;
  else 
    rise_edge <= 1'b0;

  if (shift == 2'b10)
    fall_edge <= 1'b1;
  else 
    fall_edge <= 1'b0;
end

endmodule

