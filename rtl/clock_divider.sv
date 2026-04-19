// -----------------------------------------------------------------------------
// Module  : clock_divider
// Brief   : Divides input clock to generate a slower clock signal
// Type    : Sequential (clocked)
//
// Parameters:
//   DIV - Number of input clock cycles before toggling output
//
// Inputs  : clk       - High-frequency input clock
//           rst       - Resets the divider
//
// Outputs : slow_clk  - Reduced-frequency clock
//
// Behavior:
//   - Counts up to DIV-1, then resets counter
//   - Toggles slow_clk on each wrap
//   - Output frequency = clk / (2 × DIV)
//
// Notes   :
//   - Used to slow down system for human-visible output
//   - Adjust DIV based on input clock frequency
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module clock_divider #(
  parameter int DIV = 25_000_000
)(
  input  logic clk,
  input  logic rst,        // <-- ADD RESET
  output logic slow_clk
);

  logic [$clog2(DIV)-1:0] count;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      count    <= 0;
      slow_clk <= 0;       // <-- initialize
    end
    else if (count == DIV-1) begin
      count    <= 0;
      slow_clk <= ~slow_clk;
    end
    else begin
      count <= count + 1;
    end
  end

endmodule
