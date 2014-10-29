// Decoders

// All decoders choose the corresponding output wire by shifting a binary 1 'in' times to the left

// 2x4 Decoder
module decoder_2x4(output reg [3:0]out, input wire [1:0]in, input wire enable);
	always @ (in, enable)
	begin
		out = (enable) ? (4'b0001 << in) : 4'b0000;
	end
endmodule

// 5x32 Decoder
module decoder_5x32(output reg [31:0]out, input wire [4:0]in, input wire enable);
	always @ (in, enable)
	begin
		out = (enable) ? (32'b1 << in) : 32'b0;
	end
endmodule