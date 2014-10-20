// 32-bit Arithmetic Logic Unit

module alu(output reg [31:0]res, output reg N, Z, V, C,input wire [5:0]op, [31:0]a, [31:0]b, input wire Cin);
	reg carry;		// Used to save carry to not modify the C if S is low 
	
	//----------------------------PARAMETERS-SUMMARY------------------------------------------------------------------
	// res : 32-bit bus that serves as the output port for the result of an operation
	// N   : 1-bit output that serves as the Negative Flag
	// Z   : 1-bit output that serves as the Zero Flag
	// V   : 1-bit output that serves as the Overflow Flag
	// C   : 1-bit output that serves as the Carry Flag
	// op  : 6-bit input bus that serves as the Opcode
	// a   : 6-bit input bus that serves as the first value for an operation
	// b   : 6-bit input bus that serves as the second value for an operation
	// Cin : 1-bit input that serves as the input carry
	//-----------------------------------------------------------------------------------------------------------------
	
	always @ (op, a, b, Cin)
		begin
		if(a === 32'hxxxxxxxx || b === 32'hxxxxxxxx || Cin === 1'bx)
		begin
			res = 32'h00000000;
			N   = 0;
			Z   = 0;
			V   = 0;
			C   = 0;
		end
		else
		casex (op)
			// Notation: Mnemonic(op2 with S bit = 0, op2 with S bit = 1)
			// ADD (0 y 16)
			6'b0?0000:
				begin
				{carry, res} = a + b;
				if(op[4])
					addFlags();
				end
			// AND (1 y 17)
			6'b0?0001:
				begin
				res = a & b;
				if(op[4])
					logicFlags();
				end
			// OR (2 y 18)
			6'b0?0010:
				begin
				res = a | b;
				if(op[4])
					logicFlags();
				end
			// XOR (3 y 19)
			6'b0?0011:
				begin
				res = a ^ b;
				if(op[4])
					logicFlags();
				end
			// SUB (4 y 20)
			6'b0?0100:
				begin
				$display("a = %d, b = %d",a,b);
				{carry, res} = a - b;
				if(op[4])
					subFlags();
				end
			// ANDN (5 y 21)
			6'b0?0101:
				begin
				res = a & ~b; //Not is applied to the second operand
				if(op[4])
					logicFlags();
				end
			// ORN (6 + 22)
			6'b0?0110:
				begin
				res = a | ~b; //Not is applied to the second operand
				if(op[4])
					logicFlags();
				end
			// XNOR (7 y 23)
			6'b0?0111:
				begin
				res = a ^ ~b; //Not is applied to the second operand
				if(op[4])
					logicFlags();
				end
			// ADDX (8 y 24)
			6'b0?1000:
				begin
				{carry,res} = a + b + Cin;
				if(op[4])
					addFlags();
				end
			// SUBX (12 y 28)
			6'b0?1100:
				begin
				{carry, res} = a - b - Cin;
				if(op[4])
					subFlags();
				end
			// SLL (37) shift count is given by the 5 lsb of r[rs2]
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
