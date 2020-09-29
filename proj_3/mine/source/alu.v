// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1	    Mar 15, 2020	Ryan Tran	tranryanp@gmail.com	ALU implemented
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO;

wire oprn0_inv;
not not_inst1(oprn0_inv, OPRN[0]);

wire oprn0and3;
and and_inst1(oprn0and3, OPRN[3], OPRN[0]);

wire SnA;
or or_inst1(SnA, oprn0_inv, oprn0and3);

wire [`DATA_INDEX_LIMIT:0] ripple_carry;
wire [`DATA_INDEX_LIMIT:0] NA; // to be used for irrelevant fields

// use NA[0] as CO
RC_ADD_SUB_32 rc_add_sub_32_inst1(.Y(ripple_carry), .CO(NA[0]), .A(OP1), .B(OP2), .SnA(SnA));

// multiply, but only 'lo' required
wire [`DATA_INDEX_LIMIT:0] mul_lo;
MULT32 mult32_inst1(.HI(NA), .LO(mul_lo), .A(OP1), .B(OP2));

wire [`DATA_INDEX_LIMIT:0] shift_result;
SHIFT32 shift32_inst1(.Y(shift_result), .D(OP1), .S(OP2), .LnR(OPRN[0]));

wire [`DATA_INDEX_LIMIT:0] and_result;
AND32_2x1 and32_2x1_inst1(.Y(and_result), .A(OP1), .B(OP2));

wire [`DATA_INDEX_LIMIT:0] or_result;
OR32_2x1 or32_2x1_inst1(.Y(or_result), .A(OP1), .B(OP2));

wire [`DATA_INDEX_LIMIT:0] nor_result;
NOR32_2x1 nor32_2x1_inst1(.Y(nor_result), .A(OP1), .B(OP2));

// place NA in any spots of the MUX that is unused
MUX32_16x1 mux32_16x1_inst1(.Y(OUT), .I0(NA), .I1(ripple_carry), .I2(ripple_carry), .I3(mul_lo),
                           .I4(shift_result), .I5(shift_result), .I6(and_result), .I7(or_result),
                           .I8(nor_result), .I9({31'b0, ripple_carry[31]}), .I10(NA), .I11(NA),
                           .I12(NA), .I13(NA), .I14(NA), .I15(NA), .S(OPRN[3:0]));
  
// OR then NOT to get ZERO field from OUT
wire [31:0] zero_result;
or or_inst2(zero_result[0], OUT[0], OUT[0]);

genvar i;
generate
	for (i = 1; i < 31; i = i + 1)
	begin : or_generation_loop
		or or_inst3(zero_result[i], OUT[i], zero_result[i - 1]);
	end
endgenerate

wire zero_inv;
or or_inst4(zero_inv, OUT[31], zero_result[30]);
not not_inst2(ZERO, zero_inv);

endmodule
