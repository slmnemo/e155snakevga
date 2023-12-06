// testbench for lab 2 
// Compares inputs and outputs of a module to expected IO
// Supplies clk signals to modules
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Date written: 9/11/2023

// `timescale 1ns/1ns  
`default_nettype none
`define numTestvectors 420000*10
`define WIDTH 37

module vga_top_testbench();

    logic clk, reset;
    logic [$clog2(`numTestvectors)-1:0] vectornum, errors;
    logic [`WIDTH-1:0] testvectors[10000000:0]; // Vectors of format hexValue[3:0]_segment[6:0]

    // Add other internal signals below
    logic [4:0]     next_duration;
    logic [9:0]     row, col, raddr, rowExp, colExp, raddrExp;
    logic           updateoutput, re, updateoutputExp, reExp;

    // Instantiate DUT for testing (will receive clock from external sources)
    vga_top dut(.clk, .reset, .next_duration, .updateoutput, .re, .row, .col, .raddr);

    // Initialize clock signal
    always begin 
        clk = 1; #5;
        clk = 0; #5;
    end

    // Simulation startup
    // Load testvectors into memory and reset DUT
    initial begin
        $readmemb("./testvectors/vga_controller.tv", testvectors, 0, `numTestvectors - 1);
        vectornum = 0; errors = 0;
        reset = 1; #27; reset = 0;
    end
    
    // Apply testvector on rising edge of clk
    always @(posedge clk)
        begin
            #1; {next_duration, rowExp, colExp, raddrExp, updateoutputExp, reExp} = testvectors[vectornum];
        end
        initial begin
            // Dumpfile for signals
            // $dumpfile(sevenSegment.vcd);
            // $dumpvars(0, sevenSegment);
        end
    always @(negedge clk)
        begin
            if (~reset) begin
                if (row != rowExp) begin
                    $display("Row error: row=%d, rowExp =%d",row, rowExp);
                    errors = errors + 1;
                    
                end
                if (col != colExp) begin
                    $display("Col error: col=%d, colExp =%d",col, colExp);
                    errors = errors + 1;
                    
                end
                // // Commented code below to test row and column match expectations

                // if (raddr != raddrExp) begin
                //     $display("raddr error raddr=%h, raddrExp=%h", raddr, raddrExp);
                //     errors = errors + 1;

                // end
                // if (updateoutput != updateoutputExp) begin
                //     $display("updateoutput Error uo=%h, uoExp=%h", updateoutput, updateoutputExp);
                //     errors = errors + 1;
                    
                // end
                // if (re != reExp) begin
                //     $display("re error re=%h, reExp=%h", re, reExp);
                //     errors = errors + 1;
                    
                // end
                vectornum = vectornum + 1;
                if (testvectors[vectornum] === `WIDTH'bx) begin
                    $display("%d tests completed with %d errors", vectornum, errors);
                    $stop;
                end
            end
        end
endmodule
