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

module counterdiv_dyn #(parameter dwidth=8) (
    input logic                 clk, reset, en,
    input logic  [dwidth-1:0]   count_max,
    output logic                divclk
);

logic [dwidth-1:0]  count, next_count;
logic               resetcounter;

assign next_count = count + 1;
assign divclk = (count >= (count_max)) | reset;
assign resetcounter = reset | divclk;

flopenr #(dwidth) counter(.clk, .reset(resetcounter), .en, .d(next_count), .q(count));


endmodule