// 2 to 4 decoder
//
// Written by Kaitlin Lucio
// Last modified: Sept 19, 2023

module decoder(
     input  logic [1:0] encoded,
     output logic [3:0] decoded
);

always_comb
    case(encoded)
        2'h0: decoded <= 4'b0001;
        2'h1: decoded <= 4'b0010;
        2'h2: decoded <= 4'b0100;
        2'h3: decoded <= 4'b1000;
        default: decoded <= 4'bxxxx;
    endcase

endmodule