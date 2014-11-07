module ControlUnit(

	// Control Signals
	// Enables
	output reg NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file, RAM_enable, PSR_Enable, TBR_enable,
	// Select Lines Muxes
	output reg [2:0]extender_select,
	output reg [1:0]	PC_In_Mux_select, ALUA_Mux_select, PSR_Mux_select,
	output reg [2:0]ALUB_Mux_select,
	output reg MDR_Mux_select, TBR_Mux_select,
	// Register file control
	output reg [4:0]in_PC, output reg [4:0]in_PA, output reg [4:0]in_PB,
	// Alu control
	output reg [5:0]ALU_op,
	// Ram control
	output reg [5:0]RAM_OpCode,
	// tt
	output reg [2:0] tt, 
	output reg TBR_Clr, PSR_Clr,
	// PSR
	output reg S, PS, ET,
	
	// Status Signals
	input [31:0]IR_Out,
	input MFC,
	input MSET,
	
	// Branches Signals
	input cond, BA_O, BN_O,

	// Input Signals
	input RESET,
	input Clk);

	// Local variables
	reg [31:0] State, nextState;
	
	initial begin
		RAM_enable = 0;
		register_file = 0;
	end
	
	reg TEMP_Enable;

	always @ (/*posedge Clk*/IR_Out, posedge RESET, posedge MSET)
		if (RESET) begin 
			State         = 0;
			RAM_enable    = 0;
			register_file = 0;
			// Supposed to be either a state that simply moves towards fetch state, or it's the fetch state itself
			// And everything else pertaining output signals in state 0
		end
		else if (MSET) begin
			$display("\n\n\n\n\n\n\n\n\n\nWell. MSET fired off. That means you messed up.\n\n\n\n\n\n\n\n\n\n");
		end
		else begin 
			if (IR_Out[31:30] === 2'b00 ) begin 
				if (IR_Out[24:22] === 3'b100) begin
					// Sethi instruction
					in_PA  = 5'b00000;      // A = r0
					in_PC  = IR_Out[29:25]; // getting rd
					ALU_op = 6'b000000;     // add, won't alter flags

					ALUA_Mux_select = 2'b00;
					ALUB_Mux_select = 3'b001; // need immediate value
					extender_select = 3'b100; // pass disp22 with 9:0 as zeros
					// Value should be ready
					#10;
					register_file = 1;
					#10; // Loaded 
					register_file = 0;
				end
				else
				begin
					// Branch Instructions Family

					// The address is included in the instruction in the least significant 22 bits

					register_file = 0; // Not writing to a register during a branch.
					extender_select = 2'b01;
					ALU_op          = 6'b000000;
					PC_enable =0;
					NPC_enable =0;

					if (cond) begin 
						if (BA_O) begin
							if(IR_Out[29]) begin
							
								//the delay instruction is annulled
								ALUA_Mux_select = 2'b10;
								ALUB_Mux_select = 3'b110;
								#10;
								NPC_enable =1;
								#10;
								NPC_enable = 0;
								PC_enable =1;
								#10;
								PC_enable =0;
								#10;
								//ALUA_Mux_select = 2'b10;
								//ALUB_Mux_select = 3'b110;
								NPC_enable =1;
								#10;
								NPC_enable = 0;

							end
							else begin
								
								PC_In_Mux_select = 2'b00;
								#10;
								PC_enable = 1;
								#10;
								PC_enable = 0;
								extender_select = 3'b101;
								ALUA_Mux_select = 2'b01;
								ALUB_Mux_select = 3'b001;
								#10;
								NPC_enable = 1;
								#10;
								NPC_enable = 0;
							end
						
						end
						else if (BN_O) begin
						
							if(IR_Out[29]) begin
							
								//the delay instruction is annulled
								ALUA_Mux_select = 2'b10;
								ALUB_Mux_select = 3'b110;
								#10;
								NPC_enable =1;
								#10;
								NPC_enable = 0;
								PC_enable =1;
								#10;
								PC_enable =0;
								#10;
								//ALUA_Mux_select = 2'b10;
								//ALUB_Mux_select = 3'b110;
								NPC_enable =1;
								#10;
								NPC_enable = 0;

							end
						
						end
						else begin
						//the delay instruction is annulled
							PC_In_Mux_select = 2'b00;
							#10;
							PC_enable = 1;
							#10;
							PC_enable = 0;
							extender_select = 3'b101;
							ALUA_Mux_select = 2'b01;
							ALUB_Mux_select = 3'b001;
							#10;
							NPC_enable = 1;
							#10;
							NPC_enable = 0;
						end
						
					
					end
					else begin
						
						if(IR_Out[29]) begin
							//the delay instruction is annulled
							ALUA_Mux_select = 2'b10;
							ALUB_Mux_select = 3'b110;
							#10;
							NPC_enable =1;
							#10;
							NPC_enable = 0;
							PC_enable =1;
							#10;
							PC_enable =0;
							#10;
							//ALUA_Mux_select = 2'b10;
							//ALUB_Mux_select = 3'b110;
							NPC_enable =1;
							#10;
							NPC_enable = 0;
							
						end
						else begin
						
							PC_In_Mux_select = 2'b00;
							#10;
							PC_enable = 1;
							#10;
							PC_enable = 0;
							ALUA_Mux_select = 2'b10;
							ALUB_Mux_select = 3'b110;
							#10;
							NPC_enable =1;
							#10;
							NPC_enable = 0;					
						end
					
					end
				
				end

			end
			else if (IR_Out[31:30] === 2'b01) begin 
				$display("CALLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
				// Call
				in_PC  = 5'b01111;  // Value of Program Counter is to be stored in R15
				// Just moving the value of Program Counter to R15, so add 0
				ALU_op = 6'b000000; // add
				in_PA  = 5'b00000;  // choose r0 as A

				ALUA_Mux_select = 2'b00;  // Selecting port A of regfile
				ALUB_Mux_select = 3'b011; // Selecting output of Program Counter
				// So far, value of PC is at the entrance of R15
				PC_In_Mux_select = 2'b00; // nPC --> PC
				// Now, nPC is at the entrance of PC as well
				#10;
				PC_enable     = 1;
				register_file = 1;
				#10; // Load PC output to R15 and nPC output to PC
				PC_enable     = 0;
				register_file = 0;

				// Now to perform nPC <= PC(which is R15) + 4*disp30
				in_PA = 5'b01111; // A = R15
				ALUA_Mux_select = 2'b00;  // redundant, but helps readability
				ALUB_Mux_select = 3'b001; // select output from magicbox <- IR

				extender_select = 2'b11; // Choose the shifter to perform B = 4*disp30

				ALU_op = 6'b000000; // redundant, add again: R15 + 4*disp30
				//ALU_out has the value needed, knocking at the door of nPC
				#10;
				NPC_enable = 1;
				#10; // Loads ALU output to nPC
				NPC_enable = 0;
			end
			else if (IR_Out[31:30] === 2'b10) begin
				// JMPL
				if(IR_Out[24:19] == 6'b111000)
				begin
					// Saving PC in rd
					// rd = r0 + PC;
					in_PA = 5'b00000;			// Get r0 from PA
					ALUA_Mux_select = 2'b00;	// Choose rs1 from register file
					ALUB_Mux_select = 3'b011;	// Select PC
					ALU_op = 6'b000000;			// r0 + PC
					in_PC = IR_Out[29:25];		// Store in rd
					$display("rd = r0 + PC;");
					#10;
					$display("Enable Register File");
					register_file = 1;
					#10;
					register_file = 0;
					#10;
					// PC = nPC
					PC_In_Mux_select = 2'b00;
					#10;
					PC_enable = 1;
					$display("PC = nPC");
					#10;
					PC_enable = 0;
					$display("PC disable");
					$display("nPC = rs1 + rs2 or rs1 + simm13");
					in_PA = IR_Out[18:14]; // Get rs1
					// nPC = rs1 + rs2 or rs1 + simm13
					if (IR_Out[13]) begin 
						//B is an immediate argument in IR
						ALUB_Mux_select = 3'b001; // Select output of sign extender as B for ALU
						extender_select = 2'b00;  // Select 13bit to 32bit extender
					end
					else begin 
						//B is a register
						ALUB_Mux_select = 3'b000;
						in_PB = IR_Out[4:0];
					end
					#10;
					$display("nPC enable");
					NPC_enable = 1;
					#10;
					$display("nPC disable");
					NPC_enable = 0;
					#10;
				end
				// WRTBR
				else if(IR_Out[24:19] == 6'b110011) begin
					ALU_op          = 6'b000011; // Xor opcode
					in_PA           = IR_Out[18:14]; // Get rs1
					ALUA_Mux_select = 2'b00; // Choose rs1 from register file with in_PA for A argument for ALU.
					if (IR_Out[13]) begin 
						//B is an immediate argument in IR
						ALUB_Mux_select = 3'b001; // Select output of sign extender as B for ALU
						extender_select = 2'b00;  // Select 13bit to 32bit extender
					end
					else begin 
						//B is a register
						ALUB_Mux_select = 3'b000;
						in_PB           = IR_Out[4:0];
					end
					// Result of operation outputted from ALU
					#10;
					// Choose mux pin 0 for writing TBA
					TBR_Mux_select = 0;	
					#10;
					TBR_enable = 1;
					#10; // Result of operation loaded into register of choice
					TBR_enable = 0;
				end
				//SAVE
				else if (IR_Out[24:19] == 6'b111100) begin
					PSR_Clr = 0;
					ALU_op          = 6'b000000;     // add, no change in flags
					ALUA_Mux_select = 2'b00;         // choose port A of regfile in muxA
					in_PC           = IR_Out[29:25]; // get rd
					in_PA           = IR_Out[18:14]; // get rs1

					if (IR_Out[13]) begin 
						//B is an immediate argument in IR
						ALUB_Mux_select = 3'b001; // Select output of sign extender as B for ALU
						extender_select = 2'b00;  // Select 13bit to 32bit extender
					end
					else begin 
						//B is a register
						ALUB_Mux_select = 3'b000;
						in_PB           = IR_Out[4:0];
					end
					// Result of operation outputted from ALU
					MDR_Mux_select = 0; // Choose MDR to store the result while we move windows
					//ready to enter MDR
					#10;
					MDR_Enable = 1;
					#10; // Loaded result into MDR
					// Now, we must sum 1 to CWP
					MDR_Enable = 0;
					ALUA_Mux_select = 2'b11;  // Select CWP as A
					ALUB_Mux_select = 3'b111; // B <- 1
					//Value ready
					PSR_Mux_select  = 2'b11;
					PSR_Clr = 0;
					//Value knocking the door on psr
					#10;
					PSR_Enable = 1;
					#10; // Loaded new value of CWP into PSR
					PSR_Enable = 0;
					// now we must store the value in mdr in rd in new window
					ALUA_Mux_select = 2'b00; // choose portA as A, intending to use r0
					in_PA = 5'b00000;
					ALUB_Mux_select = 3'b010; // Choose output of MDR as B, which is our value of rs1+rs2 from last window
					// Value knocking at regfile's door
					#10;
					register_file = 1;
					#10; // Loads value into rd in new window in regfile
					register_file = 0;
				end
				//RESTORE
				else if (IR_Out[24:19] == 6'b111101) begin
					PSR_Clr = 0;
					ALU_op          = 6'b000000;     // add, no change in flags
					ALUA_Mux_select = 2'b00;         // choose port A of regfile in muxA
					in_PC           = IR_Out[29:25]; // get rd
					in_PA           = IR_Out[18:14]; // get rs1

					if (IR_Out[13]) begin 
						//B is an immediate argument in IR
						ALUB_Mux_select = 3'b001; // Select output of sign extender as B for ALU
						extender_select = 2'b00;  // Select 13bit to 32bit extender
					end
					else begin 
						//B is a register
						ALUB_Mux_select = 3'b000;
						in_PB           = IR_Out[4:0];
					end
					// Result of operation outputted from ALU
					MDR_Mux_select = 0; // Choose MDR to store the result while we move windows
					//ready to enter MDR
					#10;
					MDR_Enable = 1;
					#10; // Loaded result into MDR
					// Now, we must subtract 1 from CWP
					MDR_Enable = 0;
					ALU_op = 6'b000100; // subtract
					ALUA_Mux_select = 2'b11;  // Select CWP as A
					ALUB_Mux_select = 3'b111; // B <- 1
					//Value ready
					PSR_Mux_select  = 2'b11;
					//Value knocking the door on psr
					#10;
					PSR_Enable = 1;
					#10; // Loaded new value of CWP into PSR
					PSR_Enable = 0;
					// now we must store the value in mdr in rd in new window
					ALU_op          = 6'b000000;
					ALUA_Mux_select = 2'b00; // choose portA as A, intending to use r0
					in_PA = 5'b00000;
					ALUB_Mux_select = 3'b010; // Choose output of MDR as B, which is our value of rs1+rs2 from last window
					// Value knocking at regfile's door
					#10;
					register_file = 1;
					#10; // Loads value into rd in new window in regfile
					register_file = 0;
				end
				else begin
					// Arithmetic and Logic Instructions Family
					in_PC           = IR_Out[29:25]; // Get rd
					ALU_op          = IR_Out[24:19]; // Get op3
					in_PA           = IR_Out[18:14]; // Get rs1
					ALUA_Mux_select = 2'b00; // Choose rs1 from register file with in_PA for A argument for ALU.
					
					if (IR_Out[13]) begin 
						//B is an immediate argument in IR
						ALUB_Mux_select = 3'b001; // Select output of sign extender as B for ALU
						extender_select = 2'b00;  // Select 13bit to 32bit extender
					end
					else begin 
						//B is a register
						ALUB_Mux_select = 3'b000;
						in_PB           = IR_Out[4:0];
					end
					// Result of operation outputted from ALU
					PSR_Mux_select = 2'b00;
					#10;
					register_file   = 1;
					// Modify flags if necessary
					if(IR_Out[23])
						PSR_Enable      = 1;
					#10; // Result of operation loaded into register of choice
					register_file   = 0;
					PSR_Enable      = 0;
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
			else begin
				$display("\n\n\nILLEGAL INSTRUCTION DETECTED\n\n\n");
				// Set the TBR and do all the magicks to PC <- TBR, nPC <- TBR + 4
			end
		end
	
	//TASKS
	
	task load;
	begin
		in_PC           = IR_Out[29:25];
		RAM_OpCode      = IR_Out[24:19];
		ALU_op          = 6'b000000;
		in_PA           = IR_Out[18:14];
		ALUA_Mux_select = 2'b00;

		if (IR_Out[13]) begin 
			//B is an immediate argument in IR
			ALUB_Mux_select = 3'b001;
			extender_select = 2'b00;
		end
		else begin
			//B is a register
			ALUB_Mux_select = 3'b000;
			in_PB           = IR_Out[4:0];
		end
		// Now, ALU is outputing the address from where to load the value in RAM to a register
		#10;
		MAR_Enable     = 1;
		#10; // Address loaded into MAR
		MAR_Enable     = 0;
		RAM_enable     = 1;
		MDR_Mux_select = 1;
		#10; // Initiate load instruction in RAM
		RAM_enable = 0;
		#10; // Waiting for memory to respond in 5ns meh.
		MDR_Enable = 1;
		#10; // Data loaded into MDR
		MDR_Enable      = 0;
		ALUB_Mux_select = 3'b010;
		in_PA           = 5'b00000;
		ALU_op          = 6'b000000;
		// Now, ALU outputs the value retrieved from memory
		#10;
		register_file = 1;
		#10; // Value loaded into destination register
		register_file = 0;

	end
	endtask
	
	task store;
	begin
		RAM_OpCode = IR_Out[24:19];
		ALU_op = 6'b000000;
		in_PA  = IR_Out[18:14];
		ALUA_Mux_select = 2'b00;

		if (IR_Out[13]) begin 
			//B is an immediate argument in IR
			ALUB_Mux_select = 3'b001;
			extender_select = 2'b00;
		end
		else begin 
			//B is a register
			ALUB_Mux_select = 3'b000;
			in_PB           = IR_Out[4:0];
		end
		// Now, ALU_out is outputting the address where to write in RAM
		#10;
		MAR_Enable = 1;
		#10; // MAR loaded with address on this posedge
		MAR_Enable      = 0;
		in_PA           = IR_Out[29:25];
		ALUB_Mux_select = 3'b000;
		in_PB           = 0;
		MDR_Mux_select  = 0;
		#10;
		MDR_Enable      = 1;
		#10; // MDR loaded with data to be written to memory
		MDR_Enable = 0;
		RAM_enable = 1;
		#10;
		RAM_enable = 0;
		#10; // Wait for the #5ns delay of the memory
	end
	endtask
	
endmodule