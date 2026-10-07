`timescale 1ns / 1ps

// Testbench do multiplexer 16x4
module multiplexer16x4_teste1();

//   Declaracao das entradas
     reg [1:0] S;
     reg [3:0] D0, D1, D2, D3;

//   Declaracao da saida
     wire [3:0] Z;

//   Instanciacao da UUT e ligacao das entradas e saidas
     multiplexer16x4 UUT (
         .DataIn0(D0),
         .DataIn1(D1),
         .DataIn2(D2),
         .DataIn3(D3),
         .DataOut(Z),
         .Sel(S)
     );

//   Declaracao de vars auxiliares
     integer n;            // Contador para o ciclo for
     integer erros = 0;    // Numero de saidas diferentes do esperado
     reg [3:0] esperado;

//   Verificacao automatica: a saida deve ser sempre igual a entrada selecionada
     always @(S or D0 or D1 or D2 or D3) begin
         #1;
         case (S)
             2'd0: esperado = D0;
             2'd1: esperado = D1;
             2'd2: esperado = D2;
             2'd3: esperado = D3;
         endcase
         if (Z !== esperado) begin
             $display("ERRO t=%0t: S=%d Z=%h (esperado %h)", $time, S, Z, esperado);
             erros = erros + 1;
         end
     end

//   Definicao do valor das entradas ao longo do tempo
     initial begin
         S  = 2'b00;       // Valor inicial das vars de selecao
         D0 = 4'h0;        // Valor inicial das vars de entrada
         D1 = 4'h0;
         D2 = 4'h0;
         D3 = 4'h0;

         #200;             // Aguardar 200ns para simular o tempo
                           // das configuracoes iniciais da FPGA

         for (n=0; n<14; n=n+1)
         begin
             #50;                           // Passam 50ns a cada ciclo de n
             case (n)
                  0: begin                  // Valores distintos nas 4 entradas
                         D0 = 4'hA;         // (Z=A)
                         D1 = 4'h5;
                         D2 = 4'hC;
                         D3 = 4'h3;
                     end
                  1: S = 2'b01;             // Seleciona DataIn1 (Z=5)
                  2: S = 2'b10;             // Seleciona DataIn2 (Z=C)
                  3: S = 2'b11;             // Seleciona DataIn3 (Z=3)
                  4: D0 = 4'hF;             // Muda entrada nao selecionada (Z=3)
                  5: D3 = 4'h9;             // Muda entrada selecionada (Z=9)
                  6: S = 2'b00;             // Seleciona DataIn0 (Z=F)
                  7: D0 = 4'h1;             // Testa cada bit isolado (Z=1)
                  8: D0 = 4'h2;             // (Z=2)
                  9: D0 = 4'h4;             // (Z=4)
                 10: D0 = 4'h8;             // (Z=8)
                 11: S = 2'b10;             // Seleciona DataIn2 (Z=C)
                 12: D2 = 4'h0;             // (Z=0)
                 13: S = 2'b01;             // Seleciona DataIn1 (Z=5)
             endcase
         end
         #50;
         if (erros == 0) $display("Simulacao OK: multiplexer16x4 sem erros");
         else            $display("Simulacao FALHOU: %0d erros", erros);
         $finish;
    end
endmodule
