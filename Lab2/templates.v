module AandB(a, b, out);
  input [3:0] a, b;
  output [3:0] out;

  and_gate and_gate1(a[0], b[0], out[0]);
  and_gate and_gate2(a[1], b[1], out[1]);
  and_gate and_gate3(a[2], b[2], out[2]);
  and_gate and_gate4(a[3], b[3], out[3]);
endmodule 

module nAandB(a, b, out);
  input [3:0] a, b;
  output [3:0] out;
  wire [3:0] AanB;

  AandB AB(a, b, AanB);

  not_gate not_gate1(AanB[0], out[0]);
  not_gate not_gate2(AanB[1], out[1]);
  not_gate not_gate3(AanB[2], out[2]);
  not_gate not_gate4(AanB[3], out[3]);
endmodule 

module AorB(a, b, out);
  input [3:0] a, b;
  output [3:0] out;

  or_gate or_gate1(a[0], b[0], out[0]);
  or_gate or_gate2(a[1], b[1], out[1]);
  or_gate or_gate3(a[2], b[2], out[2]);
  or_gate or_gate4(a[3], b[3], out[3]);
endmodule 

module nAorB(a, b, out);
  input [3:0] a, b;
  output [3:0] out;
  wire [3:0] AoB;

  AorB AB(a, b, AoB);

  not_gate not_gate1(AoB[0], out[0]);
  not_gate not_gate2(AoB[1], out[1]);
  not_gate not_gate3(AoB[2], out[2]);
  not_gate not_gate4(AoB[3], out[3]);
endmodule 

module fullsum_gate(a, b, C, out, outC);
  input  a, b, C;
  output  out, outC;

  wire x1;
  wire A1;
  wire A2;
  
  xor_gate xor_gate1(a, b, x1);
  xor_gate xor_gate2(x1, C, out);

  and_gate and_gate1(a, b, A1);
  and_gate and_gate2(x1, C, A2);

  or_gate or_gate1(A1, A2, outC);
endmodule

module full4sum(a, b, z, out);
  input [3:0] a, b;
  input z;
  output [3:0] out;
  wire [3:0] AoB;

  fullsum_gate fullsum_gate1(a[0], b[0], z, out[0], c1);
  fullsum_gate fullsum_gate2(a[1], b[1], c1, out[1], c2);
  fullsum_gate fullsum_gate3(a[2], b[2], c2, out[2], c3);
  fullsum_gate fullsum_gate4(a[3], b[3], c3, out[3], c4);
endmodule 

module ml_gate(a, b, x, out);
  input wire a, b, x;
  output wire out;
  
  not_gate not_gate1(x, notx);
  and_gate and_gate2(a, x, f1);
  and_gate and_gate3(b, notx, f2);
  or_gate or_gate1(f1, f2, out);
endmodule

module multiplexor_gate(f1, f2, f3, f4, f5, f6, f7, f8,control,out);
  input f1, f2, f3, f4, f5, f6, f7, f8;
  input [2:0] control;
  output out;

  not_gate not_gate1(control[0],c);
  not_gate not_gate2(control[1],b);
  not_gate not_gate3(control[2],a);

  and4_gate and4_gate1(f1,a,b,c,x1);
  and4_gate and4_gate2(f2,a,b,control[0],x2);
  and4_gate and4_gate3(f3,a,control[1],c,x3);
  and4_gate and4_gate4(f4,a,control[1],control[0],x4);
  and4_gate and4_gate5(f5,control[2],b,c,x5);
  and4_gate and4_gate6(f6,control[2],b,control[0],x6);
  and4_gate and4_gate7(f7,control[2],control[1],c,x7);
  and4_gate and4_gate8(f8,control[2],control[1],control[0],x8);

  or_gate or_gate1(x1, x2, z1);
  or_gate or_gate2(x3, x4, z2);
  or_gate or_gate3(x5, x6, z3);
  or_gate or_gate4(x7, x8, z4);
  or_gate or_gate5(z1, z2, z5);
  or_gate or_gate6(z3, z4, z6);
  or_gate or_gate7(z6, z5, out);
endmodule

