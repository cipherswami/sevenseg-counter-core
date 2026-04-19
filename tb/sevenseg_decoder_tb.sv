// -----------------------------------------------------------------------------
// Module  : seg7_decoder_tb
// Brief   : Testbench for seg7_decoder (formatted + structured output)
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module seg7_decoder_tb;

  // DUT signals
  logic [3:0] bcd;
  logic [6:0] seg;

  // DUT instance
  seg7_decoder dut (
    .bcd(bcd),
    .seg(seg)
  );

  // Expected values
  logic [6:0] expected [0:9];

  int pass_count;
  int fail_count;

  localparam int SETTLE = 1;

  // ----------------------------------------
  // Initialize expected lookup
  // ----------------------------------------
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
  // Check task
  // ----------------------------------------
  task automatic check(input logic [3:0] digit,
                       input logic [6:0] exp);
    bcd = digit;
    #SETTLE;

    // detect unknowns
    if (^seg === 1'bx) begin
      $display("FAIL  bcd=%0d  seg has X/Z: %7b", digit, seg);
      fail_count++;
    end
    else if (seg === exp) begin
      $display("PASS  bcd=%0d  seg=%7b", digit, seg);
      pass_count++;
    end else begin
      $display("FAIL  bcd=%0d  seg=%7b  expected=%7b  {a=%b b=%b c=%b d=%b e=%b f=%b g=%b}",
               digit, seg, exp,
               seg[6], seg[5], seg[4], seg[3],
               seg[2], seg[1], seg[0]);
      fail_count++;
    end
  endtask

  // ----------------------------------------
  // Test sequence
  // ----------------------------------------
  initial begin
    $dumpfile("sim/seg7.vcd");
    $dumpvars(0, seg7_decoder_tb);

    pass_count = 0;
    fail_count = 0;

    $display("========================================");
    $display("      SEG7 DECODER TESTBENCH");
    $display("========================================");

    // -------------------------
    // Valid inputs
    // -------------------------
    $display("\n----------------------------------------");
    $display("valid digits (0–9)");
    $display("----------------------------------------");

    for (int i = 0; i < 10; i++) begin
      check(i, expected[i]);
    end

    // -------------------------
    // Invalid inputs
    // -------------------------
    $display("\n----------------------------------------");
    $display("invalid inputs (10–15 → blank)");
    $display("----------------------------------------");

    for (int i = 10; i < 16; i++) begin
      check(i, 7'b0000000);
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
