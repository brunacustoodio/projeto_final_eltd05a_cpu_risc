module Counter #(parameter N=16)(
	input Load, Clk, Rst,
	output reg K
);
	reg[5:0] counter;
	reg aux_load = 0;
	
	always @(posedge Load or posedge Clk or posedge Rst) begin
		if(Rst) begin
			counter <= 0; K <= 0;
		end
		else if(Load) begin 
			counter <= 0; aux_load <= 1; K <= 0;
		end
		else if(counter == 2*N-2 && aux_load) begin
				counter <= 0; aux_load <= 0; K <= 1;
			end
		else if(aux_load) begin
			counter <= counter + 1; K <= 0;
		end
	end
	
endmodule
