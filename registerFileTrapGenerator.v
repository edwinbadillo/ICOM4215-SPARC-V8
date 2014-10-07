module registerFileTrapGenerator(output reg overFlow, output reg underFlow, output reg [31:0]wimOut, input [31:0]cwp, [31:0]wimIn, input bitDir, Clr, enable, Clk);
	
	reg [1:0] out;
	wire bitCheck = 0;
	
	
	mux4x1 muxNext(bitCheck, out, wimOut[0],wimOut[1],wimOut[2],wimOut[3]);
	
	always @ (enable,Clr)
	begin
		if(Clr)
			wimOut = 0;
		else if (enable)
		begin
		wimOut = wimIn;
		overFlow = 0;
		underFlow = 0;
		
		// Get the index of the bit to check
		if(bitDir) out = ((cwp % 4) +1) %4;
		else out = ((cwp % 4)-1) %4;
		$display("bitcheck %d", bitCheck);
		$display("out %d", out);
		// If the next window is 
		if(bitCheck == 0 && bitDir == 0)
			underFlow = 1;
		else if(bitCheck == 1 && bitDir == 1)
			overFlow = 1;
			
		if(bitDir == 0)
			wimOut[out] = 0;
		else
			begin
			wimOut[out] = 0;
			wimOut[cwp % 4] = 1;
			end
		end
	end
endmodule
