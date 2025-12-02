`timescale 1ns/1ps

module extend_TB;
  reg [15:0] in;
  wire [31:0] out;

  // Instancia o módulo extend
  extend uut (
    .in(in),
    .out(out)
  );

  initial begin
    // Testa um valor positivo (sem extensão de sinal)
    in = 16'h0001; // Número positivo
    #10;
    $display("Entrada: %h, Saída esperada: 0000_0001, Saída: %h", in, out);

    // Testa outro valor positivo (sem extensão de sinal)
    in = 16'h1234; // Outro número positivo
    #10;
    $display("Entrada: %h, Saída esperada: 0000_1234, Saída: %h", in, out);

    // Testa um valor negativo (extensão de sinal)
    in = 16'hFFFF; // Número negativo -1
    #10;
    $display("Entrada: %h, Saída esperada: FFFF_FFFF, Saída: %h", in, out);

    // Testa outro valor negativo (extensão de sinal)
    in = 16'h8000; // Número negativo com sinal (bit mais significativo 1)
    #10;
    $display("Entrada: %h, Saída esperada: FFFF_8000, Saída: %h", in, out);

    // Testa o valor zero
    in = 16'h0000; // Zero
    #10;
    $display("Entrada: %h, Saída esperada: 0000_0000, Saída: %h", in, out);

    // Finaliza a simulação
    $stop;
  end
endmodule
