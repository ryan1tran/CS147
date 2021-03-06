// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Apr 16, 2020	Ryan Tran	tranryanp@gmail.com	Register file implemented
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"

// This is going to be +ve edge clock triggered register file.
// Reset on RST=0
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

// input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

wire [`DATA_INDEX_LIMIT:0] decoder_result;
DECODER_5x32 decoder_5x32_inst1(.D(decoder_result), .I(ADDR_W));

wire [`DATA_INDEX_LIMIT:0] and_result;
wire [`DATA_INDEX_LIMIT:0] regi [`DATA_INDEX_LIMIT:0]; 

// generates 32 32-bit registers
genvar i;
generate
	for (i = 0; i <= `DATA_INDEX_LIMIT; i = i + 1)
	begin : reg32_generation_loop
		and and_write_inst(and_result[i], decoder_result[i], WRITE);
		REG32 reg32_inst(.Q(regi[i]), .D(DATA_W), .LOAD(and_result[i]), .CLK(CLK), .RESET(RST));
	end
endgenerate

wire [`DATA_INDEX_LIMIT:0] mux_result1, mux_result2;

MUX32_32x1 mux32_32x1_inst_1(.Y(mux_result1), .I0(regi[0]), .I1(regi[1]), .I2(regi[2]), .I3(regi[3]), .I4(regi[4]), .I5(regi[5]),
			     .I6(regi[6]), .I7(regi[7]), .I8(regi[8]), .I9(regi[9]), .I10(regi[10]), .I11(regi[11]), .I12(regi[12]),
			     .I13(regi[13]), .I14(regi[14]), .I15(regi[15]), .I16(regi[16]), .I17(regi[17]), .I18(regi[18]), .I19(regi[19]),
			     .I20(regi[20]), .I21(regi[21]), .I22(regi[22]), .I23(regi[23]), .I24(regi[24]), .I25(regi[25]), .I26(regi[26]),
			     .I27(regi[27]), .I28(regi[28]), .I29(regi[29]), .I30(regi[30]), .I31(regi[31]), .S(ADDR_R1));
                     
MUX32_32x1 mux32_32x1_inst_2(.Y(mux_result2), .I0(regi[0]), .I1(regi[1]), .I2(regi[2]), .I3(regi[3]), .I4(regi[4]), .I5(regi[5]),
			     .I6(regi[6]), .I7(regi[7]), .I8(regi[8]), .I9(regi[9]), .I10(regi[10]), .I11(regi[11]), .I12(regi[12]),
			     .I13(regi[13]), .I14(regi[14]), .I15(regi[15]), .I16(regi[16]), .I17(regi[17]), .I18(regi[18]), .I19(regi[19]),
			     .I20(regi[20]), .I21(regi[21]), .I22(regi[22]), .I23(regi[23]), .I24(regi[24]), .I25(regi[25]), .I26(regi[26]),
			     .I27(regi[27]), .I28(regi[28]), .I29(regi[29]), .I30(regi[30]), .I31(regi[31]), .S(ADDR_R2));
                     
MUX32_2x1 mux32_2x1_inst_1(.Y(DATA_R1), .I0({`DATA_WIDTH{1'bz}}), .I1(mux_result1), .S(READ));
MUX32_2x1 mux32_2x1_inst_2(.Y(DATA_R2), .I0({`DATA_WIDTH{1'bz}}), .I1(mux_result2), .S(READ));

endmodule
