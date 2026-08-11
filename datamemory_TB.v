`timescale 1ns/100ps
module datamemory_TB();

	reg [9:0] address;
	reg clock;
	reg [31:0] data;
	reg wren;
	
	wire [31:0] q;
	
	integer i;
	
	datamemory DUT
	(
		.address(address),
		.clock(clock),
		.data(data),
		.wren(wren),
		.q(q)
	);
	
	always #5 clock = ~clock;
	
	initial 
		begin
			clock = 0;
			//escrevendo
			wren = 1;
			
			for(i = 0; i < 1024; i = i + 1)
				begin
					#10;
					address = i;
					data = i;
				end
				
			//lendo
			wren = 0;
			
			for(i = 0; i < 1024; i = i + 1)
				begin
					#10;
					address = i;
				end
			
			#20000;
			$stop;
		end

endmodule 