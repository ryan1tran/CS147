`timescale 1ns/1ps
// Name: barrel_shifter32_tb.v
// Module: BARREL_SHIFTER32_TB
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

module BARREL_SHIFTER32_TB;
// output list
wire [31:0] Y;
// input list
reg [31:0] D;
reg [4:0] S;
reg LnR;

BARREL_SHIFTER32 barrel_shifter32_inst1(.Y(Y), .D(D), .S(S), .LnR(LnR));

initial
begin
D = 0; S = 0; LnR = 0;
#5 $write("D:%d, S:%d, LnR:%d, Y:%d\n", D, S, LnR, Y);
D = 0; S = 0; LnR = 1;
#5 $write("D:%d, S:%d, LnR:%d, Y:%d\n", D, S, LnR, Y);
D = 1; S = 1; LnR = 0;
#5 $write("D:%d, S:%d, LnR:%d, Y:%d\n", D, S, LnR, Y);
D = 1; S = 1; LnR = 1;
#5 $write("D:%d, S:%d, LnR:%d, Y:%d\n", D, S, LnR, Y);
D = 15; S = 2; LnR = 0;
#5 $write("D:%d, S:%d, LnR:%d, Y:%d\n", D, S, LnR, Y);
D = 15; S = 2; LnR = 1;
#5 $write("D:%d, S:%d, LnR:%d, Y:%d\n", D, S, LnR, Y);
D = 200; S = 3; LnR = 0;
#5 $write("D:%d, S:%d, LnR:%d, Y:%d\n", D, S, LnR, Y);
D = 200; S = 3; LnR = 1;
#5 $write("D:%d, S:%d, LnR:%d, Y:%d\n", D, S, LnR, Y);
D = 2147483647; S = 10; LnR = 0;
#5 $write("D:%d, S:%d, LnR:%d, Y:%d\n", D, S, LnR, Y);
D = 2147483647; S = 10; LnR = 1;
#5 $write("D:%d, S:%d, LnR:%d, Y:%d\n", D, S, LnR, Y);
end

endmodule
