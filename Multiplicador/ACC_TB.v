`timescale 1ns/10ps
module ACC_TB();

	reg Load, Sh, Ad, Clk;
	reg [8:0] Entradas; 
	wire [7:0] Saidas;		
	
	ACC DUT
	(
		.Load(Load), 
		.Sh(Sh), 
		.Ad(Ad), 
		.Clk(Clk), 
		.Entradas(Entradas), 
		.Saidas(Saidas)
	);
	
	initial 
		begin
			  Clk = 0;
			  Load = 0;
			  Sh = 0;
			  Ad = 0;
			  Entradas = 9'b00000000;  
			  
			  #1 Clk = ~Clk;
			  #1 Clk = ~Clk;
			  
			  Entradas = 9'b100100011;  
			  Load = 1;
			  #1 Clk = ~Clk;
			  #1 Clk = ~Clk;
			  Load = 0;
			  
			  
			  Sh = 1;  
			  #1 Clk = ~Clk;
			  #1 Clk = ~Clk;
			  Sh = 0;
			  
			  Entradas = 9'b100100000; 
			  Ad = 1;  
			  #1 Clk = ~Clk;
			  #1 Clk = ~Clk;
			  Ad = 0;
		end

endmodule
