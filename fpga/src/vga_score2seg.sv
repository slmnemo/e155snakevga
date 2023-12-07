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

logic [6:0] segment, segmentBar;

// segmentBar = {A, B, C, D, E, F, G}
always_comb
    case(digit)
        4'h0: segmentBar <= 7'b1111110;
        4'h1: segmentBar <= 7'b0110000;
        4'h2: segmentBar <= 7'b1101101;
        4'h3: segmentBar <= 7'b1111001;
        4'h4: segmentBar <= 7'b0110011;
        4'h5: segmentBar <= 7'b1011011;
        4'h6: segmentBar <= 7'b1011111;
        4'h7: segmentBar <= 7'b1110000;
        4'h8: segmentBar <= 7'b1111111;
        4'h9: segmentBar <= 7'b1110011;
        4'hA: segmentBar <= 7'b1110111;
        4'hB: segmentBar <= 7'b0011111;
        4'hC: segmentBar <= 7'b0001101;
        4'hD: segmentBar <= 7'b0111101;
        4'hE: segmentBar <= 7'b1001111;
        4'hF: segmentBar <= 7'b1000111;
        default: segmentBar <= 7'bxxxxxxx;
    endcase

assign segment = ~segmentBar;

// Logic to determine whether we are scanning a region where the segment resides, and thus should be displaying an output
// 
// Horizontal bars: A, D, G
// Vertical bars: B, C, E, F

assign disp_a = segment[6] & (row >= `A_X + XOFFSET) & (row < `A_X + `W_H + XOFFSET) & (col >= `A_Y + YOFFSET) & (col < `A_Y + `L_H + YOFFSET);
assign disp_d = segment[3] & (row >= `D_X + XOFFSET) & (row < `D_X + `W_H + XOFFSET) & (col >= `D_X + YOFFSET) & (col < `D_X + `L_H + YOFFSET);
assign disp_g = segment[0] & (row >= `G_X + XOFFSET) & (row < `G_X + `W_H + XOFFSET) & (col >= `G_X + YOFFSET) & (col < `G_X + `L_H + YOFFSET);

// Vertical bar handling
assign disp_b = segment[5] & (row >= `B_X + XOFFSET) & (row < `B_X + `W_V + XOFFSET) & (col >= `B_Y + YOFFSET) & (col < `B_Y + `L_V + YOFFSET);
assign disp_c = segment[4] & (row >= `C_X + XOFFSET) & (row < `C_X + `W_V + XOFFSET) & (col >= `C_Y + YOFFSET) & (col < `C_Y + `L_V + YOFFSET);
assign disp_e = segment[2] & (row >= `E_X + XOFFSET) & (row < `E_X + `W_V + XOFFSET) & (col >= `E_Y + YOFFSET) & (col < `E_Y + `L_V + YOFFSET);
assign disp_f = segment[1] & (row >= `F_X + XOFFSET) & (row < `F_X + `W_V + XOFFSET) & (col >= `F_Y + YOFFSET) & (col < `F_Y + `L_V + YOFFSET);

assign pix_on = disp_a | disp_b | disp_c | disp_d | disp_e | disp_f | disp_g;

assign rgb_out = {3{pix_on}}; // Can mask what color to output

endmodule