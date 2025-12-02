module Adder #(parameter N=16)(
	input [N-1:0] OperandoA, OperandoB,
	output [N:0] Soma
);

	assign Soma = OperandoA + OperandoB;

endmodule
