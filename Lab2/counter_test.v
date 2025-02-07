`include "templates.v"

module counter_reference(clk, addr, control, immediate, data);
  input clk;
  input [1:0] addr;
  input [3:0] immediate;
  input control;

  output [3:0] data;

  reg signed [3:0] registers [0:3];
  integer i;

  initial begin
    for (i = 0; i < 4; i = i + 1) begin
      registers[i] = 0;
    end
  end

  assign data = registers[addr];

  always @(negedge clk) begin
    case (control)
      1'b0: registers[addr] = registers[addr] + immediate;
      1'b1: registers[addr] = registers[addr] - immediate;
    endcase
  end
endmodule

module test_counter();
  // test inputs
  reg [1:0] addr;
  reg [3:0] immediate;
  reg clk, control;

  // test output and expected output
  wire [3:0] data, data_expected;

  // register file to test and register file model
  counter counter_to_test(clk, addr, control, immediate, data);
  counter_reference counter_to_test_against(clk, addr, control, immediate, data_expected);

  reg signed [3:0] state_actual [3:0], state_expected [3:0];

  task check_state;
    reg check_error;
    integer i;
    begin
      check_error = 0;

      for (i = 0; i < 4; i = i + 1) begin
        if (state_actual[i] !== state_expected[i]) begin
          check_error = 1;
        end
      end

      if (check_error) begin
        // $display("Error: a=%b b=%b control=%b => expected=%b actual=%b", a, b, control, alu_out_expected, alu_out);
        $display("  Error:");
        $display("    expected = [%d, %d, %d, %d]",
          state_expected[0], state_expected[1], state_expected[2], state_expected[3]
        );
        $display("    actual   = [%d, %d, %d, %d]",
          state_actual[0], state_actual[1], state_actual[2], state_actual[3]
        );
      end
    end
  endtask

  task collect_state;
    integer i;
    reg [1:0] addr_buf;
    begin
      addr_buf = addr;
      // compare against model
      for (i = 0; i < 4; i = i + 1) begin
        addr = i;
        #1
        state_actual[i] = data;
        state_expected[i] = data_expected;
      end
      addr = addr_buf;
    end
  endtask

  task check_memory_state;
    begin
      collect_state();
      check_state();
    end
  endtask

  task execute_op(input reg op, input reg [1:0] write_addr, input reg signed [3:0] imm);
    begin
      #1;
      $display("addr = %0d, op = %s, immediate = %0d", write_addr, op ? "-" : "+", imm);
      addr = write_addr;
      control = op;
      immediate = imm;
      #1;
      check_memory_state();
      #1;
      $display("clk = 1");
      clk = 1;
      #1;
      check_memory_state();
      #1;
      $display("clk = 0");
      clk = 0;
      #1;
      check_memory_state();
    end
  endtask
  initial begin
    clk = 0;

    // a[0] += -1
    execute_op(0, 0, -1);
    // a[1] += -6
    execute_op(0, 1, -6);
    // a[2] += 5
    execute_op(0, 2, 5);
    // a[3] += 0
    execute_op(0, 3, 0);

    // a[0] += 5
    execute_op(0, 0, 5);
    // a[1] += 6
    execute_op(0, 1, 6);
    // a[2] -= 3
    execute_op(1, 2, 3);
    // a[3] -= 1
    execute_op(1, 2, 1);

    // a[0] -= 2
    execute_op(1, 0, 2);
    // a[1] -= 5
    execute_op(1, 1, 5);
    // a[2] += 1
    execute_op(0, 2, 1);
    // a[3] += 7
    execute_op(0, 3, 7);
  end
endmodule