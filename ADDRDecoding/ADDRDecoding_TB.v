`timescale 1ns/100ps
module ADDRDecoding_TB;
    reg [31:0] addr;
    reg WE;
    wire cs, iWE;
    wire [31:0] iAddress;

    // Instancia o módulo
    ADDRDecoding uut (
        .addr(addr),
        .WE(WE),
        .cs(cs),
        .iWE(iWE),
        .iAddress(iAddress)
    );

    initial begin
        // Inicializa sinais
        addr = 0;
        WE = 0;

        // Teste 1: Endereço dentro do intervalo
        #10 addr = 32'h000006f1; WE = 1; #10;
        $display("Addr: %h, cs: %b, iWE: %b, iAddress: %h", addr, cs, iWE, iAddress);
		  
		  // Teste 1.1: Endereço dentro do intervalo
        #10 addr = 32'h000006f2; WE = 1; #10;
        $display("Addr: %h, cs: %b, iWE: %b, iAddress: %h", addr, cs, iWE, iAddress);
		  
		  // Teste 1.2: Endereço dentro do intervalo
        #10 addr = 32'h000006f3; WE = 1; #10;
        $display("Addr: %h, cs: %b, iWE: %b, iAddress: %h", addr, cs, iWE, iAddress);
		  
		  

        // Teste 2: Endereço no limite superior
        #10 addr = 32'h00001713; WE = 1; #10;
        $display("Addr: %h, cs: %b, iWE: %b, iAddress: %h", addr, cs, iWE, iAddress);

        // Teste 3: Endereço fora do intervalo (abaixo)
        #10 addr = 32'h00000500; WE = 1; #10;
        $display("Addr: %h, cs: %b, iWE: %b, iAddress: %h", addr, cs, iWE, iAddress);

        // Teste 4: Endereço fora do intervalo (acima)
        #10 addr = 32'h00001800; WE = 1; #10;
        $display("Addr: %h, cs: %b, iWE: %b, iAddress: %h", addr, cs, iWE, iAddress);

        $finish;
    end
endmodule

