`timescale 1ns/1ps

module SHIFT32_R_TB;
wire [31:0] Y;
reg [31:0] D;
reg [4:0] S;

SHIFT32_R shift32_r_inst(.Y(Y), .D(D), .S(S));

initial
begin
D = 0; S = 0;
#5 $write("D:%d S:%d Y:%d\n", D, S, Y);
#5 D = 64; S = 4;
#5 $write("D:%d S:%d Y:%d\n", D, S, Y);
#5 D = 100; S = 5;
#5 $write("D:%d S:%d Y:%d\n", D, S, Y);
#5 D = 123; S = 3;
#5 $write("D:%d S:%d Y:%d\n", D, S, Y);
#5 D = 1; S = 1;
#5 $write("D:%d S:%d Y:%d\n", D, S, Y);
#5 D = 1; S = 3;
#5 $write("D:%d S:%d Y:%d\n", D, S, Y);
end

endmodule
