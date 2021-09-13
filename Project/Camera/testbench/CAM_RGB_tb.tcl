quit -sim
vlib work

vlog ../CAM_RGB_Capture.v
vlog CAM_RGB_Capture_tb.v
vsim work.testbench
do CAM_RGB_Wave.do

run 150 ns
