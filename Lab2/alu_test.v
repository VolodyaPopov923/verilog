`include "templates.v"

module alu_reference(a, b, control, res);
  input wire signed [3:0] a, b; // Операнды
  input wire [2:0] control; // Управляющие сигналы для выбора операции

  output reg signed [3:0] res; // Результат

  initial calculate();
  always @(a, b, control) calculate();

  task calculate;
    case (control)
      3'b000: res <= a & b;
      3'b001: res <= ~(a & b);
      3'b010: res <= a | b;
      3'b011: res <= ~(a | b);
      3'b100: res <= a + b;
      3'b101: res <= a - b;
      3'b110: res <= (a < b);
      3'b111: begin $display("error: alu_model: invalid control %b", control); $finish; end
    endcase
  endtask
endmodule

module alu_test();
  // test inputs
  reg signed [3:0] a, b;
  reg [2:0] control;

  // test output and expected output
  wire signed [3:0] alu_out, alu_out_expected;
  alu alu_to_test(a, b, control, alu_out);
  alu_reference alu_to_test_against(a, b, control, alu_out_expected);

  integer i_control, i_a, i_b;

  task check_alu_state; begin
    // ensure changes settled
    #1;

    // compare against model
    if (alu_out !== alu_out_expected) begin
      $display("Error: a=%b b=%b control=%b => expected=%b actual=%b", a, b, control, alu_out_expected, alu_out);
    end
  end endtask

  initial begin
    for (i_control = 0; i_control < 7; i_control = i_control + 1) begin
      control = i_control;

      // print current operation
      case (control)
        3'b000: $display("Test a & b");
        3'b001: $display("Test ~(a & b)");
        3'b010: $display("Test a | b");
        3'b011: $display("Test ~(a | b)");
        3'b100: $display("Test a + b");
        3'b101: $display("Test a - b");
        3'b110: $display("Test slt");
        3'b111: begin $display("Unreachable"); $finish; end
      endcase

      // test operation for all value pairs
      for (i_a = 0; i_a < 16; i_a = i_a + 1) begin
        a = i_a;
        for (i_b = 0; i_b < 16; i_b = i_b + 1) begin
          b = i_b;
          check_alu_state();
        end
      end
    end
  end
endmodule
