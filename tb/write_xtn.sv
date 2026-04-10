// ============================================================
// File      : write_xtn.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Transaction class — data packet for stimulus
//             Randomizable fields with constraints
//             Used by sequencer, driver, monitor, scoreboard
// ============================================================

class write_xtn extends uvm_sequence_item;
  `uvm_object_utils(write_xtn)

  // Randomizable input fields
  rand logic [31:0] data_in;
  rand logic [4:0]  shift_amt;  // 0 to 31
  rand logic        dir;         // 0=left, 1=right

  // Output field — not randomized, captured from DUT
  logic [31:0] data_out;

  // Constructor
  function new(string name = "write_xtn");
    super.new(name);
  endfunction

  // Constraints
  constraint c_data  { data_in  inside {[0  : 32'hFFFFFFFF]}; }
  constraint c_shift { shift_amt inside {[0  : 31]}; }
  constraint c_dir   { dir      inside {1'b0, 1'b1}; }

  // do_print — scoreboard aur log mein dikhega
  function void do_print(uvm_printer printer);
    printer.print_field("data_in",  this.data_in,  32, UVM_HEX);
    printer.print_field("shift_amt",this.shift_amt, 5, UVM_DEC);
    printer.print_field("dir",      this.dir,       1, UVM_BIN);
    printer.print_field("data_out", this.data_out, 32, UVM_HEX);
    super.do_print(printer);
  endfunction

endclass