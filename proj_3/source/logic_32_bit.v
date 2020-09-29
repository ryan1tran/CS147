// Name: logic_32_bit.v
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
//  1.1     Apr 11, 2020	Ryan Tran	tranryanp@gmail.com	All 32-bit logic gates implemented
//  1.2	    Apr 14, 2020	Ryan Tran	tranryanp@gmail.com	32-bit BUF gate implemented
//------------------------------------------------------------------------------------------
//

// 32-bit NOR
module NOR32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;

// generates 32 NOR's
genvar i;
generate
	for (i = 0; i < 32; i = i + 1)
	begin: nor_32bit_generation_loop
		nor nor_inst1(Y[i], A[i], B[i]);
	end
endgenerate

endmodule

// 32-bit AND
module AND32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;

// generates 32 AND's
genvar i;
generate
	for (i = 0; i < 32; i = i + 1)
	begin: and_32bit_generation_loop
		and and_inst1(Y[i], A[i], B[i]);
	end
endgenerate

endmodule

// 32-bit inverter
module INV32_1x1(Y,A);
//output 
output [31:0] Y;
//input
input [31:0] A;

// generates 32 NOT's
genvar i;
generate
	for (i = 0; i < 32; i = i + 1)
	begin: inv_32bit_generation_loop
		not inv_inst1(Y[i], A[i]);
	end
endgenerate

endmodule

// 32-bit OR
module OR32_2x1(Y,A,B);
//output 
output [31:0] Y;
//input
input [31:0] A;
input [31:0] B;

wire [31:0] nor_result;

NOR32_2x1 nor32_2x1_inst1(.Y(nor_result), .A(A), .B(B));
INV32_1x1 inv32_1x1_inst1(.Y(Y), .A(nor_result));

endmodule

// 32-bit BUF
module BUF32_2x1(Y,A);
//output 
output [31:0] Y;
//input
input [31:0] A;

// generates 32 BUF's
genvar i;
generate
	for (i = 0; i < 32; i = i + 1)
	begin: buf_32bit_generation_loop
		buf buf_inst1(Y[i], A[i]);
	end
endgenerate

endmodule
