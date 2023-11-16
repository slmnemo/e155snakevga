/*
Top module for full graphics card

*/
module top (
    input logic cs, sck, sdi, sdo,
    input logic [2:0] state_in, // for testing that we can change state and duration stuff
    output logic R_out, G_out, B_out, VSync, HSync
);

logic       re;
logic [7:0] command, databyte1, databyte2;
logic [9:0] raddr, score, new_score;

spi spi(.sdi, .sdo, .sck, .cs, .command, .databyte1, .databyte2);

// TODO: Add memory interface and score handling. Maybe controller for stuff like score.

vga_top vga(.state({13'b0, state_in}), .score(10'b0), .R_out, .G_out, .B_out, .VSync, .HSync, .re, .raddr);


endmodule