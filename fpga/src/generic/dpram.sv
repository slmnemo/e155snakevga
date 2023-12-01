/*
Module to instantiate a dual port memory from BRAMs

Please work I am begging you Radiant Software
*/
module dpram #(parameter dwidth=8, addr_width=10) (
    input logic clk,
    input logic [addr_width-1:0] raddr, waddr,
    input logic [dwidth-1:0] wdata,
    input logic re, we,
    output logic [dwidth-1:0] rdata
);

    logic [dwidth-1:0] mem [(1<<addr_width)-1:0];

    always_ff @(posedge clk) begin
        if (we)
            mem[waddr] <= wdata;
        if (re)
            rdata <= mem[raddr];
    end
endmodule
