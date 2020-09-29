`timescale 1ns/1ps
// Name: rc_add_sub_64_tb.v
// Module: RC_ADD_SUB_64_TB
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 64-bit input
//        B : 64-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 64-bit adder / subtractor testbench.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Apr 10, 2020	Ryan Tran	tranryanp@gmail.com	Initial creation
//------------------------------------------------------------------------------------------
module RC_ADD_SUB_64_TB;
wire [63:0] Y;
wire CO;
reg [63:0] A, B;
reg SnA;

RC_ADD_SUB_64 RC_add_sub_64_inst1(.Y(Y), .CO(CO), .A(A), .B(B), .SnA(SnA));

initial
begin
A = 0; B = 0; SnA = 0;
#5 $write("A:%d, B:%d, SnA:%d, Y (Sum):%d, CO (Final carry-out/overflow bit):%d\n", A, B, SnA, Y, CO);
#5 A = 32; B = 32; SnA = 1;
#5 $write("A:%d, B:%d, SnA:%d, Y (Sum):%d, CO (Final carry-out/overflow bit):%d\n", A, B, SnA, Y, CO);
#5 A = 32; B = -32; SnA = 0;
#5 $write("A:%d, B:%d, SnA:%d, Y (Sum):%d, CO (Final carry-out/overflow bit):%d\n", A, B, SnA, Y, CO);
#5 A = 32; B = 16; SnA = 0;
#5 $write("A:%d, B:%d, SnA:%d, Y (Sum):%d, CO (Final carry-out/overflow bit):%d\n", A, B, SnA, Y, CO);
#5 A = 16; B = -32; SnA = 1;
#5 $write("A:%d, B:%d, SnA:%d, Y (Sum):%d, CO (Final carry-out/overflow bit):%d\n", A, B, SnA, Y, CO);
#5 A = 0; B = 32; SnA = 0;
#5 $write("A:%d, B:%d, SnA:%d, Y (Sum):%d, CO (Final carry-out/overflow bit):%d\n", A, B, SnA, Y, CO);
#5 A = 2147483647; B = 2147483647; SnA = 0;
#5 $write("A:%d, B:%d, SnA:%d, Y (Sum):%d, CO (Final carry-out/overflow bit):%d\n", A, B, SnA, Y, CO);
#5 A = 2147483647; B = 2147483647; SnA = 1;
#5 $write("A:%d, B:%d, SnA:%d, Y (Sum):%d, CO (Final carry-out/overflow bit):%d\n", A, B, SnA, Y, CO);
#5 A = 2147483647; B = -2147483648; SnA = 0;
#5 $write("A:%d, B:%d, SnA:%d, Y (Sum):%d, CO (Final carry-out/overflow bit):%d\n", A, B, SnA, Y, CO);
end

endmodule