module alu(a, b, control, res);
  input [3:0] a, b; // Операнды
  input [2:0] control; // Управляющие сигналы для выбора операции

  output [3:0] res; // Результат

  wire [3:0] A_and_B;
  wire [3:0] n_A_and_B;
  wire [3:0] A_or_B;
  wire [3:0] n_A_or_B;
  wire [3:0] A_pl_B;
  wire [3:0] notb;
  wire [3:0] A_mn_B;
  wire z0 = 0;
  wire z1 = 1;

  AandB AandB1(a, b, A_and_B);
  nAandB nAandB1(a, b, n_A_and_B);
  AorB AorB1(a, b, A_or_B);
  nAorB nAorB1(a, b, n_A_or_B);
  full4sum full4sum1(a, b, z0, A_pl_B);

  not_gate not_gate9(b[0], notb[0]);
  not_gate not_gate10(b[1], notb[1]);
  not_gate not_gate11(b[2], notb[2]);
  not_gate not_gate12(b[3], notb[3]);

  full4sum full4sum2(a, notb, z1, A_mn_B);
  
  not_gate not_gate13(A_mn_B[3], nAmnB);
  not_gate not_gate14(a[3], k1);
  not_gate not_gate15(b[3], k2);
  
  and_gate and_gate99(a[3],k2,k3);
  and_gate and_gate98(b[3],k1,k4);

  not_gate not_gate16(k3, k33);
  not_gate not_gate17(k4, k44);

  and4_gate and_gate41(k44,z1,nAmnB,k3,m1);
  and4_gate and_gate42(k44,z1,A_mn_B[3],k33,m2);
  and4_gate and_gate43(k44,z1,A_mn_B[3],k3,m3);

  or_gate or_gate41(m1,m2,m4);
  or_gate or_gate42(m3,m4,slt);

  multiplexor_gate multiplexor_gate1(A_and_B[0], n_A_and_B[0], A_or_B[0], n_A_or_B[0], A_pl_B[0], A_mn_B[0], slt, z0, control, res[0]);
  multiplexor_gate multiplexor_gate2(A_and_B[1], n_A_and_B[1], A_or_B[1], n_A_or_B[1], A_pl_B[1], A_mn_B[1], z0, z0, control, res[1]);
  multiplexor_gate multiplexor_gate3(A_and_B[2], n_A_and_B[2], A_or_B[2], n_A_or_B[2], A_pl_B[2], A_mn_B[2], z0, z0, control, res[2]);
  multiplexor_gate multiplexor_gate4(A_and_B[3], n_A_and_B[3], A_or_B[3], n_A_or_B[3], A_pl_B[3], A_mn_B[3], z0, z0, control, res[3]);
  // TODO: implementation
endmodule

module d_latch(clk, d, we, q);
  input clk; // Сигнал синхронизации
  input d; // Бит для записи в ячейку
  input we; // Необходимо ли перезаписать содержимое ячейки

  output reg q; // Сама ячейка
  // Изначально в ячейке хранится 0
  initial begin
    q <= 0;
  end
  // Значение изменяется на переданное на спаде сигнала синхронизации
  always @ (negedge clk) begin
    // Запись происходит при we = 1
    if (we) begin
      q <= d;
    end
  end
endmodule

module register_file(clk, rd_addr, we_addr, we_data, rd_data, we);
  input clk; // Сигнал синхронизации
  input [1:0] rd_addr, we_addr; // Номера регистров для чтения и записи
  input [3:0] we_data; // Данные для записи в регистровый файл
  input we; // Необходимо ли перезаписать содержимое регистра
  output [3:0] rd_data; // Данные, полученные в результате чтения из регистрового файла
  wire [3:0] buffer;
  wire [3:0] out;
  wire [3:0] w;
  wire [15:0] rd0;
  wire [15:0] rd1;

  not_gate not_gate1(we_addr[0], not0);
  not_gate not_gate2(we_addr[1], not1);

  and_gate and_gate1(not0, not1, buffer[0]);
  and_gate and_gate2(not0, we_addr[1], buffer[1]);
  and_gate and_gate3(we_addr[0], not1, buffer[2]);
  and_gate and_gate4(we_addr[0], we_addr[1], buffer[3]);

  not_gate not_gate3(rd_addr[0], notr0);
  not_gate not_gate4(rd_addr[1], notr1);

  and_gate and_gate11(notr0, notr1, out[0]);
  and_gate and_gate22(notr0, rd_addr[1], out[1]);
  and_gate and_gate33(rd_addr[0], notr1, out[2]);
  and_gate and_gate44(rd_addr[0], rd_addr[1], out[3]);

  and_gate and_gate5(we, buffer[0], w[0]);
  and_gate and_gate6(we, buffer[1], w[1]);
  and_gate and_gate7(we, buffer[2], w[2]);
  and_gate and_gate8(we, buffer[3], w[3]);
  
  d_latch d0(clk, we_data[0], w[0], rd0[0]);
  d_latch d1(clk, we_data[1], w[0], rd0[1]);
  d_latch d2(clk, we_data[2], w[0], rd0[2]);
  d_latch d3(clk, we_data[3], w[0], rd0[3]);
  d_latch d4(clk, we_data[0], w[1], rd0[4]);
  d_latch d5(clk, we_data[1], w[1], rd0[5]);
  d_latch d6(clk, we_data[2], w[1], rd0[6]);
  d_latch d7(clk, we_data[3], w[1], rd0[7]);
  d_latch d8(clk, we_data[0], w[2], rd0[8]);
  d_latch d9(clk, we_data[1], w[2], rd0[9]);
  d_latch d10(clk, we_data[2], w[2], rd0[10]);
  d_latch d11(clk, we_data[3], w[2], rd0[11]);
  d_latch d12(clk, we_data[0], w[3], rd0[12]);
  d_latch d13(clk, we_data[1], w[3], rd0[13]);
  d_latch d14(clk, we_data[2], w[3], rd0[14]);
  d_latch d15(clk, we_data[3], w[3], rd0[15]);

  and_gate and_gate9(rd0[0], out[0], rd1[0]);
  and_gate and_gate10(rd0[1], out[0], rd1[1]);
  and_gate and_gate112(rd0[2], out[0], rd1[2]);
  and_gate and_gate12(rd0[3], out[0], rd1[3]);
  and_gate and_gate13(rd0[4], out[1], rd1[4]);
  and_gate and_gate14(rd0[5], out[1], rd1[5]);
  and_gate and_gate15(rd0[6], out[1], rd1[6]);
  and_gate and_gate16(rd0[7], out[1], rd1[7]);
  and_gate and_gate17(rd0[8], out[2], rd1[8]);
  and_gate and_gate18(rd0[9], out[2], rd1[9]);
  and_gate and_gate19(rd0[10], out[2], rd1[10]);
  and_gate and_gate20(rd0[11], out[2], rd1[11]);
  and_gate and_gate21(rd0[12], out[3], rd1[12]);
  and_gate and_gate221(rd0[13], out[3], rd1[13]);
  and_gate and_gate23(rd0[14], out[3], rd1[14]);
  and_gate and_gate24(rd0[15], out[3], rd1[15]);

  or_gate or_gate1(rd1[0], rd1[4], f1);
  or_gate or_gate2(rd1[8], rd1[12], f2);
  or_gate or_gate3(f1, f2, rd_data[0]);

  or_gate or_gate4(rd1[1], rd1[5], f3);
  or_gate or_gate5(rd1[9], rd1[13], f4);
  or_gate or_gate6(f3, f4, rd_data[1]);

  or_gate or_gate7(rd1[2], rd1[6], f5);
  or_gate or_gate8(rd1[10], rd1[14], f6);
  or_gate or_gate9(f5, f6, rd_data[2]);

  or_gate or_gate10(rd1[3], rd1[7], f7);
  or_gate or_gate11(rd1[11], rd1[15], f8);
  or_gate or_gate12(f7, f8, rd_data[3]);
  // TODO: implementation
