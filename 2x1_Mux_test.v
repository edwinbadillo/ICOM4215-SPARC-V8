module test_mux_2x1;
reg S;
reg signed [31:0]I0;
reg signed [31:0]I1;
wire signed [31:0] Y;

parameter sim_time = 50;

mux_2x1 mux_2x1 (Y, S, I0, I1);

initial #sim_time $finish; // Especifica cuando termina simulacion

// Initialize inputs
initial
begin
	S = 0;
	I0 = -12;
	I1 = 120;
end

// Change Inputs 5 times with a 5ns delay
initial 
begin
	repeat(5)
	begin
		#5
		begin
		S = ~S;
		I0 = I0 +1;
		I1 = I1 +1; 
		end
	end
end

initial begin
$display ("Y \t S \t I0 \t I1"); //imprime header
$monitor ("%0d \t %0d \t %0d \t %0d", Y, S, I0, I1); //imprime las señales
end
endmodule
