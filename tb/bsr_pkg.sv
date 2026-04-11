// ============================================================
// File      : bsr_pkg.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Central package — includes all TB components
//             in dependency order for correct compilation
// ============================================================

package bsr_pkg;

  // Import UVM base library
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Step 1: Transaction class — used by all components
  `include "write_xtn.sv"

  // Step 2: Configuration classes
  `include "wr_config.sv"
  `include "env_config.sv"

  // Step 3: Driver, Monitor, Sequencer
  `include "wr_driver.sv"
  `include "wr_monitor.sv"
  `include "wr_sequencer.sv"

  // Step 4: Agent — wraps driver, monitor, sequencer
  `include "wr_agent.sv"

  // Step 5: Sequences — test stimulus generator
  `include "wr_sequence.sv"

  // Step 6: Scoreboard — functional checker
  `include "scoreboard.sv"

  // Step 7: Environment — integrates all components
  `include "environment.sv"

  // Step 8: Test — top level test controller
  `include "test.sv"

endpackage