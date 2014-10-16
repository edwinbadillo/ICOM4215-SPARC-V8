
// 12-bit to 32-bit sign extender
module sign_extender_13to32(output[31:0] out, input[12:0] in);
	if (in[12]) out[31:13] <= 19'b111_1111_1111_1111_1111;
	else begin
		out[31:13] <= 19'b000_0000_0000_0000_0000;
	end
	out[12:0] <= in;
	
endmodule


// 22-bit to 32-bit sign extender
module sign_extender_22to32(output[31:0] out, input[21:0] in);
	if (in[21]) out[31:22] <= 10'b11_1111_1111;
	else begin
		out[31:22] <= 10'b00_0000_0000;
	end
	out[21:0] <= in;
	
endmodule


// 30-bit to 32-bit sign extender
module sign_extender_30to32(output[31:0] out, input[29:0] in);
	if (in[29]) out[31:13] <= 19'b111_1111_1111_1111_1111;
	else begin
		out[31:30] <= 2'b00;
	end
	out[29:0] <= in;
	
endmodule


module sign_extender_magic_box(output[31:0] out, input [31:0] IR, input [1:0] S);
	wire [31:0] se13_out, se22_out, se30_out;

	sign_extender_13to32 se13(se13_out, IR[12:0]);
	sign_extender_22to32 se22(se22_out, IR[21:0]);
	sign_extender_30to32 se30(se30_out, IR[29:0]);

	mux_4x1 mux(out, S, se13_out, se22_out, se30_out, IR);
endmodule