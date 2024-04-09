/*
 * Basys3 top level module to test the design in an FPGA.
 *
 * Copyright (c) 2024 Martin Schoeberl
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module basys3_top (
    input  wire [15:0] sw,    // Switches
    output  wire [7:0] led,   // LEDs
    output  wire [6:0] seg,   // 7-segment
    output  wire dp,          // 7-segment
    output  wire [3:0] an,    // 7-segment
    input  wire clock,        // clock
    input  wire reset         // reset - high active
);

    assign seg = 7'b0000000;
    assign dp = 1'b0;
    assign an = 4'b1110;

    wire rst_n = ~reset;
    wire ena = 1'b1;
    // TODO: add a crude clock divider to slow down the clock to 50 MHz
    wire clk = clock;
    wire [7:0] ui_in = sw [7:0];
    wire [7:0] uo_out;
    wire [7:0] uio_in = sw [15:8];
    wire [7:0] uio_out; // TODO: shall go to PMOD, depending on the design
    wire [7:0] uio_oe;  // ignored

    tt_um_example user_project (
          .ui_in  (ui_in),    // Dedicated inputs
          .uo_out (uo_out),   // Dedicated outputs
          .uio_in (uio_in),   // IOs: Input path
          .uio_out(uio_out),  // IOs: Output path
          .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
          .ena    (ena),      // enable - goes high when design is selected
          .clk    (clk),      // clock
          .rst_n  (rst_n)     // not reset
      );

    assign led = uo_out;

endmodule