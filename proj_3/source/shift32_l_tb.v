`timescale 1ns/1ps
// Name: shift32_l_tb.v
// Module: SHIFT32_L_TB
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Apr 23, 2014	Ryan Tran	tranryanp@gmail.com	Initial creation
//------------------------------------------------------------------------------------------

module SHIFT32_L_TB;
// output list
wire [31:0] Y;
// input list
reg [31:0] D;
reg [4:0] S;

SHIFT32_L shift32_l_inst1(.Y(Y), .D(D), .S(S));

initial
begin
D = 0; S = 0;
#5 $write("D:%d, S:%d, Y:%d\n", D, S, Y);
D = 1; S = 1;
#5 $write("D:%d, S:%d, Y:%d\n", D, S, Y);
D = 15; S = 2;
#5 $write("D:%d, S:%d, Y:%d\n", D, S, Y);
D = 200; S = 3;
#5 $write("D:%d, S:%d, Y:%d\n", D, S, Y);
D = 2147483647; S = 10;
#5 $write("D:%d, S:%d, Y:%d\n", D, S, Y);
end

endmodule
