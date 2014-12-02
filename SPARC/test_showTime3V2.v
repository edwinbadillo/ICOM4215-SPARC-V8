module test_showTime3V2;

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
	wire MFC, MSET, BA_O, BN_O, cond, out_BLA, Overflow, Underflow, T3, T4, T5;
	
	reg Clk = 0;
	
	parameter sim_time = 200000;
	
	integer fd, positionInMem, data, i, j = 0, counter = 0,fp;

	reg RESET = 0, Hardware_Trap = 0;
	
	DataPath2 DataPath(IR_enable, IR_In, IR_Out, PC_enable, PC_Clr, NPC_enable, NPC_Clr, PSR_Enable, PSR_Clr, S, PS, ET, PSR_out, TEMP_Enable, TEMP_Clr, MDR_Enable, MDR_Clr,
		MAR_Enable, MAR_Clr, TBR_enable, TBR_Clr, WIM_enable, WIM_Clr, WIM_Out, TR_PR_enable, TR_PR_Clr, Overflow, Underflow, T3, T4, T5, TR_PR_out, ALU_op, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, extender_select, extender_out, 
		ALUA_Mux_select, ALUA_Mux_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, PC_In_Mux_select, TBR_Mux_select, PSR_Mux_select, RAM_OpCode, RAM_enable, MFC, MSET, out_BLA, BA_O, BN_O, Clk);
	
	ControlUnit2 ControlUnit(IR_enable, NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TBR_enable, TR_PR_enable, WIM_enable, PC_Clr, TR_PR_Clr, TBR_Clr,PSR_Clr, WIM_Clr, extender_select, PC_In_Mux_select, ALUA_Mux_select, PSR_Mux_select, ALUB_Mux_select,
		MDR_Mux_select, TBR_Mux_select, in_PC, in_PA, in_PB, ALU_op, RAM_OpCode, S, PS, ET, Overflow, Underflow, T3, T4, T5, WIM_Out, PSR_out, TR_PR_out, ALU_Out, IR_Out, MFC, MSET, out_BLA, BA_O, BN_O, RESET, Hardware_Trap, Clk);
		
	always begin
		#1 Clk = !Clk;
	end
	
	initial begin
		fp=$fopen("result_showtime3.txt","w");
	end
	
	always @(IR_Out) begin
		$fwrite(fp,"------------------------------------------------------------------------------------------------------------------\n");
		$fwrite(fp,"\t\t\t\tTime: %tns\n", $time);
		$fwrite(fp,"\t\t\t\tState %b \t nextState %b\n", ControlUnit.state, ControlUnit.nextState);
		$fwrite(fp,"\t\t\t\tPC_out:  %d\n", DataPath.PC.out);
		$fwrite(fp,"\t\t\t\tNPC_out: %d\n", DataPath.NPC.out);
		$fwrite(fp,"\t\t\t\tIR_Out: %b\n", IR_Out);
		$fwrite(fp,"\t\t\t\tPSR_out: %b\n", PSR_out);
		$fwrite(fp,"\t\t\t\tTBR_out: %b\n", DataPath.TBR_Out);
		$fwrite(fp,"\t\t\t\tWIM_Out: %b\n", DataPath.WIM_Out);
		$fwrite(fp,"\t\t\t\tTR_PR_out: %b\n", DataPath.TR_PR_out);
		$fwrite(fp,"\t\t\t\tGlobal\n");
		$fwrite(fp,"\t\t\t\tr0: %d\n", DataPath.register_file.r_out[0]);
		$fwrite(fp,"\t\t\t\tr1: %d\n", DataPath.register_file.r_out[1]);
		$fwrite(fp,"\t\t\t\tr2: %d\n", DataPath.register_file.r_out[2]);
		$fwrite(fp,"\t\t\t\tr3: %d\n", DataPath.register_file.r_out[3]);
		$fwrite(fp,"\t\t\t\tr4: %d\n", DataPath.register_file.r_out[4]);
		$fwrite(fp,"\t\t\t\tr5: %d\n", DataPath.register_file.r_out[5]);
		$fwrite(fp,"\t\t\t\tr6: %d\n", DataPath.register_file.r_out[6]);
		$fwrite(fp,"\t\t\t\tr7: %d\n", DataPath.register_file.r_out[7]);
		$fwrite(fp,"Window 3 \t\t Window 2 \t\t Window 1 \t\t Window 0\n");
		$fwrite(fp,"r31: %d \t\t r31: %d \t\t r31: %d \t\t r31: %d\n", DataPath.register_file.r_out[71], DataPath.register_file.r_out[55], DataPath.register_file.r_out[39], DataPath.register_file.r_out[23]);
		$fwrite(fp,"r30: %d \t\t r30: %d \t\t r30: %d \t\t r30: %d\n", DataPath.register_file.r_out[70], DataPath.register_file.r_out[54], DataPath.register_file.r_out[38], DataPath.register_file.r_out[22]);
		$fwrite(fp,"r29: %d \t\t r29: %d \t\t r29: %d \t\t r29: %d\n", DataPath.register_file.r_out[69], DataPath.register_file.r_out[53], DataPath.register_file.r_out[37], DataPath.register_file.r_out[21]);
		$fwrite(fp,"r28: %d \t\t r28: %d \t\t r28: %d \t\t r28: %d\n", DataPath.register_file.r_out[68], DataPath.register_file.r_out[52], DataPath.register_file.r_out[36], DataPath.register_file.r_out[20]);
		$fwrite(fp,"r27: %d \t\t r27: %d \t\t r27: %d \t\t r27: %d\n", DataPath.register_file.r_out[67], DataPath.register_file.r_out[51], DataPath.register_file.r_out[35], DataPath.register_file.r_out[19]);
		$fwrite(fp,"r26: %d \t\t r26: %d \t\t r26: %d \t\t r26: %d\n", DataPath.register_file.r_out[66], DataPath.register_file.r_out[50], DataPath.register_file.r_out[34], DataPath.register_file.r_out[18]);
		$fwrite(fp,"r25: %d \t\t r25: %d \t\t r25: %d \t\t r25: %d\n", DataPath.register_file.r_out[65], DataPath.register_file.r_out[49], DataPath.register_file.r_out[33], DataPath.register_file.r_out[17]);
		$fwrite(fp,"r24: %d \t\t r24: %d \t\t r24: %d \t\t r24: %d\n", DataPath.register_file.r_out[64], DataPath.register_file.r_out[48], DataPath.register_file.r_out[32], DataPath.register_file.r_out[16]);
		$fwrite(fp,"r23: %d \t\t r23: %d \t\t r23: %d \t\t r23: %d\n", DataPath.register_file.r_out[63], DataPath.register_file.r_out[47], DataPath.register_file.r_out[31], DataPath.register_file.r_out[15]);
		$fwrite(fp,"r22: %d \t\t r22: %d \t\t r22: %d \t\t r22: %d\n", DataPath.register_file.r_out[62], DataPath.register_file.r_out[46], DataPath.register_file.r_out[30], DataPath.register_file.r_out[14]);
		$fwrite(fp,"r21: %d \t\t r21: %d \t\t r21: %d \t\t r21: %d\n", DataPath.register_file.r_out[61], DataPath.register_file.r_out[45], DataPath.register_file.r_out[29], DataPath.register_file.r_out[13]);
		$fwrite(fp,"r20: %d \t\t r20: %d \t\t r20: %d \t\t r20: %d\n", DataPath.register_file.r_out[60], DataPath.register_file.r_out[44], DataPath.register_file.r_out[28], DataPath.register_file.r_out[12]);
		$fwrite(fp,"r19: %d \t\t r19: %d \t\t r19: %d \t\t r19: %d\n", DataPath.register_file.r_out[59], DataPath.register_file.r_out[43], DataPath.register_file.r_out[27], DataPath.register_file.r_out[11]);
		$fwrite(fp,"r18: %d \t\t r18: %d \t\t r18: %d \t\t r18: %d\n", DataPath.register_file.r_out[58], DataPath.register_file.r_out[42], DataPath.register_file.r_out[26], DataPath.register_file.r_out[10]);
		$fwrite(fp,"r17: %d \t\t r17: %d \t\t r17: %d \t\t r17: %d\n", DataPath.register_file.r_out[57], DataPath.register_file.r_out[41], DataPath.register_file.r_out[25], DataPath.register_file.r_out[9]);
		$fwrite(fp,"r16: %d \t\t r16: %d \t\t r16: %d \t\t r16: %d\n", DataPath.register_file.r_out[56], DataPath.register_file.r_out[40], DataPath.register_file.r_out[24], DataPath.register_file.r_out[8]);
		$fwrite(fp,"r15: %d \t\t r15: %d \t\t r15: %d \t\t r15: %d\n", DataPath.register_file.r_out[55], DataPath.register_file.r_out[39], DataPath.register_file.r_out[23], DataPath.register_file.r_out[71]);
		$fwrite(fp,"r14: %d \t\t r14: %d \t\t r14: %d \t\t r14: %d\n", DataPath.register_file.r_out[54], DataPath.register_file.r_out[38], DataPath.register_file.r_out[22], DataPath.register_file.r_out[70]);
		$fwrite(fp,"r13: %d \t\t r13: %d \t\t r13: %d \t\t r13: %d\n", DataPath.register_file.r_out[53], DataPath.register_file.r_out[37], DataPath.register_file.r_out[21], DataPath.register_file.r_out[69]);
		$fwrite(fp,"r12: %d \t\t r12: %d \t\t r12: %d \t\t r12: %d\n", DataPath.register_file.r_out[52], DataPath.register_file.r_out[36], DataPath.register_file.r_out[20], DataPath.register_file.r_out[68]);
		$fwrite(fp,"r11: %d \t\t r11: %d \t\t r11: %d \t\t r11: %d\n", DataPath.register_file.r_out[51], DataPath.register_file.r_out[35], DataPath.register_file.r_out[19], DataPath.register_file.r_out[67]);
		$fwrite(fp,"r10: %d \t\t r10: %d \t\t r10: %d \t\t r10: %d\n", DataPath.register_file.r_out[50], DataPath.register_file.r_out[34], DataPath.register_file.r_out[18], DataPath.register_file.r_out[66]);
		$fwrite(fp,"r9: %d \t\t\t r9: %d \t\t r9: %d \t\t r9: %d\n", DataPath.register_file.r_out[49], DataPath.register_file.r_out[33], DataPath.register_file.r_out[17], DataPath.register_file.r_out[65]);
		$fwrite(fp,"r8: %d \t\t\t r8: %d \t\t r8: %d \t\t r8: %d\n", DataPath.register_file.r_out[48], DataPath.register_file.r_out[32], DataPath.register_file.r_out[16], DataPath.register_file.r_out[64]);
		$fwrite(fp,"------------------------------------------------------------------------------------------------------------------\n");
		
		if(DataPath.MAR_Out == 68)
		begin
			$fwrite(fp,"Execution Ended!\n");
			for(j = 352; j<440; j=j+4)
			begin
				$fwrite(fp,"DataPath.ram.Mem[%d]= %b %b %b %b\n",j,DataPath.ram.Mem[j],DataPath.ram.Mem[j+1],DataPath.ram.Mem[j+2],DataPath.ram.Mem[j+3]);
			end
			$finish;
		end
	end
	
	initial begin
		fd = $fopen("testcode_sparc3.txt","r"); 
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
			$fwrite(fp,"Mem[%d] = %b\n",positionInMem, data);
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
