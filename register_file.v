// Register file

module register_file(output reg [31:0] out, input [31:0] in, input enable, rw, Clr, Clk, input [1:0] current_window, input [4:0] r_num); // still missing some arguments

	// Parameters Summary:

	wire [3:0]  d_window_out; // 

	wire [31:0] d_register_out0; // The output of the decoder used for choosing a register in window 0
	wire [31:0] d_register_out1;
	wire [31:0] d_register_out2;
	wire [31:0] d_register_out3;

	wire [31:0] mux_r_global_out; // Output of the 8x1 mux used to multiplex values of the global registers
	wire [31:0] mux_r_window_out; // Output of the 64x1 mux used to multiplex the values of the variable registers in the current window

	wire [31:0] r_out[71:0]; // 72 32-bit buses corresponding to the outputs of the registers


	wire [7:0] global_r_chosen[3:0]; // 4 8-bit buses used to determine if a global register was selected or not
	wire or0_out;
	wire or1_out;
	wire or2_out;
	wire or3_out;

	// Logic for determining whether or not a global register was selected or not
	// The result of the combinatorial circuit will be used to drive the select pin of the final 2x1 mux
	or or1(or1_out, )


	// Global Registers r0-r7
	register_32 r0(out, in, rw, Clr, Clk); // we have to make this hardcoded to always be 0
	register_32 r1(out, in, rw, Clr, Clk);
	register_32 r2(out, in, rw, Clr, Clk);
	register_32 r3(out, in, rw, Clr, Clk);
	register_32 r4(out, in, rw, Clr, Clk);
	register_32 r5(out, in, rw, Clr, Clk);
	register_32 r6(out, in, rw, Clr, Clk);
	register_32 r7(out, in, rw, Clr, Clk);

	// Other registers 
	register_32 r_other[63:0] (out, in, enable, Clr, Clk);

	// Decoder logic to access the correct registers based on current window

	decoder_2x4 d_window(d_window_out, current_window, enable); // Chooses the window

	// Each one choose one out of the 32 visible registers in the current window
	decoder_5x32 d_register0 (d_register_out0, r_num, d_window_out[0]);
	decoder_5x32 d_register1 (d_register_out1, r_num, d_window_out[1]);
	decoder_5x32 d_register2 (d_register_out2, r_num, d_window_out[2]);
	decoder_5x32 d_register3 (d_register_out3, r_num, d_window_out[3]);



	// Multiplexer logic to pipe the data fom registers in current window outside

	mux_8x1  mux_r_global(output reg [31: 0]Y, input [2:0]S, [31: 0]I0, [31: 0]I1);
	mux_64x1 mux_r_window();

	mux_2x1  mux_result(out, );

endmodule
