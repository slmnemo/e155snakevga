/*
Module that takes in a state from memory and combines it with the current column in an FSM to output the object in the pixel

TODO: Implement above version. Current version takes a 4 bit number from a counter and maps it to a pixel pattern
*/

module vga_fsm (
    input logic         clk, reset,
    input logic  [9:0]  score, col, row,
    input logic  [15:0] state_in,
    output logic        R_next, G_next, B_next, re,
    output logic [4:0]  next_duration
);

typedef enum logic [2:0] {black, white, colbasedRGB, rowbasedRGB, col20align, row20align, green, red} statetypes;

statetypes state, nextState;

logic [2:0] colRGB, rowRGB;

assign colRGB = col[2:0];
assign rowRGB = row[2:0];

always_comb
    case(state_in)
        16'd0: nextState = black;
        16'd1: nextState = white;
        16'd2: nextState = colbasedRGB;
        16'd3: nextState = rowbasedRGB;
        16'd4: nextState = col20align;
        16'd5: nextState = row20align;
        16'd6: nextState = green;
        16'd7: nextState = red;
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

// assign R_out = 0;
// assign G_out = 1;
// assign B_out = 0;

assign next_duration = ((state == col20align) | (state == row20align)) ? 5'd9 : 5'd0;

endmodule


