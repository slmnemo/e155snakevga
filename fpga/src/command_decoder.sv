/*
Module to decode SPI commands
*/
`include "command_header.sv"

module command_decoder (
    input logic         clk, reset,
    input logic         spi_done,
    input logic [7:0]   command, databyte1, databyte2,
    output logic        we, clrcmd,
    output logic [7:0]  wdata,
    output logic [9:0]  waddr, score
);

logic       we_int, update_score, update_write;
logic [7:0] wdata_int;
logic [9:0] waddr_int, score_int;

always_comb
    casez(command)
        `UPDATE_SCORE_COMMAND: begin
            score_int = {databyte1[1:0], databyte2};
            update_score = 1'b1;
            update_write = 1'b0;
            we_int = 1'b0;
            waddr_int = 10'b0;
            wdata_int = 10'b0;
        end
        `COLOR_COMMAND: begin
            score_int = score;
            wdata_int = {5'b0, command[2:0]};
            waddr_int = {databyte1[4:0], databyte2[4:0]};
            we_int = 1'b1;
            update_write = 1'b1;
            update_score = 1'b0;
        end
        default: begin
            we_int = 1'b0;
            score_int = score;
            update_score = 1'b0;
            update_write = 1'b1;
            waddr_int = waddr;
            wdata_int = wdata;
        end
    endcase

assign clrcmd = reset | update_score | update_write;

flopenr #(1) we_flop(.clk, .reset, .en(update_write), .d(we_int), .q(we));

flopenr #(8) wdata_flop(.clk, .reset, .en(update_write), .d(wdata_int), .q(wdata));

flopenr #(10) waddr_flop(.clk, .reset, .en(update_write), .d(waddr_int), .q(waddr));

flopenr #(10) score_flop(.clk, .reset, .en(update_score), .d(score_int), .q(score));
endmodule