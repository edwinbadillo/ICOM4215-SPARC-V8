

//12
7'b0001100: //branch
	begin
		register_file = 0; 
		ALU_op = 6'b000000;
		PC_enable =0;
		NPC_enable =0;
		if (cond) begin 
			if (BA_O) begin
				if(IR_Out[29]) //go to BA_O Anulled
				else //go to BA_O
			end
			else if (BN_O) begin
				if(IR_Out[29]) nextState <= 7'b0011000;//go to BN_O Anulled
				else //go to NOP
			end
			else nextState <= 7'b0011101;//go to BX TRUE
		end
		else begin
			if(IR_Out[29]) nextState <= 7'b0100010;//go to BX FALSE Anulled
			else nextState <= 7'b0101000;//go to BX FALSE
		
		end
	end

0001101://13 -BA_O Anulled
	begin
	//the delay instruction is annulled
	ALUA_Mux_select = 2'b10;
	ALUB_Mux_select = 3'b110;
	nextState <= 7'b0001110;
	end
0001110:
	begin
	NPC_enable =1;
	nextState <= 7'b0001111;
	end
0001111:
	begin
	NPC_enable = 0;
	PC_enable =1;
	nextState <= 7'b0010000;
	end
0010000:
	begin
	PC_enable =0;
	nextState <= 7'b0010001;
	end
0010001:
	begin
	//ALUA_Mux_select = 2'b10;
	//ALUB_Mux_select = 3'b110;
	NPC_enable =1;
	nextState <= 7'b0010010;
	end
0010010: //disable npc, end ba_o anulled
	begin
	NPC_enable = 0;
	nextState <= 7'b0000100; //fetch
	end
0010011://19 -BA_O
	begin
	PC_In_Mux_select = 2'b00;
	nextState <= 7'b0010100;
	end
0010100:
	begin
	PC_enable = 1;
	nextState <= 7'b0010101;
	end
0010101:
	begin
	PC_enable = 0;
	extender_select = 3'b101;
	ALUA_Mux_select = 2'b01;
	ALUB_Mux_select = 3'b001;
	end
0010110:
	begin
	NPC_enable =1;
	nextState <= 7'b0010111;
	end
0010111://end of BA_O
	begin
	NPC_enable = 0;
	nextState <= 7'b0000100; //fetch 
	end
0011000://24 -BN_O Anulled
	begin
	//the delay instruction is annulled
	ALUA_Mux_select = 2'b10;
	ALUB_Mux_select = 3'b110;
	nextState <= 7'b0011001;
	end
0011001:
	begin
	NPC_enable =1;
	nextState <= 7'b0011010;
	end
0011010:
	begin
	NPC_enable = 0;
	PC_enable =1;
	nextState <= 7'b0011011;
	end
0011011:
	begin
	PC_enable =0;
	//ALUA_Mux_select = 2'b10;
	//ALUB_Mux_select = 3'b110;
	NPC_enable =1;
	nextState <= 7'0011100b;
	end
0011100:
	begin
	NPC_enable = 0;
	nextState <= 7'b0000100; //fetch
	end
0011101://29 -BX TRUE
	begin
	//the delay instruction is annulled
	PC_In_Mux_select = 2'b00;
	nextState <= 7'b0011110;
	end
0011110:
	begin
	PC_enable = 1;
	nextState <= 7'b0011111;
	end
0011111:
	begin
	PC_enable = 0;
	extender_select = 3'b101;
	ALUA_Mux_select = 2'b01;
	ALUB_Mux_select = 3'b001;
	nextState <= 7'b;0100000
	end
0100000://32
	begin
	NPC_enable = 1;
	nextState <= 7'b0100001;
	end
0100001://33
	begin
	NPC_enable = 0;
	nextState <= 7'b0000100; //fetch
	end
0100010://34 -BX FALSE Anulled
	begin
	//the delay instruction is annulled
	ALUA_Mux_select = 2'b10;
	ALUB_Mux_select = 3'b110;
	nextState <= 7'b0100011;
	end
