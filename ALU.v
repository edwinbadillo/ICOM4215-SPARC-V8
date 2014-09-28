module alu(output reg [31:0]res, output reg N, Z, V, C,input wire [5:0]op, [31:0]a, [31:0]b, input wire Cin);
reg carry;		// Used to save carry to not modify the C if S is low 
parameter CC = 5'h10; 	// Used to check the S in the opcode
always @ (op,a,b,Cin)
begin
casex (op)
	// ADD (0 y 16)
	6'b0?0000:
		begin
		{carry, res} = a + b;
		if(CC && op)
			addFlags();
		end
	// AND (1 y 17)
	6'b0?0001:
		begin
		res = a & b;
		if(CC && op)
			logicFlags();
		end
	// OR (2 y 18)
	6'b0?0010:
		begin
		res = a | b;
		if(CC && op)
			logicFlags();
		end
	// XOR (3 y 19)
	6'b0?0011:
		begin
		res = a ^ b;
		if(CC && op)
			logicFlags();
		end
	// SUB (4 y 20)
	6'b0?0100:
		begin
		{carry, res} = a - b;
		if(CC && op)
			subFlags();
		end
	// ANDN (5 y 21)
	6'b0?0101:
		begin
		res = a & ~b; //Not is applied to the second operand
		if(CC && op)
			logicFlags();
		end
	// ORN (6 + 22)
	6'b0?0110:
		begin
		res = a | ~b; //Not is applied to the second operand
		if(CC && op)
			logicFlags();
		end
	// XNOR (7 y 23)
	6'b0?0111:
		begin
		res = a ^ ~b; //Not is applied to the second operand
		if(CC && op)
			logicFlags();
		end
	// ADDX (8 y 24)
	6'b0?1000:
		begin
		{carry,res} = a + b + Cin;
		if(CC && op)
			addFlags();
		end
	// SUBX (12 y 28)
	6'b0?1100:
		begin
		{carry, res} = a - b - Cin;
		if(CC && op)
			subFlags();
		end
	// SLL (37) shift count is giving by the 5 lsb of r[rs2]
	6'b100101:
		// Ignore the 27 MSB of r[rs2]
		res = a << (b & 32'h0000001F);
	// SRL (38)
	6'b100110:	
		res = a >> (b & 32'h0000001F);
	// SRA (39)
	6'b100111:
		// Signed declaration of a for right shift arithmetic
		res = $signed(a) >>> (b & 32'h0000001F);
endcase
end
// Task used to modify the condition codes of logical instructions
task logicFlags;
begin
	// Carry flag and overflag is cleared in logical instrucions
	V = 0;
	C = 0;
	// Negative flag
	N = res[31];
	// Zero flag
	Z = (res == 0);
end
endtask
task addFlags;
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
endtask
task subFlags;
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
endtask
endmodule
