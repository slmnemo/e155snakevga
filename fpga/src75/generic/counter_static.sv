// Generic module for a counter/clock divider which outputs once every N clock cycles (static)
//
// N is given by the parameter count_max
//
// inputs: clk, reset, en
// output: q [WIDTH]
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Last nodified: Sept 11, 2023

module counter_static #(parameter count_max=8) (
    input logic                             clk, reset, en,
    output logic [$clog2(count_max)-1:0]    count
);

logic [$clog2(count_max)-1:0]   next_count;
logic                           resetcounter;

assign resetcounter = reset | (count >= count_max);

flopenr #($clog2(count_max)) counter(.clk, .reset(resetcounter), .en, .d(next_count), .q(count));

assign next_count = count + 1;

endmodule