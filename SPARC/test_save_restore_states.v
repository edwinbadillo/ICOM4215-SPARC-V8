module test_save_restore_states;

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
	wire [3:0]ALUB_Mux_select;
	wire [2:0]PSR_Mux_select;
	
	// Enables
	wire IR_enable, PC_enable, NPC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TEMP_Enable, TBR_enable, WIM_enable, TR_PR_enable;
	
	// Clears
	wire PC_Clr, NPC_Clr, PSR_Clr, TEMP_Clr, MDR_Clr, MAR_Clr, TBR_Clr, WIM_Clr,TR_PR_CLR;

	/* Outputs */
	wire [31:0]IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUB_Mux_out, PSR_out, ALUA_Mux_out, WIM_Out, TR_PR_out;
	wire MFC, MSET, BA_O, BN_O, cond, out_BLA, Overflow, Underflow, T3, T4;
	
	reg Clk = 0;
	
	parameter sim_time = 200000;
	
	integer fd, positionInMem, data, i, j, counter = 0,fp;

	reg RESET = 0, Hardware_Trap = 0;
	
	DataPath2 DataPath(IR_enable, IR_In, IR_Out, PC_enable, PC_Clr, NPC_enable, NPC_Clr, PSR_Enable, PSR_Clr, S, PS, ET, PSR_out, TEMP_Enable, TEMP_Clr, MDR_Enable, MDR_Clr,
		MAR_Enable, MAR_Clr, TBR_enable, TBR_Clr, WIM_enable, WIM_Clr, WIM_Out, TR_PR_enable, TR_PR_Clr, Overflow, Underflow, T3, T4, TR_PR_out, ALU_op, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, extender_select, extender_out, 
		ALUA_Mux_select, ALUA_Mux_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, PC_In_Mux_select, TBR_Mux_select, PSR_Mux_select, RAM_OpCode, RAM_enable, MFC, MSET, out_BLA, BA_O, BN_O, Clk);
	
	ControlUnit2 ControlUnit(IR_enable, NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TBR_enable, TR_PR_enable, WIM_enable, PC_Clr, TR_PR_Clr, TBR_Clr,PSR_Clr, WIM_Clr, extender_select, PC_In_Mux_select, ALUA_Mux_select, PSR_Mux_select, ALUB_Mux_select,
		MDR_Mux_select, TBR_Mux_select, in_PC, in_PA, in_PB, ALU_op, RAM_OpCode, S, PS, ET, Overflow, Underflow, T3, T4, WIM_Out, PSR_out, TR_PR_out, ALU_Out, IR_Out, MFC, MSET, out_BLA, BA_O, BN_O, RESET, Hardware_Trap, Clk);
	
	integer statusI;
	always begin
		#1 Clk = !Clk;
	end
	
	always @(IR_Out) begin
		$display("Time: %tns", $time);
		$display("State %b \t nextState %b", ControlUnit.state, ControlUnit.nextState);
		$display("Clock: %d", Clk);
		$display("Reset: %d", RESET);
		$display("IR_Out: %b", IR_Out);
		$display("PSR_out: %b", PSR_out);
		$display("TBR_out: %b", DataPath.TBR_Out);
		$display("WIM_Out: %b", DataPath.WIM_Out);
		$display("TR_PR_out: %b", DataPath.TR_PR_out);
		$display("BLA_out: %b \t BA_O = %b \t BN_O = %b", DataPath.out_BLA, DataPath.BA_O, DataPath.BN_O);
		$display("In_PA: %d\t In_PB: %d \t in_PC: ", in_PA, ControlUnit.in_PB, in_PC);
		$display("out_PA: %d\t out_PB: %d", DataPath.out_PA, DataPath.out_PB);
		$display("ALUA_Mux_select: %d\tALUB_Mux_select: %d", ALUA_Mux_select, ALUB_Mux_select);
		$display("ALUA_Mux_out: %d\tALUB_Mux_out: %d", ALUA_Mux_out, ALUB_Mux_out);
		$display("ALU_Out: %d", ALU_Out);
		$display("Global");
		$display("r0: %d", DataPath.register_file.r_out[0]);
		$display("r1: %d", DataPath.register_file.r_out[1]);
		$display("r2: %d", DataPath.register_file.r_out[2]);
		$display("r3: %d", DataPath.register_file.r_out[3]);
		$display("r4: %d", DataPath.register_file.r_out[4]);
		$display("r5: %d", DataPath.register_file.r_out[5]);
		$display("r6: %d", DataPath.register_file.r_out[6]);
		$display("r7: %d", DataPath.register_file.r_out[7]);
		$display("Window 3");
		$display("r8: %d",  DataPath.register_file.r_out[8]);
		$display("r9: %d",  DataPath.register_file.r_out[9]);
		$display("r10: %d", DataPath.register_file.r_out[10]);
		$display("r11: %d", DataPath.register_file.r_out[11]);
		$display("r12: %d", DataPath.register_file.r_out[12]);
		$display("r13: %d", DataPath.register_file.r_out[13]);
		$display("r14: %d", DataPath.register_file.r_out[14]);
		$display("r15: %d", DataPath.register_file.r_out[15]);
		$display("r16: %d", DataPath.register_file.r_out[16]);
		$display("r17: %d", DataPath.register_file.r_out[17]);
		$display("r18: %d", DataPath.register_file.r_out[18]);
		$display("r19: %d", DataPath.register_file.r_out[19]);
		$display("r20: %d", DataPath.register_file.r_out[20]);
		$display("r21: %d", DataPath.register_file.r_out[21]);
		$display("r22: %d", DataPath.register_file.r_out[22]);
		$display("r23: %d", DataPath.register_file.r_out[23]);
		$display("Window 2");
		$display("r24: %d", DataPath.register_file.r_out[24]);
		$display("r25: %d", DataPath.register_file.r_out[25]);
		$display("r26: %d", DataPath.register_file.r_out[26]);
		$display("r27: %d", DataPath.register_file.r_out[27]);
		$display("r28: %d", DataPath.register_file.r_out[28]);
		$display("r29: %d", DataPath.register_file.r_out[29]);
		$display("r30: %d", DataPath.register_file.r_out[30]);
		$display("r31: %d", DataPath.register_file.r_out[31]);
		$display("r8: %d",  DataPath.register_file.r_out[32]);
		$display("r9: %d",  DataPath.register_file.r_out[33]);
		$display("r10: %d", DataPath.register_file.r_out[34]);
		$display("r11: %d", DataPath.register_file.r_out[35]);
		$display("r12: %d", DataPath.register_file.r_out[36]);
		$display("r13: %d", DataPath.register_file.r_out[37]);
		$display("r14: %d", DataPath.register_file.r_out[38]);
		$display("r15: %d", DataPath.register_file.r_out[39]);
		$display("Window 1");
		$display("r16: %d", DataPath.register_file.r_out[40]);
		$display("r17: %d", DataPath.register_file.r_out[41]);
		$display("r18: %d", DataPath.register_file.r_out[42]);
		$display("r19: %d", DataPath.register_file.r_out[43]);
		$display("r20: %d", DataPath.register_file.r_out[44]);
		$display("r21: %d", DataPath.register_file.r_out[45]);
		$display("r22: %d", DataPath.register_file.r_out[46]);
		$display("r23: %d", DataPath.register_file.r_out[47]);
		$display("r24: %d", DataPath.register_file.r_out[48]);
		$display("r25: %d", DataPath.register_file.r_out[49]);
		$display("r26: %d", DataPath.register_file.r_out[50]);
		$display("r27: %d", DataPath.register_file.r_out[51]);
		$display("r28: %d", DataPath.register_file.r_out[52]);
		$display("r29: %d", DataPath.register_file.r_out[53]);
		$display("r30: %d", DataPath.register_file.r_out[54]);
		$display("r31: %d", DataPath.register_file.r_out[55]);
		$display("Window 0");
		$display("r8: %d",  DataPath.register_file.r_out[56]);
		$display("r9: %d",  DataPath.register_file.r_out[57]);
		$display("r10: %d", DataPath.register_file.r_out[58]);
		$display("r11: %d", DataPath.register_file.r_out[59]);
		$display("r12: %d", DataPath.register_file.r_out[60]);
		$display("r13: %d", DataPath.register_file.r_out[61]);
		$display("r14: %d", DataPath.register_file.r_out[62]);
		$display("r15: %d", DataPath.register_file.r_out[63]);
		$display("r16: %d", DataPath.register_file.r_out[64]);
		$display("r17: %d", DataPath.register_file.r_out[65]);
		$display("r18: %d", DataPath.register_file.r_out[66]);
		$display("r19: %d", DataPath.register_file.r_out[67]);
		$display("r20: %d", DataPath.register_file.r_out[68]);
		$display("r21: %d", DataPath.register_file.r_out[69]);
		$display("r22: %d", DataPath.register_file.r_out[70]);
		$display("r23: %d", DataPath.register_file.r_out[71]);

		$display("Mem[352]: %d", DataPath.ram.Mem[384]);
		$display("Mem[352]: %d", DataPath.ram.Mem[388]);
		$display("Mem[352]: %d", DataPath.ram.Mem[392]);
		$display("PC_out:  %d", DataPath.PC.out);
		$display("NPC_out: %d", DataPath.NPC.out);
		$display("MAR_Out: %d \t RAM_OpCode = %b", DataPath.MAR_Out, RAM_OpCode);
		$display("--------------------------------------------------------------------------\n");
	end
	
	initial begin
		fd = $fopen("testcode_save_restore.txt","r"); 
		positionInMem = 0;
		i = 0;
		while (!($feof(fd)))
		begin
			statusI = $fscanf(fd, "%b", data);
			DataPath.ram.Mem[positionInMem]     = data[31:24];
			DataPath.ram.Mem[positionInMem + 1] = data[23:16];
			DataPath.ram.Mem[positionInMem + 2] = data[15:8];
			DataPath.ram.Mem[positionInMem + 3] = data[7:0];
			positionInMem = positionInMem + 4;
			i = i + 1;
			$display("data from file = %b", data);
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
