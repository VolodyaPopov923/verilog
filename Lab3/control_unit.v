module control_unit(control, base, A, B, C, D, E, F, G, Control, I, J, Jr);

input wire [5:0] control, base;
output wire A, B, C, D, E, F, G, I, J, Jr;
output reg [2:0] Control;

reg TA, TB, TC, TD, TE, TF, TG, TI, TJ, TJr;

reg [1:0] ALUop;

assign A = TA, B = TB, C = TC, D = TD, E = TE, F = TF, G = TG, I = TI, J = TJ, Jr = TJr; 

always @* begin
if (control == 0) begin
    TC = 0; TD = 0; TB = 0; ALUop = 2'b10; TI = 0; TJr = 0; TG = 1; TF = 1; TE = 0; TA = 0; TJ = 0;
end
else if (control == 2) begin
    TC = 0; TD = 0; TB = 0; ALUop = 2'b10; TI = 1; TJr = 0; TG = 0; TF = 0; TE = 0; TA = 0; TJ = 0;
end
else if (control == 3) begin
    TC = 0; TD = 0; TB = 0; ALUop = 2'b10; TI = 1; TJr = 0; TG = 1; TF = 0; TE = 0; TA = 0; TJ = 1;
end
else if (control == 4) begin
    TC = 0; TD = 1; TB = 0; ALUop = 2'b01; TI = 0; TJr = 0; TG = 0; TF = 0; TE = 0; TA = 0; TJ = 0;
end
else if (control == 5) begin
    TC = 1; TD = 0; TB = 0; ALUop = 2'b01; TI = 0; TJr = 0; TG = 0; TF = 0; TE = 0; TA = 0; TJ = 0;
end
else if (control == 8) begin
    TC = 0; TD = 0; TB = 0; ALUop = 2'b00; TI = 0; TJr = 0; TG = 1; TF = 0; TE = 1; TA = 0; TJ = 0;
end
else if (control == 12) begin
    TC = 0; TD = 0; TB = 0; ALUop = 2'b11; TI = 0; TJr = 0; TG = 1; TF = 0; TE = 1; TA = 0; TJ = 0;
end
else if (control == 43) begin
    TC = 0; TD = 0; TB = 1; ALUop = 2'b00; TI = 0; TJr = 0; TG = 0; TF = 0; TE = 1; TA = 0; TJ = 0;
end

if (ALUop == 2'b00)
begin
  Control = 3'b010;
end 
else if (ALUop == 2'b01)
begin
  Control = 3'b110;
end 
else if (ALUop == 2'b11) 
begin
  Control = 3'b000;
end 
else begin
  case (base)
  6'b100000: Control = 3'b010;
  6'b100010: Control = 3'b110;
  6'b100100: Control = 3'b000;
  6'b100101: Control = 3'b001;
  6'b101010: Control = 3'b111;
  6'b001000: begin 
    TJr = 1;
    TG = 0;
  end
  endcase
end
end
endmodule