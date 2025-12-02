module ADDRDecoding_Prog(
    input [31:0] addr,
    output reg CS_P
);

    reg [31:0] sup;
    reg [31:0] inf;

    initial begin
        CS_P = 0;  
    end

    always @(*) begin
        sup = 32'h065F;  // 0x260 + 0x3FF 
        inf = 32'h0260;  // 2 × 0x130 

        
        if (addr >= inf && addr <= sup) 
            CS_P = 1; 
        else
            CS_P = 0;  
    end

endmodule
