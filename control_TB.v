`timescale 1ns/100ps
module control_TB();

	reg [31:0] instruction;
	reg clk;
	reg rst;
	
	wire erro;
	wire [4:0] A_read;
	wire [4:0] B_read;
	wire [4:0] wr_address;
	wire ctrl_wr;
	wire [1:0]ALU_Op;
	wire ALU_preMux;
	wire ALU_posMux;
	wire wr_mem;
	wire ALU_x_mem;
	
	wire A_operand_hazard;
	wire B_operand_hazard;
	//wire [4:0] prev_reg;
	//wire [4:0] prev_reg_old;
	
	control DUT
	(
		.instruction(instruction),
		.clk(clk),
		.rst(rst),
		
		.erro(erro),
		.A_read(A_read),
		.B_read(B_read),
		.wr_address(wr_address),
		.ctrl_wr(ctrl_wr),
		.ALU_Op(ALU_Op),
		.ALU_preMux(ALU_preMux),
		.ALU_posMux(ALU_posMux),
		.wr_mem(wr_mem),
		.ALU_x_mem(ALU_x_mem),
		
		.A_operand_hazard(A_operand_hazard),
		.B_operand_hazard(B_operand_hazard)
		//.prev_reg(prev_reg),
		//.prev_reg_old(prev_reg_old)
		
	);
	
	always #45 clk = ~clk;
	
	initial
		begin
			clk = 1;
			rst = 1;
			#2;
			rst = 0;
			#2;
			rst = 1;
			
			instruction = 32'b10010000000000100000000000001011;
			#85;
			instruction = 32'b00101100010000100001101010100000;
			#85;
			instruction = 32'b0;
			#85;
			instruction = 32'b00101100100001000001101010100000;
			#85;
			instruction = 32'b00101100011000110001101010100000;
			
			#150;
			$stop;
		end

endmodule 