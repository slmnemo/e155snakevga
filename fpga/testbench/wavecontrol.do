onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /vga_controller_testbench/vga_control/next_duration
add wave -noupdate /vga_controller_testbench/vga_control/updateoutput
add wave -noupdate /vga_controller_testbench/vga_control/re
add wave -noupdate -radix unsigned /vga_controller_testbench/vga_control/row
add wave -noupdate -radix unsigned /vga_controller_testbench/vga_control/col
add wave -noupdate /vga_controller_testbench/vga_control/raddr
add wave -noupdate /vga_controller_testbench/vga_control/row_en
add wave -noupdate /vga_controller_testbench/vga_control/rowdone
add wave -noupdate /vga_controller_testbench/vga_control/rowvalid
add wave -noupdate /vga_controller_testbench/vga_control/colvalid
add wave -noupdate /vga_controller_testbench/vga_control/colblock_increment
add wave -noupdate /vga_controller_testbench/vga_control/startnextframe
add wave -noupdate /vga_controller_testbench/vga_control/duration_en
add wave -noupdate /vga_controller_testbench/vga_control/updateoutputvalid
add wave -noupdate /vga_controller_testbench/vga_control/delay_row
add wave -noupdate /vga_controller_testbench/vga_control/rowblock_trig
add wave -noupdate /vga_controller_testbench/vga_control/colblock_trig
add wave -noupdate /vga_controller_testbench/vga_control/duration
add wave -noupdate /vga_controller_testbench/vga_control/raddrvalid
add wave -noupdate -radix unsigned /vga_controller_testbench/vga_control/rowmod20
add wave -noupdate -radix unsigned /vga_controller_testbench/vga_control/colmod20
add wave -noupdate /vga_controller_testbench/vga_control/in_hporch
add wave -noupdate /vga_controller_testbench/vga_control/in_vporch
add wave -noupdate /vga_controller_testbench/vga_control/incr_hblock
add wave -noupdate /vga_controller_testbench/vga_control/incr_cblock
add wave -noupdate -radix unsigned /vga_controller_testbench/vga_control/next_hblock
add wave -noupdate /vga_controller_testbench/vga_control/hblock
add wave -noupdate -radix unsigned /vga_controller_testbench/vga_control/next_vblock
add wave -noupdate /vga_controller_testbench/vga_control/vblock
add wave -noupdate /vga_controller_testbench/vga_control/vstate
add wave -noupdate /vga_controller_testbench/vga_control/next_vstate
add wave -noupdate /vga_controller_testbench/vga_control/hstate
add wave -noupdate /vga_controller_testbench/vga_control/next_hstate
add wave -noupdate /vga_controller_testbench/vga_control/duration_reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4103 ps} 0}
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
WaveRestoreZoom {3750 ps} {4750 ps}
