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
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Apr 12, 2020	Ryan Tran	tranryanp@gmail.com	All line decoders and 2's complement implemented
//  1.2	    Apr 16, 2020	Ryan Tran	tranryanp@gmail.com	SR_latch, D_latch, FlipFlop and registers implemented
//------------------------------------------------------------------------------------------
//
// 64-bit two's complement
module TWOSCOMP64(Y,A);
//output list
output [63:0] Y;
//input list
input [63:0] A;

wire [63:0] A_inv;
INV32_1x1 inv32_inst1(A_inv[31:0], A[31:0]);
INV32_1x1 inv32_inst2(A_inv[63:32], A[63:32]);

wire CO;
RC_ADD_SUB_64 rc_add_sub_64_inst1(.Y(Y), .CO(CO), .A(A_inv), .B(64'b1), .SnA(1'b0));

endmodule

// 32-bit two's complement
module TWOSCOMP32(Y,A);
//output list
output [31:0] Y;
//input list
input [31:0] A;

wire [31:0] A_inv;
INV32_1x1 inv32_inst1(A_inv, A);

wire CO;
RC_ADD_SUB_32 RC_add_sub_32_inst1(.Y(Y), .CO(CO), .A(A_inv), .B(32'b1), .SnA(1'b0));

endmodule

// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

wire NA; // for unnecessary Qbar in register

// generates 32 1-bit registers
genvar i;
generate
	for (i = 0; i < 32; i = i + 1)
	begin : reg1_generation_loop
		REG1 reg1_inst1(.Q(Q[i]), .Qbar(NA), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET));
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
output Q,Qbar;

wire mux_result, q_d_ff;
MUX1_2x1 mux1_2x1_inst1(.Y(mux_result), .I0(q_d_ff), .I1(D), .S(L));

D_FF d_ff_inst1(.Q(q_d_ff), .Qbar(Qbar), .D(mux_result), .C(C), .nP(nP), .nR(nR));

buf buf_inst1(Q, q_d_ff);

endmodule

// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

wire c_inv;
not not_inst1(c_inv, C);

wire Y, Ybar;
D_LATCH d_latch_inst(.Q(Y), .Qbar(Ybar), .D(D), .C(c_inv), .nP(nP), .nR(nR));
SR_LATCH sr_latch_inst(.Q(Q), .Qbar(Qbar), .S(Y), .R(Ybar), .C(C), .nP(nP), .nR(nR));

endmodule

// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

wire d_inv;
not not_inst(d_inv, D);

SR_LATCH sr_latch_inst1(.Q(Q), .Qbar(Qbar), .S(D), .R(d_inv), .C(C), .nP(nP), .nR(nR));

endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q,Qbar;

wire nand_SC;
nand nand_sc_inst(nand_SC, S, C);

wire nand_RC;
nand nand_rc_inst(nand_RC, R, C);

wire nand_sQbar, nand_rQ;

wire and_1, and_2;
and and_inst1(and_1, nP, nand_SC);
and and_inst2(and_2, and_1, nand_rQ);
not not_inst1(nand_sQbar, and_2);

wire and_3, and_4;
and and_inst3(and_3, nR, nand_RC);
and and_inst4(and_4, and_3, nand_sQbar);
not not_inst2(nand_rQ, and_4);

buf buf_inst1(Q, nand_sQbar);
buf buf_inst2(Qbar, nand_rQ);

endmodule

// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [31:0] D;
// input
input [4:0] I;

wire I4_inv;
not not_inst1(I4_inv, I[4]);

wire [15:0] decoder_4x16_result;
DECODER_4x16 decoder_4x16_inst1(.D(decoder_4x16_result), .I(I[3:0]));

genvar i;
generate
	for (i = 0; i < 16; i = i + 1)
	begin : and_generation_loop
		and and_inst1(D[i], decoder_4x16_result[i], I4_inv);
		and and_inst2(D[i + 16], decoder_4x16_result[i], I[4]);
	end
endgenerate

endmodule

// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;

wire I3_inv;
not not_inst1(I3_inv, I[3]);

wire [7:0] decoder_3x8_result;
DECODER_3x8 decoder_3x8_inst1(.D(decoder_3x8_result), .I(I[2:0]));

genvar i;
generate
	for (i = 0; i < 8; i = i + 1)
	begin : and_generation_loop
		and and_inst_1(D[i], decoder_3x8_result[i], I3_inv);
		and and_inst_2(D[i + 8], decoder_3x8_result[i], I[3]);
	end
endgenerate

endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;

wire I2_inv;
not not_inst1(I2_inv, I[2]);

wire [3:0] decoder_2x4_result;
DECODER_2x4 decoder_2x4_inst1(.D(decoder_2x4_result), .I(I[1:0]));

// pattern of wire connections for decoders
genvar i;
generate
	for (i = 0; i < 4; i = i + 1)
	begin : and_generation_loop
		and and_inst1(D[i], decoder_2x4_result[i], I2_inv);
		and and_inst2(D[i + 4], decoder_2x4_result[i], I[2]);
	end
endgenerate

endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;

wire [1:0] I_inv;

not not_inst1(I_inv[0], I[0]);
not not_inst2(I_inv[1], I[1]);

and and_inst1(D[0], I_inv[1], I_inv[0]);
and and_inst2(D[1], I_inv[1], I[0]);
and and_inst3(D[2], I[1], I_inv[0]);
and and_inst4(D[3], I[1], I[0]);

endmodule
