`timescale 1ns/10ps
// Name: alu_tb.v
// Module: ALU_TB
// Input: 
// Output: 
//
// Notes: Testbench for testing ALU functionality
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_right (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - Set less than (0x9)
//
// Revision History:
//
// Version Date             Who               Email                    Note
//------------------------------------------------------------------------------------------
// 1.0     Sep 02, 2014	    Kaushik Patra     kpatra@sjsu.edu          Initial creation
// 1.1     Sep 04, 2014	    Kaushik Patra     kpatra@sjsu.edu          Fixed test_and_count task
//                                                                        to count number of test and
//                                                                        pass correctly.
// 1.2     Oct 02, 2019     Ryan Tran         ryan.l.tran@sjsu.edu     Implemented other functions.
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module ALU_TB;

integer total_test;
integer pass_test;

reg [`ALU_OPRN_INDEX_LIMIT:0] oprn_reg;
reg [`DATA_INDEX_LIMIT:0] op1_reg;
reg [`DATA_INDEX_LIMIT:0] op2_reg;

wire [`DATA_INDEX_LIMIT:0] r_net;
wire ZERO;

// Instantiation of ALU
ALU ALU_INST_01(.OUT(r_net), .ZERO(ZERO), .OP1(op1_reg), .OP2(op2_reg), .OPRN(oprn_reg));

// Drive the test patterns and test
initial
begin
op1_reg = 0;
op2_reg = 0;
oprn_reg = 0;

total_test = 0;
pass_test = 0;

// Test 3 + 4 = 7
#5  op1_reg = `DATA_WIDTH'd03;
    op2_reg = `DATA_WIDTH'd04;
    oprn_reg = `ALU_OPRN_WIDTH'h20;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));

// Test 20 - 15 = 5
#5  op1_reg = `DATA_WIDTH'd20;
    op2_reg = `DATA_WIDTH'd15;
    oprn_reg = `ALU_OPRN_WIDTH'h22;   
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));

// Test 8 * 4 = 32
#5  op1_reg = `DATA_WIDTH'd08;
    op2_reg = `DATA_WIDTH'd04;
    oprn_reg = `ALU_OPRN_WIDTH'h2c;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));

// Test 8 >> 2 = 2
#5  op1_reg = `DATA_WIDTH'd08;
    op2_reg = `DATA_WIDTH'd02;
    oprn_reg = `ALU_OPRN_WIDTH'h02;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));

// Test 4 << 4 = 64
#5  op1_reg = `DATA_WIDTH'd04;
    op2_reg = `DATA_WIDTH'd04;
    oprn_reg = `ALU_OPRN_WIDTH'h01;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));

// Test 5 & 10 = 0
#5  op1_reg = `DATA_WIDTH'd05;
    op2_reg = `DATA_WIDTH'd10;
    oprn_reg = `ALU_OPRN_WIDTH'h24;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));

// Test 10 | 20 = 30
#5  op1_reg = `DATA_WIDTH'd10;
    op2_reg = `DATA_WIDTH'd20;
    oprn_reg = `ALU_OPRN_WIDTH'h25;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));

// Test 3 ~| 6 = 4294967288
#5  op1_reg = `DATA_WIDTH'd03;
    op2_reg = `DATA_WIDTH'd06;
    oprn_reg = `ALU_OPRN_WIDTH'h27;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));

// Test 5 < 9 = 1
#5  op1_reg = `DATA_WIDTH'd05;
    op2_reg = `DATA_WIDTH'd09;
    oprn_reg = `ALU_OPRN_WIDTH'h2a;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net));

#5  $write("\n");
    $write("\tTotal number of tests %d\n", total_test);
    $write("\tTotal number of pass  %d\n", pass_test);
    $write("\n");
    $stop; // Stop simulation here
end

//-----------------------------------------------------------------------------
// TASK: test_and_count
// 
// PARAMETERS: 
//     INOUT: total_test ; total test counter
//     INOUT: pass_test ; pass test counter
//     INPUT: test_status ; status of the current test 1 or 0
//
// NOTES: Keeps track of number of test and pass cases.
//
//-----------------------------------------------------------------------------
task test_and_count;
inout total_test;
inout pass_test;
input test_status;

integer total_test;
integer pass_test;
begin
    total_test = total_test + 1;
    if (test_status)
    begin
        pass_test = pass_test + 1;
    end
end
endtask

//-----------------------------------------------------------------------------
// FUNCTION: test_golden
// 
// PARAMETERS: op1, op2, oprn and result
// RETURN: 1 or 0 if the result matches golden 
//
// NOTES: Tests the result against the golden. Golden is generated inside.
//
//-----------------------------------------------------------------------------
function test_golden;
input [`DATA_INDEX_LIMIT:0] op1;
input [`DATA_INDEX_LIMIT:0] op2;
input [`ALU_OPRN_INDEX_LIMIT:0] oprn;
input [`DATA_INDEX_LIMIT:0] res;

reg [`DATA_INDEX_LIMIT:0] golden; // Expected result
begin
    $write("[TEST] %0d ", op1);
    case(oprn)
        `ALU_OPRN_WIDTH'h20: begin $write("+ "); golden = op1 + op2; end // Addition
        `ALU_OPRN_WIDTH'h22: begin $write("- "); golden = op1 - op2; end // Subtraction
        `ALU_OPRN_WIDTH'h2c: begin $write("* "); golden = op1 * op2; end // Multiplication
        `ALU_OPRN_WIDTH'h02: begin $write(">> "); golden = op1 >> op2; end // Shift right logical
        `ALU_OPRN_WIDTH'h01: begin $write("<< "); golden = op1 << op2; end // Shift left logical
        `ALU_OPRN_WIDTH'h24: begin $write("& "); golden = op1 & op2; end // Bitwise AND
        `ALU_OPRN_WIDTH'h25: begin $write("| "); golden = op1 | op2; end // Bitwise OR
        `ALU_OPRN_WIDTH'h27: begin $write("~| "); golden = ~(op1 | op2); end // Bitwise NOR
        `ALU_OPRN_WIDTH'h2a: begin $write("< "); golden = (op1 < op2) ? `DATA_WIDTH'h01 : `DATA_WIDTH'h00; end // Set less than
        default: begin $write("? "); golden = `DATA_WIDTH'hx; end
    endcase
    $write("%0d = %0d , got %0d ... ", op2, golden, res);

    test_golden = (res === golden) ? 1'b1 : 1'b0; // Case equality
    if (test_golden)
	    $write("[PASSED]");
    else 
        $write("[FAILED]");
    $write("\n");
end
endfunction

endmodule
