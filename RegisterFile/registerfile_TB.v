`timescale 1ns/1ps

module registerfile_TB;
  reg Clk;
  reg we;
  reg [4:0] rs, rt, rd;
  reg [31:0] in;
  wire [31:0] outA, outB;

  // Instancia o módulo registerfile
  registerfile uut (
    .Clk(Clk),
    .we(we),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .in(in),
    .outA(outA),
    .outB(outB)
  );

  // Gera um clock com período de 10 ns
  initial begin
    Clk = 0;
    forever #5 Clk = ~Clk;
  end

  initial begin
    // Inicialização dos sinais
    we = 0;
    rs = 0;
    rt = 0;
    rd = 0;
    in = 0;

    // Aguarda o reset inicial
    #10;

    // Tenta escrever no registrador 0 e verifica se continua 0
    we = 1;
    rd = 5'd0;       // Registrador 0
    in = 32'hFFFF_FFFF; // Tenta escrever valor não-zero
    #10;

    // Desabilita a escrita e verifica a leitura do registrador 0
    we = 0;
    rs = 5'd0; // Lê o registrador 0 em outA
    #10;

    // Verifica se o registrador 0 está realmente hardwired em 0
    $display("Testando se r0 é hardwired a 0...");
    if (outA == 32'h0)
      $display("PASS: Registrador 0 permanece em 0 como esperado.");
    else
      $display("FAIL: Registrador 0 não está em 0. outA = %h", outA);

    // Testes de leitura e escrita em outros registradores para confirmação do funcionamento

    // Escreve no registrador 1
    rd = 5'd1;
    in = 32'hAAAA_AAAA;
    #10;

    // Verifica a leitura de rs e rt
    rs = 5'd1;
    rt = 5'd2;
    we = 0;
    #10;

    $display("outA = %h, esperado = %h", outA, 32'hAAAA_AAAA);
    $display("outB = %h, esperado = %h", outB, 32'h0);

    // Escreve no registrador 2
    we = 1;
    rd = 5'd2;
    in = 32'h5555_5555;
    #10;

    // Verifica novamente a leitura
    we = 0;
    rs = 5'd1;
    rt = 5'd2;
    #10;

    $display("outA = %h, esperado = %h", outA, 32'hAAAA_AAAA);
    $display("outB = %h, esperado = %h", outB, 32'h5555_5555);

    // Finaliza a simulação
    $stop;
  end
endmodule
