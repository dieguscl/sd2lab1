`timescale 1ns / 1ps

// Transcodificador de BCD (e simbolos 10 a 15) para display de 7 segmentos.
// Segmentos[6] = a ... Segmentos[0] = g, ativos a Low (0 = segmento aceso).
// O ponto decimal nao e tratado neste modulo.
module Transcod7Seg(
    input [3:0] Numero,
    output reg [6:0] Segmentos
    );

     always @(*)
         case (Numero)               //  abcdefg
             4'd0:  Segmentos = 7'b0000001;   // 0
             4'd1:  Segmentos = 7'b1001111;   // 1
             4'd2:  Segmentos = 7'b0010010;   // 2
             4'd3:  Segmentos = 7'b0000110;   // 3
             4'd4:  Segmentos = 7'b1001100;   // 4
             4'd5:  Segmentos = 7'b0100100;   // 5
             4'd6:  Segmentos = 7'b0100000;   // 6
             4'd7:  Segmentos = 7'b0001111;   // 7
             4'd8:  Segmentos = 7'b0000000;   // 8
             4'd9:  Segmentos = 7'b0000100;   // 9
             // Simbolos originais nas combinacoes nao BCD: "dIEGo-"
             4'd10: Segmentos = 7'b1000010;   // d (b c d e g)
             4'd11: Segmentos = 7'b1111001;   // I do lado esquerdo (e f), diferente do 1
             4'd12: Segmentos = 7'b0110000;   // E (a d e f g)
             4'd13: Segmentos = 7'b0100001;   // G (a c d e f)
             4'd14: Segmentos = 7'b1100010;   // o (c d e g)
             4'd15: Segmentos = 7'b1111110;   // - (g)
             default: Segmentos = 7'b1111111; // tudo apagado
         endcase

endmodule
