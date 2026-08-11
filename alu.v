module alu (
    input wire [31:0] A_In,
    input wire [31:0] B_In,
    input wire [1:0] OP,
    
    output reg [31:0] ALU_Out,
    output reg ZERO_Flag
);

    // Processo sensível a qualquer mudança nas entradas
    always @* begin
        // Operação baseada no seletor
        case (OP)
            2'b00: begin
                ALU_Out = A_In + B_In;
            end
            2'b01: begin
                ALU_Out = A_In - B_In;
            end
            2'b10: begin
                ALU_Out = A_In & B_In;
            end
            2'b11: begin
                ALU_Out = A_In | B_In;
            end
            default: begin
                ALU_Out = 32'h00000000; // Caso improvável de falha
            end
        endcase

        // Ajusta a ZERO_Flag com base no ALU_Out
        ZERO_Flag = (ALU_Out == 0) ? 1'b1 : 1'b0;
    end

endmodule