module test_Arithmetic;

	/* Inputs */
	wire [4:0]in_PC, in_PA, in_PB;
	
	wire [5:0]RAM_OpCode, ALU_op;
	
	wire MDR_Mux_select;
	wire [1:0]extender_select;
	wire [1:0]PC_In_Mux_select;
	wire [1:0]ALUA_Mux_select;
	wire [2:0]ALUB_Mux_select;
	
	// Enables
	wire PC_enable, NPC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TEMP_Enable, TBR_enable;
	
	// Clears
	wire PC_Clr, NPC_Clr, PSR_Clr, TEMP_Clr, MDR_Clr, MAR_Clr, TBR_Clr;

	/* Outputs */
	wire signed [31:0]IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUB_Mux_out, PSR_out, ALUA_Mux_out;
	wire MFC;
	
	// Local variables
	reg [31:0]IR_In;
	reg IR_Enable;
	reg Clk = 0;
	reg [4:0]dest = 1;
	reg register_file_Clr =0;
	
	parameter sim_time = 2580;


DataPath DataPath(IR_Enable, IR_In, IR_Out, PC_enable, PC_Clr, NPC_enable, NPC_Clr, PSR_Enable, PSR_Clr, PSR_out, TEMP_Enable, TEMP_Clr, MDR_Enable, MDR_Clr,
	MAR_Enable, MAR_Clr, TBR_enable, TBR_Clr, ALU_op, ALU_Out, register_file_enable, register_file_Clr, in_PA, in_PB, in_PC, out_PA, out_PB, extender_select, extender_out, 
	ALUA_Mux_select, ALUA_Mux_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, PC_In_Mux_select, RAM_OpCode, RAM_enable, MFC, Clk);
	
	ControlUnit ControlUnit(NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, extender_select, ALUB_Mux_select,
		MDR_Mux_select, in_PC, in_PA, in_PB, ALU_op, RAM_OpCode, IR_Out, MFC);
		
		
	initial begin
		repeat (2570)
		begin
			$display(" IR_out = %x, ALU_Out = %d, sign extender = %d \n in_PA = %d, in_PB = %d, in_PC = %d, ALUB_Mux_Out = %d\n out_PA = %d, out_PB = %d\n PSR_out = %b", IR_Out, ALU_Out, extender_out, in_PA, in_PB, in_PC, ALUB_Mux_out, out_PA, out_PB, PSR_out);
			#5 Clk = ~Clk; // Emulate clock
		end
	end
	
	initial begin
		repeat(31)
		begin
			register_file_Clr = ~register_file_Clr;
			#5;
			register_file_Clr = ~register_file_Clr;
			dest = dest + 1;
		end
		#5;
		IR_Enable = 1;
		IR_In = 32'b10000010100000001010000000000100;
		#5;
	end
	
	// End simulation at sim_time
	initial #sim_time $finish;
endmodule