module PSR_register_32 (output reg [31:0] out, input wire [31:0] in, input wire enable, Clr, Clk);
always @ (posedge Clk, posedge Clr)
	if (Clr) out <= 32'h00000023; // Restore CWP and ET to default
	else if (enable) out <= in; 
endmodule
