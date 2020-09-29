`timescale 1ns/1ps

module FULL_ADDER_TB;
reg A, B, CI;
wire S, CO;

FULL_ADDER fa_inst(.S(S), .CO(CO), .A(A), .B(B), .CI(CI));

initial
begin
A = 0; B = 0; CI = 0;
#5 $write("A:%d B:%d CI:%d S:%d CO:%d\n", A, B, CI, S, CO);
#5 A = 0; B = 0; CI = 1;
#5 $write("A:%d B:%d CI:%d S:%d CO:%d\n", A, B, CI, S, CO);
#5 A = 0; B = 1; CI = 0;
#5 $write("A:%d B:%d CI:%d S:%d CO:%d\n", A, B, CI, S, CO);
#5 A = 0; B = 1; CI = 1;
#5 $write("A:%d B:%d CI:%d S:%d CO:%d\n", A, B, CI, S, CO);
#5 A = 1; B = 0; CI = 0;
#5 $write("A:%d B:%d CI:%d S:%d CO:%d\n", A, B, CI, S, CO);
#5 A = 1; B = 0; CI = 1;
#5 $write("A:%d B:%d CI:%d S:%d CO:%d\n", A, B, CI, S, CO);
#5 A = 1; B = 1; CI = 0;
#5 $write("A:%d B:%d CI:%d S:%d CO:%d\n", A, B, CI, S, CO);
#5 A = 1; B = 1; CI = 1;
#5 $write("A:%d B:%d CI:%d S:%d CO:%d\n", A, B, CI, S, CO);
end

endmodule