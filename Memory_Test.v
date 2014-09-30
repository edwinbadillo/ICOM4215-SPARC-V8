module test_memory_console;

	// Inputs
	reg [5:0]OpCode; 
	reg signed [31:0]MDR_DataIn;
	reg signed [6:0]MAR_Address;
	reg enable;

	// Outputs
	wire signed [31:0]MDR_DataOut;
	wire MFC;

	// File handlers
	integer opFile;
	integer valueFile;
	
	// Constants
	`define NULL 0
	`define SEEK_SET 0
	parameter sim_time = 690;

	ram128x32 ram (MDR_DataOut, MFC, enable, OpCode, MAR_Address, MDR_DataIn);

	// End simulation at sim_time
	initial #sim_time $finish;

	// Initialize files and monitor
	initial begin
		enable = 1;
		MAR_Address = 0;
		opFile = $fopen("memoryTestCodes.txt", "r");
		if (opFile == `NULL)
			$display("Error reading memoryTestCodes.txt file");
		else
			$display("File open memoryTestCodes.txt");
		$display ("In \t Out \t MFC Enable");
		$monitor ("%0b \t %0b \t %0b \t %0b", MDR_DataIn, MDR_DataOut, MFC, enable);
	end

	initial begin
		// Load Word
		OpCode = 6'b000000;
		MDR_DataIn = -24;
		$display("Address %0d Value %b", MAR_Address, ram.Mem[MAR_Address]);
		$display("Address %0d Value %b", MAR_Address + 1, ram.Mem[MAR_Address + 1]);
		$display("Address %0d Value %b", MAR_Address + 2, ram.Mem[MAR_Address + 2]);
		$display("Address %0d Value %b", MAR_Address + 3, ram.Mem[MAR_Address + 3]);
		MAR_Address = MAR_Address + 4;
		// 
	end

endmodule
