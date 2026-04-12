// ============================================================
// File      : top.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Top module — simulation entry point
//             Instantiates DUT and interface
//             Generates TB clock, starts UVM test
// ============================================================

module top;

  // UVM aur project package import
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import bsr_pkg::*;

  // TB clock — 
  // DUT combinational
  bit tb_clk;
  always #10 tb_clk = ~tb_clk; // 20ns period = 50MHz

  // interface instantiate karo
  // tb_clk interface ko do
  bsr_if inf();
  assign inf.tb_clk = tb_clk;

  // DUT instantiate 
  barrel_shifter dut(
    .data_in  (inf.data_in),
    .shift_amt(inf.shift_amt),
    .dir      (inf.dir),
    .data_out (inf.data_out)
  );

  initial begin
    // interface config_db set 
    // "*" — poori hierarchy mein available hoga
    uvm_config_db #(virtual bsr_if)::set(
      null, "*", "bsr_if", inf);


    run_test();
  end

endmodule