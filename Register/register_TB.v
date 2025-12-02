`timescale 1ns/10ps
module register_TB();

	reg Reset, Clk;
	reg [31:0] in;
	wire [31:0] out;
	
	register DUT(
		.Clk(Clk),
		.in(in),
		.out(out),
		.Reset(Reset)
	);
	
	always
		#5 Clk = ~Clk; // Gera o sinal de clock

	initial 
	begin
		Reset = 1;  // Ativa o reset
		Clk = 0;    // Inicializa o clock
		in = 0;     // Inicializa a entrada
		#8 Reset = 0; // Desativa o reset
		#20 in = 32'h67480FAC; // Valor 1
		#30 in = 32'h11101110;  // Valor 2
		#20 Reset = 1; // Ativa o reset
		#20 Reset = 0; // Desativa o reset novamente
		#35 in = 32'hFFFFFFFF; // Valor máximo
		#20 in = 32'h00000000; // Valor mínimo
		#25 in = 32'hDEADBEEF; // Valor de teste popular
		#30 in = 32'hCAFEBABE; // Outro valor popular
		#30 in = 32'h12345678; // Valor em sequência
		#25 in = 32'hAABBCCDD; // Valor hex
		#30 in = 32'h87654321; // Valor reverso
		#30 $stop; // Para a simulação
	end
	
endmodule
