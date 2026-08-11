`timescale 1ns/10ps
module Adder_TB();

	reg [3:0] OperandoA, OperandoB;
	wire [4:0] Soma; 
	
	Adder DUT
	(
		.OperandoA(OperandoA), 
		.OperandoB(OperandoB), 
		.Soma(Soma)
	);
	
	
	initial 
		begin
			OperandoA = 4'b0000;
			OperandoB = 4'b0000;
			#1 OperandoA = 4'b0110;
			#1 OperandoB = 4'b1001;
			#1 OperandoA = 4'b1000;
			#1 OperandoB = 4'b0001;
		end

endmodule
