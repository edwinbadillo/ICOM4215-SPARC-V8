module test_decoder_2x4;

	// Inputs
	reg [1:0]in;
	reg enable; 

	// Outputs
	wire [3:0]out;

	// Constants
	parameter sim_time = 40;

	decoder_2x4 decoder (out, in, enable);

	// End simulation at sim_time
	initial #sim_time $finish;

	// Initialize header, monitor and variables
	initial 
	begin
		in = 0;
		enable = 1;
		$display("In \t Out \t Enable");
		$monitor("%b \t %b \t %b", in, out, enable);
	end

	// Change input every 5ns
	initial 
	begin
		repeat(8)
		begin
			#5 in = in + 1;
		end
	end

	// Disable decoder at 30ns
	initial 
	begin
		#30 enable = 0;
	end
	
endmodule
