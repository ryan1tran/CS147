// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version  Date        Who     email           note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014    Kaushik Patra   kpatra@sjsu.edu     Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

// Two's complement multiplicand and multiplier
wire [31:0] twoscomp32_mcnd;
wire [31:0] twoscomp32_mplr;
TWOSCOMP32 twoscomp32_inst_mcnd(.Y(twoscomp32_mcnd), .A(A));
TWOSCOMP32 twoscomp32_inst_mplr(.Y(twoscomp32_mplr), .A(B));

// Mux multiplicand and multiplier to choose complement or not
wire [31:0] mux32_2x1_mcnd;
wire [31:0] mux32_2x1_mplr;
MUX32_2x1 mux32_2x1_inst_mcnd(.Y(mux32_2x1_mcnd), .I0(A), .I1(twoscomp32_mcnd), .S(A[31]));
MUX32_2x1 mux32_2x1_inst_mplr(.Y(mux32_2x1_mplr), .I0(B), .I1(twoscomp32_mplr), .S(B[31]));

// Unsigned multiplication
wire [63:0] mult32_u_res;
MULT32_U mult32_u_inst(.HI(mult32_u_res[63:32]), .LO(mult32_u_res[31:0]), .A(mux32_2x1_mcnd), .B(mux32_2x1_mplr));

// Two's complement of unsigned multiplication
wire [63:0] twoscomp64_res;
TWOSCOMP64 twoscomp64_inst(.Y(twoscomp64_res), .A(mult32_u_res));

// XOR to choose signed or unsigned
wire xorRes;
xor xor_inst(xorRes, A[31], B[31]);

// Mux to choose complement or not
wire [63:0] mux64_2x1_res;
MUX64_2x1 mux64_2x1_inst(.Y(mux64_2x1_res), .I0(mult32_u_res), .I1(twoscomp64_res), .S(xorRes));

// Buffer to output
BUF32 buf32_inst_HI(.Y(HI), .A(mux64_2x1_res[63:32]));
BUF32 buf32_inst_LO(.Y(LO), .A(mux64_2x1_res[31:0]));

endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

wire COs [31:0];
wire [31:0] res [31:0];

AND32_2x1 and32_2x1_inst(res[0], A, {32{B[0]}});
buf buf_inst_1(COs[0], 1'b0);
buf buf_inst_2(LO[0], res[0][0]);

genvar i;
generate
    for (i = 1; i < 32; i = i + 1)
    begin : adder_31_gen_loop
        wire [31:0] and_res;
        AND32_2x1 and32_2x1_inst(and_res, A, {32{B[i]}});
        RC_ADD_SUB_32 rc_add_sub_32_inst(.Y(res[i]), .CO(COs[i]), .A(and_res), .B({COs[i - 1], res[i - 1][31:1]}), .SnA(1'b0));
        buf buf_inst(LO[i], res[i][0]);
    end
endgenerate
BUF32 buf32_inst(.Y(HI), .A({COs[31], res[31][31:1]}));

endmodule
