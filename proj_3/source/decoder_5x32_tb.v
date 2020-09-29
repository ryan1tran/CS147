`timescale 1ns/1ps
// Name: decoder_5x32_tb.v
// Module: DECODER_5x32_TB
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Apr 23, 2014	Ryan Tran	tranryanp@gmail.com	Initial creation
//------------------------------------------------------------------------------------------

module DECODER_5x32_TB;
// output
wire [31:0] D;
// input
reg [4:0] I;

DECODER_5x32 decoder_5x32_inst1(.D(D), .I(I));

initial
begin
I = 0;
#5 $write("I:%d, D:%b\n", I, D);
I = 1;
#5 $write("I:%d, D:%b\n", I, D);
I = 2;
#5 $write("I:%d, D:%b\n", I, D);
I = 3;
#5 $write("I:%d, D:%b\n", I, D);
I = 4;
#5 $write("I:%d, D:%b\n", I, D);
I = 5;
#5 $write("I:%d, D:%b\n", I, D);
I = 6;
#5 $write("I:%d, D:%b\n", I, D);
I = 7;
#5 $write("I:%d, D:%b\n", I, D);
I = 8;
#5 $write("I:%d, D:%b\n", I, D);
I = 9;
#5 $write("I:%d, D:%b\n", I, D);
I = 10;
#5 $write("I:%d, D:%b\n", I, D);
I = 11;
#5 $write("I:%d, D:%b\n", I, D);
I = 12;
#5 $write("I:%d, D:%b\n", I, D);
I = 13;
#5 $write("I:%d, D:%b\n", I, D);
I = 14;
#5 $write("I:%d, D:%b\n", I, D);
I = 15;
#5 $write("I:%d, D:%b\n", I, D);
I = 16;
#5 $write("I:%d, D:%b\n", I, D);
I = 17;
#5 $write("I:%d, D:%b\n", I, D);
I = 18;
#5 $write("I:%d, D:%b\n", I, D);
I = 19;
#5 $write("I:%d, D:%b\n", I, D);
I = 20;
#5 $write("I:%d, D:%b\n", I, D);
I = 21;
#5 $write("I:%d, D:%b\n", I, D);
I = 22;
#5 $write("I:%d, D:%b\n", I, D);
I = 23;
#5 $write("I:%d, D:%b\n", I, D);
I = 24;
#5 $write("I:%d, D:%b\n", I, D);
I = 25;
#5 $write("I:%d, D:%b\n", I, D);
I = 26;
#5 $write("I:%d, D:%b\n", I, D);
I = 27;
#5 $write("I:%d, D:%b\n", I, D);
I = 28;
#5 $write("I:%d, D:%b\n", I, D);
I = 29;
#5 $write("I:%d, D:%b\n", I, D);
I = 30;
#5 $write("I:%d, D:%b\n", I, D);
I = 31;
#5 $write("I:%d, D:%b\n", I, D);
end

endmodule
