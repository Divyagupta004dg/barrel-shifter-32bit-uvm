// ============================================================
// File      : wr_config.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Write agent configuration object
//             Carries virtual interface handle and active/passive mode
// ============================================================

class wr_config extends uvm_object;
  `uvm_object_utils(wr_config)

  // UVM_ACTIVE  = driver + monitor both run (input side)
  // UVM_PASSIVE = only monitor runs (output side)
  uvm_active_passive_enum is_active;

  // Virtual interface handle — connects TB to actual DUT signals
  // 'virtual' keyword means this is a TB-side copy of the interface
  virtual bsr_if vif;

  function new(string name = "wr_config");
    super.new(name);
  endfunction

endclass