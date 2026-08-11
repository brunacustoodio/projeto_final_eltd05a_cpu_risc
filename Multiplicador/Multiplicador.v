module Multiplicador
(
	input St,
	input Clk,
	input rst,
	input [15:0] Multiplicando,
	input [15:0] Multiplicador,
	
	output wire Idle,
	output wire Done,
	output wire Load,
	output wire K,
	output wire Sh,
	output wire [6:0]cnt,
	output wire Ad,
	output wire M,
	output [31:0] Produto,
	output wire [1:0] state
);

	//wire M;
	wire [32:0] SaidaACC;
	wire [32:0] EntradaACC;
	wire [15:0] OperandoB;
	wire [16:0] Soma;
	
	//criando um assign para os bits extraidos do ACC e sinal M
	assign OperandoB = SaidaACC[31:16];
	assign M = SaidaACC[0];
	assign EntradaACC = {Soma, Multiplicador};
	assign Produto = SaidaACC[31:0];
	
	//instanciando o ACC
	ACC ACC_01
		(
			.Load(Load),
			.Sh(Sh),
			.Ad(Ad),
			.Clk(Clk),
			.Saidas(SaidaACC),
			.Entradas(EntradaACC),
			.rst(rst)
		);
		
	//instanciando o Adder
	Adder Adder_01
		(
			.OperandoA(Multiplicando),
			.OperandoB(OperandoB),
			.Soma(Soma)
		);
		
	//instanciando o Counter
	Counter Counter_01
	(
		.Clk(Clk),
		.K(K),
		.rst(rst),
		.Load(Load),
		.cnt(cnt)
	);
	
	//instanciando CONTROL
	CONTROL CONTROL_01
	(
		.Clk(Clk),
		.K(K),
		.St(St),
		.M(M),
		.Idle(Idle),
		.Done(Done),
		.Load(Load),
		.Sh(Sh),
		.Ad(Ad),
		.rst(rst),
		.state(state)
	);
	


endmodule 