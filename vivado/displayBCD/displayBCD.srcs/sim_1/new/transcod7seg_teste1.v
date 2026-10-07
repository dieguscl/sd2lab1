`timescale 1ns / 1ps

// Testbench do transcodificador para 7 segmentos: percorre os 16 valores de Numero
module transcod7seg_teste1();

//   Declaracao das entradas
     reg [3:0] N;

//   Declaracao da saida (a..g, ativos a Low)
     wire [6:0] S;

//   Instanciacao da UUT e ligacao das entradas e saidas
     Transcod7Seg UUT (
         .Numero(N),
         .Segmentos(S)
     );

//   Tabela de referencia, escrita com os segmentos ACESOS (ativo a High) para
//   ser facil de comparar com a Fig. 30; a saida esperada e a sua negacao.
     reg [6:0] acesos [0:15];
     initial begin           //  abcdefg
         acesos[0]  = 7'b1111110;  acesos[1]  = 7'b0110000;
         acesos[2]  = 7'b1101101;  acesos[3]  = 7'b1111001;
         acesos[4]  = 7'b0110011;  acesos[5]  = 7'b1011011;
         acesos[6]  = 7'b1011111;  acesos[7]  = 7'b1110000;
         acesos[8]  = 7'b1111111;  acesos[9]  = 7'b1111011;
         acesos[10] = 7'b0111101;  acesos[11] = 7'b0000110;  // d  I
         acesos[12] = 7'b1001111;  acesos[13] = 7'b1011110;  // E  G
         acesos[14] = 7'b0011101;  acesos[15] = 7'b0000001;  // o  -
     end

//   Declaracao de vars auxiliares
     integer n;
     integer erros = 0;

//   Definicao do valor das entradas ao longo do tempo
     initial begin
         N = 4'h0;
         #200;                    // Aguardar as configuracoes iniciais da FPGA
         for (n=0; n<16; n=n+1)
         begin
             N = n;
             #50;                 // Passam 50ns em cada valor
             if (S !== ~acesos[n]) begin
                 $display("ERRO: Numero=%0d Segmentos=%b (esperado %b)", n, S, ~acesos[n]);
                 erros = erros + 1;
             end
         end
         if (erros == 0) $display("Simulacao OK: Transcod7Seg sem erros");
         else            $display("Simulacao FALHOU: %0d erros", erros);
         $finish;
     end
endmodule
