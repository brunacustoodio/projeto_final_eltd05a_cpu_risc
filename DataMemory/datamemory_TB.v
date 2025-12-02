`timescale 1ns / 1ps

module datamemory_TB;

    // Definindo os sinais de entrada e saída
    reg [9:0] address;   // Endereço de leitura (10 bits)
    reg clock;            // Clock do sistema
    reg [31:0] data;      // Dados de entrada (não usados para leitura)
    reg wren;             // Sinal de escrita (0 para leitura)
    wire [31:0] q;        // Dados lidos da memória

    // Instanciando o módulo de memória
    datamemory uut (
        .address(address),
        .clock(clock),
        .data(data),
        .wren(wren),
        .q(q)
    );

    // Gerador de clock
    always begin
        #5 clock = ~clock;  // Clock de 100 MHz (5ns de período)
    end

    // Processo de teste
     initial begin
        // Inicializando sinais
        clock = 0;
        address = 10'b0000000000;  // Endereço inicial para leitura
        data = 32'b0;              // Dados de entrada (não utilizados na leitura)
        wren = 0;                  // Desabilitar escrita, apenas leitura

        // Aguarde por alguns ciclos de clock
        #20;
        
        // Testar e imprimir os valores das 32 primeiras posições (endereços 0 a 31)
        for (address = 10'b0000000000; address <= 10'b0001111111; address = address + 1) begin
            #20;  // Espera dois ciclos para leitura (ajuste o tempo conforme necessário)
            // Imprimir os dados lidos
            $display("Data at address %b: %h", address, q);
        end
        
        // Finaliza o teste
        $finish;
    end
endmodule