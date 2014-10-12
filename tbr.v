module tbr (output reg [31:0] out, input wire [19:0] TBA, input wire [8:0] tt, input wire enable, Clr, Clk);
initial 
	out[3:0]=0;
always @ (posedge Clk, posedge Clr)
	if (Clr) out <= 32'h00000000; //Clr = 1, clears register by writing '0' to all 32 bits
	else if (enable)begin
	out[31:12] <= TBA;
	out[11:4] <= tt;
	end	
endmodule

