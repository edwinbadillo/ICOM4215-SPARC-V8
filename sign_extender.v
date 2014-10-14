module sign_extender_13to32(output[31:0] out, input[12:0] in);
	if (in[12]) out[31:13] <= 19'b111_1111_1111_1111_1111;
	else begin
		out[31:13] <= 19'b000_0000_0000_0000_0000;
	end
	out[12:0] <= in;
	
endmodule