`timescale 1ns/1ps

module D_FF_TB;
wire Q, Qbar;
reg D, C, nP, nR;

D_FF d_ff_inst(.Q(Q), .Qbar(Qbar), .D(D), .C(C), .nP(nP), .nR(nR));

initial
begin
// Negative edge to set D-Latch = 1
#5 D = 1'b1; C = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, nP, nR, Q, Qbar);

// Set
#5 D = 1'b1; C = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, nP, nR, Q, Qbar);

// Control off, retain values = 1
#5 D = 1'bx; C = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, nP, nR, Q, Qbar);

// Negative edge to set D-Latch = 0
#5 D = 1'b0; C = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, nP, nR, Q, Qbar);

// Reset
#5 D = 1'b0; C = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, nP, nR, Q, Qbar);

// Control off, retain values = 0
#5 D = 1'bx; C = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("D:%d C:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, nP, nR, Q, Qbar);

// Preset
#5 D = 1'bx; C = 1'b1; nP = 1'b0; nR = 1'b1;
#5 $write("D:%d C:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, nP, nR, Q, Qbar);

// Reset
#5 D = 1'bx; C = 1'b1; nP = 1'b1; nR = 1'b0;
#5 $write("D:%d C:%d nP:%d nR:%d Q:%d Qbar:%d\n", D, C, nP, nR, Q, Qbar);
end

endmodule