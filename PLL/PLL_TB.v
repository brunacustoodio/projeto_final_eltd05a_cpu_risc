`timescale 1ns/100ps
module PLL_TB();
	reg CLK;
	wire CLK_SYS, CLK_MUL;
	
	PLL DUT(
			  .inclk0(CLK),
			  .c0(CLK_MUL),
			  .c1(CLK_SYS)
			 );
	
	initial #4000 $stop;
	initial CLK = 1'b0;
	always #10 CLK = ~CLK; // Clock de 50 MHz

endmodule 