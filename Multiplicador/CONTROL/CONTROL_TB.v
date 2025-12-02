`timescale 1ns/100ps

module CONTROL_TB();

	reg Clk, St, Rst, K, M;
	wire Idle, Done, Load, Sh, Ad;
	reg [1:0] state;

	// Instanciando o módulo CONTROL
	CONTROL DUT (
		.Clk(Clk), 
		.St(St), 
		.Rst(Rst),
		.K(K), 
		.M(M), 
		.Idle(Idle), 
		.Done(Done), 
		.Load(Load), 
		.Sh(Sh), 
		.Ad(Ad)
	);

	// Geração do clock (periodo de 10 unidades de tempo)
	always #5 Clk = ~Clk;

	// Inicialização de variáveis e monitoramento
	initial begin
		 // Inicialmente, todos os sinais são zerados
		 Clk = 0; 
		 St = 0; 
		 K = 0; 
		 M = 0;
		 Rst = 0;
		 
		 // Reseta o sistema (Rst = 1, depois volta a 0)
		 $display("Tempo\tSt\tK\tM\tIdle\tLoad\tSh\tAd\tDone");
		 $monitor("%g\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", $time, St, K, M, Idle, Load, Sh, Ad, Done);
		 
		 // Reset no início
		 #1 Rst = 1;
		 #3 Rst = 0;

		 // Teste: Sistema em repouso (estado S0)
		 #10;

		 // Teste: Ativar St para iniciar (de S0 para S1)
		 St = 1;
		 #10;

		 // Teste: Avançar para S2 (não depende de St)
		 St = 0;
		 #10;

		 // Teste: Mudar K para 1, levando para S3
		 K = 1;
		 #10;

		 // Teste: Voltando ao estado S0, Done deve ser ativado
		 K = 0;
		 #10;

		 // Teste: Ativar M para verificar Ad = M no estado S1
		 St = 1;  // Ativa o início
		 M = 1;   // Define M para 1
		 #10;

		 // Teste: Estado S1 deve ter Ad = M (ou seja, Ad = 1)
		 #10;

		 // Teste: Deixar K = 0 para ir de S2 para S1
		 K = 0;
		 #10;

		 // Teste: Voltando para S1 novamente, Idle deve ser 1
		 St = 0;
		 M = 0;
		 #10;

		 // Finalizando a simulação
		 $stop;
	end
	
	initial $init_signal_spy("/CONTROL_TB/DUT/state","state",1);

endmodule
