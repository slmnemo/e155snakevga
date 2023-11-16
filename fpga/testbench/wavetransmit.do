onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_transmitter_testbench/clk
add wave -noupdate /vga_transmitter_testbench/reset
add wave -noupdate /vga_transmitter_testbench/vectornum
add wave -noupdate /vga_transmitter_testbench/errors
add wave -noupdate /vga_transmitter_testbench/testvectors
add wave -noupdate /vga_transmitter_testbench/row
add wave -noupdate /vga_transmitter_testbench/col
add wave -noupdate /vga_transmitter_testbench/VSync
add wave -noupdate /vga_transmitter_testbench/HSync
add wave -noupdate /vga_transmitter_testbench/VSyncExp
add wave -noupdate /vga_transmitter_testbench/HSyncExp
add wave -noupdate /vga_transmitter_testbench/RGB
add wave -noupdate /vga_transmitter_testbench/RGB_out
add wave -noupdate /vga_transmitter_testbench/RGBExp
add wave -noupdate /vga_transmitter_testbench/transmitter/output_en
add wave -noupdate /vga_transmitter_testbench/transmitter/R_in
add wave -noupdate /vga_transmitter_testbench/transmitter/G_in
add wave -noupdate /vga_transmitter_testbench/transmitter/B_in
add wave -noupdate /vga_transmitter_testbench/transmitter/R_out
add wave -noupdate /vga_transmitter_testbench/transmitter/G_out
add wave -noupdate /vga_transmitter_testbench/transmitter/B_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {19 ps}
