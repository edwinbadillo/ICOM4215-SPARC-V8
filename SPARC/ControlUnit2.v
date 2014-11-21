module ControlUnit2(

	// Control Signals
	// Enables
	output reg IR_enable, NPC_enable, PC_enable, MDR_Enable, MAR_Enable, register_file, RAM_enable, PSR_Enable, TBR_enable,
	// Clear
	output reg PC_Clr,
	// Select Lines Muxes
	output reg [2:0]extender_select,
	output reg [1:0]PC_In_Mux_select, ALUA_Mux_select, PSR_Mux_select,
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

	reg [6:0] nextState, state;
	
	always @ (posedge Clk, RESET)
	begin
		if(RESET)
			state = 7'b000000;
		else
			state = nextState;
	end
	
	always @ (state, MFC)
		case (state)
			/********************/
			/*		RESET		*/
			/*					*/
			// Init PC
			7'b000000:
			begin
				PC_Clr = 1;
				PSR_Clr = 1;
				nextState = 7'b0000001;
			end
			// ALU output 4
			7'b0000001:
			begin
				PC_Clr = 0;
				PSR_Clr = 0;
				ALUA_Mux_select = 2'b01;
				ALUB_Mux_select = 3'b110;
				in_PA = 5'b00000;
				ALU_op = 6'b000000;
				nextState = 7'b0000010;
			end
			// NPC = 4
			7'b0000010:
			begin
				NPC_enable = 1;
				nextState = 7'b0000011;
			end
			// Disable NPC
			7'b0000011:
			begin
				NPC_enable = 0;
				nextState = 7'b0000100;
			end
			/********************/
			/*		Fetch		*/
			/*					*/
			// Get PC in ALU
			7'b0000100:
			begin
				in_PA = 5'b00000;
				ALUA_Mux_select = 2'b00;
				ALUB_Mux_select = 3'b011;
				nextState = 7'b0000101;
			end
			// Enable MAR and Load word opcode RAM
			7'b0000101:
			begin
				MAR_Enable = 1;
				RAM_OpCode = 6'b000000; ///TODO: REVERT BACK TO OPCODE SPARC 000000
				nextState = 7'b0000110;
			end
			// Start RAM procedure
			7'b0000110:
			begin
				MAR_Enable = 0;
				RAM_enable = 1;
				nextState = 7'b0000111;
			end
			// Wait for MFC
			7'b0000111:
			begin
				if(MFC)
				begin
					IR_enable = 1;
					RAM_enable = 0;
					nextState = 7'b0001000;
				end
			end
			// Disable IR
			7'b0001000:
			begin
				IR_enable = 0;
				nextState = 7'b1101100;
			end
			/********************/
			/*	   PC Flow		*/
			/*					*/
			7'b1101101: // 109
			begin
				// NPC + 4
				ALUA_Mux_select = 2'b10;  // Select NPC
				ALUB_Mux_select = 3'b110; // Select 4
				ALU_op = 6'b000000;
				PC_In_Mux_select = 2'b00; 
				// Now NPC is ready to be passed to PC and NPC + 4 is ready for NPC
				nextState = 7'b1101110;
			end
			// Enable PC and NPC for NPC -> PC, NPC + 4 -> NPC
			7'b1101110: // 110
			begin
				PC_enable = 1;
				NPC_enable = 1;
				nextState = 7'b1101111;
			end
			7'b1101111: // 111
			begin
				PC_enable = 0;
				NPC_enable = 0;
				nextState = 7'b0000100; // Go to Fetch
			end
			/********************/
			/*		Decode		*/
			/*					*/
			7'b1101100: // 108
			begin
				// OP = 00
				if (IR_Out[31:30] === 2'b00 ) 
				begin
					// Sethi
					if (IR_Out[24:22] === 3'b100) nextState = 7'b0001001;
					// Branches
					else
						nextState = 7'b0001100;
					begin
					end
				end
				// OP = 01 (Call)
				else if (IR_Out[31:30] === 2'b01) 
				begin
					nextState = 7'b0101101;
				end
				// OP = 10
				else if (IR_Out[31:30] === 2'b10)
				begin
					// JMPL
					if(IR_Out[24:19] == 6'b111000)
					begin
						nextState = 7'b0110010;
					end
					// Faltan
					// Arithmetic
					else 
						nextState = 7'b1010001;
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
						nextState = 7'b1011001;
					end
					// Store
					else if(IR_Out[24:19] == 6'b000100||IR_Out[24:19] == 6'b000101||IR_Out[24:19] == 6'b000110) 
					begin
						nextState = 7'b1100100;
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
			7'b0001001:
			begin
				extender_select = 3'b100;
				ALUA_Mux_select = 2'b00;
				ALUB_Mux_select = 3'b001;
				in_PC = IR_Out[29:25];
				in_PA = 5'b00000;
				ALU_op = 6'b000000;
				nextState = 7'b0001010;
			end
			7'b0001010:
			begin
				register_file = 1;
				nextState = 7'b0001011;
			end
			7'b0001011:
			begin
				register_file = 0;
				nextState = 7'b1101101; // Go to PC flow control
			end
			/********************/
			/*		Branch		*/
			/*					*/
			7'b0001100:
			begin
				register_file = 0; 
				ALU_op = 6'b000000;
				PC_enable =0;
				NPC_enable =0;
				if (cond) begin 
					if (BA_O) begin
						if(IR_Out[29]) nextState = 7'b0001101;//go to BA_O Anulled
						else nextState <= 7'b0010011;//go to BA_O
					end
					else if (BN_O) begin
						if(IR_Out[29]) nextState <= 7'b0011000;//go to BN_O Anulled
						else nextState <= 7'b1101101; //Go to flow control //go to NOP
					end
					else nextState <= 7'b0011101;//go to BX TRUE
				end
				else begin
					if(IR_Out[29]) nextState <= 7'b0100010;//go to BX FALSE Anulled
					else nextState <= 7'b0101000;//go to BX FALSE
				
				end
			end
			7'b0001101://13 -BA_O Anulled
				begin
				//the delay instruction is annulled
				ALUA_Mux_select = 2'b10;
				ALUB_Mux_select = 3'b110;
				nextState <= 7'b0001110;
				end
			7'b0001110:
				begin
				NPC_enable =1;
				nextState <= 7'b0001111;
				end
			7'b0001111:
				begin
				NPC_enable = 0;
				PC_enable =1;
				nextState <= 7'b0010000;
				end
			7'b0010000:
				begin
				PC_enable =0;
				nextState <= 7'b0010001;
				end
			7'b0010001:
				begin
				//ALUA_Mux_select = 2'b10;
				//ALUB_Mux_select = 3'b110;
				NPC_enable =1;
				nextState <= 7'b0010010;
				end
			7'b0010010: //disable npc, end ba_o anulled
				begin
				NPC_enable = 0;
				nextState <= 7'b0000100; //Go to fetch 
				end
			7'b0010011://19 -BA_O
				begin
				extender_select = 3'b101;
				ALUA_Mux_select = 2'b01;
				ALUB_Mux_select = 3'b001;
				PC_In_Mux_select = 2'b00;
				nextState <= 7'b0010100;
				end
			7'b0010100:
				begin
				PC_enable = 1;
				NPC_enable =1;
				nextState <= 7'b0010101;
				end
			7'b0010101:
				begin
				PC_enable = 0;
				NPC_enable = 0;
				nextState = 7'b0000100; //Go to fetch 7'b0010110;
				end
			// 7'b0010110:
				// begin
				
				// nextState <= 7'b0010111;
				// end
			// 7'b0010111://end of BA_O
				// begin
				
				// nextState <= 7'b0000100; //Go to fetch 
				// end
			7'b0011000://24 -BN_O Anulled
				begin
				//the delay instruction is annulled
				ALUA_Mux_select = 2'b10;
				ALUB_Mux_select = 3'b110;
				nextState <= 7'b0011001;
				end
			7'b0011001:
				begin
				NPC_enable =1;
				nextState <= 7'b0011010;
				end
			7'b0011010:
				begin
				NPC_enable = 0;
				PC_enable =1;
				nextState <= 7'b0011011;
				end
			7'b0011011:
				begin
				PC_enable =0;
				//ALUA_Mux_select = 2'b10;
				//ALUB_Mux_select = 3'b110;
				NPC_enable =1;
				nextState <= 7'b0011100;
				end
			7'b0011100:
				begin
				NPC_enable = 0;
				nextState <= 7'b0000100; //Go to fetch 
				end
			7'b0011101://29 -BX TRUE
				begin
				//the delay instruction is annulled
				extender_select = 3'b101;
				ALUA_Mux_select = 2'b01;
				ALUB_Mux_select = 3'b001;
				//tengo mi npc
				PC_In_Mux_select = 2'b00;
				nextState <= 7'b0011110;
				end
			7'b0011110:
				begin
				PC_enable = 1;
				NPC_enable = 1;
				nextState <= 7'b0011111;
				end
			7'b0011111:
				begin
				PC_enable = 0;
				NPC_enable = 0;
				nextState <= 7'b0000100;//Go to fetch 7'b0100000;
				end
			// 7'b0100000://32
				// begin
				
				// nextState <= 7'b0100001;
				// end
			// 7'b0100001://33
				// begin
				
				// nextState <= 7'b0000100; //Go to fetch 
				// end
			7'b0100010://34 -BX FALSE Anulled
				begin
				//the delay instruction is annulled
				ALUA_Mux_select = 2'b10;
				ALUB_Mux_select = 3'b110;
				nextState <= 7'b0100011;
				end
			7'b0100011:
				begin
				NPC_enable =1;
				nextState <= 7'b0100100;
				end
			7'b0100100:
				begin
				NPC_enable = 0;
				PC_enable =1;
				nextState <= 7'b0100101;
				end
			7'b0100101:
				begin
				PC_enable =0;
				nextState <= 7'b0100110;
				end
			7'b0100110:
				begin
				//ALUA_Mux_select = 2'b10;
				//ALUB_Mux_select = 3'b110;
				NPC_enable =1;
				nextState <= 7'b0100111;
				end
			7'b0100111:
				begin
				NPC_enable = 0;
				nextState <= 7'b0000100; //Go to fetch 
				end
			7'b0101000://40 -BX FALSE
				begin
				PC_In_Mux_select = 2'b00;
				nextState <= 7'b0101001;
				end
			7'b0101001:
				begin
				PC_enable = 1;
				nextState <= 7'b0101010;
				end
			7'b0101010:
				begin
				PC_enable = 0;
				ALUA_Mux_select = 2'b10;
				ALUB_Mux_select = 3'b110;
				nextState <= 7'b0101011;
				end
			7'b0101011:
				begin
				NPC_enable =1;
				nextState <= 7'b0101100;
				end
			7'b0101100:
				begin
				NPC_enable = 0;
				nextState <= 7'b0000100; //Go to fetch 
				end
			/********************/
			/*		Call		*/
			/*					*/
			7'b0101101: //45- Call
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
				nextState <= 7'b0101110;
				end
			7'b0101110:
				begin
				PC_enable     = 1;
				register_file = 1;
				nextState <= 7'b0101111;
				end
			7'b0101111://47
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
				nextState <= 7'b0110000; 
				end
				
			7'b0110000:
				begin
				NPC_enable = 1;
				nextState <= 7'b0110001; // Loads ALU output to nPC
				end
				
			7'b0110001: //49
				begin
				NPC_enable = 0;
				nextState <= 7'b0000100; //Go to fetch
				end
			/********************/
			/*		JMPL		*/
			/*					*/
			7'b0110010:
				begin
					in_PA = 5'b00000;			// Get r0 from PA
					ALUA_Mux_select = 2'b00;	// Choose rs1 from register file
					ALUB_Mux_select = 3'b011;	// Select PC
					ALU_op = 6'b000000;			// r0 + PC
					in_PC = IR_Out[29:25];		// Store in rd
					nextState = 7'b0110011;
				end
			7'b0110011:
				begin
					register_file = 1;
					nextState = 7'b0110100;
				end
			7'b0110100:
				begin
					register_file = 0;
					nextState = 7'b0110101;
				end
			7'b0110101:
				begin
					PC_In_Mux_select = 2'b00;
					nextState = 7'b0110110;
				end
			7'b0110110:
				begin
					PC_enable = 1;
					nextState = 7'b0110111;
				end
			7'b0110111:
				begin
					PC_enable = 0;
					in_PA = IR_Out[18:14];
					if(IR_Out[13])
						nextState = 7'b0111000;
					else
						nextState = 7'b0111001;
				end
			7'b0111000:
				begin
					//B is an immediate argument in IR
					ALUB_Mux_select = 3'b001; // Select output of sign extender as B for ALU
					extender_select = 2'b00;  // Select 13bit to 32bit extender
					nextState = 7'b0111010;
				end
			7'b0111001:
				begin
					//B is a register
					ALUB_Mux_select = 3'b000;
					in_PB = IR_Out[4:0];
					nextState = 7'b0111010;
				end
			7'b0111010:
				begin
					NPC_enable = 1;
					nextState = 7'b0111011;
				end
			7'b0111011:
				begin
					NPC_enable = 0;
					nextState = 7'b0000100; // Go to fetch
				end	
			/********************/
			/*		Arith		*/
			/*		Logic		*/
			7'b1010001: //81
			begin
				ALUA_Mux_select = 2'b00;
				in_PC = IR_Out[29:25];
				in_PA = IR_Out[18:14];
				ALU_op = IR_Out[24:19];
				if(IR_Out[13])
					// Immediate
					nextState = 7'b1010010; // 82
				else
					nextState = 7'b1010011; // 83
			end
			// Immediate
			7'b1010010: //82
			begin
				extender_select = 3'b000;
				ALUB_Mux_select = 3'b001;
				nextState = 7'b1010100;	// 84
			end
			// B is a register
			7'b1010011: //83
			begin
				in_PB = IR_Out[4:0];
				ALUB_Mux_select = 3'b000;
				nextState = 7'b1010100;	// 84
			end
			// ALU value ready
			7'b1010100: //84
			begin
				PSR_Mux_select = 2'b00;
				nextState = 7'b1010101;	
			end
			// Write ALU out to register file
			7'b1010101: //85
			begin
				register_file = 1;
				if(IR_Out[23])
					// Modify flag
					PSR_Enable = 1;
				nextState = 7'b1010111;	// 87
			end
			// Estado de mas...no se usa. DONT TOUCH
			// 7'b1010110: //86
			// begin
				// register_file = 0;
				// PSR_Enable = 0;
				// nextState = 7'b1010111;	// 87
			// end
			7'b1010111: //87
			begin
				PSR_Enable = 0;
				register_file = 0;
				nextState = 7'b1101101;	// Increment PC and NPC and then go to Fetch
			end
			/********************/
			/*		LOAD		*/
			/*					*/
			7'b1011001: //89
			begin
				ALUA_Mux_select = 2'b00;
				in_PC = IR_Out[29:25];
				in_PA = IR_Out[18:14];
				ALU_op = 6'b000000;
				RAM_OpCode = IR_Out[24:19];
				register_file = 0;
				if(IR_Out[13])
					// Immediate
					nextState = 7'b1011010; //90
				else
					nextState = 7'b1011011; //91
			end
			7'b1011010: //90
			begin
				extender_select = 2'b00;
				ALUB_Mux_select = 3'b001;
				nextState = 7'b1011100; //92
			end
			7'b1011011: //91
			begin
				ALUB_Mux_select = 3'b000;
				in_PB = IR_Out[4:0];
				nextState = 7'b1011100; //92
			end
			7'b1011100: //92
			begin
				MAR_Enable = 1;
				nextState = 7'b1011101;
			end
			7'b1011101: //93
			begin
				MAR_Enable = 0;
				RAM_enable = 1;
				MDR_Mux_select = 1;
				in_PA = 5'b00000;
				ALUB_Mux_select = 3'b010;
				nextState = 7'b1011110;
			end
			7'b1011110: //94
			begin
				RAM_enable = 0;
				nextState = 7'b1011111;
			end
			7'b1011111: //95
			begin
				MDR_Enable = 1;
				nextState = 7'b1100000;
			end
			7'b1100000: //96
			begin
				MDR_Enable = 0;
				nextState = 7'b1100001;
			end
			7'b1100001: //97
			begin
				register_file  = 1;
				nextState = 7'b1100010;
			end
			7'b1100010: //98
			begin
				register_file  = 0;
				nextState = 7'b1101101; // Got to flow control
			end
			/********************/
			/*		Store		*/
			/*					*/
			7'b1100100://100
				begin
				RAM_OpCode = IR_Out[24:19];
				ALU_op = 6'b000000;
				in_PA  = IR_Out[18:14];
				ALUA_Mux_select = 2'b00;
				if (IR_Out[13]) nextState <= 7'b1100101; //B immediate
				else nextState <= 7'b1100110; //B register
				end
			7'b1100101:
				begin
				//B is an immediate argument in IR
				ALUB_Mux_select = 3'b001;
				extender_select = 2'b00;
				nextState <= 7'b1100111; //mar enable
				end
			7'b1100110:
				begin
				//B is a register
				ALUB_Mux_select = 3'b000;
				in_PB = IR_Out[4:0];
				nextState <= 7'b1100111; //mar enable
				end
			7'b1100111:
				begin
				MAR_Enable = 1;
				nextState <= 7'b1101000;//mar enable, init mdr
				end
			7'b1101000:
				begin
				MAR_Enable      = 0;
				in_PA           = IR_Out[29:25];
				ALUB_Mux_select = 3'b000;
				in_PB           = 0;
				MDR_Mux_select  = 0;
				nextState <= 7'b1101001; //mdr enable
				end
			7'b1101001:
				begin
				MDR_Enable      = 1;
				nextState <= 7'b1101010;//MDR disable, store value
				end
			7'b1101010:
				begin
				MDR_Enable = 0;
				RAM_enable = 1;
				nextState <= 7'b1101011;//Ram disable
				end
			7'b1101011:
				begin
				RAM_enable = 0;
				nextState <= 7'b1101101; //Go to flow control
				end
		endcase
endmodule