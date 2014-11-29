module test_showTime;

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
	
	parameter sim_time = 20000;
	
	integer fd, positionInMem, data, i, j, counter = 0;

	reg RESET = 0;
	
	integer fp;

	DataPath2 DataPath(IR_enable, IR_In, IR_Out, PC_enable, PC_Clr, NPC_enable, NPC_Clr, PSR_Enable, PSR_Clr, S, PS, ET, PSR_out, TEMP_Enable, TEMP_Clr, MDR_Enable, MDR_Clr,
		MAR_Enable, MAR_Clr, TBR_enable, TBR_Clr, WIM_enable, WIM_Clr, ALU_op, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, extender_select, extender_out, 
		ALUA_Mux_select, ALUA_Mux_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, PC_In_Mux_select, TBR_Mux_select, PSR_Mux_select, RAM_OpCode, RAM_enable, MFC, MSET, out_BLA, BA_O, BN_O, Clk);
	
	ControlUnit2 ControlUnit(IR_enable, NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable, TBR_enable, PC_Clr, extender_select, PC_In_Mux_select, ALUA_Mux_select, PSR_Mux_select, ALUB_Mux_select,
		MDR_Mux_select, TBR_Mux_select, in_PC, in_PA, in_PB, ALU_op, RAM_OpCode, TBR_Clr, PSR_Clr, S, PS, ET,WIM_enable, WIM_Clr, IR_Out, MFC, MSET, out_BLA, BA_O, BN_O, RESET, Clk);
	
	always begin
		#1 Clk = !Clk;
		// printValues();
	end
	
	initial begin
		fp=$fopen("result_showtime.txt","w");
	end
	
	always @ (DataPath.MAR_Out, DataPath.ram.Mem[DataPath.MAR_Out])
	begin
		$fwrite(fp,"Count = %d, Mar_Out = %d \nMem[%0d] = %d\nMem[%0d] = %d\nMem[%0d] = %d\nMem[%0d] = %d\n", counter, DataPath.MAR_Out,DataPath.MAR_Out, DataPath.ram.Mem[DataPath.MAR_Out],DataPath.MAR_Out+1, DataPath.ram.Mem[DataPath.MAR_Out+1], DataPath.MAR_Out+2,DataPath.ram.Mem[DataPath.MAR_Out+2], DataPath.MAR_Out +3,DataPath.ram.Mem[DataPath.MAR_Out+3]);
		$fwrite(fp,"r1: %d\nr2: %d\nr3: %d\nr5: %d\n", DataPath.register_file.r_out[1], DataPath.register_file.r_out[2],DataPath.register_file.r_out[3],DataPath.register_file.r_out[5]);
		$fwrite(fp,"PSR = %b\n----------------------\n", PSR_out);
		counter = counter +1;
		if(IR_Out == 32'b00010000100000000000000000000000)
		begin
			$fwrite(fp,"Last Branch Always Reached!\n");
			$display("r1: %d", DataPath.register_file.r_out[1]);
			$display("r2: %d", DataPath.register_file.r_out[2]);
			$display("r3: %d", DataPath.register_file.r_out[3]);
			$display("r5: %d", DataPath.register_file.r_out[5]);
			for(i = 0; i<52; i=i+1)
			begin
				if(i%4==0)
					$fwrite(fp,"-------------------\n");
				$fwrite(fp,"DataPath.ram.Mem[%0d]= %0d;\n",i,DataPath.ram.Mem[i]);
			end
			$finish;
		end
	end
	
	
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

endmodule
