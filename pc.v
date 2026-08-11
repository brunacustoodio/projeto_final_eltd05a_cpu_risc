module pc (
    input clk, rst,
    input Flag_Zero,
    input [31:0] BNE_Offset,
    input BNE_On,
    input [25:0] JUMP_Address,
    input JUMP_Flag,

    output reg [31:0] PC_Out
);

    reg initialized;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            PC_Out <= 32'h0260;
            initialized <= 0;
        end else if (!initialized) begin
            PC_Out <= 32'h0260;
            initialized <= 1;
        end else begin
            case (1'b1)
                JUMP_Flag: PC_Out <= {6'b0, JUMP_Address} + 32'h0260;
                ~BNE_On: PC_Out <= PC_Out + 4;
                ~Flag_Zero: PC_Out <= PC_Out + BNE_Offset - 4;
                default: PC_Out <= PC_Out + 4;
            endcase
        end
    end

endmodule
