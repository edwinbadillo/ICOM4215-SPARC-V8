//2x4 Encoder: Receives a 4 bit code and encodes it to a 2 bit code
module encoder4x2 (output reg [1:0]out, input[3:0] in);
always@(in)
begin
case(in)
  4'b1000: out = 2'b11; //8=>3
  4'b0100: out = 2'b10; //4=>2
  4'b0010: out = 2'b01; //2=>1
  4'b0001: out = 2'b00; //1=>0
  default: out = 2'bZ;
 endcase
end
endmodule