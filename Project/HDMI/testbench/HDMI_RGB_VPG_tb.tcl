quit -sim
vlib work

vlog ../HDMI_RGB_VPG.v
vlog HDMI_RGB_VPG_tb.v
vsim work.HDMI_RGB_VPG_tb
do HDMI_RGB_VPG_wave.do
run 40000 ns