onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Camera Input}
add wave -noupdate -label Clock /CAM_RAM_HDMI_tb/clk
add wave -noupdate -label Vsync /CAM_RAM_HDMI_tb/vsync
add wave -noupdate -label Href /CAM_RAM_HDMI_tb/href
add wave -noupdate -label I_CAM_DTA -radix hexadecimal -radixshowbase 0 /CAM_RAM_HDMI_tb/CAM_DTA
add wave -noupdate -divider {Camera Output}
add wave -noupdate -label o_pclk /CAM_RAM_HDMI_tb/o_pclk
add wave -noupdate -label CAM_EN /CAM_RAM_HDMI_tb/CAM_En
add wave -noupdate -label o_pixel -radix hexadecimal -childformat {{{/CAM_RAM_HDMI_tb/pixel[15]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[14]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[13]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[12]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[11]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[10]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[9]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[8]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[7]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[6]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[5]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[4]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[3]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[2]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[1]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/pixel[0]} -radix hexadecimal}} -subitemconfig {{/CAM_RAM_HDMI_tb/pixel[15]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[14]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[13]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[12]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[11]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[10]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[9]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[8]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[7]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[6]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[5]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[4]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[3]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[2]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[1]} {-height 15 -radix hexadecimal} {/CAM_RAM_HDMI_tb/pixel[0]} {-height 15 -radix hexadecimal}} /CAM_RAM_HDMI_tb/pixel
add wave -noupdate -divider {Buffer Input}
add wave -noupdate -label WR_ADDR -radix decimal /CAM_RAM_HDMI_tb/RAM_u/WR_ADDR
add wave -noupdate -label HDMI_ADDR -radix decimal -radixshowbase 0 /CAM_RAM_HDMI_tb/HDMI_ADDR
add wave -noupdate -divider {Buffer Output}
add wave -noupdate -label HDMI_En /CAM_RAM_HDMI_tb/HDMI_En
add wave -noupdate -label HDMI_DTA -radix hexadecimal -childformat {{{/CAM_RAM_HDMI_tb/HDMI_DTA[15]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[14]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[13]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[12]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[11]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[10]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[9]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[8]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[7]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[6]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[5]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[4]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[3]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[2]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[1]} -radix hexadecimal} {{/CAM_RAM_HDMI_tb/HDMI_DTA[0]} -radix hexadecimal}} -radixshowbase 0 -subitemconfig {{/CAM_RAM_HDMI_tb/HDMI_DTA[15]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[14]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[13]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[12]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[11]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[10]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[9]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[8]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[7]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[6]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[5]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[4]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[3]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[2]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[1]} {-height 15 -radix hexadecimal -radixshowbase 0} {/CAM_RAM_HDMI_tb/HDMI_DTA[0]} {-height 15 -radix hexadecimal -radixshowbase 0}} /CAM_RAM_HDMI_tb/HDMI_DTA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10160 ps} 0}
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
WaveRestoreZoom {0 ps} {52500 ps}
