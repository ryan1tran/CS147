`timescale 1ns/1ps

module MUX64_2x1_TB;
wire [63:0] Y;
reg [63:0] I0, I1;
reg S;

MUX64_2x1 mux64_2x1_inst(.Y(Y), .I0(I0), .I1(I1), .S(S));

initial
begin
I0 = 0; I1 = 0; S = 0;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
#5 I0 = 4294967294; I1 = 4294967295; S = 1;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
#5 I0 = 4294967294; I1 = 4294967295; S = 0;
#5 $write("I0:%d I1:%d S:%d Y:%d\n", I0, I1, S, Y);
end

endmodule