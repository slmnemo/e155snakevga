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


assign HSync = ((row > 10'd655) & (row < 10'd752));


assign VSync = ((col > 10'489) & (col < 10'd492));

endmodule
