/*
Module to generate control signals for other VGA modules such as row, col, donext

Also handles raddr and re logic

TODO: handle initialization case (row and delay counter mismatch) and read and reset counter at max value

TODO: fix issues related to resetting earlier than expected

*/

`include "vga_params.sv"

module vga_controller (
    input logic         clk, reset,
    output logic        updateoutput, update_state, re,
    output logic [9:0]  row, col, raddr
);

logic       row_en, rowdone, rowvalid, colvalid, colblock_increment, startnextframe, duration_en, updateoutputvalid, delay_row;
logic       rowblock_trig, colblock_trig;
logic [4:0] next_duration, duration;
logic [9:0] raddrvalid;
logic [4`:0] rowmod20, colmod20;

flopenr #(5) duration_flop(.clk, .reset, .en(updateoutput | startnextframe), .d(next_duration), .q(duration));

// flop to delay row_counter turn-on by exactly one clock cycle
flop #(1) rowdelay_flop(.clk, .reset, .d(1'b1), .q(row_en));

// row counter always running ***TODO: fix discrepancy between delay counter and row
counter_static #(`HFULLSCAN-1) row_counter(.clk, .reset(startnextframe), .en(row_en), .count(row));

// row internal signals
assign rowdone = (row == `HFULLSCAN-1); // 2 cycle delay between row finish and actual coladdr increment?
assign rowvalid = (row < `HACTIVE);

// column counter enabled by row reset
counter_static #(`VFULLSCAN) col_counter(.clk, .reset(startnextframe), .en(rowdone), .count(col));

// Logic and states for vertical and horizontal address fsms
logic       incr_hblock, incr_cblock;
logic [4:0] next_hblock, hblock, next_vblock, vblock;

typedef enum logic [1:0] {V_IDLE, V_ADRINC, V_WAIT_FOR_DONE} vstates; 
vstates vstate, next_vstate;

typedef enum logic [1:0] {H_IDLE, H_ADRINC, H_READ, H_UPDATE} hstates;
hstates hstate, next_hstate;

always_comb begin
    case(hstate)
        H_IDLE:     if (rowblock_trig == 1'b1)  next_hstate = H_ADRINC;
                    else                        next_hstate = H_IDLE;
        H_ADRINC:   if (rowvalid == 1'b1)       next_hstate = H_READ;
                    else                        next_hstate = H_IDLE;
        H_READ:                                 next_hstate = H_UPDATE;
        H_UPDATE:                               next_hstate = H_IDLE;
        default:        next_hstate = H_IDLE;
    endcase
end

always_comb begin
    case(vstate)
        V_IDLE: if (colblock_trig == 1'b1)          next_vstate = V_ADRINC;
                else                                next_vstate = V_IDLE;
        V_ADRINC:                                   next_vstate = V_WAIT_FOR_DONE;
        V_WAIT_FOR_DONE:    if (rowdone == 1'b1)    next_vstate = V_IDLE;
                            else                    next_vstate = V_WAIT_FOR_DONE;

        default:    next_vstate = V_IDLE;
    endcase
end

// col internal signals
assign colvalid = (col < `VACTIVE);
assign colblock_increment = (colvalid & rowdone & (vstate != V_WAIT_FOR_DONE)); // account for pipeline delay when calculating next readaddr
assign startnextframe = reset | ((col == `VFULLSCAN-1) & rowdone);

// Handle division of row and column inputs by block boundaries
counter_static #(19) rowblock_counter(.clk, .reset(startnextframe), .en(rowvalid), .count(rowmod20));
counter_static #(20) colblock_counter(.clk, .reset(startnextframe | colblock_trig), .en(colblock_increment), .count(colmod20));

// Precalculating signals for fsm to calculate read address
assign in_hporch = ~rowvalid;
assign in_vporch = ~colvalid;
assign colblock_trig = (colmod20 == 5'd19) & in_hporch;
assign rowblock_trig = (rowmod20 == 5'd19) & rowvalid & colvalid;

// Flop to do state logic
always_ff @(posedge clk) begin
    if (reset) begin
        hstate <= H_IDLE;
        vstate <= V_IDLE;
    end
    else begin
        hstate <= next_hstate;
        vstate <= next_vstate;
    end
end

assign incr_hblock = (hstate == H_ADRINC);
assign incr_cblock = (vstate == V_ADRINC);

flopenr #(5) rowaddr_flop(.clk, .reset(in_hporch | reset), .en(incr_hblock), .d(next_hblock), .q(hblock));
flopenr #(5) coladdr_flop(.clk, .reset(in_vporch | reset), .en(incr_cblock), .d(next_vblock), .q(vblock));

assign next_hblock = hblock + 5'b1;
assign next_vblock = vblock + 5'b1;

assign raddr = {hblock, vblock};
assign re = (hstate == H_READ) | in_vporch | in_hporch;
assign update_state = (hstate == H_UPDATE);

// assign rowblock_update = rowblock_clk | (row == 0); // no need for colblock_update at 0 since we only need to fetch row ahead of time
// counter_static #(32) addrrowoffset_counter(.clk, .reset(~rowvalid | reset), .en(rowblock_update), .count(raddr[4:0]));
// counter_static #(24) addrcoloffset_counter(.clk, .reset(~colvalid | reset), .en(colblock_clk), .count(raddr[9:5]));

// count duration using next duration to create clear boundaries on colors

// Hardcode next duration to 20
assign next_duration = 5'd19;

assign duration_en = (colvalid & rowvalid);
assign duration_reset = ~duration_en | reset;

counterdiv_dyn #(5) duration_counterdiv(.clk, .reset(duration_reset), .en(duration_en), .count_max(duration), .divclk(updateoutputvalid));

mux2 #(1) updateoutput_mux(.s(duration_en), .d0(1'b1), .d1(updateoutputvalid), .q(updateoutput));

endmodule

