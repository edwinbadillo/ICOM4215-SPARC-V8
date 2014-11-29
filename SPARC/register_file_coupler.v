module register_file_coupler (output [1:0]out, input [1:0] in);
	not (out[1], in[1]);
	not (out[0], in[0]);
endmodule