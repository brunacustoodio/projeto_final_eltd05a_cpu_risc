`timescale 1ns/100ps
module ADDRDecoding_Prog_TB();

	reg [31:0] Addr_in;
	wire [9:0] Addr_out;
	wire cs;
	
	integer i;
	
	ADDRDecoding_Prog DUT
	(
		.Addr_in(Addr_in),
		.Addr_out(Addr_out),
		.cs(cs)
	);
		
	initial
		begin
			for(i = 0; i < 10000; i = i + 1)
				begin
					#10;
					Addr_in = i;
				end
			#50;
			$stop;
		end
	
endmodule 