`timescale 1ns/1ps
// Name: mux32_4x1_tb.v
// Module: MUX32_4x1_TB
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
//  1.0     Apr 18, 2020	Ryan Tran	tranryanp@gmail.com	Initial creation
//------------------------------------------------------------------------------------------

module MUX32_4x1_TB;
reg [31:0] I0, I1, I2, I3;
reg [1:0] S;
wire [31:0] Y;

MUX32_4x1 mux32_4x1_inst1(.Y(Y), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .S(S));

initial
begin
I0 = 0; I1 = 0; I2 = 0; I3 = 0; S = 0;
#5 $write("I0:%d, I1:%d, I2:%d, I3:%d, S:%d Y:%d\n", I0, I1, I2, I3, S, Y);
I0 = 1431655700; I1 = 1431655701; I2 = 1431655702; I3 = 1431655703; S = 0;
#5 $write("I0:%d, I1:%d, I2:%d, I3:%d, S:%d Y:%d\n", I0, I1, I2, I3, S, Y);
I0 = 1431655700; I1 = 1431655701; I2 = 1431655702; I3 = 1431655703; S = 1;
#5 $write("I0:%d, I1:%d, I2:%d, I3:%d, S:%d Y:%d\n", I0, I1, I2, I3, S, Y);
I0 = 1431655700; I1 = 1431655701; I2 = 1431655702; I3 = 1431655703; S = 2;
#5 $write("I0:%d, I1:%d, I2:%d, I3:%d, S:%d Y:%d\n", I0, I1, I2, I3, S, Y);
I0 = 1431655700; I1 = 1431655701; I2 = 1431655702; I3 = 1431655703; S = 3;
#5 $write("I0:%d, I1:%d, I2:%d, I3:%d, S:%d Y:%d\n", I0, I1, I2, I3, S, Y);
end

endmodule
