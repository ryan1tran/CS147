`timescale 1ns/1ps
// Name: decoder_2x4_tb.v
// Module: DECODER_2x4_TB
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

module DECODER_2x4_TB;
// output
wire [3:0] D;
// input
reg [1:0] I;

DECODER_2x4 decoder_2x4_inst1(.D(D), .I(I));

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
end

endmodule
