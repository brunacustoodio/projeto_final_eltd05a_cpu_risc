/*
Grupo 2

Nomes:
Bruna Custodio Alves - 2021032144
Gean Carlos Gonçalves Martins - 2020021262


Perguntas:

a) Qual a latência do sistema?
b) Qual o throughput do sistema?
c) Qual a máxima frequência operacional entregue pelo Time Quest Timing Analizer 
para o multiplicador e para o sistema? (Indique a FPGA utilizada)
d) Qual a máxima frequência de operação do sistema? (Indique a FPGA utilizada)
e) Analisando a sua implementação de dois domínios de clock diferentes, 
haverá problemas com metaestabilidade?  Por que?
f) A aplicação de um multiplicador do tipo utilizado, no sistema MIPS sugerido, 
é eficiente em termos de velocidade? Por que?
g) Cite modificações cabíveis na arquitetura do sistema que tornaria o sistema 
mais rápido (frequência de operação maior). Para cada modificação sugerida, 
qual a nova latência e throughput do sistema?
 

Respostas do grupo:

a) A latência desse sistema é de 5 ciclos de clock (tempo que o processamento de uma
informação na entrada leva para chegar à saída)


b) O throughput desse sistema é de uma instrução executada a cada ciclo de clock


c) FPGA utilizada: EP4CGX110CF23C7
Máxima freq. operacional entregue pelo TimeQuest para a CPU: 39.02 MHz
Máxima freq. operacional entregue pelo TimeQuest para o multiplicador: 212.68 MHz


d) FPGA utilizada: EP4CGX110CF23C7
Máxima freq. de operação entregue pelo TimeQuest para a CPU: 39.02 MHz
Máxima freq. de operação entregue pelo TimeQuest para o multiplicador: 212.68 MHz
Considerando que o clock da cpu tem que ser um múltiplo de 34 vezes menor que o clock do multiplicador, 
o clock máximo teórico possível é de 212.68MHz/34 ~6,25MHz


e) Não haveria problemas com metaestabilidade uma vez que o clock do sistema seja
34x menor que o clock do multiplicador (ou o clock do multiplicador ser 34 vezes maior
que o clock do sistema), que é o tempo necessário até que a informação entregue pelo
multiplicador tenha seu processamento completo finalizado


f) Não é necessariamente eficiente em termos de frequência de clock justamente 
por limitar a frequência máxima de operação em cerca de 16% do valor previsto de 
39 MHz (reduzindo para 6,25 MHz).


g) Modificação sugerida: Utilizar os multiplicadores de hardware dedicados da FPGA (DSP Blocks) ou
 uma arquitetura em pipeline. A depender do multiplicador escolhido, a latência da instrução de multiplicação cairia 
 (para 1 ciclo no caso de DSP combinacional), mas o throughput do sistema continuaria sendo 1 instrução por ciclo (e não 5). 
 Com essa modificação, a frequência máxima de operação não precisaria ser dividida, permitindo que o sistema rodasse próximo 
 aos 39 MHz previstos atualmente.





Informações sobre o sistema:

 - O projeto utiliza a fpga EP4CGX110CF23C7 fast model
 - A frequência da CPU foi definida como 2,5MHz
 - A frequência do multiplicador, por sua vez, é de 34 * 2,5 = 85MHz
 - A simulação termina, quase que, imediatamente após o segundo posedge em iWE
 - A unidade da PLL (gerada pelo IP) recebe um clock de 5MHz (aparentemente é o
mínimo que a PLL aceita na entrada), divide por 2 em c0 e multiplica por 17
em c1
*/
module risc
(


	input CLK,
	input rst,
	input [31:0] Prog_BUS_READ,
	input [31:0] Data_BUS_READ,
	//input CLK_MUL,
	//input CLK_SYS,
	
	
	
	output wire [31:0] Data_BUS_WRITE,
	output wire WE,
	output wire CS,
	output wire CS_P,
	output wire [31:0] ADDR_Prog,
	output wire [31:0] ADDR,
	
	
	
	//monitorando os sinais requisitados via externalização
	output wire CS_WB,
	output wire iWE,
	output wire [31:0] writeBack,
	output wire [9:0] iAddress,
	output wire CLK_MUL,
	output wire CLK_SYS
	
	
);

//demais sinais
	wire zeroIn;
	wire bneIn;
	wire [31:0] IMM;
	wire JUMP;
	wire [25:0]JUMP_Address;
	wire [9:0] OUTPUT;
	wire [31:0] INSTMEM_Out;
	wire [31:0] EX;
	wire [15:0] GLOBAL_Offset;
	wire [13:0] CTRL_ID_EX_Out;
	wire WR;
	wire BNE;
	
	
	
