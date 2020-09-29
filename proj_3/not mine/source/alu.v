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
//  - Integer add (0x1), sub(0x2), mul(0x3)
//  - Integer shift_rigth (0x4), shift_left (0x5)
//  - Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version  Date        Who     email           note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014    Kaushik Patra   kpatra@sjsu.edu     Initial creation
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

wire [`DATA_INDEX_LIMIT:0] unused;

wire [`DATA_INDEX_LIMIT:0] add_sub_res;
wire not_oprn0;
wire and_oprn3_oprn0;
wire SnA;
not not_oprn0_inst(not_oprn0, OPRN[0]);
and and_oprn3_oprn0_inst(and_oprn3_oprn0, OPRN[3], OPRN[0]);
or or_SnA_inst(SnA, not_oprn0, and_oprn3_oprn0);
RC_ADD_SUB_32 rc_add_sub_32_inst(.Y(add_sub_res), .CO(unused[0]), .A(OP1), .B(OP2), .SnA(SnA));

wire [`DATA_INDEX_LIMIT:0] mul_res;
MULT32 mult32_inst(.HI(unused), .LO(mul_res), .A(OP1), .B(OP2));

wire [`DATA_INDEX_LIMIT:0] shift_res;
SHIFT32 shift32_inst(.Y(shift_res), .D(OP1), .S(OP2), .LnR(OPRN[0]));

wire [`DATA_INDEX_LIMIT:0] and_res;
AND32_2x1 and32_2x1_inst(.Y(and_res), .A(OP1), .B(OP2));

wire [`DATA_INDEX_LIMIT:0] or_res;
OR32_2x1 or32_2x1_inst(.Y(or_res), .A(OP1), .B(OP2));

wire [`DATA_INDEX_LIMIT:0] nor_res;
NOR32_2x1 nor32_2x1_inst(.Y(nor_res), .A(OP1), .B(OP2));

MUX32_16x1 mux32_16x1_inst(.Y(OUT), .I0(unused), .I1(add_sub_res), .I2(add_sub_res), .I3(mul_res),
                           .I4(shift_res), .I5(shift_res), .I6(and_res), .I7(or_res),
                           .I8(nor_res), .I9({31'b0, add_sub_res[31]}), .I10(unused), .I11(unused),
                           .I12(unused), .I13(unused), .I14(unused), .I15(unused), .S(OPRN[3:0]));
                           
wire [31:0] zero_res;
or or_init_inst(zero_res[0], OUT[0], OUT[0]);
genvar i;
generate
    for (i = 1; i < 31; i = i + 1)
    begin : or_gen_loop
        or or_inst(zero_res[i], OUT[i], zero_res[i - 1]);
    end
endgenerate
wire not_zero;
or or_end_inst(not_zero, OUT[31], zero_res[30]);
not not_inst(ZERO, not_zero);

endmodule
