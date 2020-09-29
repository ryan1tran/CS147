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
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Apr 14, 2020	Ryan Tran	tranryanp@gmail.com	Both multipliers implemented
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

// 2's complement multiplicand and multiplier
wire [31:0] twos_mcnd;
wire [31:0] twos_mplr;
TWOSCOMP32 twoscomp32_inst1(.Y(twos_mcnd), .A(A));
TWOSCOMP32 twoscomp32_inst2(.Y(twos_mplr), .A(B));

// MUX to choose between non-complemented or 2's complemented based on original first bits
wire [31:0] mux_mcnd;
wire [31:0] mux_mclr;
MUX32_2x1 mux32_2x1_inst1(.Y(mux_mcnd), .I0(A), .I1(twos_mcnd), .S(A[31]));
MUX32_2x1 mux32_2x1_inst2(.Y(mux_mclr), .I0(B), .I1(twos_mplr), .S(B[31]));

// multiply unsigned
wire [63:0] multu_result;
MULT32_U mult32_u_inst1(.HI(multu_result[63:32]), .LO(multu_result[31:0]), .A(mux_mcnd), .B(mux_mclr));

// 2's complement of unsigned multiplication result
wire [63:0] mult_result;
TWOSCOMP64 twoscomp64_inst1(.Y(mult_result), .A(multu_result));

// XOR the original first bits to choose signed or unsignedd
wire xor_result;
xor xor_inst1(xor_result, A[31], B[31]);

// MUX to choose complement or non-complement for multiplication result
wire [63:0] mux_result;
MUX64_2x1 mux64_2x1_inst1(.Y(mux_result), .I0(multu_result), .I1(mult_result), .S(xor_result));

// store first 32 bits in HI and last 32 bits in LO
BUF32_2x1 buf32_inst1(.Y(HI), .A(mux_result[63:32]));
BUF32_2x1 buf32_inst2(.Y(LO), .A(mux_result[31:0]));

endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

wire carry [31:0];
wire [31:0] result [31:0];

AND32_2x1 and32_2x1_inst1(result[0], A, {32{B[0]}});
buf buf_inst1(carry[0], 1'b0);
buf buf_inst2(LO[0], result[0][0]);

genvar i;
generate
	for (i = 1; i < 32; i = i + 1)
	begin : adder_generation_loop
		wire [31:0] and_res;
		AND32_2x1 and32_2x1_inst(and_res, A, {32{B[i]}});
		RC_ADD_SUB_32 rc_add_sub_32_inst(.Y(result[i]), .CO(carry[i]),
		.A(and_res), .B({carry[i - 1], result[i - 1][31:1]}), .SnA(1'b0));
		buf buf_inst(LO[i], result[i][0]);
	end
endgenerate

BUF32_2x1 buf32_2x1_inst1(.Y(HI), .A({carry[31], result[31][31:1]}));

endmodule
