module DataPath(input Clk, Clr); //Missing shit like crazy

wire trap, rett;
wire N,Z,C,V;
wire [31:0] IR_Out, MDR_Out;
wire [6:0]MAR_Out;

alu alu (res, N, Z, V, C, op, a, b, Cin);

ram256x8 ram (RAM_Out, MFC, RAM_enable, RAM_OpCode, MAR_Out, MDR_Out);
register_32 IR(IR_Out, RAM_Out, IR_Enable, Clr, Clk);

mux_2x1 MDR_Mux(MDR_Mux_out, MDR_Mux_S, ALU_Out, RAM_Out);
register_32 MDR(MDR_Out, MDR_Mux_out, MDR_Enable, Clr, Clk);
register_32 MAR(MAR_Out, ALU_Out, MAR_Enable, Clr, Clk);
psr PSR (PSR_out, {N,Z,V,C}, cwp_in, trap, rett, PSR_Enable, Clr, Clk);
