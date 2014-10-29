module test_wim;

parameter sim_time = 690;

reg [31:0] cwp = 0;
reg [31:0] wimIn = 0;
reg bitDir;
reg Clr;
reg Clk = 0;
reg enable;

wire overFlow;
wire underFlow;
wire [31:0]wimOut;
wire [31:0]wimOutTrap;


wim wim(wimOut, wimIn,enable,Clr,Clk);
registerFileTrapGenerator rftg (overFlow,underFlow, wimOutTrap, cwp, wimIn, bitDir, Clr, enable,Clk);


// End simulation at sim_time
initial #sim_time $finish;

initial
begin
	repeat(80)
	begin
	Clk = ~Clk;
	#5;
	end
end

initial begin
$display (" overFlow = %b \t underflow = %b \t wim = %b \t cwp = %d \t bitDir = %d \t Clk = %d", overFlow, underFlow, wimOutTrap, cwp % 4, bitDir, Clk);
$monitor (" overFlow = %b \t underflow = %b \t wim = %b \t cwp = %d \t bitDir = %d \t Clk = %d", overFlow, underFlow, wimOutTrap, cwp % 4, bitDir, Clk);
end

initial
begin
	Clr = 1;
	#5;
	Clr = 0;
	#5;
	repeat(10)
	begin
		enable = 1;
		bitDir = 1;
		wimIn = wimOutTrap;
		#5;
		cwp = cwp + 1;
		enable = 0;
		#5;
	end
	repeat(10)
	begin
		enable = 1;
		bitDir = 0;
		wimIn = wimOutTrap;
		#5;
		cwp = cwp - 1;
		enable = 0;
		#5;
	end
end

endmodule
