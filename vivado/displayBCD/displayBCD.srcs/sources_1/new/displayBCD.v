`timescale 1ns / 1ps

// Circuito de ensaio do transcodificador na Basys3.
// SW3..SW0 escolhem o simbolo e SW15..SW12 escolhem quais displays acendem.
// Os anodos sao comuns e ativos a Low, por isso inverte-se o valor dos interruptores.
module displayBCD(
    input [3:0] Numero,
    input [3:0] Liga,
    output [6:0] Segmentos,
    output DotPoint,
    output [3:0] Anodos
    );

     Transcod7Seg transcod (
         .Numero(Numero),
         .Segmentos(Segmentos)
     );

     assign Anodos = ~Liga;
     assign DotPoint = 1'b1;       // ponto decimal apagado

endmodule
