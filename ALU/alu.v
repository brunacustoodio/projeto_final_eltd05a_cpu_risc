module alu(a, b, sel, out, zeroFlag);
    input [31:0] a, b;
    input [1:0] sel;
    output reg [31:0] out;
    output zeroFlag;

    assign zeroFlag = (out == 32'b0) ? 1 : 0;  

    always @(*)
    begin
        case(sel)
            2'b00: out <= a + b; 	
            2'b01: out <= a - b;		
            2'b10: out <= a & b;		
            2'b11: out <= a | b;		
        endcase
    end
 
endmodule