//wires do register file 
	wire REGISTER_FILE_WE_In;
	wire [4:0] REGISTER_FILE_Address_In;
	wire [4:0] REGISTER_FILE_A_Read_In;
	wire [4:0] REGISTER_FILE_B_Read_In;
	wire [31:0] REGISTER_FILE_A_Out;
	wire [31:0] REGISTER_FILE_B_Out;
	wire [4:0] REGISTER_FILE_A_Read_Address;
	wire REGISTER_FILE_WE_CTRL_ID_EX_Output;
	wire [31:0] REGISTER_A_Out;
	wire REGISTER_FILE_WE_Tramitter;
	wire [4:0] REGISTER_FILE_Address_Tramitter;
	
	
	
//wires para multiplexadores
	wire MUX_EX_00;
	wire MUX_EX_01;
	wire [31:0] MUX_IF_ID;
	wire MUX_03;
	wire MUX_EX_00_In;
	wire MUX_EX_01_In;
	wire MUX_WB_01;
	wire MUX_WB_01_In;
	
	
	
//wires para o multiplicador
	wire MUL_Start;
	wire MUL_Start_In;
	wire [15:0] Multiplicando;
	wire [15:0] Multiplicador;
	wire [31:0] MUL_Out;
	
	
	
//wires para a alu
	wire [1:0] ALU_OP_In;
	wire [31:0] B_In;
	wire [31:0] ALU_Out;
	wire [1:0] ALU_Operation;
	
	
	
//wires para as memorias 
	wire [31:0] DATAMEM_Out;
	wire [7:0] CTRL_MEM_WB_Out;
	wire [31:0] D_MEM_WB_Out;
	wire [31:0] DATA_Tramitter; 
	
	
		
