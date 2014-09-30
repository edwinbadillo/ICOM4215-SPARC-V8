module test_mux_64x1;
reg [1:0]S;
reg signed [31:0] I[63:0]
wire signed [31:0] Y;

parameter sim_time = 50;

mux_64x1 mux_64x1 (Y, S, I);
reg [63:0]count = 000;

initial #sim_time $finish; // Especifica cuando termina simulacion

// Initialize inputs
initial
begin
	S = 0;
	repeat(64)
	begin
		begin
		i[count] = count;
		count = count +1;
		end
	end
end

// Change Inputs 7 times with a 5ns delay
initial 
begin
	repeat(64)
	begin
		#5
		begin
		S = S +1;
		end
	end
end

initial begin
$display ("Y \t S \t"); //imprime header
$monitor ("%0d \t %0d \t", Y, S); //imprime las señales
end
endmodule
