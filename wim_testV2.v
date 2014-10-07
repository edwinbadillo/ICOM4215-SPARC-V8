module test_wim;

parameter sim_time = 690;

reg [31:0] cwp = 0;
reg bitDir;
reg Clr;
reg enable;

wire overFlow;
wire underFlow;
wire [31:0]wimReg;

wim wim (overFlow,underFlow, wimReg, cwp, bitDir,Clr, enable);

// End simulation at sim_time
initial #sim_time $finish;

initial begin
$monitor (" overFlow = %b \t underflow = %b \t wim = %b \t cwp = %d \t bitDir = %d", overFlow, underFlow, wimReg, cwp, bitDir);
end

initial
begin
	Clr = 1;
	#5
	Clr = 0;
	#5;
	enable = 1;
	bitDir = 1;
	cwp = 0;
	#5;
	enable = 0;
	#5;
	enable = 1;
	bitDir = 1;
	cwp = 1;
	#5;
	enable = 0;
	#5;
	enable = 1;
	bitDir = 1;
	cwp = 2;
	#5
	enable = 0;
	#5;
	enable = 1;
	bitDir = 1;
	cwp = 3;
	enable = 0;
	#5;
	enable = 1;
	bitDir = 1;
	cwp = 4;
	#5;
	enable = 0;
end

endmodule
