module register_32 (output reg [31:0] out, input wire [31:0] in, input wire enable, Clr, Clk);
always @ (Clk, posedge Clr)
	if (Clr) out <= 32'h00000000; //Clr = 1, clears register by writing '0' to all 32 bits
	else if (enable) out <= in; 
endmodule
