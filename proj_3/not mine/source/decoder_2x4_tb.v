`timescale 1ns/1ps

module DECODER_2x4_TB;
wire [3:0] D;
reg [1:0] I;

DECODER_2x4 decoder_2x4_inst(.D(D), .I(I));

initial
begin
I = 0;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 1;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 2;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 3;
#5 $write("I:%d D:%b\n", I, D);
end

endmodule
