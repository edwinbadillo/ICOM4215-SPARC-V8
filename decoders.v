// Decoders

// 2x4 Decoder
module decoder_2x4(output reg [3:0]out, input wire [1:0]in, input wire enable);
// If enabled, it chooses the corresponding wire by shifting a 1 'in' times to the left
assign out = (enable) ? (4'b1 << in) : 4'b0;
endmodule

// 5x32 Decoder
module decoder_5x32(output reg [31:0]out, input wire [4:0]in, input wire enable);
// If enabled, it chooses the corresponding wire by shifting a 1 'in' times to the left
assign out = (enable) ? (32'b1 << in) : 32'b0;
endmodule
