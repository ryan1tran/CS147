// Name: register_file_tb.v
// Module: REGISTER_FILE_32x32_TB
// 
// Monitors: DATA_W  : Data to be written at address ADDR
//           ADDR_W  : Address of the register location to be accessed for writing
//           ADDR_R1 : First address of the register location to be accessed for reading
//           ADDR_R2 : Second address of the register location to be accessed for reading
//           READ    : Read signal
//           WRITE   : Write signal
//
// Input:    DATA    : Data read out in the read operation
//           CLK     : Clock signal
//           RST     : Reset signal
//
// Notes: - Testbench for REGISTER_FILE_32x32 memory system
//
// Revision History:
//
// Version Date		        Who               Email                    Note
//------------------------------------------------------------------------------------------
// 1.0     Sep 10, 2014     Kaushik Patra     kpatra@sjsu.edu          Initial creation
// 1.1     Oct 02, 2019     Ryan Tran         ryan.l.tran@sjsu.edu     Implemented register test bench
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module REGISTER_FILE_32x32_TB;

// Address registers
reg [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1;
reg [`REG_ADDR_INDEX_LIMIT:0] ADDR_R2;
reg [`REG_ADDR_INDEX_LIMIT:0] ADDR_W;

// Control registers
reg READ, WRITE, RST;

// Register for writing
reg [`DATA_INDEX_LIMIT:0] DATA_W;

// For testing
integer i;
integer no_of_test, no_of_pass;

// Wires for outputs
wire  CLK;
wire [`DATA_INDEX_LIMIT:0] DATA_R1;
wire [`DATA_INDEX_LIMIT:0] DATA_R2;

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));

// 32x32 register file instance
REGISTER_FILE_32x32 reg_inst(.DATA_R1(DATA_R1), .DATA_R2(DATA_R2), .ADDR_R1(ADDR_R1), .ADDR_R2(ADDR_R2), .DATA_W(DATA_W), .ADDR_W(ADDR_W), .READ(READ), .WRITE(WRITE), .CLK(CLK), .RST(RST));

initial
begin
RST = 1'b1;
READ = 1'b0;
WRITE = 1'b0;
DATA_W = {`DATA_WIDTH{1'b0}};
no_of_test = 0;
no_of_pass = 0;

// Start the operation
#10    RST = 1'b0;
#10    RST = 1'b1;

// Write data to all register locations
for(i = 0; i <= `REG_INDEX_LIMIT; i = i + 1)
begin
#10   DATA_W = i; ADDR_W = i; READ = 1'b0; WRITE = 1'b1;
end

// Test 00 case
#10   READ = 1'b0; WRITE = 1'b0;
#5    no_of_test = no_of_test + 1;
      if (DATA_R1 !== {`DATA_WIDTH{1'bz}} || DATA_R2 != {`DATA_WIDTH{1'bz}})
        $write("[TEST] Read %1b, Write %1b, expecting 32'hzzzzzzzz, got %8h and %8h [FAILED]\n", READ, WRITE, DATA_R1, DATA_R2);
      else 
	no_of_pass = no_of_pass + 1;

// Read data from all register locations
for(i = 0; i <= `REG_INDEX_LIMIT; i = i + 1)
begin
#5    READ = 1'b1; WRITE = 1'b0; ADDR_R1 = i; ADDR_R2 = i;
#5    no_of_test = no_of_test + 1;
      if (DATA_R1 !== i || DATA_R2 !== i)
         $write("[TEST] Read %1b, Write %1b, expecting %8h, got %8h and %8h [FAILED]\n", READ, WRITE, i, DATA_R1, DATA_R2);
      else 
         no_of_pass = no_of_pass + 1;
end

#10   READ = 1'b0; WRITE = 1'b0; // No op

#10   $write("\n");
      $write("\tTotal number of tests %d\n", no_of_test);
      $write("\tTotal number of pass  %d\n", no_of_pass);
      $write("\n");
      $stop;
end
endmodule;

