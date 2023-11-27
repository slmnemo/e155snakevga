// Generic module for a 2 mux
//
// inputs: clk, reset, en, d [WIDTH]
// output: q [WIDTH]
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Last nodified: Sept 11, 2023

module mux2 #(parameter WIDTH=32) (
    input               s,
    input [WIDTH-1:0]   d0, d1,
    output [WIDTH-1:0]  q
);

assign q = s ? d1 : d0;

endmodule