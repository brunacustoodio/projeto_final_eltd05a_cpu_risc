`timescale 1ns/100ps
module register_TB();

	reg Clk;
	reg [31:0] d;
	reg rst;
	
	wire [31:0] q;
	
	integer i;
	
	register #(.WIDTH(32)) DUT
	(
		.Clk(Clk),
		.d(d),
		.q(q),
		.rst(rst)
	);
	
	always #5 Clk = ~Clk;
	
	initial
		begin
			rst = 1;
			#10;
			rst = 0;
			#10;
			rst = 1;
			
			Clk = 0;
			
			for(i = 0; i < 1000; i = i + 1)
				begin
					#10;
					d = i;
				end
			
			#50;
			$stop;
		end

endmodule 