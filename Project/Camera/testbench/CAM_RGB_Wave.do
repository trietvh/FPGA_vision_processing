onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -label Clock /testbench/clk
add wave -noupdate -label Reset_n /testbench/reset
add wave -noupdate -label VSYNC /testbench/vsync
add wave -noupdate -label HREF /testbench/href
add wave -noupdate -label CAM_DATA -radix hexadecimal -radixshowbase 0 /testbench/CAM_DTA
add wave -noupdate -divider Output
add wave -noupdate -label o_pclk /testbench/o_pclk
add wave -noupdate -label Valid_Pixel -radix hexadecimal -radixshowbase 0 /testbench/pixel
add wave -noupdate -label Enable /testbench/en
add wave -noupdate -divider {STATE Tracking}
add wave -noupdate -label STATE /testbench/UUT/STATE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {39815 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 15
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {150 ns}
