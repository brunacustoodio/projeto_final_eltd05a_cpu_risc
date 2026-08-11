module CONTROL (
	input Clk, K, St, M, rst,
	output reg Idle, Done, Load, Sh, Ad,
	output reg [1:0] state
);
	
	//definindo os parametros de estado
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3; 
	
	always@(posedge Clk or negedge rst)
		begin
			if(~rst)
				begin
					state <= S0;
					Done <= 1;
					Idle <= 0;
				end else
						begin																	
							case(state)
									S0:
										begin
											Idle <= 1;
											
											if(St)
												begin
													Done <= 0;
													state <= S1;
												end else state <= state;
										end
									S1:
										begin
											if(K) state <= S0; 
											else if(M)
														begin
															state <= S2;
														end else state <= S2;
										end
									S2:
										begin
											if(K) state <= S0; else state <= S1;
										end
								endcase 
						end

		end
		
	always@(state or St or M)
		begin	
			case(state)
				S0:
					begin 
						if(St) 
							begin
								Load = 1; 
								Sh = 0;
								Ad = 0;
							end
						else 
							begin
								Load = 0;
								Sh = 0;
								Ad = 0;
							end
					end
				S1:
					begin 
						if(M) 
							begin
								Ad = 1; 
								Load = 0;
								Sh = 0;
							end
						else
							begin
								Ad = 0; 
								Load = 0;
								Sh = 0;
							end
					end
				S2: 
					begin
						Ad = 0; 
						Load = 0;
						Sh = 1;
					end
			endcase
		end
		

endmodule
