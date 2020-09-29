// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
//
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_right (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version Date             Who               Email                    Note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//  1.2	    Feb 21, 2020	Ryan Tran	tranryanp@gmail.com	ALU implemented
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);

// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO;

// simulator internal storage for results
reg [`DATA_INDEX_LIMIT:0] OUT;
reg ZERO;

always @(OP1 or OP2 or OPRN)
begin
    case (OPRN)
        `ALU_OPRN_WIDTH'h20 : OUT = OP1 + OP2; // addition
	`ALU_OPRN_WIDTH'h22 : OUT = OP1 - OP2; // subtraction
	`ALU_OPRN_WIDTH'h2c : OUT = OP1 * OP2; // multiplication
	`ALU_OPRN_WIDTH'h02 : OUT = OP1 >> OP2; // shift right
	`ALU_OPRN_WIDTH'h01 : OUT = OP1 << OP2; // shift left
	`ALU_OPRN_WIDTH'h24 : OUT = OP1 & OP2; // bitwise and
	`ALU_OPRN_WIDTH'h25 : OUT = OP1 | OP2; // bitwise or
	`ALU_OPRN_WIDTH'h27 : OUT = ~(OP1 | OP2); // bitwise nor
	`ALU_OPRN_WIDTH'h2a : OUT = OP1 < OP2; // set less than
        default: OUT = `DATA_WIDTH'hxxxxxxxx; // default
                 
    endcase
	ZERO = OUT == 0 ? 1 : 0;
end

endmodule
