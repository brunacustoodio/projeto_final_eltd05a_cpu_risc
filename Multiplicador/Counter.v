module Counter (
	input Load, Clk, rst,
	output reg K,
	output reg [6:0]cnt
);

	reg flag;
	
	always@(posedge Clk or negedge rst)
		begin
			if(~rst)
				begin
					K <= 0;
					cnt <= 0;
					flag <= 0;
				end else if(Load)
					begin
						flag <= 1;
						cnt <= 0;
					end else if(flag)
									begin
						cnt <= cnt + 1;
						
						if(cnt == 31) 
							begin
								K <= 1;
								flag <= 0;
								cnt <= 0;
							end else K <= 0;
					end else K <= 0;
		end

endmodule
