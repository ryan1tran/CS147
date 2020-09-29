`timescale 1ns/1ps

module TWOSCOMP32_TB;
wire [31:0] Y;
reg [31:0] A;

TWOSCOMP32 twoscomp32_inst(.Y(Y), .A(A));

initial
begin
A = 0;
#5 $write("A:%b Y:%b\n", A, Y);
#5 A = 1;
#5 $write("A:%b Y:%b\n", A, Y);
#5 A = 32;
#5 $write("A:%b Y:%b\n", A, Y);
#5 A = 4294967295;
#5 $write("A:%b Y:%b\n", A, Y);
#5 A = -1;
#5 $write("A:%b Y:%b\n", A, Y);
end

endmodule
