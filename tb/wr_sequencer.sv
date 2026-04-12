// ============================================================
// File      : wr_sequencer.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Sequencer — traffic controller between
//             sequence and driver
//             Base class handles all queue management
// ============================================================

class wr_sequencer extends uvm_sequencer #(write_xtn);
  `uvm_component_utils(wr_sequencer)

  // constructor — 
  // uvm_sequencer base class
  function new(string name = "wr_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass