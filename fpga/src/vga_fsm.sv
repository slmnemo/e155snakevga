/*
Module that takes in a state from memory and combines it with the current column in an FSM to output the object in the pixel

TODO: Implement above version. Current version takes a 4 bit number from a counter and maps it to a pixel pattern
*/

module vga_fsm (
    input logic         clk, reset,
    input logic  [9:0]  score, col, row,
    input logic  [15:0] state_in,
    output logic        R_next, G_next, B_next, VSync, HSync, re,
    output logic [4:0]  duration
);

typedef enum logic [2:0] {black, white, colbasedRGB, rowbasedRGB, col20align, row20align, green, red} statetypes;

statetypes state, nextState;

logic [2:0] colRGB, rowRGB;

assign colRGB = col[2:0];
assign rowRGB = row[2:0];

always_comb
    case(state_in)
        3'd0: nextState = black;
        3'd1: nextState = white;
        3'd2: nextState = colbasedRGB;
        3'd3: nextState = rowbasedRGB;
        3'd4: nextState = col20align;
        3'd5: nextState = row20align;
        3'd6: nextState = green;
        3'd7: nextState = red;
        default: nextState = black;
    endcase

always_ff @(posedge clk)
    if (reset)
        state <= black;
    else
        state <= nextState;

assign R_out = (state == white) | (state == red) | ((state == colbasedRGB) & colRGB[2]) | ((state == rowbasedRGB) & rowRGB[2]);
assign G_out = (state == white) | (state == green) | ((state == colbasedRGB) & colRGB[1]) | ((state == rowbasedRGB) & rowRGB[1]);
assign B_out = (state == white) | ((state == colbasedRGB) & colRGB[0]) | ((state == rowbasedRGB) & rowRGB[0]);

assign duration = ((state == col20align) | (state == row20align)) ? 5'd20 : 5'd0;

endmodule


