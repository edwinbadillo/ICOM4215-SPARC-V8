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
		
	always begin
		#5 Clk = !Clk;
		printValues();
	end
	
	initial begin //155ns
		// repeat(31)
		// begin
		// 	IR_In = {2'b10,dest,25'b0100000000110000000000100}; // Adding a 4 with 0 and storing the result in dest reg
		// 	IR_Enable = 1;
		// 	#5;
		// 	dest = dest + 1;
		// end
		// IR_Enable = 1;
		// #5;
		// DataPath.ram.Mem[8]  = 8'hFF;
		// DataPath.ram.Mem[9]  = 8'hFF;
		// DataPath.ram.Mem[10] = 8'hFF;
		// DataPath.ram.Mem[11] = 8'hFF;
		// $display(" MY INSTRUCTION~~~~~~~~~~~~~~~~~~~~~`");
		// //IR_In = 32'b11_00110_000000_00100_0_xxxxxxxx_00101; //Load Word
		// IR_In = 32'b11_00110_000100_00100_0_xxxxxxxx_00101; //Store Word from r6 into memory location r4 + r5
		// #5;
		// IR_Enable = 0;
		// #15;

		printValues();
		
		IR_Enable = 1;
		IR_In     = 32'b10_00001_000000_00000_1_0000000000011; // mov %r1, #3   ---> add %r1, %r0, #3
		#10;
		ControlUnit.register_file = 0;
		#10;
		IR_Enable = 1;
		IR_In     = 32'b10_00010_000000_00000_1_0000000000110; // mov %r2, #6   ---> add %r2, %r0, #6
		#10;
		ControlUnit.register_file = 0;
		#10;
		IR_Enable = 1;
		IR_In     = 32'b10_00010_000000_00001_0_xxxxxxxx_00010; // add %r2, %r1, %r2
		#10;
		ControlUnit.register_file = 0;



	end
	
	// End simulation at sim_time
	initial #sim_time $finish;

	task printValues;
	begin
		$display("Time: %tns", $time);
		$display("Clock: %d", Clk);
		$display("IR_Out: %b", IR_Out);
		$display("extender_out: %d", extender_out);
		$display("ALU_Out: %d", ALU_Out);
		$display("in_PA: %d\tin_PB: %d\tin_PC: %d", in_PA, in_PB, in_PC);
		$display("ALUA_Mux_select: %d\tALUB_Mux_select: %d", ALUA_Mux_select, ALUA_Mux_select);
		$display("ALUA_Mux_out: %d\tALUB_Mux_out: %d", ALUA_Mux_out, ALUB_Mux_out);
		$display("out_PA: %d\tout_PB: %d", out_PA, out_PB);
		$display("PSR_out: %b", PSR_out);
		$display("R1 = %d", DataPath.register_file.r_out[1]);
		$display("R2 = %d", DataPath.register_file.r_out[2]);
		$display("RF_enable: %d", register_file_enable);
		$display("RAM[30]: %h", DataPath.ram.Mem[30]);
		$display("RAM[31]: %h", DataPath.ram.Mem[31]);
		$display("RAM[32]: %h", DataPath.ram.Mem[32]);
		$display("RAM[33]: %h", DataPath.ram.Mem[33]);
		$display("--------------------------------------------------------------------------\n");
	end
	endtask

endmodule
