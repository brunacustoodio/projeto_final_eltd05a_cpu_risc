`timescale 1ns/100ps
module registerfile_TB();

	reg clk;
	reg rst;
	reg wr;
	
	reg [31:0] dataIn;
	reg [4:0] wrAddress;
	reg [4:0] rdAddress1;
	reg [4:0] rdAddress2;
	
	wire [31:0] dataOut1;
	wire [31:0] dataOut2;
	
	integer i;
	
	registerfile DUT
	(
		.clk(clk),
		.rst(rst),
		.wr(wr),
		.dataIn(dataIn),
		.wrAddress(wrAddress),
		.rdAddress1(rdAddress1),
		.rdAddress2(rdAddress2),
		.dataOut1(dataOut1),
		.dataOut2(dataOut2)
	);
	
	always #4 clk = ~clk;
	
	initial 
		begin
			clk = 0;
			
			//reset
			rst = 1;
			#2;
			rst = 0;
			#2;
			rst = 1;
			
			wr = 1;
			
			//escrevendo
			for(i = 0; i < 33; i = i + 1)
				begin
					#10;
					wrAddress = i;
					dataIn = i + 1;
				end
				
				wr = 0;
				
				//leitura
				for(i = 0; i < 32; i = i + 1)
					begin
						#10;
						rdAddress1 = i;
						rdAddress2 = i;
					end
					
					#50;
					$stop;
		end

endmodule 