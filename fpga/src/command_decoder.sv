/*
Module to decode SPI commands
*/
`include "command_header.sv"

module command_decoder (
    input logic         clk, reset,
    input logic         spi_done,
    input logic [7:0]   command, databyte1, databyte2,
    output logic        we, cmd_received,
    output logic [7:0]  wdata,
    output logic [9:0]  waddr, score
);


// logic       we_int, update_score, update_write;
// logic [7:0] wdata_int;
// logic [9:0] waddr_int, score_int;
logic       cmd_received_int;
logic [9:0] score_int;

always_comb
    casez(command)
        `UPDATE_SCORE_COMMAND: begin
            score_int = {databyte1[1:0], databyte2};
            we = 1'b0;
            waddr = 10'b0;
            wdata = 10'b0;
            cmd_received_int = 1'b1;
        end
        `COLOR_COMMAND: begin
            score_int = score;
            we = 1'b1;
            waddr = {databyte1[4:0], databyte2[4:0]};
            wdata = {5'b0, command[2:0]};
            cmd_received_int = 1'b1;
        end
        default: begin
            score_int = score;
            we = 1'b0;
            waddr = 10'b0;
            wdata = 8'b0;
            cmd_received_int = 1'b0;
        end
    endcase

synchronizer cmd_rec_synch(.clk, .reset, .d(cmd_received_int), .q(cmd_received));

flop #(10) score_flop(.clk, .reset, .d(score_int), .q(score));
endmodule