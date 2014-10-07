module test_register_file_V2;

	/* 
		This test module writes, reads, and clears all the 4 windows in the register file.
		The module first writes to all the register which takes 1280ns.
		Next, the module reads each window registers to verify the writes, this takes 640ns
		Then it clears some register to verify the asynchronous clear taking 15ns.
		At last, it clears all the register in 640ns.
	*/

	// Inputs
	reg signed [31:0]in;			// data in
	reg [4:0]PA_in;					// Address for port A used for reading a register
	reg [4:0]PB_in;					// Address for port B used for reading a register 
	reg [4:0]PC_in;					// Address for port C. Used to indicate writing and clearing a register
	reg enable = 0;
	reg Clr = 0;
	reg Clk = 0;
	reg [4:0]current_window;

	// Outputs
	wire signed [31:0] PA_out;
	wire signed [31:0] PB_out;
	
	parameter sim_time = 2580;

	register_file register_file(PA_out, PB_out, in, PA_in, PB_in, PC_in, enable, Clr, Clk, current_window[1:0]);
	
	initial begin
		$monitor("\t Window = %0d \t In = %0d \t E = %0d \t Clr = %0d \t Clk = %0d\n\t RegisterPA = %0d \t RegisterPB = %0d \t RegisterPC = %0d \t PA_out = %0d \t PB_out = %0d", current_window, in, enable, Clr, Clk, PA_in, PB_in, PC_in, PA_out, PB_out);
		repeat (2570) #5 Clk = ~Clk; // Emulate clock
	end
	
	initial 
	begin
		// Writing to every register in each window
		current_window = 0;
		in = 0;
		// Iterate through the 4 windows writing to each register.
		repeat(4)
		begin
			PC_in = 0;
			// Iterate through the 32 register of each window
			repeat(32)
			begin
				// Perform write to a register
				enable = ~enable;
				#5;
				enable = ~enable;
				#5;
				// Go to next register
				in = in + 1;
				PC_in = PC_in + 1;
			end
		// Go to next window
		current_window = current_window + 1;
		end
		
		// Reading every register in each window
		current_window = 0;
		enable = 0;
		// Iterate through the 4 windows reading each register
		repeat(4)
		begin
			PA_in = 0;
			PB_in = 31;
			// Iterate through the 32 register of each window
			repeat(32)
			begin
				#5;
				PA_in = PA_in + 1;
				PB_in = PB_in - 1;
			end
		current_window = current_window + 1;
		end
		// Clearing some registers
		current_window = 0;
		PC_in = 3;						// Clear global register 3
		PA_in = 3;
		Clr = ~Clr;
		#5;
		PB_in = 31;
		PC_in = 31;						// Clear register 31 in window 0
		#5;
		Clr = ~Clr;
		current_window = 1;				// Change to window 1
		PA_in = 1;
		PC_in = 1;						// Clear register 1
		Clr = ~Clr;
		#5;
		
		// Clearing all registers
		current_window = 4'b0000;
		enable = 0;
		Clr = 0;
		// Iterate through the 4 windows reading and clearing each register
		repeat(4)
		begin
			PA_in = 0;
			PB_in = 31;
			PC_in = 0;
			// Iterate through the 32 register of each window
			repeat(32)
			begin
				// Enable Clear of current Register
				Clr = ~Clr;
				#5;
				// Disable Clear
				Clr = ~Clr;
				PA_in = PA_in + 1;
				PB_in = PB_in - 1;
				PC_in = PA_in;
			end
		current_window = current_window + 1;
		end
	end
	// End simulation at sim_time
	initial #sim_time $finish;
endmodule
