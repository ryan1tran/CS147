`timescale 1ns/1ps

module REG32_TB;
wire [31:0] Q;
reg [31:0] D;
reg LOAD, CLK, RESET;

REG32 reg32_inst(.Q(Q), .D(D), .LOAD(LOAD), .CLK(CLK), .RESET(RESET));

initial
begin
/* LOAD = 1 */

// Negative edge to set D-Latch = 1
#5 D = 32'hffffffff; LOAD = 1'b1; CLK = 1'b0; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Set
#5 D = 32'hffffffff; LOAD = 1'b1; CLK = 1'b1; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Control off, retain values = 1
#5 D = 32'bx; LOAD = 1'b1; CLK = 1'b0; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Reset
#5 D = 32'bx; LOAD = 1'b1; CLK = 1'b1; RESET = 1'b0;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Negative edge to set D-Latch = 1
#5 D = 32'hffffffff; LOAD = 1'b1; CLK = 1'b0; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Set
#5 D = 32'hffffffff; LOAD = 1'b1; CLK = 1'b1; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Negative edge to set D-Latch = 0
#5 D = 32'b0; LOAD = 1'b1; CLK = 1'b0; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Reset
#5 D = 32'b0; LOAD = 1'b1; CLK = 1'b1; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Control off, retain values = 0
#5 D = 32'bx; LOAD = 1'b1; CLK = 1'b0; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

/* L = 0 */

// Negative edge to set D-Latch = 1
#5 D = 32'hffffffff; LOAD = 1'b0; CLK = 1'b0; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Set
#5 D = 32'hffffffff; LOAD = 1'b0; CLK = 1'b1; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Control off, retain values = 1
#5 D = 32'bx; LOAD = 1'b0; CLK = 1'b0; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Reset
#5 D = 32'bx; LOAD = 1'b0; CLK = 1'b1; RESET = 1'b0;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Negative edge to set D-Latch = 1
#5 D = 32'hffffffff; LOAD = 1'b0; CLK = 1'b0; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Set
#5 D = 32'hffffffff; LOAD = 1'b0; CLK = 1'b1; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Negative edge to set D-Latch = 0
#5 D = 32'b0; LOAD = 1'b0; CLK = 1'b0; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Reset
#5 D = 32'b0; LOAD = 1'b0; CLK = 1'b1; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);

// Control off, retain values = 0
#5 D = 32'bx; LOAD = 1'b0; CLK = 1'b0; RESET = 1'b1;
#5 $write("D:%d LOAD:%d CLK:%d RESET:%d Q:%d\n", D, LOAD, CLK, RESET, Q);
end

endmodule