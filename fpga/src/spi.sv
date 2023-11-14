/*
filename: spi.sv
author: Diego Herrera Vicioso dherreravicioso@hmc.edu

Module to take in a 3 byte sequence over SPI:
command (1 byte)
databyte1 (1 byte)
databyte2 (1 byte)

This module expects one 3 byte transaction when CS is high. 
No transmission is required for this application, only receive.

CPOL = 0, CPHA = 0
*/

module spi(input  logic sdi,
           input  logic sck,
           input  logic cs,
           output logic [7:0] command, databyte1, databyte2);

    // shift register for receiving SPI data
    always_ff @(posedge sck)
        if (cs) {command, databyte1, databyte2} = {command[6:0], databyte1, databyte2, sdi};
    
endmodule



// testbench for spi module
module spi_tb();
    logic sck, clk, sdi, cs;

    logic [7:0] command, command_exp;
    logic [7:0] databyte1, databyte1_exp;
    logic [7:0] databyte2, databyte2_exp;

    // variable to count cycles
    logic [16:0] i;

    spi dut(sdi, sck, cs, command, databyte1, databyte2);

    initial begin
        // arbitrary values to send over SPI
        command_exp <= 8'h03;
        databyte1_exp <= 8'h18;
        databyte2_exp <= 8'h09;
    end

    initial begin
        i = 0;
        cs = 0;
        clk = 0;
        sck = 0;
        #20;
        cs = 1;
        #10;
    end

    // generate clk signal
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // wide register to shift out
    logic [23:0] comb;
    assign comb = {command_exp, databyte1_exp, databyte2_exp};


    always @(posedge clk) begin
        if (i == 24) begin
            cs = 0;
            // end the tb
            if (command == command_exp && databyte1 == databyte1_exp && databyte2 == databyte2_exp)
                $display("Testbench ran successfully");
            else $display("Error: check waveforms");
            $stop();
        end

        // shift out next bit in combined register
        if (cs) begin
            #1; sdi = comb[23-i];
            #1; sck = 1; #5; sck = 0;
            i = i + 1;
        end
    end







endmodule