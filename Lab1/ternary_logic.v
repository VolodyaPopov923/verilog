module ternary_min(a, b, out);
  input [1:0] a;
  input [1:0] b;
  output [1:0] out;

  and_gate and_gate1(a[1], b[1], out[1]);

  wire nota1;
  wire notb1;
  wire nota0;
  wire notb0;
  wire f11;
  wire f12;
  wire f1;
  wire f21;
  wire f22;
  wire f2;
  wire f31;
  wire f32;
  wire f3;
  wire f;

  not_gate not_gate1(a[1], nota1);
  not_gate not_gate2(b[1], notb1);
  not_gate not_gate3(a[0], nota0);
  not_gate not_gate4(b[0], notb0);

  and_gate and_gate2(nota1, a[0], f11);
  and_gate and_gate3(notb1, b[0], f12);
  and_gate and_gate4(f11, f12, f1);

  and_gate and_gate5(nota1, a[0], f21);
  and_gate and_gate6(b[1], notb0, f22);
  and_gate and_gate7(f21, f22, f2);

  and_gate and_gate8(a[1], nota0, f31);
  and_gate and_gate9(notb1, b[0], f32);
  and_gate and_gate10(f31, f32, f3);  

  or_gate or_gate1(f1, f2, f);
  or_gate or_gate2(f, f3, out[0]);

  // TODO: implementation
endmodule

module ternary_max(a, b, out);
  input [1:0] a;
  input [1:0] b;
  output [1:0] out;

  or_gate or_gate2(a[1], b[1], out[1]);

  wire nota1;
  wire notb1;
  wire nota0;
  wire notb0;
  wire f11;
  wire f12;
  wire f1;
  wire f21;
  wire f22;
  wire f2;
  wire f31;
  wire f32;
  wire f3;
  wire f;

  not_gate not_gate1(a[1], nota1);
  not_gate not_gate2(b[1], notb1);
  not_gate not_gate3(a[0], nota0);
  not_gate not_gate4(b[0], notb0);

  and_gate and_gate2(nota1, nota0, f11);
  and_gate and_gate3(notb1, b[0], f12);
  and_gate and_gate4(f11, f12, f1);

  and_gate and_gate5(nota1, a[0], f21);
  and_gate and_gate6(notb1, notb0, f22);
  and_gate and_gate7(f21, f22, f2);

  and_gate and_gate8(nota1, a[0], f31);
  and_gate and_gate9(notb1, b[0], f32);
  and_gate and_gate10(f31, f32, f3);

  or_gate or_gate11(f1, f2, f);
  or_gate or_gate12(f, f3, out[0]);
  // TODO: implementation
endmodule

module ternary_consensus(a, b, out);
  input [1:0] a;
  input [1:0] b;
  output [1:0] out;

  and_gate and_gate1(a[1], b[1], out[1]);

  wire nota1;
  wire notb1;
  wire f11;
  wire f12;
  wire f1;
  wire f21;
  wire f22;
  wire f2;

  not_gate not_gate1(a[1], nota1);
  not_gate not_gate2(b[1], notb1);

  or_gate or_gate1(a[1], a[0], f11);
  or_gate or_gate2(b[1], b[0], f12);
  or_gate or_gate3(f11, f12, f1);

  or_gate or_gate4(nota1, a[0], f21);
  or_gate or_gate5(notb1, b[0], f22);
  or_gate or_gate6(f21, f22, f2);

  and_gate and_gate2(f1, f2, out[0]);
  // TODO: implementation
endmodule

module ternary_any(a, b, out);
  input [1:0] a;
  input [1:0] b;
  output [1:0] out;

  wire c1;
  wire f121; 
  wire f11;
  wire f211;
  wire f221; 
  wire f21; 
  wire f311; 
  wire f321; 
  wire f31; 
  wire ff1;
  wire nota1;
  wire notb1; 
  wire notb0;
  wire nota0;

  not_gate not_gate1(a[0], nota0);
  not_gate not_gate2(a[1], nota1);
  not_gate not_gate3(b[0], notb0);
  not_gate not_gate4(b[1], notb1);
  
  and_gate and_gate1(nota1, a[0], c1);
  and_gate and_gate2(b[1], notb0, f121);
  and_gate and_gate3(c1, f121, f11);
  
  and_gate and_gate4(a[1], nota0, f211);
  and_gate and_gate5(notb1, b[0], f221);
  and_gate and_gate6(f211, f221, f21);
  
  and_gate and_gate7(a[1], nota0, f311);
  and_gate and_gate8(b[1], notb0, f321);
  and_gate and_gate9(f311, f321, f31);

  or_gate or_gate1(f11, f21, ff1);
  or_gate or_gate2(ff1, f31, out[1]);

  wire f112;
  wire f122;
  wire f12;
  wire f212;
  wire f222;
  wire f22;
  wire f312; 
  wire f322; 
  wire f32;
  wire ff2;


  and_gate and_gate10(nota1, nota0, f112);
  and_gate and_gate11(b[1], notb0, f122);
  and_gate and_gate12(f112, f122, f12);
  
  // 2-й клоз
  and_gate and_gate13(nota1, a[0], f212);
  and_gate and_gate14(notb1, b[0], f222);
  and_gate and_gate15(f212, f222, f22);

  // 3-й клоз
  and_gate and_gate16(a[1], nota0, f312);
  and_gate and_gate17(notb1, notb0, f322);
  and_gate and_gate18(f312, f322, f32);

  // считаем f2
  or_gate or_gate3(f12, f22, ff2);
  or_gate or_gate4(ff2, f32, out[0]);
  // TODO: implementation
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