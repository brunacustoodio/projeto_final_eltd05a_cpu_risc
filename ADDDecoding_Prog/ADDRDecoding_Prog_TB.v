`timescale 1ns/1ps

module ADDRDecoding_Prog_TB;

    // Inputs
    reg [31:0] addr;

    // Outputs
    wire CS_P;

    // Instantiate the Unit Under Test (UUT)
    ADDRDecoding_Prog uut (
        .addr(addr), 
        .CS_P(CS_P)
    );

    // Test Cases
    initial begin
        // Test case 1: Address below inf (expected CS_P = 0)
        addr = 32'h08F0;
        #10;
        $display("Address: %h, CS_P: %b (Expected: 0)", addr, CS_P);

        // Test case 2: Address equal to inf (expected CS_P = 1)
        addr = 32'h09F0;
        #10;
        $display("Address: %h, CS_P: %b (Expected: 1)", addr, CS_P);

        // Test case 3: Address between inf and sup (expected CS_P = 1)
        addr = 32'h1000;
        #10;
        $display("Address: %h, CS_P: %b (Expected: 1)", addr, CS_P);

        // Test case 4: Address equal to sup (expected CS_P = 1)
        addr = 32'h1A13;
        #10;
        $display("Address: %h, CS_P: %b (Expected: 1)", addr, CS_P);

        // Test case 5: Address above sup (expected CS_P = 0)
        addr = 32'h1A14;
        #10;
        $display("Address: %h, CS_P: %b (Expected: 0)", addr, CS_P);

        // Finaliza a simulação
        $finish;
    end
endmodule
