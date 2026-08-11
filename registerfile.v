//Synchounous Write and Assynchounous Read
module registerfile 
//#(
	//parameter DATA_WIDTH = 32,
	//parameter ADDR_WIDTH = 5 // 5 bits to address 32 registers
//) 
(
	 input clk,
	 input rst,
	 input wr,
	 input [31:0] dataIn,
	 input [4:0] wrAddress, // Address for writing
	 input [4:0] rdAddress1, // Address for the first read
	 input [4:0] rdAddress2, // Address for the second read
	 
	 output reg [31:0] dataOut1, // Data output for the first read
	 output reg [31:0] dataOut2 // Data output for the second read
);

 // Calculate the number of registers
 //localparam NUM_REGISTERS = 2**ADDR_WIDTH;
 integer i;
 
 //--------------Internal variables----------------
 reg [31:0] registers [0:31]; // Registers 1 to NUM_REGISTERS-1
 
 // Register write logic
 always @(posedge clk or negedge rst) 
	 begin
		 if (~rst) 
			 begin
				 for (i = 1; i < 32; i = i + 1)
					registers[i] <= {32{1'b0}}; // Initialize registers 1 to NUM_REGISTERS-1 to 0
			 end else if (wr && wrAddress != 0) 
							 begin
								registers[wrAddress] <= dataIn; // Write data to the selected register (except register 0)
							 end
	 end
 
 // Output logic for the first read
 always @(*) 
	 begin
		 if (rdAddress1 == 0) dataOut1 <= {32{1'b0}}; // Register 0 is always 0
		 else dataOut1 <= registers[rdAddress1]; // Read data from the first selected register
	 end
 // Output logic for the second read
 
 always @(*) 
	 begin
		 if (rdAddress2 == 0) dataOut2 <= {32{1'b0}}; // Register 0 is always 0
		 else dataOut2 <= registers[rdAddress2]; // Read data from the second selected register
	 end
endmodule
