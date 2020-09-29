// Name: state_machine_tb.v
// Module: STATE_MACHINE_TB
//
// Monitors:  DATA : Data to be written at address ADDR
//            ADDR : Address of the memory location to be accessed
//            READ : Read signal
//            WRITE: Write signal
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - Testbench for CU's state machine
//
// Revision History:
//
// Version Date             Who           Email                    Note
//------------------------------------------------------------------------------------------
// 1.0     Oct 02, 2019	    Ryan Tran     ryan.l.tran@sjsu.edu     Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module STATE_MACHINE_TB;

// Wires to CU outputs
wire [`DATA_INDEX_LIMIT:0] MEM_DATA;
wire [`DATA_INDEX_LIMIT:0] RF_DATA_W;
wire [`REG_ADDR_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
wire RF_READ, RF_WRITE;
wire [`DATA_INDEX_LIMIT:0] ALU_OP1, ALU_OP2;
wire [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
wire [`ADDRESS_INDEX_LIMIT:0] MEM_ADDR;
wire MEM_READ, MEM_WRITE;
wire CLK;

// Registers to CU inputs
reg [`DATA_INDEX_LIMIT:0] RF_DATA_R1, RF_DATA_R2, ALU_RESULT;
reg ZERO, RST;

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));

// Control unit instance
CONTROL_UNIT control_unit_inst(.MEM_DATA(MEM_DATA), .RF_DATA_W(RF_DATA_W), .RF_ADDR_W(RF_ADDR_W), .RF_ADDR_R1(RF_ADDR_R1), .RF_ADDR_R2(RF_ADDR_R2), .RF_READ(RF_READ), .RF_WRITE(RF_WRITE),
                    .ALU_OP1(ALU_OP1), .ALU_OP2(ALU_OP2), .ALU_OPRN(ALU_OPRN), .MEM_ADDR(MEM_ADDR), .MEM_READ(MEM_READ), .MEM_WRITE(MEM_WRITE),
                    .RF_DATA_R1(RF_DATA_R1), .RF_DATA_R2(RF_DATA_R2), .ALU_RESULT(ALU_RESULT), .ZERO(ZERO), .CLK(CLK), .RST(RST));

initial
begin
RST = 1'b0;

#15     RST = 1'b1;
#20     RST = 1'b0;

#100   $write("Finished CU's state machine testing.");  
       $stop;
end
endmodule

