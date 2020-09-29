`timescale 1ns/1ps
// Name: mult32_tb.v
// Module: MULT32_TB
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Apr 18, 2020	Ryan Tran	tranryanp@gmail.com	Initial creation
//------------------------------------------------------------------------------------------

module MULT32_TB;
// output list
wire [31:0] HI;
wire [31:0] LO;
// input list
reg [31:0] A;
reg [31:0] B;

MULT32 mult32_inst1(.HI(HI), .LO(LO), .A(A), .B(B));

initial
begin
A = 0; B = 0;
#5 $write("A:%d, B:%d, HI:%d, LO:%d\n", A, B, HI, LO);
A = 2; B = 5;
#5 $write("A:%d, B:%d, HI:%d, LO:%d\n", A, B, HI, LO);
A = 5; B = 2;
#5 $write("A:%d, B:%d, HI:%d, LO:%d\n", A, B, HI, LO);
A = 3781; B = 7132;
#5 $write("A:%d, B:%d, HI:%d, LO:%d\n", A, B, HI, LO);
A = 4294967295; B = 4294967295;
#5 $write("A:%d, B:%d, HI:%d, LO:%d\n", A, B, HI, LO);
A = -2; B = 5;
#5 $write("A:%d, B:%d, HI:%d, LO:%d\n", A, B, HI, LO);
A = -5; B = 2;
#5 $write("A:%d, B:%d, HI:%d, LO:%d\n", A, B, HI, LO);
A = 3781; B = -7132;
#5 $write("A:%d, B:%d, HI:%d, LO:%d\n", A, B, HI, LO);
A = -4294967295; B = -4294967295;
#5 $write("A:%d, B:%d, HI:%d, LO:%d\n", A, B, HI, LO);
end

endmodule
