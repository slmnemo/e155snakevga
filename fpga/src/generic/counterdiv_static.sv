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

module counterdiv_static #(parameter count_max) (
    input logic                 clk, reset, en,
    output logic                divclk
);

logic [$clog2(count_max)-1:0]  count, next_count;
logic               resetcounter;

assign resetcounter = reset | divclk;

flopenr #($clog2(count_max)) counter(.clk, .reset(resetcounter), .en, .d(next_count), .q(count));

assign next_count = count + 1;
assign divclk = (count == (count_max));

endmodule