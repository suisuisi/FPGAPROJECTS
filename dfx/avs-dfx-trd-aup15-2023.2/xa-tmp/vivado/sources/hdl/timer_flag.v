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
//  /   /        Filename: timer_flag.v
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

module timer_flag (
  input      clk,
  input      vs_shift_decouple,
  input      vs_count_decouple,
  output     vs_shift_capture,
  output     vs_count_capture
  );

edge_det edge_det_count (
  .clk(clk),
  .din(vs_count_decouple),
  .rise_edge(),
  .fall_edge(vs_count_capture)
  );

edge_det edge_det_shift (
  .clk(clk),
  .din(vs_shift_decouple),
  .rise_edge(),
  .fall_edge(vs_shift_capture)
  );

endmodule