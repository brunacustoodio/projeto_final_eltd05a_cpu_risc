module ACC (
	input Load, Sh, Ad, Clk, rst,
	input [32:0] Entradas,
	output reg[32:0] Saidas
);

	always@(posedge Clk or negedge rst)
		begin
			if(~rst) Saidas <= 0;
			else
				begin
	if(Load)
		begin
			Saidas[15:0] <= Entradas[15:0];
			Saidas[32:16] <= 4'b0;
		end else
				begin
					if(Sh)
		begin
			Saidas <= Saidas >> 1;
		end else
				begin
					if(Ad)
						begin
							Saidas[32:16] <= Entradas[32:16];
						end else Saidas <= Saidas; 
				end
								end
				end
		end

endmodule

