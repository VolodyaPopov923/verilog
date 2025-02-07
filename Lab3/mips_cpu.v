`include "alu.v"
`include "util.v"
`include "control_unit.v"

module jump(in, out);
  input [25:0] in;
  output [31:0] out;

  assign out = {6'b000000, in};
endmodule

module read(a, b, RD, J, out);
  input wire [4:0] a, b; 
  input wire RD, J;
  output [4:0] out;

  wire [4:0] TRW;
  
  mux2_5 mux1(a, b, RD, TRW);
  mux2_5 mux2(TRW, 5'b11111, J, out);
endmodule

module oper(register_rd1, register_rd2, const, a, control, out, zero);
  input wire [31:0] register_rd1, register_rd2, const; 
  input wire [2:0] control;
  input wire a;
  output [31:0] out;
  output zero;

  wire [31:0] A = register_rd1;
  wire [31:0] B;
  mux2_32 mux1(.d0(register_rd2), .d1(const), .a(a), .out(B));
  alu_gate alu1(A, B, control, out, zero);
endmodule

module newpc(const, pc, out1, out2);
  input wire [31:0] pc, const; 
  output [31:0] out1, out2;

  wire [31:0] f;
  shl_2 shl1(const, f);
  alu_gate alu1(pc, 4, 3'b010, out1, g1);
  alu_gate alu2(out1, f, 3'b010, out2, g2);
endmodule

module jumppc(a, b1, I, A, Jr, out);
  input wire [25:0] a;
  input wire [31:0] b1, A; 
  input wire I, Jr; 
  output [31:0] out;

  wire [31:0] TJ, TE;
  jump jump1(a, TJ);
  shl_2 shl1(TJ, TE);
  wire [31:0] b2;
  mux2_32 mux1(b1, TE, I, b2);
  mux2_32 mux2(b2, A, Jr, out);
endmodule

module mips_cpu(clk, pc, pc_new, instruction_memory_a, instruction_memory_rd, data_memory_a, data_memory_rd, data_memory_we, data_memory_wd,
                register_a1, register_a2, register_a3, register_we3, register_wd3, register_rd1, register_rd2);
  // сигнал синхронизации
  input clk;
  // текущее значение регистра PC
  inout [31:0] pc;
  // новое значение регистра PC (адрес следующей команды)
  output [31:0] pc_new;
  // we для памяти данных
  output data_memory_we;
  // адреса памяти и данные для записи памяти данных
  output [31:0] instruction_memory_a, data_memory_a, data_memory_wd;
  // данные, полученные в результате чтения из памяти
  inout [31:0] instruction_memory_rd, data_memory_rd;
  // we3 для регистрового файла
  output register_we3;
  // номера регистров
  output [4:0] register_a1, register_a2, register_a3;
  // данные для записи в регистровый файл
  output [31:0] register_wd3;
  // данные, полученные в результате чтения из регистрового файла
  inout [31:0] register_rd1, register_rd2;

  wire [5:0] control = instruction_memory_rd[31:26];
  wire [5:0] base = instruction_memory_rd[5:0];

  assign instruction_memory_a = pc;
  assign register_we3 = G;
  assign data_memory_a = Result;
  assign data_memory_wd = register_rd2;
  assign data_memory_we = B;
  wire [31:0] H;
  mux2_32 mux1(Result, data_memory_rd, A, H);
  mux2_32 mux2(H, pc0, J, register_wd3);

  wire A, B, C, D, E, F, G, I, J, Jr;
  wire [2:0] Control;
  assign register_a1 = a1;
  assign register_a2 = a2;
  assign register_a3 = a3;
  wire [31:0] const, Result, pc0, pc1;

  control_unit CU(control, base, A, B, C, D, E, F, G, Control, I, J, Jr);

  read re1(b1, b2, F, J, a3);

  sign_extend se(tC, const);

  wire [31:0] sA = register_rd1;
  wire zero, X, Y, nz, rz;
  wire [15:0] tC = instruction_memory_rd[15:0];
  wire [25:0] jA = instruction_memory_rd[25:0];

  oper oper1(register_rd1, register_rd2, const, E, Control, Result, zero);

  newpc npc(const, pc, pc0, pc1);

  mux2_1 mux3(nz, zero, D, rz);
  and_gate and1(Y, rz, X);
  wire [31:0] Z;

  mux2_1 mux4(C, D, zero, Y);
  assign nz = !zero;

  mux2_32 mux5(pc0, pc1, X, Z);

  jumppc jump2(jA, Z, I, sA, Jr, pc_new);

  wire [4:0] a1 = instruction_memory_rd[25:21]; 
  wire [4:0] a2 = instruction_memory_rd[20:16];
  wire [4:0] a3; 
  wire [4:0] b1 = instruction_memory_rd[20:16];
  wire [4:0] b2 = instruction_memory_rd[15:11];
endmodule