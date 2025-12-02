`timescale 1ns/100ps
module Adder_TB;

	parameter N = 4;
	reg[N-1:0] OperandoA, OperandoB;
	wire[N:0] Soma;

	Adder #(.N(N)) DUT(
							 .OperandoA(OperandoA),
							 .OperandoB(OperandoB),
							 .Soma(Soma)
							);
							
	initial begin
		OperandoA = 15;
		OperandoB = 15;
		#20;
		OperandoA = 7;
		OperandoB = 6;
		#20;
		$stop;
	end

endmodule 