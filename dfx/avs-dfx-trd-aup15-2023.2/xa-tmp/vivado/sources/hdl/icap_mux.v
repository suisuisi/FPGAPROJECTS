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
//  /   /        Filename: icap_mux.v
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

module icap_mux (

(* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF vs_shift_axis_status:vs_count_axis_status" *) input icap_clk,

(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 SEM_ICAP avail" *)   output        sem_icap_avail,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 SEM_ICAP o" *)       output [31:0] sem_icap_o,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 SEM_ICAP prdone" *)  output        sem_icap_prdone,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 SEM_ICAP prerror" *) output        sem_icap_prerror,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 SEM_ICAP csib" *)    input         sem_icap_csib,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 SEM_ICAP i" *)       input [31:0]  sem_icap_i,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 SEM_ICAP rdwrb" *)   input         sem_icap_rdwrb,

(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 DFXC_ICAP avail" *)   output        dfxc_icap_avail,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 DFXC_ICAP o" *)       output [31:0] dfxc_icap_o,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 DFXC_ICAP prdone" *)  output        dfxc_icap_prdone,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 DFXC_ICAP prerror" *) output        dfxc_icap_prerror,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 DFXC_ICAP csib" *)    input         dfxc_icap_csib,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 DFXC_ICAP i" *)       input [31:0]  dfxc_icap_i,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 DFXC_ICAP rdwrb" *)   input         dfxc_icap_rdwrb,

(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 ICAP avail" *)       input         icap_avail,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 ICAP o" *)           input [31:0]  icap_o,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 ICAP prdone" *)      input         icap_prdone,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 ICAP prerror" *)     input         icap_prerror,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 ICAP csib" *)        output        icap_csib,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 ICAP i" *)           output [31:0] icap_i,
(* X_INTERFACE_INFO = "xilinx.com:interface:icap_rtl:1.0 ICAP rdwrb" *)       output        icap_rdwrb,

(* X_INTERFACE_INFO = "xilinx.com:interface:cap:1.0 sem_icap_arbiter REL" *)  output reg    sem_icap_rel = 1'b0,
(* X_INTERFACE_INFO = "xilinx.com:interface:cap:1.0 sem_icap_arbiter GNT" *)  output reg    sem_icap_gnt = 1'b0,
(* X_INTERFACE_INFO = "xilinx.com:interface:cap:1.0 sem_icap_arbiter REQ" *)  input         sem_icap_req,

(* X_INTERFACE_INFO = "xilinx.com:interface:cap:1.0 dfxc_icap_arbiter REL" *)  output reg    dfxc_icap_rel = 1'b0,
(* X_INTERFACE_INFO = "xilinx.com:interface:cap:1.0 dfxc_icap_arbiter GNT" *)  output reg    dfxc_icap_gnt = 1'b0,
(* X_INTERFACE_INFO = "xilinx.com:interface:cap:1.0 dfxc_icap_arbiter REQ" *)  input         dfxc_icap_req,

