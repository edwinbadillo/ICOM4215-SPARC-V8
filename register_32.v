module register_32 (output reg [31:0] out, input [31:0] in, input enable, Clr, Clk);
always @ (posedge Clk, negedge Clr)
	if (!Clr) out <= 32'h00000000;
	else if (!enable) out <= in;
endmodule
