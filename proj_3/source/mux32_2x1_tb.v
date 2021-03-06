`timescale 1ns/1ps
// Name: mux32_2x1_tb.v
// Module: MUX32_2x1_TB
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

module MUX32_2x1_TB;
reg [31:0] I0, I1;
reg S;
wire [31:0] Y;

MUX32_2x1 mux32_2x1_inst1(.Y(Y), .I0(I0), .I1(I1), .S(S));

initial
begin
I0 = 0; I1 = 0; S = 0;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
#5 I0 = 1431655700; I1 = 1431655701; S = 0;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
#5 I0 = 1431655700; I1 = 1431655701; S = 1;
#5 $write("I0:%d, I1:%d, S:%d, Y:%d\n", I0, I1, S, Y);
end

endmodule
