`timescale 1ns/1ps
// Name: decoder_4x16_tb.v
// Module: DECODER_4x16_TB
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

module DECODER_4x16_TB;
// output
wire [15:0] D;
// input
reg [3:0] I;

DECODER_4x16 decoder_4x16_inst1(.D(D), .I(I));

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
end

endmodule
