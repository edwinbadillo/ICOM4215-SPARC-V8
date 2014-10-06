module encoder4x2 (output reg [1:0]out, input[3:0] in);
always@(in)
begin
case(in)
  4'b1000: out = 0;
  4'b0100: out = 1;
  4'b0010: out = 2;
  4'b0001: out = 3;
  default: out = 2'bZ;
 endcase
end
endmodule