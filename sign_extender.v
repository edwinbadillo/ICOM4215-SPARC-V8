
// 12-bit to 32-bit sign extender
module sign_extender_13to32(output[31:0] out, input[12:0] in);
	if (in[12]) out[31:13] <= 19'b111_1111_1111_1111_1111;
	else begin
		out[31:13] <= 19'b000_0000_0000_0000_0000;
	end
	out[12:0] <= in;
	
endmodule


// 22-bit to 32-bit sign extender
module sign_extender_22to32(output[31:0] out, input[21:0] in);
	if (in[21]) out[31:22] <= 10'b11_1111_1111;
	else begin
		out[31:22] <= 10'b00_0000_0000;
	end
	out[21:0] <= in;
	
endmodule


// 30-bit to 32-bit sign extender
module sign_extender_30to32(output[31:0] out, input[29:0] in);
	if (in[29]) out[31:13] <= 19'b111_1111_1111_1111_1111;
	else begin
		out[31:30] <= 2'b00;
	end
	out[29:0] <= in;
	
endmodule