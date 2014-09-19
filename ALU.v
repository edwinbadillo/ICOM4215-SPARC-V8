module alu(output reg [31:0]res, N, Z, V, C,reg [31:0]yReg,input [5:0]op, [31:0]a, [31:0]b, Cin);
reg carry;
always @ (op,a,b,Cin)
begin
	case (op)
		// ADD (0)
		6'b0?0000:
			{carry, res} = a + b;
		// AND (1)
		6'b0?0001:
			res = a & b;
		// OR (2)
		6'b0?0010:
			res = a | b;
		// XOR (3)
		6'b0?0011:
			res = a ^ b;
		// ANDN (5)
		6'b0?0101:
			res = a & ~b; //Not is applied to the second operand
		// ORN (6)
		6'b0?0110:
			res = a | ~b; //Not is applied to the second operand
		// XNOR (7)
		6'b0?0111:
			res = a ^ ~b; //Not is applied to the second operand
		// ADDX (8)
		6'b0?1000:
			{carry,res} = a + b + Cin;
		// UMUL (10) Multiplication results in a 64 bit result divided in res (lsb) and the Y register (msb)
		6'b0?1010:
			{yReg, res} = a * b;
		// SMUL (11) Multiplication results in a 64 bit result divided in res (lsb) and the Y register (msb)
		6'b0?1011:
			begin
			 
			{yReg, res} = a * b;
			end
	endcase
end
// Sum operation and carry flag
//{C,res} = a+b;
// Overflow => Num(+) + Num(+) = Num(-) o Num(-) + Num(-) = Num(+)
//V = ( (a[31] == b[31]) && (res[31] != a[31]));
// Negative Flag
//N = res[31];
// Zero Flag
//Z = (res == 0);
//end
endmodule
