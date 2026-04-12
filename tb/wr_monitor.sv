// ============================================================
// File      : wr_monitor.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Write monitor — observes DUT inputs via interface
//             Broadcasts captured data to scoreboard via analysis port
// ============================================================

class wr_monitor extends uvm_monitor;
  `uvm_component_utils(wr_monitor)

  // analysis_port —
  // scoreboard ko data bhejta hai
  uvm_analysis_port #(write_xtn) port1;

  virtual bsr_if vif;
  wr_config wr_cfg;

  function new(string name = "wr_monitor", uvm_component parent);
    super.new(name, parent);
    // port ko constructor mein initialize karo
    port1 = new("port1", this);
  endfunction

  // build_phase — config interface capture
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(wr_config)::get(this, "", "wr_config", wr_cfg))
      `uvm_fatal(get_type_name(), "wr_monitor: config not found")
  endfunction

  // connect_phase — vif extract through config
  function void connect_phase(uvm_phase phase);
    vif = wr_cfg.vif;
  endfunction

  // run_phase — forever observe 
  task run_phase(uvm_phase phase);
    forever
      collect_data();
  endtask

  // collect_data — signals capture 
  task collect_data();
    write_xtn xtn;
    xtn = write_xtn::type_id::create("xtn");

    // clocking block edge wait 
    @(vif.mon_cb);

    // input signals capture 
    xtn.data_in  = vif.mon_cb.data_in;
    xtn.shift_amt = vif.mon_cb.shift_amt;
    xtn.dir      = vif.mon_cb.dir;

    // ek aur edge wait — output stable ho jaaye
    @(vif.mon_cb);
    xtn.data_out = vif.mon_cb.data_out;

    `uvm_info(get_type_name(),
      $sformatf("Captured: data_in=%0h shift=%0d dir=%0b data_out=%0h",
      xtn.data_in, xtn.shift_amt, xtn.dir, xtn.data_out), UVM_LOW)

    // do scoreboard broadcast 
    port1.write(xtn);
  endtask

endclass