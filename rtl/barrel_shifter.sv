// ============================================================
// File      : barrel_shifter.sv
// Designer  : Divya Gupta, JIIT Noida
// Purpose   : Parameterized barrel shifter — supports any width
//             Default: 32-bit. Scalable to 64-bit and beyond.
// ============================================================

module barrel_shifter #(
  parameter WIDTH     = 32,
  parameter SHIFT_W   = $clog2(WIDTH)  // auto: 32->5, 64->6
)(
  input  logic [WIDTH-1:0]   data_in,
  input  logic [SHIFT_W-1:0] shift_amt,
  input  logic               dir,        // 0=left, 1=right
  output logic [WIDTH-1:0]   data_out
);

  assign data_out = (dir == 1'b0) ? (data_in << shift_amt)
                                  : (data_in >> shift_amt);

endmodule