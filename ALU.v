module alu(output reg [31:0]res, [31:0]yRegO, N, Z, V, C, trap,input wire [5:0]op, [31:0]a, [31:0]b, [31:0]yRegI, Cin);
reg carry;
parameter CC = 5'h10;
integer temp;
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
			// Carry flag and overflag is cleared in logical instrucions
			V = 0;
			C = 0;
			// Negative flag
			N = res[31];
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
			// Carry flag and overflag is cleared in logical instrucions
			V = 0;
			C = 0;
			// Negative flag
			N = res[31];
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
			// Carry flag and overflag is cleared in logical instrucions
			V = 0;
			C = 0;
			// Negative flag
			N = res[31];
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
			// Carry flag and overflag is cleared in logical instrucions
			V = 0;
			C = 0;
			// Negative flag
			N = res[31];
			// Zero flag
			Z = (res == 0);
			end
		end
	// ORN (6 + 22)
	6'b0?0110:
		begin
		res = a | ~b; //Not is applied to the second operand
		if(CC && op)
			// Modify cc
			begin
			// Carry flag and overflag is cleared in logical instrucions
			V = 0;
			C = 0;
			// Negative flag
			N = res[31];
			// Zero flag
			Z = (res == 0);
			end
		end
	// XNOR (7 y 23)
	6'b0?0111:
		begin
		res = a ^ ~b; //Not is applied to the second operand
		if(CC && op)
			// Modify cc
			begin
			// Carry flag and overflag is cleared in logical instrucions
			V = 0;
			C = 0;
			// Negative flag
			N = res[31];
			// Zero flag
			Z = (res == 0);
			end
		end
	// ADDX (8 y 24)
	6'b0?1000:
		begin
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
		begin
		{yRegO, res} = a * b;
		if(CC && op)
			// Modify cc
			begin
			// Clear carry flag and overflow flag
			C = 0;
			V = 0;
			// Negative flag
			N = res[31];
			// Zero flag
			Z = (res == 0);
			end
		end
	/* TO DO SIGN EXTENSION */
	/* TO DO SIGN EXTENSION */
	/* TO DO SIGN EXTENSION */
	// SMUL (11 y 27) Multiplication results in a 64 bit result divided in res (lsb) and the Y register (msb)
	6'b0?1011:
		begin
		{yRegO, res} = a * b;
		if(CC && op)
			// Modify cc
			begin
			// Clear carry flag and overflow flag
			C = 0;
			V = 0;
			// Negative flag
			N = res[31];
			// Zero flag
			Z = (res == 0);
			end
		end
	// SUBX (12 y 28)
	6'b0?1100:
		begin
		{carry, res} = a - b - Cin;
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
	/* TO DO SIGN EXTENSION */
	/* TO DO SIGN EXTENSION */
	/* TO DO SIGN EXTENSION */
	// UDIV (14 y 30)
	6'b0?1110:
		// Concatinate yReg and a to form a 64 bit number to be divided by b which results
		// in a 32 bit number
		res = {yRegI, a} / b;
	/* TO DO SIGN EXTENSION */
	/* TO DO SIGN EXTENSION */
	/* TO DO SIGN EXTENSION */
	// SDIV (15 y 31)
	6'b0?1111:	
		res = a / b;
	// TADcc (32)
	// tag overflow occurs if bit 1 or bit 0 of either operand is nonzero, or if the 
	// addition generates an arithmetic overflow
	6'b100000:
		begin
		{C,res} = a + b;
		// Tag overflow occured
		if( (a[1:0] != 0 || b[1:0] != 0) || ( (a[31] == b[31]) && (res[31] != a[31])))
			V = 1;
		else
			V = 0;
		// Negative flag
		N = res[31];
		// Zero flag
		Z = (res == 0);
		end
	// TSUBcc (33)
	6'b100001:	
		begin
		{C,res} = a - b;
		// Tag overflow occured
		if( (a[1:0] != 0 || b[1:0] != 0) || (a[31] != b[31] && a[31] != res[31]))
			V = 1;
		else
			V = 0;
		// Negative flag
		N = res[31];
		// Zero flag
		Z = (res == 0);
		end
	// TADDccTV (34)
	// Generates trap if a tag overflow occurs, operation is cancelled
	6'b100010:
		begin
		{carry, temp} = a + b;
		// Tag overflow occured
		if( (a[1:0] != 0 || b[1:0] != 0) || (a[31] == b[31] && temp[31] != a[31]))
			// Trap generated
			trap = 1;
		else
			begin
			// restore value
			res = temp;
			// Modify cc
			V = 0;
			C = carry;
			// Negative flag
			N = res[31];
			// Zero flag
			Z = (res == 0);
			end
		end
	// TSUBccTV (35)
	// Generates trap if a tag overflow occurs, operation is cancelled
	6'b100011:	
		begin
		{carry, temp} = a - b;
		// Tag overflow occured
		if( (a[1:0] != 0 || b[1:0] != 0) || (a[31] != b[31] && a[31] != res[31]))
			// Trap generated
			trap = 1;
		else
			begin
			// restore value
			res = temp;
			// Modify cc
			V = 0;
			C = carry;
			// Negative flag
			N = res[31];
			// Zero flag
			Z = (res == 0);
			end
		end
	// MULScc (36)
	// no entiendo
	6'b100100:
		begin
		//a = a >> 1;
		//a = a | (N ^ V);
		//if(yRegI[0] == 1)
		end
	// SLL (37) shift count is giving by the 5 lsb of r[rs2]
	6'b100101:
		// Ignore the 27 MSB of r[rs2]
		res = a << (b & 5'b11111);
	// SRL (38)
	6'b100110:	
		res = a >> (b & 5'b11111);
	// SRA (39)
	6'b100111:
		res = a >>> (b & 5'b11111);
endcase
end
endmodule
