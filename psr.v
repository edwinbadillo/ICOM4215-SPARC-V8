module psr (output reg [31:0] out, input wire [3:0] icc_in,input wire [2:0] cwp_in, input wire trap, rett, enable, Clr, Clk);

initial
	out <=32'hf6000020; 
	/*
	PSR impl: F -> Reserved
	PSR ver: 6 -> Reserved
	ET: 1 ->Traps Enabled	
	*/
	
always @ (posedge Clk, posedge Clr)
	if (Clr) out <= 32'hf6000020; //Clr = 1, clears register's writeable bits by writing '0' 
	else if (enable) begin
	 out[23:20]<= icc_in; 
	 out[2:0]<= cwp_in;
	 
	 if(trap) begin //page 75
	 out[5]<=0; //ET
	 out[6]<= out[7]; //PS<=S
	 out[7]<= 1; //S
	 end
	 if(rett) begin
	 out[5]<=1; //ET
	 out[6]<= out[7]; //PS<=S
	 out[7]<= 0; //S
	 end
	end
endmodule 
