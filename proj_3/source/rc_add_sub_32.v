// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Apr 10, 2020	Ryan Tran	tranryanp@gmail.com	Ripple carry adder/subtractor implemented
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;

// additional wires to contain sum and carry results
wire [63:0] sum;
// one more carry than sum results because there is an initial carry
wire [64:0] carry;

// assign carry to CO since carries are the previous CO
assign CO = carry[64];
// the first carry is dependent on if it is addition or subtraction
assign carry[0] = SnA;

// use generate to generate a new instance of the full adder per iteration
genvar i;
generate
	for (i = 0; i < 64; i = i + 1)
	begin: FA_64bit_generation_loop
		xor xor_inst1(sum[i], B[i], SnA);
		FULL_ADDER FA_inst1(.S(Y[i]), .CO(carry[i + 1]), .A(A[i]), .B(sum[i]), .CI(carry[i]));
	end
endgenerate

endmodule

module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input SnA;

// additional wires to contain sum and carry results
wire [`DATA_INDEX_LIMIT:0] sum;
// one more carry than sum results because there is an initial carry
wire [`DATA_WIDTH:0] carry;

// assign carry to CO since carries are the previous CO
assign CO = carry[`DATA_WIDTH];
// the first carry is dependent on if it is addition or subtraction
assign carry[0] = SnA;

// use generate to generate a new instance of the full adder per iteration
genvar i;
generate
	for (i = 0; i < `DATA_WIDTH; i = i + 1)
	begin : FA_32bit_generation_loop
		xor xor_inst1(sum[i], B[i], SnA);
		FULL_ADDER FA_inst1(.S(Y[i]), .CO(carry[i + 1]), .A(A[i]), .B(sum[i]), .CI(carry[i]));
	end
endgenerate

endmodule

