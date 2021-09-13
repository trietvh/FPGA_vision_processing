onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Clock /RAM_DTA_Capture_tb/clk
add wave -noupdate -label WR_EN /RAM_DTA_Capture_tb/WR_EN
add wave -noupdate -label WR_ADDR -radix decimal /RAM_DTA_Capture_tb/WR_ADDR
add wave -noupdate -label {Input Data} -radix hexadecimal /RAM_DTA_Capture_tb/PIXEL
add wave -noupdate -label RD_ADDR -radix decimal /RAM_DTA_Capture_tb/RD_ADDR
add wave -noupdate -label RD_DTA -radix hexadecimal /RAM_DTA_Capture_tb/RD_DTA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 ns}
