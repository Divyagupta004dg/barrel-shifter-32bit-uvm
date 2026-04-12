// ============================================================
// File      : environment.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Environment — integrates agent and scoreboard
//             Build phase creates components
//             Connect phase wires analysis ports
// ============================================================

class environment extends uvm_env;
  `uvm_component_utils(environment)

  // components jo environment ke andar hain
  wr_agent    agt;
  scoreboard  sb;
  env_config  env_cfg;

  function new(string name = "environment", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // pehle env_config lo — iske bina pata nahi kya banana hai
    if(!uvm_config_db #(env_config)::get(this, "", "env_config", env_cfg))
      `uvm_fatal(get_type_name(), "environment: env_config not found")

    super.build_phase(phase);

    // wr_config ko config_db pe set karo — agent uthayega
    uvm_config_db #(wr_config)::set(this, "agt*", "wr_config",
                                    env_cfg.wr_cfg[0]);

    // agent banao — har baar
    if(env_cfg.has_wragent)
      agt = wr_agent::type_id::create("agt", this);

    // scoreboard banao — agar enabled hai
    if(env_cfg.has_scoreboard)
      sb = scoreboard::type_id::create("sb", this);

  endfunction

  // connect_phase — monitor ka port scoreboard se jodo
  function void connect_phase(uvm_phase phase);
    // monitor ka analysis port → scoreboard ka FIFO
    // ye connection nahi hoga toh scoreboard ko data milega hi nahi
    agt.monh.port1.connect(sb.export1.analysis_export);
  endfunction

endclass