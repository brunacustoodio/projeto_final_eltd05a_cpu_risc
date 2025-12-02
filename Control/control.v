module control(
	input [31:0] in,
	output [24:0] out
);	
	reg [5:0] operation_code, operation;
	reg [4:0] rs, rt, rd;
	
	reg [1:0] ALU_sel;
	reg mul_Start, mux_immediate_or_regB, mux2_ALU;
	reg WR_mem, CS_WB_2, WR_regfile;
	reg jmpAdress; 
	reg jmpFlag, branchFlag;
	
	assign out = {
		rs,
		rt,
		rd,
		WR_regfile,
		mux_immediate_or_regB,
		ALU_sel,
		mul_Start,
		mux2_ALU,
		WR_mem,
		CS_WB_2,
		branchFlag,
		jmpFlag
		};
		
	always @ (in) 
	begin
		operation_code = in[31:26];
		rs = in[25:21]; 
		rt = in[20:16]; 
		operation = in[5:0];
		case(in[31:26])
			6'd52:
			begin
				ALU_sel = 2'b00;
				rd = rt;
				WR_regfile = 1;
				WR_mem = 0;
				mux_immediate_or_regB = 1;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 0;
				jmpFlag = 0;
				branchFlag = 0;
			end

			6'd53:
			begin
				ALU_sel = 2'b00;
				rd = rs;
				WR_regfile = 0;
				WR_mem = 1;
				mux_immediate_or_regB = 1;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 0;
				jmpFlag = 0;
				branchFlag = 0;
			end

			6'd54:
			begin
				ALU_sel = 2'b01;
				rd = 5'b0; 
				WR_regfile = 0;
				WR_mem = 0;
				mux_immediate_or_regB = 0;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 0;
				jmpFlag = 0;
				branchFlag = 1;
			end
			6'd55:
			begin  
				ALU_sel = 2'b00;
				rd = rt;
				WR_regfile = 1;
				WR_mem = 0;
				mux_immediate_or_regB = 1;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 1;
				jmpFlag = 0;
				branchFlag = 0;
			end
			
			6'd56:
			begin  
				ALU_sel = 2'b11;
				rd = rt;
				WR_regfile = 1;
				WR_mem = 0;
				mux_immediate_or_regB = 1;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 1;
				jmpFlag = 0;
				branchFlag = 0;
			end

			6'd2:
			begin
				ALU_sel = 2'b00;
				rd = 5'b0;
				WR_regfile = 0;
				WR_mem = 0;
				mux_immediate_or_regB = 0;
				mux2_ALU = 1;
				mul_Start = 0;
				CS_WB_2 = 0;
				jmpFlag = 1; 
				branchFlag = 0;
			end

			default: 
			begin
				rd = in[15:11];
				case(operation)
					6'd32: // ADD		 
					begin
						ALU_sel = 2'b00;
						WR_regfile = 1;
						rd = rd;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 1;
						mul_Start = 0;
						CS_WB_2 = 1;
						jmpFlag = 0;
						branchFlag = 0;
					end

					6'd34: // SUB 
					begin
						ALU_sel = 2'b01;
						WR_regfile = 1;
						rd = rd;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 1;
						mul_Start = 0;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end

					6'd50: // MUL 
					begin
						ALU_sel = 2'b00; 
						WR_regfile = 1;
						rd = rd;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 0;
						mul_Start = 1;
						CS_WB_2 = 1;
						jmpFlag = 0;
						branchFlag = 0;
					end
					6'd36: //AND 
					begin
						ALU_sel = 2'b10;
						rd = rd;
						WR_regfile = 1;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 0;
						mul_Start = 1;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end

					6'd37: // OR 
					begin
						ALU_sel = 2'b11;
						WR_regfile = 1;
						WR_mem = 0;
						rd = rd;
						mux_immediate_or_regB = 0;
						mux2_ALU = 0;
						mul_Start = 1;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end

					default: 
					begin
						rs = 5'b00000;
						rt = 5'b00000;
						ALU_sel = 2'b00;
						rd = 5'b00000;
						WR_regfile = 0;
						WR_mem = 0;
						mux_immediate_or_regB = 0;
						mux2_ALU = 0;
						mul_Start = 0;
						CS_WB_2 = 0;
						jmpFlag = 0;
						branchFlag = 0;
					end
				endcase
			end
		endcase
	end

endmodule 
