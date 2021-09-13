onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -label Clock /DTA_Buffer_tb/clk
add wave -noupdate -label Write_En /DTA_Buffer_tb/WR_EN
add wave -noupdate -label {Pixel data} -radix hexadecimal -radixshowbase 0 /DTA_Buffer_tb/PIXEL
add wave -noupdate -label RD_Address -radix hexadecimal -radixshowbase 0 /DTA_Buffer_tb/RD_ADDR
add wave -noupdate -divider Output
add wave -noupdate -label RD_DTA -radix hexadecimal -radixshowbase 0 /DTA_Buffer_tb/RD_DTA
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
WaveRestoreZoom {0 ps} {200 ns}
