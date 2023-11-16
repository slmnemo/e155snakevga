/*
Top module for full graphics card

*/
module top (
    input logic cs, sck, sdi, resetB,
    input logic [2:0] state_in, // for testing that we can change state and duration stuff
    output logic R_out, G_out, B_out, VSync, HSync,
	output logic clk2
);

logic		hsclk, core_clk, reset, clk3;
logic       re;
logic [7:0] command, databyte1, databyte2;
logic [9:0] raddr, score, new_score;

assign reset = ~resetB;

HSOSC #(.CLKHF_DIV(2'b00))
	hf_osc(.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(hsclk));

assign clk = hsclk;
// sysclk_pll clk_pll(.ref_clk_i(hsclk), .rst_n_i(reset), .outcore_o(core_clk), .outglobal_o(clk));

flop #(1) memeclk(.clk, .reset, .d(clk3), .q(clk2));
assign clk3 = ~clk2;

spi spi(.sdi, .sck, .cs, .command, .databyte1, .databyte2);

// TODO: Add memory interface and score handling. Maybe controller for stuff like score.

vga_top vga(.clk, .reset, .state({13'b0, state_in}), .score(10'b0), .R_out, .G_out, .B_out, .VSync, .HSync, .re, .raddr);


endmodule