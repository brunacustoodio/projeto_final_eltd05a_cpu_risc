`timescale 1ns / 1ps

module control_TB;   
   // Definir sinais de entrada e saída
   reg [31:0] in;
   wire [24:0] out;

   // Instancia o módulo de controle
   control uut (
     .in(in),
     .out(out)
   );

   // Inicialização do Testbench
   initial begin
     // Inicialização do sinal de entrada
     in = 32'b0;
     
     // Teste com os dados fornecidos no arquivo Intel HEX
     // Linha 1: :040000008FE106F195
     #10 in = 32'h8FE106F1; // Carregar dados em 'in'
     #10 $display("Entrada: in = %h", in); // Exibir entrada
     #10 $display("Esperado: out = 1111100001000011100010100"); // Saída esperada
     #10 $display("Gerado: out = %b", out); // Saída gerada
     
     #10 in = 32'h344352A0; // Instrução de ADD
     #10 $display("Entrada: in = %h", in); // Exibir entrada
     #10 $display("Esperado: out = 0001000011010101000010000"); // Saída esperada
     #10 $display("Gerado: out = %b", out); // Saída gerada

     // Finalizar simulação
     #10 $finish;
   end

   // Monitorar os sinais
   initial begin
     $monitor("in = %h, out = %b", in, out);
   end
endmodule
