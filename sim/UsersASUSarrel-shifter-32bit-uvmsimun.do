set UVM_HOME C:/intelFPGA/20.1/modelsim_ase/verilog_src/uvm-1.2

vlib work
vmap work work

vlog -sv +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv

vlog -sv ../rtl/barrel_shifter.sv

vlog -sv +incdir+../tb +incdir+$UVM_HOME/src ../tb/bsr_if.sv ../tb/bsr_pkg.sv ../tb/top.sv

vsim -sv_seed random +UVM_TESTNAME=test_random +UVM_VERBOSITY=UVM_LOW work.top

add wave -recursive *

run -all
