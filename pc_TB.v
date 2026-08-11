`timescale 1ns/100ps
module pc_TB();

	reg clk;
	reg rst;
	reg [31:0] branchOffset;
	reg branchOn;
	reg [25:0] jmpAddress;
	reg jmpFlag;
	reg zero;
	
	wire [31:0] pc_out;
	
	pc DUT
	(
		.clk(clk),
		.rst(rst),
		.pc_out(pc_out),
		.branchOffset(branchOffset),
		.branchOn(branchOn),
		.jmpAddress(jmpAddress),
		.jmpFlag(jmpFlag),
		.zero(zero)
	);
	
	always #5 clk = ~clk;
	
	initial 
		begin
			zero = 1;
			jmpFlag = 0;
			jmpAddress = 0;
			branchOn = 0;
			branchOffset = 0;
			clk = 0;
			rst = 1;
			
			#5;
			
			rst = 0;
			
			#5;
			
			rst = 1;
			
			#50000;
			$stop;
		end

endmodule 