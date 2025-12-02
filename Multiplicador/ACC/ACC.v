module ACC #(parameter N=16)(
	input Load, Sh, Ad, Clk, Rst,
	input [2*N:0] Entradas,
	output reg [2*N:0] Saidas
);

	always @(posedge Clk or posedge Rst) begin
		if (Rst) Saidas <= {2*N+1{1'b0}};
		else begin
			if (Load) Saidas <= {{N{1'b0}},Entradas[N-1:0]};
			else if (Sh) Saidas <= Saidas >> 1;
			else if	(Ad) Saidas <= {Entradas[2*N:N], Saidas[N-1:0]};		
		end
	end 

endmodule
