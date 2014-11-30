	//Write TBR
	8'b01110110: //118
	begin
		if(PSR_Out[7]) begin 
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
		nextState = 8'1111000;
	end
	
	8'1111000://120
	begin
		TBR_enable = 0;
		nextState <= 8'b01101101; // Flow control
	end
	
	//Write PSR
	8'b1111001://121
	begin
		if(PSR_Mux_out[7]) begin 
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
			if(ALU_out[4:0] > 3) begin////YOYOYOYOYO
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
		if(PSR_Mux_out[7]) begin 
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
	