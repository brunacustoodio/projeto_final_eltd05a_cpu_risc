`timescale 1ns/10ps
module Counter_TB();

	reg Load = 0, Clk;
	wire K;
	reg [2:0] i = 3'b000; 


	
	Counter DUT
	(
		.Load(Load), 
		.Clk(Clk), 
		.K(K)
	); 
	
	
	initial 
		begin
			Clk = 0;
			#1 Load = 0;
			#1 Load = 1;
			#1 Load = 0;
			#1 Clk = 1;
			#2 Clk = 0;   
			#2 Clk = 1;
			
			for(i = 0; i < 7; i = i + 1)
				begin
					#2 Clk = 0;
					#2 Clk = 1;
				end
		end

endmodule
