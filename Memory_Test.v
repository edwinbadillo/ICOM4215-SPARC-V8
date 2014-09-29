module test_memory_console;

	// Inputs
	reg [5:0]op; 
	reg signed [31:0]a;
	reg signed [31:0]b;
	reg Cin = 1; 

	// Outputs
	wire signed [31:0]res;
	wire N, Z, V, C;

	// File handlers
	integer opFile;
	integer valueFile;

	// Constants
	`define NULL 0
	`define SEEK_SET 0
	parameter sim_time = 690;

	alu alu1 (res, N, Z, V, C, op, a, b, Cin);
	ram ram1 (MDR_DataOut, Enable, OpCode, MAR_Address, MDR_DataIn)

	// End simulation at sim_time
	initial #sim_time $finish;

	// Initialize files and monitor
	initial begin
		opFile = $fopen("memoryTestCodes.txt", "r");
		if (opFile == `NULL)
			$display("Error reading memoryTestCodes.txt file");
		else
			$display("File open memoryTestCodes.txt");
		valueFile = $fopen("memoryValues.txt", "r");
		if (valueFile == `NULL)
			$display("Error reading memoryValuestxt file");
		else
			$display("File open memoryValues.txt");
		$monitor ("%b \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d ",op, a, b, Cin, res, N, Z, V, C);
	end

	initial begin
		repeat(5)
		begin
			$display("======================================================");
			// Read values for a and b and display header
			$fscanf(valueFile, "%d\n", a);
			$fscanf(valueFile, "%d\n", b);
			$display("\ta = %0d \t b = %0d",a, b);	
			$display ("  op \t    a \t b \t Cin \t res \t N \t Z \t V \t C"); 
			// Reset pointer of the op code file to the start of the file
			$fseek(opFile, 0, `SEEK_SET);
			// Read the 23 op codes instruction with a 5ns interval
			repeat(23)
			begin
			#5 $fscanf(data_file, "%b\n", op);
			end
		end
	end

endmodule
