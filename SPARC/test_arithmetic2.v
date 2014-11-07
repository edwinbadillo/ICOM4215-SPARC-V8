module test_arithmetic2;

	/* Inputs */
	wire [4:0]in_PC, in_PA, in_PB;
	wire [31:0]IR_In;
	
	wire [5:0]RAM_OpCode, ALU_op;
	wire [2:0] tt;
	
	wire MDR_Mux_select;
	wire TBR_Mux_select;
	wire [2:0]extender_select;
	wire [1:0]PC_In_Mux_select;
	wire [1:0]ALUA_Mux_select;
	wire [2:0]ALUB_Mux_select;
	wire [1:0]PSR_Mux_select;
	
	// Enables
	wire IR_enable, PC_enable, NPC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TEMP_Enable, TBR_enable;
	
	// Clears
	wire PC_Clr, NPC_Clr, PSR_Clr, TEMP_Clr, MDR_Clr, MAR_Clr, TBR_Clr;

	/* Outputs */
	wire signed [31:0]IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUB_Mux_out, PSR_out, ALUA_Mux_out;
	wire MFC, MSET, BA_O, BN_O, cond, out_BLA;
	
	reg Clk = 0;
	
	parameter sim_time = 500;

	reg RESET = 0;

	DataPath2 DataPath(IR_enable, IR_In, IR_Out, PC_enable, PC_Clr, NPC_enable, NPC_Clr, PSR_Enable, PSR_Clr, S, PS, ET, PSR_out, TEMP_Enable, TEMP_Clr, MDR_Enable, MDR_Clr,
		MAR_Enable, MAR_Clr, TBR_enable, TBR_Clr, tt, ALU_op, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, extender_select, extender_out, 
		ALUA_Mux_select, ALUA_Mux_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, PC_In_Mux_select, TBR_Mux_select, PSR_Mux_select, RAM_OpCode, RAM_enable, MFC, MSET, out_BLA, BA_O, BN_O, Clk);
	
	ControlUnit2 ControlUnit(IR_enable, NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TBR_enable, PC_Clr, extender_select, PC_In_Mux_select, ALUA_Mux_select, PSR_Mux_select, ALUB_Mux_select,
		MDR_Mux_select, TBR_Mux_select, in_PC, in_PA, in_PB, ALU_op, RAM_OpCode, tt, TBR_Clr, PSR_Clr, S, PS, ET, IR_Out, MFC, MSET, out_BLA, BA_O, BN_O, RESET, Clk);
		
	always begin
		#5 Clk = !Clk;
		printValues();
	end
	
	initial begin
		DataPath.ram.Mem[3]= 8'b00000001;
		DataPath.ram.Mem[2]= 8'b00100000;
		DataPath.ram.Mem[1]= 8'b00000000;
		DataPath.ram.Mem[0]= 8'b10000010;
		
		DataPath.ram.Mem[7]= 8'b00000111;
		DataPath.ram.Mem[6]= 8'b01100000;
		DataPath.ram.Mem[5]= 8'b00000000;
		DataPath.ram.Mem[4]= 8'b10000010;
		RESET = 1;
		#10;
		RESET = 0;
		#10;
	end
	
	// End simulation at sim_time
	initial #sim_time $finish;

	task printValues;
	begin
		$display("Time: %tns", $time);
		$display("State %b \t nextState %b", ControlUnit.state, ControlUnit.nextState);
		$display("Clock: %d", Clk);
		$display("Reset: %d", RESET);
		$display("IR_Out: %b", IR_Out);
		$display("In_PA: %d\t In_PB: %d ]t in_PC", in_PA, ControlUnit.in_PB, in_PC);
		$display("out_PA: %d\t out_PB: %d", DataPath.out_PA, DataPath.out_PB);
		$display("ALUA_Mux_select: %d\tALUB_Mux_select: %d", ALUA_Mux_select, ALUB_Mux_select);
		$display("ALUA_Mux_out: %d\tALUB_Mux_out: %d", ALUA_Mux_out, ALUB_Mux_out);
		$display("ALU_Out: %d", ALU_Out);
		$display("r1: %d", DataPath.register_file.r_out[1]);
		$display("PC_out:  %b", DataPath.PC.out);
		$display("NPC_out: %b", DataPath.NPC.out);
		$display("MAR_Out: %d \t RAM_OpCode = %b", DataPath.MAR_Out, RAM_OpCode);
		$display("MAR_Enable: %d \t RAM_enable = %b", MAR_Enable, RAM_enable);
		$display("IR_Enable: %d \t RAM_Out = %b", IR_enable, DataPath.RAM_Out);
		$display("--------------------------------------------------------------------------\n");
	end
	endtask

endmodule
