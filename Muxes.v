// 32 Bit Multiplexers

// 32 bit 2x1 Multiplexer
module mux_2x1 (output reg [31: 0]Y, input S, [31: 0]I0, [31: 0]I1);
always @ (S, I0, I1) 
	if (S) Y = I1; 
	else Y = I0; 
endmodule

// 32 bit 4x1 Multiplexer
module mux_4x1 (output reg [31: 0]Y, input [1:0]S, [31: 0]I0, [31:0]I1, [31:0]I2, [31:0]I3); 
always @ (S, I0, I1, I2, I3) 
	case(S)
		2'b00: Y = I0;
		2'b01: Y = I1;
		2'b10: Y = I2;
		2'b11: Y = I3;
	endcase
endmodule

