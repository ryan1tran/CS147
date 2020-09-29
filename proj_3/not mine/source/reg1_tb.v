`timescale 1ns/1ps

module REG1_TB;
wire Q, Qbar;
reg D, C, L, nP, nR;

REG1 reg1_inst(.Q(Q), .Qbar(Qbar), .D(D), .C(C), .L(L), .nP(nP), .nR(nR));

initial
begin
/* L = 1 */

// Negative edge to set D-Latch = 1
#5 D = 1'b1; C = 1'b0; L = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Set
#5 D = 1'b1; C = 1'b1; L = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Control off, retain values = 1
#5 D = 1'bx; C = 1'b0; L = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Negative edge to set D-Latch = 0
#5 D = 1'b0; C = 1'b0; L = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Reset
#5 D = 1'b0; C = 1'b1; L = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Control off, retain values = 0
#5 D = 1'bx; C = 1'b0; L = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Preset
#5 D = 1'bx; C = 1'b1; L = 1'b1; nP = 1'b0; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Reset
#5 D = 1'bx; C = 1'b1; L = 1'b1; nP = 1'b1; nR = 1'b0;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

/* L = 0 */

// Negative edge to set D-Latch = 1
#5 D = 1'b1; C = 1'b0; L = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Set
#5 D = 1'b1; C = 1'b1; L = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Control off, retain values = 1
#5 D = 1'bx; C = 1'b0; L = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Negative edge to set D-Latch = 0
#5 D = 1'b0; C = 1'b0; L = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Reset
#5 D = 1'b0; C = 1'b1; L = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Control off, retain values = 0
#5 D = 1'bx; C = 1'b0; L = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Preset
#5 D = 1'bx; C = 1'b1; L = 1'b0; nP = 1'b0; nR = 1'b1;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);

// Reset
#5 D = 1'bx; C = 1'b1; L = 1'b0; nP = 1'b1; nR = 1'b0;
#5 $write("D:%d C:%d L:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, L, nP, nR, Q, Qbar);
end

endmodule