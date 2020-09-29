`timescale 1ns/1ps
// Name: half_adder_tb.v
// Module: HALF_ADDER_TB
//
// Output: Y : Sum
//         C : Carry
//
// Input: A : Bit 1
//        B : Bit 2
//
// Notes: 1-bit half adder testbench.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Apr  8, 2020	Ryan Tran	tranryanp@gmail.com	Initial creation
//------------------------------------------------------------------------------------------
module HALF_ADDER_TB;
reg A, B;
wire Y, C;

HALF_ADDER HA_inst1(.Y(Y), .C(C), .A(A), .B(B));

initial
begin
	A=0; B=0;
	#5 $write("A:%d, B:%d, Y (Sum):%d, C (Carry):%d\n", A, B, Y, C);
	#5 A=1; B=0;
	#5 $write("A:%d, B:%d, Y (Sum):%d, C (Carry):%d\n", A, B, Y, C);
	#5 A=0; B=1;
	#5 $write("A:%d, B:%d, Y (Sum):%d, C (Carry):%d\n", A, B, Y, C);
	#5 A=1; B=1;
	#5 $write("A:%d, B:%d, Y (Sum):%d, C (Carry):%d\n", A, B, Y, C);
end

endmodule
