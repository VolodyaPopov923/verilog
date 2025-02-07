module and_gate(a, b, out);
  input a, b;
  output reg out;

  always @(a && b) begin
  out = a && b;
  end
endmodule

module alu_gate(a, b, control, out, zero);
  input [31:0] a, b;
  input [2:0] control;
  output reg [31:0] out;
  output reg zero;

  always @* begin
    if (control == 0) begin
      out = a & b;
    end
    if (control == 1) begin
      out = a | b;
    end
    if (control == 2) begin
      out = a + b;
    end
    if (control == 6) begin
      out = a - b;
    end
    if (control == 7) begin
      out = a < b;
    end
    zero = (out == 0) ? 1 : 0;
  end
endmodule