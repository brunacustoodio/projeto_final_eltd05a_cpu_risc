`timescale 1ns/1ps

module mux_TB;

    // Declaração de sinais para o testbench
    reg a;         // Entrada 0
    reg b;         // Entrada 1
    reg sel;       // Sinal de seleção
    wire out;      // Saída

    // Instanciação do módulo mux2to1
    mux DUT (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );

    // Procedimento de teste
    initial begin
        // Monitorar os sinais
        $monitor("Time = %0dns | a = %b, b = %b, sel = %b | out = %b", $time, a, b, sel, out);

        // Teste 1: sel = 0, deve passar o valor de 'a' para a saída
        a = 0; b = 0; sel = 0;
        #10; // Espera 10ns

        a = 1; b = 0; sel = 0;
        #10;

        // Teste 2: sel = 1, deve passar o valor de 'b' para a saída
        a = 0; b = 1; sel = 1;
        #10;

        a = 1; b = 1; sel = 1;
        #10;

        // Teste 3: sel alternando entre 0 e 1 para verificar se o mux funciona corretamente
        a = 1; b = 0; sel = 0;
        #10;

        sel = 1;
        #10;

        // Encerrar a simulação
        $finish;
    end

endmodule
