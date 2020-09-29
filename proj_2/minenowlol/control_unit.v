// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: RF_DATA_W  : Data to be written at register file address RF_ADDR_W
//         RF_ADDR_W  : Register file address of the memory location to be written
//         RF_ADDR_R1 : Register file address of the memory location to be read for RF_DATA_R1
//         RF_ADDR_R2 : Registere file address of the memory location to be read for RF_DATA_R2
//         RF_READ    : Register file Read signal
//         RF_WRITE   : Register file Write signal
//         ALU_OP1    : ALU operand 1
//         ALU_OP2    : ALU operand 2
//         ALU_OPRN   : ALU operation code
//         MEM_ADDR   : Memory address to be read in
//         MEM_READ   : Memory read signal
//         MEM_WRITE  : Memory write signal
//         
// Input:  RF_DATA_R1 : Data at ADDR_R1 address
//         RF_DATA_R2 : Data at ADDR_R1 address
//         ALU_RESULT    : ALU output data
//         CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Control unit synchronize operations of a processor
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//  1.2	    Mar  1, 2020	Ryan Tran	tranryanp@gmail.com	Implemented R-type
//  1.3	    Mar  5, 2020	Ryan Tran	tranryanp@gmail.com	Implemented I-type
//  1.4	    Mar 10, 2020	Ryan Tran	tranryanp@gmail.com	Implemented J-type/Control unit implemented
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(MEM_DATA, RF_DATA_W, RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2, RF_READ, RF_WRITE,
                    ALU_OP1, ALU_OP2, ALU_OPRN, MEM_ADDR, MEM_READ, MEM_WRITE,
                    RF_DATA_R1, RF_DATA_R2, ALU_RESULT, ZERO, CLK, RST); 

