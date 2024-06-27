module machine_d(
    input wire x,
    input wire CLK,
    input wire RESET,
    output wire F,
    output wire [2:0] S
);

    wire resS2;
    wire resS1;
    wire resS0;

    assign resS2 =  S[2] | (S[1] & ~x);

    assign resS1 = (S[2] & ~x) | (~S[1] & ~x) | (S[1] & x); //or statement

    assign resS0 = (~S[0] & x)|(S[0] & ~x); //or statement

    dff d0(.D(resS2), .CLK(CLK), .RESET(RESET), .Q(S[2]));
    dff d1(.D(resS1), .CLK(CLK), .RESET(RESET), .Q(S[1]));
    dff d2(.D(resS0), .CLK(CLK), .RESET(RESET), .Q(S[0]));

    assign F = S[2] & S[1] & ~S[0]; //or statement


endmodule