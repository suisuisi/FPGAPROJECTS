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
//  /   /        Filename: sem_wrapper.v
// /___/   /\    Date Last Modified: 14 FEB 2020
// \   \  /  \
//  \___\/\___\
//
//
//
// Board:  VCU118
// Device: xcvu9p
// Design Name: dfxc_usp
// Purpose: Dynamic Function eXchange Tutorial

module sem_wrapper(
  input         icap_clk,
  input [31:0]  icap_o,
  output        icap_csib,
  output        icap_rdwrb,
  output [31:0] icap_i,
  input         icap_prerror,
  input         icap_prdone,
  input         icap_avail,
  input         icap_rel,
  input         icap_gnt,
  output        icap_req
  );

  wire [7:0]  monitor_txdata;
  wire        monitor_txwrite;
  wire        monitor_txfull;
  wire [7:0]  monitor_data;
  wire        monitor_valid;

  wire        command_strobe;
  wire        command_busy;
  wire [43:0] command_code;
  wire        command_strobe_pulse;
  reg         command_strobe_delay;

  wire        status_heartbeat;
  wire        status_initialization;
  wire        status_observation;
  wire        status_correction;
  wire        status_classification;
  wire        status_injection;
  wire        status_diagnostic_scan;
  wire        status_detect_only;
  wire        status_essential;
  wire        status_uncorrectable;

  wire        slr0_fecc_eccerrornotsingle;
  wire        slr0_fecc_eccerrorsingle;
  wire        slr0_fecc_endofframe;
  wire        slr0_fecc_endofscan;
  wire        slr0_fecc_crcerror;
  wire [26:0] slr0_fecc_far;
  wire [1:0]  slr0_fecc_farsel;

  wire        slr1_fecc_eccerrornotsingle;
  wire        slr1_fecc_eccerrorsingle;
  wire        slr1_fecc_endofframe;
  wire        slr1_fecc_endofscan;
  wire        slr1_fecc_crcerror;
  wire [26:0] slr1_fecc_far;
  wire [1:0]  slr1_fecc_farsel;

  wire        slr2_fecc_eccerrornotsingle;
  wire        slr2_fecc_eccerrorsingle;
  wire        slr2_fecc_endofframe;
  wire        slr2_fecc_endofscan;
  wire        slr2_fecc_crcerror;
  wire [26:0] slr2_fecc_far;
  wire [1:0]  slr2_fecc_farsel;

  reg [4:0]   status_idle_cnt;

//SEM Enable via VIO
assign icap_req = icap_req_temp & vio_sem_en;

//SEM idle status detection
assign status_idle = ~(status_initialization
                       | status_observation
                       | status_correction
                       | status_classification
                       | status_injection
                       | status_essential
                       | status_uncorrectable
                       | status_diagnostic_scan
                       | status_detect_only)
                       & (icap_gnt & icap_req);

