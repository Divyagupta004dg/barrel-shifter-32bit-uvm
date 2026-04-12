// ============================================================
// File      : wr_agent.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Write agent — wraps driver, monitor, sequencer
//             ACTIVE mode: all three components run
//             PASSIVE mode: only monitor runs
// ============================================================

class wr_agent extends uvm_agent;
  `uvm_component_utils(wr_agent)

  // three components — 
  wr_driver    drvh;
  wr_monitor   monh;
  wr_sequencer seqrh;

  wr_config wr_cfg;

  function new(string name = "wr_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  // build_phase —
  function void build_phase(uvm_phase phase);
    // pehle config lo
    if(!uvm_config_db #(wr_config)::get(this, "", "wr_config", wr_cfg))
      `uvm_fatal(get_type_name(), "wr_agent: config not found")

    super.build_phase(phase);

    // monitor  — ACTIVE aur PASSIVE both case forms
    monh = wr_monitor::type_id::create("monh", this);

    // driver aur sequencer sirf ACTIVE mein bante hain
    if(wr_cfg.is_active == UVM_ACTIVE) begin
      drvh  = wr_driver::type_id::create("drvh", this);
      seqrh = wr_sequencer::type_id::create("seqrh", this);
    end
  endfunction

  // connect_phase — driver aur sequencer join
  function void connect_phase(uvm_phase phase);
    if(wr_cfg.is_active == UVM_ACTIVE)
      // driver ka port sequencer ke export se connect karo
      drvh.seq_item_port.connect(seqrh.seq_item_export);
  endfunction

endclass