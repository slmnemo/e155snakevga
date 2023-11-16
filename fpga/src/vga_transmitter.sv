/*
Module to send VGA outputs based on row and column

takes in pixel data and row/col value and outputs correct pixel values and VSync/Hsync

*/
module vga_transmitter(
    input logic         R_in, G_in, B_in,
    input logic  [9:0]  row, col,
    output logic        R_out, G_out, B_out, VSync, HSync
);

logic output_en;

transmit_controller controller(.row, .col, .VSync, .HSync, .output_en);

mux2 #(1) R_mux(.s(output_en), .d0(1'b0), .d1(R_in), .q(R_out));
mux2 #(1) G_mux(.s(output_en), .d0(1'b0), .d1(G_in), .q(G_out));
mux2 #(1) B_mux(.s(output_en), .d0(1'b0), .d1(B_in), .q(B_out));

endmodule

