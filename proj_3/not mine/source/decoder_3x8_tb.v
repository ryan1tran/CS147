`timescale 1ns/1ps

module DECODER_3x8_TB;
wire [7:0] D;
reg [2:0] I;

DECODER_3x8 decoder_3x8_inst(.D(D), .I(I));

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
#5 I = 4;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 5;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 6;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 7;
#5 $write("I:%d D:%b\n", I, D);
end

endmodule
