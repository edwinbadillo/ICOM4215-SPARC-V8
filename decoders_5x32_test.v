module test_decoder_5x32;

	// Inputs
	reg [4:0]in;
	reg enable; 

	// Outputs
	wire [31:0]out;

	// Constants
	parameter sim_time = 160;

	decoder_5x32 decoder (out,in,enable);

	// End simulation at sim_time
	initial #sim_time $finish;

	// Initialize header, monitor and variables
	initial 
	begin
		in = 0;
		enable = 1;
		$display("In \t Out \t Enable");
		$monitor ("%b \t %b \t %b",in, out, enable);
	end

	// Change input each 5ns interval
	initial 
	begin
		repeat(32)
		begin
			#5 in = in + 1;
		end
	end

	// Disable decoder at 30ns and enable decoder at 40ns
	initial 
	begin
		#30 enable = 0;
		#10 enable = 1; 
	end
	
endmodule
