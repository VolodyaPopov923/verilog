`include "templates.v"

module register_file_reference(clk, rd_addr, we_addr, we_data, rd_data, we);
  input clk; // Сигнал синхронизации
  input [1:0] rd_addr, we_addr; // Номера регистров для чтения и записи
  input [3:0] we_data; // Данные для записи в регистровый файл
  input we;

  output [3:0] rd_data; // Данные, полученные в результате чтения из регистрового файла
  // TODO: implementation

  reg [3:0] registers [0:3];
  integer i;

  initial begin
    for (i = 0; i < 4; i = i + 1) begin
      registers[i] = 0;
    end
  end

  assign rd_data = registers[rd_addr];

  always @(negedge clk) begin
    if (we) begin
      registers[we_addr] = we_data;
    end
  end
endmodule

module test_register_file();
  // test inputs
  reg [1:0] rd_addr, we_addr;
  reg [3:0] we_data;
  reg clk, we;

  // test output and expected output
  wire [3:0] rd_data, rd_data_expected;

  // register file to test and register file model
  register_file register_file_to_test(clk, rd_addr, we_addr, we_data, rd_data, we);
  register_file_reference register_file_to_test_against(clk, rd_addr, we_addr, we_data, rd_data_expected, we);

  // input values to test
  reg [3:0] testvals [0:3];

  reg [3:0] state_actual [3:0], state_expected [3:0];

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
        $display("    expected = [%b, %b, %b, %b]",
          state_expected[0], state_expected[1], state_expected[2], state_expected[3]
        );
        $display("    actual   = [%b, %b, %b, %b]",
          state_actual[0], state_actual[1], state_actual[2], state_actual[3]
        );
      end
    end
  endtask

  task collect_state;
    integer i;
    begin
      // compare against model
      for (i = 0; i < 4; i = i + 1) begin
        rd_addr = i;
        #1;
        state_actual[i] = rd_data;
        state_expected[i] = rd_data_expected;
      end
    end
  endtask

  task check_memory_state;
    begin
      collect_state();
      check_state();
    end
  endtask

  task write_value(input reg [1:0] addr, input reg [3:0] value);
    begin
      #1;
      $display("we_addr = %0d, we_data = %0d, we = 1", addr, value);
      we_addr = addr;
      we_data = value;
      we = 1;
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
      $display("we = 0");
      we = 0;
      check_memory_state();
    end
  endtask
  initial begin
    testvals[0] = 4'b1111;
    testvals[1] = 4'b1010;
    testvals[2] = 4'b0101;
    testvals[3] = 4'b0000;

    clk = 0;

    write_value(0, testvals[0]);
    write_value(1, testvals[1]);
    write_value(2, testvals[2]);
    write_value(3, testvals[3]);
    write_value(0, testvals[1]);
    write_value(1, testvals[2]);
    write_value(2, testvals[3]);
    write_value(3, testvals[0]);
    write_value(0, testvals[2]);
    write_value(1, testvals[3]);
    write_value(2, testvals[0]);
    write_value(3, testvals[1]);
  end
endmodule