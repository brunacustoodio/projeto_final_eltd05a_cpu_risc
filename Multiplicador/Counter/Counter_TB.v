`timescale 1ns / 100ps

module Counter_TB;

    parameter N = 6; 
    reg Load, Clk, Rst;
	 reg[N:0] counter;
    wire K;
    integer i;

    Counter #(N) DUT (
        .Load(Load),
        .Clk(Clk),
        .Rst(Rst),
        .K(K)
    );

    initial begin
        Clk = 0;
        forever #10 Clk = ~Clk;  
    end

    initial begin
        Rst = 0;
        #2 Rst = 1;  
        #2 Rst = 0;

        Load = 1;      
        #4 Load = 0;  

        for (i = 0; i <= 2*N - 3; i = i + 1) begin
            #20;
        end

        #20 Load = 1;     
        #4 Load = 0;  

        for (i = 0; i <= 2*N - 3; i = i + 1) begin
            #20;      
        end
        #50 Rst = 1;
		  #2 Rst = 0;
		  #50;
        $stop;
    end
    initial $init_signal_spy("/Counter_TB/DUT/counter","counter",1);

endmodule
