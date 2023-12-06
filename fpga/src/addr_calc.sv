/*

*/

`include "command_header.sv"

module addr_calc (
    input logic [7:0]   command, .databyte1, .databyte2,
    input logic         spi_done,
    output logic        we, waddr, wdata
);

// Case statement to decode commands
always_comb
    casez(command)
    
    endcase

endmodule
