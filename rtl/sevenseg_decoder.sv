// -----------------------------------------------------------------------------
// Module  : seg7_decoder
// Brief   : Converts 4-bit BCD (0–9) input into 7-segment display pattern
// Type    : Combinational
//
// Inputs  : bcd [3:0]  - Binary-coded decimal digit
// Outputs : seg [6:0]  - Segment control {a,b,c,d,e,f,g}
//
// Notes   :
//   - Active-high output (1 = segment ON)
//   - Invalid inputs (10–15) → all segments OFF
// -----------------------------------------------------------------------------

`timescale 1ns/1ps

module seg7_decoder (
    input  logic [3:0] bcd,  // 4-bit BCD input (0-9)
    output logic [6:0] seg   // 7-segment output {a,b,c,d,e,f,g}
);

    always_comb begin
        case (bcd)
            4'd0: seg = 7'b1111110;
            4'd1: seg = 7'b0110000;
            4'd2: seg = 7'b1101101;
            4'd3: seg = 7'b1111001;
            4'd4: seg = 7'b0110011;
            4'd5: seg = 7'b1011011;
            4'd6: seg = 7'b1011111;
            4'd7: seg = 7'b1110000;
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1111011;
            default: seg = 7'b0000000; // blank for invalid input
        endcase
    end

endmodule
