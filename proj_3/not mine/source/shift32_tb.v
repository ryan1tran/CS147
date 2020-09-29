`timescale 1ns/1ps

module SHIFT32_TB;
wire [31:0] Y;
reg [31:0] D;
reg [31:0] S;
reg LnR;

SHIFT32 shift32_inst(.Y(Y), .D(D), .S(S), .LnR(LnR));

initial
begin
D = 0; S = 0; LnR = 0;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 2; S = 4; LnR = 1;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 5; S = 5; LnR = 1;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 13; S = 3; LnR = 1;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 2147483648; S = 1; LnR = 1;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 2147483648; S = 3; LnR = 1;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 64; S = 4; LnR = 0;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 100; S = 5; LnR = 0;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 123; S = 3; LnR = 0;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 1; S = 1; LnR = 0;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 1; S = 3; LnR = 0;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 1; S = 31; LnR = 1;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 1; S = 32; LnR = 1;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 1; S = 33; LnR = 1;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
#5 D = 1; S = 35; LnR = 1;
#5 $write("D:%d S:%d LnR:%d Y:%d\n", D, S, LnR, Y);
end

endmodule
