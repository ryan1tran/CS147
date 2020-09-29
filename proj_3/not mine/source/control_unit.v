// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: CTRL  : Control signal for data path
//         READ  : Memory read signal
//         WRITE : Memory Write signal
//
// Input:  ZERO : Zero status from ALU
//         CLK  : Clock signal
//         RST  : Reset Signal
//
// Notes: - Control unit synchronize operations of a processor
//          Assign each bit of control signal to control one part of data path
//
// Revision History:
//
// Version  Date        Who     email           note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014    Kaushik Patra   kpatra@sjsu.edu     Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(CTRL, READ, WRITE, ZERO, INSTRUCTION, CLK, RST); 
// Output signals
output [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
output READ, WRITE;

// input signals
input ZERO, CLK, RST;
input [`DATA_INDEX_LIMIT:0] INSTRUCTION;

reg [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
reg READ, WRITE;
reg [`DATA_INDEX_LIMIT:0] INSTR;

wire [2:0] proc_state;
PROC_SM state_machine(.STATE(proc_state), .CLK(CLK), .RST(RST));

always @ (proc_state)
begin
    if (proc_state === `PROC_FETCH)
    begin
        READ = 1'b1;
        WRITE = 1'b0;
        CTRL = `CTRL_WIDTH'h00200000;
    end
    
    else if (proc_state === `PROC_DECODE)
    begin
        INSTR = INSTRUCTION;
        if (INSTR[31:26] === 6'h1b) // push
        begin
            CTRL = `CTRL_WIDTH'h00000070;
        end
        else if (INSTR[31:26] === 6'h0f || INSTR[31:26] === 6'h02 ||
                 INSTR[31:26] === 6'h03 || INSTR[31:26] === 6'h1c) // lui, jmp, jal, pop
        begin
            CTRL = `CTRL_WIDTH'h00000010;
        end
        else
        begin
            CTRL = `CTRL_WIDTH'h00000050; // everything else
        end
    end
    
    else if (proc_state === `PROC_EXE)
    begin
        /* R-Type */
        if (INSTR[31:26] === 6'h00)
        begin
            if (INSTR[5:0] === 6'h20) // add
            begin
                CTRL = `CTRL_WIDTH'h00006000;
            end
            else if (INSTR[5:0] === 6'h22) // sub
            begin
                CTRL = `CTRL_WIDTH'h0000A000;
            end
            else if (INSTR[5:0] === 6'h2c) // mul
            begin
                CTRL = `CTRL_WIDTH'h0000E000;
            end
            else if (INSTR[5:0] === 6'h24) // and
            begin
                CTRL = `CTRL_WIDTH'h0001A000;
            end
            else if (INSTR[5:0] === 6'h25) // or
            begin
                CTRL = `CTRL_WIDTH'h0001E000;
            end
            else if (INSTR[5:0] === 6'h27) // nor
            begin
                CTRL = `CTRL_WIDTH'h00022000;
            end
            else if (INSTR[5:0] === 6'h2a) // slt
            begin
                CTRL = `CTRL_WIDTH'h00026000;
            end
            else if (INSTR[5:0] === 6'h01) // sll
            begin
                CTRL = `CTRL_WIDTH'h00015400;
            end
            else if (INSTR[5:0] === 6'h02) // srl
            begin
                CTRL = `CTRL_WIDTH'h00011400;
            end
            else if (INSTR[5:0] === 6'h08) // jr
            begin
                CTRL = `CTRL_WIDTH'h00000000;
            end
        end
        
        else // I-Type and J-Type
        begin
            /* I-Type */
            if (INSTR[31:26] === 6'h08) // addi
            begin
                CTRL = `CTRL_WIDTH'h00004800;
            end
            else if (INSTR[31:26] === 6'h1d) // muli
            begin
                CTRL = `CTRL_WIDTH'h0000C800;
            end
            else if (INSTR[31:26] === 6'h0c) // andi
            begin
                CTRL = `CTRL_WIDTH'h00018000;
            end
            else if (INSTR[31:26] === 6'h0d) // ori
            begin
                CTRL = `CTRL_WIDTH'h0001C000;
            end
            else if (INSTR[31:26] === 6'h0f) // lui
            begin
                CTRL = `CTRL_WIDTH'h00000000;
            end
            else if (INSTR[31:26] === 6'h0a) // stli
            begin
                CTRL = `CTRL_WIDTH'h00024800;
            end
            else if (INSTR[31:26] === 6'h04) // beq
            begin
                CTRL = `CTRL_WIDTH'h0000A000;
            end
            else if (INSTR[31:26] === 6'h05) // bne
            begin
                CTRL = `CTRL_WIDTH'h0000A000;
            end
            else if (INSTR[31:26] === 6'h23) // lw
            begin
                CTRL = `CTRL_WIDTH'h00004800;
            end
            else if (INSTR[31:26] === 6'h2b) // sw
            begin
                CTRL = `CTRL_WIDTH'h00004800;
            end
            
            /* J-Type */
            else if (INSTR[31:26] === 6'h02) // jmp
            begin
                CTRL = `CTRL_WIDTH'h00000000;
            end
            else if (INSTR[31:26] === 6'h03) // jal
            begin
                CTRL = `CTRL_WIDTH'h00000000;
            end
            else if (INSTR[31:26] === 6'h1b) // push
            begin
                CTRL = `CTRL_WIDTH'h00009200;
            end
            else if (INSTR[31:26] === 6'h1c) // pop
            begin
                CTRL = `CTRL_WIDTH'h00005300;
            end
        end
    end
    
    else if (proc_state === `PROC_MEM)
    begin
        /* R-Type */
        if (INSTR[31:26] === 6'h00)
        begin
            if (INSTR[5:0] === 6'h20) // add
            begin
                CTRL = `CTRL_WIDTH'h00006000;
            end
            else if (INSTR[5:0] === 6'h22) // sub
            begin
                CTRL = `CTRL_WIDTH'h0000A000;
            end
            else if (INSTR[5:0] === 6'h2c) // mul
            begin
                CTRL = `CTRL_WIDTH'h0000E000;
            end
            else if (INSTR[5:0] === 6'h24) // and
            begin
                CTRL = `CTRL_WIDTH'h0001A000;
            end
            else if (INSTR[5:0] === 6'h25) // or
            begin
                CTRL = `CTRL_WIDTH'h0001E000;
            end
            else if (INSTR[5:0] === 6'h27) // nor
            begin
                CTRL = `CTRL_WIDTH'h00022000;
            end
            else if (INSTR[5:0] === 6'h2a) // slt
            begin
                CTRL = `CTRL_WIDTH'h00026000;
            end
            else if (INSTR[5:0] === 6'h01) // sll
            begin
                CTRL = `CTRL_WIDTH'h00015400;
            end
            else if (INSTR[5:0] === 6'h02) // srl
            begin
                CTRL = `CTRL_WIDTH'h00011400;
            end
            else if (INSTR[5:0] === 6'h08) // jr
            begin
                CTRL = `CTRL_WIDTH'h00000000;
            end
        end
        
        else // I-Type and J-Type
        begin
            /* I-Type */
            if (INSTR[31:26] === 6'h08) // addi
            begin
                CTRL = `CTRL_WIDTH'h00004800;
            end
            else if (INSTR[31:26] === 6'h1d) // muli
            begin
                CTRL = `CTRL_WIDTH'h0000C800;
            end
            else if (INSTR[31:26] === 6'h0c) // andi
            begin
                CTRL = `CTRL_WIDTH'h00018000;
            end
            else if (INSTR[31:26] === 6'h0d) // ori
            begin
                CTRL = `CTRL_WIDTH'h0001C000;
            end
            else if (INSTR[31:26] === 6'h0f) // lui
            begin
                CTRL = `CTRL_WIDTH'h00000000;
            end
            else if (INSTR[31:26] === 6'h0a) // stli
            begin
                CTRL = `CTRL_WIDTH'h00024800;
            end
            else if (INSTR[31:26] === 6'h04) // beq
            begin
                CTRL = `CTRL_WIDTH'h0000A000;
            end
            else if (INSTR[31:26] === 6'h05) // bne
            begin
                CTRL = `CTRL_WIDTH'h0000A000;
            end
            else if (INSTR[31:26] === 6'h23) // lw
            begin
                READ = 1'b1;
                WRITE = 1'b0;
                CTRL = `CTRL_WIDTH'h00004800;
            end
            else if (INSTR[31:26] === 6'h2b) // sw
            begin
                READ = 1'b0;
                WRITE = 1'b1;
                CTRL = `CTRL_WIDTH'h00004800;
            end
            
            /* J-Type */
            else if (INSTR[31:26] === 6'h02) // jmp
            begin
                CTRL = `CTRL_WIDTH'h00000000;
            end
            else if (INSTR[31:26] === 6'h03) // jal
            begin
                CTRL = `CTRL_WIDTH'h00000000;
            end
            else if (INSTR[31:26] === 6'h1b) // push
            begin
                READ = 1'b0;
                WRITE = 1'b1;
                CTRL = `CTRL_WIDTH'h00509200;
            end
            else if (INSTR[31:26] === 6'h1c) // pop
            begin
                READ = 1'b1;
                WRITE = 1'b0;
                CTRL = `CTRL_WIDTH'h00100000;
            end
        end
    end
    
    else if (proc_state === `PROC_WB)
    begin
        /* R-Type */
        if (INSTR[31:26] === 6'h00)
        begin
            if (INSTR[5:0] === 6'h20) // add
            begin
                CTRL = `CTRL_WIDTH'h1200608B;
            end
            else if (INSTR[5:0] === 6'h22) // sub
            begin
                CTRL = `CTRL_WIDTH'h1200A08B;
            end
            else if (INSTR[5:0] === 6'h2c) // mul
            begin
                CTRL = `CTRL_WIDTH'h1200E08B;
            end
            else if (INSTR[5:0] === 6'h24) // and
            begin
                CTRL = `CTRL_WIDTH'h1201A08B;
            end
            else if (INSTR[5:0] === 6'h25) // or
            begin
                CTRL = `CTRL_WIDTH'h1201E08B;
            end
            else if (INSTR[5:0] === 6'h27) // nor
            begin
                CTRL = `CTRL_WIDTH'h1202208B;
            end
            else if (INSTR[5:0] === 6'h2a) // slt
            begin
                CTRL = `CTRL_WIDTH'h1202608B;
            end
            else if (INSTR[5:0] === 6'h01) // sll
            begin
                CTRL = `CTRL_WIDTH'h1201548B;
            end
            else if (INSTR[5:0] === 6'h02) // srl
            begin
                CTRL = `CTRL_WIDTH'h1201148B;
            end
            else if (INSTR[5:0] === 6'h08) // jr
            begin
                CTRL = `CTRL_WIDTH'h00000009;
            end
        end
        
        else // I-Type and J-Type
        begin
            /* I-Type */
            if (INSTR[31:26] === 6'h08) // addi
            begin
                CTRL = `CTRL_WIDTH'h1600488B;
            end
            else if (INSTR[31:26] === 6'h1d) // muli
            begin
                CTRL = `CTRL_WIDTH'h1600C88B;
            end
            else if (INSTR[31:26] === 6'h0c) // andi
            begin
                CTRL = `CTRL_WIDTH'h1601808B;
            end
            else if (INSTR[31:26] === 6'h0d) // ori
            begin
                CTRL = `CTRL_WIDTH'h1601C08B;
            end
            else if (INSTR[31:26] === 6'h0f) // lui
            begin
                CTRL = `CTRL_WIDTH'h1700008B;
            end
            else if (INSTR[31:26] === 6'h0a) // stli
            begin
                CTRL = `CTRL_WIDTH'h1602088B;
            end
            else if (INSTR[31:26] === 6'h04) // beq
            begin
                if (ZERO === 1'b0)
                begin
                    CTRL = `CTRL_WIDTH'h0000A00D;
                end
                else
                begin
                    CTRL = `CTRL_WIDTH'h0000A00B;
                end
            end
            else if (INSTR[31:26] === 6'h05) // bne
            begin
                if (ZERO !== 1'b0)
                begin
                    CTRL = `CTRL_WIDTH'h0000A00D;
                end
                else
                begin
                    CTRL = `CTRL_WIDTH'h0000A00B;
                end
            end
            else if (INSTR[31:26] === 6'h23) // lw
            begin
                CTRL = `CTRL_WIDTH'h1680008B;
            end
            else if (INSTR[31:26] === 6'h2b) // sw
            begin
                CTRL = `CTRL_WIDTH'h0000000B;
            end
            
            /* J-Type */
            else if (INSTR[31:26] === 6'h02) // jmp
            begin
                CTRL = `CTRL_WIDTH'h00000001;
            end
            else if (INSTR[31:26] === 6'h03) // jal
            begin
                CTRL = `CTRL_WIDTH'h08000081;
            end
            else if (INSTR[31:26] === 6'h1b) // push
            begin
                CTRL = `CTRL_WIDTH'h0000930B;
            end
            else if (INSTR[31:26] === 6'h1c) // pop
            begin
                CTRL = `CTRL_WIDTH'h0280008B;
            end
        end
    end
end

endmodule


//------------------------------------------------------------------------------------------
// Module: PROC_SM
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version  Date        Who     email           note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014    Kaushik Patra   kpatra@sjsu.edu     Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE, CLK, RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;

// Registers for current and next states
reg [2:0] STATE;
reg [2:0] next_state;

// Initial state is unknown and next state is fetch
initial
begin
    STATE = 3'bxxx;
    next_state = `PROC_FETCH;
end

// On negative edge of reset, state is unknown and next state is fetch
always @ (negedge RST)
begin
    STATE = 3'bxxx;
    next_state = `PROC_FETCH;
end

// On positive edge of clock, change states
always @ (posedge CLK)
begin
    STATE = next_state;

    case (STATE)
        `PROC_FETCH: next_state = `PROC_DECODE;
        `PROC_DECODE: next_state = `PROC_EXE;
	    `PROC_EXE: next_state = `PROC_MEM;
	    `PROC_MEM: next_state = `PROC_WB;
	    `PROC_WB: next_state = `PROC_FETCH;
    endcase
end

endmodule