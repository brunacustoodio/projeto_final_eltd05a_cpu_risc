module Multiplicador #(parameter N=16)(
	input St, Clk, Rst,
	input[N-1:0] Multiplicando, Multiplicador,
	output Idle, Done,
	output[2*N-1:0] Produto
);
	
	wire Load, Sh, Ad, K, M;
	wire[N:0] Soma;
	wire[N-1:0] operandoB;
	wire[2*N:0] resultado;
	assign M = resultado[0];
	assign operandoB = resultado[2*N-1:N];
	
	CONTROL controle (
							.Clk(Clk), 
							.K(K), 
							.St(St), 
							.M(M),
							.Idle(Idle), 
							.Done(Done), 
							.Load(Load), 
							.Sh(Sh), 
							.Ad(Ad),
							.Rst(Rst));
							
	Counter #(.N(N)) Contador (
							.Load(Load), 
							.Clk(Clk), 
							.Rst(Rst),
							.K(K));
	Adder #(.N(N)) somador (
							.OperandoA(Multiplicando), 
							.OperandoB(operandoB), 
							.Soma(Soma));
	ACC #(.N(N)) acumulador (
							.Load(Load), 
							.Sh(Sh), 
							.Ad(Ad), 
							.Clk(Clk), 
							.Rst(Rst),
							.Entradas({Soma,Multiplicador}), 
							.Saidas(resultado));
						
	assign Produto = resultado[2*N-1:0];
	

endmodule 