// Generic module for a counter/clock divider which outputs once every N clock cycles (static)
//
// N is given by the parameter div_val
//
// inputs: clk, reset, en
// output: q [WIDTH]
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Last nodified: Sept 11, 2023

`timescale 10ns/1ns

module counter_static #(parameter logic div_val) (
    input logic                         clk, reset, en,
    output logic                        cout
);

logic [$clog2(div_val)-1:0] count, next_count;
logic                       resetcounter;

assign resetcounter = reset | divclk;

flopenr #($clog2(div_val)) counter(.clk, .reset(resetcounter), .en, .d(count), .q(next_count));

assign next_count = count + 1;
assign cout = (div_val == (count-1));

endmodule