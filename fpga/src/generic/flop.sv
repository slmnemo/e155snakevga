// Generic module for an enabled sync flop with an enable and variable width
//
// inputs: clk, reset, en, d [WIDTH]
// output: q [WIDTH]
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Last nodified: Sept 11, 2023

module flop #(parameter WIDTH=32) (
    input logic                 clk, reset,
    input logic [WIDTH-1:0]     d,
    output logic [WIDTH-1:0]    q
);


always_ff @(posedge clk)
    if (reset)
        q <= #1 0;
    else
        q <= #1 d;


endmodule