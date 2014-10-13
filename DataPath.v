module DataPath(input Clk, Clr); //Missing shit like crazy

wire trap, rett;
wire N,Z,C,V;
wire [31:0] IR_Out, MDR_Out;
wire [6:0] MAR_Out;

wire ALU_out;



register_32 NPC (NPC_out, NPC_in, NPC_enable, NPC_Clr, Clk);
wire [31:0] NPC_out;
register_32 PC (PC_out, NPC_out, PC_enable, PC_Clr, Clk);
wire [31:0] PC_out;



alu alu (ALU_out, N, Z, V, C, op, a, b, Cin);

ram256x8 ram (RAM_Out, MFC, RAM_enable, RAM_OpCode, MAR_Out, MDR_Out);

register_32 IR(IR_Out, RAM_Out, IR_Enable, Clr, Clk);

mux_2x1 MDR_Mux(MDR_Mux_out, MDR_Mux_S, ALU_out, RAM_Out);
register_32 MDR(MDR_Out, MDR_Mux_out, MDR_Enable, Clr, Clk);

register_32 MAR(MAR_Out, ALU_out, MAR_Enable, Clr, Clk);

psr PSR (PSR_out, {N,Z,V,C}, cwp_in, trap, PSR_Enable, Clr, Clk);
tbr TBR (TBR_Out, TBA, tt, enable, Clr, Clk);

endmodule