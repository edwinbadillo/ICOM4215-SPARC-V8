module test_wim;

parameter sim_time = 690;

reg [31:0] cwp = 0;
reg [31:0] wimIn = 0;
reg bitDir;
reg Clr;
reg Clk;
reg enable;

wire overFlow;
wire underFlow;
wire [31:0]wimOut;


wim wim(wimOut, wimIn,enable,Clr,Clk);
registerFileTrapGenerator rftg (overFlow,underFlow, wimOut, cwp, wimIn, bitDir, Clr, enable,Clk);


// End simulation at sim_time
initial #sim_time $finish;

initial begin
$display (" overFlow = %b \t underflow = %b \t wim = %b \t cwp = %d \t bitDir = %d", overFlow, underFlow, wimIn, cwp, bitDir);
$monitor (" overFlow = %b \t underflow = %b \t wim = %b \t cwp = %d \t bitDir = %d", overFlow, underFlow, wimIn, ((cwp %4) +1) %4, bitDir);
end

initial
begin
	enable = 1;
	bitDir = 1;
	cwp = 0;
	wimIn = wimOut;
	#5;
	enable = 0;
	#5;
	enable = 1;
	bitDir = 1;
	cwp = 1;
	wimIn = wimOut;
	#5;
	enable = 0;
	#5;
	enable = 1;
	bitDir = 1;
	cwp = 2;
	wimIn = wimOut;
	#5
	enable = 0;
	#5;
	enable = 1;
	bitDir = 1;
	cwp = 3;
	wimIn = wimOut;
	#5;
	enable = 0;
	#5;
	enable = 1;
	bitDir = 1;
	cwp = 4;
	wimIn = wimOut;
	#5;
	enable = 0;
end

endmodule
