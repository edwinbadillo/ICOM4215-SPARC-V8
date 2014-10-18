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
	
	always @ (IR_Out, MFC)
		if (IR_Out[31:30] === 2'b00 ) begin 
			// do nothing
		end
		else if (IR_Out[31:30] === 2'b01) begin 
			// do nothing
		end
		else if (IR_Out[31:30] === 2'b10) begin 
			// Arithmetic and Logic Instructions Family
			in_PC  = IR_Out[29:25];
			ALU_op = IR_Out[24:19];
			in_PA  = IR_Out[18:14];
			register_file = 1;
			
			if (IR_Out[13]) begin 
				//B is an immediate argument in IR
				ALUB_Mux_select = 2'b01;
				extender_select = 2'b00;
			end
			else begin 
				//B is a register
				ALUB_Mux_select = 2'b00;
				in_PB = IR_Out[4:0];
			end
		end
		else if (IR_Out[31:30] === 2'b10) begin 
			// do nothing
		end
	begin
		
		
	end
endmodule