module ControlUnit(
	// Enables
	output reg NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file, RAM_enable, PSR_Enable,
	// Select Lines Muxes
	output reg [1:0]extender_select, [1:0]ALUB_Mux_select,
	output reg MDR_Mux_select,
	// Register file input
	output reg [4:0]in_PC, [4:0]in_PA, [4:0]in_PB,
	// Alu inputs
	output reg [5:0]ALU_op,
	// Ram input
	output reg [5:0]RAM_OpCode,
	
	input [31:0]IR_Out,
	input MFC);
	
	always @ (IR_Out, MFC)
		if (IR_Out[31:30] === 2'b00 ) begin 
			// do nothing
		end
		else if (IR_Out[31:30] === 2'b01) begin 
			// do nothing
		end
		else if (IR_Out[31:30] === 2'b10) begin 
			// Arithmetic and Logic Instructions Family
			in_PC  = IR_Out[29:25];
			ALU_op = IR_Out[24:19];
			in_PA  = IR_Out[18:14];
			register_file = 1;
			PSR_Enable = 1;
			if (IR_Out[13]) begin 
				//B is an immediate argument in IR
				ALUB_Mux_select = 2'b01;
				extender_select = 2'b00;
			end
			else begin 
				//B is a register
				ALUB_Mux_select = 2'b00;
				in_PB = IR_Out[4:0];
			end
		end
		else if (IR_Out[31:30] === 2'b11) begin 
			// Load and Store operations
			
			if(IR_Out[24:19] == 6'b000011) begin 			//Load DOUBLE WORD
			IR_Out[24:19] = 6'b000000; //load word op-code
			load(); //TRAP IF NOT EVEN ADDRESS
			register_file = 0;
			IR_Out[29:25] = IR_Out[29:25] + 1; //choosing the following register
			IR_Out[18:14] = IR_Out[18:14] + 4; //adding 4 to PA in order to choose corresponding address
			load();
		
			end
			else if(IR_Out[24:19] == 6'b000000||IR_Out[24:19] == 6'b000001||IR_Out[24:19] == 6'b000010||IR_Out[24:19] == 6'b001001||IR_Out[24:19] == 6'b001010) begin

				load();
			end
			else if(IR_Out[24:19] == 6'b000111)begin
			//STORE DOUBLE WORD
			
			end
			else if(IR_Out[24:19] == 6'b000100||IR_Out[24:19] == 6'b000101||IR_Out[24:19] == 6'b000110) begin
			store();
			end
			else if(IR_Out[24:19] == 6'b001111) begin
			//SWAP THEM REGISTERS
			end
		end
	begin
		
		
	end
	
	
	//TASKS
	
	task load;
	begin
		in_PC  = IR_Out[29:25];
		ALU_op = 6'b000000;
		in_PA  = IR_Out[18:14];
		PSR_Enable = 1;

		if (IR_Out[13]) begin 
			//B is an immediate argument in IR
			ALUB_Mux_select = 2'b01;
			extender_select = 2'b00;
		end
		else begin 
			//B is a register
			ALUB_Mux_select = 2'b00;
			in_PB = IR_Out[4:0];
		end
		MAR_Enable =1;
		#5;
		RAM_enable = 1;
		MDR_Mux_select = 1;
		MDR_Enable =1;
		#5;
		ALUB_Mux_select = 2'b10;
		in_PA  = 5'b00000;
		ALU_op = 6'b000000;
		register_file = 1;
		#5;
		register_file = 0;
	end
	endtask
	
	task store;
	begin
		ALU_op = 6'b000000;
		RAM_OpCode = IR_Out[24:19];
		in_PA  = IR_Out[18:14];
		PSR_Enable = 1;

		if (IR_Out[13]) begin 
			//B is an immediate argument in IR
			ALUB_Mux_select = 2'b01;
			extender_select = 2'b00;
		end
		else begin 
			//B is a register
			ALUB_Mux_select = 2'b00;
			in_PB = IR_Out[4:0];
		end
		MAR_Enable =1;
		#5;
		in_PA  = IR_Out[29:25];
		ALUB_Mux_select = 2'b00;
		in_PB = 0;
		MDR_Mux_select = 0;
		MDR_Enable =1;
		#5;
		RAM_enable = 1;
		#5;
	
	end
	endtask
	
endmodule