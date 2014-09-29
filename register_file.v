// Register file

module register_file(output reg [31:0] out, input [31:0] in, input enable, Clr, Clk, input [1:0] current_window, input [4:0] r_num); // still missing some arguments

wire [3:0]  d_window_out;
wire [31:0] d_register_out0;
wire [31:0] d_register_out1;
wire [31:0] d_register_out2;
wire [31:0] d_register_out3;

wire [71:0] r_out;

// Global Registers r0-r7
register_32 r0(out, in, enable, Clr, Clk); // we have to make this hardcoded to always be 0
register_32 r1(out, in, enable, Clr, Clk);
register_32 r2(out, in, enable, Clr, Clk);
register_32 r3(out, in, enable, Clr, Clk);
register_32 r4(out, in, enable, Clr, Clk);
register_32 r5(out, in, enable, Clr, Clk);
register_32 r6(out, in, enable, Clr, Clk);
register_32 r7(out, in, enable, Clr, Clk);

// Other registers
register_32 r_other[63:0] (out, in, enable, Clr, Clk);

// Decoder logic to access the correct registers based on current window

decoder_2x4 d_window(d_window_out, current_window, enable); // Chooses the window

// Each one choose one out of the 32 visible registers in the current window
decoder_5x32 d_register0 (d_register_out0, r_num, d_window_out[0]);
decoder_5x32 d_register1 (d_register_out1, r_num, d_window_out[1]);
decoder_5x32 d_register2 (d_register_out2, r_num, d_window_out[2]);
decoder_5x32 d_register3 (d_register_out3, r_num, d_window_out[3]);



// Multiplexer logic to pipe the data fom registers in current window outside






//DFF d[15:0] (clk, DFF_i, DFF_o);


endmodule
