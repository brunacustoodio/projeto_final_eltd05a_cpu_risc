`timescale 1ns/100ps
module ADDRDecoding_TB();

	reg [31:0] Addr_in;
	reg clk;
	
	wire [9:0] Addr_out;
	wire cs;
	
	integer i;
	
	ADDRDecoding DUT
	(
		.Addr_in(Addr_in),
		//.clk(clk),
		.Addr_out(Addr_out),
		.cs(cs)
	);
	
	always #4 clk = ~clk;
	
	initial
		begin
			clk = 0;
			
			for(i = 0; i < 8000; i = i + 1)
				begin
					#10;
					Addr_in = i;
				end
			
			#50;
			$stop;
		end

endmodule 