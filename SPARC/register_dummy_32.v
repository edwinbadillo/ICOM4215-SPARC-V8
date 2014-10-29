module register_dummy_32 (output reg [31:0] out, input wire [31:0] in, input wire Clk);
always @ (posedge Clk)
	out <= 32'h00000000; //Always outputting 32 bits of '0'
endmodule

