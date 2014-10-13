

module psr(output reg [31:0] out, input wire [3:0] icc_in, input wire [4:0] cwp_in, input wire [1:0] trap, input wire enable, Clr, Clk);
	
	//---DESCRIPTION---------------------------------------------------------------------------------------------------
	// This module represents the Processor State Register(TBR) in the SPARC architecture version 8.
	// The PSR contains various fields that control the processor and hold status information.
	// 
	// +-------------+------------+------------+-----------------+--------+--------+-----------+------+-------+-------+----------+
	// | impl[31:28] | ver[27:24] | icc[23:20] | reserved[19:14] | EC[13] | EF[12] | PIL[11:8] | S[7] | PS[6] | ET[5] | CWP[4:0] |
	// +-------------+------------+------------+-----------------+--------+--------+-----------+------+-------+-------+----------+
	// 
	// 
	// impl     : Bits 31 through 28 are hardwired to 0xF to denote the implementation characteristics
	// ver      : Bits 27 through 24 are hardwired to 0x6 to denote an implementation version
	// icc      : Bits 23 through 20 are the IU's condition codes, where PSR[23]=N, PSR[22]=Z, PSR[21]=V, PSR[20]=C
	// reserved : Bits 19 through 14 are hardwired to 0, because they are reserved by the SPARC specification
	// EC       : Bit 13 determines whether or not the coprocessor is enabled. Hardwired to 0;
	// EF       : Bit 12 determines whether the FPU is enabled. Hardwired to 0;
	// PIL      : Bits 11 through 8 identify the interrupt above which the processor will accept an interrupt. Hardwired to 0.
	// S        : Bit 7 determines whether the processor is in supervisor mode. 1 = supervisor mode, 0 = user mode.
	// PS       : Bit 6 contains the value of the S bit at the time of the most recent trap.
	// ET       : Bit 5 determines whether traps are enabled(1=enabled). A trap automatically sets ET to 0.
	// CWP      : Bits 4 through 0 represent the current window pointer.
	//-----------------------------------------------------------------------------------------------------------------

	//---PARAMETERS-SUMMARY--------------------------------------------------------------------------------------------
	// out    : 32-bit output bus that serves as the output of the PSR contents
	// icc_in : 4-bit input bus for the integer unit condition codes {N,Z,V,C}
	// cwp_in : 5-bit input bus used to write to the cwp
	// trap   : 2-bit input bus used to handle trap or rett ***
	// enable : 1-bit write enable signal
	// Clr    : 1-bit asynchronous clear signal
	// Clk    : 1-bit system clock signal
	//-----------------------------------------------------------------------------------------------------------------

	initial
		out <= 32'hf6000020;
		/*
		PSR impl: 0xF -> Reserved
		PSR ver : 0x6 -> Reserved
		PSR ET  : 0x1 -> Traps Enabled	
		*/
		
	always @ (posedge Clk, posedge Clr)
		if (Clr) out <= 32'hf6000020; //Clr = 1, clears register's writeable bits by writing '0' 
		else if (enable) begin
			out[23:20] <= icc_in; 
			out[4:0]   <= cwp_in;

			if(trap==1) begin //Trap Enabled ->page 75
				out[5] <= 0; //ET
				out[6] <= out[7]; //PS<=S
				out[7] <= 1; //S
			end
			if(trap==2) begin //Rett Enabled
				out[5] <= 1; //ET
				out[6] <= out[7]; //PS<=S
				out[7] <= 0; //S
			end
		end
endmodule 
