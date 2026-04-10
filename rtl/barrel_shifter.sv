// ============================================================
// 32-bit Barrel Shifter — RTL Design
// Designer : Divya Gupta, JIIT Noida
// Description: Combinational barrel shifter using MUX tree
// Supports left and right logical shift, 0 to 31 positions
// ============================================================

module barrel_shifter (
  input  logic [31:0] data_in,
  input  logic [4:0]  shift_amt,
  input  logic        dir,
  output logic [31:0] data_out
);

  assign data_out = (dir == 1'b0) ? (data_in << shift_amt)
                                  : (data_in >> shift_amt);

endmodule