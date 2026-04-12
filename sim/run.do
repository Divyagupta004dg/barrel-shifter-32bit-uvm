# ============================================================
# File      : run.do
# Project   : 32-bit Barrel Shifter UVM Verification
# Purpose   : ModelSim compilation and simulation script
# ============================================================

# Step 1: Library banao
vlib work
vmap work work

# Step 2: UVM compile karo
vlog -sv +incdir+$MODEL_TECH/../verilog_src/uvm-1.1d/src \
     $MODEL_TECH/../verilog_src/uvm-1.1d/src/uvm_pkg.sv

# Step 3: RTL compile karo
vlog -sv ../rtl/barrel_shifter.sv

# Step 4: TB files compile karo — order matter karta hai
vlog -sv +incdir+../tb \
     +incdir+$MODEL_TECH/../verilog_src/uvm-1.1d/src \
     ../tb/bsr_if.sv \
     ../tb/bsr_pkg.sv \
     ../tb/top.sv

# Step 5: Simulate karo
vsim -sv_seed random \
     +UVM_TESTNAME=test_random \
     +UVM_VERBOSITY=UVM_LOW \
     work.top

# Step 6: Waveform add karo
add wave -recursive *

# Step 7: Run karo
run -all