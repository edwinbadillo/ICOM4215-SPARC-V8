module test_pc;

	/* Inputs */
	wire [4:0]in_PC, in_PA, in_PB;
	
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
	wire PC_enable, NPC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TEMP_Enable, TBR_enable;
	
	// Clears
	wire PC_Clr, NPC_Clr, PSR_Clr, TEMP_Clr, MDR_Clr, MAR_Clr, TBR_Clr;

	/* Outputs */
	wire signed [31:0]IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUB_Mux_out, PSR_out, ALUA_Mux_out;
	wire MFC, MSET, BA_O, BN_O, cond, out_BLA;
	
	// Local variables
	reg [31:0]IR_In;
	reg IR_Enable;
	reg Clk = 0;
	
	parameter sim_time = 200;

	reg RESET = 0;


	DataPath DataPath(IR_Enable, IR_In, IR_Out, PC_enable, PC_Clr, NPC_enable, NPC_Clr, PSR_Enable, PSR_Clr, S, PS, ET, PSR_out, TEMP_Enable, TEMP_Clr, MDR_Enable, MDR_Clr,
		MAR_Enable, MAR_Clr, TBR_enable, TBR_Clr, tt, ALU_op, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, extender_select, extender_out, 
		ALUA_Mux_select, ALUA_Mux_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, PC_In_Mux_select, TBR_Mux_select, PSR_Mux_select, RAM_OpCode, RAM_enable, MFC, MSET, out_BLA, BA_O, BN_O, Clk);
	
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

		/* Init PC and nPC */
		
		// Select input of pc from ALU
		ControlUnit.PC_In_Mux_select = 2'b01;
		#10;
		// Enable PC
		ControlUnit.PC_enable = 1;
		#10;
		// Disable PC and pass output of PC to ALUA and 4 through ALUB
		ControlUnit.PC_enable = 0;
		ControlUnit.ALUA_Mux_select = 2'b01;
		ControlUnit.ALUB_Mux_select = 3'b110;
		ControlUnit.ALU_op = 6'b000000;
		ControlUnit.NPC_enable = 1;
		#10;
		ControlUnit.NPC_enable = 0;
		#10;
		
		IR_Enable = 0;
		IR_In     = 32'b10_00001_000000_00000_1_0000000000011; // mov %r1, #3   ---> add %r1, %r0, #3
		// IR value to be loaded is ready
		IR_Enable = 1;
		#10; // Instruction loaded in IR
		IR_Enable = 0;
		#10;
		
		/* jmpl instruction */
		
		IR_Enable = 1;
		IR_In     = 32'b10_00001_111000_00000_1_0000000001111; // jmpl %r0, 15, r1
		
		// IR_Enable = 1;
		// IR_In     = 32'b10_00010_111000_00001_0_0000000000001; // jmpl %r1, r1, r2
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
		$display("ALUA_Mux_select: %d\tALUB_Mux_select: %d", ALUA_Mux_select, ALUB_Mux_select);
		$display("ALUA_Mux_out: %d\tALUB_Mux_out: %d", ALUA_Mux_out, ALUB_Mux_out);
		$display("out_PA: %d\tout_PB: %d", out_PA, out_PB);
		$display("PSR_out: %b", PSR_out);
		$display("R1 = %d", DataPath.register_file.r_out[1]);
		$display("PC = %d", DataPath.PC.out);
		$display("nPC = %d", DataPath.NPC.out);
		$display("RF_enable: %d", register_file_enable);
		$display("PC in = %d", DataPath.PC_In_Mux.Y);
		$display("--------------------------------------------------------------------------\n");
	end
	endtask

endmodule