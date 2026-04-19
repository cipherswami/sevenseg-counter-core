// -----------------------------------------------------------------------------
// Module  : top
// Brief   : Top-level integration of clock divider, counter, and 7-seg decoder
// Type    : Structural (integration layer)
//
// Inputs  :
//   clk        - System clock (FPGA clock)
//   rst        - Active-high reset
//
// Outputs :
//   seg [6:0]  - 7-segment display outputs
//
// Structure:
//   clk → clock_divider → counter → seg7_decoder → seg
//
// Notes   :
//   - Output is inverted for active-low 7-segment displays
//   - DIV parameter controls visible counting speed
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module top #(
  parameter int DIV = 25_000_000   // adjust for your FPGA clock
)(
  input  logic clk,
  input  logic rst,
  output logic [6:0] seg
);

  // -------------------------
  // Internal signals
  // -------------------------
  logic slow_clk;
  logic [3:0] count;
  logic [6:0] seg_raw;

  // -------------------------
  // Clock Divider
  // -------------------------
  clock_divider #(
    .DIV(DIV)
  ) u_div (
    .clk      (clk),
    .rst      (rst),
    .slow_clk (slow_clk)
  );

  // -------------------------
  // Counter (0–9)
  // -------------------------
  counter u_counter (
    .clk   (slow_clk),
    .rst   (rst),
    .count (count)
  );

  // -------------------------
  // 7-Segment Decoder
  // -------------------------
  seg7_decoder u_decoder (
    .bcd (count),
    .seg (seg_raw)
  );

  // -------------------------
  // Output mapping
  // -------------------------
  // Most FPGA boards use active-low 7-seg
  assign seg = ~seg_raw;

endmodule
