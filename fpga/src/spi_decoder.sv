/*
filename: spi_decoder.sv
author: Diego Herrera Vicioso dherreravicioso@hmc.edu

Module to signal when a SPI transaction is done to send an spi_done signal to memory
*/


module spi_decoder(input logic clk, reset,
                   input logic cs,
                   output logic spi_done);

    typedef enum logic [1:0] {S_IDLE, S_RECEIVING, S_DONE} statetype;
    statetype state, nextstate;

    // next state register
    always_ff @(posedge clk) begin
		state <= nextstate;
	end

    // next state logic
    always_comb begin
        case(state) 
            S_IDLE:      begin
                         if (cs) nextstate = S_RECEIVING;
                         else nextstate = S_IDLE;
                         end
            S_RECEIVING: begin 
                         if (cs) nextstate = S_RECEIVING;
                         else nextstate = S_DONE;
                         end
            S_DONE: nextstate = S_IDLE;
            default: nextstate = S_IDLE;
        endcase
    end

    // output logic
    assign spi_done = (state == S_DONE);
endmodule

