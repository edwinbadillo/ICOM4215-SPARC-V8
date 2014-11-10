module test_showTime2Step;

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
	
	parameter sim_time = 200000;
	
	integer fd, positionInMem, data, i, j, counter = 0,fp;

	reg RESET = 0;

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
		$display("r4: %d", DataPath.register_file.r_out[4]);
		$display("r10: %d", DataPath.register_file.r_out[10]);
		$display("r3: %d", DataPath.register_file.r_out[3]);
		$display("r2: %d", DataPath.register_file.r_out[2]);
		$display("r5: %d", DataPath.register_file.r_out[5]);
		$display("r15: %d", DataPath.register_file.r_out[15]);
		$display("r8: %d", DataPath.register_file.r_out[8]);
		$display("r12: %d", DataPath.register_file.r_out[12]);
		$display("r11: %d", DataPath.register_file.r_out[11]);
		$display("r16: %d", DataPath.register_file.r_out[16]);
		$display("Mem[224]: %d \t Mem[232]: %d \t Mem[248]: %d \t Mem[252]: %d", DataPath.ram.Mem[224], DataPath.ram.Mem[232], DataPath.ram.Mem[248], DataPath.ram.Mem[252]);
		$display("Mem[225]: %d \t Mem[233]: %d \t Mem[249]: %d \t Mem[253]: %d", DataPath.ram.Mem[225], DataPath.ram.Mem[233], DataPath.ram.Mem[249], DataPath.ram.Mem[253]);
		$display("Mem[226]: %d \t Mem[234]: %d \t Mem[250]: %d \t Mem[254]: %d", DataPath.ram.Mem[226], DataPath.ram.Mem[234], DataPath.ram.Mem[250], DataPath.ram.Mem[254]);
		$display("Mem[227]: %d \t Mem[235]: %d \t Mem[251]: %d \t Mem[255]: %d", DataPath.ram.Mem[227], DataPath.ram.Mem[235], DataPath.ram.Mem[251], DataPath.ram.Mem[255]);
		$display("---");
		$display("Mem[228]: %d \t Mem[236]: %d \t Mem[216]: %d \t Mem[256]: %d", DataPath.ram.Mem[228], DataPath.ram.Mem[236], DataPath.ram.Mem[216], DataPath.ram.Mem[256]);
		$display("Mem[229]: %d \t Mem[237]: %d \t Mem[217]: %d \t Mem[257]: %d", DataPath.ram.Mem[229], DataPath.ram.Mem[237], DataPath.ram.Mem[217], DataPath.ram.Mem[257]);
		$display("Mem[230]: %d \t Mem[238]: %d \t Mem[218]: %d \t Mem[258]: %d", DataPath.ram.Mem[230], DataPath.ram.Mem[238], DataPath.ram.Mem[218], DataPath.ram.Mem[258]);
		$display("Mem[231]: %d \t Mem[239]: %d \t Mem[219]: %d \t Mem[259]: %d", DataPath.ram.Mem[231], DataPath.ram.Mem[239], DataPath.ram.Mem[219],DataPath.ram.Mem[259]);
		$display("---");
		$display("Mem[240]: %d \t Mem[244]: %d \t Mem[212]: %d \t Mem[260]: %d", DataPath.ram.Mem[240], DataPath.ram.Mem[244], DataPath.ram.Mem[212], DataPath.ram.Mem[260]);
		$display("Mem[241]: %d \t Mem[245]: %d \t Mem[213]: %d \t Mem[261]: %d", DataPath.ram.Mem[241], DataPath.ram.Mem[245], DataPath.ram.Mem[213], DataPath.ram.Mem[261]);
		$display("Mem[242]: %d \t Mem[246]: %d \t Mem[214]: %d \t Mem[262]: %d", DataPath.ram.Mem[242], DataPath.ram.Mem[246], DataPath.ram.Mem[214], DataPath.ram.Mem[262]);
		$display("Mem[243]: %d \t Mem[247]: %d \t Mem[215]: %d \t Mem[263]: %d", DataPath.ram.Mem[243], DataPath.ram.Mem[247], DataPath.ram.Mem[215], DataPath.ram.Mem[263]);
		$display("---");
		$display("PC_out:  %d", DataPath.PC.out);
		$display("NPC_out: %d", DataPath.NPC.out);
		$display("MAR_Out: %d \t RAM_OpCode = %b", DataPath.MAR_Out, RAM_OpCode);
		$display("MAR_Enable: %d \t RAM_enable = %b", MAR_Enable, RAM_enable);
		$display("IR_Enable: %d \t RAM_Out = %b", IR_enable, DataPath.RAM_Out);
		$display("--------------------------------------------------------------------------\n");
	end
	
	initial begin
		fd = $fopen("showTime2.txt","r"); 
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

endmodule
