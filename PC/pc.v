module pc(
    input Clk, Reset, zeroFlag, jmpFlag, branchFlag,
    input [31:0] branchOffset, jmpAddress,
    output reg [31:0] addr,
    output reg resetControl
);
    always @(posedge Clk or posedge Reset) begin
        if (Reset) begin
            addr <= 32'h0260;
            resetControl <= 0; 
        end
        else if (jmpFlag) begin
            addr <= jmpAddress + 32'h0260; 
            resetControl <= 0; 
        end
        else if (branchFlag && !zeroFlag) begin  
            addr <= addr + $signed(branchOffset) - 4; 
            resetControl <= 1; 
        end
        else begin
            addr <= addr + 4; 
            resetControl <= 0; 
        end
    end
endmodule
