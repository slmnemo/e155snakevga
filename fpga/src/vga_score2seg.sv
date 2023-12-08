/*

Module that takes in a row and column and returns a max RGB value if the digit should be on for this display
*/

`include "vga_params.sv"

module vga_score2seg #(parameter XOFFSET=640, YOFFSET=480) (
    input logic [3:0] digit,
    input logic [9:0] row, col, 
    output logic [2:0] rgb_out
);

logic disp_a, disp_b, disp_c, disp_d, disp_e, disp_f, disp_g, pix_on;

// Taken from 7-segment display code

logic [6:0] segment;

// segment = {A, B, C, D, E, F, G}
always_comb
    case(digit)
        4'h0: segment <= 7'b1111110;
        4'h1: segment <= 7'b0110000;
        4'h2: segment <= 7'b1101101;
        4'h3: segment <= 7'b1111001;
        4'h4: segment <= 7'b0110011;
        4'h5: segment <= 7'b1011011;
        4'h6: segment <= 7'b1011111;
        4'h7: segment <= 7'b1110000;
        4'h8: segment <= 7'b1111111;
        4'h9: segment <= 7'b1110011;
        4'hA: segment <= 7'b1110111;
        4'hB: segment <= 7'b0011111;
        4'hC: segment <= 7'b1001110;
        4'hD: segment <= 7'b0111101;
        4'hE: segment <= 7'b1001111;
        4'hF: segment <= 7'b1000111;
        default: segment <= 7'bxxxxxxx;
    endcase

// Logic to determine whether we are scanning a region where the segment resides, and thus should be displaying an output
// 
// Horizontal bars: A, D, G
// Vertical bars: B, C, E, F
//
// Note that Y coordinates are flipped, with the "larger" value being lower down than the smaller one

assign disp_a = segment[6] & (row >= `A_X + XOFFSET) & (row < `A_X + `W_H + XOFFSET) & (col <= `A_Y + YOFFSET) & (col > `A_Y + `L_H + YOFFSET);
assign disp_d = segment[3] & (row >= `D_X + XOFFSET) & (row < `D_X + `W_H + XOFFSET) & (col <= `D_Y + YOFFSET) & (col > `D_Y + `L_H + YOFFSET);
assign disp_g = segment[0] & (row >= `G_X + XOFFSET) & (row < `G_X + `W_H + XOFFSET) & (col <= `G_Y + YOFFSET) & (col > `G_Y + `L_H + YOFFSET);

// Vertical bar handling
assign disp_b = segment[5] & (row >= `B_X + XOFFSET) & (row < `B_X + `W_V + XOFFSET) & (col <= `B_Y + YOFFSET) & (col > `B_Y + `L_V + YOFFSET);
assign disp_c = segment[4] & (row >= `C_X + XOFFSET) & (row < `C_X + `W_V + XOFFSET) & (col <= `C_Y + YOFFSET) & (col > `C_Y + `L_V + YOFFSET);
assign disp_e = segment[2] & (row >= `E_X + XOFFSET) & (row < `E_X + `W_V + XOFFSET) & (col <= `E_Y + YOFFSET) & (col > `E_Y + `L_V + YOFFSET);
assign disp_f = segment[1] & (row >= `F_X + XOFFSET) & (row < `F_X + `W_V + XOFFSET) & (col <= `F_Y + YOFFSET) & (col > `F_Y + `L_V + YOFFSET);

assign pix_on = disp_a | disp_b | disp_c | disp_d | disp_e | disp_f | disp_g;

assign rgb_out = {3{pix_on}}; // Can mask what color to output

endmodule