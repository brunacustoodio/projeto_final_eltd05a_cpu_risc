`timescale 1ns/100ps
module InstMem_TB();

	reg [9:0] address;
	reg Clk;
	
	wire [31:0] q;
	
	integer i;
	
	InstMem DUT
	(
		.address(address),
		.clock(Clk),
		.q(q)
	);
	
	always #15.5 Clk = ~Clk;


	initial 
		begin
			Clk = 0;
			for(i = 0; i < 1024; i = i + 4)
				begin
					#40;
					address = i;
				end
				
			#50;
			$stop;
		end
	
endmodule 