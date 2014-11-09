module test_store;

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
	wire [31:0]IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUB_Mux_out, PSR_out, ALUA_Mux_out;
	wire MFC, MSET, BA_O, BN_O, cond, out_BLA;
	
	reg Clk = 0;
	
	parameter sim_time = 20000000;
	
	integer fd, positionInMem, data, i, j;

	reg RESET = 0;
	
	integer fp;

	DataPath2 DataPath(IR_enable, IR_In, IR_Out, PC_enable, PC_Clr, NPC_enable, NPC_Clr, PSR_Enable, PSR_Clr, S, PS, ET, PSR_out, TEMP_Enable, TEMP_Clr, MDR_Enable, MDR_Clr,
		MAR_Enable, MAR_Clr, TBR_enable, TBR_Clr, tt, ALU_op, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, extender_select, extender_out, 
		ALUA_Mux_select, ALUA_Mux_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, PC_In_Mux_select, TBR_Mux_select, PSR_Mux_select, RAM_OpCode, RAM_enable, MFC, MSET, out_BLA, BA_O, BN_O, Clk);
	
	ControlUnit2 ControlUnit(IR_enable, NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TBR_enable, PC_Clr, extender_select, PC_In_Mux_select, ALUA_Mux_select, PSR_Mux_select, ALUB_Mux_select,
		MDR_Mux_select, TBR_Mux_select, in_PC, in_PA, in_PB, ALU_op, RAM_OpCode, tt, TBR_Clr, PSR_Clr, S, PS, ET, IR_Out, MFC, MSET, out_BLA, BA_O, BN_O, RESET, Clk);
		
	always begin
		#1 Clk = !Clk;
		$display("Time: %tns", $time);
		$display("State %b \t nextState %b", ControlUnit.state, ControlUnit.nextState);
		$display("Clock: %d", Clk);
		$display("Reset: %d", RESET);
		$display("IR_Out: %b", IR_Out);
		$display("BLA_out: %b \t BA_O = %b \t BN_O = %b", DataPath.out_BLA, DataPath.BA_O, DataPath.BN_O);
		$display("PSR_out: %b", PSR_out);
		$display("In_PA: %d\t In_PB: %d \t in_PC", in_PA, ControlUnit.in_PB, in_PC);
		$display("out_PA: %d\t out_PB: %d", DataPath.out_PA, DataPath.out_PB);
		$display("ALUA_Mux_select: %d\tALUB_Mux_select: %d", ALUA_Mux_select, ALUB_Mux_select);
		$display("ALUA_Mux_out: %d\tALUB_Mux_out: %d", ALUA_Mux_out, ALUB_Mux_out);
		$display("ALU_Out: %d", ALU_Out);
		$display("r1: %d", DataPath.register_file.r_out[1]);
		$display("r2: %d", DataPath.register_file.r_out[2]);
		$display("r3: %d", DataPath.register_file.r_out[3]);
		$display("r5: %d", DataPath.register_file.r_out[5]);
		$display("Mem 45: %d", DataPath.ram.Mem[45]);
		$display("Mem 47: %d", DataPath.ram.Mem[47]);
		$display("Mem 49: %d", DataPath.ram.Mem[49]);
		$display("PC_out:  %d", DataPath.PC.out);
		$display("NPC_out: %d", DataPath.NPC.out);
		$display("MAR_Out: %d \t RAM_OpCode = %b", DataPath.MAR_Out, RAM_OpCode);
		$display("MAR_Enable: %d \t RAM_enable = %b", MAR_Enable, RAM_enable);
		$display("IR_Enable: %d \t RAM_Out = %b", IR_enable, DataPath.RAM_Out);
		$display("--------------------------------------------------------------------------\n");
	end
	
	/*
	initial begin
		fp=$fopen("result.txt","w");
	end
	
	always @ (DataPath.MAR_Out, DataPath.ram.Mem[DataPath.MAR_Out])
	begin
		//$display("Mar_Out = %d \nMem[%d] = %b\nMem[%d] = %b\nMem[%d] = %b\nMem[%d] = %b", DataPath.MAR_Out,DataPath.MAR_Out, DataPath.ram.Mem[DataPath.MAR_Out],DataPath.MAR_Out+1, DataPath.ram.Mem[DataPath.MAR_Out+1], DataPath.MAR_Out+2,DataPath.ram.Mem[DataPath.MAR_Out+2], DataPath.MAR_Out +3,DataPath.ram.Mem[DataPath.MAR_Out+3]);
		//$fwrite(fp,"Time: %tns, Mar_Out = %d \nMem[%d] = %b\nMem[%d] = %b\nMem[%d] = %b\nMem[%d] = %b\n--------------------------------\n", $time, DataPath.MAR_Out,DataPath.MAR_Out, DataPath.ram.Mem[DataPath.MAR_Out],DataPath.MAR_Out+1, DataPath.ram.Mem[DataPath.MAR_Out+1], DataPath.MAR_Out+2,DataPath.ram.Mem[DataPath.MAR_Out+2], DataPath.MAR_Out +3,DataPath.ram.Mem[DataPath.MAR_Out+3]);
	end
	*/
	
	initial begin
		fd = $fopen("showTime1.txt","r"); 
		positionInMem = 0;
		i = 0;
		while (!($feof(fd)))
		begin
			$fscanf(fd, "%b", data);
			DataPath.ram.Mem[positionInMem]= data[31:24];
			DataPath.ram.Mem[positionInMem + 1]= data[23:16];
			DataPath.ram.Mem[positionInMem + 2]= data[15:8];
			DataPath.ram.Mem[positionInMem + 3]= data[7:0];
			positionInMem = positionInMem + 4;
			i = i + 1;
			$display("data de file = %b", data);
		end
		$fclose(fd);
		RESET = 1;
		#2;
		RESET = 0;
		#2;
	end
	
	// End simulation at sim_time
	initial #sim_time $finish;

	// task printValues;
	// begin
		// $monitor("IR_Out: %0b \t PSR_out: %0b\nIn_PA: %0d, \t In_PB: %0d, \t in_PC %0d\nout_PA: %0d\t out_PB: %0d, ALU_Out: %0d \nPC_out:  %0d, \t NPC_out: %0d \nr1: %0d\t r2: %0d \t r3: %0d \t r5: %0d\n MAR_Out: %0d\n-----------------------------------", IR_Out, PSR_out, in_PA, ControlUnit.in_PB, in_PC, DataPath.out_PA, DataPath.out_PB, ALU_Out, DataPath.PC.out, DataPath.NPC.out, DataPath.register_file.r_out[1],DataPath.register_file.r_out[2],DataPath.register_file.r_out[3],DataPath.register_file.r_out[5], DataPath.MAR_Out);
		// $display("Time: %tns", $time);
		// $display("State %b \t nextState %b", ControlUnit.state, ControlUnit.nextState);
		// $display("Clock: %d", Clk);
		// $display("Reset: %d", RESET);
		// $display("IR_Out: %b", IR_Out);
		// $display("BLA_out: %b \t BA_O = %b \t BN_O = %b", DataPath.out_BLA, DataPath.BA_O, DataPath.BN_O);
		// $display("PSR_out: %b", PSR_out);
		// $display("In_PA: %d\t In_PB: %d \t in_PC", in_PA, ControlUnit.in_PB, in_PC);
		// $display("out_PA: %d\t out_PB: %d", DataPath.out_PA, DataPath.out_PB);
		// $display("ALUA_Mux_select: %d\tALUB_Mux_select: %d", ALUA_Mux_select, ALUB_Mux_select);
		// $display("ALUA_Mux_out: %d\tALUB_Mux_out: %d", ALUA_Mux_out, ALUB_Mux_out);
		// $display("ALU_Out: %d", ALU_Out);
		// $display("r1: %d", DataPath.register_file.r_out[1]);
		// $display("r2: %d", DataPath.register_file.r_out[2]);
		// $display("r3: %d", DataPath.register_file.r_out[3]);
		// $display("r5: %d", DataPath.register_file.r_out[5]);
		// $display("Mem 45: %d", DataPath.ram.Mem[45]);
		// $display("Mem 47: %d", DataPath.ram.Mem[47]);
		// $display("Mem 49: %d", DataPath.ram.Mem[49]);
		// $display("PC_out:  %d", DataPath.PC.out);
		// $display("NPC_out: %d", DataPath.NPC.out);
		// $display("MAR_Out: %d \t RAM_OpCode = %b", DataPath.MAR_Out, RAM_OpCode);
		// $display("MAR_Enable: %d \t RAM_enable = %b", MAR_Enable, RAM_enable);
		// $display("IR_Enable: %d \t RAM_Out = %b", IR_enable, DataPath.RAM_Out);
		// $display("--------------------------------------------------------------------------\n");
	// end
	// endtask

endmodule
