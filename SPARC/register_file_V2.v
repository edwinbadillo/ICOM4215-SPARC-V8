// Register file
// Contains 72 registers and implements the register windows specification

module register_file(output [31:0] out_PA, output [31:0] out_PB, input [31:0] in,  input [4:0] in_PA, input [4:0] in_PB, input [4:0] in_PC, input enable, Clr, Clk, input [1:0] current_window); // still missing some arguments

	//---PARAMETERS-SUMMARY--------------------------------------------------------------------------------------------
	// out_PA         : 32-bit bus that serves as output for input PA
	// out_PB         : 32-bit bus that serves as output for input PB
	// in			  : 32-bit bus corresponding to the data to be written
	// in_PA          : 5-bit address bus that will choose the output of out_A
	// in_PB          : 5-bit address bus that will choose the output of out_B
	// in_PC          : 5-bit address bus that will choose which register will be written or cleared
	// enable         : Bit used to enable writing to a register in the register file
	// Clr            : Asynchronous Clear Signal
	// Clk            : System clock
	// current_window : The current register window in play. Usually provided by the CU from the CWP (current window pointer)
	//-----------------------------------------------------------------------------------------------------------------


	//---DECODER-LOGIC-FOR-CHOOSING-CORRECT-REGISTER-BASED-ON-CURRENT-WINDOW FOR ENABLING-------------------------------------------

	wire [3:0]  d_window_out; // 4-bit bus that is the output of the enable decoder in charge of choosing the current register window
	
	wire [31:0] d3_out; // The output of the decoder used for choosing a register in window 3
	wire [31:0] d2_out; // The output of the decoder used for choosing a register in window 2
	wire [31:0] d1_out; // The output of the decoder used for choosing a register in window 1
	wire [31:0] d0_out; // The output of the decoder used for choosing a register in window 0
	

	decoder_2x4 d_window(d_window_out, current_window, enable); // This decoder chooses the window

	// Each one chooses one out of the 32 visible registers in the current window
	decoder_5x32 d3(d3_out, in_PC, d_window_out[3]);
	decoder_5x32 d2(d2_out, in_PC, d_window_out[2]);
	decoder_5x32 d1(d1_out, in_PC, d_window_out[1]);
	decoder_5x32 d0(d0_out, in_PC, d_window_out[0]);
	
	//---DECODER-LOGIC-FOR-CHOOSING-CORRECT-REGISTER-BASED-ON-CURRENT-WINDOW FOR CLEARING-------------------------------------------
	
	wire [3:0]  d_window_out_clear; // 4-bit bus that is the output of the clear decoder in charge of choosing the current register window
	
	wire [31:0] d3_clear;
	wire [31:0] d2_clear;
	wire [31:0] d1_clear;
	wire [31:0] d0_clear; // The output of the decoder used for clearing a register in window 0

	decoder_2x4 d_window_clear(d_window_out_clear, current_window, Clr); // This decoder chooses the window for clearing

	// Each one chooses one out of the 32 visible registers in the current window to be cleared	
	decoder_5x32 c3(d3_clear, in_PC, d_window_out_clear[3]);
	decoder_5x32 c2(d2_clear, in_PC, d_window_out_clear[2]);
	decoder_5x32 c1(d1_clear, in_PC, d_window_out_clear[1]);
	decoder_5x32 c0(d0_clear, in_PC, d_window_out_clear[0]);
	
	
	//---INTERCONNECTION-OF-CLEAR-AND-ENABLE-SIGNALS-TO-THE-REGISTERS--------------------------------------------------------------------------------------
	
	wire [71:0] r_enable; // a 72-bit bus for enabling each of the registers
	wire [71:0] r_clear;  // a 72-bit bus for clearing each of the registers

	// Mux for enabling global registers r0-r7
	mux_8_4x1 mux_global(r_enable[7:0], current_window, d0_out[7:0], d1_out[7:0], d2_out[7:0], d3_out[7:0]);
	// Mux for clearing global registers r0-r7
	mux_8_4x1 mux_global_clear(r_clear[7:0], current_window, d0_clear[7:0], d1_clear[7:0], d2_clear[7:0], d3_clear[7:0]);
	

	// Window 3: Inputs  (r31-r24 del window 3) 
	// Window 0: Outputs (r15-r8  del window 0) 
	// 71-64  enable,
	or or71 (r_enable[71], d3_out[31], d0_out[15]);
	or or70 (r_enable[70], d3_out[30], d0_out[14]);
	or or69 (r_enable[69], d3_out[29], d0_out[13]);
	or or68 (r_enable[68], d3_out[28], d0_out[12]);
	or or67 (r_enable[67], d3_out[27], d0_out[11]);
	or or66 (r_enable[66], d3_out[26], d0_out[10]);
	or or65 (r_enable[65], d3_out[25], d0_out[9]);
	or or64 (r_enable[64], d3_out[24], d0_out[8]);

	// 71-64 clear,
	or or71_clear (r_clear[71], d3_clear[31], d0_clear[15]);
	or or70_clear (r_clear[70], d3_clear[30], d0_clear[14]);
	or or69_clear (r_clear[69], d3_clear[29], d0_clear[13]);
	or or68_clear (r_clear[68], d3_clear[28], d0_clear[12]);
	or or67_clear (r_clear[67], d3_clear[27], d0_clear[11]);
	or or66_clear (r_clear[66], d3_clear[26], d0_clear[10]);
	or or65_clear (r_clear[65], d3_clear[25], d0_clear[9]);
	or or64_clear (r_clear[64], d3_clear[24], d0_clear[8]);

	// Window 3: Local (r23-r16 del window 3) 
	// r63-56 enable
	buf buf63  (r_enable[63], d3_out[23]); 
	buf buf62  (r_enable[62], d3_out[22]); 
	buf buf61  (r_enable[61], d3_out[21]); 
	buf buf60  (r_enable[60], d3_out[20]); 
	buf buf59  (r_enable[59], d3_out[19]); 
	buf buf58  (r_enable[58], d3_out[18]);
	buf buf57  (r_enable[57], d3_out[17]); 
	buf buf56  (r_enable[56], d3_out[16]); 

	// r63-56 clear
	buf buf63_clear  (r_clear[63], d3_clear[23]); 
	buf buf62_clear  (r_clear[62], d3_clear[22]); 
	buf buf61_clear  (r_clear[61], d3_clear[21]); 
	buf buf60_clear  (r_clear[60], d3_clear[20]); 
	buf buf59_clear  (r_clear[59], d3_clear[19]); 
	buf buf58_clear  (r_clear[58], d3_clear[18]); 
	buf buf57_clear  (r_clear[57], d3_clear[17]); 
	buf buf56_clear  (r_clear[56], d3_clear[16]); 

	// Window 3: Outputs (r15-r8  del window 3)
	// Window 2: Inputs  (r31-r24 del window 2) 
	// r55-48 enable,
	or or55 (r_enable[55], d3_out[15],  d2_out[31]);
	or or54 (r_enable[54], d3_out[14],  d2_out[30]);
	or or53 (r_enable[53], d3_out[13],  d2_out[29]);
	or or52 (r_enable[52], d3_out[12],  d2_out[28]);
	or or51 (r_enable[51], d3_out[11],  d2_out[27]);
	or or50 (r_enable[50], d3_out[10],  d2_out[26]);
	or or49 (r_enable[49], d3_out[9],  d2_out[25]);
	or or48 (r_enable[48], d3_out[8],  d2_out[24]);

	// r55-48 clear,
	or or55_clear (r_clear[55], d3_clear[15],  d2_clear[31]);
	or or54_clear (r_clear[54], d3_clear[14],  d2_clear[30]);
	or or53_clear (r_clear[53], d3_clear[13],  d2_clear[29]);
	or or52_clear (r_clear[52], d3_clear[12],  d2_clear[28]);
	or or51_clear (r_clear[51], d3_clear[11],  d2_clear[27]);
	or or50_clear (r_clear[50], d3_clear[10],  d2_clear[26]);
	or or49_clear (r_clear[49], d3_clear[9],  d2_clear[25]);
	or or48_clear (r_clear[48], d3_clear[8],  d2_clear[24]);

	// Window 2: Local (r23-r16 del window 2) 
	// r47-40 enable,
	buf buf47  (r_enable[47], d2_out[23]);
	buf buf46  (r_enable[46], d2_out[22]);
	buf buf45  (r_enable[45], d2_out[21]);
	buf buf44  (r_enable[44], d2_out[20]);
	buf buf43  (r_enable[43], d2_out[19]);
	buf buf42  (r_enable[42], d2_out[18]);
	buf buf41  (r_enable[41], d2_out[17]);
	buf buf40  (r_enable[40], d2_out[16]);
	

	// r47-40 clear,
	buf buf47_clear  (r_clear[47], d2_clear[23]);
	buf buf46_clear  (r_clear[46], d2_clear[22]);
	buf buf45_clear  (r_clear[45], d2_clear[21]);
	buf buf44_clear  (r_clear[44], d2_clear[20]);
	buf buf43_clear  (r_clear[43], d2_clear[19]);
	buf buf42_clear  (r_clear[42], d2_clear[18]);
	buf buf41_clear  (r_clear[41], d2_clear[17]);
	buf buf40_clear  (r_clear[40], d2_clear[16]);
	
	// Window 2: Outputs (r15-r8  del window 2)
	// Window 1: Inputs  (r31-r24 del window 1) 
	// r39-32 enable,
	or or39 (r_enable[39], d2_out[15], d1_out[31]);
	or or38 (r_enable[38], d2_out[14], d1_out[30]);
	or or37 (r_enable[37], d2_out[13], d1_out[29]);
	or or36 (r_enable[36], d2_out[12], d1_out[28]);
	or or35 (r_enable[35], d2_out[11], d1_out[27]);
	or or34 (r_enable[34], d2_out[10], d1_out[26]);
	or or33 (r_enable[33], d2_out[9], d1_out[25]);
	or or32 (r_enable[32], d2_out[8], d1_out[24]);

	// r39-32 clear,
	or or39_clear (r_clear[39], d2_clear[15], d1_clear[31]);
	or or38_clear (r_clear[38], d2_clear[14], d1_clear[30]);
	or or37_clear (r_clear[37], d2_clear[13], d1_clear[29]);
	or or36_clear (r_clear[36], d2_clear[12], d1_clear[28]);
	or or35_clear (r_clear[35], d2_clear[11], d1_clear[27]);
	or or34_clear (r_clear[34], d2_clear[10], d1_clear[26]);
	or or33_clear (r_clear[33], d2_clear[9], d1_clear[25]);
	or or32_clear (r_clear[32], d2_clear[8], d1_clear[24]);

	// Window 1: Local (r23-r16 del window 1) 
	// r31-24 enable,
	buf buf31  (r_enable[31], d1_out[23]);
	buf buf30  (r_enable[30], d1_out[22]);
	buf buf29  (r_enable[29], d1_out[21]);
	buf buf28  (r_enable[28], d1_out[20]);
	buf buf27  (r_enable[27], d1_out[19]);
	buf buf26  (r_enable[26], d1_out[18]);
	buf buf25  (r_enable[25], d1_out[17]);
	buf buf24  (r_enable[24], d1_out[16]);

	// r31-24 clear,
	buf buf31_clear  (r_clear[31], d1_clear[23]);
	buf buf30_clear  (r_clear[30], d1_clear[22]);
	buf buf29_clear  (r_clear[29], d1_clear[21]);
	buf buf28_clear  (r_clear[28], d1_clear[20]);
	buf buf27_clear  (r_clear[27], d1_clear[19]);
	buf buf26_clear  (r_clear[26], d1_clear[18]);
	buf buf25_clear  (r_clear[25], d1_clear[17]);
	buf buf24_clear  (r_clear[24], d1_clear[16]);

	// Window 1: Outputs (r15-r8  del window 1)
	// Window 0: Inputs  (r31-r24 del window 0) 
	// r23-16 enable,
	or or23 (r_enable[23], d1_out[15], d0_out[31]);
	or or22 (r_enable[22], d1_out[14], d0_out[30]);
	or or21 (r_enable[21], d1_out[13], d0_out[29]);
	or or20 (r_enable[20], d1_out[12], d0_out[28]);
	or or19 (r_enable[19], d1_out[11], d0_out[27]);
	or or18 (r_enable[18], d1_out[10], d0_out[26]);
	or or17 (r_enable[17], d1_out[9], d0_out[25]);
	or or16 (r_enable[16], d1_out[8], d0_out[24]);

	// r23-16 clear,
	or or23_clear (r_clear[23], d1_clear[15], d0_clear[23]);
	or or22_clear (r_clear[22], d1_clear[14], d0_clear[22]);
	or or21_clear (r_clear[21], d1_clear[13], d0_clear[21]);
	or or20_clear (r_clear[20], d1_clear[12], d0_clear[20]);
	or or19_clear (r_clear[19], d1_clear[11], d0_clear[19]);
	or or18_clear (r_clear[18], d1_clear[10], d0_clear[18]);
	or or17_clear (r_clear[17], d1_clear[9], d0_clear[17]);
	or or16_clear (r_clear[16], d1_clear[8], d0_clear[16]);

	// Window 0: Local (r23-r16 del window 0) 
	// r15-8 enable,
	buf buf15  (r_enable[15], d0_out[23]);
	buf buf14  (r_enable[14], d0_out[22]);
	buf buf13  (r_enable[13], d0_out[21]);
	buf buf12  (r_enable[12], d0_out[20]);
	buf buf11  (r_enable[11], d0_out[19]);
	buf buf10  (r_enable[10], d0_out[18]);
	buf buf9   (r_enable[9],  d0_out[17]);
	buf buf8   (r_enable[8],  d0_out[16]);

	// r15-8 clear,
	buf buf15_clear  (r_clear[15], d0_clear[23]);
	buf buf14_clear  (r_clear[14], d0_clear[22]);
	buf buf13_clear  (r_clear[13], d0_clear[21]);
	buf buf12_clear  (r_clear[12], d0_clear[20]);
	buf buf11_clear  (r_clear[11], d0_clear[19]);
	buf buf10_clear  (r_clear[10], d0_clear[18]);
	buf buf9_clear   (r_clear[9],  d0_clear[17]);
	buf buf8_clear   (r_clear[8],  d0_clear[16]);



	//---REGISTERS-----------------------------------------------------------------------------------------------------

	wire [31:0] r_out[71:0]; // 72 32-bit buses corresponding to the outputs of the registers

	// Global Registers r0-r7
	register_32 r7  (r_out[7],  in, r_enable[7], r_clear[7], Clk);
	register_32 r6  (r_out[6],  in, r_enable[6], r_clear[6], Clk);
	register_32 r5  (r_out[5],  in, r_enable[5], r_clear[5], Clk);
	register_32 r4  (r_out[4],  in, r_enable[4], r_clear[4], Clk);
	register_32 r3  (r_out[3],  in, r_enable[3], r_clear[3], Clk);
	register_32 r2  (r_out[2],  in, r_enable[2], r_clear[2], Clk);
	register_32 r1  (r_out[1],  in, r_enable[1], r_clear[1], Clk);
	register_dummy_32 r0  (r_out[0], in, Clk); // r0 should always be 0. It is implemented with a dummy 32'b0 register
	
	// Variable registers

	// Window 3: Inputs  (r31-r24 del window 3) 
	// Window 0: Outputs (r15-r8  del window 0) 
	register_32 r71 (r_out[71], in, r_enable[71], r_clear[71], Clk);
	register_32 r70 (r_out[70], in, r_enable[70], r_clear[70], Clk);
	register_32 r69 (r_out[69], in, r_enable[69], r_clear[69], Clk);
	register_32 r68 (r_out[68], in, r_enable[68], r_clear[68], Clk);
	register_32 r67 (r_out[67], in, r_enable[67], r_clear[67], Clk);
	register_32 r66 (r_out[66], in, r_enable[66], r_clear[66], Clk);
	register_32 r65 (r_out[65], in, r_enable[65], r_clear[65], Clk);
	register_32 r64 (r_out[64], in, r_enable[64], r_clear[64], Clk);
	
	// Window 3: Local (r23-r16 del window 3) 
	register_32 r63 (r_out[63], in, r_enable[63], r_clear[63], Clk);
	register_32 r62 (r_out[62], in, r_enable[62], r_clear[62], Clk);
	register_32 r61 (r_out[61], in, r_enable[61], r_clear[61], Clk);
	register_32 r60 (r_out[60], in, r_enable[60], r_clear[60], Clk);
	register_32 r59 (r_out[59], in, r_enable[59], r_clear[59], Clk);
	register_32 r58 (r_out[58], in, r_enable[58], r_clear[58], Clk);
	register_32 r57 (r_out[57], in, r_enable[57], r_clear[57], Clk);
	register_32 r56 (r_out[56], in, r_enable[56], r_clear[56], Clk);

	// Window 3: Outputs (r15-r8  del window 3)
	// Window 2: Inputs  (r31-r24 del window 2) 
	register_32 r55 (r_out[55], in, r_enable[55], r_clear[55], Clk);
	register_32 r54 (r_out[54], in, r_enable[54], r_clear[54], Clk);
	register_32 r53 (r_out[53], in, r_enable[53], r_clear[53], Clk);
	register_32 r52 (r_out[52], in, r_enable[52], r_clear[52], Clk);
	register_32 r51 (r_out[51], in, r_enable[51], r_clear[51], Clk);
	register_32 r50 (r_out[50], in, r_enable[50], r_clear[50], Clk);
	register_32 r49 (r_out[49], in, r_enable[49], r_clear[49], Clk);
	register_32 r48 (r_out[48], in, r_enable[48], r_clear[48], Clk);
	
	// Window 2: Local (r23-r16 del window 2) 
	register_32 r47 (r_out[47], in, r_enable[47], r_clear[47], Clk);
	register_32 r46 (r_out[46], in, r_enable[46], r_clear[46], Clk);
	register_32 r45 (r_out[45], in, r_enable[45], r_clear[45], Clk);
	register_32 r44 (r_out[44], in, r_enable[44], r_clear[44], Clk);
	register_32 r43 (r_out[43], in, r_enable[43], r_clear[43], Clk);
	register_32 r42 (r_out[42], in, r_enable[42], r_clear[42], Clk);
	register_32 r41 (r_out[41], in, r_enable[41], r_clear[41], Clk);
	register_32 r40 (r_out[40], in, r_enable[40], r_clear[40], Clk);

	// Window 2: Outputs (r15-r8  del window 2)
	// Window 1: Inputs  (r31-r24 del window 1) 
	register_32 r39 (r_out[39], in, r_enable[39], r_clear[39], Clk);
	register_32 r38 (r_out[38], in, r_enable[38], r_clear[38], Clk);
	register_32 r37 (r_out[37], in, r_enable[37], r_clear[37], Clk);
	register_32 r36 (r_out[36], in, r_enable[36], r_clear[36], Clk);
	register_32 r35 (r_out[35], in, r_enable[35], r_clear[35], Clk);
	register_32 r34 (r_out[34], in, r_enable[34], r_clear[34], Clk);
	register_32 r33 (r_out[33], in, r_enable[33], r_clear[33], Clk);
	register_32 r32 (r_out[32], in, r_enable[32], r_clear[32], Clk);
	
	
	// Window 1: Local (r23-r16 del window 1) 
	register_32 r31 (r_out[31], in, r_enable[31], r_clear[31], Clk);
	register_32 r30 (r_out[30], in, r_enable[30], r_clear[30], Clk);
	register_32 r29 (r_out[29], in, r_enable[29], r_clear[29], Clk);
	register_32 r28 (r_out[28], in, r_enable[28], r_clear[28], Clk);
	register_32 r27 (r_out[27], in, r_enable[27], r_clear[27], Clk);
	register_32 r26 (r_out[26], in, r_enable[26], r_clear[26], Clk);
	register_32 r25 (r_out[25], in, r_enable[25], r_clear[25], Clk);
	register_32 r24 (r_out[24], in, r_enable[24], r_clear[24], Clk);	
	
	// Window 1: Outputs (r15-r8  del window 1)
	// Window 0: Inputs  (r31-r24 del window 0) 
	register_32 r23 (r_out[23], in, r_enable[23], r_clear[23], Clk);
	register_32 r22 (r_out[22], in, r_enable[22], r_clear[22], Clk);
	register_32 r21 (r_out[21], in, r_enable[21], r_clear[21], Clk);
	register_32 r20 (r_out[20], in, r_enable[20], r_clear[20], Clk);
	register_32 r19 (r_out[19], in, r_enable[19], r_clear[19], Clk);
	register_32 r18 (r_out[18], in, r_enable[18], r_clear[18], Clk);
	register_32 r17 (r_out[17], in, r_enable[17], r_clear[17], Clk);
	register_32 r16 (r_out[16], in, r_enable[16], r_clear[16], Clk);
	
	// Window 0: Local (r23-r16 del window 0) 
	register_32 r15 (r_out[15], in, r_enable[15], r_clear[15], Clk);
	register_32 r14 (r_out[14], in, r_enable[14], r_clear[14], Clk);
	register_32 r13 (r_out[13], in, r_enable[13], r_clear[13], Clk);
	register_32 r12 (r_out[12], in, r_enable[12], r_clear[12], Clk);
	register_32 r11 (r_out[11], in, r_enable[11], r_clear[11], Clk);
	register_32 r10 (r_out[10], in, r_enable[10], r_clear[10], Clk);
	register_32 r9  (r_out[9],  in, r_enable[9],  r_clear[9], Clk);
	register_32 r8  (r_out[8],  in, r_enable[8],  r_clear[8], Clk);



	//---MULTIPLEXING-FOR-OUTPUT---------------------------------------------------------------------------------------

	// Port A
	
	wire [31:0] mux_window_out0A;
	wire [31:0] mux_window_out1A;
	wire [31:0] mux_window_out2A;
	wire [31:0] mux_window_out3A;

	mux_32x1 mux_window0A(mux_window_out0A, in_PA, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[64],  r_out[65],  r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71], 
		r_out[8], r_out[9], r_out[10], r_out[11], r_out[12], r_out[13], r_out[14], r_out[15],
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23]
		);

	mux_32x1 mux_window1A(mux_window_out1A, in_PA, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23], 
		r_out[24], r_out[25], r_out[26], r_out[27], r_out[28], r_out[29], r_out[30], r_out[31],
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39]
		);
		
	mux_32x1 mux_window2A(mux_window_out2A, in_PA, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39], 
		r_out[40], r_out[41], r_out[42], r_out[43], r_out[44], r_out[45], r_out[46], r_out[47],
		r_out[48], r_out[49], r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55]
		);

	mux_32x1 mux_window3A(mux_window_out3A, in_PA, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[48],  r_out[49],  r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55], 
		r_out[56], r_out[57], r_out[58], r_out[59], r_out[60], r_out[61], r_out[62], r_out[63],
		r_out[64], r_out[65], r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71]
		);
	
	// Output for PA
	mux_32_4x1  mux_resultA(out_PA, current_window, mux_window_out0A, mux_window_out1A, mux_window_out2A, mux_window_out3A);
	
	// Port B
	
	wire [31:0] mux_window_out0B;
	wire [31:0] mux_window_out1B;
	wire [31:0] mux_window_out2B;
	wire [31:0] mux_window_out3B;

	mux_32x1 mux_window0B(mux_window_out0B, in_PB, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[64],  r_out[65],  r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71], 
		r_out[8], r_out[9], r_out[10], r_out[11], r_out[12], r_out[13], r_out[14], r_out[15],
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23]
		);

	mux_32x1 mux_window1B(mux_window_out1B, in_PB, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[16], r_out[17], r_out[18], r_out[19], r_out[20], r_out[21], r_out[22], r_out[23], 
		r_out[24], r_out[25], r_out[26], r_out[27], r_out[28], r_out[29], r_out[30], r_out[31],
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39]
		);
		
	mux_32x1 mux_window2B(mux_window_out2B, in_PB, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[32], r_out[33], r_out[34], r_out[35], r_out[36], r_out[37], r_out[38], r_out[39], 
		r_out[40], r_out[41], r_out[42], r_out[43], r_out[44], r_out[45], r_out[46], r_out[47],
		r_out[48], r_out[49], r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55]
		);

	mux_32x1 mux_window3B(mux_window_out3B, in_PB, 
		r_out[0], r_out[1], r_out[2], r_out[3], r_out[4], r_out[5], r_out[6], r_out[7], 
		r_out[48],  r_out[49],  r_out[50], r_out[51], r_out[52], r_out[53], r_out[54], r_out[55], 
		r_out[56], r_out[57], r_out[58], r_out[59], r_out[60], r_out[61], r_out[62], r_out[63],
		r_out[64], r_out[65], r_out[66], r_out[67], r_out[68], r_out[69], r_out[70], r_out[71]
		);
	
	// Output for PB
	mux_32_4x1  mux_resultB(out_PB, current_window, mux_window_out0B, mux_window_out1B, mux_window_out2B, mux_window_out3B);

endmodule
