module wim (output reg [31:0] out, input wire [31:0] in, input wire enable, Clr, Clk);
always @ (posedge Clk, posedge Clr)
	if (Clr) out[3:0] <= 1'h0;
	else if (enable) out[3:0] <= in[3:0];
endmodule