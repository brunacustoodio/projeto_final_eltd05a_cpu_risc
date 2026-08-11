
`timescale 1ns/100ps



module risc_TB();

	reg CLK;
	reg rst;
	reg Prog_BUS_READ;
	
	wire [31:0] Data_BUS_WRITE;
	wire WE;
	wire CS;
	wire CS_P;
	wire [31:0] ADDR_Prog;
	wire [31:0] ADDR;
	wire CS_WB;
	wire iWE;
	wire CLK_MUL;
	wire CLK_SYS;
	wire [31:0] writeBack;
	wire [9:0] iAddress;
	
	risc DUT (
			.CLK(CLK),
			.rst(rst),
			.Prog_BUS_READ(Prog_BUS_READ),
			
			.Data_BUS_WRITE(Data_BUS_WRITE),
			.iWE(iWE),
			.CLK_MUL(CLK_MUL),
			.CLK_SYS(CLK_SYS),
			.CS_WB(CS_WB),
			.WE(WE),
			.CS(CS),
			.CS_P(CS_P),
			.ADDR_Prog(ADDR_Prog),
			.ADDR(ADDR),
			.writeBack(writeBack),
			.iAddress(iAddress)
		);
		
		
		
		
		always #100 CLK = ~CLK;
		//always #5.88 CLK_MUL = ~CLK_MUL;
		//always #200 CLK_SYS = ~CLK_SYS;
		
		
		
		
		initial begin
				CLK = 0;
				//CLK_MUL = 0;
				//CLK_SYS = 0;
				
				rst = 1;
				#15;
				rst = 0;
				#15;
				rst = 1;
				
				#250000;
				$stop;
			end
			
			
			

endmodule 


