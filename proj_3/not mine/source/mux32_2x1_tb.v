`timescale 1ns/1ps

module MUX32_2x1_TB;
wire [31:0] Y;
reg [31:0] I0, I1;
reg S;

MUX32_2x1 mux32_2x1_inst(.Y(Y), .I0(I0), .I1(I1), .S(S));

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