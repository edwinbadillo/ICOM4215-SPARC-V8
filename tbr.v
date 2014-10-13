module tbr(output reg [31:0] out, input wire [19:0] TBA, input wire [7:0] tt, input wire enable, Clr, Clk);
	
	//---DESCRIPTION---------------------------------------------------------------------------------------------------
	// This module represents the Trap Base Register(TBR) in the SPARC architecture version 8.
	// The TBR contains 3 fields that together equal the address to which control is transferred when a trap occurs.
	// +-----------------------------------+
	// | TBA[31:12] | tt[11:4] | zero[3:0] |
	// +-----------------------------------+
	// 
	// Trab Base Address(TBA) : Bits 31 through 12 are the trap base address, which is established by supervisor 
	//                          software. It contains the most significant 20 bits of the trap table address. The
	//                          TBA field is written by the WRTBR instruction.
	// Trap_type(tt)          : Bits 11 through 4 comprise the trap type field. Written by hardware when a trap 
	//                          occurs, and retains its value until the next trap. It provides an offset into the
	//                          trap table. The WRTBR instruction does not affect the tt field.
	// zero                   : Bits 3 through 0 are hardcoded zeros.
	//-----------------------------------------------------------------------------------------------------------------

	//---PARAMETERS-SUMMARY--------------------------------------------------------------------------------------------
	// out    : 32-bit output bus that serves as the output of the TBR contents
	// TBA    : 20-bit input bus for the Trap Base Address field
	// tt     : 8-bit input bus used to write over the trap_type section of the tbr
	// enable : 1-bit write enable signal
	// Clr    : 1-bit asynchronous clear signal
	// Clk    : 1-bit system clock signal
	//-----------------------------------------------------------------------------------------------------------------

	initial
		out[3:0]=0;
	always @ (posedge Clk, posedge Clr)
		if (Clr) out <= 32'h00000000; // Clr = 1, clears register by writing '0' to all 32 bits
		else if (enable) begin
			out[31:12] <= TBA;
			out[11:4]  <= tt;
		end
endmodule

