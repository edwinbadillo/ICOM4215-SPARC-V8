// Register file
// Contains 72 registers and implements the register windows specification

module register_file(output reg [31:0] out, input [31:0] in, input enable, rw, Clr, Clk, input [1:0] current_window, input [4:0] r_num); // still missing some arguments

	//---PARAMETERS-SUMMARY--------------------------------------------------------------------------------------------
	// out            : 32-bit bus that serves as the output ports of this module
	// in             : 32-bit bus that will provide the value to be written to the chosen register as input to the module
	// enable         : Bit used to enable writing to a register in the register file
	// rw             : Bit indicating whether the operation to be performed is a read or write. Read = 0, Write = 1
	// Clr            : Asynchronous Clear Signal
	// Clk            : System clock
	// current_window : The current register window in play. Usually provided by the CU from the CWP (current window pointer) register
	// r_num          : 5-bit address bus for choosing one of the 32 visible registers of the current window
	//-----------------------------------------------------------------------------------------------------------------


	//---DECODER-LOGIC-FOR-CHOOSING-CORRECT-REGISTER-BASED-ON-CURRENT-WINDOW-------------------------------------------

	wire [3:0]  d_window_out; // 4-bit bus that is the output of the decoder in charge of choosing the current register window

	wire [31:0] d0_out; // The output of the decoder used for choosing a register in window 0
	wire [31:0] d1_out;
	wire [31:0] d2_out;
	wire [31:0] d3_out;

	wire and1_out;

	// Permit writing only when rw = 1 and enable = 1
	and and1(and1_out, enable, rw);
	decoder_2x4 d_window(d_window_out, current_window, and1_out); // This decoder chooses the window

	// Each one chooses one out of the 32 visible registers in the current window
	decoder_5x32 d0(d0_out, r_num, d_window_out[0]);
	decoder_5x32 d1(d1_out, r_num, d_window_out[1]);
	decoder_5x32 d2(d2_out, r_num, d_window_out[2]);
	decoder_5x32 d3(d3_out, r_num, d_window_out[3]);

	wire [71:0] r_enable; // a 72-bit bus for enabling each of the registers

	// Global registers r0-r7
	mux_8_4x1 mux_global(r_enable[7:0], current_window, d0_out[7:0], d1_out[7:0], d2_out[7:0], d3_out[7:0]);
	// r8-r15, 
	or  or8   (r_enable[8],  d3_out[24], d0_out[8]);
	or  or9   (r_enable[9],  d3_out[25], d0_out[9]);
	or  or10  (r_enable[10], d3_out[26], d0_out[10]);
	or  or11  (r_enable[11], d3_out[27], d0_out[11]);
	or  or12  (r_enable[12], d3_out[28], d0_out[12]);
	or  or13  (r_enable[13], d3_out[29], d0_out[13]);
	or  or14  (r_enable[14], d3_out[30], d0_out[14]);
	or  or15  (r_enable[15], d3_out[31], d0_out[15]);

	buf buf16 (r_enable[16], d0_out[16]);
	buf buf17 (r_enable[17], d0_out[17]);
	buf buf18 (r_enable[18], d0_out[18]);
	buf buf19 (r_enable[19], d0_out[19]);
	buf buf20 (r_enable[20], d0_out[20]);
	buf buf21 (r_enable[21], d0_out[21]);
	buf buf22 (r_enable[22], d0_out[22]);
	buf buf23 (r_enable[23], d0_out[23]);

	or  or24  (r_enable[24], d0_out[24], d1_out[8]);
	or  or25  (r_enable[25], d0_out[25], d1_out[9]);
	or  or26  (r_enable[26], d0_out[26], d1_out[10]);
	or  or27  (r_enable[27], d0_out[27], d1_out[11]);
	or  or28  (r_enable[28], d0_out[28], d1_out[12]);
	or  or29  (r_enable[29], d0_out[29], d1_out[13]);
	or  or30  (r_enable[30], d0_out[30], d1_out[14]);
	or  or31  (r_enable[31], d0_out[31], d1_out[15]);

	buf buf32 (r_enable[32], d1_out[16]);
	buf buf33 (r_enable[33], d1_out[17]);
	buf buf34 (r_enable[34], d1_out[18]);
	buf buf35 (r_enable[35], d1_out[19]);
	buf buf36 (r_enable[36], d1_out[20]);
	buf buf37 (r_enable[37], d1_out[21]);
	buf buf38 (r_enable[38], d1_out[22]);
	buf buf39 (r_enable[39], d1_out[23]);

	or  or40  (r_enable[40], d1_out[24], d2_out[8]);
	or  or41  (r_enable[41], d1_out[25], d2_out[9]);
	or  or42  (r_enable[42], d1_out[26], d2_out[10]);
	or  or43  (r_enable[43], d1_out[27], d2_out[11]);
	or  or44  (r_enable[44], d1_out[28], d2_out[12]);
	or  or45  (r_enable[45], d1_out[29], d2_out[13]);
	or  or46  (r_enable[46], d1_out[30], d2_out[14]);
	or  or47  (r_enable[47], d1_out[31], d2_out[15]);

	buf buf48 (r_enable[48], d2_out[16]);
	buf buf49 (r_enable[49], d2_out[17]);
	buf buf50 (r_enable[50], d2_out[18]);
	buf buf51 (r_enable[51], d2_out[19]);
	buf buf52 (r_enable[52], d2_out[20]);
	buf buf53 (r_enable[53], d2_out[21]);
	buf buf54 (r_enable[54], d2_out[22]);
	buf buf55 (r_enable[55], d2_out[23]);

	or  or56  (r_enable[56], d2_out[24], d3_out[8]);
	or  or57  (r_enable[57], d2_out[25], d3_out[9]);
	or  or58  (r_enable[58], d2_out[26], d3_out[10]);
	or  or59  (r_enable[59], d2_out[27], d3_out[11]);
	or  or60  (r_enable[60], d2_out[28], d3_out[12]);
	or  or61  (r_enable[61], d2_out[29], d3_out[13]);
	or  or62  (r_enable[62], d2_out[30], d3_out[14]);
	or  or63  (r_enable[63], d2_out[31], d3_out[15]);
	// 
	buf buf64 (r_enable[64], d3_out[16]);
	buf buf65 (r_enable[65], d3_out[17]);
	buf buf66 (r_enable[66], d3_out[18]);
	buf buf67 (r_enable[67], d3_out[19]);
	buf buf68 (r_enable[68], d3_out[20]);
	buf buf69 (r_enable[69], d3_out[21]);
	buf buf70 (r_enable[70], d3_out[22]);
	buf buf71 (r_enable[71], d3_out[23]);


	//---REGISTERS-----------------------------------------------------------------------------------------------------

	wire [31:0] r_out[71:0]; // 72 32-bit buses corresponding to the outputs of the registers

	// Global Registers r0-r7
	register_dummy_32 r0  (r_out[0], in, Clk); // r0 should always be 0. It is implemented with a dummy 32'b0 register

	register_32 r1  (r_out[1],  in, r_enable[1], Clr, Clk);
	register_32 r2  (r_out[2],  in, r_enable[2], Clr, Clk);
	register_32 r3  (r_out[3],  in, r_enable[3], Clr, Clk);
	register_32 r4  (r_out[4],  in, r_enable[4], Clr, Clk);
	register_32 r5  (r_out[5],  in, r_enable[5], Clr, Clk);
	register_32 r6  (r_out[6],  in, r_enable[6], Clr, Clk);
	register_32 r7  (r_out[7],  in, r_enable[7], Clr, Clk);
	// Variable registers 
	// r8-r15
	register_32 r8  (r_out[8],  in, r_enable[8],  Clr, Clk);
	register_32 r9  (r_out[9],  in, r_enable[9],  Clr, Clk);
	register_32 r10 (r_out[10], in, r_enable[10], Clr, Clk);
	register_32 r11 (r_out[11], in, r_enable[11], Clr, Clk);
	register_32 r12 (r_out[12], in, r_enable[12], Clr, Clk);
	register_32 r13 (r_out[13], in, r_enable[13], Clr, Clk);
	register_32 r14 (r_out[14], in, r_enable[14], Clr, Clk);
	register_32 r15 (r_out[15], in, r_enable[15], Clr, Clk);
	// r16-r23
	register_32 r16 (r_out[16], in, r_enable[16], Clr, Clk);
	register_32 r17 (r_out[17], in, r_enable[17], Clr, Clk);
	register_32 r18 (r_out[18], in, r_enable[18], Clr, Clk);
	register_32 r19 (r_out[19], in, r_enable[19], Clr, Clk);
	register_32 r20 (r_out[20], in, r_enable[20], Clr, Clk);
	register_32 r21 (r_out[21], in, r_enable[21], Clr, Clk);
	register_32 r22 (r_out[22], in, r_enable[22], Clr, Clk);
	register_32 r23 (r_out[23], in, r_enable[23], Clr, Clk);
	// r24-r31
	register_32 r24 (r_out[24], in, r_enable[24], Clr, Clk);
	register_32 r25 (r_out[25], in, r_enable[25], Clr, Clk);
	register_32 r26 (r_out[26], in, r_enable[26], Clr, Clk);
	register_32 r27 (r_out[27], in, r_enable[27], Clr, Clk);
	register_32 r28 (r_out[28], in, r_enable[28], Clr, Clk);
	register_32 r29 (r_out[29], in, r_enable[29], Clr, Clk);
	register_32 r30 (r_out[30], in, r_enable[30], Clr, Clk);
	register_32 r31 (r_out[31], in, r_enable[31], Clr, Clk);
	// r32-r39
	register_32 r32 (r_out[32], in, r_enable[32], Clr, Clk);
	register_32 r33 (r_out[33], in, r_enable[33], Clr, Clk);
	register_32 r34 (r_out[34], in, r_enable[34], Clr, Clk);
	register_32 r35 (r_out[35], in, r_enable[35], Clr, Clk);
	register_32 r36 (r_out[36], in, r_enable[36], Clr, Clk);
	register_32 r37 (r_out[37], in, r_enable[37], Clr, Clk);
	register_32 r38 (r_out[38], in, r_enable[38], Clr, Clk);
	register_32 r39 (r_out[39], in, r_enable[39], Clr, Clk);
	// r40-r47
	register_32 r40 (r_out[40], in, r_enable[40], Clr, Clk);
	register_32 r41 (r_out[41], in, r_enable[41], Clr, Clk);
	register_32 r42 (r_out[42], in, r_enable[42], Clr, Clk);
	register_32 r43 (r_out[43], in, r_enable[43], Clr, Clk);
	register_32 r44 (r_out[44], in, r_enable[44], Clr, Clk);
	register_32 r45 (r_out[45], in, r_enable[45], Clr, Clk);
	register_32 r46 (r_out[46], in, r_enable[46], Clr, Clk);
	register_32 r47 (r_out[47], in, r_enable[47], Clr, Clk);
	// r48-r55
	register_32 r48 (r_out[48], in, r_enable[48], Clr, Clk);
	register_32 r49 (r_out[49], in, r_enable[49], Clr, Clk);
	register_32 r50 (r_out[50], in, r_enable[50], Clr, Clk);
	register_32 r51 (r_out[51], in, r_enable[51], Clr, Clk);
	register_32 r52 (r_out[52], in, r_enable[52], Clr, Clk);
	register_32 r53 (r_out[53], in, r_enable[53], Clr, Clk);
	register_32 r54 (r_out[54], in, r_enable[54], Clr, Clk);
	register_32 r55 (r_out[55], in, r_enable[55], Clr, Clk);
	// r56-r63
	register_32 r56 (r_out[56], in, r_enable[56], Clr, Clk);
	register_32 r57 (r_out[57], in, r_enable[57], Clr, Clk);
	register_32 r58 (r_out[58], in, r_enable[58], Clr, Clk);
	register_32 r59 (r_out[59], in, r_enable[59], Clr, Clk);
	register_32 r60 (r_out[60], in, r_enable[60], Clr, Clk);
	register_32 r61 (r_out[61], in, r_enable[61], Clr, Clk);
	register_32 r62 (r_out[62], in, r_enable[62], Clr, Clk);
	register_32 r63 (r_out[63], in, r_enable[63], Clr, Clk);
	// r64-r71
	register_32 r64 (r_out[64], in, r_enable[64], Clr, Clk);
	register_32 r65 (r_out[65], in, r_enable[65], Clr, Clk);
	register_32 r66 (r_out[66], in, r_enable[66], Clr, Clk);
	register_32 r67 (r_out[67], in, r_enable[67], Clr, Clk);
	register_32 r68 (r_out[68], in, r_enable[68], Clr, Clk);
	register_32 r69 (r_out[69], in, r_enable[69], Clr, Clk);
	register_32 r70 (r_out[70], in, r_enable[70], Clr, Clk);
	register_32 r71 (r_out[71], in, r_enable[71], Clr, Clk);


	//---MULTIPLEXING-FOR-OUTPUT---------------------------------------------------------------------------------------

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

	wire [31:0] mux_result_out;
	wire and2_out;

	mux_4x1  mux_result(mux_result_out, current_window, mux_window0_out, mux_window1_out, mux_window2_out, mux_window3_out);

	// Output is not high impedance only when reading(rw = 0) and enable = 1
	nand nand(and2_out, !rw, enable);
	mux_2x1  mux_final(out, rw, mux_result_out, 32'hzzzz_zzzz);

endmodule
