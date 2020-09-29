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
// Version  Date        Who     email           note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014    Kaushik Patra   kpatra@sjsu.edu     Initial creation
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

wire [63:0] XORs;
wire [64:0] CIs;

assign CO = CIs[64];
assign CIs[0] = SnA;

genvar i;
generate
    for (i = 0; i < 64; i = i + 1)
    begin : fa_64_gen_loop
        xor xor_inst(XORs[i], B[i], SnA);
        FULL_ADDER fa_inst(.S(Y[i]), .CO(CIs[i + 1]), .A(A[i]), .B(XORs[i]), .CI(CIs[i]));
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

wire [`DATA_INDEX_LIMIT:0] XORs;
wire [`DATA_WIDTH:0] CIs;

assign CO = CIs[`DATA_WIDTH];
assign CIs[0] = SnA;

genvar i;
generate
    for (i = 0; i < `DATA_WIDTH; i = i + 1)
    begin : fa_32_gen_loop
        xor xor_inst(XORs[i], B[i], SnA);
        FULL_ADDER fa_inst(.S(Y[i]), .CO(CIs[i + 1]), .A(A[i]), .B(XORs[i]), .CI(CIs[i]));
    end
endgenerate

endmodule

