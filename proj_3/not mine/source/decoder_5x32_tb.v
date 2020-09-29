`timescale 1ns/1ps

module DECODER_5x32_TB;
wire [31:0] D;
reg [4:0] I;

DECODER_5x32 decoder_5x32_inst(.D(D), .I(I));

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
#5 I = 16;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 17;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 18;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 19;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 20;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 21;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 22;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 23;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 24;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 25;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 26;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 27;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 28;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 29;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 30;
#5 $write("I:%d D:%b\n", I, D);
#5 I = 31;
#5 $write("I:%d D:%b\n", I, D);
end

endmodule
