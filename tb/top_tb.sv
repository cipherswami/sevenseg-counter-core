// -----------------------------------------------------------------------------
// Module  : top_tb
// Brief   : Testbench for full system (divider + counter + seg7)
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module top_tb;

  logic clk;
  logic rst;
  logic [6:0] seg;
  logic [6:0] prev_seg;

  int pass_count;
  int fail_count;
  int digit;

  // -------------------------
  // Clock generation
  // -------------------------
  initial clk = 0;
  always #5 clk = ~clk;

  // -------------------------
  // DUT
  // -------------------------
  localparam int DIV = 4;

  top #(
    .DIV(DIV)
  ) dut (
    .clk (clk),
    .rst (rst),
    .seg (seg)
  );

  // -------------------------
  // Expected values (ACTIVE-HIGH)
  // -------------------------
  logic [6:0] expected [0:9];

  initial begin
    expected[0] = 7'b1111110;
    expected[1] = 7'b0110000;
    expected[2] = 7'b1101101;
    expected[3] = 7'b1111001;
    expected[4] = 7'b0110011;
    expected[5] = 7'b1011011;
    expected[6] = 7'b1011111;
    expected[7] = 7'b1110000;
    expected[8] = 7'b1111111;
    expected[9] = 7'b1111011;
  end

  // ----------------------------------------
  // Test sequence
  // ----------------------------------------
  initial begin
    $dumpfile("sim/top.vcd");
    $dumpvars(0, top_tb);

    pass_count = 0;
    fail_count = 0;

    $display("========================================");
    $display("          TOP SYSTEM TESTBENCH");
    $display("========================================");

    // -------------------------
    // Reset
    // -------------------------
    rst = 1;
    repeat (2) @(posedge clk);
    rst = 0;

    // -------------------------
    // Wait until output is valid
    // -------------------------
    wait (^seg !== 1'bx);
    prev_seg = seg;

    $display("\n----------------------------------------");
    $display("checking 0 → 9 sequence");
    $display("----------------------------------------");

    // IMPORTANT: first observed transition is '1'
    digit = 1;

    // -------------------------
    // Event-driven checking
    // -------------------------
    repeat (10) begin

      // wait for next digit change
      wait (seg !== prev_seg);

      // allow settle
      @(posedge clk);

      if (seg === ~expected[digit]) begin
        $display("PASS  count=%0d seg=%7b", digit, seg);
        pass_count++;
      end else begin
        $display("FAIL  count=%0d seg=%7b expected=%7b",
                 digit, seg, ~expected[digit]);
        fail_count++;
      end

      prev_seg = seg;
      digit = (digit == 9) ? 0 : digit + 1;

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
