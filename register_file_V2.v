// Register file
// Contains 72 registers and implements the register windows specification

module register_file(output [31:0] out_PA, output [31:0] out_PB, input [31:0] in,  input [4:0] in_PA, input [4:0] in_PB, input [4:0] in_PC, input enable, rw, Clr, Clk, input [1:0] current_window); // still missing some arguments

	//---PARAMETERS-SUMMARY--------------------------------------------------------------------------------------------
	// out_PA         : 32-bit bus that serves as output for input PA
	// out_PB         : 32-bit bus that serves as output for input PB
	// in			  : 32-bit bus corresponding of the data to be written
	// in_PA          : 5-bit address that will choose the output of out_A
	// in_PB          : 5-bit address that will choose the output of out_B
	// in_PC          : 5-bit address bus that will choose which register will be written or cleared
	// enable         : Bit used to enable writing to a register in the register file
	// rw             : Bit indicating whether the operation to be performed is a read or write. Read = 0, Write = 1
	// Clr            : Asynchronous Clear Signal
	// Clk            : System clock
	// current_window : The current register window in play. Usually provided by the CU from the CWP (current window pointer) register
	//-----------------------------------------------------------------------------------------------------------------


	//---DECODER-LOGIC-FOR-CHOOSING-CORRECT-REGISTER-BASED-ON-CURRENT-WINDOW FOR ENABLING-------------------------------------------

	wire [3:0]  d_window_out; // 4-bit bus that is the output of the enable decoder in charge of choosing the current register window

	wire [31:0] d0_out; // The output of the decoder used for choosing a register in window 0
	wire [31:0] d1_out;
	wire [31:0] d2_out;
	wire [31:0] d3_out;

	wire and1_out;

	// Permit writing only when rw = 1 and enable = 1
	and and1(and1_out, enable, rw);
	decoder_2x4 d_window(d_window_out, current_window, and1_out); // This decoder chooses the window

	// Each one chooses one out of the 32 visible registers in the current window
	decoder_5x32 d0(d0_out, in_PC, d_window_out[0]);
	decoder_5x32 d1(d1_out, in_PC, d_window_out[1]);
	decoder_5x32 d2(d2_out, in_PC, d_window_out[2]);
	decoder_5x32 d3(d3_out, in_PC, d_window_out[3]);
	
	//---DECODER-LOGIC-FOR-CHOOSING-CORRECT-REGISTER-BASED-ON-CURRENT-WINDOW FOR CLEARING-------------------------------------------
	
	wire [3:0]  d_window_out_clear; // 4-bit bus that is the output of the clear decoder in charge of choosing the current register window
	
	wire [31:0] d0_clear; // The output of the decoder used for clearing a register in window 0
	wire [31:0] d1_clear;
	wire [31:0] d2_clear;
	wire [31:0] d3_clear;

	decoder_2x4 d_window_clear(d_window_out_clear, current_window, Clr); // This decoder chooses the window for clearing

	// Each one chooses one out of the 32 visible registers in the current window to be cleared
	decoder_5x32 c0(d0_clear, in_PC, d_window_out_clear[0]);
	decoder_5x32 c1(d1_clear, in_PC, d_window_out_clear[1]);
	decoder_5x32 c2(d2_clear, in_PC, d_window_out_clear[2]);
	decoder_5x32 c3(d3_clear, in_PC, d_window_out_clear[3]);
	
	//---INTERCONNECTION OF CLEAR AND ENABLE SIGNALS TO THE REGISTERS--------------------------------------------------------------------------------------
	
	wire [71:0] r_enable; // a 72-bit bus for enabling each of the registers
	wire [71:0] r_clear; // a 72-bit bus for clearing each of the registers

	// Mux for enabling global registers r0-r7
	mux_8_4x1 mux_global(r_enable[7:0], current_window, d0_out[7:0], d1_out[7:0], d2_out[7:0], d3_out[7:0]);
	// Mux for clearing global registers r0-r7
	mux_8_4x1 mux_global_clear(r_clear[7:0], current_window, d0_clear[7:0], d1_clear[7:0], d2_clear[7:0], d3_clear[7:0]);
	
	// r8-r15 enable,
	or  or8   (r_enable[8],  d3_out[24], d0_out[8]);
	or  or9   (r_enable[9],  d3_out[25], d0_out[9]);
	or  or10  (r_enable[10], d3_out[26], d0_out[10]);
	or  or11  (r_enable[11], d3_out[27], d0_out[11]);
	or  or12  (r_enable[12], d3_out[28], d0_out[12]);
	or  or13  (r_enable[13], d3_out[29], d0_out[13]);
	or  or14  (r_enable[14], d3_out[30], d0_out[14]);
	or  or15  (r_enable[15], d3_out[31], d0_out[15]);
	
	// r8-r15 clear,
	or  or8_clear   (r_clear[8],  d3_clear[24], d0_clear[8]);
	or  or9_clear   (r_clear[9],  d3_clear[25], d0_clear[9]);
	or  or10_clear  (r_clear[10], d3_clear[26], d0_clear[10]);
	or  or11_clear  (r_clear[11], d3_clear[27], d0_clear[11]);
	or  or12_clear  (r_clear[12], d3_clear[28], d0_clear[12]);
	or  or13_clear  (r_clear[13], d3_clear[29], d0_clear[13]);
	or  or14_clear  (r_clear[14], d3_clear[30], d0_clear[14]);
	or  or15_clear  (r_clear[15], d3_clear[31], d0_clear[15]);

	// r16-23 enable,
	buf buf16 (r_enable[16], d0_out[16]);
	buf buf17 (r_enable[17], d0_out[17]);
	buf buf18 (r_enable[18], d0_out[18]);
	buf buf19 (r_enable[19], d0_out[19]);
	buf buf20 (r_enable[20], d0_out[20]);
	buf buf21 (r_enable[21], d0_out[21]);
	buf buf22 (r_enable[22], d0_out[22]);
	buf buf23 (r_enable[23], d0_out[23]);
	
	// r16-23 clear,
	buf buf16_clear (r_clear[16], d0_clear[16]);
	buf buf17_clear (r_clear[17], d0_clear[17]);
	buf buf18_clear (r_clear[18], d0_clear[18]);
	buf buf19_clear (r_clear[19], d0_clear[19]);
	buf buf20_clear (r_clear[20], d0_clear[20]);
	buf buf21_clear (r_clear[21], d0_clear[21]);
	buf buf22_clear (r_clear[22], d0_clear[22]);
	buf buf23_clear (r_clear[23], d0_clear[23]);

	// r24-31 enable,
	or  or24  (r_enable[24], d0_out[24], d1_out[8]);
	or  or25  (r_enable[25], d0_out[25], d1_out[9]);
	or  or26  (r_enable[26], d0_out[26], d1_out[10]);
	or  or27  (r_enable[27], d0_out[27], d1_out[11]);
	or  or28  (r_enable[28], d0_out[28], d1_out[12]);
	or  or29  (r_enable[29], d0_out[29], d1_out[13]);
	or  or30  (r_enable[30], d0_out[30], d1_out[14]);
	or  or31  (r_enable[31], d0_out[31], d1_out[15]);
	
	// r24-r31 clear,
	or  or24_clear  (r_clear[24], d0_clear[24], d1_clear[8]);
	or  or25_clear  (r_clear[25], d0_clear[25], d1_clear[9]);
	or  or26_clear  (r_clear[26], d0_clear[26], d1_clear[10]);
	or  or27_clear  (r_clear[27], d0_clear[27], d1_clear[11]);
	or  or28_clear  (r_clear[28], d0_clear[28], d1_clear[12]);
	or  or29_clear  (r_clear[29], d0_clear[29], d1_clear[13]);
	or  or30_clear  (r_clear[30], d0_clear[30], d1_clear[14]);
	or  or31_clear  (r_clear[31], d0_clear[31], d1_clear[15]);

	// r32-r39 enable,
	buf buf32 (r_enable[32], d1_out[16]);
	buf buf33 (r_enable[33], d1_out[17]);
	buf buf34 (r_enable[34], d1_out[18]);
	buf buf35 (r_enable[35], d1_out[19]);
	buf buf36 (r_enable[36], d1_out[20]);
	buf buf37 (r_enable[37], d1_out[21]);
	buf buf38 (r_enable[38], d1_out[22]);
	buf buf39 (r_enable[39], d1_out[23]);
	
	// r32-r39 clear,
	buf buf32_clear (r_clear[32], d1_clear[16]);
	buf buf33_clear (r_clear[33], d1_clear[17]);
	buf buf34_clear (r_clear[34], d1_clear[18]);
	buf buf35_clear (r_clear[35], d1_clear[19]);
	buf buf36_clear (r_clear[36], d1_clear[20]);
	buf buf37_clear (r_clear[37], d1_clear[21]);
	buf buf38_clear (r_clear[38], d1_clear[22]);
	buf buf39_clear (r_clear[39], d1_clear[23]);

	// r40-47 enable,
	or  or40  (r_enable[40], d1_out[24], d2_out[8]);
	or  or41  (r_enable[41], d1_out[25], d2_out[9]);
	or  or42  (r_enable[42], d1_out[26], d2_out[10]);
	or  or43  (r_enable[43], d1_out[27], d2_out[11]);
	or  or44  (r_enable[44], d1_out[28], d2_out[12]);
	or  or45  (r_enable[45], d1_out[29], d2_out[13]);
	or  or46  (r_enable[46], d1_out[30], d2_out[14]);
	or  or47  (r_enable[47], d1_out[31], d2_out[15]);
	
	// r40-47 clear,
	or  or40_clear  (r_clear[40], d1_clear[24], d2_clear[8]);
	or  or41_clear  (r_clear[41], d1_clear[25], d2_clear[9]);
	or  or42_clear  (r_clear[42], d1_clear[26], d2_clear[10]);
	or  or43_clear  (r_clear[43], d1_clear[27], d2_clear[11]);
	or  or44_clear  (r_clear[44], d1_clear[28], d2_clear[12]);
	or  or45_clear  (r_clear[45], d1_clear[29], d2_clear[13]);
	or  or46_clear  (r_clear[46], d1_clear[30], d2_clear[14]);
	or  or47_clear  (r_clear[47], d1_clear[31], d2_clear[15]);
	
	// r48-55 enable,
	buf buf48 (r_enable[48], d2_out[16]);
	buf buf49 (r_enable[49], d2_out[17]);
	buf buf50 (r_enable[50], d2_out[18]);
	buf buf51 (r_enable[51], d2_out[19]);
	buf buf52 (r_enable[52], d2_out[20]);
	buf buf53 (r_enable[53], d2_out[21]);
	buf buf54 (r_enable[54], d2_out[22]);
	buf buf55 (r_enable[55], d2_out[23]);
	
	// r48-55 clear,
	buf buf48_clear (r_clear[48], d2_clear[16]);
	buf buf49_clear (r_clear[49], d2_clear[17]);
	buf buf50_clear (r_clear[50], d2_clear[18]);
	buf buf51_clear (r_clear[51], d2_clear[19]);
	buf buf52_clear (r_clear[52], d2_clear[20]);
	buf buf53_clear (r_clear[53], d2_clear[21]);
	buf buf54_clear (r_clear[54], d2_clear[22]);
	buf buf55_clear (r_clear[55], d2_clear[23]);

	// r56-63 enable
	or  or56  (r_enable[56], d2_out[24], d3_out[8]);
	or  or57  (r_enable[57], d2_out[25], d3_out[9]);
	or  or58  (r_enable[58], d2_out[26], d3_out[10]);
	or  or59  (r_enable[59], d2_out[27], d3_out[11]);
	or  or60  (r_enable[60], d2_out[28], d3_out[12]);
	or  or61  (r_enable[61], d2_out[29], d3_out[13]);
	or  or62  (r_enable[62], d2_out[30], d3_out[14]);
	or  or63  (r_enable[63], d2_out[31], d3_out[15]);
	
	// r56-63 clear
	or  or56_clear  (r_clear[56], d2_clear[24], d3_clear[8]);
	or  or57_clear  (r_clear[57], d2_clear[25], d3_clear[9]);
	or  or58_clear  (r_clear[58], d2_clear[26], d3_clear[10]);
	or  or59_clear  (r_clear[59], d2_clear[27], d3_clear[11]);
	or  or60_clear  (r_clear[60], d2_clear[28], d3_clear[12]);
	or  or61_clear  (r_clear[61], d2_clear[29], d3_clear[13]);
	or  or62_clear  (r_clear[62], d2_clear[30], d3_clear[14]);
	or  or63_clear  (r_clear[63], d2_clear[31], d3_clear[15]);
	
	// 64-71 enable,
	buf buf64 (r_enable[64], d3_out[16]);
	buf buf65 (r_enable[65], d3_out[17]);
	buf buf66 (r_enable[66], d3_out[18]);
	buf buf67 (r_enable[67], d3_out[19]);
	buf buf68 (r_enable[68], d3_out[20]);
	buf buf69 (r_enable[69], d3_out[21]);
	buf buf70 (r_enable[70], d3_out[22]);
	buf buf71 (r_enable[71], d3_out[23]);
	
	// 64-71 clear,
	buf buf64_clear (r_clear[64], d3_clear[16]);
	buf buf65_clear (r_clear[65], d3_clear[17]);
	buf buf66_clear (r_clear[66], d3_clear[18]);
	buf buf67_clear (r_clear[67], d3_clear[19]);
	buf buf68_clear (r_clear[68], d3_clear[20]);
	buf buf69_clear (r_clear[69], d3_clear[21]);
	buf buf70_clear (r_clear[70], d3_clear[22]);
	buf buf71_clear (r_clear[71], d3_clear[23]);


	//---REGISTERS-----------------------------------------------------------------------------------------------------

	wire [31:0] r_out[71:0]; // 72 32-bit buses corresponding to the outputs of the registers

	// Global Registers r0-r7
	register_dummy_32 r0  (r_out[0], in, Clk); // r0 should always be 0. It is implemented with a dummy 32'b0 register

	register_32 r1  (r_out[1],  in, r_enable[1], r_clear[1], Clk);
	register_32 r2  (r_out[2],  in, r_enable[2], r_clear[2], Clk);
	register_32 r3  (r_out[3],  in, r_enable[3], r_clear[3], Clk);
	register_32 r4  (r_out[4],  in, r_enable[4], r_clear[4], Clk);
	register_32 r5  (r_out[5],  in, r_enable[5], r_clear[5], Clk);
	register_32 r6  (r_out[6],  in, r_enable[6], r_clear[6], Clk);
	register_32 r7  (r_out[7],  in, r_enable[7], r_clear[7], Clk);
	// Variable registers 
	// r8-r15
	register_32 r8  (r_out[8],  in, r_enable[8],  r_clear[8], Clk);
	register_32 r9  (r_out[9],  in, r_enable[9],  r_clear[9], Clk);
	register_32 r10 (r_out[10], in, r_enable[10], r_clear[10], Clk);
	register_32 r11 (r_out[11], in, r_enable[11], r_clear[11], Clk);
	register_32 r12 (r_out[12], in, r_enable[12], r_clear[12], Clk);
	register_32 r13 (r_out[13], in, r_enable[13], r_clear[13], Clk);
	register_32 r14 (r_out[14], in, r_enable[14], r_clear[14], Clk);
	register_32 r15 (r_out[15], in, r_enable[15], r_clear[15], Clk);
	// r16-r23
	register_32 r16 (r_out[16], in, r_enable[16], r_clear[16], Clk);
	register_32 r17 (r_out[17], in, r_enable[17], r_clear[17], Clk);
	register_32 r18 (r_out[18], in, r_enable[18], r_clear[18], Clk);
	register_32 r19 (r_out[19], in, r_enable[19], r_clear[19], Clk);
	register_32 r20 (r_out[20], in, r_enable[20], r_clear[20], Clk);
	register_32 r21 (r_out[21], in, r_enable[21], r_clear[21], Clk);
	register_32 r22 (r_out[22], in, r_enable[22], r_clear[22], Clk);
	register_32 r23 (r_out[23], in, r_enable[23], r_clear[23], Clk);
	// r24-r31
	register_32 r24 (r_out[24], in, r_enable[24], r_clear[24], Clk);
	register_32 r25 (r_out[25], in, r_enable[25], r_clear[25], Clk);
	register_32 r26 (r_out[26], in, r_enable[26], r_clear[26], Clk);
	register_32 r27 (r_out[27], in, r_enable[27], r_clear[27], Clk);
	register_32 r28 (r_out[28], in, r_enable[28], r_clear[28], Clk);
	register_32 r29 (r_out[29], in, r_enable[29], r_clear[29], Clk);
	register_32 r30 (r_out[30], in, r_enable[30], r_clear[30], Clk);
	register_32 r31 (r_out[31], in, r_enable[31], r_clear[31], Clk);
	// r32-r39
	register_32 r32 (r_out[32], in, r_enable[32], r_clear[32], Clk);
	register_32 r33 (r_out[33], in, r_enable[33], r_clear[33], Clk);
	register_32 r34 (r_out[34], in, r_enable[34], r_clear[34], Clk);
	register_32 r35 (r_out[35], in, r_enable[35], r_clear[35], Clk);
	register_32 r36 (r_out[36], in, r_enable[36], r_clear[36], Clk);
	register_32 r37 (r_out[37], in, r_enable[37], r_clear[37], Clk);
	register_32 r38 (r_out[38], in, r_enable[38], r_clear[38], Clk);
	register_32 r39 (r_out[39], in, r_enable[39], r_clear[39], Clk);
	// r40-r47
	register_32 r40 (r_out[40], in, r_enable[40], r_clear[40], Clk);
	register_32 r41 (r_out[41], in, r_enable[41], r_clear[41], Clk);
	register_32 r42 (r_out[42], in, r_enable[42], r_clear[42], Clk);
	register_32 r43 (r_out[43], in, r_enable[43], r_clear[43], Clk);
	register_32 r44 (r_out[44], in, r_enable[44], r_clear[44], Clk);
	register_32 r45 (r_out[45], in, r_enable[45], r_clear[45], Clk);
	register_32 r46 (r_out[46], in, r_enable[46], r_clear[46], Clk);
	register_32 r47 (r_out[47], in, r_enable[47], r_clear[47], Clk);
	// r48-r55
	register_32 r48 (r_out[48], in, r_enable[48], r_clear[48], Clk);
	register_32 r49 (r_out[49], in, r_enable[49], r_clear[49], Clk);
	register_32 r50 (r_out[50], in, r_enable[50], r_clear[50], Clk);
	register_32 r51 (r_out[51], in, r_enable[51], r_clear[51], Clk);
	register_32 r52 (r_out[52], in, r_enable[52], r_clear[52], Clk);
	register_32 r53 (r_out[53], in, r_enable[53], r_clear[53], Clk);
	register_32 r54 (r_out[54], in, r_enable[54], r_clear[54], Clk);
	register_32 r55 (r_out[55], in, r_enable[55], r_clear[55], Clk);
	// r56-r63
	register_32 r56 (r_out[56], in, r_enable[56], r_clear[56], Clk);
	register_32 r57 (r_out[57], in, r_enable[57], r_clear[57], Clk);
	register_32 r58 (r_out[58], in, r_enable[58], r_clear[58], Clk);
	register_32 r59 (r_out[59], in, r_enable[59], r_clear[59], Clk);
	register_32 r60 (r_out[60], in, r_enable[60], r_clear[60], Clk);
	register_32 r61 (r_out[61], in, r_enable[61], r_clear[61], Clk);
	register_32 r62 (r_out[62], in, r_enable[62], r_clear[62], Clk);
	register_32 r63 (r_out[63], in, r_enable[63], r_clear[63], Clk);
	// r64-r71
	register_32 r64 (r_out[64], in, r_enable[64], r_clear[64], Clk);
	register_32 r65 (r_out[65], in, r_enable[65], r_clear[65], Clk);
	register_32 r66 (r_out[66], in, r_enable[66], r_clear[66], Clk);
	register_32 r67 (r_out[67], in, r_enable[67], r_clear[67], Clk);
	register_32 r68 (r_out[68], in, r_enable[68], r_clear[68], Clk);
	register_32 r69 (r_out[69], in, r_enable[69], r_clear[69], Clk);
	register_32 r70 (r_out[70], in, r_enable[70], r_clear[70], Clk);
	register_32 r71 (r_out[71], in, r_enable[71], r_clear[71], Clk);


	//---MULTIPLEXING-FOR-OUTPUT---------------------------------------------------------------------------------------

	// Port A
	
	wire [31:0] mux_window_out0A;
	wire [31:0] mux_window_out1A;
	wire [31:0] mux_window_out2A;
	wire [31:0] mux_window_out3A;

	mux_32x1 mux_window0A(mux_window_out0A, in_PA, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[8],  r_out[9],  r_out[10], r_out[11], r_out[12], r_out[13], r_out[14], r_out[15], 
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23],
		r_out[24], r_out[25], r_out[26], r_out[27], r_out[28], r_out[29], r_out[30], r_out[31]
		);

	mux_32x1 mux_window1A(mux_window_out1A, in_PA, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[24], r_out[25], r_out[26], r_out[27], r_out[28], r_out[29], r_out[30], r_out[31], 
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39],
		r_out[40], r_out[41], r_out[42], r_out[43], r_out[44], r_out[45], r_out[46], r_out[47]
		);

	mux_32x1 mux_window2A(mux_window_out2A, in_PA, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[40], r_out[41], r_out[42], r_out[43], r_out[44], r_out[45], r_out[46], r_out[47], 
		r_out[48], r_out[49], r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55],
		r_out[56], r_out[57], r_out[58], r_out[59], r_out[60], r_out[61], r_out[62], r_out[63]
		);

	mux_32x1 mux_window3A(mux_window_out3A, in_PA, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[56], r_out[57], r_out[58], r_out[59], r_out[60], r_out[61], r_out[62], r_out[63], 
		r_out[64], r_out[65], r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71],
		r_out[8],  r_out[9],  r_out[10], r_out[11], r_out[12], r_out[13], r_out[14], r_out[15]
		);
	
	// Output for PA
	mux_4x1  mux_result(out_PA, current_window, mux_window_out0A, mux_window_out1A, mux_window_out2A, mux_window_out3A);
	
	// Port B
	
	wire [31:0] mux_window_out0B;
	wire [31:0] mux_window_out1B;
	wire [31:0] mux_window_out2B;
	wire [31:0] mux_window_out3B;

	mux_32x1 mux_window0B(mux_window_out0B, in_PB, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[8],  r_out[9],  r_out[10], r_out[11], r_out[12], r_out[13], r_out[14], r_out[15], 
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23],
		r_out[24], r_out[25], r_out[26], r_out[27], r_out[28], r_out[29], r_out[30], r_out[31]
		);

	mux_32x1 mux_window1B(mux_window_out1B, in_PB, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[24], r_out[25], r_out[26], r_out[27], r_out[28], r_out[29], r_out[30], r_out[31], 
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39],
		r_out[40], r_out[41], r_out[42], r_out[43], r_out[44], r_out[45], r_out[46], r_out[47]
		);

	mux_32x1 mux_window2B(mux_window_out2B, in_PB, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[40], r_out[41], r_out[42], r_out[43], r_out[44], r_out[45], r_out[46], r_out[47], 
		r_out[48], r_out[49], r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55],
		r_out[56], r_out[57], r_out[58], r_out[59], r_out[60], r_out[61], r_out[62], r_out[63]
		);

	mux_32x1 mux_window3B(mux_window_out3B, in_PB, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[56], r_out[57], r_out[58], r_out[59], r_out[60], r_out[61], r_out[62], r_out[63], 
		r_out[64], r_out[65], r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71],
		r_out[8],  r_out[9],  r_out[10], r_out[11], r_out[12], r_out[13], r_out[14], r_out[15]
		);
	
	// Output for PB
	mux_4x1  mux_result(out_PB, current_window, mux_window_out0B, mux_window_out1B, mux_window_out2B, mux_window_out3B);

endmodule
