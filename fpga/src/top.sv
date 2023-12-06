/*
Top module for full graphics card

*/
module top (
    input logic cs, sck, sdi, resetB,
    output logic R_out, G_out, B_out, VSyncB, HSyncB
);

logic		hsclk, core_clk, reset, VSync, HSync;
logic       re, we, spi_done;
logic [7:0] command, databyte1, databyte2, wdata, rdata, state_in;
logic [9:0] raddr, waddr, score;

assign reset = ~resetB;

HSOSC #(.CLKHF_DIV(2'b00))
	hf_osc(.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(hsclk));

sysclk_pll clk_pll(.ref_clk_i(hsclk), .rst_n_i(resetB), .outcore_o(core_clk), .outglobal_o(clk));

spi spi_inst(.sdi, .sck, .cs, .command, .databyte1, .databyte2);

spi_decoder spi_dec_inst(.clk, .reset, .cs, .spi_done);

command_decoder command_dec_inst(.clk, .reset, .command, .databyte1, .databyte2, .spi_done, .we, .waddr, .wdata, .score);

dpram ebram_casc(.clk, .raddr, .waddr, .re, .we, .wdata, .rdata(state_in));

vga_top vga(.clk, .reset, .state_in, .score, .R_out, .G_out, .B_out, .VSync, .HSync, .re, .raddr);

assign VSyncB = ~VSync;
assign HSyncB = ~HSync;

endmodule