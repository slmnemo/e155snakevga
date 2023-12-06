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
    input logic  [7:0]  score_in,
    output logic        R_out, G_out, B_out, VSync, HSync, re,
    output logic [9:0]  raddr
);

logic           updateoutput;
logic           R_next, B_next, G_next, R_in, G_in, B_in;
logic [4:0]     next_duration;
logic [7:0]     state;
logic [9:0]     row, col;

flopenr #(3)    state_flop(.clk, .reset, .en(), .d(state_in), .q(state));

vga_fsm         vgafsm(.clk, .reset, .state_in(state), .score, .col, .row, .R_next, .G_next, .B_next, .next_duration);

vga_controller  vgacontroller(.clk, .reset, .next_duration, .updateoutput, .re, .row, .col, .raddr);

flopenr #(3)    rgb_flop(.clk, .reset, .en(updateoutput), .d({R_next, G_next, B_next}), .q({R_in, G_in, B_in}));

// TODO: Use mux and score to calculate what to display for score and mask it with RGB values

vga_transmitter vgatransmitter(.R_in, .G_in, .B_in, .row, .col, .R_out, .G_out, .B_out, .VSync, .HSync);

endmodule
