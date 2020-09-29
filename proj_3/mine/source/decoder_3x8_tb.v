`timescale 1ns/1ps
// Name: decoder_3x8_tb.v
// Module: DECODER_3x8_TB
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

module DECODER_3x8_TB;
// output
wire [7:0] D;
// input
reg [2:0] I;

DECODER_3x8 decoder_3x8_inst1(.D(D), .I(I));

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
end

endmodule
