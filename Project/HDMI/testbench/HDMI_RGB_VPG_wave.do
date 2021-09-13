onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Input
add wave -noupdate -label reset_n /HDMI_RGB_VPG_tb/reset_n
add wave -noupdate -label i_Pixel -radix hexadecimal -radixshowbase 0 /HDMI_RGB_VPG_tb/PIXEL
add wave -noupdate -divider Output
add wave -noupdate -label Vsync /HDMI_RGB_VPG_tb/vs
add wave -noupdate -label Hsync /HDMI_RGB_VPG_tb/hs
add wave -noupdate -label {Date enable} /HDMI_RGB_VPG_tb/de
add wave -noupdate -label Red -radix hexadecimal -radixshowbase 0 /HDMI_RGB_VPG_tb/vga_r
add wave -noupdate -label Green -radix hexadecimal -radixshowbase 0 /HDMI_RGB_VPG_tb/vga_g
add wave -noupdate -label Blue -radix hexadecimal -radixshowbase 0 /HDMI_RGB_VPG_tb/vga_b
add wave -noupdate -divider HDMI_signals
add wave -noupdate -label pre_de /HDMI_RGB_VPG_tb/UUT/pre_vga_de
add wave -noupdate -label h_count -radix decimal -radixshowbase 0 /HDMI_RGB_VPG_tb/UUT/h_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28143500 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {19127604 ps} {33893230 ps}
