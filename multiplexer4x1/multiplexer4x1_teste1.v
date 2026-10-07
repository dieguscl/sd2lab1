`timescale 1ns / 1ps

// Testbench do multiplexer 4x1 (sequencia personalizada)
module multiplexer4x1_teste1();

//   Declaracao das entradas
     reg [1:0] S;
     reg [3:0] D;

//   Declaracao da saida
     wire Z;

//   Instanciacao da UUT e ligacao das entradas e saidas
     multiplexer4x1 UUT (
         .Sel1(S[1]),
         .Sel0(S[0]),
         .DataIn0(D[0]),
         .DataIn1(D[1]),
         .DataIn2(D[2]),
         .DataIn3(D[3]),
         .DataOut(Z)
     );

//   Declaracao de vars auxiliares
     integer n;            // Contador para o ciclo for
     integer erros = 0;    // Numero de saidas diferentes do esperado

//   Verificacao automatica: a saida deve ser sempre igual a entrada selecionada
     always @(S or D) begin
         #1;
         if (Z !== D[S]) begin
             $display("ERRO t=%0t: S=%b D=%b Z=%b (esperado %b)", $time, S, D, Z, D[S]);
             erros = erros + 1;
         end
     end

//   Definicao do valor das entradas ao longo do tempo
//   Para cada selecao: liga so a entrada selecionada (Z=1), depois liga todas
//   as outras exceto a selecionada (Z=0), mostrando que so a selecionada passa.
     initial begin
         S = 2'b00;        // Valor inicial das vars de selecao
         D = 4'b0000;      // Valor inicial das vars de entrada (Z=0)

         #200;             // Aguardar 200ns para simular o tempo
                           // das configuracoes iniciais da FPGA

         for (n=0; n<16; n=n+1)
         begin
             #50;                           // Passam 50ns a cada ciclo de n
             case (n)
                  0: D = 4'b0001;           // Entrada 0 a 1, selecionada a 0 (Z=1)
                  1: D = 4'b1110;           // Todas a 1 menos a 0 (Z=0)
                  2: S = 2'b01;             // Seleciona a entrada 1 (Z=1)
                  3: D = 4'b0010;           // So a entrada 1 a 1 (Z=1)
                  4: D = 4'b1101;           // Todas a 1 menos a 1 (Z=0)
                  5: S = 2'b10;             // Seleciona a entrada 2 (Z=1)
                  6: D = 4'b0100;           // So a entrada 2 a 1 (Z=1)
                  7: D = 4'b1011;           // Todas a 1 menos a 2 (Z=0)
                  8: S = 2'b11;             // Seleciona a entrada 3 (Z=1)
                  9: D = 4'b1000;           // So a entrada 3 a 1 (Z=1)
                 10: D = 4'b0111;           // Todas a 1 menos a 3 (Z=0)
                 11: D = 4'b1111;           // Todas a 1 (Z=1)
                 12: S = 2'b10;             // Seleciona a entrada 2 (Z=1)
                 13: S = 2'b01;             // Seleciona a entrada 1 (Z=1)
                 14: S = 2'b00;             // Seleciona a entrada 0 (Z=1)
                 15: D = 4'b0000;           // Todas a 0 (Z=0)
             endcase
         end
         #50;
         if (erros == 0) $display("Simulacao OK: multiplexer4x1 sem erros");
         else            $display("Simulacao FALHOU: %0d erros", erros);
         $finish;
    end
endmodule
