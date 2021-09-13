# stop any simulation that is currently running
quit -sim

# create the default "work" library
vlib work;

vlog ../RAM_DTA_Capture.v

vlog RAM_DTA_Capture_tb.v

vsim work.RAM_DTA_Capture_tb -Lf 220model -Lf altera_mf_ver -Lf verilog

do RAM_DTA_Capture_wave.do

run 200 ns