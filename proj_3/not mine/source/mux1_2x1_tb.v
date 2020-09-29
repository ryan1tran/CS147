`timescale 1ns/1ps

module MUX1_2x1_TB;
wire Y;
reg I0, I1, S;

MUX1_2x1 mux1_2x1_inst(.Y(Y), .I0(I0), .I1(I1), .S(S));

initial
begin
I0 = 0; I1 = 0; S = 0;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
#5 I0 = 0; I1 = 0; S = 1;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
#5 I0 = 0; I1 = 1; S = 0;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
#5 I0 = 0; I1 = 1; S = 1;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
#5 I0 = 1; I1 = 0; S = 0;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
#5 I0 = 1; I1 = 0; S = 1;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
#5 I0 = 1; I1 = 1; S = 0;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
#5 I0 = 1; I1 = 1; S = 1;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
end

endmodule