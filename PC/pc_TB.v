`timescale 1ns / 1ps // Unidade de tempo de 1ns, precisão de 1ps
module pc_TB;
    // Declaração de sinais para entradas e saídas
    reg Clk, Reset, zeroFlag, jmpFlag, branchFlag;
    reg [31:0] branchOffset, jmpAddress;
    wire [31:0] addr;
    wire resetControl;

    // Instanciação do módulo `pc`
    pc uut (
        .Clk(Clk),
        .Reset(Reset),
        .zeroFlag(zeroFlag),
        .jmpFlag(jmpFlag),
        .branchFlag(branchFlag),
        .branchOffset(branchOffset),
        .jmpAddress(jmpAddress),
        .addr(addr),
        .resetControl(resetControl)
    );

    // Geração de clock
    initial Clk = 0;
    always #5 Clk = ~Clk; // Clock com período de 10 unidades de tempo

    // Teste inicial
    initial begin
        // Monitoramento de sinais
        $monitor("Time: %0t | Reset: %b | Clk: %b | Addr: %h | ResetControl: %b | BranchOffset: %h | JmpAddress: %h | ZeroFlag: %b | JmpFlag: %b | BranchFlag: %b", 
                 $time, Reset, Clk, addr, resetControl, branchOffset, jmpAddress, zeroFlag, jmpFlag, branchFlag);

        // Inicializa entradas
        Reset = 0;
        zeroFlag = 0;
        jmpFlag = 0;
        branchFlag = 0;
        branchOffset = 32'h00000008;
        jmpAddress = 32'h00000ABC;

        // Teste de Reset
        Reset = 1; #10; // Reset ativo
        Reset = 0; #10; // Reset desativado

        // Teste de incremento normal
        #10;
        zeroFlag = 0;
        jmpFlag = 0;
        branchFlag = 0;

        // Teste de jump
        jmpFlag = 1;
        jmpAddress = 32'h00000FFF;
        #10;
        jmpFlag = 0;

        // Teste de branch (condição verdadeira)
        branchFlag = 1;
        zeroFlag = 1;
        branchOffset = 32'hFFFFFFF8; // Offset negativo
        #10;
        branchFlag = 0;
        zeroFlag = 0;

        // Teste de branch (condição falsa)
        branchFlag = 1;
        zeroFlag = 0;
        branchOffset = 32'h00000010; // Offset positivo
        #10;
        branchFlag = 0;

        // Finaliza simulação
        #50;
        $stop;
    end
endmodule
