module ram512x8 (output reg[31:0] MDR_DataOut, output reg MFC, input Enable,input[5:0] OpCode, input[31:0] MAR_Address, input[31:0] MDR_DataIn); 

	reg[7:0] Mem[0:511]; //512 localizations  of 1 byte
	
	//----------------------------PARAMETERS-SUMMARY------------------------------------------------------------------
	// MDR_DataOut : 32-bit bus that serves as the output port for the 32-bits sent to the MDR
	// MFC         : 1-bit output that serves as the bit used to tell the CU that the operation has been completed
	// Enable      : 1-bit input used for enabling the ram
	// OpCode      : 6-bit input bus that serves as the Opcode
	// MAR_Address : 32-bit input bus that serves as the address given by the MAR to indicate where to write
	// MDR_DataIn  : 32-bit input bus that serves as the input port for the 32-bits to be written to memory
	//-----------------------------------------------------------------------------------------------------------------
	
	always@(Enable, OpCode)
	begin
		MFC <= 0;
		if(Enable)
			case(OpCode)
			//Load Word 
				6'b000000:begin
					#5;
					MDR_DataOut[31:24] <= Mem[MAR_Address];
					MDR_DataOut[23:16] <= Mem[MAR_Address + 1];
					MDR_DataOut[15:8]  <= Mem[MAR_Address + 2];
					MDR_DataOut[7:0]   <= Mem[MAR_Address + 3];
					MFC <= 1;
				end

			//Load Unsigned Byte
			6'b000001: begin
					#5;
					MDR_DataOut[31:8] <= 24'h00000;
					MDR_DataOut[7:0]  <= Mem[MAR_Address + 3];
					MFC <= 1;
				end

			//Load Unsigned Halfword
				6'b000010: begin
					#5;
					MDR_DataOut[31:16] <= 16'h0000;
					MDR_DataOut[15:8]  <= Mem[MAR_Address + 2];
					MDR_DataOut[7:0]   <= Mem[MAR_Address + 3];
					MFC <= 1;
				end

			//Load Doubleword
				//6'b000011: Y = I0;
				//Implemented using the Control Unit to make two 32bit Loads	

			//Store Word
				6'b000100: begin
					#5;
					Mem[MAR_Address]     <= MDR_DataIn[31:24];
					Mem[MAR_Address + 1] <= MDR_DataIn[23:16];
					Mem[MAR_Address + 2] <= MDR_DataIn[15:8];
					Mem[MAR_Address + 3] <= MDR_DataIn[7:0];
					MFC <= 1;
				end

			//Store Byte
				6'b000101: begin
					#5;
					Mem[MAR_Address]     <= 8'h00; 
					Mem[MAR_Address + 1] <= 8'h00;
					Mem[MAR_Address + 2] <= 8'h00;
					Mem[MAR_Address + 3] <= MDR_DataIn[7:0];
					MFC <= 1;
				end

			//Store Halfword
				6'b000110: begin
					#5;	
					Mem[MAR_Address]     <= 8'h00; 
					Mem[MAR_Address + 1] <= 8'h00;
					Mem[MAR_Address + 2] <= MDR_DataIn[15:8];
					Mem[MAR_Address + 3] <= MDR_DataIn[7:0];
					MFC <= 1;
				end

			//Store Doubleword
				//6'b000111: Y = I0;
				//Implemented using the Control Unit to make two 32bit Stores

			//Load Signed Byte
				6'b001001: begin
					if(Mem[MAR_Address + 3][7]==1)
						begin
							#5;
							MDR_DataOut[31:8] <= 24'hffffff;
							MDR_DataOut[7:0]  <= Mem[MAR_Address + 3];
							MFC <= 1;
						end
					else
						begin
							#5;
							MDR_DataOut[31:8] <= 24'h000000;
							MDR_DataOut[7:0]  <= Mem[MAR_Address + 3];
							MFC <= 1;
						end
				end

			//Load Signed Halfword
				6'b001010: begin
					if(Mem[MAR_Address + 2][7]==1)
						begin
							#5;
							MDR_DataOut[31:16] <= 16'hffff;
							MDR_DataOut[15:8]  <= Mem[MAR_Address + 2];
							MDR_DataOut[7:0]   <= Mem[MAR_Address + 3];
							MFC <= 1;
						end
					else
						begin
							#5;
							MDR_DataOut[31:16] <= 16'h0000;
							MDR_DataOut[15:8]  <= Mem[MAR_Address + 2];
							MDR_DataOut[7:0]   <= Mem[MAR_Address + 3];
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