
// 32 bit 2x1 Multiplexer
module mux_2x1 (output reg [31: 0]Y, input S, [31: 0]I0, [31: 0]I1); 
always @ (S, I0, I1) 
if (S) Y = I1; 
else Y = I0; 
endmodule