(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 vs_shift_axis_status TDATA" *)   input [31:0] vs_shift_axis_status_tdata,
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 vs_shift_axis_status TVALID" *)  input        vs_shift_axis_status_tvalid,

(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 vs_count_axis_status TDATA" *)   input [31:0] vs_count_axis_status_tdata,
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 vs_count_axis_status TVALID" *)  input        vs_count_axis_status_tvalid

);
//No PRDONE version

reg       vs_shift_err           = 1'b0;
reg       vs_shift_loading       = 1'b0;
reg [1:0] vs_shift_loading_shift = 2'b0;
reg       vs_count_err           = 1'b0;
reg       vs_count_loading       = 1'b0;
reg [1:0] vs_count_loading_shift = 2'b0;
reg       vs_loading_end         = 1'b0;
reg [2:0] state                  = 3'b0;

localparam ST_IDLE         = 0;
localparam ST_SEM_GNT      = 1;
localparam ST_SEM_WAIT_REL = 2;
localparam ST_DFXC_GNT      = 3;
localparam ST_DFXC_WAIT_REL = 4;

//ICAP MUX
assign icap_csib  = (sem_icap_gnt)? sem_icap_csib  : ((dfxc_icap_gnt)? dfxc_icap_csib  : 1'b1);
assign icap_rdwrb = (sem_icap_gnt)? sem_icap_rdwrb : ((dfxc_icap_gnt)? dfxc_icap_rdwrb : 1'b1);
assign icap_i     = (sem_icap_gnt)? sem_icap_i     : ((dfxc_icap_gnt)? dfxc_icap_i     : 32'b0);

assign sem_icap_avail   = icap_avail;
assign sem_icap_o       = icap_o;
assign sem_icap_prdone  = icap_prdone ;
assign sem_icap_prerror = icap_prerror;

assign dfxc_icap_avail   = icap_avail;
assign dfxc_icap_o       = icap_o;
assign dfxc_icap_prdone  = icap_prdone;
assign dfxc_icap_prerror = icap_prerror;


//DFXC error status extraction
always @(posedge icap_clk)
begin
  if (vs_shift_axis_status_tvalid)
    vs_shift_err <= |vs_shift_axis_status_tdata[6:3];

  if (vs_count_axis_status_tvalid)
    vs_count_err <= |vs_count_axis_status_tdata[6:3];
end


//DFXC loading finish flag creation 
always @(posedge icap_clk)
begin
  if (vs_shift_axis_status_tvalid && vs_shift_axis_status_tdata[2:0] == 3'b100)
    vs_shift_loading <= 1'b1;
  else if (vs_shift_axis_status_tvalid && vs_shift_axis_status_tdata[2:0] != 3'b100)
    vs_shift_loading <= 1'b0;

  if (vs_count_axis_status_tvalid && vs_count_axis_status_tdata[2:0] == 3'b100)
    vs_count_loading <= 1'b1;
  else if (vs_count_axis_status_tvalid && vs_count_axis_status_tdata[2:0] != 3'b100)
    vs_count_loading <= 1'b0;

  vs_shift_loading_shift <= {vs_shift_loading_shift, vs_shift_loading};
  vs_count_loading_shift <= {vs_count_loading_shift, vs_count_loading};
  
  if (vs_shift_loading_shift == 2'b10 || vs_count_loading_shift == 2'b10)
    vs_loading_end <= 1'b1;
  else
    vs_loading_end <= 1'b0;
end


//ICAP arbitoration state machine
always @(posedge icap_clk)
begin
  case (state)
  ST_IDLE :
    begin
      if (sem_icap_gnt == 1'b1)
        state <= ST_SEM_GNT;
      else if (dfxc_icap_gnt == 1'b1)
        state <= ST_DFXC_GNT;
      else if (sem_icap_req == 1'b1)
        state <= ST_SEM_GNT;
      else if (dfxc_icap_req == 1'b1)
        state <= ST_DFXC_GNT;
      else
        state <= ST_IDLE;
    end

  ST_SEM_GNT :
    begin
      sem_icap_gnt <= 1'b1;

      if (dfxc_icap_req == 1'b1)
        state <= ST_SEM_WAIT_REL;
    end

  ST_SEM_WAIT_REL :
    begin
      sem_icap_rel <= 1'b1;

      if (sem_icap_req == 1'b0)
        begin
          sem_icap_rel <= 1'b0;
          sem_icap_gnt <= 1'b0;
          state <= ST_DFXC_GNT;
        end
    end

  ST_DFXC_GNT :
    begin
      dfxc_icap_gnt <= 1'b1;

      if (sem_icap_req == 1'b1)
        state <= ST_DFXC_WAIT_REL;
    end

  ST_DFXC_WAIT_REL :
    begin
      dfxc_icap_rel <= 1'b1;

      //If error is not detected after PR, DFXC release ICAP(If there's error, hold ICAP and need to fix error)
      if (dfxc_icap_req == 1'b0 && vs_loading_end && (vs_count_err == 1'b0 && vs_shift_err == 1'b0))
        begin
          dfxc_icap_rel <= 1'b0;
          dfxc_icap_gnt <= 1'b0;
          state <= ST_SEM_GNT;
        end
    end

  default :
    begin
      dfxc_icap_gnt <= 1'b0;
      sem_icap_gnt <= 1'b0;
      dfxc_icap_rel <= 1'b0;
      sem_icap_rel <= 1'b0;
      state <= ST_IDLE;
    end
  endcase
end

endmodule