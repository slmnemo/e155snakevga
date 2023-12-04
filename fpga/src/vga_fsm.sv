/*
Module that takes in a state from memory and combines it with the current column in an FSM to output the object in the pixel

TODO: Implement above version. Current version takes a 4 bit number from a counter and maps it to a pixel pattern
*/

module vga_fsm (
    input logic         clk, reset,
    input logic  [9:0]  score, col, row,
    input logic  [7:0]  state_in,
    output logic        R_next, G_next, B_next, re,
    output logic [4:0]  next_duration
);

typedef enum logic [3:0] {black20, blue20, green20, cyan20, red20, purple20, yellow20, white20} statetypes;

statetypes state, nextState;

always_comb
    case(state_in)
        8'd0: nextState = black;
        8'd1: nextState = blue;
        8'd2: nextState = green;
        8'd3: nextState = cyan;
        8'd4: nextState = red;
        8'd5: nextState = purple;
        8'd6: nextState = yellow;
        8'd7: nextState = white;
        default: nextState = black;
    endcase

always_ff @(posedge clk)
    if (reset)
        state <= black;
    else
        state <= nextState;

assign R_next = (state == white) | (state == red) | ((state == colbasedRGB) & colRGB[2]) | ((state == rowbasedRGB) & rowRGB[2]) | ((state == row20align) & rowRGB[2]) | ((state == col20align) & colRGB[2]);
assign G_next = (state == white) | (state == green) | ((state == colbasedRGB) & colRGB[1]) | ((state == rowbasedRGB) & rowRGB[1]) | ((state == row20align) & rowRGB[1]) | ((state == col20align) & colRGB[1]);
assign B_next = (state == white) | ((state == colbasedRGB) & colRGB[0]) | ((state == rowbasedRGB) & rowRGB[0]) | ((state == row20align) & rowRGB[0]) | ((state == col20align) & colRGB[0]);

assign duration = 5'd19;

endmodule


