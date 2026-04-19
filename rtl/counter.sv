// -----------------------------------------------------------------------------
// Module  : counter
// Brief   : 4-bit modulo-10 counter (0 → 9 → repeat)
// Type    : Sequential (clocked)
//
// Inputs  : clk        - System clock
// Outputs : count[3:0] - Current count value
//
// Behavior:
//   - Increments on every rising clock edge
//   - Rolls over to 0 after reaching 9
//
// Notes   :
//   - Uses non-blocking assignments (<=)
//   - No reset (power-on value assumed 0 for simplicity)
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module counter (
  input  logic clk,
  input  logic rst,
  output logic [3:0] count
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      count <= 4'd0;
    else if (count == 4'd9)
      count <= 4'd0;
    else
      count <= count + 1;
  end

endmodule
