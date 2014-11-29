module test_register_file_coupler;
	reg  [1:0] in;
	wire [1:0] out;

	register_file_coupler rfc (out, in);

	initial begin
		in = 2'b00;
		#10;
		$display("In: %d, Out: %d", in, out);
		in = 2'b01;
		#10;
		$display("In: %d, Out: %d", in, out);
		in = 2'b10;
		#10;
		$display("In: %d, Out: %d", in, out);
		in = 2'b11;
		#10;
		$display("In: %d, Out: %d", in, out);
	end

	initial #40 $finish; 
endmodule