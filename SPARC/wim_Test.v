module test_register;
reg signed [31:0] in = 32'h0000001;
wire signed [31:0] out;
reg enable;
reg Clr, Clk;

parameter sim_time = 50;

wim wim (out, in, enable, Clr, Clk); // Instantiation of the module

initial #sim_time $finish; // Specifies when the simulation ends

// Initialize control signals and emulate clock
initial 
begin
	enable = 1; // Enable register
	Clk = 0; // Initialize Clk	
	Clr = 1'b1;  // Disable clear
	repeat (10) #5 Clk = ~Clk; // Emulate clock
end

// Clear register
initial
begin
	#15 
	begin 
	Clr = 0;	 // Enable clear
	#5 Clr = 1;	// Disable clear
	end
end

// Enable register
initial
begin
	#25 
	begin 
		enable = 0;	 //  Disable register
		#5 enable = 1;	// Enable register
	end
end

initial repeat (10) #5 in = in + 1;

initial begin
$display ("in \tout \tenable \tclear \tclock"); //printing header
$monitor ("%0d \t %0d \t %0d \t %0d \t %0d", in, out, enable, Clr, Clk); //printing signal
end
endmodule
