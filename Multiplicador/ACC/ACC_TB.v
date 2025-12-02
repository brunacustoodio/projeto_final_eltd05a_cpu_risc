`timescale 1ns/100ps
module ACC_TB;
	parameter N = 4;
	reg Load, Sh, Ad, Clk, Rst;
	reg[2*N:0] Entradas;
	wire[2*N:0] Saidas;
	
	ACC #(.N(N)) DUT(
		.Load(Load), 
		.Sh(Sh), 
		.Ad(Ad), 
		.Clk(Clk),
		.Rst(Rst),
		.Entradas(Entradas),
		.Saidas(Saidas)	
	);
	
	initial begin
		Clk = 0;
		Rst = 0;
		Load = 0;
		Sh = 0;
		Ad = 0;
		Entradas = 9'b0_1101_1011;  // Valores 13 e 11
	end
	
	always #10 Clk = ~Clk;
	
	initial begin
		// Teste 1: Reset
		#2 Rst = 1;
		#10 Rst = 0;
		#5;
		
		// Teste 2: Load
		#10 Load = 1;
		#10 Load = 0;
		#10;  
		
		// Teste 3: Shift (Sh) - Após Load
		Sh = 1;
		#10 Sh = 0;
		#10;
		
		// Teste 4: Adiciona parte alta de Entradas (Ad) - Após o primeiro Shift
		Ad = 1;
		#10 Ad = 0;
		#10;
		
		// Teste 5: Shift (Sh) - Após primeiro Ad
		Sh = 1;
		#10 Sh = 0;
		#10;
		
		// Teste 4: Adiciona parte alta de Entradas (Ad) - Após o segundo Shift
		Ad = 1;
		#10 Ad = 0;
		#10;
		
		#10;
		$stop;
	end
	
endmodule
