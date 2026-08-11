`timescale 1ns/100ps
module alu_TB();
	
	reg [1:0] Op;
	reg [31:0] operand_A;
	reg  [31:0] operand_B;
	
	wire [31:0] Result;
	wire zero;
	
	
	alu DUT
	(
		.Op(Op),
		.operand_A(operand_A),
		.operand_B(operand_B),
		.Result(Result),
		.zero(zero)
	);
	
	
	initial
		begin
			//somando A e B
			Op = 2'b00;
			operand_A = 122546;
			operand_B = 100000;
			
			#10;
			
			//subtraido A e B
			Op = 2'b01;
			operand_A = 122546;
			operand_B = 100000;
			
			#10;
			
			//and AB
			Op = 2'b10;
			operand_A = 32'hffffffff;
			operand_B = 32'h0;
			
			#10;
			
			//or AB
			Op = 2'b11;
			operand_A = 32'hffffffff;
			operand_B = 32'h0;
			
			#50;
			
			$stop;
		end
	
endmodule 