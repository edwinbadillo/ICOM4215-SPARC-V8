module test_decoder_2x4;

	// Inputs
	reg [1:0]in;
	reg enable; 

	// Outputs
	wire [3:0]out;

	// Constants
	parameter sim_time = 40;

	decoder_2x4 decoder (out,in,enable);

	// End simulation at sim_time
	initial #sim_time $finish;

	// Initialize header, monitor and variables
	initial 
	begin
		in = 0;
		$display("In \t Out \t Enable"); //Printing Header
		$monitor ("%b \t %b \t %b",in, out, enable); //Printing signals
	end

	initial 
	begin
		repeat(8)
		begin
			#5 in = in + 1;
			#30 enable = 0;
		end
		
	end

endmodule
