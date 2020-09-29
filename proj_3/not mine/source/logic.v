// Name: logic.v
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
// 64-bit two's complement
module TWOSCOMP64(Y, A);
//output list
output [63:0] Y;
//input list
input [63:0] A;

wire [63:0] inv_res;
wire CO;

INV64_1x1 inv64_1x1_inst(inv_res, A);
RC_ADD_SUB_64 rc_add_sub_64_inst(.Y(Y), .CO(CO), .A(inv_res), .B(64'b1), .SnA(1'b0));

endmodule

// 32-bit two's complement
module TWOSCOMP32(Y, A);
//output list
output [31:0] Y;
//input list
input [31:0] A;

wire [31:0] inv_res;
wire CO;

INV32_1x1 inv32_1x1_inst(inv_res, A);
RC_ADD_SUB_32 rc_add_sub_32_inst(.Y(Y), .CO(CO), .A(inv_res), .B(32'b1), .SnA(1'b0));

endmodule

// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

wire unused;

genvar i;
generate
    for (i = 0; i < 32; i = i + 1)
    begin : reg1_32_gen_loop
        REG1 reg1_inst(.Q(Q[i]), .Qbar(unused), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET));
    end
endgenerate

endmodule

// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
input D, C, L;
input nP, nR;
output Q, Qbar;

wire mux_res;
wire d_ff_q;

MUX1_2x1 mux1_2x1_inst(.Y(mux_res), .I0(d_ff_q), .I1(D), .S(L));
D_FF d_ff_inst(.Q(d_ff_q), .Qbar(Qbar), .D(mux_res), .C(C), .nP(nP), .nR(nR));

buf buf_inst(Q, d_ff_q);

endmodule

// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q, Qbar;

wire Y, Ybar;
wire not_c;

not not_inst(not_c, C);

D_LATCH d_latch_inst(.Q(Y), .Qbar(Ybar), .D(D), .C(not_c), .nP(nP), .nR(nR));
SR_LATCH sr_latch_inst(.Q(Q), .Qbar(Qbar), .S(Y), .R(Ybar), .C(C), .nP(nP), .nR(nR));

endmodule

// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q, Qbar;

wire not_d;

not not_inst(not_d, D);

SR_LATCH sr_latch_inst(.Q(Q), .Qbar(Qbar), .S(D), .R(not_d), .C(C), .nP(nP), .nR(nR));

endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q, Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q, Qbar;

wire nand_sc_res;
wire nand_rc_res;
wire nand_sQbar_res;
wire nand_rq_res;

nand nand_sc_inst(nand_sc_res, S, C);
nand nand_rc_inst(nand_rc_res, R, C);

NAND_3x1 nand_3x1_sQbar_inst(.Y(nand_sQbar_res), .A(nP), .B(nand_sc_res), .C(nand_rq_res));
NAND_3x1 nand_3x1_rq_inst(.Y(nand_rq_res), .A(nR), .B(nand_rc_res), .C(nand_sQbar_res));

buf buf_inst_1(Q, nand_sQbar_res);
buf buf_inst_2(Qbar, nand_rq_res);

endmodule

// 5x32 Line decoder
module DECODER_5x32(D, I);
// output
output [31:0] D;
// input
input [4:0] I;

wire I4_not;
not not_inst(I4_not, I[4]);

wire [15:0] decoder_4x16_res;
DECODER_4x16 decoder_4x16_inst(.D(decoder_4x16_res), .I(I[3:0]));

genvar i;
generate
    for (i = 0; i < 16; i = i + 1)
    begin : and_32_gen_loop
        and and_inst_1(D[i], decoder_4x16_res[i], I4_not);
        and and_inst_2(D[i + 16], decoder_4x16_res[i], I[4]);
    end
endgenerate

endmodule

// 4x16 Line decoder
module DECODER_4x16(D, I);
// output
output [15:0] D;
// input
input [3:0] I;

wire I3_not;
not not_inst(I3_not, I[3]);

wire [7:0] decoder_3x8_res;
DECODER_3x8 decoder_3x8_inst(.D(decoder_3x8_res), .I(I[2:0]));

genvar i;
generate
    for (i = 0; i < 8; i = i + 1)
    begin : and_16_gen_loop
        and and_inst_1(D[i], decoder_3x8_res[i], I3_not);
        and and_inst_2(D[i + 8], decoder_3x8_res[i], I[3]);
    end
endgenerate

endmodule

// 3x8 Line decoder
module DECODER_3x8(D, I);
// output
output [7:0] D;
// input
input [2:0] I;

wire I2_not;
not not_inst(I2_not, I[2]);

wire [3:0] decoder_2x4_res;
DECODER_2x4 decoder_2x4_inst(.D(decoder_2x4_res), .I(I[1:0]));

genvar i;
generate
    for (i = 0; i < 4; i = i + 1)
    begin : and_8_gen_loop
        and and_inst_1(D[i], decoder_2x4_res[i], I2_not);
        and and_inst_2(D[i + 4], decoder_2x4_res[i], I[2]);
    end
endgenerate

endmodule

// 2x4 Line decoder
module DECODER_2x4(D, I);
// output
output [3:0] D;
// input
input [1:0] I;

wire [1:0] I_not;

not not_inst_1(I_not[0], I[0]);
not not_inst_2(I_not[1], I[1]);

and and_inst_1(D[0], I_not[1], I_not[0]);
and and_inst_2(D[1], I_not[1], I[0]);
and and_inst_3(D[2], I[1], I_not[0]);
and and_inst_4(D[3], I[1], I[0]);

endmodule

module NAND_3x1(Y, A, B, C);
output Y;
input A, B, C;

wire res_1, res_2;

and and_inst_1(res_1, A, B);
and and_inst_2(res_2, res_1, C);
not not_inst(Y, res_2);

endmodule

// For instruction register: 32-bit D-Latch instead of register with D_FF for clock synchronization ease
/*module D_LATCH_32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

wire unused;

genvar i;
generate
    for (i = 0; i < 32; i = i + 1)
    begin : d_latch_32_gen_loop
        D_LATCH d_latch_inst(.Q(Q[i]), .Qbar(unused), .D(D[i]), .C(CLK), .nP(1'b1), .nR(RESET));
    end
endgenerate

endmodule*/