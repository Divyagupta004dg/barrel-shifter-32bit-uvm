// ============================================================
// File      : wr_sequence.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Sequences — stimulus generator
//             seq_random: constrained random transactions
//             seq_corner: directed corner case transactions
// ============================================================

// ---- Sequence 1: Random ----
// fully random transactions — broad coverage ke liye
class seq_random extends uvm_sequence #(write_xtn);
  `uvm_object_utils(seq_random)

  function new(string name = "seq_random");
    super.new(name);
  endfunction

  task body();
    // 20 random transactions generate karo
    repeat(20) begin
      req = write_xtn::type_id::create("req");
      start_item(req);
      // randomize — constraints automatically apply honge
      if(!req.randomize())
        `uvm_fatal("SEQ", "Randomization failed")
      finish_item(req);
    end
  endtask

endclass

// ---- Sequence 2: Corner Cases ----
class seq_corner extends uvm_sequence #(write_xtn);
  `uvm_object_utils(seq_corner)

  function new(string name = "seq_corner");
    super.new(name);
  endfunction

  task body();
    // Case 1: shift = 0 — koi shift nahi, output = input
    send(32'hA5A5A5A5, 5'd0, 1'b0);

    // Case 2: shift = 31 — maximum left shift
    send(32'hFFFFFFFF, 5'd31, 1'b0);

    // Case 3: shift = 31 — maximum right shift
    send(32'hFFFFFFFF, 5'd31, 1'b1);

    // Case 4: data_in = 0 — zero input
    send(32'h00000000, 5'd15, 1'b0);

    // Case 5: data_in = all 1s — max value
    send(32'hFFFFFFFF, 5'd0,  1'b1);

    // Case 6: data_in = 1 — LSB only left shift
    send(32'h00000001, 5'd1,  1'b0);

    // Case 7: data_in = MSB only right shift
    send(32'h80000000, 5'd1,  1'b1);
  endtask

  // helper task — 
  task send(logic [31:0] din, logic [4:0] sh, logic d);
    req = write_xtn::type_id::create("req");
    start_item(req);
    req.data_in  = din;
    req.shift_amt = sh;
    req.dir      = d;
    finish_item(req);
  endtask

endclass