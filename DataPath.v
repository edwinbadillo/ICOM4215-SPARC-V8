module DataPath(
	// Instruction Register
	input IR_Enable,
	input [31:0]IR_In,
	output [31:0]IR_Out,
	
	// ALU
	output [31:0]ALU_out,
	
	// register file
	input register_file_enable,
	input [4:0] in_PA, in_PB, in_PC,
	output [31:0]out_PA, out_PB,
	
	// Sign Extender
	input [1:0]extender_select,
	output [31:0]extender_out,
	
	// ALUB Mux
	input [1:0]ALUB_Mux_select,
	output [31:0]ALUB_Mux_out,
	
	// MDR Mux
	input MDR_Mux_select,
	
	// Ram input
	input [5:0]RAM_OpCode,
	output MFC,
	
	// Enables
	input NPC_enable, PC_enable, MDR_Enable, MAR_Enable, RAM_enable, PSR_Enable,
	input Clk, Clr); //Missing shit like crazy
	
	
	wire trap, rett;
	wire N,Z,C,V,Cin;

	wire [31:0] MDR_Mux_out, MDR_Out, MAR_Out, RAM_Out;
	
	/* Registers */

	// NPC and PC registers
/* 	register_32 NPC (NPC_out, NPC_in, NPC_enable, NPC_Clr, Clk);
	register_32 PC (PC_out, NPC_out, PC_enable, PC_Clr, Clk); */
	
	// IR
	register_32 IR(IR_Out, IR_In, IR_Enable, IR_Clr, Clk);
	
	// Memory registers
	/* register_32 MDR(MDR_Out, MDR_Mux_out, MDR_Enable, Clr, Clk);
	register_32 MAR(MAR_Out, ALU_out, MAR_Enable, Clr, Clk); */
	
	/* Components */
	
	register_file register_file(out_PA, out_PB, ALU_out, in_PA, in_PB, in_PC, register_file_enable, Clr, Clk, 2'b00);
	
	// ALU
	alu alu(ALU_out, N, Z, V, C, IR_Out[24:19], out_PA, ALUB_Mux_out, Cin);
	
	// Sign Extender for immediate values: 00 = 12 bit, 01 = 22 bit, 10 = 30 bit
	sign_extender_magic_box s_extender(extender_out, IR_Out, extender_select);

	// RAM
	// ram512x8 ram(RAM_Out, MFC, RAM_enable, RAM_OpCode, MAR_Out, MDR_Out);

/* 	// Process State Register
	psr PSR (PSR_out, {N,Z,V,C}, cwp_in, trap, PSR_Enable, Clr, Clk);
	
	// Trap Base Register
	tbr TBR (TBR_Out, TBA, tt, enable, Clr, Clk); */
	
	/* Muxes */
	
	// Mux for the input of MDR (Memory out or ALU out)
	// mux_2x1 MDR_Mux(MDR_Mux_out, MDR_Mux_select, ALU_out, RAM_Out);

	
	
	// Mux for selecting second operand for ALU
	mux_32_4x1 ALUB_Mux(ALUB_Mux_out, ALUB_Mux_select, out_PB, extender_out, MDR_Out, 32'h00000000);

endmodule