`timescale 1ns/100ps
module extend_TB();

	reg [15:0] offset_In;
	wire [31:0] offset_Out;
	
	extend DUT
	(
		.offset_In(offset_In),
		.offset_Out(offset_Out)
	);
	
	initial
		begin
			offset_In = 16'hffff;
			
			#10;
			
			offset_In = 16'h7fff;
			
			#50;
			$stop;
		end

endmodule 