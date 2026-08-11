module ADDRDecoding (
    input [31:0] ADDRESS_In,
    input WE,
    output wire [9:0] ADDRESS_Out,
    output reg iWE,
    output reg cs
);

    // Parâmetro para os limites de decodificação
    localparam BASE_ADDR = 32'h0480;
    localparam LIMIT_ADDR = 32'h087F;

    // Registro auxiliar para manipular a saída
    reg [31:0] aux;

    // Saída atribuída diretamente ao valor de 10 bits
    assign ADDRESS_Out = aux[9:0];

    // Função para verificar se o endereço está dentro do intervalo permitido
    function automatic is_within_range;
        input [31:0] addr;
        begin
            is_within_range = (addr >= BASE_ADDR) && (addr <= LIMIT_ADDR);
        end
    endfunction

    always @(*) begin
        // Reset padrão para todos os sinais
        aux = 0;
        cs = 0;
        iWE = 0;

        // Lógica de decodificação
        if (is_within_range(ADDRESS_In)) begin
            aux = ADDRESS_In - BASE_ADDR; // Ajusta o endereço base
            cs = 1; // Chip Select ativo

            // Controla o sinal de escrita
            iWE = WE ? 1 : 0;
        end
    end

endmodule
