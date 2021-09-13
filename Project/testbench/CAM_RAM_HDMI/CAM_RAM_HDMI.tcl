quit -sim
vlib work



vlog ../../Buffer/RAM_DTA_Capture.v
vlog ../../Buffer/RGB_DTA_Buffer.v


vlog ../../Camera/CAM_RGB_Capture.v 



vlog CAM_RAM_HDMI_tb.v
vsim work.CAM_RAM_HDMI_tb -Lf 220model -Lf altera_mf_ver -Lf verilog

do CAM_RAM_HDMI_wave.do
run 55 ns