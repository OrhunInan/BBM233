`timescale 1ns/10ps

module multiplier (
    input [2:0] A, B,
    output [5:0] P
);

wire ands[7:0];
wire couts[5:0];
wire misc[1:0];

and(P[0], A[0], B[0]);
and(ands[0], A[1], B[0]);
and(ands[1], A[0], B[1]);
and(ands[2], A[2], B[0]);
and(ands[3], A[1], B[1]);
and(ands[4], A[2], B[1]);
and(ands[5], A[0], B[2]);
and(ands[6], A[1], B[2]);
and(ands[7], A[2], B[2]);

half_adder H1(.A(ands[0]), .B(ands[1]), .S(P[1]), .C(couts[0]));
half_adder H2(.A(ands[2]), .B(ands[3]), .S(misc[0]), .C(couts[1]));
full_adder F1(.A(ands[5]), .B(misc[0]), .Cin(couts[0]), .S(P[2]), .Cout(couts[2]));
full_adder F2(.A(ands[6]), .B(ands[4]), .Cin(couts[1]), .S(misc[1]), .Cout(couts[3]));
half_adder H3(.A(misc[1]), .B(couts[2]), .S(P[3]), .C(couts[4]));
full_adder F3(.A(ands[7]), .B(couts[3]), .Cin(couts[4]), .S(P[4]), .Cout(P[5]));


endmodule
