// top module for vga
//
// inputs: clk, reset, newstate
// output: R, G, B, VSync, HSync
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Last nodified: Sept 11, 2023

module vga_top (
    input logic         clk, reset,
    input logic  [15:0] state,
    input logic  [9:0]  score,
    output logic        R_out, G_out, B_out, VSync, HSync, re,
    output logic [9:0]  raddr
);

logic           updateoutput;
logic           R_next, B_next, G_next, R_in, G_in, B_in;
logic [4:0]     next_duration;
logic [9:0]     row, col;

vga_fsm         vgafsm(.clk, .reset, .state_in(state), .score, .col, .row, .R_next, .G_next, .B_next);

flopenr #(3)    rgb_flop(.clk, .reset, .en(updateoutput), .d({R_next, B_next, G_next}), .q({R_in, G_in, B_in}));

vga_controller  vgacontroller(.clk, .reset, .next_duration, .updateoutput, .re, .row, .col, .raddr);

vga_transmitter vgatransmitter(.R_in(1'b0), .G_in(1'b1), .B_in(1'b0), .row, .col, .R_out, .G_out, .B_out, .VSync, .HSync);

endmodule
