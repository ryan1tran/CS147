`timescale 1ns/1ps

module DECODER_4x16_TB;
wire [15:0] D;
reg [3:0] I;

DECODER_4x16 decoder_4x16_inst(.D(D), .I(I));

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
#5 I = 8;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 9;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 10;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 11;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 12;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 13;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 14;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 15;
#5 $write("I:%d D:%b\n", I, D);
end

endmodule
