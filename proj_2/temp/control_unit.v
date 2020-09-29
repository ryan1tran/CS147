// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: RF_DATA_W  : Data to be written at register file address RF_ADDR_W
//         RF_ADDR_W  : Register file address of the memory location to be written
//         RF_ADDR_R1 : Register file address of the memory location to be read for RF_DATA_R1
//         RF_ADDR_R2 : Register file address of the memory location to be read for RF_DATA_R2
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
//         ALU_RESULT : ALU output data
//         ZERO       : Zero signal
//         CLK        : Clock signal
//         RST        : Reset signal
//
// InOut:  MEM_DATA   : Data to be read in from or write to the memory
//
// Notes: - Control unit synchronize operations of a processor
//
// Revision History:
//
// Version	Date             Who               Email                    Note
//------------------------------------------------------------------------------------------
// 1.0     Sep 10, 2014     Kaushik Patra     kpatra@sjsu.edu          Initial creation
// 1.1     Oct 19, 2014     Kaushik Patra     kpatra@sjsu.edu          Added ZERO status output
// 1.2     Oct 02, 2019     Ryan Tran         ryan.l.tran@sjsu.edu     Implemented control unit
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(MEM_DATA, RF_DATA_W, RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2, RF_READ, RF_WRITE,
                    ALU_OP1, ALU_OP2, ALU_OPRN, MEM_ADDR, MEM_READ, MEM_WRITE,
                    RF_DATA_R1, RF_DATA_R2, ALU_RESULT, ZERO, CLK, RST); 

