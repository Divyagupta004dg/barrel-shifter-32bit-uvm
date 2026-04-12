// ============================================================
// File      : test.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Test classes — configure and launch environment
//             test        : base class with config setup
//             test_random : runs constrained random sequence
//             test_corner : runs directed corner case sequence
// ============================================================

// ---- Base Test ----
// config setup karta hai — dono tests isko extend karte hain
class test extends uvm_test;
  `uvm_component_utils(test)

  env_config  env_cfg;
  wr_config   wr_cfg;
  environment envh;

  function new(string name = "test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);

    // Step 1: env_config banao
    env_cfg = env_config::type_id::create("env_cfg");

    // Step 2: wr_config banao
    wr_cfg = wr_config::type_id::create("wr_cfg");

    // Step 3: wr_config settings set karo
    // ACTIVE — driver + monitor dono chalenge
    wr_cfg.is_active = UVM_ACTIVE;

    // Step 4: interface config_db se lo
    // top.sv ne set kiya tha — ab yahan get karo
    if(!uvm_config_db #(virtual bsr_if)::get(
        this, "", "bsr_if", wr_cfg.vif))
      `uvm_fatal(get_type_name(), "test: interface not found")

    // Step 5: wr_config env_config mein daalo
    env_cfg.wr_cfg    = new[1];
    env_cfg.wr_cfg[0] = wr_cfg;

    // Step 6: env_config ko config_db pe set karo
    // environment uthayega isse
    uvm_config_db #(env_config)::set(
        this, "*", "env_config", env_cfg);

    super.build_phase(phase);

    // Step 7: environment banao
    envh = environment::type_id::create("envh", this);

  endfunction

endclass

// ---- Test 1: Random ----
// constrained random sequence chalaata hai
class test_random extends test;
  `uvm_component_utils(test_random)

  function new(string name = "test_random", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    seq_random seq;
    seq = seq_random::type_id::create("seq");

    // raise_objection — simulation mat khatam karo abhi
    phase.raise_objection(this);

    // sequence start karo — agent ke sequencer pe
    seq.start(envh.agt.seqrh);

    // drop_objection — ab khatam kar sakte ho
    phase.drop_objection(this);
  endtask

endclass

// ---- Test 2: Corner Cases ----
// directed corner case sequence chalaata hai
class test_corner extends test;
  `uvm_component_utils(test_corner)

  function new(string name = "test_corner", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    seq_corner seq;
    seq = seq_corner::type_id::create("seq");

    phase.raise_objection(this);
    seq.start(envh.agt.seqrh);
    phase.drop_objection(this);
  endtask

endclass