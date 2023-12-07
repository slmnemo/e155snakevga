/*
Module to control transmitter pixel and VSync/HSync output

takes in row and col and outputs values for VSync, HSync, and output_en

TODO IF NEEDED: use flops and logic to cut down amount of logic cells, parametrization
*/
`include "vga_params.sv"

module transmit_controller (
    input logic  [9:0]  row, col,
    output logic        VSync, HSync, output_en
);

assign output_en = (row < `HACTIVE) & (col < `VACTIVE);


assign HSync = ~((row >= (`HACTIVE+`HFRONTPORCH)) & (row < (`HACTIVE+`HFRONTPORCH+`HSYNCPULSE)));


assign VSync = ~((col >= (`VACTIVE+`VFRONTPORCH)) & (col < (`VACTIVE+`VFRONTPORCH+`VSYNCPULSE)));

endmodule
