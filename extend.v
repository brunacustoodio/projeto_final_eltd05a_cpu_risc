module extend (
	input [15:0] OFFSET_In,
	output reg [31:0] OFFSET_Out
);

	wire MSB;
	
	assign MSB = OFFSET_In[15];
	
	always@(*) begin
			if(MSB) OFFSET_Out = 32'hffff0000 | OFFSET_In;
			else OFFSET_Out = 32'h0000ffff & OFFSET_In;
		end

endmodule 