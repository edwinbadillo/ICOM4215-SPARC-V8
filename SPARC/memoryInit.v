module memoryInit;

	// Inputs
	reg [4:0]in_PC, in_PA, in_PB;
	
	reg [5:0]RAM_OpCode;
	
	reg MDR_Mux_select;
	reg [1:0]extender_select, ALUB_Mux_select;
	
	reg NPC_enable, PC_enable, IR_Enable, MDR_Enable, MAR_Enable, register_file_enable, RAM_enable, PSR_Enable;
	reg Clr = 0;
	reg Clk = 0;
	
	reg [31:0]IR_In, register_file_in;

	// Outputs
	wire signed [31:0] IR_Out, ALU_Out, extender_out, out_PA, out_PB, ALUB_Mux_out;
	wire MFC;
	
	parameter sim_time = 2580;

	integer fd, positionInMem, data, i, j;
	
	DataPath DataPath( IR_Enable, IR_In, IR_Out, ALU_Out, register_file_enable, in_PA, in_PB, in_PC, out_PA, out_PB, 
	extender_select, extender_out, ALUB_Mux_select, ALUB_Mux_out, MDR_Mux_select, RAM_OpCode, MFC, NPC_enable, PC_enable, MDR_Enable, MAR_Enable,
	RAM_enable, PSR_Enable, Clk, Clr);
	
	initial begin
		repeat (2570)
		begin
			#5 Clk = ~Clk; // Emulate clock
		end
	end
	
	initial begin
		fd = $fopen("code.txt","r"); 
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
		positionInMem = 0;
		for (j = 0; j < i; j = j +1) begin
			$display ("Instruction %d : %b", j,{DataPath.ram.Mem[positionInMem],DataPath.ram.Mem[positionInMem+1],DataPath.ram.Mem[positionInMem+2],DataPath.ram.Mem[positionInMem+3]});
			positionInMem = positionInMem + 4;
    	end
	end
	
	// End simulation at sim_time
	initial #sim_time $finish;
endmodule
