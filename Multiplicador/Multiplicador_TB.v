`timescale 1ns/100ps
module Multiplicador_TB;
	
	//parameter N = 16;
	
	reg St, Clk, Rst;
	reg [15:0] Multiplicando, Multiplicador;
	wire Idle, Done;
	wire [31:0] Produto;

	Multiplicador DUT(
		.St(St), 
		.Clk(Clk), 
		.Rst(Rst), 
		.Multiplicando(Multiplicando), 
		.Multiplicador(Multiplicador), 
		.Idle(Idle), 
		.Done(Done), 
		.Produto(Produto)
	);
  
	always #10 Clk = ~Clk;

	initial begin
		Clk = 0;
		Rst = 0;
		St = 0;
		
		// Caso de teste 1: Multiplicando = 15, Multiplicador = 15
		Multiplicando = 3;
		Multiplicador = 0;

		// Reset
		#5 Rst = 1;
		#10 Rst = 0;
		
		#20;

		// Ativar o multiplicador
		St = 1;
		#20;
		St = 0;

		// Espera até que o sinal Done seja ativado, o que significa que a multiplicação terminou
		wait (Done == 1);

		#35;

		// Caso de teste 2: Multiplicando = 7, Multiplicador = 3
		Multiplicando = 7;
		Multiplicador = 3;

		// Iniciar nova multiplicação
		St = 1;
		#20;
		St = 0;

		// Espera novamente até que o sinal Done seja ativado, o que significa que a multiplicação terminou
		wait (Done == 1);
		
		#35;

		// Caso de teste 3: Multiplicando = 10, Multiplicador = 5
		Multiplicando = 10;
		Multiplicador = 5;

		// Iniciar a multiplicação
		St = 1;
		#20;
		St = 0;

		// Esperar o Done
		wait (Done == 1);
		
		#35;

		// Caso de teste 4: Multiplicando = 0, Multiplicador = 0
		Multiplicando = 0;
		Multiplicador = 0;

		// Iniciar nova multiplicação
		St = 1;
		#20;
		St = 0;

		// Espera novamente até que o sinal Done seja ativado, o que significa que a multiplicação terminou
		wait (Done == 1);
		
		#35;

		// Caso de teste 5: Multiplicando = 0, Multiplicador = 3
		Multiplicando = 0;
		Multiplicador = 3;

		// Iniciar nova multiplicação
		St = 1;
		#20;
		St = 0;

		// Espera novamente até que o sinal Done seja ativado, o que significa que a multiplicação terminou
		wait (Done == 1);
		
		#35;

		// Caso de teste 6: Multiplicando = 15, Multiplicador = 15
		Multiplicando = 65535;
		Multiplicador = 65535;

		// Iniciar nova multiplicação
		St = 1;
		#20;
		St = 0;

		// Espera novamente até que o sinal Done seja ativado, o que significa que a multiplicação terminou
		wait (Done == 1);

		// Finalizar simulação
		#60;
		$stop;
	end

endmodule
