`timescale 1ns/10ps
module CONTROL_TB();

	reg Clk, M, St, K;
	wire Idle, Done, Load, Sh, Ad;		
	
	CONTROL DUT
	(
		.Idle(Idle), 
		.Done(Done), .St(St), 
		.Load(Load), .Sh(Sh), 
		.Ad(Ad), 
		.Clk(Clk), 
		.K(K), 
		.M(M)
	);
	
	initial 
		begin
				Clk = 0;

			
				M = 0;
				K = 0;
			#1 St = 0;
			#1 St = 1;	
			#1 Clk = 1;
			#1 St = 0;	
				M = 1;
			#2 Clk = 0;   
			#2 Clk = 1;
			#2 Clk = 0; 
			#2 Clk = 1;
			#2 Clk = 0;
			#2 Clk = 1;
			#2 Clk = 0; 
				M = 1;
			#2 Clk = 1;
			#2 Clk = 0;
			#2 Clk = 1;
			#2 Clk = 0; 
				M = 0;
			#2 Clk = 1;
			#2 Clk = 0;
			#2 Clk = 1;
			#2 Clk = 0; 
				M = 1;
			#2 Clk = 1; 
			#2 Clk = 0;	
				K = 1;
			#2 Clk = 1;
			#2 Clk = 0;
			#2 Clk = 1;
			#2 Clk = 0;
			#2 Clk = 1;
		end
	
endmodule
