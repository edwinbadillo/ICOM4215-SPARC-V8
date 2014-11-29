module test_showTime2;

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
	wire IR_enable, PC_enable, NPC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TEMP_Enable, TBR_enable, WIM_enable;
	
	// Clears
	wire PC_Clr, NPC_Clr, PSR_Clr, TEMP_Clr, MDR_Clr, MAR_Clr, TBR_Clr, WIM_Clr;

	/* Outputs */
	wire [31:0]IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUB_Mux_out, PSR_out, ALUA_Mux_out;
	wire MFC, MSET, BA_O, BN_O, cond, out_BLA;
	
	reg Clk = 0;
	
	parameter sim_time = 200000;
	
	integer fd, positionInMem, data, i, j, counter = 0,fp;

	reg RESET = 0;

	DataPath2 DataPath(IR_enable, IR_In, IR_Out, PC_enable, PC_Clr, NPC_enable, NPC_Clr, PSR_Enable, PSR_Clr, S, PS, ET, PSR_out, TEMP_Enable, TEMP_Clr, MDR_Enable, MDR_Clr,
		MAR_Enable, MAR_Clr, TBR_enable, TBR_Clr, WIM_enable, WIM_Clr, ALU_op, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, extender_select, extender_out, 
		ALUA_Mux_select, ALUA_Mux_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, PC_In_Mux_select, TBR_Mux_select, PSR_Mux_select, RAM_OpCode, RAM_enable, MFC, MSET, out_BLA, BA_O, BN_O, Clk);
	
	ControlUnit2 ControlUnit(IR_enable, NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TBR_enable, PC_Clr, extender_select, PC_In_Mux_select, ALUA_Mux_select, PSR_Mux_select, ALUB_Mux_select,
		MDR_Mux_select, TBR_Mux_select, in_PC, in_PA, in_PB, ALU_op, RAM_OpCode, TBR_Clr, PSR_Clr, S, PS, ET,WIM_enable, WIM_Clr, IR_Out, MFC, MSET, out_BLA, BA_O, BN_O, RESET, Clk);
		
	always begin
		#1 Clk = !Clk;
	end
	
	initial begin
		fp=$fopen("result_showtime2.txt","w");
	end
	
	always @ (DataPath.MAR_Out, DataPath.ram.Mem[DataPath.MAR_Out])
	begin
		$fwrite(fp,"Count = %d, Mar_Out = %d, IR_out = %b \nMem[%0d] = %d\nMem[%0d] = %d\nMem[%0d] = %d\nMem[%0d] = %d\n", counter, DataPath.MAR_Out, IR_Out,DataPath.MAR_Out, DataPath.ram.Mem[DataPath.MAR_Out],DataPath.MAR_Out+1, DataPath.ram.Mem[DataPath.MAR_Out+1], DataPath.MAR_Out+2,DataPath.ram.Mem[DataPath.MAR_Out+2], DataPath.MAR_Out +3,DataPath.ram.Mem[DataPath.MAR_Out+3]);
		// $fwrite(fp,"r1: %d\nr2: %d\nr3: %d\nr4: %d\nr5: %d\nr8: %d\nr10: %d\nr11: %d\nr12: %d\nr15: %d\n", DataPath.register_file.r_out[1], DataPath.register_file.r_out[2],DataPath.register_file.r_out[3],DataPath.register_file.r_out[4], DataPath.register_file.r_out[5],DataPath.register_file.r_out[8],DataPath.register_file.r_out[10],DataPath.register_file.r_out[11],DataPath.register_file.r_out[12],DataPath.register_file.r_out[15]);
		for(i = 224; i<264; i=i+4)
			begin
				$fwrite(fp,"DataPath.ram.Mem[%0d]= %b %b %b %b\n",i,DataPath.ram.Mem[i],DataPath.ram.Mem[i+1],DataPath.ram.Mem[i+2],DataPath.ram.Mem[i+3]);
			end
		$fwrite(fp,"PSR = %b\n---------------------\n", PSR_out);
		counter = counter +1;
		if(IR_Out == 32'b00010000100000000000000000000000)
		begin
			$fwrite(fp,"Last Branch Always Reached!\n");
			// $display("r1: %d", DataPath.register_file.r_out[1]);
			// $display("r2: %d", DataPath.register_file.r_out[2]);
			// $display("r3: %d", DataPath.register_file.r_out[3]);
			// $display("r4: %d", DataPath.register_file.r_out[4]);
			// $display("r5: %d", DataPath.register_file.r_out[5]);
			// $display("r8: %d", DataPath.register_file.r_out[8]);
			// $display("r10: %d", DataPath.register_file.r_out[10]);
			// $display("r11: %d", DataPath.register_file.r_out[11]);
			// $display("r12: %d", DataPath.register_file.r_out[12]);
			// $display("r15: %d", DataPath.register_file.r_out[15]);
			for(i = 224; i<264; i=i+4)
			begin
				$fwrite(fp,"-------------------\n");
				$fwrite(fp,"DataPath.ram.Mem[%0d]= %b %b %b %b\n",i,DataPath.ram.Mem[i],DataPath.ram.Mem[i+1],DataPath.ram.Mem[i+2],DataPath.ram.Mem[i+3]);
			end
			$finish;
		end
	end
	
	
	initial begin
		fd = $fopen("testcode_sparc2.txt","r"); 
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