// Output signals
// Outputs for register file 
output [`DATA_INDEX_LIMIT:0] RF_DATA_W;
output [`REG_ADDR_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
output RF_READ, RF_WRITE;
// Outputs for ALU
output [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
output  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
// Outputs for memory
output [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR;
output MEM_READ, MEM_WRITE;

// Input signals
input [`DATA_INDEX_LIMIT:0] RF_DATA_R1, RF_DATA_R2, ALU_RESULT;
input ZERO, CLK, RST;

// Inout signal
inout [`DATA_INDEX_LIMIT:0] MEM_DATA;

// State nets
wire [2:0] proc_state;

// simulator internal storage for outputs
reg [`DATA_INDEX_LIMIT:0] RF_DATA_W, ALU_OP1, ALU_OP2;
reg [`REG_ADDR_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
reg RF_READ, RF_WRITE, MEM_READ, MEM_WRITE;
reg  [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;
reg [`ADDRESS_INDEX_LIMIT:0] MEM_ADDR;

// register for writing data
reg [`DATA_INDEX_LIMIT:0] REG_MEM_DATA;
assign MEM_DATA = (MEM_READ === 1'b0 && MEM_WRITE === 1'b1) ? REG_MEM_DATA : {`DATA_WIDTH{1'bz}};

// simulator internal storage for registers
reg [`ADDRESS_INDEX_LIMIT:0] PC_REG, SP_REF;
reg [`DATA_INDEX_LIMIT:0] INST_REG;
reg [5:0] opcode, funct;
reg [4:0] rs, rt, rd, shamt;
reg [15:0] immediate;
reg [25:0] address;
reg [`DATA_INDEX_LIMIT:0] sign_extend, zero_extend, lui, jump_address;

PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));

initial
begin
	PC_REG = `INST_START_ADDR;
	SP_REF = `INIT_STACK_POINTER;
end

always @ (proc_state)
begin
	if (proc_state === `PROC_FETCH)
	begin
		MEM_ADDR = PC_REG;
		MEM_READ = 1'b1;
		MEM_WRITE = 1'b0;
		RF_READ = 1'b0;
		RF_WRITE = 1'b0;
	end

	if (proc_state === `PROC_DECODE)
	begin
		INST_REG = MEM_DATA;
		
		// R-type
		{opcode, rs, rt, rd, shamt, funct} = INST_REG;
		
		// I-type
		{opcode, rs, rt, immediate } = INST_REG;
		
		// J-type
		{opcode, address} = INST_REG;
		
		// sign-extended immediate
		sign_extend = {{16{immediate[15]}}, immediate};
		
		// zero-extended immediate
		zero_extend = {16'b0, immediate};
		
		// I-type LUI value
		lui = {immediate, 16'b0};
		
		// J-type jump address
		jump_address = {6'b0, address};
		
		// registers for operations
		RF_ADDR_R1 = rs;
		RF_ADDR_R2 = rt;
		RF_READ = 1'b1;
		RF_WRITE = 1'b0;
	end

	// any instructions with similar structures are grouped together for efficiency and code conciseness
	if (proc_state === `PROC_EXE)
	begin
		// R-types for execution state
		if (opcode === 6'h00) // R-Type opcode
		begin
			// funct code for shift left logical (sll) or shift right logical (srl)
			if (funct === 6'h01 || funct === 6'h02)
			begin
				ALU_OP1 = RF_DATA_R1;
				ALU_OP2 = shamt;
				ALU_OPRN = funct;
			end
			
			else if (funct === 6'h08) // funct code for jump register (jr)
			begin
				PC_REG = RF_DATA_R1;
			end
			
			else // the rest of the R-Types: add, sub, mul, and, or, nor, slt
			begin
				ALU_OP1 = RF_DATA_R1;
				ALU_OP2 = RF_DATA_R2;
				ALU_OPRN = funct;
			end
		end
		
		// I-types for execution state
		// add immediate (addi), load word (lw), or store word (sw)
		else if (opcode === 6'h08 || opcode === 6'h23 || opcode === 6'h2b)
		begin
			ALU_OP1 = RF_DATA_R1;
			ALU_OP2 = sign_extend;
			ALU_OPRN = `ALU_OPRN_WIDTH'h20; // alu operation code for addition
		end
		
		else if (opcode === 6'h1d) // multiply immediate (muli)
		begin
			ALU_OP1 = RF_DATA_R1;
			ALU_OP2 = sign_extend;
			ALU_OPRN = `ALU_OPRN_WIDTH'h2c; // alu operation code for multiplication
		end
		
		else if (opcode === 6'h0c) // and immediate (andi)
		begin
			ALU_OP1 = RF_DATA_R1;
			ALU_OP2 = zero_extend;
			ALU_OPRN = `ALU_OPRN_WIDTH'h24; // alu operation code for bitwise AND
		end
		
		else if (opcode === 6'h0d) // or immediate (ori)
		begin
			ALU_OP1 = RF_DATA_R1;
			ALU_OP2 = zero_extend;
			ALU_OPRN = `ALU_OPRN_WIDTH'h25; // alu operation code for bitwise OR
		end
		
		else if (opcode === 6'h0a) // set less than immediate (slti)
		begin
			ALU_OP1 = RF_DATA_R1;
			ALU_OP2 = sign_extend;
			ALU_OPRN = `ALU_OPRN_WIDTH'h2a; // alu operation code for set less than
		end
		
		// J-Types for execution state
		else if (opcode === 6'h1b) // push (push)
			RF_ADDR_R1 = 1'b0;
	end

	if (proc_state === `PROC_MEM)
	begin
		// I-types for memory access state
		if (opcode === 6'h23) // load word (lw)
		begin
			MEM_ADDR = ALU_RESULT;
			MEM_READ = 1'b1;
			MEM_WRITE = 1'b0;
		end
		
		else if (opcode === 6'h2b) // store word (sw)
		begin
			MEM_ADDR = ALU_RESULT;
			REG_MEM_DATA = RF_DATA_R2;
			MEM_READ = 1'b0;
			MEM_WRITE = 1'b1;
		end
		
		// J-types for memory access state
		else if (opcode === 6'h1b) // push (push)
		begin
			MEM_ADDR = SP_REF;
			SP_REF = SP_REF - 1;
			REG_MEM_DATA = RF_DATA_R1;
			MEM_READ = 1'b0;
			MEM_WRITE = 1'b1;
		end
		
		else if (opcode === 6'h1c) // pop (pop)
		begin
			SP_REF = SP_REF + 1;
			MEM_ADDR = SP_REF;
			MEM_READ = 1'b1;
			MEM_WRITE = 1'b0;
		end
	end

	if (proc_state === `PROC_WB)
	begin
		PC_REG = PC_REG + 1;
		MEM_READ = 1'b0;
		MEM_WRITE = 1'b0;
		
		// R-types for write-back state
		if (opcode === 6'h00) // R-type opcode
		begin
			if (funct === 6'h08) // jump register (jr)
				PC_REG = RF_DATA_R1;
			else // rest of R-types are the same: add, sub, mul, and, or, nor, slt, sll, srl
			begin
				RF_ADDR_W = rd;
				RF_DATA_W = ALU_RESULT;
				RF_READ = 1'b0;
				RF_WRITE = 1'b1;
			end
		end
		
		// I-types
		// add immediate (addi), multiply immediate (muli), and immediate (andi),
		// or immediate (ori), load upper immediate (lui), or set less than immediate (slti)
		else if (opcode === 6'h08 || opcode === 6'h1d || opcode === 6'h0c ||
			 opcode === 6'h0d || opcode === 6'h0f || opcode === 6'h0a)
		begin
			RF_ADDR_W = rt;
			
			if (opcode === 6'h0f)
				RF_DATA_W = lui;
			else
				RF_DATA_W = ALU_RESULT;
			
			RF_READ = 1'b0;
			RF_WRITE = 1'b1;
		end
		
		// branch on equal (beq) or branch on not equal (bne)
		else if ((opcode === 6'h04 && RF_DATA_R1 === RF_DATA_R2) ||
			 (opcode === 6'h05 && RF_DATA_R1 !== RF_DATA_R2))
			PC_REG = PC_REG + sign_extend;
		
		// J-types
		else if (opcode === 6'h02) // jump (jmp)
			PC_REG = jump_address;
		
		else if (opcode === 6'h03) // jump and link (jal)
		begin
			RF_DATA_W = PC_REG;
			PC_REG = jump_address;
			RF_ADDR_W = `REG_INDEX_LIMIT;
			RF_READ = 1'b0;
			RF_WRITE = 1'b1;
		end
		
		else if (opcode === 6'h1c) // pop (pop)
		begin
			RF_DATA_W = MEM_DATA;
			RF_ADDR_W = 1'b0;
			RF_READ = 1'b0;
			RF_WRITE = 1'b1;
		end
	end
end
endmodule;

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
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Feb 28, 2020	Ryan Tran	tranryanp@gmail.com	State machine implemented
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;

// list of registers
reg [2:0] STATE;
reg [2:0] next_state;

// initialization
initial
begin
	STATE = 3'bxx;
	next_state = `PROC_FETCH;
end

// reset
always @ (negedge RST)
begin
	STATE = 3'bxx;
	next_state = `PROC_FETCH;
end

// state switch on clock cycle
always @ (posedge CLK)
begin
	STATE = next_state; // set current_state to next_state
	case (STATE) // next_state is moved one forward in the cycle
		`PROC_FETCH: next_state = `PROC_DECODE;
		`PROC_DECODE: next_state = `PROC_EXE;
		`PROC_EXE: next_state = `PROC_MEM;
		`PROC_MEM: next_state = `PROC_WB;
		`PROC_WB: next_state = `PROC_FETCH;
	endcase
end

endmodule;