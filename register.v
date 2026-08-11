module register 
#(
    parameter WIDTH = 16  // Largura padrão de 16 bits
) 
(
    input wire Clk,
    input wire rst,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(posedge Clk or negedge rst) 
		 begin
			  if (~rst) begin
					q <= {WIDTH{1'b0}};
			  end else begin
					q <= d;
			  end
		 end

endmodule
