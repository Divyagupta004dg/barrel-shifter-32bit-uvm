// ============================================================
// File      : scoreboard.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Scoreboard — functional checker + coverage collector
//             Reference model computes expected output
//             Compares with actual DUT output
// ============================================================

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  // 2 FIFOs — wr_monitor aur rd_monitor se data aata hai
  // FIFO buffer karta hai — timing mismatch handle karta hai
  uvm_tlm_analysis_fifo #(write_xtn) export1; // inputs
  uvm_tlm_analysis_fifo #(write_xtn) export2; // output

  write_xtn xtn1, xtn2;

  // reference model
  logic [31:0] ref_out;

  // ---- Coverage Groups ----

  // cg1 — input coverage
  // data_in range, shift_amt corners, direction
  covergroup cg1;
    option.per_instance = 1;

    // data_in — 3 ranges cover karo
    DATA_RANGE: coverpoint xtn1.data_in {
      bins ZERO    = {32'h0};
      bins LOW     = {[32'h1       : 32'h0000FFFF]};
      bins MID     = {[32'h00010000: 32'hFFFEFFFF]};
      bins HIGH    = {[32'hFFFF0000: 32'hFFFFFFFE]};
      bins ALL_ONE = {32'hFFFFFFFF};
    }

    // shift_amt — corners important 
    SHIFT_VAL: coverpoint xtn1.shift_amt {
      bins NO_SHIFT  = {5'd0};
      bins LOW_SHIFT = {[5'd1  : 5'd10]};
      bins MID_SHIFT = {[5'd11 : 5'd20]};
      bins HI_SHIFT  = {[5'd21 : 5'd30]};
      bins MAX_SHIFT = {5'd31};
    }

    // direction — left ya right
    DIR_VAL: coverpoint xtn1.dir {
      bins LEFT  = {1'b0};
      bins RIGHT = {1'b1};
    }

    // cross coverage — shift and direction
    // ye sabse important hai — interviewer yehi poochta hai
    SHIFT_DIR_CROSS: cross SHIFT_VAL, DIR_VAL;

  endgroup

  // cg2 — output coverage
  covergroup cg2;
    option.per_instance = 1;
    DOUT_RANGE: coverpoint xtn2.data_out {
      bins ZERO    = {32'h0};
      bins LOW     = {[32'h1       : 32'h0000FFFF]};
      bins MID     = {[32'h00010000: 32'hFFFEFFFF]};
      bins HIGH    = {[32'hFFFF0000: 32'hFFFFFFFE]};
      bins ALL_ONE = {32'hFFFFFFFF};
    }
  endgroup

  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    // FIFOs constructor mein initialize karo
    export1 = new("export1", this);
    export2 = new("export2", this);
    // covergroups instantiate karo
    cg1 = new();
    cg2 = new();
  endfunction

  task run_phase(uvm_phase phase);
    // fork —
    fork

      // Thread 1 — inputs monitor karo, reference calculate karo
      forever begin
        export1.get(xtn1);
        cg1.sample();
        compute_expected(xtn1);
        `uvm_info(get_type_name(),
          $sformatf("INPUT captured: data_in=%0h shift=%0d dir=%0b",
          xtn1.data_in, xtn1.shift_amt, xtn1.dir), UVM_LOW)
      end

      // Thread 2 — output 
      forever begin
        export2.get(xtn2);
        cg2.sample();
        compare(xtn2);
        `uvm_info(get_type_name(),
          $sformatf("OUTPUT captured: data_out=%0h",
          xtn2.data_out), UVM_LOW)
      end

    join
  endtask

  // reference model — RTL SW version
  // yehi calculate karta hai expected output
  task compute_expected(write_xtn xtn);
    if(xtn.dir == 1'b0)
      ref_out = xtn.data_in << xtn.shift_amt; // left shift
    else
      ref_out = xtn.data_in >> xtn.shift_amt; // right shift
  endtask

  // comparator — expected vs actual
  task compare(write_xtn xtn);
    if(ref_out == xtn.data_out)
      `uvm_info(get_type_name(),
        $sformatf("PASS: expected=%0h actual=%0h",
        ref_out, xtn.data_out), UVM_LOW)
    else
      // UVM_ERROR — simulation
      `uvm_error(get_type_name(),
        $sformatf("FAIL: expected=%0h actual=%0h",
        ref_out, xtn.data_out))
  endtask

  // report_phase — simulation end
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(),
      $sformatf("Final Coverage = %0.2f%%",
      $get_coverage()), UVM_LOW)
  endfunction

endclass