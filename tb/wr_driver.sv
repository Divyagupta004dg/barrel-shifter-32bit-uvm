// ============================================================
// File      : wr_driver.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Write driver — drives stimulus to DUT via interface
//             Gets transaction from sequencer, applies to DUT pins
// ============================================================

class wr_driver extends uvm_driver #(write_xtn);
  `uvm_component_utils(wr_driver)

  // virtual interface handle —
  virtual bsr_if vif;
  wr_config wr_cfg;

  function new(string name = "wr_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  // build_phase — 
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(wr_config)::get(this, "", "wr_config", wr_cfg))
      `uvm_fatal(get_type_name(), "wr_driver: config not found")
  endfunction

  // connect_phase — 
  function void connect_phase(uvm_phase phase);
    vif = wr_cfg.vif;
  endfunction

  // run_phase — forever loop
  task run_phase(uvm_phase phase);
    forever begin
      // sequencer se next transaction lo — tab tak wait karo
      seq_item_port.get_next_item(req);
      // DUT ko drive karo
      drive_to_dut(req);
      // sequencer ko batao — ho gaya, next do
      seq_item_port.item_done();
    end
  endtask

  // actual signal driving task
  task drive_to_dut(write_xtn xtn);
    // clocking block edge ka wait karo
    @(vif.drv_cb);
    // clocking block ke through signals drive karo
    vif.drv_cb.data_in  <= xtn.data_in;
    vif.drv_cb.shift_amt <= xtn.shift_amt;
    vif.drv_cb.dir      <= xtn.dir;
    `uvm_info(get_type_name(),
      $sformatf("Driving: data_in=%0h shift=%0d dir=%0b",
      xtn.data_in, xtn.shift_amt, xtn.dir), UVM_LOW)
  endtask

endclass