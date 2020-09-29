// Name: mux.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version  Date        Who     email           note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014    Kaushik Patra   kpatra@sjsu.edu     Initial creation
//------------------------------------------------------------------------------------------
//
// 32-bit mux
module MUX32_32x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15,
                     I16, I17, I18, I19, I20, I21, I22, I23,
                     I24, I25, I26, I27, I28, I29, I30, I31, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0, I1, I2, I3, I4, I5, I6, I7;
input [31:0] I8, I9, I10, I11, I12, I13, I14, I15;
input [31:0] I16, I17, I18, I19, I20, I21, I22, I23;
input [31:0] I24, I25, I26, I27, I28, I29, I30, I31;
input [4:0] S;

wire [31:0] mux32_16x1_res_1;
wire [31:0] mux32_16x1_res_2;

MUX32_16x1 mux32_16x1_inst_1(.Y(mux32_16x1_res_1), .I0(I0), .I1(I1), .I2(I2), .I3(I3),
                             .I4(I4), .I5(I5), .I6(I6), .I7(I7),
                             .I8(I8), .I9(I9), .I10(I10), .I11(I11),
                             .I12(I12), .I13(I13), .I14(I14), .I15(I15), .S(S[3:0]));
MUX32_16x1 mux32_16x1_inst_2(.Y(mux32_16x1_res_2), .I0(I16), .I1(I17), .I2(I18), .I3(I19),
                             .I4(I20), .I5(I21), .I6(I22), .I7(I23),
                             .I8(I24), .I9(I25), .I10(I26), .I11(I27),
                             .I12(I28), .I13(I29), .I14(I30), .I15(I31), .S(S[3:0]));
MUX32_2x1 mux32_2x1_inst(.Y(Y), .I0(mux32_16x1_res_1), .I1(mux32_16x1_res_2), .S(S[4]));

endmodule

// 32-bit 16x1 mux
module MUX32_16x1(Y, I0, I1, I2, I3, I4, I5, I6, I7,
                     I8, I9, I10, I11, I12, I13, I14, I15, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [31:0] I4;
input [31:0] I5;
input [31:0] I6;
input [31:0] I7;
input [31:0] I8;
input [31:0] I9;
input [31:0] I10;
input [31:0] I11;
input [31:0] I12;
input [31:0] I13;
input [31:0] I14;
input [31:0] I15;
input [3:0] S;

wire [31:0] mux32_8x1_res_1;
wire [31:0] mux32_8x1_res_2;

MUX32_8x1 mux32_8x1_inst_1(.Y(mux32_8x1_res_1), .I0(I0), .I1(I1), .I2(I2), .I3(I3),
                           .I4(I4), .I5(I5), .I6(I6), .I7(I7), .S(S[2:0]));
MUX32_8x1 mux32_8x1_inst_2(.Y(mux32_8x1_res_2), .I0(I8), .I1(I9), .I2(I10), .I3(I11),
                           .I4(I12), .I5(I13), .I6(I14), .I7(I15), .S(S[2:0]));
MUX32_2x1 mux32_2x1_inst(.Y(Y), .I0(mux32_8x1_res_1), .I1(mux32_8x1_res_2), .S(S[3]));

endmodule

// 32-bit 8x1 mux
module MUX32_8x1(Y, I0, I1, I2, I3, I4, I5, I6, I7, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [31:0] I4;
input [31:0] I5;
input [31:0] I6;
input [31:0] I7;
input [2:0] S;

wire [31:0] mux32_4x1_res_1;
wire [31:0] mux32_4x1_res_2;

MUX32_4x1 mux32_4x1_inst_1(.Y(mux32_4x1_res_1), .I0(I0), .I1(I1),
                           .I2(I2), .I3(I3), .S(S[1:0]));
MUX32_4x1 mux32_4x1_inst_2(.Y(mux32_4x1_res_2), .I0(I4), .I1(I5),
                           .I2(I6), .I3(I7), .S(S[1:0]));
MUX32_2x1 mux32_2x1_inst(.Y(Y), .I0(mux32_4x1_res_1), .I1(mux32_4x1_res_2), .S(S[2]));

endmodule

// 32-bit 4x1 mux
module MUX32_4x1(Y, I0, I1, I2, I3, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input [31:0] I2;
input [31:0] I3;
input [1:0] S;

wire [31:0] mux32_2x1_res_1;
wire [31:0] mux32_2x1_res_2;

MUX32_2x1 mux32_2x1_inst_1(.Y(mux32_2x1_res_1), .I0(I0), .I1(I1), .S(S[0]));
MUX32_2x1 mux32_2x1_inst_2(.Y(mux32_2x1_res_2), .I0(I2), .I1(I3), .S(S[0]));
MUX32_2x1 mux32_2x1_inst_3(.Y(Y), .I0(mux32_2x1_res_1), .I1(mux32_2x1_res_2), .S(S[1]));

endmodule

// 64-bit mux
module MUX64_2x1(Y, I0, I1, S);
// output list
output [63:0] Y;
//input list
input [63:0] I0;
input [63:0] I1;
input S;

genvar i;
generate
    for (i = 0; i < 64; i = i + 1)
    begin : mux1_2x1_gen_loop
        MUX1_2x1 mux1_2x1_inst(Y[i], I0[i], I1[i], S);
    end
endgenerate

endmodule

// 32-bit mux
module MUX32_2x1(Y, I0, I1, S);
// output list
output [31:0] Y;
//input list
input [31:0] I0;
input [31:0] I1;
input S;

genvar i;
generate
    for (i = 0; i < 32; i = i + 1)
    begin : mux1_2x1_gen_loop
        MUX1_2x1 mux1_2x1_inst(Y[i], I0[i], I1[i], S);
    end
endgenerate

endmodule

// 1-bit mux
module MUX1_2x1(Y, I0, I1, S);
//output list
output Y;
//input list
input I0, I1, S;

wire s_not, and_1, and_2;

not not_inst(s_not, S);
and and_inst_1(and_1, I0, s_not);
and and_inst_2(and_2, I1, S);
or or_inst(Y, and_1, and_2);

endmodule

// 5-bit mux
module MUX5_2x1(Y, I0, I1, S);
// output list
output [4:0] Y;
//input list
input [4:0] I0;
input [4:0] I1;
input S;

genvar i;
generate
    for (i = 0; i < 5; i = i + 1)
    begin : mux1_2x1_gen_loop
        MUX1_2x1 mux1_2x1_inst(Y[i], I0[i], I1[i], S);
    end
endgenerate

endmodule