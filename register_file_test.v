module test_register_file_console;


	//---PARAMETERS-SUMMARY--------------------------------------------------------------------------------------------
	// out            : 32-bit bus that serves as the output ports of this module
	// in1111111111111             : 32-bit bus that will provide the value to be written to the chosen register as input to the module
	// enable         : 
	// rw 1111111111111            : Bit indicating whether the operation to be performed is a read or write. Read = 0, Write = 1
	// Clr  1111111111111          : 
	// Clk            : System clock
	// current_window1111111111 : The current register window in play. Usually provided by the CU from the CWP (current window pointer) register
	// r_num 11111         : 5-bit address bus for choosing one of the 32 visible registers of the current window
	//-----------------------------------------------------------------------------------------------------------------


	// Inputs
	reg [5:0]OpCode; 
	reg signed [6:0]in;
	reg enable;
	reg rw;
	reg Clr = 1;
	reg Clk = 1;
	reg signed [1:0]current_window;
	reg signed [4:0]r_num;

	// Outputs
	reg signed [31:0]out;

	
	parameter sim_time = 800;

	register_file register_file(out, in, enable, rw, Clr, Clk, current_window, r_num); // still missing some arguments
	
	initial begin
		repeat (310) #5 Clk = ~Clk; // Emulate clock
	end
	
	initial begin
		current_window = 0;
		repeat(4) //Iterating through windows
		begin
		r_num =0;
		in =0;
			repeat(32) //Iterating through registers
			begin
				
				rw = 0;
				repeat(2)
				begin
				$monitor("\t Window = %0d \t Register = %0d \t In = %0d \t RW = %0d ",current_window, r_num, in, rw);	

				in = in + 1;
				
				rw = rw + 1	
				end
			r_num = r_num + 1;
			
			end
			
		
		
		end

	end
	// End simulation at sim_time
	initial #sim_time $finish;

	

endmodule
