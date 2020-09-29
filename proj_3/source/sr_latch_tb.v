`timescale 1ns/1ps

module SR_LATCH_TB;
wire Q, Qbar;
reg S, R, C, nP, nR;

SR_LATCH sr_latch_inst1(.Q(Q), .Qbar(Qbar), .S(S), .R(R), .C(C), .nP(nP), .nR(nR));

initial
begin
// Set
#5 S = 1'b1; R = 1'b0; C = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("S:%d, R:%d, C:%d, nP:%d, nR:%d, Q:%d, Qbar:%d\n", S, R, C, nP, nR, Q, Qbar);

// Control off, retain values = 1
#5 S = 1'bx; R = 1'bx; C = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("S:%d, R:%d, C:%d, nP:%d, nR:%d, Q:%d, Qbar:%d\n", S, R, C, nP, nR, Q, Qbar);

// S = R = 0, retain values = 1
#5 S = 1'b0; R = 1'b0; C = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("S:%d, R:%d, C:%d, nP:%d, nR:%d, Q:%d, Qbar:%d\n", S, R, C, nP, nR, Q, Qbar);

// Reset
#5 S = 1'b0; R = 1'b1; C = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("S:%d, R:%d, C:%d, nP:%d, nR:%d, Q:%d, Qbar:%d\n", S, R, C, nP, nR, Q, Qbar);

// Control off, retain values = 0
#5 S = 1'bx; R = 1'bx; C = 1'b0; nP = 1'b1; nR = 1'b1;
#5 $write("S:%d, R:%d, C:%d, nP:%d, nR:%d, Q:%d, Qbar:%d\n", S, R, C, nP, nR, Q, Qbar);

// S = R = 0, retain values = 0
#5 S = 1'b0; R = 1'b0; C = 1'b1; nP = 1'b1; nR = 1'b1;
#5 $write("S:%d, R:%d, C:%d, nP:%d, nR:%d, Q:%d, Qbar:%d\n", S, R, C, nP, nR, Q, Qbar);

// Preset
#5 S = 1'bx; R = 1'bx; C = 1'bx; nP = 1'b0; nR = 1'b1;
#5 $write("S:%d, R:%d, C:%d, nP:%d, nR:%d, Q:%d, Qbar:%d\n", S, R, C, nP, nR, Q, Qbar);

// Reset
#5 S = 1'bx; R = 1'bx; C = 1'bx; nP = 1'b1; nR = 1'b0;
#5 $write("S:%d, R:%d, C:%d, nP:%d, nR:%d, Q:%d, Qbar:%d\n", S, R, C, nP, nR, Q, Qbar);
end

endmodule