// Outputs for register file 
output [`DATA_INDEX_LIMIT:0] RF_DATA_W;
output [`REG_ADDR_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
output RF_READ, RF_WRITE;

// Outputs for ALU
output [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
output [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;

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

// Registers for register file outputs
reg [`DATA_INDEX_LIMIT:0] RF_DATA_W;
reg [`REG_ADDR_INDEX_LIMIT:0] RF_ADDR_W, RF_ADDR_R1, RF_ADDR_R2;
reg RF_READ, RF_WRITE;

// Registers for ALU outputs
reg [`DATA_INDEX_LIMIT:0]  ALU_OP1, ALU_OP2;
reg [`ALU_OPRN_INDEX_LIMIT:0] ALU_OPRN;

// Registers for memory outputs
reg [`ADDRESS_INDEX_LIMIT:0]  MEM_ADDR;
reg MEM_READ, MEM_WRITE;

// Register for memory write data
reg [`DATA_INDEX_LIMIT:0] MEM_DATA_REG;
assign MEM_DATA = (MEM_READ === 1'b0 && MEM_WRITE === 1'b1) ? MEM_DATA_REG : {`DATA_WIDTH{1'bz}};

// Internal registers
reg [`ADDRESS_INDEX_LIMIT:0] PC_REG, SP_REG;
reg [`DATA_INDEX_LIMIT:0] INST_REG;
reg [5:0] opcode, funct;
reg [4:0] rs, rt, rd, shamt;
reg [15:0] immediate;
reg [25:0] address;
reg [`DATA_INDEX_LIMIT:0] SIGN_EXTENDED, ZERO_EXTENDED, LUI, JUMP_ADDR;

PROC_SM state_machine(.STATE(proc_state), .CLK(CLK), .RST(RST));

initial
begin
   PC_REG = `INST_START_ADDR;
   SP_REG = `INIT_STACK_POINTER;
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
   
   else if (proc_state === `PROC_DECODE)
   begin
      INST_REG = MEM_DATA;
	  
      // R-Type
      {opcode, rs, rt, rd, shamt, funct} = INST_REG;
	  
      // I-Type
      {opcode, rs, rt, immediate} = INST_REG;
	  
      // J-Type
      {opcode, address} = INST_REG;
	  
	  // Sign extended for immediate
      SIGN_EXTENDED = {{16{immediate[15]}}, immediate};
	  
      // Zero extended for immediate
      ZERO_EXTENDED = {16'b0, immediate};
	  
      // LUI value for I-Type
      LUI = {immediate, 16'b0};
	  
      // Jump address for J-Type
      JUMP_ADDR = {6'b0, address};

      // Register file to read operation
      RF_ADDR_R1 = rs;
      RF_ADDR_R2 = rt;
      RF_READ = 1'b1;
	  RF_WRITE = 1'b0;
   end
   
   else if (proc_state === `PROC_EXE)
   begin
   
      /* R-Type */
	  
      if (opcode === 6'h00)
	  begin
	     
		 // Shift left logical (sll) or shift right logical (srl)
	     if (funct === 6'h01 || funct === 6'h02)
		 begin
		    ALU_OPRN = funct;
			ALU_OP1 = RF_DATA_R1;
			ALU_OP2 = shamt;
		 end
		 
		 // Jump register (jr)
		 else if (funct === 6'h08)
	     begin
	        PC_REG = RF_DATA_R1;
	     end
		 
		 // Add, sub, mul, and, or, nor, slt, sll, srl
	     else
	     begin
	        ALU_OPRN = funct;
			ALU_OP1 = RF_DATA_R1;
			ALU_OP2 = RF_DATA_R2;
	     end
	  end
	  
	  /* I-Type */
	  
	  // Addition immediate (addi), load word (lw), or store word (sw)
	  else if (opcode === 6'h08 || opcode === 6'h23 || opcode === 6'h2b)
	  begin
	     ALU_OPRN = `ALU_OPRN_WIDTH'h20;
		 ALU_OP1 = RF_DATA_R1;
		 ALU_OP2 = SIGN_EXTENDED;
	  end
	  
	  // Multiplication immediate (muli)
	  else if (opcode === 6'h1d)
	  begin
	     ALU_OPRN = `ALU_OPRN_WIDTH'h2c;
		 ALU_OP1 = RF_DATA_R1;
		 ALU_OP2 = SIGN_EXTENDED;
	  end
	  
	  // Logical AND immediate (andi)
	  else if (opcode === 6'h0c)
	  begin
	     ALU_OPRN = `ALU_OPRN_WIDTH'h24;
		 ALU_OP1 = RF_DATA_R1;
		 ALU_OP2 = ZERO_EXTENDED;
	  end
	  
	  // Logical OR immediate (ori)
	  else if (opcode === 6'h0d)
	  begin
	     ALU_OPRN = `ALU_OPRN_WIDTH'h25;
		 ALU_OP1 = RF_DATA_R1;
		 ALU_OP2 = ZERO_EXTENDED;
	  end
	  
	  // Set less than immediate (slti)
	  else if (opcode === 6'h0a)
	  begin
	     ALU_OPRN = `ALU_OPRN_WIDTH'h2a;
		 ALU_OP1 = RF_DATA_R1;
		 ALU_OP2 = SIGN_EXTENDED;
	  end
	  
	  /* J-Type */
	  
	  // Push to stack (push)
	  else if (opcode === 6'h1b)
	  begin
	     RF_ADDR_R1 = 0;
	  end
	  
   end
   
   else if (proc_state === `PROC_MEM)
   begin
      
	  /* I-Type */
	  
	  // Load word (lw)
	  if (opcode === 6'h23)
	  begin
	     MEM_ADDR = ALU_RESULT;
		 MEM_READ = 1'b1;
		 MEM_WRITE = 1'b0;
	  end
	  
	  // Store word (sw)
	  else if (opcode === 6'h2b)
	  begin
	     MEM_ADDR = ALU_RESULT;
		 MEM_DATA_REG = RF_DATA_R2;
		 MEM_WRITE = 1'b1;
		 MEM_READ = 1'b0;
	  end
	  
	  /* J-Type */
	  
	  // Push to stack (push)
	  else if (opcode === 6'h1b)
	  begin
	     MEM_ADDR = SP_REG;
		 MEM_DATA_REG = RF_DATA_R1;
		 MEM_WRITE = 1'b1;
		 MEM_READ = 1'b0;
		 SP_REG = SP_REG - 1;
	  end
	  
	  // Pop from stack (pop)
	  else if (opcode === 6'h1c)
	  begin
	     SP_REG = SP_REG + 1;
	     MEM_ADDR = SP_REG;
		 MEM_READ = 1'b1;
		 MEM_WRITE = 1'b0;
	  end
   end
   
   else if (proc_state === `PROC_WB)
   begin
      PC_REG = PC_REG + 1;
	  MEM_READ = 1'b0;
	  MEM_WRITE = 1'b0;
	  
	  /* R-Type */
	  
      if (opcode === 6'h00)
	  begin
	  
	     // Jump register (jr)
	     if(funct === 6'h08)
		 begin
            PC_REG = RF_DATA_R1;
	     end
		 
		 // All other R-Type write back to register operations
         else
         begin
            RF_ADDR_W = rd;
            RF_DATA_W = ALU_RESULT;
            RF_WRITE = 1'b1;
			RF_READ = 1'b0;
         end
	  end
	  
	  /* I-Type */
	  
	  // Addi, muli, andi, ori, lui, slti
	  else if (opcode === 6'h08 || opcode === 6'h1d || opcode === 6'h0c || 
	           opcode === 6'h0d || opcode === 6'h0f || opcode === 6'h0a)
	  begin
	     RF_ADDR_W = rt;
		 RF_DATA_W = opcode === 6'h0f ? LUI : ALU_RESULT;
		 RF_WRITE = 1'b1;
		 RF_READ = 1'b0;
	  end
	  
	  // Branch on equal (beq) and branch on not equal (bne)
	  else if ((opcode === 6'h04 && RF_DATA_R1 === RF_DATA_R2) ||
	           (opcode === 6'h05 && RF_DATA_R1 !== RF_DATA_R2))
	  begin
	     PC_REG = PC_REG + SIGN_EXTENDED;
	  end
	  
	  /* J-Type */
	  
	  // Jump to address
	  else if (opcode === 6'h02)
	  begin
	     PC_REG = JUMP_ADDR;
	  end
	  
	  // Jump and link (jal)
	  else if (opcode === 6'h03)
	  begin
	     RF_ADDR_W = 31;
		 RF_DATA_W = PC_REG;
		 RF_WRITE = 1'b1;
		 RF_READ = 1'b0;
		 PC_REG = JUMP_ADDR;
	  end
	  
	  // Pop from stack (pop)
	  else if (opcode === 6'h1c)
	  begin
	     RF_ADDR_W = 0;
		 RF_DATA_W = MEM_DATA;
		 RF_WRITE = 1'b1;
		 RF_READ = 1'b0;
	  end
   end
end
endmodule

//------------------------------------------------------------------------------------------
// Module: PROC_SM
// Output: STATE : State of the processor
//         
// Input:  CLK   : Clock signal
//         RST   : Reset signal
//
// Notes: - Processor continuously cycle within fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version Date             Who               Email                    Note
//------------------------------------------------------------------------------------------
// 1.0     Sep 10, 2014	    Kaushik Patra     kpatra@sjsu.edu          Initial creation
// 1.1     Oct 02, 2019     Ryan Tran         ryan.l.tran@sjsu.edu     Implemented state machine
//------------------------------------------------------------------------------------------
module PROC_SM(STATE, CLK, RST);

// List of inputs
input CLK, RST;

// List of outputs
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