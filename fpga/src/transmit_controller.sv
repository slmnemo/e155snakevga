/*
Module to control transmitter pixel and VSync/HSync output

takes in row and col and outputs values for VSync, HSync, and output_en

TODO IF NEEDED: use flops and logic to cut down amount of logic cells, parametrization
*/
module transmit_controller (
    input logic  [9:0]  row, col,
    output logic        VSync, HSync, output_en
);

assign output_en = (row < 10'd640) & (col < 10'd480);


assign HSync = ((row > 10'd687) & (row < 10'd784));


assign VSync = ((col > 10'd512) & (col < 10'd515));

endmodule
