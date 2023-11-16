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

module counter_dynamic #(parameter dwidth) (
    input logic                         clk, reset, en,
    input logic  [dwidth-1:0]           count_max,
    output logic [dwidth-1:0]           count
);

logic [dwidth-1:0]  next_count;
logic               resetcounter;

assign resetcounter = reset | (count == count_max);

flopenr #(dwidth) counter(.clk, .reset(resetcounter), .en, .d(next_count), .q(count));

assign next_count = count + 1;

endmodule