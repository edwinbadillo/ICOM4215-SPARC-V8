module ControlUnit(
	// Enables
	output NPC_enable, PC_enable, IR_Enable, MDR_Enable, MAR_Enable, register_file, RAM_enable, PSR_Enable,
	// Select Lines Muxes
	output [1:0]extender_select, [1:0]ALUB_Mux_select,
	output MDR_Mux_select,
	// Register file input
	output [4:0]in_PC, [4:0]in_PA, [4:0]in_PB,
	// Alu inputs
	output [5:0]ALU_op,
	// Ram input
	output [5:0]RAM_OpCode,
	
	input [31:0]IR_Out,
	input MFC);
	
	always @ (MFC)
	begin
		
		
	end
endmodule