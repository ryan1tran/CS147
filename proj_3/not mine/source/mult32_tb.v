`timescale 1ns/1ps

module MULT32_TB;
wire [31:0] HI;
wire [31:0] LO;
reg [31:0] A;
reg [31:0] B;

MULT32 mult32_inst(.HI(HI), .LO(LO), .A(A), .B(B));

initial
begin
A = 0; B = 0;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
#5 A = 4; B = 8;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
#5 A = 8; B = 4;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
#5 A = 65536; B = 65536;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
#5 A = 65535; B = 65535;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
#5 A = 4294967295; B = 4294967295;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
#5 A = -4; B = 8;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
#5 A = 8; B = -4;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
#5 A = -65536; B = 65536;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
#5 A = 65535; B = -65535;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
#5 A = -4294967295; B = -4294967295;
#5 $write("A:%d B:%d HI:%d LO:%d\n", A, B, HI, LO);
end

endmodule
