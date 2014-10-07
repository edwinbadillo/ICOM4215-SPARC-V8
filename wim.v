module wim (output reg [31:0] out, input wire [31:0] in, input wire Clk);
always @ (posedge Clk)
	out <= 32'h0000000F;
endmodule

