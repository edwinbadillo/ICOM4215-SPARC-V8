module test_memory_console;

	// Inputs
	reg [5:0]OpCode; 
	reg signed [31:0]MDR_DataIn;
	reg signed [6:0]MAR_Address;
	reg enable;

	// Outputs
	wire signed [31:0]MDR_DataOut;
	wire MFC;
	
	parameter sim_time = 800;
	
	`define LOAD_W 6'b000000
	`define LOAD_UB 6'b000001
	`define LOAD_UHW 6'b000010
	`define LOAD_SB 6'b001001
	`define LOAD_SHW 6'b001010
	
	`define STORE_W 6'b000100
	`define STORE_B 6'b000101
	`define STORE_HW 6'b000110

	ram256x8 ram (MDR_DataOut, MFC, enable, OpCode, MAR_Address, MDR_DataIn);

	// End simulation at sim_time
	initial #sim_time $finish;

	// Initialize files and monitor
	initial begin
		MAR_Address = 0;
		enable = 1;
		$display ("In \t Out \t MFC Enable");
		$monitor ("%0d \t %0d \t %0b \t %0b", MDR_DataIn, MDR_DataOut, MFC, enable);
	end

	initial begin
		// Store Word
		MDR_DataIn = 234512;
		OpCode = `STORE_W;
		// Wait for memory
		# 6;
		$display("Storing Word at Address 0");
		$display("Address %0d Value %b", MAR_Address, ram.Mem[MAR_Address]);
		$display("Address %0d Value %b", MAR_Address + 1, ram.Mem[MAR_Address + 1]);
		$display("Address %0d Value %b", MAR_Address + 2, ram.Mem[MAR_Address + 2]);
		$display("Address %0d Value %b", MAR_Address + 3, ram.Mem[MAR_Address + 3]);
		MAR_Address = MAR_Address + 4;
		// Store Byte
		MDR_DataIn = 5;
		OpCode = `STORE_B;
		// Wait for memory
		# 6;
		$display("Storing Byte at Address 4");
		$display("Address %0d Value %b", MAR_Address, ram.Mem[MAR_Address]);
		$display("Address %0d Value %b", MAR_Address + 1, ram.Mem[MAR_Address + 1]);
		$display("Address %0d Value %b", MAR_Address + 2, ram.Mem[MAR_Address + 2]);
		$display("Address %0d Value %b", MAR_Address + 3, ram.Mem[MAR_Address + 3]);
		MAR_Address = MAR_Address + 4;
		// Store halfword
		MDR_DataIn = 1234;
		OpCode = `STORE_HW;
		// Wait for memory
		# 6;
		$display("Storing halfword at Address 8");
		$display("Address %0d Value %b", MAR_Address, ram.Mem[MAR_Address]);
		$display("Address %0d Value %b", MAR_Address + 1, ram.Mem[MAR_Address + 1]);
		$display("Address %0d Value %b", MAR_Address + 2, ram.Mem[MAR_Address + 2]);
		$display("Address %0d Value %b", MAR_Address + 3, ram.Mem[MAR_Address + 3]);
		MAR_Address = MAR_Address + 4;
		// Load Word
		$display("Loading Word at Address 0");
		MAR_Address = 0;
		OpCode = `LOAD_W;
		#6;
		// Load Unsigned Byte
		$display("Loading Unsigned Byte at Address 4");
		MAR_Address = 4;
		OpCode = `LOAD_UB;
		#6;
		// Load Signed Byte 
		$display("Loading signed Byte at Address 4");
		MAR_Address = 4;
		OpCode = `LOAD_SB;
		#6;
		// Load Unsigned Halfword 
		$display("Loading Unsigned Halfword at Address 8");
		MAR_Address = 8;
		OpCode = `LOAD_UHW;
		#6;
		// Load Signed Halfword 
		$display("Loading signed Halfword at Address 8");
		MAR_Address = 8;
		OpCode = `LOAD_SHW;
		#6;
		// Store Byte (Testing signed store and load)
		$display("Storing Signed Byte at Address 4");
		MDR_DataIn = -5;
		MAR_Address = 4;
		OpCode = `STORE_B;
		// Wait for memory
		# 6;
		$display("Address %0d Value %b", MAR_Address, ram.Mem[MAR_Address]);
		$display("Address %0d Value %b", MAR_Address + 1, ram.Mem[MAR_Address + 1]);
		$display("Address %0d Value %b", MAR_Address + 2, ram.Mem[MAR_Address + 2]);
		$display("Address %0d Value %b", MAR_Address + 3, ram.Mem[MAR_Address + 3]);
		MAR_Address = MAR_Address + 4;
		// Load Signed Byte 
		$display("Loading signed Byte at Address 4");
		MAR_Address = 4;
		OpCode = `LOAD_SB;
		#6;
		// Store halfword (Testing signed store and load
		$display("Storing halfword at Address 8");
		MAR_Address = 8;
		MDR_DataIn = -2356;
		OpCode = `STORE_HW;
		// Wait for memory
		# 6;
		$display("Address %0d Value %b", MAR_Address, ram.Mem[MAR_Address]);
		$display("Address %0d Value %b", MAR_Address + 1, ram.Mem[MAR_Address + 1]);
		$display("Address %0d Value %b", MAR_Address + 2, ram.Mem[MAR_Address + 2]);
		$display("Address %0d Value %b", MAR_Address + 3, ram.Mem[MAR_Address + 3]);
		// Load Signed Halfword 
		$display("Loading signed Halfword at Address 8");
		MAR_Address = 8;
		OpCode = `LOAD_SHW;
		#6;
	end

endmodule
