// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Apr 13, 2020	Ryan Tran	tranryanp@gmail.com	Shift amount and direction controlled barrel shifters implemented
//  1.2     Apr 15, 2020	Ryan Tran	tranryanp@gmail.com	Shift right and shift left implemented
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [31:0] S;
input LnR;

wire [31:0] shift_result;
BARREL_SHIFTER32 barrel_shifter32_inst(.Y(shift_result), .D(D), .S(S[4:0]), .LnR(LnR));

wire [31:5] or_result;
or or_inst1(or_result[5], S[5], S[5]);
genvar i;
generate
	for (i = 6; i <= 31; i = i + 1)
	begin : or_generation_loop
		or or_inst2(or_result[i], S[i], or_result[i - 1]);
	end
endgenerate

MUX32_2x1 mux32_2x1_inst1(.Y(Y), .I0(shift_result), .I1(32'b0), .S(or_result[31]));

endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
input LnR;

wire [31:0] shift32r_result;
wire [31:0] shift32l_result;

SHIFT32_R shift32_r_inst1(.Y(shift32r_result), .D(D), .S(S));
SHIFT32_L shift32_l_inst1(.Y(shift32l_result), .D(D), .S(S));
MUX32_2x1 mux32_2x1_inst1(.Y(Y), .I0(shift32r_result), .I1(shift32l_result), .S(LnR));

endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

wire [31:0] result [3:0];

genvar i, j;
generate
	for (i = 0; i < 32; i = i + 1)
	begin : mux_generation_loop_1
		if (i == 31)
		begin
			MUX1_2x1 mux_inst_1(.Y(result[0][i]), .I0(D[i]), .I1(1'b0), .S(S[0]));
		end
		else
		begin
			MUX1_2x1 mux_inst_2(.Y(result[0][i]), .I0(D[i]), .I1(D[i + 1]), .S(S[0]));
		end
	end

	for (i = 1; i < 4; i = i + 1)
	begin : mux_generation_loop_2
		for (j = 0; j < 32; j = j + 1)
		begin : mux_generation_loop_2_inner
			if (j > 31 - (2 ** i))
			begin
				MUX1_2x1 mux_inst_3(.Y(result[i][j]), .I0(result[i - 1][j]), .I1(1'b0), .S(S[i]));
			end
			else
			begin
				MUX1_2x1 mux_inst_4(.Y(result[i][j]), .I0(result[i - 1][j]), .I1(result[i - 1][j + 2 ** i]), .S(S[i]));
			end
		end
	end

	for (i = 0; i < 32; i = i + 1)
	begin : mux_generation_loop_3
		if (i > 15)
		begin
			MUX1_2x1 mux_inst_5(.Y(Y[i]), .I0(result[3][i]), .I1(1'b0), .S(S[4]));
		end
		else
		begin
			MUX1_2x1 mux_inst_6(.Y(Y[i]), .I0(result[3][i]), .I1(result[3][i + 16]), .S(S[4]));
		end
	end
endgenerate

endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

wire [31:0] result [3:0];

genvar i, j;
generate
	for (i = 0; i < 32; i = i + 1)
	begin : mux_generation_loop_1
		if (i == 0)
		begin
			MUX1_2x1 mux_inst_1(.Y(result[0][i]), .I0(D[i]), .I1(1'b0), .S(S[0]));
		end
		else
		begin
		MUX1_2x1 mux_inst_2(.Y(result[0][i]), .I0(D[i]), .I1(D[i - 1]), .S(S[0]));
		end
	end

	for (i = 1; i < 4; i = i + 1)
	begin : mux_generation_loop_2
		for (j = 0; j < 32; j = j + 1)
		begin : mux_generation_loop_2_inner
			if (j < 2 ** i)
			begin
				MUX1_2x1 mux_inst_3(.Y(result[i][j]), .I0(result[i - 1][j]), .I1(1'b0), .S(S[i]));
			end
			else
			begin
				MUX1_2x1 mux_inst_4(.Y(result[i][j]), .I0(result[i - 1][j]), .I1(result[i - 1][j - 2 ** i]), .S(S[i]));
			end
		end
	end
    
	for (i = 0; i < 32; i = i + 1)
	begin : mux_generation_loop_3
		if (i < 16)
		begin
			MUX1_2x1 mux_inst_5(.Y(Y[i]), .I0(result[3][i]), .I1(1'b0), .S(S[4]));
		end
		else
		begin
			MUX1_2x1 mux_inst_6(.Y(Y[i]), .I0(result[3][i]), .I1(result[3][i - 16]), .S(S[4]));
		end
	end
endgenerate

endmodule

