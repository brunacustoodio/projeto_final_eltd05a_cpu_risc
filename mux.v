module mux 
#(
    parameter N = 4,  // Número de entradas
    parameter WIDTH = 8  // Largura de cada entrada
)
(
    input [N*WIDTH-1:0] in, // Entradas concatenadas
    input [$clog2(N)-1:0] sel, // Sinal de seleção
    output [WIDTH-1:0] out  // Saída selecionada
);

    assign out = in[sel*WIDTH +: WIDTH];

endmodule 