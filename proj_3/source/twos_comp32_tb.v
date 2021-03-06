`timescale 1ns/1ps
// Name: twos_comp32_tb.v
// Module: TWOS_COMP32_TB
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
//  1.1     Apr 18, 2020	Ryan Tran	tranryanp@gmaiil.com	Initial creation
//------------------------------------------------------------------------------------------
//

module TWOS_COMP32_TB;
//output list
wire [31:0] Y;
//input list
reg [31:0] A;

TWOSCOMP32 twoscomp32_inst1(.Y(Y), .A(A));

initial
begin
A = 0;
#5 $write("A:%b, Y:%b\n", A, Y);
A = 1;
#5 $write("A:%b, Y:%b\n", A, Y);
A = -1;
#5 $write("A:%b, Y:%b\n", A, Y);
A = 1431655765;
#5 $write("A:%b, Y:%b\n", A, Y);
A = -1431655766;
#5 $write("A:%b, Y:%b\n", A, Y);
end

endmodule
