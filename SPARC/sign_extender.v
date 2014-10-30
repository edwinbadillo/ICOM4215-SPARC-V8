
// 12-bit to 32-bit sign extender
module sign_extender_13to32(output reg [31:0] out, input[12:0] in);
	always @ (in)
	begin
	if (in[12]) out[31:13] <= 19'b111_1111_1111_1111_1111;
	else
		out[31:13] <= 19'b000_0000_0000_0000_0000;
	out[12:0] <= in;
	end
endmodule


// 22-bit to 32-bit sign extender
module sign_extender_22to32(output reg [31:0] out, input[21:0] in);
	always @ (in)
	begin
	if (in[21]) out[31:22] <= 10'b11_1111_1111;
	else begin
		out[31:22] <= 10'b00_0000_0000;
	end
	out[21:0] <= in;
	end
endmodule


// 30-bit to 32-bit sign extender
module sign_extender_30to32(output reg [31:0] out, input[29:0] in);
	always @ (in)
	begin
	if (in[29]) out[31:30] <= 2'b11;
	else begin
		out[31:30] <= 2'b00;
	end
	out[29:0] <= in;
	end
endmodule

// doubleshifter for multiplying a number by 4
module shift_left_twice(output[31:0] out, input[29:0] in);
	out[31:2] <= in;
	out[1:0]  <= 2'b00;
endmodule


module sign_extender_magic_box(output [31:0] out, input [31:0] IR, input [1:0] S);
	wire [31:0] se13_out, se22_out, se30_out, sh4x_out;

	sign_extender_13to32 se13(se13_out, IR[12:0]);
	sign_extender_22to32 se22(se22_out, IR[21:0]);
	sign_extender_30to32 se30(se30_out, IR[29:0]);
	shift_left_twice     sh4x(sh4x_out, IR[29:0]);

	mux_32_4x1 mux(out, S, se13_out, se22_out, se30_out, sh4x_out);
endmodule