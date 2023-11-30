/*
filename: spi_decoder.sv
author: Diego Herrera Vicioso dherreravicioso@hmc.edu

Module to signal when a SPI transaction is done to send a write enable (we) signal to memory
*/


module spi_decoder(input logic clk, reset,
                   input logic cs,
                   output logic we);

    typedef enum logic [1:0] {S_IDLE, S_RECEIVING, S_DONE} statetype;
    statetype state, nextstate;

    // next state register
    always_ff (@posedge clk)
        if (reset) state <= S_IDLE;
        else state <= nextstate;

    // next state logic
    always_comb
        case(state) 
            S_IDLE: if (cs) nextstate = S_RECEIVING;
                    else nextstate = S_IDLE;
            S_RECEIVING: if (~cs) nextstate = S_DONE;
                        else nextstate = S_RECEIVING;
            S_DONE: nextstate = S_IDLE;
            default: nextstate = S_IDLE;
        endcase

    // output logic
    assign we = (state == S_DONE);
endmodule

