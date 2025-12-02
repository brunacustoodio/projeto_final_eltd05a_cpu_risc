module registerfile (
    input Clk, we, resetControl,
    input [4:0] rs, rt, rd,
    input [31:0] in,
    output reg [31:0] outA, outB
);    
    reg [31:0] register [31:0]; 
    integer j;

    initial begin
        for (j = 0; j < 32; j = j + 1) 
            register[j] <= 32'h0;
    end

    always @(posedge Clk) begin
        
        if (resetControl) begin
            outA <= 32'h0;
            outB <= 32'h0;
        end else begin
            // Leitura
            if (rs == 0) 
                outA <= 32'h0; 
            else 
                outA <= register[rs];

            if (rt == 0) 
                outB <= 32'h0; 
            else 
                outB <= register[rt];
				if (we && rd != 0) 
                register[rd] <= in; 
        end
    end
	 
endmodule