//assigns para separação de sianis concatenados nos registros de transferencia de estagio
	assign MUX_WB_01_In = CTRL_ID_EX_Out[0];
	assign WE = CTRL_ID_EX_Out[1];
	assign MUX_EX_01_In = CTRL_ID_EX_Out[2];
	assign MUX_EX_00_In = CTRL_ID_EX_Out[3];
	assign ALU_OP_In = CTRL_ID_EX_Out[5:4];
	assign REGISTER_FILE_WE_Tramitter = CTRL_ID_EX_Out[6];
	assign REGISTER_FILE_Address_Tramitter = CTRL_ID_EX_Out[11:7];
	assign MUL_Start_In = CTRL_ID_EX_Out[12];
	assign bneIn = CTRL_ID_EX_Out[13];
	
	assign Multiplicando = REGISTER_A_Out[15:0];
	assign Multiplicador = Data_BUS_WRITE[15:0];
	assign GLOBAL_Offset = MUX_IF_ID[15:0];

	
	assign REGISTER_FILE_Address_In = CTRL_MEM_WB_Out[7:3];
	assign REGISTER_FILE_WE_In = CTRL_MEM_WB_Out[2];
	assign MUX_WB_01 = CTRL_MEM_WB_Out[1];
	assign CS_WB = CTRL_MEM_WB_Out[0];
	


	PLL PLL_00 (
			.inclk0(CLK),
			.c0(CLK_SYS),
			.c1(CLK_MUL)
		);
		
		
	
	pc PROGRAM_COUNTER (
			.clk(CLK_SYS),
			.rst(rst),
			.Flag_Zero(zeroIn),
			.BNE_On(bneIn),
			.BNE_Offset(IMM),
			.JUMP_Flag(JUMP),
			.JUMP_Address(JUMP_Address),
			
			.PC_Out(ADDR_Prog)
		);
		
		
		
	ADDRDecoding_Prog PROG_MEM_ADDRESS_DECODER (
			.ADDRESS_In(ADDR_Prog),
			
			.ADDRESS_Out(OUTPUT),
			.CS(CS_P)
		);
		
		
		
	mux #(.N(2), .WIDTH(32)) MUX00 (
			.in({INSTMEM_Out, Prog_BUS_READ}),
			.sel(CS_P),
			
			.out(MUX_IF_ID)
		);
		
		
		
	InstMem INSTRUCTION_MEMORY (
			.clock(CLK_SYS),
			.address(OUTPUT),
			
			.q(INSTMEM_Out)
		);
		
		
	extend EXTEND_00 (
			.OFFSET_In(GLOBAL_Offset),
			
			.OFFSET_Out(EX)
		);
		
		
		
	register #(.WIDTH(32)) REGISTER_00 (
			.Clk(CLK_SYS),
			.rst(rst),
			.d(EX),
			
			.q(IMM)
		);
		
		
		
	register #(.WIDTH(32)) REGISTER_01 (
			.Clk(CLK_SYS),
			.rst(rst),
			.d(REGISTER_FILE_A_Out),
			
			.q(REGISTER_A_Out)
		);
		
		
		
	register #(.WIDTH(32)) REGISTER_02 (
			.Clk(CLK_SYS),
			.rst(rst),
			.d(REGISTER_FILE_B_Out),
			
			.q(Data_BUS_WRITE)
		);
		
		
		
	register #(.WIDTH(14)) REGISTER_03 (
			.Clk(CLK_SYS),
			.rst(rst),
			.d({BNE, MUL_Start, REGISTER_FILE_A_Read_Address, REGISTER_FILE_WE_CTRL_ID_EX_Output, 
				ALU_Operation, MUX_EX_00, MUX_EX_01, WR, MUX_03}),
				
			.q(CTRL_ID_EX_Out)
		);
		
		
		
	registerfile REGISTER_BANK (
		.clk(CLK_SYS),
		.rst(rst),
		.wr(REGISTER_FILE_WE_In),
		.dataIn(writeBack),
		.wrAddress(REGISTER_FILE_Address_In),
		.rdAddress1(REGISTER_FILE_A_Read_In),
		.rdAddress2(REGISTER_FILE_B_Read_In),
		
		.dataOut1(REGISTER_FILE_A_Out),
		.dataOut2(REGISTER_FILE_B_Out)
	);
	
	
	
	control CONTROL_00 (
			.CONTROL_Entrace(MUX_IF_ID),
			.BRANCH_Flag_Input(bneIn),
			.ZERO_Flag_Input(zeroIn),
			
			.R0(REGISTER_FILE_A_Read_In),
			.R1(REGISTER_FILE_B_Read_In),
			.R2(REGISTER_FILE_A_Read_Address),
			
			.REGISTER_WE(REGISTER_FILE_WE_CTRL_ID_EX_Output),
			.ALU_Operation(ALU_Operation),
			
			.MUX_01(MUX_EX_00),
			.MUX_02(MUX_EX_01),
			.MUX_03(MUX_03),
			
			.WR(WR),
			.MUL_Start(MUL_Start),
			.BNE(BNE),
			
			.JUMP(JUMP),
			.JUMP_Address(JUMP_Address)
		);
		
		
		

	mux #(.N(2), .WIDTH(32)) MUX_01 (
			.in({IMM, Data_BUS_WRITE}),
			.sel(MUX_EX_00_In),
			
			.out(B_In)
		);
		
		
		
	mux #(.N(2), .WIDTH(32)) MUX_02 (
			.in({ALU_Out, MUL_Out}),
			.sel(MUX_EX_01_In),
			
			.out(ADDR)
		);
		
		
		
	Multiplicador MULTIPLIER (
			.Clk(CLK_MUL),
			.rst(rst),
			.St(MUL_Start_In),
			.Multiplicando(Multiplicando),
			.Multiplicador(Multiplicador),
			
			.Produto(MUL_Out)
		);
		
		
		
	alu ALU_00 (
			.A_In(REGISTER_A_Out),
			.B_In(B_In),
			.OP(ALU_OP_In),
			
			.ALU_Out(ALU_Out),
			.ZERO_Flag(zeroIn)
		);
		
		
		
	mux #(.N(2), .WIDTH(32)) MUX_003 (
			.in({DATAMEM_Out, Data_BUS_READ}),
			.sel(CS_WB),
			
			.out(DATA_Tramitter)
		);
		
		
		
	mux #(.N(2), .WIDTH(32)) MUX_04 (
			.in({DATA_Tramitter, D_MEM_WB_Out}),
			.sel(MUX_WB_01),
			
			.out(writeBack)
		);
		
		
		

	ADDRDecoding MEM_PROG_ADDRESS_DECODER (
			.ADDRESS_In(ADDR),
			
			.ADDRESS_Out(iAddress),
			.WE(WE),
			.iWE(iWE),
			.cs(CS)
		);
		
		
		
	datamemory DATA_MEMORY (
			.address(iAddress),
			.clock(CLK_SYS),
			.data(Data_BUS_WRITE),
			.wren(iWE),
			
			.q(DATAMEM_Out)
		);
		
		
		
	register #(.WIDTH(8)) REGISTER_04 (
			.Clk(CLK_SYS),
			.rst(rst),
			.d({REGISTER_FILE_Address_Tramitter, REGISTER_FILE_WE_Tramitter, MUX_WB_01_In, CS}),
			
			.q(CTRL_MEM_WB_Out)
		);
		
		
		
	register #(.WIDTH(32)) REGISTER_05 (
			.Clk(CLK_SYS),
			.rst(rst),
			.d(ADDR),
			
			.q(D_MEM_WB_Out)
		);
		
		

		
endmodule 

