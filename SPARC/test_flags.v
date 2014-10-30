module test_flags;
	
	/* Inputs */
	wire [4:0]in_PC, in_PA, in_PB;
	
	wire [5:0]RAM_OpCode, ALU_op;
	wire [2:0] tt;
	
	wire MDR_Mux_select;
	wire TBR_Mux_select;
	wire  S, PS, ET;
	wire [2:0]extender_select;
	wire [1:0]PC_In_Mux_select;
	wire [1:0]ALUA_Mux_select;
	wire [2:0]ALUB_Mux_select;
	wire [1:0]PSR_Mux_select;
	wire cond, BA_O, BN_O;
	
	// Enables
	wire PC_enable, NPC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TEMP_Enable, TBR_enable;
	
	// Clears
	wire PC_Clr, NPC_Clr, PSR_Clr, TEMP_Clr, MDR_Clr, MAR_Clr, TBR_Clr;

	/* Outputs */
	wire signed [31:0]IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUB_Mux_out, PSR_out, ALUA_Mux_out;
	wire MFC, MSET;
	
	// Local variables
	reg [31:0]IR_In;
	reg IR_Enable;
	reg register_file_Clr = 0;
	reg Clk = 0;
	
	parameter sim_time = 170;

	reg RESET = 0;


	DataPath DataPath(IR_Enable, IR_In, IR_Out, PC_enable, PC_Clr, NPC_enable, NPC_Clr, PSR_Enable, PSR_Clr, S, PS, ET, PSR_out, TEMP_Enable, TEMP_Clr, MDR_Enable, MDR_Clr,
		MAR_Enable, MAR_Clr, TBR_enable, TBR_Clr, tt, ALU_op, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, extender_select, extender_out, 
		ALUA_Mux_select, ALUA_Mux_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, PC_In_Mux_select, TBR_Mux_select, PSR_Mux_select, RAM_OpCode, RAM_enable, MFC, MSET, Clk);
	
	ControlUnit ControlUnit(NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TBR_enable, extender_select, PC_In_Mux_select, ALUA_Mux_select, PSR_Mux_select, ALUB_Mux_select,
		MDR_Mux_select, TBR_Mux_select, in_PC, in_PA, in_PB, ALU_op, RAM_OpCode, tt, TBR_Clr, PSR_Clr, S, PS, ET, IR_Out, MFC, MSET, cond, BA_O, BN_O, RESET, Clk);
		
	/* Make a regular pulsing clock. */
	// reg clk = 0;
	always begin 
		#5 Clk = !Clk;
		printValues();
	end

	initial begin
		// Magicks to emulate the two cycles within the arithmetic/logic instruction execution state
		// When CU has states, the magicks is simply another state.
		printValues();

		ControlUnit.PSR_Clr = 0;
		#10;
		ControlUnit.PSR_Clr = 1;
		#10;
		ControlUnit.PSR_Clr = 0;
		
		IR_Enable = 0;
		IR_In     = 32'b10_00001_010000_00000_1_0000000000000; // mov %r1, #0   ---> add %r1, %r0, #0
		// IR value to be loaded is ready
		IR_Enable = 1;
		#10; // Instruction loaded in IR
		IR_Enable = 0;
		IR_In     = 32'b10_00010_000000_00000_1_0000000000110; // mov %r2, #6   ---> add %r2, %r0, #6
		#10;
		IR_Enable = 1;
		#10; // Instruction loaded in IR
		IR_Enable = 0;
		IR_In     = 32'b10_00001_010000_00000_1_1111111111111; // mov %r1, #0   ---> add %r1, %r0, #0
		#10;
		IR_Enable = 1;
		#10; // Instruction loaded in IR
		IR_Enable = 0;
		IR_In     = 32'b10_00010_000000_00000_1_0000000000001; // mov %r2, #1   ---> add %r2, %r0, #1
		#10;
		IR_Enable = 1;
		#10; // Instruction loaded in IR
		IR_Enable = 0;
		IR_In     = 32'b10_00010_010000_00001_0_00000000_00010; // add %r2, %r1, %r2
		#10;
		IR_Enable = 1;
		#10; // Instruction loaded into IR
	end
	
	// End simulation at sim_time
	initial #sim_time $finish;

	task printValues;
	begin
		$display("Time: %tns", $time);
		$display("Clock: %d",  Clk);
		$display("IR_Out: %b", IR_Out);
		$display("extender_out: %d", extender_out);
		$display("ALU_Out: %d", ALU_Out);
		$display("ALU_Op: %d", ControlUnit.ALU_op);
		$display("N: %d, Z: %d, V: %d, C: %d", DataPath.alu.N, DataPath.alu.Z, DataPath.alu.V, DataPath.alu.C);
		$display("in_PA: %d\tin_PB: %d\tin_PC: %d", in_PA, in_PB, in_PC);
		$display("ALUA_Mux_select: %d\tALUB_Mux_select: %d", ALUA_Mux_select, ALUB_Mux_select);
		$display("ALUA_Mux_out: %d\tALUB_Mux_out: %d", ALUA_Mux_out, ALUB_Mux_out);
		$display("out_PA: %d\tout_PB: %d", out_PA, out_PB);
		$display("PSR_Mux_Out: %b", DataPath.PSR_Mux_out);
		$display("PSR_out: %b", PSR_out);
		$display("R1 = %d", DataPath.register_file.r_out[1]);
		$display("R2 = %d", DataPath.register_file.r_out[2]);
		$display("RF_enable: %d", register_file_enable);
		$display("--------------------------------------------------------------------------\n");
	end
	endtask

endmodule