`timescale 1ns/100ps

module Multiplicador_TB();

    // Declarando os registros correspondentes
    reg Clk;
    reg St;
    reg rst;
    reg [15:0] Multiplicando;
    reg [15:0] Multiplicador;
    
    wire Idle;
    wire Done;
	 wire [1:0] state;
	 wire Load;
	 //wire [4:0]Soma;
	 wire Ad;
	 wire Sh;
	 wire [6:0]cnt;
	 wire K;
	 wire M;
	 //wire rst;
	 //wire rst02;
	 //wire rst01;
    wire [31:0] Produto;

    // Instanciando o DUT (Device Under Test)
    Multiplicador DUT
    (
        .Clk(Clk),
        .St(St),
        .Multiplicando(Multiplicando),
        .Multiplicador(Multiplicador),
        .Idle(Idle),
        .Done(Done),
        .Produto(Produto),
		  .rst(rst),
		  .state(state),
		  //.rst01(rst01),
		  //.rst02(rst02),
		  .Load(Load),
		  .K(K),
		  //.Soma(Soma),
		  .Sh(Sh),
		  .Ad(Ad),
		  .cnt(cnt),
		  .M(M)
    );

    integer i, j;  // Variáveis de controle para os loops
    
    initial
    begin
        // Inicializando variáveis e o circuito
        Clk = 0;
        St = 0;
        //rst = 1;
        Multiplicando = 4;
        Multiplicador = 3;
        
        #40 rst = 0;
        #40 rst = 1;
        
        // Teste automatizado com for
        for(i = 0; i < 25; i = i + 1) begin  // Loop para Multiplicando (0 a 15)
            for(j = 0; j < 25; j = j + 1) begin  // Loop para Multiplicador (0 a 15)
                Multiplicando = i;
                Multiplicador = j;
                #150 St = 1;
                #150 St = 0;
                #2000;  // Tempo suficiente para processar o produto
                
                // Verificação do resultado
                if (Produto == (i * j)) begin
                    $display("Teste OK: %d * %d = %d", i, j, Produto);
                end else begin
                    $display("Erro: %d * %d = %d (esperado %d)", i, j, Produto, (i * j));
                end
					 
					 //#10 rst = 0;
					 //#10 rst = 1;
            end
        end
        
        #400 $stop;
    end
    
    always #20 Clk = ~Clk;

endmodule
