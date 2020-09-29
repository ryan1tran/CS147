`timescale 1ns/1ps

`include "prj_definition.v"

module RC_ADD_SUB_64_TB;
wire [63:0] Y;
wire CO;
reg [63:0] A;
reg [63:0] B;
reg SnA;

RC_ADD_SUB_64 rc_add_sub_64_inst(.Y(Y), .CO(CO), .A(A), .B(B), .SnA(SnA));

initial
begin
A = 0; B = 0; SnA = 0;
#5 $write("A:%d B:%d SnA:%d Y:%d CO:%d\n", A, B, SnA, Y, CO);
#5 A = 32; B = 16; SnA = 1;
#5 $write("A:%d B:%d SnA:%d Y:%d CO:%d\n", A, B, SnA, Y, CO);
#5 A = 32; B = 16; SnA = 0;
#5 $write("A:%d B:%d SnA:%d Y:%d CO:%d\n", A, B, SnA, Y, CO);
#5 A = 16; B = 32; SnA = 1;
#5 $write("A:%d B:%d SnA:%d Y:%d CO:%d\n", A, B, SnA, Y, CO);
#5 A = 16; B = 32; SnA = 0;
#5 $write("A:%d B:%d SnA:%d Y:%d CO:%d\n", A, B, SnA, Y, CO);
#5 A = 2147483648; B = 2147483648; SnA = 0;
#5 $write("A:%d B:%d SnA:%d Y:%d CO:%d\n", A, B, SnA, Y, CO);
#5 A = 2147483649; B = 2147483649; SnA = 0;
#5 $write("A:%d B:%d SnA:%d Y:%d CO:%d\n", A, B, SnA, Y, CO);
end

endmodule