always @(posedge icap_clk)
begin
  if (~status_idle)
    status_idle_cnt <= 5'b0;
  else if (status_idle_cnt[4] == 1'b1)
    status_idle_cnt <= status_idle_cnt;
  else
    status_idle_cnt <= status_idle_cnt + 1'b1;
end

assign status_idle_flag = status_idle_cnt[4];
//----

//SEM accept ICAP REL during specified status only
assign icap_rel_int = icap_rel & (status_observation | status_diagnostic_scan | status_detect_only | status_idle_flag);

sem_ultra_ssi u_sem (
//  .slr0_status_heartbeat(slr0_status_heartbeat),              // output wire slr0_status_heartbeat
//  .slr1_status_heartbeat(slr1_status_heartbeat),              // output wire slr1_status_heartbeat
//  .slr2_status_heartbeat(slr2_status_heartbeat),              // output wire slr2_status_heartbeat
  .status_initialization(status_initialization),              // output wire status_initialization
  .status_observation(status_observation),                    // output wire status_observation
  .status_correction(status_correction),                      // output wire status_correction
  .status_classification(status_classification),              // output wire status_classification
  .status_injection(status_injection),                        // output wire status_injection
  .status_essential(status_essential),                        // output wire status_essential
  .status_uncorrectable(status_uncorrectable),                // output wire status_uncorrectable
  .status_diagnostic_scan(status_diagnostic_scan),            // output wire status_diagnostic_scan
  .status_detect_only(status_detect_only),                    // output wire status_detect_only
  .monitor_txdata(monitor_txdata),                            // output wire [7 : 0] monitor_txdata
  .monitor_txwrite(monitor_txwrite),                          // output wire monitor_txwrite
  .monitor_txfull(monitor_txfull),                            // input wire monitor_txfull
  .monitor_rxdata(8'b0),                                      // input wire [7 : 0] monitor_rxdata
  .monitor_rxread(),                                          // output wire monitor_rxread
  .monitor_rxempty(1'b1),                                     // input wire monitor_rxempty
  .command_strobe(command_strobe_pulse),                            // input wire command_strobe
  .command_busy(command_busy),                                // output wire command_busy
  .command_code(command_code),                                // input wire [43 : 0] command_code
  .icap_clk(icap_clk),                                        // input wire icap_clk
  .icap_o(icap_o),                                            // input wire [31 : 0] icap_o
  .icap_csib(icap_csib),                                      // output wire icap_csib
  .icap_rdwrb(icap_rdwrb),                                    // output wire icap_rdwrb
  .icap_i(icap_i),                                            // output wire [31 : 0] icap_i
  .icap_prerror(icap_prerror),                                // input wire icap_prerror
  .icap_prdone(icap_prdone),                                  // input wire icap_prdone
  .icap_avail(icap_avail),                                    // input wire icap_avail
  .cap_rel(icap_rel),                                         // input wire cap_rel
  .cap_gnt(icap_gnt),                                         // input wire cap_gnt
  .cap_req(icap_req_temp),                                    // output wire cap_req
  .fecc_eccerrornotsingle(slr0_fecc_eccerrornotsingle),  // input wire slr0_fecc_eccerrornotsingle
  .fecc_eccerrorsingle(slr0_fecc_eccerrorsingle),
  .fecc_endofframe(slr0_fecc_endofframe),
  .fecc_endofscan(slr0_fecc_endofscan),
  .fecc_far(slr0_fecc_far),
  .fecc_crcerror(slr0_fecc_crcerror),
//  .slr0_fecc_eccerrornotsingle(slr0_fecc_eccerrornotsingle),  // input wire slr0_fecc_eccerrornotsingle
//  .slr0_fecc_eccerrorsingle(slr0_fecc_eccerrorsingle),        // input wire slr0_fecc_eccerrorsingle
//  .slr0_fecc_endofframe(slr0_fecc_endofframe),                // input wire slr0_fecc_endofframe
//  .slr0_fecc_endofscan(slr0_fecc_endofscan),                  // input wire slr0_fecc_endofscan
//  .slr0_fecc_crcerror(slr0_fecc_crcerror),                    // input wire slr0_fecc_crcerror
//  .slr0_fecc_far(slr0_fecc_far),                              // input wire [26 : 0] slr0_fecc_far
//  .slr0_fecc_farsel(slr0_fecc_farsel),                        // output wire [1 : 0] slr0_fecc_farsel
//  .slr1_fecc_eccerrornotsingle(slr1_fecc_eccerrornotsingle),  // input wire slr1_fecc_eccerrornotsingle
//  .slr1_fecc_eccerrorsingle(slr1_fecc_eccerrorsingle),        // input wire slr1_fecc_eccerrorsingle
//  .slr1_fecc_endofframe(slr1_fecc_endofframe),                // input wire slr1_fecc_endofframe
//  .slr1_fecc_endofscan(slr1_fecc_endofscan),                  // input wire slr1_fecc_endofscan
//  .slr1_fecc_crcerror(slr1_fecc_crcerror),                    // input wire slr1_fecc_crcerror
//  .slr1_fecc_far(slr1_fecc_far),                              // input wire [26 : 0] slr1_fecc_far
//  .slr1_fecc_farsel(slr1_fecc_farsel),                        // output wire [1 : 0] slr1_fecc_farsel
//  .slr2_fecc_eccerrornotsingle(slr2_fecc_eccerrornotsingle),  // input wire slr2_fecc_eccerrornotsingle
//  .slr2_fecc_eccerrorsingle(slr2_fecc_eccerrorsingle),        // input wire slr2_fecc_eccerrorsingle
//  .slr2_fecc_endofframe(slr2_fecc_endofframe),                // input wire slr2_fecc_endofframe
//  .slr2_fecc_endofscan(slr2_fecc_endofscan),                  // input wire slr2_fecc_endofscan
//  .slr2_fecc_crcerror(slr2_fecc_crcerror),                    // input wire slr2_fecc_crcerror
//  .slr2_fecc_far(slr2_fecc_far),                              // input wire [26 : 0] slr2_fecc_far
//  .slr2_fecc_farsel(slr2_fecc_farsel),                        // output wire [1 : 0] slr2_fecc_farsel
  .aux_error_cr_ne(1'b0),                                     // input wire aux_error_cr_ne
  .aux_error_cr_es(1'b0),                                     // input wire aux_error_cr_es
  .aux_error_uc(1'b0)                                         // input wire aux_error_uc
);

FRAME_ECCE4 u_frame_ecc_slr0 (
  .CRCERROR(slr0_fecc_crcerror),
  .ECCERRORNOTSINGLE(slr0_fecc_eccerrornotsingle),
  .ECCERRORSINGLE(slr0_fecc_eccerrorsingle),
  .ENDOFFRAME(slr0_fecc_endofframe),
  .ENDOFSCAN(slr0_fecc_endofscan),
  .FAR(slr0_fecc_far),
  .FARSEL(slr0_fecc_farsel),
  .ICAPBOTCLK(),
  .ICAPTOPCLK(icap_clk)
  );

FRAME_ECCE4 u_frame_ecc_slr1 (
  .CRCERROR(slr1_fecc_crcerror),
  .ECCERRORNOTSINGLE(slr1_fecc_eccerrornotsingle),
  .ECCERRORSINGLE(slr1_fecc_eccerrorsingle),
  .ENDOFFRAME(slr1_fecc_endofframe),
  .ENDOFSCAN(slr1_fecc_endofscan),
  .FAR(slr1_fecc_far),
  .FARSEL(slr1_fecc_farsel),
  .ICAPBOTCLK(),
  .ICAPTOPCLK(icap_clk)
  );

FRAME_ECCE4 u_frame_ecc_slr2 (
  .CRCERROR(slr2_fecc_crcerror),
  .ECCERRORNOTSINGLE(slr2_fecc_eccerrornotsingle),
  .ECCERRORSINGLE(slr2_fecc_eccerrorsingle),
  .ENDOFFRAME(slr2_fecc_endofframe),
  .ENDOFSCAN(slr2_fecc_endofscan),
  .FAR(slr2_fecc_far),
  .FARSEL(slr2_fecc_farsel),
  .ICAPBOTCLK(),
  .ICAPTOPCLK(icap_clk)
  );

sem_command u_sem_command (
  .clk(icap_clk),
  .command_strobe(command_strobe),
  .command_busy(command_busy),
  .command_code(command_code),
  .vio_sem_en(vio_sem_en)
  );

///////////////////////////////////////////////////////////////////////////
// Create a single-cycle pulse from the VIO command_strobe output to ensure a
// single command is issued to the SEM controller.
///////////////////////////////////////////////////////////////////////////
always @(posedge icap_clk)
begin
  command_strobe_delay <= command_strobe;
end

assign command_strobe_pulse = !command_strobe && command_strobe_delay;

sem_monitor_fifo u_sem_monitor_fifo (
  .icap_clk(icap_clk),
  .data_in(monitor_txdata),
  .data_out(monitor_data),
  .data_present(monitor_valid),
  .write(monitor_txwrite),
  .read(1'b1),
  .full(monitor_txfull)
  );

ila_sem_ssi u_ila_sem (
  .clk(icap_clk),                   // input wire clk

  .probe0(slr0_status_heartbeat),        // input wire [0:0]  probe0
  .probe1(slr1_status_heartbeat),        // input wire [0:0]  probe0
  .probe2(slr2_status_heartbeat),        // input wire [0:0]  probe0
  .probe3(status_initialization),   // input wire [0:0]  probe1
  .probe4(status_observation),      // input wire [0:0]  probe2
  .probe5(status_correction),       // input wire [0:0]  probe3
  .probe6(status_classification),   // input wire [0:0]  probe4
  .probe7(status_injection),        // input wire [0:0]  probe5
  .probe8(status_diagnostic_scan),  // input wire [0:0]  probe6
  .probe9(status_detect_only),      // input wire [0:0]  probe7
  .probe10(status_essential),        // input wire [0:0]  probe8
  .probe11(status_uncorrectable),    // input wire [0:0]  probe9

  .probe12(slr0_fecc_eccerrornotsingle), // input wire [0:0]  probe10
  .probe13(slr0_fecc_eccerrorsingle),    // input wire [0:0]  probe11
  .probe14(slr0_fecc_endofframe),        // input wire [0:0]  probe12
  .probe15(slr0_fecc_endofscan),         // input wire [0:0]  probe13
  .probe16(slr0_fecc_crcerror),          // input wire [0:0]  probe14
  .probe17(slr0_fecc_far),               // input wire [26:0]  probe15
  .probe18(slr0_fecc_farsel),            // input wire [1:0]  probe16

  .probe19(slr1_fecc_eccerrornotsingle), // input wire [0:0]  probe10
  .probe20(slr1_fecc_eccerrorsingle),    // input wire [0:0]  probe11
  .probe21(slr1_fecc_endofframe),        // input wire [0:0]  probe12
  .probe22(slr1_fecc_endofscan),         // input wire [0:0]  probe13
  .probe23(slr1_fecc_crcerror),          // input wire [0:0]  probe14
  .probe24(slr1_fecc_far),               // input wire [26:0]  probe15
  .probe25(slr1_fecc_farsel),            // input wire [1:0]  probe16

  .probe26(slr2_fecc_eccerrornotsingle), // input wire [0:0]  probe10
  .probe27(slr2_fecc_eccerrorsingle),    // input wire [0:0]  probe11
  .probe28(slr2_fecc_endofframe),        // input wire [0:0]  probe12
  .probe29(slr2_fecc_endofscan),         // input wire [0:0]  probe13
  .probe30(slr2_fecc_crcerror),          // input wire [0:0]  probe14
  .probe31(slr2_fecc_far),               // input wire [26:0]  probe15
  .probe32(slr2_fecc_farsel),            // input wire [1:0]  probe16

  .probe33(monitor_data),           // input wire [7:0]  probe17
  .probe34(monitor_valid),          // input wire [0:0]  probe18

  .probe35(icap_avail),             // input wire [0:0]  probe19
  .probe36(icap_rel_int),           // input wire [0:0]  probe20
  .probe37(icap_gnt),               // input wire [0:0]  probe21
  .probe38(icap_req),               // input wire [0:0]  probe22
  .probe39(icap_o),                 // input wire [31:0]  probe23
  .probe40(icap_i),                 // input wire [31:0]  probe24
  .probe41(icap_csib),              // input wire [0:0]  probe25
  .probe42(icap_rdwrb),             // input wire [0:0]  probe26
  .probe43(icap_prerror),           // input wire [0:0]  probe27
  .probe44(icap_prdone)             // input wire [0:0]  probe28
);

endmodule
