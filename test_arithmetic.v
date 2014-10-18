module test_Arithmetic;

	// Inputs
	wire [4:0]in_PC, in_PA, in_PB;
	
	wire [5:0]RAM_OpCode, ALU_op;
	
	wire MDR_Mux_select;
	wire [1:0]extender_select, ALUB_Mux_select;
	
	wire NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable;
	reg Clr = 0;
	reg Clk = 0;

	// Outputs
	wire signed [31:0] IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUB_Mux_out, PSR_out;
	wire MFC;
	
	reg [31:0]IR_In;
	reg IR_Enable;
	
	parameter sim_time = 2580;
	reg [4:0]dest = 1;

	DataPath DataPath(IR_Enable, IR_In, IR_Out, ALU_op, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, 
	extender_select, extender_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, RAM_OpCode, MFC, PSR_out, NPC_enable, PC_enable, MDR_Enable, MAR_Enable,
	RAM_enable, PSR_Enable, Clk, Clr);
	
	ControlUnit ControlUnit(NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, extender_select, ALUB_Mux_select,
		MDR_Mux_select, in_PC, in_PA, in_PB, ALU_op, RAM_OpCode, IR_Out, MFC);
		
	initial begin
		repeat (2570)
		begin
			$display(" IR_out = %x, ALU_Out = %d, sign extender = %d \n in_PA = %d, in_PB = %d, in_PC = %d, ALU_Mux_Out = %d\n out_PA = %d, out_PB = %d\n PSR_out = %b", IR_Out, ALU_Out, extender_out, in_PA, in_PB, in_PC, ALUB_Mux_out, out_PA, out_PB, PSR_out);
			#5 Clk = ~Clk; // Emulate clock
		end
	end
	
	initial begin
		repeat(31)
		begin
			IR_In = {2'b10,dest,25'b0100000000110000000000100};
			IR_Enable = 1;
			#5;
			dest = dest + 1;
		end
		IR_In = 32'b10000010100000001010000000000100;
		#5;
	end
	
	// End simulation at sim_time
	initial #sim_time $finish;
endmodule
