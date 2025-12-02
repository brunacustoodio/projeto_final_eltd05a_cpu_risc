module CONTROL (
	input Clk, K, St, M, Rst,
	output reg Idle, Done, Load, Sh, Ad
);

	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
	
	reg [1:0] state;	
	
	always @(posedge Clk or posedge Rst) begin
		if(Rst) state <= S0;
		else
			case (state)
				S0: state <= (St) ? S1 : S0;		
				S1: state <= S2;
				S2: state <= (K) ? S3 : S1;		
				S3: state <= S0;
				default: state <= S0;
			endcase	
	end
	
	always @ (*)begin
		Idle=0; 
		Sh=0;
		Ad=0; 
		Done=0; 
		Load=0;
		case (state)
			S0: begin Idle = 1; if (St) Load = 1; end	
			S1: Ad = M;
			S2: Sh = 1;	
			S3: Done = 1;
		endcase
	end

endmodule 