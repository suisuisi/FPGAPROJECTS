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
//  /   /        Filename: sem_monitor_fifo.v
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
/////////////////////////////////////////////////////////////////////////////
//
// Module Description:
//
// This module contains a 32x8 synchronous FIFO implementation.
//
/////////////////////////////////////////////////////////////////////////////
//
// Port Definition:
//
// Name                          Type   Description
// ============================= ====== ====================================
// icap_clk                      input  The system clock signal.
//
// data_in[7:0]                  input  Input to the FIFO. Synchronous
//                                      to icap_clk.
//
// data_out[7:0]                 output Output from the FIFO.  Synchronous
//                                      to icap_clk.
//
// write                         input  Write strobe, used to enable data
//                                      capture.  Synchronous to icap_clk.
//
// read                          input  Read strobe, used to advance data
//                                      output to next value.  Synchronous
//                                      to icap_clk.
//
// full                          output Indicates when the FIFO is full.
//                                      Synchronous to icap_clk.
//
// data_present                  output Indicates when the FIFO has data
//                                      (not empty). Synchronous to icap_clk.
//
/////////////////////////////////////////////////////////////////////////////
//
// Parameter and Localparam Definition:
//
// Name                          Type   Description
// ============================= ====== ====================================
// TCQ                           int    Sets the clock-to-out for behavioral
//                                      descriptions of sequential logic.
//
/////////////////////////////////////////////////////////////////////////////
//
// Module Dependencies:
//
// sem_ultra_uart_fifo
// |
// \- SRLC32E (unisim)
//
/////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

/////////////////////////////////////////////////////////////////////////////
// Module
/////////////////////////////////////////////////////////////////////////////

module sem_monitor_fifo (
  input  wire        icap_clk,
  input  wire  [7:0] data_in,
  output wire  [7:0] data_out,
  input  wire        write,
  input  wire        read,
  output wire        full,
  output wire        data_present
  );

  ///////////////////////////////////////////////////////////////////////////
  // Define local constants.
  ///////////////////////////////////////////////////////////////////////////

  localparam TCQ = 1;

  ///////////////////////////////////////////////////////////////////////////
  // Declare signals.
  ///////////////////////////////////////////////////////////////////////////

  reg   [5:0] augend = 6'b011111;
  reg   [5:0] addend;
  wire  [1:0] addsel;
  wire        valid_write;
  wire        valid_read;

  ///////////////////////////////////////////////////////////////////////////
  // Data storage.
  ///////////////////////////////////////////////////////////////////////////

  SRLC32E data_srl_0 (
    .D(data_in[0]),
    .CE(write),
    .CLK(icap_clk),
    .A(augend[4:0]),
    .Q(data_out[0]),
    .Q31());

  SRLC32E data_srl_1 (
    .D(data_in[1]),
    .CE(write),
    .CLK(icap_clk),
    .A(augend[4:0]),
    .Q(data_out[1]),
    .Q31());

  SRLC32E data_srl_2 (
    .D(data_in[2]),
    .CE(write),
    .CLK(icap_clk),
    .A(augend[4:0]),
    .Q(data_out[2]),
    .Q31());

  SRLC32E data_srl_3 (
    .D(data_in[3]),
    .CE(write),
    .CLK(icap_clk),
    .A(augend[4:0]),
    .Q(data_out[3]),
    .Q31());

  SRLC32E data_srl_4 (
    .D(data_in[4]),
    .CE(write),
    .CLK(icap_clk),
    .A(augend[4:0]),
    .Q(data_out[4]),
    .Q31());

  SRLC32E data_srl_5 (
    .D(data_in[5]),
    .CE(write),
    .CLK(icap_clk),
    .A(augend[4:0]),
    .Q(data_out[5]),
    .Q31());

  SRLC32E data_srl_6 (
    .D(data_in[6]),
    .CE(write),
    .CLK(icap_clk),
    .A(augend[4:0]),
    .Q(data_out[6]),
    .Q31());

  SRLC32E data_srl_7 (
    .D(data_in[7]),
    .CE(write),
    .CLK(icap_clk),
    .A(augend[4:0]),
    .Q(data_out[7]),
    .Q31());

  ///////////////////////////////////////////////////////////////////////////
  // Buffer management.
  ///////////////////////////////////////////////////////////////////////////

  assign valid_write = write && !(augend == 6'b111111);
  assign valid_read = read && augend[5];
  assign addsel = {valid_read, valid_write};

  always @*
  begin
    case (addsel)
      2'b01: addend = 6'b000001;
      2'b10: addend = 6'b111111;
      default: addend = 6'b000000;
    endcase
  end

  always @(posedge icap_clk)
  begin
    augend <= #TCQ (augend + addend);
  end

  assign data_present = augend[5];
  assign full = (augend == 6'b111111);

  ///////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////////

endmodule

/////////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////////
