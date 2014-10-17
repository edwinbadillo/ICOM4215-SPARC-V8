module test_Arithmetic;

	// Inputs
	reg [4:0]in_PC, in_PA, in_PB;
	
	reg [5:0]RAM_OpCode;
	
	reg MDR_Mux_select;
	reg [1:0]extender_select, ALUB_Mux_select;
	
	reg NPC_enable, PC_enable, IR_Enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable;
	reg Clr = 0;
	reg Clk = 0;
	
	reg [31:0]IR_In, register_file_in;

	// Outputs
	wire signed [31:0] IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUB_Mux_out;
	wire MFC;
	
	parameter sim_time = 2580;

	DataPath DataPath( IR_Enable, IR_In, IR_Out, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, 
	extender_select, extender_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, RAM_OpCode, MFC, NPC_enable, PC_enable, MDR_Enable, MAR_Enable,
	RAM_enable, PSR_Enable, Clk, Clr);
	
	initial begin
		$monitor(" IR_out = %x, ALU_Out = %d, sign extender = %d \n in_PA = %d, in_PB = %d, in_PC = %d, ALU_Mux_Out = %d\n out_PA = %d, out_PB = %d", IR_Out, ALU_Out, extender_out, in_PA, in_PB, in_PC, ALUB_Mux_out, out_PA, out_PB);
		repeat (2570)
		begin
			#5 Clk = ~Clk; // Emulate clock
		end
	end
	
	initial begin
		// Initialize register port inputs
		in_PC = 1;
		in_PA = 1;
		in_PB = 2;
		// Clearing Register
		repeat(31)
		begin
			Clr = 1;
			#5;
			Clr = 0;
			in_PC = in_PC + 1;
			in_PA = in_PA + 1;
			in_PB = in_PB + 1;
		end
		// Performing instruction add r[1] = r[4] + simm13 = 0 + 4
		IR_Enable = 1;
		IR_In = 32'b10_00001_000000_00100_1_0000000000100;
		// Selecting mux outputs
		extender_select = 2'b00;
		ALUB_Mux_select = 2'b01;
		#5;
		in_PC = 1;
		register_file_enable = 1;
		#5;
		in_PA = 1;
		register_file_enable = 0;
		#5;
		// Performing instruction add r[1] = r[1] + r[1] = 8
		// IR_Enable = 1;
		// IR_In = 32'b10_00001_000000_00001_0_00000000_00001;
		// Selecting mux outputs
		// extender_select = 2'b00;
		// ALUB_Mux_select = 2'b00;
		// in_PC = 1;
		// register_file_enable = 1;
		// in_PA = 1;
		// #5;
	end
	
	// End simulation at sim_time
	initial #sim_time $finish;
endmodule
