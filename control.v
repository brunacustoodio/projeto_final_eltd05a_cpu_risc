module control
(
    input [31:0] CONTROL_Entrace,
    input BRANCH_Flag_Input,
    input ZERO_Flag_Input,

    output reg [4:0] R0,
    output reg [4:0] R1,
    output reg [4:0] R2,
    output reg REGISTER_WE,

    output reg [1:0] ALU_Operation,

    output reg MUX_01,
    output reg MUX_02,
    output reg MUX_03,

    output reg WR,
    output reg MUL_Start,
    output reg BNE,

    output reg JUMP,
    output wire [25:0] JUMP_Address
);

    // Definições de sinais
    wire [5:0] OPCODE = CONTROL_Entrace[31:26];
    wire [5:0] FUNCT = CONTROL_Entrace[5:0];

    assign JUMP_Address = CONTROL_Entrace[25:0];

    always @(*) begin
        // Resetar sinais
        {R0, R1, R2} = 0;
        {REGISTER_WE, WR, MUL_Start, BNE, JUMP} = 0;
        {MUX_01, MUX_02, MUX_03} = 0;
        ALU_Operation = 0;

        // Lógica de controle
        if (BRANCH_Flag_Input && ~ZERO_Flag_Input) begin
            BNE = 1;
        end else begin
            case (OPCODE)
                34: begin 
                    R0 = CONTROL_Entrace[25:21];
                    R2 = CONTROL_Entrace[20:16];
                    REGISTER_WE = 1;
                    {MUX_01, MUX_02, MUX_03} = 3'b111;
                end

                35: begin 
                    R0 = CONTROL_Entrace[25:21];
                    R1 = CONTROL_Entrace[20:16];
                    WR = 1;
                    {MUX_01, MUX_02, MUX_03} = 3'b111;
                end

                36: begin 
                    R0 = CONTROL_Entrace[25:21];
                    R1 = CONTROL_Entrace[20:16];
                    ALU_Operation = 1;
                    BNE = 1;
                    MUX_02 = 1;
                end

                37: begin 
                    R0 = CONTROL_Entrace[25:21];
                    R2 = CONTROL_Entrace[20:16];
                    REGISTER_WE = 1;
                    {MUX_01, MUX_02} = 2'b11;
                end

                38: begin 
                    R0 = CONTROL_Entrace[25:21];
                    R2 = CONTROL_Entrace[20:16];
                    REGISTER_WE = 1;
                    ALU_Operation = 3;
                    {MUX_01, MUX_02} = 2'b11;
                end

                6'b000010: begin // JUMP
                    JUMP = 1;
                end

                6'b000000: begin // Default para MUX_02
                    MUX_02 = 1;
                end

                default: begin
                    if (OPCODE == 12) begin // Tipo R
                        case (FUNCT)
                            6'b100000: begin // ADD
                                R0 = CONTROL_Entrace[25:21];
                                R1 = CONTROL_Entrace[20:16];
                                R2 = CONTROL_Entrace[15:11];
                                REGISTER_WE = 1;
                                MUX_02 = 1;
                            end

                            6'b100010: begin // SUB
                                R0 = CONTROL_Entrace[25:21];
                                R1 = CONTROL_Entrace[20:16];
                                R2 = CONTROL_Entrace[15:11];
                                REGISTER_WE = 1;
                                ALU_Operation = 1;
                                MUX_02 = 1;
                            end

                            6'b100100: begin // AND
                                R0 = CONTROL_Entrace[25:21];
                                R1 = CONTROL_Entrace[20:16];
                                R2 = CONTROL_Entrace[15:11];
                                REGISTER_WE = 1;
                                ALU_Operation = 2;
                                MUX_02 = 1;
                            end

                            6'b100101: begin // OR
                                R0 = CONTROL_Entrace[25:21];
                                R1 = CONTROL_Entrace[20:16];
                                R2 = CONTROL_Entrace[15:11];
                                REGISTER_WE = 1;
                                ALU_Operation = 3;
                                MUX_02 = 1;
                            end

                            6'b110010: begin // MUL
                                R0 = CONTROL_Entrace[25:21];
                                R1 = CONTROL_Entrace[20:16];
                                R2 = CONTROL_Entrace[15:11];
                                REGISTER_WE = 1;
                                MUX_02 = 0;
                                MUL_Start = 1;
                            end

                            default: ; // NOP
                        endcase
                    end
                end
            endcase
        end
    end

endmodule
