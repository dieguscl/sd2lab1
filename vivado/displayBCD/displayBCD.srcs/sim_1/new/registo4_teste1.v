`timescale 1ns / 1ps

// Testbench do registo de 4 bits com clear e enable
module registo4_teste1();

//   Declaracao das entradas
     reg [3:0] D;
     reg CE, CLR;
     reg Clk = 0;

//   Declaracao da saida
     wire [3:0] Q;

//   Instanciacao da UUT e ligacao das entradas e saidas
     Registo4 UUT (
         .Data(D),
         .CE(CE),
         .Clk(Clk),
         .CLR(CLR),
         .DataOut(Q)
     );

//   Relogio de 100 MHz (periodo de 10ns), como o da Basys3
     always #5 Clk = ~Clk;

//   Declaracao de vars auxiliares
     integer erros = 0;
     task verifica(input [3:0] esperado);
         if (Q !== esperado) begin
             $display("ERRO t=%0t: Q=%h (esperado %h)", $time, Q, esperado);
             erros = erros + 1;
         end
     endtask

//   Definicao do valor das entradas ao longo do tempo
//   (as entradas mudam a meio do periodo, longe do flanco ascendente)
     initial begin
         D = 4'h0; CE = 0; CLR = 1;      // Clear ativo: Q=0
         #102;                            // Aguardar as configuracoes iniciais da FPGA
         CLR = 0;
         D = 4'h5;            #20 verifica(4'h0);   // CE=0: Q nao muda
         CE = 1;              #20 verifica(4'h5);   // CE=1: carrega 5 no flanco
         D = 4'hA;            #20 verifica(4'hA);   // carrega A
         CE = 0; D = 4'h3;    #20 verifica(4'hA);   // CE=0: mantem A
         CLR = 1;             #3  verifica(4'h0);   // Clear assincrono: Q=0 sem esperar pelo flanco
         CE = 1;              #17 verifica(4'h0);   // Clear tem prioridade sobre CE
         CLR = 0; D = 4'hF;   #20 verifica(4'hF);   // carrega F
         D = 4'h9;            #20 verifica(4'h9);   // carrega 9
         CE = 0;              #20 verifica(4'h9);
         if (erros == 0) $display("Simulacao OK: Registo4 sem erros");
         else            $display("Simulacao FALHOU: %0d erros", erros);
         $finish;
     end
endmodule
