module ControlUnit2(

	// Control Signals
	// Enables
	output reg IR_enable, NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file, RAM_enable, PSR_Enable, TBR_enable, TR_PR_enable, WIM_enable,
	// Clear
	output reg PC_Clr, TR_PR_Clr, TBR_Clr, PSR_Clr, WIM_Clr,
	// Select Lines Muxes
	output reg [2:0]extender_select,
	output reg [1:0]PC_In_Mux_select, ALUA_Mux_select,
	output reg [2:0]PSR_Mux_select,
	output reg [3:0]ALUB_Mux_select,
	output reg MDR_Mux_select, TBR_Mux_select,
	// Register file control
	output reg [4:0]in_PC, output reg [4:0]in_PA, output reg [4:0]in_PB,
	// Alu control
	output reg [5:0]ALU_op,
	// Ram control
	output reg [5:0]RAM_OpCode,
	// PSR
	output reg S, PS, ET,
	// Priority
	output reg Overflow, Underflow, T3,T4,
	
	// WIM and PSR
	input [31:0] WIM_Out, PSR_Out, TR_PR_Out, ALU_out,
	
	// Status Signals
	input [31:0]IR_Out,
	input MFC,
	input MSET,
	
	// Branches Signals
	input cond, BA_O, BN_O,

	// Input Signals
	input RESET,
	input Hardware_Trap,
	input Clk);

	reg [7:0] nextState, state;
	
	always @ (posedge Clk, RESET)
	begin
		if(RESET)
			state = 8'b0000000;
		else
			state = nextState;
	end
	
	always @ (state, MFC)
		case (state)
			/********************/
			/*		RESET		*/
			/*					*/
			// Init PC
			8'b0000000:
			begin
				PC_Clr = 1;
				TR_PR_Clr = 1;
				PSR_Clr = 1;
				TBR_Clr = 1;
				
				S = 0;
				PS = 0;
				Overflow = 0;
				Underflow = 0;
				T3 = 0;
				T4 = 0;
				
				nextState = 8'b00000001;
			end
			// ALU output 4
			8'b00000001:
			begin
				PC_Clr = 0;
				TR_PR_Clr = 0;
				PSR_Clr = 0;
				TBR_Clr = 0;
				ALUA_Mux_select = 2'b01;
				ALUB_Mux_select = 3'b110;
				in_PA = 5'b00000;
				ALU_op = 6'b000000;
				nextState = 8'b00000010;
			end
			// NPC = 4
			8'b00000010:
			begin
				NPC_enable = 1;
				PSR_Enable = 0;
				nextState = 8'b00000011;
			end
			// Disable NPC
			8'b00000011:
			begin
				NPC_enable = 0;
				nextState = 8'b00000100;
			end
			/********************/
			/*		Fetch		*/
			/*					*/
			// Get PC in ALU
			8'b00000100:
			begin
				in_PA = 5'b00000;
				ALUA_Mux_select = 2'b00;
				ALUB_Mux_select = 3'b011;
				nextState = 8'b00000101;
			end
			// Enable MAR and Load word opcode RAM
			8'b00000101:
			begin
				MAR_Enable = 1;
				RAM_OpCode = 6'b000000; ///TODO: REVERT BACK TO OPCODE SPARC 000000
				nextState = 8'b00000110;
			end
			// Start RAM procedure
			8'b00000110:
			begin
				MAR_Enable = 0;
				RAM_enable = 1;
				nextState = 8'b00000111;
			end
			// Wait for MFC
			8'b00000111:
			begin
				if(MFC)
				begin
					IR_enable = 1;
					RAM_enable = 0;
					nextState = 8'b00001000;
				end
			end
			// Disable IR
			8'b00001000:
			begin
				IR_enable = 0;
				nextState = 8'b01101100;
			end
			/********************/
			/*	   PC Flow		*/
			/*					*/
			8'b01101101: // 109
			begin
				// NPC + 4
				ALUA_Mux_select = 2'b10;  // Select NPC
				ALUB_Mux_select = 3'b110; // Select 4
				ALU_op = 6'b000000;
				PC_In_Mux_select = 2'b00; 
				// Now NPC is ready to be passed to PC and NPC + 4 is ready for NPC
				nextState = 8'b01101110;
			end
			// Enable PC and NPC for NPC -> PC, NPC + 4 -> NPC
			8'b01101110: // 110
			begin
				PC_enable = 1;
				NPC_enable = 1;
				nextState = 8'b01101111;
			end
			8'b01101111: // 111
			begin
				PC_enable = 0;
				NPC_enable = 0;
				nextState = 8'b00000100; // Go to Fetch
			end
			/********************/
			/*		Decode		*/
			/*					*/
			8'b01101100: // 108
			begin
				// OP = 00
				if (IR_Out[31:30] === 2'b00 ) 
				begin
					// Sethi
					if (IR_Out[24:22] === 3'b100) nextState = 8'b00001001;
					// Branches
					else
						nextState = 8'b00001100;
					begin
					end
				end
				// OP = 01 (Call)
				else if (IR_Out[31:30] === 2'b01) 
				begin
					nextState = 8'b00101101;
				end
				// OP = 10
				else if (IR_Out[31:30] === 2'b10)
				begin
					// JMPL
					if(IR_Out[24:19] == 6'b111000)
					begin
						nextState = 8'b00110010;
					end
					// Trap icc
					else if(IR_Out[24:19] == 6'b111010)
					begin
						nextState = 8'b10000101;
					end
					// R PSR
					else if(IR_Out[24:19] == 6'b101001)
					begin
						nextState = 8'b01110011;
					end
					// R WIM
					else if(IR_Out[24:19] == 6'b101010)
					begin
						nextState = 8'b01111111;
					end
					// R TBR
					else if(IR_Out[24:19] == 6'b101011)
					begin
						nextState = 8'b01110000;
					end 
					// W TBR
					else if(IR_Out[24:19] == 6'b110011)
					begin
						nextState = 8'b01110110;
					end
					// W PSR
					else if(IR_Out[24:19] == 6'b110001)
					begin
						nextState = 8'b1111001;
					end
					// W WIM
					else if(IR_Out[24:19] == 6'b110010)
					begin
						nextState = 8'b1111100;
					end
					// Faltan
					// Arithmetic
					else 
						nextState = 8'b01010001;
					begin
					end
				end
				// OP = 11
				else if (IR_Out[31:30] === 2'b11) 
				begin
					// Falta double transaction y swap
					// Load
					if(IR_Out[24:19] == 6'b000000||IR_Out[24:19] == 6'b000001||IR_Out[24:19] == 6'b000010||IR_Out[24:19] == 6'b001001||IR_Out[24:19] == 6'b001010) 
					begin
						nextState = 8'b01011001;
					end
					// Store
					else if(IR_Out[24:19] == 6'b000100||IR_Out[24:19] == 6'b000101||IR_Out[24:19] == 6'b000110) 
					begin
						nextState = 8'b01100100;
					end
				end
				else begin
				$display("\n\n\nILLEGAL INSTRUCTION DETECTED\n\n\n");
				// Set the TBR and do all the magicks to PC <- TBR, nPC <- TBR + 4
				end
			end
			/********************/
			/*		Sethi		*/
			/*					*/
			8'b00001001:
			begin
				extender_select = 3'b100;
				ALUA_Mux_select = 2'b00;
				ALUB_Mux_select = 3'b001;
				in_PC = IR_Out[29:25];
				in_PA = 5'b00000;
				ALU_op = 6'b000000;
				nextState = 8'b00001010;
			end
			8'b00001010:
			begin
				register_file = 1;
				nextState = 8'b00001011;
			end
			8'b00001011:
			begin
				register_file = 0;
				nextState = 8'b01101101; // Go to PC flow control
			end
			/********************/
			/*		Branch		*/
			/*					*/
			8'b00001100:
			begin
				register_file = 0; 
				ALU_op = 6'b000000;
				PC_enable =0;
				NPC_enable =0;
				if (cond) begin 
					if (BA_O) begin
						if(IR_Out[29]) nextState = 8'b00001101;//go to BA_O Anulled
						else nextState <= 8'b00010011;//go to BA_O
					end
					else if (BN_O) begin
						if(IR_Out[29]) nextState <= 8'b00011000;//go to BN_O Anulled
						else nextState <= 8'b01101101; //Go to flow control //go to NOP
					end
					else nextState <= 8'b00011101;//go to BX TRUE
				end
				else begin
					if(IR_Out[29]) nextState <= 8'b00100010;//go to BX FALSE Anulled
					else nextState <= 8'b00101000;//go to BX FALSE
				
				end
			end
			8'b00001101://13 -BA_O Anulled
				begin
				//the delay instruction is annulled
				ALUA_Mux_select = 2'b10;
				ALUB_Mux_select = 3'b110;
				nextState <= 8'b00001110;
				end
			8'b00001110:
				begin
				NPC_enable =1;
				nextState <= 8'b00001111;
				end
			8'b00001111:
				begin
				NPC_enable = 0;
				PC_enable =1;
				nextState <= 8'b00010000;
				end
			8'b00010000:
				begin
				PC_enable =0;
				nextState <= 8'b00010001;
				end
			8'b00010001:
				begin
				//ALUA_Mux_select = 2'b10;
				//ALUB_Mux_select = 3'b110;
				NPC_enable =1;
				nextState <= 8'b00010010;
				end
			8'b00010010: //disable npc, end ba_o anulled
				begin
				NPC_enable = 0;
				nextState <= 8'b00000100; //Go to fetch 
				end
			8'b00010011://19 -BA_O
				begin
				extender_select = 3'b101;
				ALUA_Mux_select = 2'b01;
				ALUB_Mux_select = 3'b001;
				PC_In_Mux_select = 2'b00;
				nextState <= 8'b00010100;
				end
			8'b00010100:
				begin
				PC_enable = 1;
				NPC_enable =1;
				nextState <= 8'b00010101;
				end
			8'b00010101:
				begin
				PC_enable = 0;
				NPC_enable = 0;
				nextState = 8'b00000100; //Go to fetch 8'b00010110;
				end
			// 8'b00010110:
				// begin
				
				// nextState <= 8'b00010111;
				// end
			// 8'b00010111://end of BA_O
				// begin
				
				// nextState <= 8'b00000100; //Go to fetch 
				// end
			8'b00011000://24 -BN_O Anulled
				begin
				//the delay instruction is annulled
				ALUA_Mux_select = 2'b10;
				ALUB_Mux_select = 3'b110;
				nextState <= 8'b00011001;
				end
			8'b00011001:
				begin
				NPC_enable =1;
				nextState <= 8'b00011010;
				end
			8'b00011010:
				begin
				NPC_enable = 0;
				PC_enable =1;
				nextState <= 8'b00011011;
				end
			8'b00011011:
				begin
				PC_enable =0;
				//ALUA_Mux_select = 2'b10;
				//ALUB_Mux_select = 3'b110;
				NPC_enable =1;
				nextState <= 8'b00011100;
				end
			8'b00011100:
				begin
				NPC_enable = 0;
				nextState <= 8'b00000100; //Go to fetch 
				end
			8'b00011101://29 -BX TRUE
				begin
				//the delay instruction is annulled
				extender_select = 3'b101;
				ALUA_Mux_select = 2'b01;
				ALUB_Mux_select = 3'b001;
				//tengo mi npc
				PC_In_Mux_select = 2'b00;
				nextState <= 8'b00011110;
				end
			8'b00011110:
				begin
				PC_enable = 1;
				NPC_enable = 1;
				nextState <= 8'b00011111;
				end
			8'b00011111:
				begin
				PC_enable = 0;
				NPC_enable = 0;
				nextState <= 8'b00000100;//Go to fetch 8'b00100000;
				end
			// 8'b00100000://32
				// begin
				
				// nextState <= 8'b00100001;
				// end
			// 8'b00100001://33
				// begin
				
				// nextState <= 8'b00000100; //Go to fetch 
				// end
			8'b00100010://34 -BX FALSE Anulled
				begin
				//the delay instruction is annulled
				ALUA_Mux_select = 2'b10;
				ALUB_Mux_select = 3'b110;
				nextState <= 8'b00100011;
				end
			8'b00100011:
				begin
				NPC_enable =1;
				nextState <= 8'b00100100;
				end
			8'b00100100:
				begin
				NPC_enable = 0;
				PC_enable =1;
				nextState <= 8'b00100101;
				end
			8'b00100101:
				begin
				PC_enable =0;
				nextState <= 8'b00100110;
				end
			8'b00100110:
				begin
				//ALUA_Mux_select = 2'b10;
				//ALUB_Mux_select = 3'b110;
				NPC_enable =1;
				nextState <= 8'b00100111;
				end
			8'b00100111:
				begin
				NPC_enable = 0;
				nextState <= 8'b00000100; //Go to fetch 
				end
			8'b00101000://40 -BX FALSE
				begin
				PC_In_Mux_select = 2'b00;
				nextState <= 8'b00101001;
				end
			8'b00101001:
				begin
				PC_enable = 1;
				nextState <= 8'b00101010;
				end
			8'b00101010:
				begin
				PC_enable = 0;
				ALUA_Mux_select = 2'b10;
				ALUB_Mux_select = 3'b110;
				nextState <= 8'b00101011;
				end
			8'b00101011:
				begin
				NPC_enable =1;
				nextState <= 8'b00101100;
				end
			8'b00101100:
				begin
				NPC_enable = 0;
				nextState <= 8'b00000100; //Go to fetch 
				end
			/********************/
			/*		Call		*/
			/*					*/
			8'b00101101: //45- Call
				begin
				in_PC  = 5'b01111;  // Value of Program Counter is to be stored in R15
				// Just moving the value of Program Counter to R15, so add 0
				ALU_op = 6'b000000; // add
				in_PA  = 5'b00000;  // choose r0 as A
				ALUA_Mux_select = 2'b00;  // Selecting port A of regfile
				ALUB_Mux_select = 3'b011; // Selecting output of Program Counter
				// So far, value of PC is at the entrance of R15
				PC_In_Mux_select = 2'b00; // nPC --> PC
				// Now, nPC is at the entrance of PC as well
				nextState <= 8'b00101110;
				end
			8'b00101110:
				begin
				PC_enable     = 1;
				register_file = 1;
				nextState <= 8'b00101111;
				end
			8'b00101111://47
				begin
				PC_enable     = 0;
				register_file = 0;

				// Now to perform nPC <= PC(which is R15) + 4*disp30
				in_PA = 5'b01111; // A = R15
				ALUA_Mux_select = 2'b00;  // redundant, but helps readability
				ALUB_Mux_select = 3'b001; // select output from magicbox <- IR
				extender_select = 2'b11; // Choose the shifter to perform B = 4*disp30
				ALU_op = 6'b000000; // redundant, add again: R15 + 4*disp30
				//ALU_out has the value needed, knocking at the door of nPC
				nextState <= 8'b00110000; 
				end
				
			8'b00110000:
				begin
				NPC_enable = 1;
				nextState <= 8'b00110001; // Loads ALU output to nPC
				end
				
			8'b00110001: //49
				begin
				NPC_enable = 0;
				nextState <= 8'b00000100; //Go to fetch
				end
			/********************/
			/*		JMPL		*/
			/*					*/
			8'b00110010:
				begin
					in_PA = 5'b00000;			// Get r0 from PA
					ALUA_Mux_select = 2'b00;	// Choose rs1 from register file
					ALUB_Mux_select = 3'b011;	// Select PC
					ALU_op = 6'b000000;			// r0 + PC
					in_PC = IR_Out[29:25];		// Store in rd
					nextState = 8'b00110011;
				end
			8'b00110011:
				begin
					register_file = 1;
					nextState = 8'b00110100;
				end
			8'b00110100:
				begin
					register_file = 0;
					nextState = 8'b00110101;
				end
			8'b00110101:
				begin
					PC_In_Mux_select = 2'b00;
					nextState = 8'b00110110;
				end
			8'b00110110:
				begin
					PC_enable = 1;
					nextState = 8'b00110111;
				end
			8'b00110111:
				begin
					PC_enable = 0;
					in_PA = IR_Out[18:14];
					if(IR_Out[13])
						nextState = 8'b00111000;
					else
						nextState = 8'b00111001;
				end
			8'b00111000:
				begin
					//B is an immediate argument in IR
					ALUB_Mux_select = 3'b001; // Select output of sign extender as B for ALU
					extender_select = 2'b00;  // Select 13bit to 32bit extender
					nextState = 8'b00111010;
				end
			8'b00111001:
				begin
					//B is a register
					ALUB_Mux_select = 3'b000;
					in_PB = IR_Out[4:0];
					nextState = 8'b00111010;
				end
			8'b00111010:
				begin
					NPC_enable = 1;
					nextState = 8'b00111011;
				end
			8'b00111011:
				begin
					NPC_enable = 0;
					nextState = 8'b00000100; // Go to fetch
				end	
			/********************/
			/*		Arith		*/
			/*		Logic		*/
			8'b01010001: //81
			begin
				ALUA_Mux_select = 2'b00;
				in_PC = IR_Out[29:25];
				in_PA = IR_Out[18:14];
				ALU_op = IR_Out[24:19];
				if(IR_Out[13])
					// Immediate
					nextState = 8'b01010010; // 82
				else
					nextState = 8'b01010011; // 83
			end
			// Immediate
			8'b01010010: //82
			begin
				extender_select = 3'b000;
				ALUB_Mux_select = 3'b001;
				nextState = 8'b01010100;	// 84
			end
			// B is a register
			8'b01010011: //83
			begin
				in_PB = IR_Out[4:0];
				ALUB_Mux_select = 3'b000;
				nextState = 8'b01010100;	// 84
			end
			// ALU value ready
			8'b01010100: //84
			begin
				PSR_Mux_select = 2'b00;
				nextState = 8'b01010101;	
			end
			// Write ALU out to register file
			8'b01010101: //85
			begin
				register_file = 1;
				if(IR_Out[23])
					// Modify flag
					PSR_Enable = 1;
				nextState = 8'b01010111;	// 87
			end
			// Estado de mas...no se usa. DONT TOUCH
			// 8'b01010110: //86
			// begin
				// register_file = 0;
				// PSR_Enable = 0;
				// nextState = 8'b01010111;	// 87
			// end
			8'b01010111: //87
			begin
				PSR_Enable = 0;
				register_file = 0;
				nextState = 8'b01101101;	// Increment PC and NPC and then go to Fetch
			end
			/********************/
			/*		LOAD		*/
			/*					*/
			8'b01011001: //89
			begin
				ALUA_Mux_select = 2'b00;
				in_PC = IR_Out[29:25];
				in_PA = IR_Out[18:14];
				ALU_op = 6'b000000;
				RAM_OpCode = IR_Out[24:19];
				register_file = 0;
				if(IR_Out[13])
					// Immediate
					nextState = 8'b01011010; //90
				else
					nextState = 8'b01011011; //91
			end
			8'b01011010: //90
			begin
				extender_select = 2'b00;
				ALUB_Mux_select = 3'b001;
				nextState = 8'b01011100; //92
			end
			8'b01011011: //91
			begin
				ALUB_Mux_select = 3'b000;
				in_PB = IR_Out[4:0];
				nextState = 8'b01011100; //92
			end
			8'b01011100: //92
			begin
				MAR_Enable = 1;
				nextState = 8'b01011101;
			end
			8'b01011101: //93
			begin
				MAR_Enable = 0;
				RAM_enable = 1;
				MDR_Mux_select = 1;
				in_PA = 5'b00000;
				ALUB_Mux_select = 3'b010;
				nextState = 8'b01011110;
			end
			8'b01011110: //94
			begin
				RAM_enable = 0;
				nextState = 8'b01011111;
			end
			8'b01011111: //95
			begin
				MDR_Enable = 1;
				nextState = 8'b01100000;
			end
			8'b01100000: //96
			begin
				MDR_Enable = 0;
				nextState = 8'b01100001;
			end
			8'b01100001: //97
			begin
				register_file  = 1;
				nextState = 8'b01100010;
			end
			8'b01100010: //98
			begin
				register_file  = 0;
				nextState = 8'b01101101; // Got to flow control
			end
			/********************/
			/*		Store		*/
			/*					*/
			8'b01100100://100
				begin
				RAM_OpCode = IR_Out[24:19];
				ALU_op = 6'b000000;
				in_PA  = IR_Out[18:14];
				ALUA_Mux_select = 2'b00;
				if (IR_Out[13]) nextState <= 8'b01100101; //B immediate
				else nextState <= 8'b01100110; //B register
				end
			8'b01100101:
				begin
				//B is an immediate argument in IR
				ALUB_Mux_select = 3'b001;
				extender_select = 2'b00;
				nextState <= 8'b01100111; //mar enable
				end
			8'b01100110:
				begin
				//B is a register
				ALUB_Mux_select = 3'b000;
				in_PB = IR_Out[4:0];
				nextState <= 8'b01100111; //mar enable
				end
			8'b01100111:
				begin
				MAR_Enable = 1;
				nextState <= 8'b01101000;//mar enable, init mdr
				end
			8'b01101000:
				begin
				MAR_Enable      = 0;
				in_PA           = IR_Out[29:25];
				ALUB_Mux_select = 3'b000;
				in_PB           = 0;
				MDR_Mux_select  = 0;
				nextState <= 8'b01101001; //mdr enable
				end
			8'b01101001:
				begin
				MDR_Enable      = 1;
				nextState <= 8'b01101010;//MDR disable, store value
				end
			8'b01101010:
				begin
				MDR_Enable = 0;
				RAM_enable = 1;
				nextState <= 8'b01101011;//Ram disable
				end
			8'b01101011:
				begin
				RAM_enable = 0;
				nextState <= 8'b01101101; //Go to flow control
				end
			
			/********************/
			/*  Read Privilege	*/
			/*					*/
			
			//Read WIM
			8'b01111111:
				begin
					if(!PSR_Out[7]) begin 
						//go to trap 5
					end
					else begin
						ALU_op = 6'b000000;
						in_PA = 5'b00000;
						in_PC  = IR_Out[29:25];
						ALUA_Mux_select = 2'b00;
						ALUB_Mux_select = 4'b1000;
						nextState <= 8'b11111110;//change
					end
				end
			8'b11111110:
				begin
					register_file =1;
					nextState <= 8'b11111111;//change
				end
			8'b11111111:
				begin
					register_file =0;
					nextState <= 8'b01101101;//flow control
				end
			
			//Read TBR
			8'b01110000:
				begin
					if(!PSR_Out[7]) begin 
						//go to trap 5
						//nextState <= 
					end
					else begin
						ALU_op = 6'b000000;
						in_PA = 5'b00000;
						in_PC  = IR_Out[29:25];
						ALUA_Mux_select = 2'b00;
						ALUB_Mux_select = 4'b1001;
						nextState <= 8'b01110001;
					end
				end
			8'b01110001:
				begin
					register_file =1;
					nextState <= 8'b01110010;
				end
			
			8'b01110010:
				begin
					register_file =0;
					nextState <= 8'b01101101;//flow control
				end
			
			//Read PSR
			8'b01110011:
				begin
					if(!PSR_Out[7]) begin 
						//go to trap 5
					end
					else begin
						ALU_op = 6'b000000;
						in_PA = 5'b00000;
						in_PC  = IR_Out[29:25];
						ALUA_Mux_select = 2'b00;
						ALUB_Mux_select = 4'b1010;
						nextState <= 8'b01110100;
					end
				end
			8'b01110100:
				begin
					register_file =1;
					nextState <= 8'b01110101;
				end
			
			8'b01110101:
				begin
					register_file =0;
					nextState <= 8'b01101101; //go to flow control
				end
			
			/********************/
			/*  Write Privilege	*/
			/*					*/
				
			//Write TBR
			8'b01110110: //118
			begin
				if(!PSR_Out[7]) begin 
					//go to trap 5
				end
				else begin
					ALU_op = 6'b000011; //XOR
					TBR_Mux_select = 1'b0;
					in_PA = IR_Out[18:14]; // Get rs1
					if (IR_Out[13]) begin 
						//B is an immediate argument in IR
						ALUB_Mux_select = 4'b0001; // Select output of sign extender as B for ALU
						extender_select = 2'b00;  // Select 13bit to 32bit extender
					end
					else begin 
						//B is a register
						ALUB_Mux_select = 4'b0000;
						in_PB = IR_Out[4:0];
					end
					nextState = 8'b01110111;
				end
			end
			
			8'b01110111://119
			begin
				TBR_enable = 1;
				nextState = 8'b1111000;
			end
			
			8'b1111000://120
			begin
				TBR_enable = 0;
				nextState <= 8'b01101101; // Flow control
			end
				
			//Write PSR
			8'b1111001://121
			begin
				if(!PSR_Out[7]) begin 
					//go to trap 5
				end
				else begin
					ALU_op = 6'b000011; //XOR
					in_PA = IR_Out[18:14]; // Get rs1
					if (IR_Out[13]) begin 
						//B is an immediate argument in IR
						ALUB_Mux_select = 4'b0001; // Select output of sign extender as B for ALU
						extender_select = 2'b00;  // Select 13bit to 32bit extender
					end
					else begin 
						//B is a register
						ALUB_Mux_select = 4'b0000;
						in_PB = IR_Out[4:0];
					end
					//ALU_out  = what we want to write
					if(ALU_out[4:0] > 3) begin//// YOYOYOYOYO
						//go to trap 5
					end
					else begin
						PSR_Mux_select = 3'b101; //ALU_out
						nextState <= 8'b01111010;

					end
				end
			end
			
			8'b01111010://122
			begin
				PSR_Enable = 1;
				nextState <= 8'b01111011;
			end
			
			8'b01111011://123
			begin
				PSR_Enable = 0;
				nextState <= 8'b01101101; // Flow control
			end
			
			
			//Write WIM
			8'b1111100://124
			begin
				if(!PSR_Out[7]) begin 
					//go to trap 5
				end
				else begin
					ALU_op = 6'b000011; //XOR
					in_PA = IR_Out[18:14]; // Get rs1
					if (IR_Out[13]) begin 
						//B is an immediate argument in IR
						ALUB_Mux_select = 4'b0001; // Select output of sign extender as B for ALU
						extender_select = 2'b00;  // Select 13bit to 32bit extender
					end
					else begin 
						//B is a register
						ALUB_Mux_select = 4'b0000;
						in_PB = IR_Out[4:0];
					end
					nextState <= 8'b01111101;
				end
			end
			
			8'b01111101://125
			begin
				WIM_enable = 1;
				nextState <= 8'b01111110;
			end
			8'b01111110://126
			begin
				WIM_enable = 0;
				nextState <= 8'b01101101; // Flow control
			end
			
			/********************/
			/*	  TRAP icc		*/
			/*					*/
						
			8'b10000101:
			begin
				if(cond && PSR_Out[5])
					// Trap condition was true and trap enables
				begin
					T3 = 1;
					TR_PR_enable = 1;
					
					ALUA_Mux_select = 2'b00; 
					TBR_Mux_select = 1'b1;
					ALU_op = 6'b000000;
					in_PA = IR_Out[18:14];
					
					// Check priority
					nextState <= 8'b10011010;
				end
				else
					// Nop
				begin
					nextState <= 8'b01101101; // Flow control
				end
			end
			
			// Immediate
			8'b10000110:
			begin	
				extender_select = 2'b00;
				ALUB_Mux_select = 4'b0001;
				nextState <= 8'b10001000;
			end
			
			// Register
			8'b10000111:
			begin	
				ALUB_Mux_select = 4'b0000;
				in_PB = IR_Out[4:0];
				nextState <= 8'b10001000;
			end
			
			// TBR enable
			8'b10001000:
			begin	
				TBR_enable = 1;
				nextState <= 8'b10001001;
			end
			
			// TBR disable
			8'b10001001:
			begin	
				TBR_enable = 0;
				// Save S in PS
				PS = PSR_Out[7];
				// Write to PS
				PSR_Mux_select = 3'b100;
				nextState <= 8'b10001010;
			end
			
			// PSR enable
			8'b10001010:
			begin	
				PSR_Enable = 1;
				nextState <= 8'b10001011;
			end
			
			// Enter supervisor
			8'b10001011:
			begin	
				PSR_Enable = 0;
				PSR_Mux_select = 3'b001;
				S = 1;
				nextState <= 8'b10001100;
			end
			
			// PSR Enable
			8'b10001100:
			begin	
				PSR_Enable = 1;
				nextState <= 8'b10001101;
			end
			
			// Disable Traps (ET)
			8'b10001101:
			begin	
				PSR_Enable = 0;
				PSR_Mux_select = 3'b010;
				ET = 0;
				nextState <= 8'b10001110;
			end
			
			// PSR Enable
			8'b10001110:
			begin	
				PSR_Enable = 1;
				nextState <= 8'b10001111;
			end
			
			// Decrement CWP
			8'b10001111:
			begin	
				PSR_Enable = 0;
				ALU_op = 6'b000100; // sub
				ALUA_Mux_select = 2'b11;//CWP
				ALUB_Mux_select = 4'b0111;//1
				PSR_Mux_select = 3'b011; //CWP to write	
				nextState <= 8'b10010000;
			end
			
			// PSR Enable
			8'b10010000:
			begin	
				PSR_Enable = 1;
				nextState <= 8'b10010001;
			end
			
			// Saving PC
			8'b10010001:
			begin	
				PSR_Enable = 0;
				ALU_op = 6'b000000; // add
				in_PA = 5'b00000; //GET PC
				ALUB_Mux_select = 4'b0011;
				ALUA_Mux_select = 2'b00;
				in_PC = 5'b10001;//PC->r17
				nextState <= 8'b10010010;
			end
			
			// Enable Reg
			8'b10010010:
			begin	
				register_file = 1;
				nextState <= 8'b10010011;
			end
			
			// Saving nPC
			8'b10010011:
			begin	
				register_file = 0;
				ALUB_Mux_select = 4'b0100;
				in_PC = 5'b10010;//NPC->r18
				nextState <= 8'b10010100;
			end
			
			// Enable Reg
			8'b10010100:
			begin	
				register_file = 1;
				nextState <= 8'b10010101;
			end
			
			// Jump to trap PC <- TBR
			8'b10010101:
			begin	
				register_file = 0;
				//PC<-TBR
				PC_In_Mux_select = 2'b10;  //TBR_Out
				nextState <= 8'b10010110;
			end
			
			// Enable PC
			8'b10010110:
			begin	
				PC_enable = 1;
				nextState <= 8'b10010111;
			end
			
			// Disable PC, nPC -> PC + 4
			8'b10010111:
			begin	
				PC_enable = 0;
				//NPC<-TBR+4
				ALUA_Mux_select = 2'b01; //PC Out
				ALUB_Mux_select = 4'b0110; //4
				nextState <= 8'b10011000;
			end
			
			// Enable nPC
			8'b10011000:
			begin	
				NPC_enable = 1;
				nextState <= 8'b10011001;
			end
			
			// Disable nPC
			8'b10011001:
			begin	
				NPC_enable = 0;
				nextState = 8'b00000100; // Go to Fetch
			end
			
			/********************/
			/*	  	Rett		*/
			/*					*/
			
			8'b10011011: //155
			begin	
				if( WIM_Out & 2^(PSR_Out[1:0] + 1) == 1)
				begin
					// Underflow
					Underflow = 1;
					TR_PR_enable = 1;
					
					// Check priority
					nextState <= 8'b10011010;
				end
				ALU_op = 6'b000000; // add
				ALUA_Mux_select = 2'b11;//CWP
				ALUB_Mux_select = 4'b0111;//1
				PSR_Mux_select = 3'b011; //CWP to write
				nextState = 8'b10011100; 
			end
			
			// PSR Enable
			8'b10011100:
			begin	
				PSR_Enable = 1;
				nextState <= 8'b10011101;
			end
			
			// PSR Disable
			8'b10011101:
			begin	
				PSR_Enable = 0;
				PC_In_Mux_select = 2'b00;
				nextState <= 8'b10011110;
			end
			
			// Enable PC
			8'b10011110:
			begin	
				PC_enable = 1;
				nextState <= 8'b10011111;
			end
			
			// Disable PC, nPC = rs1 + rs2 or rs1 + simm13
			8'b10011111:
			begin	
				PC_enable = 0;
				// nPC = rs1 + rs2 or rs1 + simm13
				in_PA = IR_Out[18:14]; // Get rs1
				if (IR_Out[13]) begin 
				//B is an immediate argument in IR
				ALUB_Mux_select = 4'b0001; // Select output of sign extender as B for ALU
				extender_select = 2'b00;  // Select 13bit to 32bit extender
				end
				else begin 
				//B is a register
				ALUB_Mux_select = 3'b000;
				in_PB = IR_Out[4:0];
				end
				in_PC = IR_Out[29:25];
				nextState <= 8'b10100000;
			end
			
			// Enable register
			8'b10100000:
			begin	
				register_file = 1;
				nextState <= 8'b10100001;
			end
			
			// Disable register, restore S from PS
			8'b10100001:
			begin	
				register_file = 0;
				S = PSR_Out[6];
				PSR_Mux_select = 3'b001;	
				nextState = 8'b10100010;
			end
			
			// PSR Enable
			8'b10100010:
			begin	
				PSR_Enable = 1;
				nextState <= 8'b10100011;
			end
			
			// PSR Disable, enable traps
			8'b10100011:
			begin	
				PSR_Enable = 0;
				ET = 1;
				PSR_Mux_select = 3'b010;
				nextState <= 8'b10100100;
			end
			
			// PSR Enable
			8'b10100100:
			begin	
				PSR_Enable = 1;
				nextState <= 8'b10100101;
			end
			
			// PSR Disable
			8'b10100101:
			begin	
				PSR_Enable = 0;
				nextState = 8'b00000100; // Go to Fetch
			end
			
			/********************/
			/*	  Priority		*/
			/*					*/
			
			8'b10011010:
			begin
				#1;
				$display("hi: %b", TR_PR_Out[2]);
				if(Hardware_Trap)
				begin
					
				end
				// Overflow
				else if(TR_PR_Out[0])
				begin
					
				end
				// Underflow
				else if(TR_PR_Out[1])
				begin
					// Go to trap table 2
				end
				// Trap 3
				else if(TR_PR_Out[2])
				begin
					TR_PR_enable = 0;
					if(IR_Out[13])
						nextState = 8'b10000110;
					else
						nextState = 8'b10000111;
				end
				// Trap 4
				else if(TR_PR_Out[3])
				begin
					
				end
			end
		endcase
endmodule