module alu(output reg [31:0]res, N, Z, V, C,[31:0]yReg,input [5:0]op, [31:0]a, [31:0]b, Cin);
reg carry;
reg CC = 5'h10;
always @ (op,a,b,Cin)
begin
casex (op)
	// ADD (0 y 16)
	6'b0?0000:
		begin
		{carry, res} = a + b;
		if(CC && op)
			// Modify cc
			begin
			// Carry flag
			C = carry;
			// Negative flag
			N = res[31];
			// Overflow => Num(+) + Num(+) = Num(-) o Num(-) + Num(-) = Num(+)
			V = ( (a[31] == b[31]) && (res[31] != a[31]));
			// Zero flag
			Z = (res == 0);
			end
		end
	// AND (1 y 17)
	6'b0?0001:
		begin
		res = a & b;
		if(CC && op)
			// Modify cc
			begin
			// Carry flag is cleared in logical instrucions
			C = 0;
			// Negative flag
			N = res[31];
			// Overflow is cleared
			V = 0;
			// Zero flag
			Z = (res == 0);
			end
		end
	// OR (2 y 18)
	6'b0?0010:
		begin
		res = a | b;
		if(CC && op)
			// Modify cc
			begin
			// Carry flag is cleared in logical instrucions
			C = 0;
			// Negative flag
			N = res[31];
			// Overflow is cleared
			V = 0;
			// Zero flag
			Z = (res == 0);
			end
		end
	// XOR (3 y 19)
	6'b0?0011:
		begin
		res = a ^ b;
		if(CC && op)
			// Modify cc
			begin
			// Carry flag is cleared in logical instrucions
			C = 0;
			// Negative flag
			N = res[31];
			// Overflow is cleared
			V = 0;
			// Zero flag
			Z = (res == 0);
			end
		end
	// SUB (4 y 20)
	6'b0?0100:
		begin
		{carry, res} = a - b;
		if(CC && op)
			// Modify cc
			begin
			// Carry flag
			C = carry;
			// Negative flag
			N = res[31];
			// Overflow => Num(+) - Num(-) = Num(-) o Num(-) - Num(+) = Num(+)
			V = ((a[31] != b[31]) && (a[31] != res[31]));
			// Zero flag
			Z = (res == 0);
			end
		end
	// ANDN (5 y 21)
	6'b0?0101:
		begin
		res = a & ~b; //Not is applied to the second operand
		if(CC && op)
			// Modify cc
			begin
			// Carry flag is cleared in logical instrucions
			C = 0;
			// Negative flag
			N = res[31];
			// Overflow is cleared
			V = 0;
			// Zero flag
			Z = (res == 0);
			end
		end
	// ORN (6 + 22)
	6'b0?0110:
		res = a | ~b; //Not is applied to the second operand
`		if(CC && op)
			// Modify cc
			begin
			// Carry flag is cleared in logical instrucions
			C = 0;
			// Negative flag
			N = res[31];
			// Overflow is cleared
			V = 0;
			// Zero flag
			Z = (res == 0);
			end
		end
	// XNOR (7 y 23)
	6'b0?0111:
		res = a ^ ~b; //Not is applied to the second operand
		if(CC && op)
			// Modify cc
			begin
			// Carry flag is cleared in logical instrucions
			C = 0;
			// Negative flag
			N = res[31];
			// Overflow is cleared
			V = 0;
			// Zero flag
			Z = (res == 0);
			end
		end
	// ADDX (8 y 24)
	6'b0?1000:
		{carry,res} = a + b + Cin;
		if(CC && op)
			// Modify cc
			begin
			// Carry flag
			C = carry;
			// Negative flag
			N = res[31];
			// Overflow => Num(+) + Num(+) = Num(-) o Num(-) + Num(-) = Num(+)
			V = ( (a[31] == b[31]) && (res[31] != a[31]));
			// Zero flag
			Z = (res == 0);
			end
		end
	// UMUL (10 y 26) Multiplication results in a 64 bit result divided in res (lsb) and the Y register (msb)
	6'b0?1010:
		{yReg, res} = a * b;
	/* TO DO SIGN EXTENSION */
	// SMUL (11 y 27) Multiplication results in a 64 bit result divided in res (lsb) and the Y register (msb)
	6'b0?1011:
		begin
		{yReg, res} = a * b;
		end
	// SUBX (12 y 28)
	6'b0?1100:
		{yReg, res} = a * b;
	/* TO DO */
	// UDIV (14 y 30)
	6'b0?1110:
		res = a / b;
	// SDIV (15 y 31)
	6'b0?1111:	
		res = a / b;
	// TADcc (32)
	6'b100000:	
		res = a / b;
	// TSUBcc (33)
	6'b100001:	
		res = a / b;
	// TADDccTV (34)
	6'b100010:	
		res = a / b;
	// TSUBccTV (35)
	6'b100011:	
		res = a / b;
	// MULScc (36)
	6'b100100:	
		res = a / b;
	// SLL (37)
	6'b100101:	
		res = a / b;
	// SRL (38)
	6'b100110:	
		res = a / b;
	// SRA (39)
	6'b100111:	
		res = a / b;
endcase
end
endmodule
