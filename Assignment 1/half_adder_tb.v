`timescale 1ns/10ps

module half_adder_tb;

reg A, B;

wire S, Cout;

full_adder UUT(.A(A), .B(B), .S(S), .C(Cout));

initial begin
    
    $dumpfile("half_adder.vcd");
	$dumpvars;

    A = 0; B = 0;
    #10; A = 0; B = 1;
    #10; A = 1; B = 0;
    #10; A = 1; B = 1;
    #10; $finish;
end

endmodule
