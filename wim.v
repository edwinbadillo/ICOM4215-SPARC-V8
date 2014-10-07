
module wim(output reg overFlow, output reg underFlow, output reg [31:0]wimReg, input [31:0]cwp, input bitDir, Clr, enable);
	
	reg [1:0] out;
	wire bitCheck = 0;
	
	mux4x1 muxNext(bitCheck, out, wimReg[0],wimReg[1],wimReg[2],wimReg[3]);
	
	always @ (enable,Clr)
	begin
		if(Clr)
			wimReg = 0;
		else if (enable)
		begin
		overFlow = 0;
		underFlow = 0;
		// Get the index of the bit to check

		if(bitDir) out = ((cwp % 4) +1) %4;
		else out = ((cwp % 4)-1) %4;
		
		// If the next window is 
		if(bitCheck == 0 && bitDir == 0)
			underFlow = 1;
		else if(bitCheck == 1 && bitDir == 1)
			overFlow = 1;
		if(bitDir == 0)
			wimReg[out] = 0;
		else
			begin
			if(wimReg [out] == 1)
				wimReg [out] = 0;
			wimReg[cwp % 4] = 1;
			end
		end
	end
endmodule
