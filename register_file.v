// Register file

module register_file(output reg [31:0] out, input [31:0] in, input enable, rw, Clr, Clk, input [1:0] current_window, input [4:0] r_num); // still missing some arguments

	//---PARAMETERS-SUMMARY--------------------------------------------------------------------------------------------
	// out            : 32-bit bus that serves as the output ports of this module
	// in             : 32-bit bus that will provide the value to be written to the chosen register as input to the module
	// enable         : 
	// rw             : Bit indicating whether the operation to be performed is a read or write. Read = 0, Write = 1
	// Clr            :
	// Clk            : System clock
	// current_window : 
	// r_num          : 5-bit address bus for choosing one of the 32 visible registers of the current window

	//---WIRES---------------------------------------------------------------------------------------------------------
	wire [3:0]  d_window_out; // 4-bit bus that is the output of the decoder in charge of choosing the current register window

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

	wire nor0_out; // The output of the nor gate that takes in the output of the 4 or gates, the value of 

	wire [31:0]mux_result_out;

	//---DECODER-LOGIC-FOR-CHOOSING-CORRECT-REGISTER-BASED-ON-CURRENT-WINDOW-------------------------------------------
	decoder_2x4 d_window(d_window_out, current_window, enable); // Chooses the window

	// Each one choose one out of the 32 visible registers in the current window
	decoder_5x32 d_register0 (d_register_out0, r_num, d_window_out[0]);
	decoder_5x32 d_register1 (d_register_out1, r_num, d_window_out[1]);
	decoder_5x32 d_register2 (d_register_out2, r_num, d_window_out[2]);
	decoder_5x32 d_register3 (d_register_out3, r_num, d_window_out[3]);


	//---REGISTERS-----------------------------------------------------------------------------------------------------

	// Global Registers r0-r7
	register_32 r0(r_out[0], in, rw, Clr, Clk); // we have to make this hardcoded to always be 0 TODO
	register_32 r1(r_out[1], in, rw, Clr, Clk);
	register_32 r2(r_out[2], in, rw, Clr, Clk);
	register_32 r3(r_out[3], in, rw, Clr, Clk);
	register_32 r4(r_out[4], in, rw, Clr, Clk);
	register_32 r5(r_out[5], in, rw, Clr, Clk);
	register_32 r6(r_out[6], in, rw, Clr, Clk);
	register_32 r7(r_out[7], in, rw, Clr, Clk);

	// Other registers 
	register_32 r_other[63:0] (r_out[63:8], in, rw, Clr, Clk); // 64 32-bit registers to be used for the register windows

	//---MULTIPLEXING-FOR-OUTPUT---------------------------------------------------------------------------------------

	// Logic for determining whether or not a global register was selected or not
	// The result of the combinatorial circuit will be used to drive the select pin of the final 2x1 mux
	or or0(or0_out, global_r_chosen[0]);
	or or1(or1_out, global_r_chosen[1]);
	or or2(or2_out, global_r_chosen[2]);
	or or3(or3_out, global_r_chosen[3]);

	nor nor0(nor0_out, or0_out, or1_out, or2_out, or3_out);

	// Multiplexer logic to pipe the data fom registers in current window outside

	mux_8x1  mux_r_global(mux_r_global_out, input [2:0]S, [31: 0]I0, [31: 0]I1);
	mux_64x1 mux_r_window(mux_r_window_out, );

	mux_2x1  mux_result(mux_result_out, nor0_out, mux_r_global_out, mux_r_window_out);

	mux_2x1  mux_final(out, rw, mux_r_global_out, 32'hzzzz_zzzz); // If read, output register value. IF write, high impedance.

endmodule
