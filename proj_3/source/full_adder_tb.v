`timescale 1ns/1ps
// Name: full_adder_tb.v
// Module: FULL_ADDER_TB
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder testbench.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0	    Apr  9, 2020	Ryan Tran	tranryanp@gmail.com	Initial creation
//------------------------------------------------------------------------------------------
module FULL_ADDER_TB;
reg A, B, CI;
wire S, CO;

FULL_ADDER FA_inst1(.S(S), .CO(CO), .A(A), .B(B), .CI(CI));

initial
begin
	A = 0; B = 0; CI = 0;
	#5 $write("A:%d, B:%d, CI (Carry in):%d, S (Sum):%d, CO (Carry-out):%d\n", A, B, CI, S, CO);
	#5 A = 0; B = 0; CI = 1;
	#5 $write("A:%d, B:%d, CI (Carry in):%d, S (Sum):%d, CO (Carry-out):%d\n", A, B, CI, S, CO);
	#5 A = 0; B = 1; CI = 0;
	#5 $write("A:%d, B:%d, CI (Carry in):%d, S (Sum):%d, CO (Carry-out):%d\n", A, B, CI, S, CO);
	#5 A = 0; B = 1; CI = 1;
	#5 $write("A:%d, B:%d, CI (Carry in):%d, S (Sum):%d, CO (Carry-out):%d\n", A, B, CI, S, CO);
	#5 A = 1; B = 0; CI = 0;
	#5 $write("A:%d, B:%d, CI (Carry in):%d, S (Sum):%d, CO (Carry-out):%d\n", A, B, CI, S, CO);
	#5 A = 1; B = 0; CI = 1;
	#5 $write("A:%d, B:%d, CI (Carry in):%d, S (Sum):%d, CO (Carry-out):%d\n", A, B, CI, S, CO);
	#5 A = 1; B = 1; CI = 0;
	#5 $write("A:%d, B:%d, CI (Carry in):%d, S (Sum):%d, CO (Carry-out):%d\n", A, B, CI, S, CO);
	#5 A = 1; B = 1; CI = 1;
	#5 $write("A:%d, B:%d, CI (Carry in):%d, S (Sum):%d, CO (Carry-out):%d\n", A, B, CI, S, CO);
end

endmodule
