// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
// CTRL[0]  = pc_load
// CTRL[1]  = pc_sel_1
// CTRL[2]  = pc_sel_2
// CTRL[3]  = pc_sel_3
// CTRL[4]  = ir_load
// CTRL[5]  = r1_sel_1
// CTRL[6]  = reg_r
// CTRL[7]  = reg_w
// CTRL[8]  = sp_load
// CTRL[9]  = op1_sel_1
// CTRL[10] = op2_sel_1
// CTRL[11] = op2_sel_2
// CTRL[12] = op2_sel_3
// CTRL[13] = op2_sel_4
// CTRL[14] = alu_oprn[0]
// CTRL[15] = alu_oprn[1]
// CTRL[16] = alu_oprn[2]
// CTRL[17] = alu_oprn[3]
// CTRL[18] = alu_oprn[4]
// CTRL[19] = alu_oprn[5]
// CTRL[20] = ma_sel_1
// CTRL[21] = ma_sel_2
// CTRL[22] = md_sel_1
// CTRL[23] = wd_sel_1
// CTRL[24] = wd_sel_2
// CTRL[25] = wd_sel_3
// CTRL[26] = wa_sel_1
// CTRL[27] = wa_sel_2
// CTRL[28] = wa_sel_3
//
// Revision History:
//
// Version  Date        Who     email           note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014    Kaushik Patra   kpatra@sjsu.edu     Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output ZERO;
output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;

// input list
input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
input CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;

wire [`DATA_INDEX_LIMIT:0] R1_data, R2_data, alu_out, add_res_1, add_res_2,
                           op1_sel_1, op2_sel_1, op2_sel_2, op2_sel_3, op2_sel_4,
                           wd_sel_1, wd_sel_2, wd_sel_3, ma_sel_2, ma_sel_1,
                           pc_out, ir_res, sp_res, pc_sel_1, pc_sel_2, pc_sel_3;
wire [4:0] r1_sel_1, wa_sel_1, wa_sel_2, wa_sel_3;
wire unused;

BUF32 buf_inst(.Y(INSTRUCTION), .A(DATA_IN));

RC_ADD_SUB_32 add_1(.Y(add_res_1), .CO(unused), .A(32'b1), .B(pc_out), .SnA(1'b0));
RC_ADD_SUB_32 add_2(.Y(add_res_2), .CO(unused), .A(add_res_1), .B({{16{ir_res[15]}}, ir_res[15:0]}), .SnA(1'b0));

defparam pc_inst.PATTERN = `INST_START_ADDR;
REG32_PP pc_inst(.Q(pc_out), .D(pc_sel_3), .LOAD(CTRL[0]), .CLK(CLK), .RESET(RST));

MUX32_2x1 mux_pc_sel_1(.Y(pc_sel_1), .I0(R1_data), .I1(add_res_1), .S(CTRL[1]));
MUX32_2x1 mux_pc_sel_2(.Y(pc_sel_2), .I0(pc_sel_1), .I1(add_res_2), .S(CTRL[2]));
MUX32_2x1 mux_pc_sel_3(.Y(pc_sel_3), .I0({6'b0, ir_res[25:0]}), .I1(pc_sel_2), .S(CTRL[3]));

REG32 ir_inst(.Q(ir_res), .D(DATA_IN), .LOAD(CTRL[4]), .CLK(CLK), .RESET(RST));

MUX5_2x1 mux_r1_sel_1(.Y(r1_sel_1), .I0(ir_res[25:21]), .I1(5'b00000), .S(CTRL[5]));

REGISTER_FILE_32x32_BEHAVIORAL rf_32x32_inst(.DATA_R1(R1_data), .DATA_R2(R2_data), .ADDR_R1(r1_sel_1), .ADDR_R2(ir_res[20:16]), 
                                  .DATA_W(wd_sel_3), .ADDR_W(wa_sel_3), .READ(CTRL[6]), .WRITE(CTRL[7]), .CLK(CLK), .RST(RST));
                                  
defparam sp_inst.PATTERN = `INIT_STACK_POINTER;
REG32_PP sp_inst(.Q(sp_res), .D(alu_out), .LOAD(CTRL[8]), .CLK(CLK), .RESET(RST));

MUX32_2x1 mux_op1_sel_1(.Y(op1_sel_1), .I0(R1_data), .I1(sp_res), .S(CTRL[9]));

MUX32_2x1 mux_op2_sel_1(.Y(op2_sel_1), .I0(32'b1), .I1({27'b0, ir_res[10:6]}), .S(CTRL[10]));
MUX32_2x1 mux_op2_sel_2(.Y(op2_sel_2), .I0({16'b0, ir_res[15:0]}), .I1({{16{ir_res[15]}}, ir_res[15:0]}), .S(CTRL[11]));
MUX32_2x1 mux_op2_sel_3(.Y(op2_sel_3), .I0(op2_sel_2), .I1(op2_sel_1), .S(CTRL[12]));
MUX32_2x1 mux_op2_sel_4(.Y(op2_sel_4), .I0(op2_sel_3), .I1(R2_data), .S(CTRL[13]));
                                  
ALU alu_inst(.OUT(alu_out), .ZERO(ZERO), .OP1(op1_sel_1), .OP2(op2_sel_4), .OPRN(CTRL[19:14]));

MUX32_2x1 mux_ma_sel_1(.Y(ma_sel_1), .I0(alu_out), .I1(sp_res), .S(CTRL[20]));
MUX32_2x1 mux_ma_sel_2(.Y(ADDR), .I0(ma_sel_1), .I1(pc_out), .S(CTRL[21]));

MUX32_2x1 mux_md_sel_1(.Y(DATA_OUT), .I0(R2_data), .I1(R1_data), .S(CTRL[22]));

MUX32_2x1 mux_wd_sel_1(.Y(wd_sel_1), .I0(alu_out), .I1(DATA_IN), .S(CTRL[23]));
MUX32_2x1 mux_wd_sel_2(.Y(wd_sel_2), .I0(wd_sel_1), .I1({ir_res[15:0], 16'b0}), .S(CTRL[24]));
MUX32_2x1 mux_wd_sel_3(.Y(wd_sel_3), .I0(add_res_1), .I1(wd_sel_2), .S(CTRL[25]));

MUX5_2x1 mux_wa_sel_1(.Y(wa_sel_1), .I0(ir_res[15:11]), .I1(ir_res[20:16]), .S(CTRL[26]));
MUX5_2x1 mux_wa_sel_2(.Y(wa_sel_2), .I0(5'b00000), .I1(5'b11111), .S(CTRL[27]));
MUX5_2x1 mux_wa_sel_3(.Y(wa_sel_3), .I0(wa_sel_2), .I1(wa_sel_1), .S(CTRL[28]));

endmodule
