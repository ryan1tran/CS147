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
// Version  Date        Who     email           note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014    Kaushik Patra   kpatra@sjsu.edu     Initial creation
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

wire [`DATA_INDEX_LIMIT:0] decoder_5x32_res;
DECODER_5x32 decoder_5x32_inst(.D(decoder_5x32_res), .I(ADDR_W));

wire [`DATA_INDEX_LIMIT:0] and_write_res;
wire [`DATA_INDEX_LIMIT:0] reg_q [`DATA_INDEX_LIMIT:0]; 

genvar i;
generate
    for (i = 0; i <= `DATA_INDEX_LIMIT; i = i + 1)
    begin : reg_32_gen_loop
        and and_write_inst(and_write_res[i], decoder_5x32_res[i], WRITE);
        REG32 reg32_inst(.Q(reg_q[i]), .D(DATA_W), .LOAD(and_write_res[i]), .CLK(CLK), .RESET(RST));
    end
endgenerate

wire [`DATA_INDEX_LIMIT:0] mux_res_1, mux_res_2;

MUX32_32x1 mux32_32x1_inst_1(.Y(mux_res_1), .I0(reg_q[0]), .I1(reg_q[1]), .I2(reg_q[2]), .I3(reg_q[3]), .I4(reg_q[4]), .I5(reg_q[5]), .I6(reg_q[6]), .I7(reg_q[7]),
                     .I8(reg_q[8]), .I9(reg_q[9]), .I10(reg_q[10]), .I11(reg_q[11]), .I12(reg_q[12]), .I13(reg_q[13]), .I14(reg_q[14]), .I15(reg_q[15]),
                     .I16(reg_q[16]), .I17(reg_q[17]), .I18(reg_q[18]), .I19(reg_q[19]), .I20(reg_q[20]), .I21(reg_q[21]), .I22(reg_q[22]), .I23(reg_q[23]),
                     .I24(reg_q[24]), .I25(reg_q[25]), .I26(reg_q[26]), .I27(reg_q[27]), .I28(reg_q[28]), .I29(reg_q[29]), .I30(reg_q[30]), .I31(reg_q[31]), .S(ADDR_R1));
                     
MUX32_32x1 mux32_32x1_inst_2(.Y(mux_res_2), .I0(reg_q[0]), .I1(reg_q[1]), .I2(reg_q[2]), .I3(reg_q[3]), .I4(reg_q[4]), .I5(reg_q[5]), .I6(reg_q[6]), .I7(reg_q[7]),
                     .I8(reg_q[8]), .I9(reg_q[9]), .I10(reg_q[10]), .I11(reg_q[11]), .I12(reg_q[12]), .I13(reg_q[13]), .I14(reg_q[14]), .I15(reg_q[15]),
                     .I16(reg_q[16]), .I17(reg_q[17]), .I18(reg_q[18]), .I19(reg_q[19]), .I20(reg_q[20]), .I21(reg_q[21]), .I22(reg_q[22]), .I23(reg_q[23]),
                     .I24(reg_q[24]), .I25(reg_q[25]), .I26(reg_q[26]), .I27(reg_q[27]), .I28(reg_q[28]), .I29(reg_q[29]), .I30(reg_q[30]), .I31(reg_q[31]), .S(ADDR_R2));
                     
MUX32_2x1 mux32_2x1_inst_1(.Y(DATA_R1), .I0({`DATA_WIDTH{1'bz}}), .I1(mux_res_1), .S(READ));
MUX32_2x1 mux32_2x1_inst_2(.Y(DATA_R2), .I0({`DATA_WIDTH{1'bz}}), .I1(mux_res_2), .S(READ));

endmodule

// Behavioral model of RF from Project 2 because gate model of RF not working properly
module REGISTER_FILE_32x32_BEHAVIORAL(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

// Inputs
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

// Outputs
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

// 32x32 memory storage
reg [`DATA_INDEX_LIMIT:0] reg_32x32 [0:`REG_INDEX_LIMIT];

// For reset
integer i;

// Registers for outputs
reg [`DATA_INDEX_LIMIT:0] DATA_R1;
reg [`DATA_INDEX_LIMIT:0] DATA_R2;

// Initialize all 32 registers to 0
initial
begin
   for (i = 0; i <= `REG_INDEX_LIMIT; i = i + 1)
   begin
      reg_32x32[i] = {`DATA_WIDTH{1'b0}};
   end
end

always @ (negedge RST or posedge CLK)
begin
   if (RST === 1'b0) // Reset
   begin
      for (i = 0; i <= `REG_INDEX_LIMIT; i = i + 1)
      begin
         reg_32x32[i] = {`DATA_WIDTH{1'b0}};
      end
   end
   else
   begin
      if (READ === 1'b1 && WRITE === 1'b0) // Read
      begin
         DATA_R1 = reg_32x32[ADDR_R1];
         DATA_R2 = reg_32x32[ADDR_R2];
      end
      else if (READ === 1'b0 && WRITE === 1'b1) // Write
      begin
         reg_32x32[ADDR_W] = DATA_W;
      end
   end
end
endmodule

