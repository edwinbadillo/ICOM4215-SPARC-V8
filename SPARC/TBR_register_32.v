module TBR_register_32 (output reg [31:0] out, input wire [31:0] in, input wire enable, Clr, Clk);
always @ (posedge Clk, posedge Clr)
	if (Clr) out <= 32'h00000180; // Restore TBA to default (3)
	else if (enable) out <= in; 
endmodule