endmodule

module counter(clk, addr, control, immediate, data);
  input clk; // Сигнал синхронизации
  input [1:0] addr; // Номер значения счетчика которое читается или изменяется
  input [3:0] immediate; // Целочисленная константа, на которую увеличивается/уменьшается значение счетчика
  input control; // 0 - операция инкремента, 1 - операция декремента
  output [3:0] data; // Данные из значения под номером addr, подающиеся на выход
  wire[3:0] x, y;

  wire z1 = 1;
  register_file file(clk, addr, addr, x, y, z1);

  wire[2:0] element = {2'b10, control};

  alu alu1(y, immediate, element, x);
  assign data = y;
endmodule

module not_gate(a, out);
  input wire a;
  output out;

  supply1 pwr;
  supply0 gnd;

  pmos pmos1(out, pwr, a);
  nmos nmos1(out, gnd, a);
endmodule

module and_gate(a, b, out);
  input wire a, b;
  output wire out;
  wire nand_out;
  nand_gate nand_gate1(a, b, nand_out);
  not_gate not_gate1(nand_out, out);
endmodule

module and4_gate(a, b, c, d, out); 
  input wire a, b, c, d;
  output wire out;
  wire c1, c2;
  and_gate and_gate1(a, b, c1);
  and_gate and_gate2(c, d, c2);
  and_gate and_gate3(c1, c2, out);
endmodule

module nand_gate(a, b, out); 
  input wire a, b;
  output out;

  supply1 pwr;
  supply0 gnd;

  wire nmos1_out;

  pmos pmos1(out, pwr, a);
  pmos pmos2(out, pwr, b);

  nmos nmos1(nmos1_out, gnd, b);
  nmos nmos2(out, nmos1_out, a);
endmodule

module nor_gate(a, b, out); 
  input wire a, b;
  output out; 

  wire c1; 

  supply1 pwr; 
  supply0 gnd;

  pmos(c1, pwr, b); 
  pmos(out, c1, a); 

  nmos(out, gnd, a); 
  nmos(out, gnd, b);
endmodule

module or_gate(a, b, out);
  input wire a, b;
  output wire out;
  wire nand_out;
  nor_gate nor_gate1(a, b, nand_out);
  not_gate not_gate1(nand_out, out);
endmodule

module xor_gate(a, b, out);
  input wire a, b;
  output wire out;

  wire nota;
  wire notb;
  wire c1;
  wire c2;

  not_gate not_gate1(a, nota);
  not_gate not_gate2(b, notb);

  and_gate and_gate1(a, notb, c1);
  and_gate and_gate2(nota, b, c2);

  or_gate or_gate1(c1, c2, out);
endmodule