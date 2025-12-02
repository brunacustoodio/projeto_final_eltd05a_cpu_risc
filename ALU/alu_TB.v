module alu_TB;
    reg [31:0] a, b;
    reg [1:0] sel;
    wire [31:0] out;
    wire zeroFlag;

    // Instanciação da ALU
    alu DUT (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out),
        .zeroFlag(zeroFlag)
    );

    initial begin
        // Teste de soma: a + b = 10 + 15
        a = 32'd10;
        b = 32'd15;
        sel = 2'b00;
        #10;
        $display("Soma: a = %d, b = %d, out = %d, zeroFlag = %b", a, b, out, zeroFlag);

        // Teste de subtração com zeroFlag = 0: a - b = 15 - 10
        a = 32'd15;
        b = 32'd10;
        sel = 2'b01;
        #10;
        $display("Subtracao (não zero): a = %d, b = %d, out = %d, zeroFlag = %b", a, b, out, zeroFlag);

        // Teste de subtração com zeroFlag = 1: a - b = 20 - 20
        a = 32'd20;
        b = 32'd20;
        sel = 2'b01;
        #10;
        $display("Subtracao (zero): a = %d, b = %d, out = %d, zeroFlag = %b", a, b, out, zeroFlag);

        // Teste de AND: a & b = 15 & 7
        a = 32'hF;    // 15 em hexadecimal
        b = 32'h7;    // 7 em hexadecimal
        sel = 2'b10;
        #10;
        $display("AND: a = %h, b = %h, out = %h, zeroFlag = %b", a, b, out, zeroFlag);

        // Teste de OR com zeroFlag = 0: a | b = 8 | 4
        a = 32'd8;
        b = 32'd4;
        sel = 2'b11;
        #10;
        $display("OR (não zero): a = %d, b = %d, out = %d, zeroFlag = %b", a, b, out, zeroFlag);

        // Teste de OR com zeroFlag = 1: a | b = 0 | 0
        a = 32'd0;
        b = 32'd0;
        sel = 2'b11;
        #10;
        $display("OR (zero): a = %d, b = %d, out = %d, zeroFlag = %b", a, b, out, zeroFlag);

        $finish; // Termina a simulação
    end

endmodule