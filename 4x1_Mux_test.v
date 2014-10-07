module test_mux_4x1;
reg [1:0]S;
reg signed [31:0]I0;
reg signed [31:0]I1;
reg signed [31:0]I2;
reg signed [31:0]I3;
wire signed [31:0] Y;

parameter sim_time = 50;

mux_4x1 mux_4x1 (Y, S, I0, I1, I2, I3);

initial #sim_time $finish; // Specifies when to end simulation

// Initialize inputs
initial
begin
	S = 0;
	I0 = -12;
	I1 = 120;
	I2 = 1034;
	I3 = 2234;
end

// Change Inputs 5 times with a 5ns delay
initial 
begin
	repeat(5)
	begin
		#5
		begin
		S = S +1;
		I0 = I0 +1;
		I1 = I1 +1;
		I2 = I2 +1;
		I3 = I3 +1;
		end
	end
end

initial begin
$display ("Y \t S \t I0 \t I1 \t I2 \t I3"); //Printing Header 
$monitor ("%0d \t %0d \t %0d \t %0d \t %0d \t %0d", Y, S, I0, I1, I2, I3); //Printing Signals
end
endmodule
