`timescale 1ns/1ps
// Name: mux1_2x1_tb.v
// Module: MUX1_2x1_TB
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
//  1.0     Apr 11, 2020	Ryan Tran	tranryanp@gmail.com	Initial creation
//------------------------------------------------------------------------------------------

module MUX1_2x1_TB;
reg I0, I1, S;
wire Y;

MUX1_2x1 mux1_2x1_inst1(.Y(Y), .I0(I0), .I1(I1), .S(S));

initial
begin
#5 I0 = 0; I1 = 0; S = 0;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
#5 I0 = 0; I1 = 0; S = 1;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
#5 I0 = 0; I1 = 1; S = 0;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
#5 I0 = 0; I1 = 1; S = 1;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
#5 I0 = 1; I1 = 0; S = 0;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
#5 I0 = 1; I1 = 0; S = 1;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
#5 I0 = 1; I1 = 1; S = 0;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
#5 I0 = 1; I1 = 1; S = 1;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
end

endmodule
