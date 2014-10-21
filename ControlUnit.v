module ControlUnit(
	// Enables
	output reg NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file, RAM_enable, PSR_Enable,
	// Select Lines Muxes
	output reg [1:0]extender_select, [2:0]ALUB_Mux_select,
	output reg MDR_Mux_select,
	// Register file input
	output reg [4:0]in_PC, [4:0]in_PA, [4:0]in_PB,
	// Alu inputs
	output reg [5:0]ALU_op,
	// Ram input
	output reg [5:0]RAM_OpCode,
	
	input [31:0]IR_Out,
	input MFC);
	initial begin
	RAM_enable = 0;
	end
	
	reg TEMP_Enable;
	always @ (IR_Out, MFC)
		if (IR_Out[31:30] === 2'b00 ) begin 
			// Branch Instructions Family

			// The address is included in the instruction in the least significant 22 bits

			// checking cond field, to determine the type of branch
			/*casex (IR_Out[28:25])
				4'b1000:
					// Branch always, ba
				4'b0000:
					// Branch never, bn

				4'b1001:
					// Branch on not equal, bne
				4'b0001:
					// Branch on equal, be

				4'b1010:
					// Branch on greater, bg
				4'b0010:
					// Branch on less or equal, ble

				4'b1011:
					// Branch on greater or equal, bge
				4'b0011:
					// Branch on less, bl

				4'b1100:
					// Branch on greater unsigned, bgu
				4'b0100:
					// Branch on less or equal unsigned, bleu

				4'b1101:
					// Branch on carry = 0, bcc
				4'b0101:
					// Branch on carry = 1, bcs

				4'b1110:
					// Branch on positive, bpos
				4'b0110:
					// Branch on negative, bneg

				4'b1111:
					// Branch on overflow = 0, bvc
				4'b0111:
					// Branch on overflow = 1, bvs

			endcase
			*/


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
				ALUB_Mux_select = 3'b001;
				extender_select = 2'b00;
			end
			else begin 
				//B is a register
				ALUB_Mux_select = 3'b000;
				in_PB = IR_Out[4:0];
			end
		end
		else if (IR_Out[31:30] === 2'b11) begin 
			// Load and Store operations
			
			if(IR_Out[24:19] == 6'b000011) begin 			//Load DOUBLE WORD
			/*IR_Out[24:19] = 6'b000000; //load word op-code
			load(); //TRAP IF NOT EVEN ADDRESS
			register_file = 0;
			IR_Out[29:25] = IR_Out[29:25] + 1; //choosing the following register
			IR_Out[18:14] = IR_Out[18:14] + 4; //adding 4 to PA in order to choose corresponding address
			load();*/
		
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
			
			ALU_op = 6'b000000;
			in_PA  = IR_Out[18:14];
			if (IR_Out[13]) begin 
				//B is an immediate argument in IR
				ALUB_Mux_select = 3'b001;
				extender_select = 2'b00;
			end
			else begin 
				//B is a register
				ALUB_Mux_select = 3'b000;
				in_PB = IR_Out[4:0];
			end
			MAR_Enable =1;
			#5;
			MAR_Enable =0;
			RAM_enable = 1;
			MDR_Mux_select = 1;
			MDR_Enable =1;
			#5;
			MDR_Enable =0;
			TEMP_Enable = 1;
			#5;
			TEMP_Enable=0;
			in_PA  = IR_Out[29:25];
			ALUB_Mux_select = 3'b000;
			in_PB = 0;
			MDR_Mux_select = 0;
			MDR_Enable =1;
			#5;
			MDR_Enable =0;
			RAM_enable = 1;
			#5;
			RAM_enable = 0;
			ALUB_Mux_select = 3'b100;
			in_PC  = IR_Out[29:25];
			in_PA  = 5'b00000;
			ALU_op = 6'b000000;
			register_file = 1;			
			#5;
			register_file = 0;
			
			
			end
		end
	begin
		
		
	end
	
	
	//TASKS
	
	task load;
	begin
		in_PC  = IR_Out[29:25];
		RAM_OpCode = IR_Out[24:19];
		ALU_op = 6'b000000;
		in_PA  = IR_Out[18:14];
		if (IR_Out[13]) begin 
			//B is an immediate argument in IR
			ALUB_Mux_select = 3'b001;
			extender_select = 2'b00;
		end
		else begin 
			//B is a register
			ALUB_Mux_select = 3'b000;
			in_PB = IR_Out[4:0];
		end
		MAR_Enable =1;
		#6;
		MAR_Enable =0;
		RAM_enable = 1;
		MDR_Mux_select = 1;
		#2;
		MDR_Enable =1;
		
		#9;
		MDR_Enable =0;
		RAM_enable = 0;
		ALUB_Mux_select = 3'b010;
		in_PA  = 5'b00000;
		ALU_op = 6'b000000;
		register_file = 1;
		#6;
		register_file = 0;
		#2;
		
	end
	endtask
	
	task store;
	begin
		RAM_OpCode = IR_Out[24:19];
		ALU_op = 6'b000000;
		in_PA  = IR_Out[18:14];
		if (IR_Out[13]) begin 
			//B is an immediate argument in IR
			ALUB_Mux_select = 3'b001;
			extender_select = 2'b00;
		end
		else begin 
			//B is a register
			ALUB_Mux_select = 3'b000;
			in_PB = IR_Out[4:0];
		end
		MAR_Enable =1;
		#6;
		MAR_Enable =0;
		in_PA  = IR_Out[29:25];
		ALUB_Mux_select = 3'b000;
		in_PB = 0;
		MDR_Mux_select = 0;
		MDR_Enable =1;
		#5;
		MDR_Enable =0;
		#2;
		RAM_enable = 1;
		#5;
		RAM_enable = 0;
	
	end
	endtask
	
endmodule