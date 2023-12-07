/*
Top module for full graphics card

*/
module top (
    input logic cs, sck, sdi, resetB,
    output logic R_out, G_out, B_out, VSyncB, HSyncB
);

logic		hsclk, core_clk, reset, VSync, HSync;
logic       cs_sync, sck_sync, sdi_sync;
logic       re, we, spi_done, cmd_received;
logic [7:0] command, databyte1, databyte2, command_rx, databyte1_rx, databyte2_rx;
logic [7:0] wdata, rdata, state_in;
logic [9:0] raddr, waddr, score;

assign reset = ~resetB;

HSOSC #(.CLKHF_DIV(2'b00))
	hf_osc(.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(hsclk));

sysclk_pll clk_pll(.ref_clk_i(hsclk), .rst_n_i(resetB), .outcore_o(core_clk), .outglobal_o(clk));

synchronizer spi_cs_synch(.clk, .reset, .d(cs), .q(cs_sync));
synchronizer spi_sck_synch(.clk, .reset, .d(sck), .q(sck_sync));
synchronizer spi_sdi_synch(.clk, .reset, .d(sdi), .q(sdi_sync));

spi spi_inst(.sdi(sdi_sync), .sck(sck_sync), .cs(cs_sync), .command_rx, .databyte1_rx, .databyte2_rx);

spi_decoder spi_dec_inst(.clk, .reset, .cs(cs_sync), .spi_done);

flopenr #(24) spi_data_flop(.clk, .reset(cmd_received), .en(spi_done), 
    .d({command_rx, databyte1_rx, databyte2_rx}), 
    .q({command, databyte1, databyte2}));

command_decoder command_dec_inst(.clk, .reset, .command, .databyte1, .databyte2, .spi_done, .cmd_received, .we, .waddr, .wdata, .score);

dpram ebram_casc(.clk, .raddr, .waddr, .re, .we, .wdata, .rdata);

// ebram ebram_dp(.rd_addr_i(raddr), .rd_clk_en_i(1'b1), .rd_clk_i(clk), .rd_en_i(re), .rd_data_o(rdata), 
//                 .rst_i(reset), 
//                 .wr_addr_i(waddr), .wr_clk_en_i(1'b1), .wr_clk_i(clk), .wr_data_i(wdata), .wr_en_i(we));

vga_top vga(.clk, .reset, .state_in(rdata), .score, .R_out, .G_out, .B_out, .VSync, .HSync, .re, .raddr);

assign VSyncB = ~VSync;
assign HSyncB = ~HSync;

endmodule