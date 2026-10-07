`timescale 1ns / 1ps

// Testbench do circuito de ensaio displayBCD (transcodificador + anodos).
// Percorre as 256 combinacoes de Numero e Liga e verifica que:
//   - os segmentos sao os do transcodificador para esse Numero;
//   - os anodos sao a negacao de Liga (anodos comuns ativos a Low);
//   - o ponto decimal fica sempre apagado (1).
module displaybcd_teste1();

//   Declaracao das entradas
     reg [3:0] N, L;

//   Declaracao das saidas
     wire [6:0] Seg;
     wire DP;
     wire [3:0] An;

//   Instanciacao da UUT e ligacao das entradas e saidas
     displayBCD UUT (
         .Numero(N),
         .Liga(L),
         .Segmentos(Seg),
         .DotPoint(DP),
         .Anodos(An)
     );

//   Segmentos acesos (ativo a High) de cada simbolo, a partir da Fig. 30
     reg [6:0] acesos [0:15];
     initial begin           //  abcdefg
         acesos[0]  = 7'b1111110;  acesos[1]  = 7'b0110000;
         acesos[2]  = 7'b1101101;  acesos[3]  = 7'b1111001;
         acesos[4]  = 7'b0110011;  acesos[5]  = 7'b1011011;
         acesos[6]  = 7'b1011111;  acesos[7]  = 7'b1110000;
         acesos[8]  = 7'b1111111;  acesos[9]  = 7'b1111011;
         acesos[10] = 7'b0111101;  acesos[11] = 7'b0000110;
         acesos[12] = 7'b1001111;  acesos[13] = 7'b1011110;
         acesos[14] = 7'b0011101;  acesos[15] = 7'b0000001;
     end

     integer n, erros = 0;
     initial begin
         N = 0; L = 0;
         #200;
         for (n=0; n<256; n=n+1) begin
             {L, N} = n;
             #10;
             if (Seg !== ~acesos[N] || An !== ~L || DP !== 1'b1) begin
                 $display("ERRO: Numero=%h Liga=%b -> Seg=%b An=%b DP=%b", N, L, Seg, An, DP);
                 erros = erros + 1;
             end
         end
         if (erros == 0) $display("Simulacao OK: displayBCD sem erros (256 combinacoes)");
         else            $display("Simulacao FALHOU: displayBCD com %0d erros", erros);
         $finish;
     end
endmodule
