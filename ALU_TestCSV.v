module test_alu_csv;
reg [5:0]op = 6'b000000; //Genera las combinaciones de las entradas
reg [31:0]a = 5;
reg [31:0]b = 2;
reg Cin = 0; 
wire [31:0]res;
wire N;
wire Z;
wire V;
wire C;
parameter sim_time = 125;
integer data_file; // file handler
integer fp;
`define NULL 0

alu alu1 (res, N, Z, V, C, op, a, b, Cin); // Instanciación del módulo

initial #sim_time $finish; // Especifica cuando termina simulación

initial begin
repeat (23)
begin
	#5 $fscanf(data_file, "%b\n", op);
end
end

initial begin
data_file = $fopen("aluTestOpCodes.txt", "r");
if (data_file == `NULL)
	$display("Error reading aluTestOpCodes.txt file");
else
	$display("File open aluTestOpCodes.txt");
fp=$fopen("result.txt","w");
end
always @ (op)
$fwrite(fp,"%b,%d,%d,%d,%d,%d,%d,%d,%d\n",op, a, b, Cin, res, N, Z, V, C);
endmodule
