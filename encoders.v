module encoder4x2 (output reg [1:0]out, input[3:0] in);
always@(in)
begin
case(in)
  4'b1000: out = 2'b11;
  4'b0100: out = 2'b10;
  4'b0010: out = 2'b01;
  4'b0001: out = 2'b00;
  default: out = 2'bZ;
 endcase
end
endmodule