0100011:
	begin
	NPC_enable =1;
	nextState <= 7'b0100100;
	end
0100100:
	begin
	NPC_enable = 0;
	PC_enable =1;
	nextState <= 7'b0100101;
	end
0100101:
	begin
	PC_enable =0;
	nextState <= 7'b0100110;
	end
0100110:
	begin
	//ALUA_Mux_select = 2'b10;
	//ALUB_Mux_select = 3'b110;
	NPC_enable =1;
	nextState <= 7'b0100111;
	end
0100111:
	begin
	NPC_enable = 0;
	nextState <= 7'b0000100; //fetch
	end
0101000://40 -BX FALSE
	begin
	PC_In_Mux_select = 2'b00;
	nextState <= 7'b0101001;
	end
0101001:
	begin
	PC_enable = 1;
	nextState <= 7'b0101010;
	end
0101010:
	begin
	PC_enable = 0;
	ALUA_Mux_select = 2'b10;
	ALUB_Mux_select = 3'b110;
	nextState <= 7'b0101011;
	end
0101011:
	begin
	NPC_enable =1;
	nextState <= 7'b0101100;
	end
0101100:
	begin
	NPC_enable = 0;
	nextState <= 7'b0000100;//fetch
	end
0101101: //45- Call
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
0101110:
	begin
	PC_enable     = 1;
	register_file = 1;
	nextState <= 7'b0101111;
	end
0101111://47
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
	
0110000:
	begin
	NPC_enable = 1;
	nextState <= 7'b0110001; // Loads ALU output to nPC
	end
	
0110001: //49
	begin
	NPC_enable = 0;
	nextState <= 7'b0000100; //fetch
	end
	
	

//88
7'b1011000: nextState <= 7'b0000100; //no load double word, go to Fetch
7'b1011001: //load
	begin //Init reg and muxes
	in_PC           = IR_Out[29:25];
	RAM_OpCode      = IR_Out[24:19];
	ALU_op          = 6'b000000;
	in_PA           = IR_Out[18:14];
	ALUA_Mux_select = 2'b00;
	if (IR_Out[13]) nextState <= 7'b1011010; //B immediate
	else nextState <= 7'b1011011; //B register
	end
7'b1011010://B immediate
	begin
	//B is an immediate argument in IR
	ALUB_Mux_select = 3'b001;
	extender_select = 2'b00;
	nextState <= 7'b1011100;//mar enable
	end
7'b1011011: //B register
	begin
	ALUB_Mux_select = 3'b000;
	in_PB           = IR_Out[4:0];
	nextState <= 7'b1011100; //mar enable
	end
7'b1011100:
	begin
	MAR_Enable     = 1;
	nextState <= 7'b1011101; //disable MAR, Enable Ram and MDR Mux
	end
7'b1011101:
	begin
	MAR_Enable     = 0;
	RAM_enable     = 1;
	MDR_Mux_select = 1;
	nextState <= 7'b1011110; //disable ram
	end
7'b1011110:
	begin
	RAM_enable = 0;
	nextState <= 7'b1011111; //mdr enable
	end
	
7'b1011111: //95
	begin
	MDR_Enable = 1;
	nextState <= 7'b1100000; //MDR disable, Load datum to register
	end
7'b1100000:
	begin
	MDR_Enable      = 0;
	ALUB_Mux_select = 3'b010;
	in_PA           = 5'b00000;
	ALU_op          = 6'b000000;
	nextState <= 7'b1100001; //MDR disable, Load datum to register
	end
7'b1100001:
	begin
	register_file = 1;
	nextState <= 7'b1100010; //disable register file
	end
7'b1100010://98
	begin
	register_file = 0;
	nextState <= 7'b0000100; //Fetch
	end
7'b1100011: nextState <= 7'b0000100; //no store double word, go to Fetch
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
	nextState <= 7'b1100110; //mar enable
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
	nextState <= 7'b0000100; //Fetch
	end
	
	