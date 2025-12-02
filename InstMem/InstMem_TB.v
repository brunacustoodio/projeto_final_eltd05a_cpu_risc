`timescale 1ns / 1ps

module InstMem_TB;

  // Declaração dos sinais
  reg [9:0] address;  // Endereço de entrada
  reg clock;          // Clock de entrada
  wire [31:0] q;      // Saída da memória

  // Instância do módulo InstMem
  InstMem uut (
    .address(address),
    .clock(clock),
    .q(q)
  );

  // Geração do clock
  initial begin
    clock = 0;
    forever #10 clock = ~clock; // Período do clock = 20ns
  end

  // Estímulos para o módulo
  initial begin
    // Inicializa sinais
    address = 10'b0000000000; // Iniciar a leitura no endereço 4

    // Monitorar valores
    $monitor("Time: %0t | Address: %0d | Data: %h", $time, address, q);

    // Aguardar o início do clock
    #50;

    // Ler endereços válidos por mais tempo
    repeat (200) begin // Aumentado para 30 ciclos
      #100;
      address = address + 4; // Incrementar endereço em passos de 4
    end

    // Finalizar simulação após mais ciclos
    $finish;
  end

endmodule
