module test_mux_8x1;
reg [1:0]S;
reg signed [31:0]I0;
reg signed [31:0]I1;
reg signed [31:0]I2;
reg signed [31:0]I3;
reg signed [31:0]I4;
reg signed [31:0]I5;
reg signed [31:0]I6;
reg signed [31:0]I7;
wire signed [31:0] Y;

parameter sim_time = 50;

mux_8x1 mux_8x1 (Y, S, I0, I1, I2, I3, I4, I5, I6, I7);

initial #sim_time $finish; // Especifica cuando termina simulacion

// Initialize inputs
initial
begin
	S = 0;
	I0 = -12;
	I1 = 120;
	I2 = 1034;
	I3 = 2234;
	I4 = -13;
	I5 = 123;
	I6 = 1024;
	I7 = 2034;
end

// Change Inputs 7 times with a 5ns delay
initial 
begin
	repeat(7)
	begin
		#5
		begin
		S = S +1;
		end
	end
end

initial begin
$display ("Y \t S \t I0 \t I1 \t I2 \t I3 \t I4 \t I5 \t I6 \t I7"); //imprime header
$monitor ("%0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d \t %0d", Y, S, I0, I1, I2, I3, I4, I5, I6, I7); //imprime las señales
end
endmodule
