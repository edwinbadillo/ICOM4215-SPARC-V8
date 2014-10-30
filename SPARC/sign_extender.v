
// 12-bit to 32-bit sign extender
module sign_extender_13to32(output[31:0] out, input[12:0] in);
	assign out[31:13] = {19{in[12]}};
	assign out[12:0]  = in[12:0];
endmodule


// 22-bit to 32-bit sign extender
module sign_extender_22to32(output[31:0] out, input[21:0] in);
	assign out[31:22] = {10{in[21]}};
	assign out[21:0]  = in[21:0];
endmodule


// 30-bit to 32-bit sign extender
module sign_extender_30to32(output[31:0] out, input[29:0] in);
	assign out[31:30] = {2{in[29]}};
	assign out[29:0]  = in[29:0];
endmodule

// multiplies a 30-bit field by 4
module mult4_30bit(output[31:0] out, input[29:0] in);
	assign out[31:2] = in;
	assign out[1:0]  = 2'b00;
endmodule

// pass disp22 with other bits equal to zero
module pass_disp22(output[31:0] out, input[21:0] in);
	assign out[31:22] = 10'b0000000000;
	assign out[21:0]  = in;
endmodule

// multiplies a 22-bit field by 4
module mult4_22bit(output[31:0] out, input[21:0] in);
	assign out[31:24] = {8{in[21]}};
	assign out[23:2]  = in;
	assign out[1:0]   = 2'b00;
endmodule

module sign_extender_magic_box(output [31:0] out, input [31:0] IR, input [2:0] S);
	wire [31:0] se13_out, se22_out, se30_out, m30_out, pd22_out, m22_out;

	sign_extender_13to32 se13(se13_out, IR[12:0]);
	sign_extender_22to32 se22(se22_out, IR[21:0]);
	sign_extender_30to32 se30(se30_out, IR[29:0]);
	mult4_30bit          m30 (m30_out,  IR[29:0]);
	pass_disp22          pd22(pd22_out, IR[21:0]);
	mult4_22bit          m22 (m22_out,  IR[21:0]); 



	mux_8x1 mux(out, S, se13_out, se22_out, se30_out, m30_out, pd22_out, m22_out, 0, 0); //32bit 8x1 mux
endmodule