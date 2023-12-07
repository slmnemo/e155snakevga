/*

VGA driver to mask an RGB input signal with a score signal and output the final pixel value

*/

`include "vga_params.sv"

module vga_score_controller (
    input logic [9:0]   score, row, col,
    output logic [2:0]  rgb_score
);

logic [2:0] rgb_ones, rgb_tens, rgb_huns;

// Commented out because of inability to get decimal output working on FPGA despite working in sim
//
// logic [9:0] tens_div, huns_div;
// logic [9:0] ones, tens, huns;

// assign ones = score % 4'd10;
// assign tens_div = score / 10'd10;
// assign huns_div = score / 10'd100;
// assign tens = tens_div % 10'd10;
// assign huns = huns_div % 10'd10;

vga_score2seg #(`ONES_X_OFFSET, `ONES_Y_OFFSET) ones_score2seg(.digit(score[3:0]), .row, .col, .rgb_out(rgb_ones));

vga_score2seg #(`TENS_X_OFFSET, `TENS_Y_OFFSET) tens_score2seg(.digit(score[7:4]), .row, .col, .rgb_out(rgb_tens));

vga_score2seg#(`HUNS_X_OFFSET, `HUNS_Y_OFFSET)  huns_score2seg(.digit({2'b0,score[9:8]}), .row, .col, .rgb_out(rgb_huns));

assign rgb_score = rgb_ones | rgb_tens | rgb_huns;

endmodule
