`timescale 1ns/1ps

module MUX32_4x1_TB;
wire [31:0] Y;
reg [31:0] I0, I1, I2, I3;
reg [1:0] S;

MUX32_4x1 mux32_4x1_inst(.Y(Y), .I0(I0), .I1(I1), .I2(I2), .I3(I3), .S(S));

initial
begin
I0 = 0; I1 = 0; I2 = 0; I3 = 0; S = 0;
#5 $write("I0:%d I1:%d I2:%d I3:%d S:%d Y:%d\n", I0, I1, I2, I3, S, Y);
#5 I0 = 4294967292; I1 = 4294967293; I2 = 4294967294; I3 = 4294967295; S = 0;
#5 $write("I0:%d I1:%d I2:%d I3:%d S:%d Y:%d\n", I0, I1, I2, I3, S, Y);
#5 I0 = 4294967292; I1 = 4294967293; I2 = 4294967294; I3 = 4294967295; S = 1;
#5 $write("I0:%d I1:%d I2:%d I3:%d S:%d Y:%d\n", I0, I1, I2, I3, S, Y);
#5 I0 = 4294967292; I1 = 4294967293; I2 = 4294967294; I3 = 4294967295; S = 2;
#5 $write("I0:%d I1:%d I2:%d I3:%d S:%d Y:%d\n", I0, I1, I2, I3, S, Y);
#5 I0 = 4294967292; I1 = 4294967293; I2 = 4294967294; I3 = 4294967295; S = 3;
#5 $write("I0:%d I1:%d I2:%d I3:%d S:%d Y:%d\n", I0, I1, I2, I3, S, Y);
end

endmodule