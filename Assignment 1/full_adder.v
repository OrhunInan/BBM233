`timescale 1ns/10ps

module full_adder(
    input A, B, Cin,
    output S, Cout
);
wire carry_one, sum_one, carry_two;
half_adder adder1(A,B,sum_one,carry_one);
half_adder adder2(sum_one, Cin, S, carry_two);
or (Cout, carry_one, carry_two);

endmodule