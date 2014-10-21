module test_memory_path;

	// Inputs
	wire [4:0]in_PC, in_PA, in_PB;
	
	wire [5:0]RAM_OpCode, ALU_op;
	
	wire MDR_Mux_select;
	wire [1:0]extender_select;
	
	wire [2:0]ALUB_Mux_select;	
	wire NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, PSR_Enable, RAM_enable;
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
			$display(" IR_out = %b \n ALU_Out = %d, sign extender = %d \n in_PA = %d, in_PB = %d, in_PC = %d, ALU_Mux_Out = %d\n out_PA = %d, out_PB = %d\n PSR_out = %b, MDR_Mux_select = %d, MDR_Out = %b \n MAR_Out = %b, RAM_Out = %b \n Ram address 11 = %d \n ---------------------------------------\n", IR_Out, ALU_Out, extender_out, in_PA, in_PB, in_PC, ALUB_Mux_out, out_PA, out_PB, PSR_out, MDR_Mux_select, DataPath.MDR.out, DataPath.MAR.out, DataPath.ram.MDR_DataOut, DataPath.ram.Mem[11]);
			#5 Clk = ~Clk; // Emulate clock
		end
	end
	
	initial begin//155ns
		repeat(31)
		begin
			IR_In = {2'b10,dest,25'b0100000000110000000000100};
			IR_Enable = 1;
			#5;
			dest = dest + 1;
		end
		dest = 6;
		IR_In = {2'b10,dest,25'b010000000001000000000001};
		IR_Enable = 1;
		#5;
		DataPath.ram.Mem[8] = 8'hFF;
		DataPath.ram.Mem[9] = 8'hFF;
		DataPath.ram.Mem[10] = 8'hFF;
		DataPath.ram.Mem[11] = 8'hFF;
		$display(" MY ISNTRUCTION~~~~~~~~~~~~~~~~~~~~~`");
		//IR_In = 32'b11_00110_000000_00100_0_xxxxxxxx_00101; //Load Word
		  IR_In = 32'b11_00110_000100_00100_0_xxxxxxxx_00101; //Store Word
		#5;
		IR_Enable = 0;
		#15;
		
		
	end
	
	// End simulation at sim_time
	initial #sim_time $finish;
endmodule
