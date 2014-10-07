module test_mux_64x1;
reg [5:0]S;
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
reg signed[31:0]I32;
reg signed[31:0]I33;
reg signed[31:0]I34;
reg signed[31:0]I35;
reg signed[31:0]I36;
reg signed[31:0]I37;
reg signed[31:0]I38;
reg signed[31:0]I39;
reg signed[31:0]I40;
reg signed[31:0]I41;
reg signed[31:0]I42;
reg signed[31:0]I43;
reg signed[31:0]I44;
reg signed[31:0]I45;
reg signed[31:0]I46;
reg signed[31:0]I47;
reg signed[31:0]I48;
reg signed[31:0]I49;
reg signed[31:0]I50;
reg signed[31:0]I51;
reg signed[31:0]I52;
reg signed[31:0]I53;
reg signed[31:0]I54;
reg signed[31:0]I55;
reg signed[31:0]I56;
reg signed[31:0]I57;
reg signed[31:0]I58;
reg signed[31:0]I59;
reg signed[31:0]I60;
reg signed[31:0]I61;
reg signed[31:0]I62;
reg signed[31:0]I63;
wire signed [31:0] Y;

parameter sim_time = 3550;

mux_64x1 mux_64x1 (Y, S, I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15, I16, I17, I18, I19, I20, I21, I22, I23, I24, I25, I26, I27, I28, I29, I30, I31, I32, I33, I34, I35, I36, I37, I38, I39, I40, I41, I42, I43, I44, I45, I46, I47, I48, I49, I50, I51, I52, I53, I54, I55, I56, I57, I58, I59, I60, I61, I62, I63);
reg [63:0]count = 000;

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
	I32 = 32;
	I33 = 33;
	I34 = 34;
	I35 = 35;
	I36 = 36;
	I37 = 37;
	I38 = 38;
	I39 = 39;
	I40 = 40;
	I41 = 41;
	I42 = 42;
	I43 = 43;
	I44 = 44;
	I45 = 45;
	I46 = 46;
	I47 = 47;
	I48 = 48;
	I49 = 49;
	I50 = 50;
	I51 = 51;
	I52 = 52;
	I53 = 53;
	I54 = 54;
	I55 = 55;
	I56 = 56;
	I57 = 57;
	I58 = 58;
	I59 = 59;
	I60 = 60;
	I61 = 61;
	I62 = 62;
	I63 = 63;

end

// Change Inputs 64 times with a 5ns delay
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
$monitor ("%0d \t %0d \t", Y, S); //printing output and inputs
end
endmodule
