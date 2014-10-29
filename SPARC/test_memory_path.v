module test_memory_path;

	// Inputs
	wire [4:0]in_PC, in_PA, in_PB;
	
	wire [5:0]RAM_OpCode, ALU_op;
	
	wire MDR_Mux_select;
	wire [1:0]extender_select;
	wire [1:0]PC_In_Mux_select;
	wire [1:0] ALUA_Mux_select;
	wire [2:0] ALUB_Mux_select;	
	wire NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, PSR_Enable, RAM_enable;
	reg Clr = 0;
	reg Clk = 0;

	// Outputs
	wire signed [31:0] IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUA_Mux_out, ALUB_Mux_out, PSR_out;
	wire MFC;
	
	reg [31:0]IR_In;
	reg IR_Enable;
	
	parameter sim_time = 250;
	reg [4:0]dest = 1;

	reg RESET = 0;

	DataPath DataPath(IR_Enable, IR_In, IR_Out, PC_enable, PC_Clr, NPC_enable, NPC_Clr, PSR_Enable, PSR_Clr, PSR_out, TEMP_Enable, TEMP_Clr, MDR_Enable, MDR_Clr,
		MAR_Enable, MAR_Clr, TBR_enable, TBR_Clr, ALU_op, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, extender_select, extender_out, 
		ALUA_Mux_select, ALUA_Mux_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, PC_In_Mux_select, RAM_OpCode, RAM_enable, MFC, Clk);
	
	ControlUnit ControlUnit(NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, extender_select, ALUA_Mux_select, ALUB_Mux_select,
		MDR_Mux_select, in_PC, in_PA, in_PB, ALU_op, RAM_OpCode, IR_Out, MFC, RESET, Clk);
		
	initial begin
		repeat (70)
		begin
			$display("Time: %t\n IR_out = %b \n ALU_Out = %d, sign extender = %d \n in_PA = %d, in_PB = %d, in_PC = %d, ALU_Mux_Out = %d\n out_PA = %d, out_PB = %d\n PSR_out = %b, MDR_Mux_select = %d, MDR_Out = %b \n MAR_Out = %b, RAM_Out = %b \n Ram address 08 = %d \n Ram address 09 = %d \n Ram address 10 = %d \n Ram address 11 = %d \n---------------------------------------\n", $time, IR_Out, ALU_Out, extender_out, in_PA, in_PB, in_PC, ALUB_Mux_out, out_PA, out_PB, PSR_out, MDR_Mux_select, DataPath.MDR.out, DataPath.MAR.out, DataPath.ram.MDR_DataOut, DataPath.ram.Mem[8], DataPath.ram.Mem[9], DataPath.ram.Mem[10], DataPath.ram.Mem[11]);
			#5 Clk = ~Clk; // Emulate clock
		end
	end
	
	initial begin//155ns
		repeat(31)
		begin
			IR_In = {2'b10,dest,25'b0100000000110000000000100}; // Adding a 4 with 0 and storing the result in dest reg
			IR_Enable = 1;
			#5;
			dest = dest + 1;
		end
		IR_Enable = 1;
		#5;
		DataPath.ram.Mem[8]  = 8'hFF;
		DataPath.ram.Mem[9]  = 8'hFF;
		DataPath.ram.Mem[10] = 8'hFF;
		DataPath.ram.Mem[11] = 8'hFF;
		$display(" MY INSTRUCTION~~~~~~~~~~~~~~~~~~~~~`");
		//IR_In = 32'b11_00110_000000_00100_0_xxxxxxxx_00101; //Load Word
		IR_In = 32'b11_00110_000100_00100_0_xxxxxxxx_00101; //Store Word from r6 into memory location r4 + r5
		#5;
		IR_Enable = 0;
		#15;
	end
	
	// End simulation at sim_time
	initial #sim_time $finish;
endmodule
