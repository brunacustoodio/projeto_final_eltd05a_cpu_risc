`timescale 1ns/100ps

module mux_TB();

	reg [3:0]in;
	reg sel;
	
	wire [1:0]out;
	
	integer i;				//para teste no for
	
	mux
	#(
		.N(2),			//duas entradas de 1 bit
		.WIDTH(2)
	)
	DUT
	(
		.in(in),
		.out(out),
		.sel(sel)
	);
	
	
	initial
		begin
			for(i = 0; i < 32; i = i + 1)
				begin
					{sel, in} = i;
					
					#10;
				end
				
			$stop;
			
		end
		

endmodule 