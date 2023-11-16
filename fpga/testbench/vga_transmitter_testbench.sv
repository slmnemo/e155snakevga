// testbench for lab 2 
// Compares inputs and outputs of a module to expected IO
// Supplies clk signals to modules
//
// Written by Kaitlin Lucio (nlucio@hmc.edu)
// Date written: 9/11/2023

// `timescale 1ns/1ns  
`default_nettype none
`define numTestvectors 420000
`define WIDTH 28

module vga_transmitter_testbench();

    logic clk, reset;
    logic [$clog2(`numTestvectors)-1:0] vectornum, errors;
    logic [`WIDTH-1:0] testvectors[1000000:0]; // Vectors of format hexValue[3:0]_segment[6:0]

    // Add other internal signals below
    logic [9:0]     row, col;
    logic           VSync, HSync, VSyncExp, HSyncExp;
    logic [2:0]     RGB, RGB_out, RGBExp;

    // Instantiate DUT for testing (will receive clock from external sources)
    vga_transmitter transmitter(.row, .col, .R_in(RGB[2]), .G_in(RGB[1]), .B_in(RGB[0]), .VSync, .HSync, .R_out(RGB_out[2]), .G_out(RGB_out[1]), .B_out(RGB_out[0]));

    // Initialize clock signal
    always begin 
        clk = 1; #5;
        clk = 0; #5;
    end

    // Simulation startup
    // Load testvectors into memory and reset DUT
    initial begin
        $readmemb("./testvectors/vga_transmitter.tv", testvectors, 0, `numTestvectors - 1);
        vectornum = 0; errors = 0;
        reset = 1; #27; reset = 0;
    end
    
    // Apply testvector on rising edge of clk
    always @(posedge clk)
        begin
            #1; {row, col, RGB, VSyncExp, HSyncExp, RGBExp} = testvectors[vectornum];
        end
        initial begin
            // Dumpfile for signals
            // $dumpfile(sevenSegment.vcd);
            // $dumpvars(0, sevenSegment);
        end
    always @(negedge clk)
        begin
            if (~reset) begin
                if (RGB_out != RGBExp) begin
                    $display("RGB error: RGB_out=%d, RGBExp =%d",RGB_out, RGBExp);
                    errors = errors + 1;
                    
                end
                if (VSync != VSyncExp) begin
                    $display("VSync error: VSync=%d, VSyncExp =%d", VSync, VSyncExp);
                    errors = errors + 1;
                    
                end
                if (HSync != HSyncExp) begin
                    $display("HSync error HSync=%h, HSyncExp=%h", HSync, HSyncExp);
                    errors = errors + 1;

                end
                vectornum = vectornum + 1;
                if (testvectors[vectornum] === `WIDTH'bx) begin
                    $display("%d tests completed with %d errors", vectornum, errors);
                    $stop;
                end
            end
        end
endmodule
