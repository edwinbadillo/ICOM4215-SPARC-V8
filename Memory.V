module ram128x32 (output reg[31:0] MDR_DataOut, output reg MFC, input Enable,input[5:0] OpCode, input[6:0] MAR_Address, input[31:0] MDR_DataIn); 

	reg[7:0] Mem[0:255]; //256 localizaciones de 8 bits
	
	always@(Enable, OpCode)
	begin
		MFC <= 0;
		if(Enable)
			case(OpCode)
			//Load Word 
				6'b000000:begin
					Mem[MAR_Address]     <= MDR_DataIn[31:24];
					Mem[MAR_Address + 1] <= MDR_DataIn[23:16];
					Mem[MAR_Address + 2] <= MDR_DataIn[15:8];
					Mem[MAR_Address + 3] <= MDR_DataIn[7:0];
					MFC <= 1;
				end

			//Load Unsigned Byte
				6'b000001: begin
					Mem[MAR_Address]     <= MDR_DataIn[31:24]; 
					Mem[MAR_Address + 1] <= 8'h00;
					Mem[MAR_Address + 2] <= 8'h00;
					Mem[MAR_Address + 3] <= 8'h00;
					MFC <= 1;
				end

			//Load Unsigned Halfword
				6'b000010: begin
					Mem[MAR_Address]     <= MDR_DataIn[31:24]; 
					Mem[MAR_Address + 1] <= MDR_DataIn[23:16];
					Mem[MAR_Address + 2] <= 8'h00;
					Mem[MAR_Address + 3] <= 8'h00;
					MFC <= 1;
				end

			//Load Doubleword
				//6'b000011: Y = I0;
				//Implemented using the Control Unit to make two 32bit Loads	

			//Store Word
				6'b000100: begin
					MDR_DataOut[31:24] <= Mem[MAR_Address];
					MDR_DataOut[23:16] <= Mem[MAR_Address + 1];
					MDR_DataOut[15:8]  <= Mem[MAR_Address + 2];
					MDR_DataOut[7:0]   <= Mem[MAR_Address + 3];
					MFC <= 1;
				end

			//Store Byte
				6'b000101: begin
					MDR_DataOut[31:8] <= 24'h00000;
					MDR_DataOut[7:0]  <= Mem[MAR_Address];
					MFC <= 1;
				end

			//Store Halfword
				6'b000110: begin
					MDR_DataOut[31:16] <= 16'h0000;
					MDR_DataOut[15:8]  <= Mem[MAR_Address];
					MDR_DataOut[7:0]   <= Mem[MAR_Address + 1];
					#5 MFC <= 1;
				end

			//Store Doubleword
				//6'b000111: Y = I0;
				//Implemented using the Control Unit to make two 32bit Stores

			//Load Signed Byte
				6'b001001: begin
					if(MDR_DataIn[31]==1)
						begin
							Mem[MAR_Address]     <= MDR_DataIn[31:24]; 
							Mem[MAR_Address + 1] <= 8'hff;
							Mem[MAR_Address + 2] <= 8'hff;
							Mem[MAR_Address + 3] <= 8'hff;
							MFC <= 1;
						end
					else
						begin
							Mem[MAR_Address]     <= MDR_DataIn[31:24]; 
							Mem[MAR_Address + 1] <= 8'h00;
							Mem[MAR_Address + 2] <= 8'h00;
							Mem[MAR_Address + 3] <= 8'h00;
							MFC <= 1;
						end
				end

			//Load Signed Halfword
				6'b001010: begin
					if(MDR_DataIn[31]==1)
						begin
							Mem[MAR_Address]     <= MDR_DataIn[31:24]; 
							Mem[MAR_Address + 1] <= MDR_DataIn[23:16];
							Mem[MAR_Address + 2] <= 8'hff;
							Mem[MAR_Address + 3] <= 8'hff;
							MFC <= 1;
						end
					else
						begin
							Mem[MAR_Address]     <= MDR_DataIn[31:24]; 
							Mem[MAR_Address + 1] <= MDR_DataIn[23:16];
							Mem[MAR_Address + 2] <= 8'h00;
							Mem[MAR_Address + 3] <= 8'h00;
							MFC <= 1;
						end
				end

			//SWAP register with memory
			//	6'b001111:
			//Implemented using the Control Unit and previous operations
				default : $display("Error in RAM");
			endcase
		else MDR_DataOut= 32'bz; 
	end
endmodule