`timescale 1ns / 1ps

module machine_d_tb;

    reg RESET, CLK, x; 
    wire [2:0] S;
    wire F;
    
    machine_d c1(.x(x), .CLK(CLK), .RESET(RESET), .S(S), .F(F));
    
    initial begin
        $dumpfile("machine_d_result.vcd");
        $dumpvars;
        RESET = 1;
        x = 0;
        #5;
        RESET = 0; 
        #5;
        x = 1;
        #40;
        x=0
        #20;
        x = 1;
        #40;
        x=0
        #20;
        x = 1;
        #40;
        x = 0;
        #40;
        x = 1;
        #20;
        x = 0;
        #20;
        x = 1;
        #20;
        RESET = 1;
        #5;
        RESET = 0;
        #25;
        x = 0;
        #80;
        x = 1;
        #20;
        $finish;
    end

    initial begin
        CLK = 0;
        forever begin
            #20;
            CLK = ~CLK;
        end
    end

endmodule