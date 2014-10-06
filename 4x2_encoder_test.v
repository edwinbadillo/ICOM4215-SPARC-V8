module test_encoder_4x2;
reg [3:0]in;
wire [1:0] out;

parameter sim_time = 50;

encoder_4x2 encoder_4x2 (out, in);

initial #sim_time $finish; // Especifica cuando termina simulacion

// Initialize inputs
initial
begin
	in = 8;
	
end

// Change Inputs 5 times with a 5ns delay
initial 
begin

	
	begin
	#5
	in = 4;
	#5
	in = 2;
	#5
	in = 1;
	end

end

initial begin
$display ("Out \t in \t"); //imprime header
$monitor ("%0d \t %0d \t", out, in); //imprime las señales
end
endmodule
