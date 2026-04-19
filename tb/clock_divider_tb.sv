// -----------------------------------------------------------------------------
// Module  : clock_divider_tb
// Brief   : Testbench for clock_divider
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module clock_divider_tb;

  logic clk;
  logic rst;
  logic slow_clk;
  logic prev;

  int pass_count;
  int fail_count;

  // -------------------------
  // Clock generation
  // -------------------------
  initial clk = 0;
  always #1 clk = ~clk;

  // -------------------------
  // DUT
  // -------------------------
  localparam int DIV = 4;

  clock_divider #(
    .DIV(DIV)
  ) dut (
    .clk      (clk),
    .rst      (rst),
    .slow_clk (slow_clk)
  );

  // ----------------------------------------
  // Test sequence
  // ----------------------------------------
  initial begin
    $dumpfile("sim/divider.vcd");
    $dumpvars(0, clock_divider_tb);

    pass_count = 0;
    fail_count = 0;

    $display("========================================");
    $display("     CLOCK DIVIDER TESTBENCH");
    $display("========================================");

    // -------------------------
    // Reset
    // -------------------------
    rst = 1;
    repeat (2) @(posedge clk);
    rst = 0;

    // allow stabilization after reset
    repeat (2) @(posedge clk);

    $display("\n----------------------------------------");
    $display("checking toggle behavior");
    $display("----------------------------------------");

    prev = slow_clk;

    // -------------------------
    // Check toggling
    // -------------------------
    repeat (20) begin
      repeat (DIV) @(posedge clk);

      if (^slow_clk === 1'bx) begin
        $display("FAIL  slow_clk has X/Z: %b", slow_clk);
        fail_count++;
      end
      else if (slow_clk !== prev) begin
        $display("PASS  slow_clk toggled → %b", slow_clk);
        pass_count++;
      end
      else begin
        $display("FAIL  slow_clk did not toggle (value=%b)", slow_clk);
        fail_count++;
      end

      prev = slow_clk;
    end

    // ----------------------------------------
    // Summary
    // ----------------------------------------
    $display("\n========================================");
    $display("Results: %0d passed, %0d failed", pass_count, fail_count);
    $display("========================================");

    if (fail_count == 0)
      $display("ALL TESTS PASSED");
    else
      $display("SOME TESTS FAILED");

    $finish;
  end

endmodule
