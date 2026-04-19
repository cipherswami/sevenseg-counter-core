// -----------------------------------------------------------------------------
// Module  : counter_tb
// Brief   : Testbench for modulo-10 counter (formatted output)
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module counter_tb;

  logic clk;
  logic rst;
  logic [3:0] count;

  int pass_count, fail_count;
  int expected;

  // -------------------------
  // Clock generation
  // -------------------------
  initial clk = 0;
  always #5 clk = ~clk;

  // -------------------------
  // DUT
  // -------------------------
  counter dut (
    .clk   (clk),
    .rst   (rst),
    .count (count)
  );

  // -------------------------
  // Test sequence
  // -------------------------
  initial begin
    $dumpfile("sim/counter.vcd");
    $dumpvars(0, counter_tb);

    pass_count = 0;
    fail_count = 0;

    $display("========================================");
    $display("        COUNTER TESTBENCH");
    $display("========================================");

    // --- reset ---
    rst = 1;
    repeat (2) @(posedge clk);
    rst = 0;

    @(posedge clk);   // first valid cycle

    expected = 1;

    repeat (20) begin
      if (count === expected) begin
        $display("PASS  count=%0d (0x%0h)", count, count);
        pass_count++;
      end else begin
        $display("FAIL  count=%0d expected=%0d", count, expected);
        fail_count++;
      end

      expected = (expected == 9) ? 0 : expected + 1;

      @(posedge clk);
    end

    // -------------------------
    // Summary
    // -------------------------
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
