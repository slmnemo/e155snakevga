// top module for vga
//
// inputs: clk, reset, newstate
// output: R, G, B, VSync, HSync
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Last nodified: Sept 11, 2023

module vga_top (
    input logic         clk, reset,
    input logic  [7:0]  state_in,
    input logic  [9:0]  score,
    output logic        R_out, G_out, B_out, VSync, HSync, re,
    output logic [9:0]  raddr
);

logic           updateoutput, update_state;
logic           R_next, B_next, G_next, R_in, G_in, B_in;
logic [2:0]     state;
logic [9:0]     row, col;

flopenr #(3)    state_flop(.clk, .reset, .en(update_state), .d(state_in[2:0]), .q(state));

vga_controller  vgacontroller(.clk, .reset, .updateoutput, .update_state, .row, .col, .re, .raddr);

flopenr #(3)    rgb_flop(.clk, .reset, .en(updateoutput), .d(state), .q({R_in, G_in, B_in}));

// TODO: Use mux and score to calculate what to display for score and mask it with RGB values

vga_transmitter vgatransmitter(.R_in, .G_in, .B_in, .row, .col, .R_out, .G_out, .B_out, .VSync, .HSync);

endmodule
