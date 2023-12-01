/*
Top module for full graphics card

*/
module top (
    input logic cs, sck, sdi, resetB,
    input logic [2:0] state_in, // for testing that we can change state and duration stuff
    output logic R_out, G_out, B_out, VSyncB, HSyncB,
	output logic [2:0] LED
);

logic		hsclk, core_clk, clk, reset, VSync, HSync;
logic       re, we;
logic [2:0] LEDpar;
logic [7:0] command, databyte1, databyte2;
logic [9:0] raddr, score, new_score;

assign reset = ~resetB;

HSOSC #(.CLKHF_DIV(2'b00))
	hf_osc(.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(hsclk));

sysclk_pll clk_pll(.ref_clk_i(hsclk), .rst_n_i(resetB), .outcore_o(core_clk), .outglobal_o(clk));

spi spi_inst(.sdi, .sck, .cs, .command, .databyte1, .databyte2);

spi_decoder spi_dec_inst(.clk, .reset, .cs, .we);

// TODO: Add memory interface and score handling. Maybe controller for stuff like score.

vga_top vga(.clk, .reset, .state({13'b0, state_in}), .score(10'b0), .R_out, .G_out, .B_out, .VSync, .HSync, .re, .raddr);

assign VSyncB = ~VSync;
assign HSyncB = ~HSync;


endmodule