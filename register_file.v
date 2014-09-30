// Register file

module register_file(output reg [31:0] out, input [31:0] in, input enable, rw, Clr, Clk, input [1:0] current_window, input [4:0] r_num); // still missing some arguments

	//---PARAMETERS-SUMMARY--------------------------------------------------------------------------------------------
	// out            : 32-bit bus that serves as the output ports of this module
	// in             : 32-bit bus that will provide the value to be written to the chosen register as input to the module
	// enable         : 
	// rw             : Bit indicating whether the operation to be performed is a read or write. Read = 0, Write = 1
	// Clr            : 
	// Clk            : System clock
	// current_window : The current register window in play. Usually provided by the CU from the CWP (current window pointer) register
	// r_num          : 5-bit address bus for choosing one of the 32 visible registers of the current window
	//-----------------------------------------------------------------------------------------------------------------


	//---WIRES---------------------------------------------------------------------------------------------------------
	wire [3:0]  d_window_out; // 4-bit bus that is the output of the decoder in charge of choosing the current register window

	wire [31:0] d_register_out0; // The output of the decoder used for choosing a register in window 0
	wire [31:0] d_register_out1;
	wire [31:0] d_register_out2;
	wire [31:0] d_register_out3;

	wire [31:0] mux_r_global_out; // Output of the 8x1 mux used to multiplex values of the global registers
	wire [31:0] mux_r_window_out; // Output of the 64x1 mux used to multiplex the values of the variable registers in the current window

	wire [31:0] r_out[71:0]; // 72 32-bit buses corresponding to the outputs of the registers in one current register window

	wire [7:0] global_r_chosen[3:0]; // 4 8-bit buses used to determine if a global register was selected or not

	// wire or0_out;
	// wire or1_out;
	// wire or2_out;
	// wire or3_out;

	// wire nor0_out; // The output of the nor gate that takes in the output of the 4 or gates, the value of 

	wire [31:0] mux_result_out;

	//---DECODER-LOGIC-FOR-CHOOSING-CORRECT-REGISTER-BASED-ON-CURRENT-WINDOW-------------------------------------------
	decoder_2x4 d_window(d_window_out, current_window, enable); // Chooses the window

	// Each one chooses one out of the 32 visible registers in the current window
	decoder_5x32 d_register0(d_register_out0, r_num, d_window_out[0]);
	decoder_5x32 d_register1(d_register_out1, r_num, d_window_out[1]);
	decoder_5x32 d_register2(d_register_out2, r_num, d_window_out[2]);
	decoder_5x32 d_register3(d_register_out3, r_num, d_window_out[3]);


	//---REGISTERS-----------------------------------------------------------------------------------------------------

	// Global Registers r0-r7
	register_32 r0  (r_out[0],  in, rw, Clr, Clk); // we have to make this hardcoded to always be 0 TODO
	register_32 r1  (r_out[1],  in, rw, Clr, Clk);
	register_32 r2  (r_out[2],  in, rw, Clr, Clk);
	register_32 r3  (r_out[3],  in, rw, Clr, Clk);
	register_32 r4  (r_out[4],  in, rw, Clr, Clk);
	register_32 r5  (r_out[5],  in, rw, Clr, Clk);
	register_32 r6  (r_out[6],  in, rw, Clr, Clk);
	register_32 r7  (r_out[7],  in, rw, Clr, Clk);
	// Variable registers 
	// r8-r15
	register_32 r8  (r_out[8],  in, rw, Clr, Clk);
	register_32 r9  (r_out[9],  in, rw, Clr, Clk);
	register_32 r10 (r_out[10], in, rw, Clr, Clk);
	register_32 r11 (r_out[11], in, rw, Clr, Clk);
	register_32 r12 (r_out[12], in, rw, Clr, Clk);
	register_32 r13 (r_out[13], in, rw, Clr, Clk);
	register_32 r14 (r_out[14], in, rw, Clr, Clk);
	register_32 r15 (r_out[15], in, rw, Clr, Clk);
	// r16-r23
	register_32 r16 (r_out[16], in, rw, Clr, Clk);
	register_32 r17 (r_out[17], in, rw, Clr, Clk);
	register_32 r18 (r_out[18], in, rw, Clr, Clk);
	register_32 r19 (r_out[19], in, rw, Clr, Clk);
	register_32 r20 (r_out[20], in, rw, Clr, Clk);
	register_32 r21 (r_out[21], in, rw, Clr, Clk);
	register_32 r22 (r_out[22], in, rw, Clr, Clk);
	register_32 r23 (r_out[23], in, rw, Clr, Clk);
	// r24-r31
	register_32 r24 (r_out[24], in, rw, Clr, Clk);
	register_32 r25 (r_out[25], in, rw, Clr, Clk);
	register_32 r26 (r_out[26], in, rw, Clr, Clk);
	register_32 r27 (r_out[27], in, rw, Clr, Clk);
	register_32 r28 (r_out[28], in, rw, Clr, Clk);
	register_32 r29 (r_out[29], in, rw, Clr, Clk);
	register_32 r30 (r_out[30], in, rw, Clr, Clk);
	register_32 r31 (r_out[31], in, rw, Clr, Clk);
	// r32-r39
	register_32 r32 (r_out[32], in, rw, Clr, Clk);
	register_32 r33 (r_out[33], in, rw, Clr, Clk);
	register_32 r34 (r_out[34], in, rw, Clr, Clk);
	register_32 r35 (r_out[35], in, rw, Clr, Clk);
	register_32 r36 (r_out[36], in, rw, Clr, Clk);
	register_32 r37 (r_out[37], in, rw, Clr, Clk);
	register_32 r38 (r_out[38], in, rw, Clr, Clk);
	register_32 r39 (r_out[39], in, rw, Clr, Clk);
	// r40-r47
	register_32 r40 (r_out[40], in, rw, Clr, Clk);
	register_32 r41 (r_out[41], in, rw, Clr, Clk);
	register_32 r42 (r_out[42], in, rw, Clr, Clk);
	register_32 r43 (r_out[43], in, rw, Clr, Clk);
	register_32 r44 (r_out[44], in, rw, Clr, Clk);
	register_32 r45 (r_out[45], in, rw, Clr, Clk);
	register_32 r46 (r_out[46], in, rw, Clr, Clk);
	register_32 r47 (r_out[47], in, rw, Clr, Clk);
	// r48-r55
	register_32 r48 (r_out[48], in, rw, Clr, Clk);
	register_32 r49 (r_out[49], in, rw, Clr, Clk);
	register_32 r50 (r_out[50], in, rw, Clr, Clk);
	register_32 r51 (r_out[51], in, rw, Clr, Clk);
	register_32 r52 (r_out[52], in, rw, Clr, Clk);
	register_32 r53 (r_out[53], in, rw, Clr, Clk);
	register_32 r54 (r_out[54], in, rw, Clr, Clk);
	register_32 r55 (r_out[55], in, rw, Clr, Clk);
	// r56-r63
	register_32 r56 (r_out[56], in, rw, Clr, Clk);
	register_32 r57 (r_out[57], in, rw, Clr, Clk);
	register_32 r58 (r_out[58], in, rw, Clr, Clk);
	register_32 r59 (r_out[59], in, rw, Clr, Clk);
	register_32 r60 (r_out[60], in, rw, Clr, Clk);
	register_32 r61 (r_out[61], in, rw, Clr, Clk);
	register_32 r62 (r_out[62], in, rw, Clr, Clk);
	register_32 r63 (r_out[63], in, rw, Clr, Clk);
	// r64-r71
	register_32 r64 (r_out[64], in, rw, Clr, Clk);
	register_32 r65 (r_out[65], in, rw, Clr, Clk);
	register_32 r66 (r_out[66], in, rw, Clr, Clk);
	register_32 r67 (r_out[67], in, rw, Clr, Clk);
	register_32 r68 (r_out[68], in, rw, Clr, Clk);
	register_32 r69 (r_out[69], in, rw, Clr, Clk);
	register_32 r70 (r_out[70], in, rw, Clr, Clk);
	register_32 r71 (r_out[71], in, rw, Clr, Clk);


	// register_32 r[71:0] (r_out[71:0], in, rw, Clr, Clk); // 64 32-bit registers to be used for the register windows




	//---MULTIPLEXING-FOR-OUTPUT---------------------------------------------------------------------------------------

	// Logic for determining whether or not a global register was selected or not
	// The result of the combinatorial circuit will be used to drive the select pin of the final 2x1 mux
	// or or0(or0_out, global_r_chosen[0]);
	// or or1(or1_out, global_r_chosen[1]);
	// or or2(or2_out, global_r_chosen[2]);
	// or or3(or3_out, global_r_chosen[3]);

	// nor nor0(nor0_out, or0_out, or1_out, or2_out, or3_out);

	// Multiplexer logic to pipe the data fom registers in current window outside

	// mux_8x1  mux_r_global(mux_r_global_out, r_num[2:0], [31: 0]I0, [31: 0]I1);
	// mux_64x1 mux_r_window(mux_r_window_out, );

	// mux_2x1  mux_result(mux_result_out, nor0_out, mux_r_global_out, mux_r_window_out);

	wire [31:0] mux_window_out0;
	wire [31:0] mux_window_out1;
	wire [31:0] mux_window_out2;
	wire [31:0] mux_window_out3;

	mux_32x1 mux_window0(mux_window0_out, r_num, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[8],  r_out[9],  r_out[10], r_out[11], r_out[12], r_out[13], r_out[14], r_out[15], 
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23],
		r_out[24], r_out[25], r_out[26], r_out[27], r_out[28], r_out[29], r_out[30], r_out[31]
		);

	mux_32x1 mux_window1(mux_window1_out, r_num, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[24], r_out[25], r_out[26], r_out[27], r_out[28], r_out[29], r_out[30], r_out[31], 
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39],
		r_out[40], r_out[41], r_out[42], r_out[43], r_out[44], r_out[45], r_out[46], r_out[47]
		);

	mux_32x1 mux_window2(mux_window2_out, r_num, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[40], r_out[41], r_out[42], r_out[43], r_out[44], r_out[45], r_out[46], r_out[47], 
		r_out[48], r_out[49], r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55],
		r_out[56], r_out[57], r_out[58], r_out[59], r_out[60], r_out[61], r_out[62], r_out[63]
		);

	mux_32x1 mux_window3(mux_window3_out, r_num, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[56], r_out[57], r_out[58], r_out[59], r_out[60], r_out[61], r_out[62], r_out[63], 
		r_out[64], r_out[65], r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71],
		r_out[8],  r_out[9],  r_out[10], r_out[11], r_out[12], r_out[13], r_out[14], r_out[15]
		);

	mux_4x1  mux_result(mux_result_out, current_window, mux_window_out[0], mux_window_out[1], mux_window_out[2], mux_window_out[3]);

	mux_2x1  mux_final(out, rw, mux_result_out, 32'hzzzz_zzzz); // If read, output register value. If write, high impedance.

endmodule
