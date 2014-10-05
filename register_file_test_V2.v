module test_register_file_console;

	// Inputs
	reg signed [31:0]in;
	reg enable = 1;
	reg rw;
	reg Clr = 1;
	reg Clk = 0;
	reg signed [1:0]current_window;
	reg signed [4:0]r_num;

	// Outputs
	wire signed [31:0]out;

	
	parameter sim_time = 800;

	register_file register_file(out, in, enable, rw, Clr, Clk, current_window, r_num); // still missing some arguments
	
	initial begin
		$monitor("\t Window = %0d \t Register = %0d \t In = %0d \t RW = %0d ",current_window, r_num, in, rw);	
		repeat (310) #5 Clk = ~Clk; // Emulate clock
	end
	
	initial begin
		current_window = 0;
		repeat(4) //Iterating through windows
		begin
		r_num =0;
		in = 0;
		#5;
			repeat(32) //Iterating through registers
			begin
				
				rw = 1;
				repeat(2)
				begin
				#10;
				rw = rw + 1;
				end
			in = in + 1;
			r_num = r_num + 1;
			
			end
		
		end

	end
	// End simulation at sim_time
	initial #sim_time $finish;

	

endmodule
