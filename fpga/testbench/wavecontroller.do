onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /vga_controller_testbench/clk
add wave -noupdate -radix hexadecimal /vga_controller_testbench/reset
add wave -noupdate -radix unsigned /vga_controller_testbench/row
add wave -noupdate -radix unsigned /vga_controller_testbench/col
add wave -noupdate -radix hexadecimal /vga_controller_testbench/raddr
add wave -noupdate -radix unsigned /vga_controller_testbench/rowExp
add wave -noupdate -radix unsigned /vga_controller_testbench/colExp
add wave -noupdate -radix hexadecimal /vga_controller_testbench/raddrExp
add wave -noupdate -radix hexadecimal /vga_controller_testbench/updateoutput
add wave -noupdate -radix hexadecimal /vga_controller_testbench/re
add wave -noupdate -radix hexadecimal /vga_controller_testbench/updateoutputExp
add wave -noupdate -radix hexadecimal /vga_controller_testbench/reExp
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/rowdone
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/rowvalid
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/colvalid
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/colblock_increment
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/startnextframe
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/duration_en
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/updateoutputvalid
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/rowblock_clk
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/colblock_clk
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/duration
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/rowblock_update
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vga_control/duration_reset
add wave -noupdate -radix hexadecimal /vga_controller_testbench/errors
add wave -noupdate -radix hexadecimal /vga_controller_testbench/vectornum
add wave -noupdate /vga_controller_testbench/vga_control/duration_counterdiv/dwidth
add wave -noupdate /vga_controller_testbench/vga_control/duration_counterdiv/clk
add wave -noupdate /vga_controller_testbench/vga_control/duration_counterdiv/reset
add wave -noupdate /vga_controller_testbench/vga_control/duration_counterdiv/en
add wave -noupdate /vga_controller_testbench/vga_control/duration_counterdiv/count_max
add wave -noupdate /vga_controller_testbench/vga_control/duration_counterdiv/divclk
add wave -noupdate /vga_controller_testbench/vga_control/duration_counterdiv/count
add wave -noupdate /vga_controller_testbench/vga_control/duration_counterdiv/next_count
add wave -noupdate /vga_controller_testbench/vga_control/duration_counterdiv/resetcounter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27 ps} 0}
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
WaveRestoreZoom {0 ps} {288 ps}
