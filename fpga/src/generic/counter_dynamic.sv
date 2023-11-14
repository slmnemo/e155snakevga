// Generic module for a counter/clock divider which outputs once every N clock cycles
//
// N is given by the input d
//
//
//
// inputs: clk, reset, en, d [WIDTH]
// output: q [WIDTH]
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Last nodified: Sept 11, 2023

`timescale 10ns/1ns

module counter_dynamic #(parameter dwidth) (
    input logic                         clk, reset, en,
    input logic [dwidth:0]              d,
    output logic                        out
);

logic [dwidth:0]    count, next_count;
logic               resetcounter;

assign resetcounter = reset | divclk;

flopenr #($clog2(div_val)) counter(.clk, .reset(resetcounter), .en, .d(count), .q(next_count));

assign next_count = count + 1;
assign out = (d == (count-1));

endmodule