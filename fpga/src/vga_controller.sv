/*
Module to generate control signals for other VGA modules such as row, col, donext

Also handles raddr and re logic

TODO: handle initialization case (row and delay counter mismatch) and read and reset counter at max value


*/

module vga_controller #(parameter horizontal_scansize=800-1, parameter vertical_scansize=525-1) (
    input logic         clk, reset,
    input logic [4:0]   next_duration,
    output logic        updateoutput, re,
    output logic [9:0]  row, col, raddr
);

logic       row_en, rowdone, rowvalid, colvalid, colblock_increment, startnextframe, duration_en, updateoutputvalid, delay_row;
logic       rowblock_clk, colblock_clk;
logic [4:0] duration;
logic [9:0] raddrvalid;

typedef enum logic [2:0] {prep_next_line, prep_next_frame, fetch_next} statetypes; // states go here, have 8 states possible rn
statetypes state, next_state;

flopenr #(5) duration_flop(.clk, .reset, .en(updateoutput | startnextframe), .d(next_duration), .q(duration));

// flop to delay row_counter turn-on by exactly one clock cycle
flop #(1) rowdelay_flop(.clk, .reset, .d(1'b1), .q(row_en));

// row counter always running ***TODO: fix discrepancy between delay counter and row
counter_static #(horizontal_scansize) row_counter(.clk, .reset(startnextframe), .en(row_en), .count(row));

// row internal signals
assign rowdone = (row == 10'd799); // 2 cycle delay between row finish and actual coladdr increment?
assign rowvalid = (row < 10'd640);

// column counter enabled by row reset
assign startnextframe = reset | ((col == 10'd524) & (row == 10'd799));
counter_static #(vertical_scansize) col_counter(.clk, .reset(startnextframe), .en(rowdone), .count(col));

// col internal signals
assign colvalid = (col < 10'd480);
assign colblock_increment = (colvalid & (row == 10'd798));

// Handle division of row and column inputs by block boundaries
counterdiv_static #(19) rowblock_counterdiv(.clk, .reset(startnextframe), .en(rowvalid), .divclk(rowblock_clk));
counterdiv_static #(19) colblock_counterdiv(.clk, .reset(startnextframe), .en(colblock_increment), .divclk(colblock_clk));

// calculate address offsets for 1k BMEM

assign rowblock_update = rowblock_clk | (row == 0); // no need for colblock_update at 0 since we only need to fetch row ahead of time
counter_static #(32) addrrowoffset_counter(.clk, .reset(~rowvalid | reset), .en(rowblock_update), .count(raddr[4:0]));
counter_static #(24) addrcoloffset_counter(.clk, .reset(~colvalid | reset), .en(colblock_clk), .count(raddr[9:5]));

// count duration down from next duration
assign duration_en = (colvalid & rowvalid);
assign duration_reset = ~duration_en | reset;

counterdiv_dyn #(5) duration_counterdiv(.clk, .reset(duration_reset), .en(duration_en), .count_max(duration), .divclk(updateoutputvalid));

mux2 #(1) updateoutput_mux(.s(duration_en), .d0(1'b1), .d1(updateoutputvalid), .q(updateoutput));

// read from correct memory address if invalid or updating row boundary 
assign re = duration_reset | rowblock_update;

endmodule

