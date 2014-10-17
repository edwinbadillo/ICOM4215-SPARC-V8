module DataPath(output [31:0]IR_Out, MFC,
	// Enables
	input NPC_enable, PC_enable, IR_Enable, MDR_Enable, MAR_Enable, file_enable, RAM_enable, RAM_OpCode, PSR_Enable,
	// Select Lines
	extender_select, MDR_Mux_select, ALUB_Mux_select,
	// Miscellaneous
	Clk, Clr); //Missing shit like crazy
	
	
	/* Registers */

	// NPC and PC registers
	register_32 NPC (NPC_out, NPC_in, NPC_enable, NPC_Clr, Clk);
	register_32 PC (PC_out, NPC_out, PC_enable, PC_Clr, Clk);
	// IR
	register_32 IR(IR_Out, RAM_Out, IR_Enable, Clr, Clk);
	
	// Memory registers
	register_32 MDR(MDR_Out, MDR_Mux_out, MDR_Enable, Clr, Clk);
	register_32 MAR(MAR_Out, ALU_out, MAR_Enable, Clr, Clk);
	
	/* Components */
	
	register_file(out_PA, out_PB, file_in, in_PA, in_PB, in_PC, file_enable, Clr, Clk, current_window);
	
	// ALU
	alu alu(ALU_out, N, Z, V, C, ALU_op, a, b, Cin);
	
	// Sign Extender for immediate values: 00 = 12 bit, 01 = 22 bit, 10 = 30 bit
	sign_extender_magic_box s_extender(extender_out, IR_Out, extender_select);

	// RAM
	ram512x8 ram(RAM_Out, MFC, RAM_enable, RAM_OpCode, MAR_Out, MDR_Out);

	// Process State Register
	psr PSR (PSR_out, {N,Z,V,C}, cwp_in, trap, PSR_Enable, Clr, Clk);
	
	// Trap Base Register
	tbr TBR (TBR_Out, TBA, tt, enable, Clr, Clk);
	
	/* Muxes */
	
	// Mux for the input of MDR (Memory out or ALU out)
	mux_2x1 MDR_Mux(MDR_Mux_out, MDR_Mux_select, ALU_out, RAM_Out);
	
	// Mux for selecting second operand for ALU
	mux4x1 ALUB_Mux(ALUB_Mux_out, ALUB_Mux_select, PB_out, extender_out, MDR_Out, 32'h00000000);

endmodule