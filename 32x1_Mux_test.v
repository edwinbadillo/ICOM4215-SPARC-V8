module test_mux_32x1;
reg [4:0]S;
reg signed[31:0]I0;
reg signed[31:0]I1;
reg signed[31:0]I2;
reg signed[31:0]I3;
reg signed[31:0]I4;
reg signed[31:0]I5;
reg signed[31:0]I6;
reg signed[31:0]I7;
reg signed[31:0]I8;
reg signed[31:0]I9;
reg signed[31:0]I10;
reg signed[31:0]I11;
reg signed[31:0]I12;
reg signed[31:0]I13;
reg signed[31:0]I14;
reg signed[31:0]I15;
reg signed[31:0]I16;
reg signed[31:0]I17;
reg signed[31:0]I18;
reg signed[31:0]I19;
reg signed[31:0]I20;
reg signed[31:0]I21;
reg signed[31:0]I22;
reg signed[31:0]I23;
reg signed[31:0]I24;
reg signed[31:0]I25;
reg signed[31:0]I26;
reg signed[31:0]I27;
reg signed[31:0]I28;
reg signed[31:0]I29;
reg signed[31:0]I30;
reg signed[31:0]I31;
wire signed [31:0] Y;

parameter sim_time = 3550;

mux_32x1 mux_32x1 (Y, S, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30, I31);

initial #sim_time $finish; // Specifies when to end simulation

// Initialize inputs
initial
begin
	S = 0;
	I0 = 0;
	I1 = 1;
	I2 = 2;
	I3 = 3;
	I4 = 4;
	I5 = 5;
	I6 = 6;
	I7 = 7;
	I8 = 8;
	I9 = 9;
	I10 = 10;
	I11 = 11;
	I12 = 12;
	I13 = 13;
	I14 = 14;
	I15 = 15;
	I16 = 16;
	I17 = 17;
	I18 = 18;
	I19 = 19;
	I20 = 20;
	I21 = 21;
	I22 = 22;
	I23 = 23;
	I24 = 24;
	I25 = 25;
	I26 = 26;
	I27 = 27;
	I28 = 28;
	I29 = 29;
	I30 = 30;
	I31 = 31;
end

// Change Input 32 times with a 5ns delay
initial 
begin
	repeat(32)
	begin
		#5
		begin
		S = S +1;
		end
	end
end

initial begin
$display ("Y \t S \t"); //printing header
$monitor ("%0d \t %0d \t", Y, S); //printing output and inputs
end
endmodule
