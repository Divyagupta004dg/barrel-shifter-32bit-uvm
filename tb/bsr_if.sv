// ============================================================
// File      : bsr_if.sv
// Project   : 32-bit Barrel Shifter UVM Verification
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : SystemVerilog interface connecting DUT and TB
//             Provides clocking blocks to avoid race conditions
//             Modports enforce access control per component
// ============================================================

interface bsr_if();

  logic [31:0] data_in;
  logic [4:0]  shift_amt;
  logic        dir;
  logic [31:0] data_out;
  logic        tb_clk;

  // Driver clocking block — drives inputs to DUT
  clocking drv_cb @(posedge tb_clk);
    default input #1 output #1;
    output data_in;
    output shift_amt;
    output dir;
  endclocking

  // Monitor clocking block — observes all signals
  clocking mon_cb @(posedge tb_clk);
    default input #1 output #1;
    input data_in;
    input shift_amt;
    input dir;
    input data_out;
  endclocking

  modport DRV_MP (clocking drv_cb);
  modport MON_MP (clocking mon_cb);

endinterface