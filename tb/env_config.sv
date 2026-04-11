// ============================================================
// File      : env_config.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Environment configuration — master settings object
//             Controls which components are enabled
// ============================================================

class env_config extends uvm_object;
  `uvm_object_utils(env_config)

  // Flags to enable/disable components
  // Set in test, read in environment
  bit has_scoreboard = 1;
  bit has_wragent    = 1;

  // Number of DUT instances — 1 for this project
  int no_of_duts = 1;

  // Write agent config array — one per DUT
  wr_config wr_cfg[];

  function new(string name = "env_config");
    super.new(name);
  endfunction

endclass