module wim (output reg [31:0] out, input wire [31:0] in, input wire enable, Clr, Clk);
//Only the four Least Significant Bits (LSB) are editable by 
//the instructions rdwim and wrwim since the implementation uses 4 windows

initial
	out =0;

always @ (posedge Clk, posedge Clr)
	if (Clr) out[3:0] <= 1'h0; //Clear the 4 LSB
	else if (enable) out[3:0] <= in[3:0]; //Write the 4 LSB
endmodule