`timescale 1ns/100ps
module PLL_TB();
	
	reg inclk0;
	
	wire c0;
	wire c1;
	
	PLL DUT
		(	
			.inclk0(inclk0),
			.c0(c0),
			.c1(c1)
		);
	
	always #14.706 inclk0 = ~inclk0;
	
	initial
		begin
			inclk0 = 0;
			
			#10000;
			$stop;
		end

endmodule 