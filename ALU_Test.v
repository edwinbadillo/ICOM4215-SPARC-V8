module test_alu;
reg [5:0]op = 6'b000000; //Genera las combinaciones de las entradas
reg [31:0]a = 32'h0348F;
reg [31:0]b = 32'h15D15;
reg Cin = 0; //Las entradas del módulo deben ser tipo
wire [31:0]res;
wire N;
wire Z;
wire V;
wire C;
wire [31:0]yReg; //Las salidas deben ser tipo wire
parameter sim_time = 100;
alu alu1 (res, N, Z, V, C, yReg, op, a, b, Cin); // Instanciación del módulo
initial #sim_time $finish; // Especifica cuando termina simulación
initial begin
repeat (5)
begin
	repeat(2)
	begin
	#5 op = op ^ 6'b010000; //cada 10 unidades de tiempo
	end
	#10 op = op + 1; //cada 10 unidades de tiempo
end
end
initial begin
$display (" op		a	   b	Cin	res	N	Z	V	C	 yReg"); //imprime header
$monitor ("%b	%d	%d	  %d	%d		%d	%d	%d	%d %d",op, a, b, Cin, res, N, Z, V, C, yReg ); //imprime las señales
end
endmodule
