/*

*/

module synchronizer #(parameter WIDTH=1) (
    input logic                 clk, reset,
    input logic [WIDTH-1:0]     d,
    output logic [WIDTH-1:0]    q
);
    logic [WIDTH-1:0] in_between;

    flop #(WIDTH) synch_flop1(.clk, .reset, .d, .q(in_between));
    flop #(WIDTH) synch_flop2(.clk, .reset, .d(in_between), .q);

endmodule
