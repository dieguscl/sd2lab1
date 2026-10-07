`timescale 1ns / 1ps

// Testbench do registo de 4 bits com clear e enable.
// Parte 1: casos dirigidos (CE, clear assincrono, prioridade do clear, 16 valores).
// Parte 2: 2000 ciclos com entradas aleatorias comparados com um modelo de referencia,
//          com CLR a mudar em instantes que nao coincidem com o relogio.
module registo4_teste1();

//   Declaracao das entradas
     reg [3:0] D = 4'h0;
     reg CE = 0, CLR = 0;
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

//   Modelo de referencia: o comportamento esperado do registo
     reg [3:0] referencia = 4'h0;
     always @(posedge Clk or posedge CLR)
         if (CLR)      referencia <= 4'h0;
         else if (CE)  referencia <= D;

//   Verificacao continua: a saida tem de ser sempre igual a referencia
//   (comparada 1ns depois de qualquer mudanca, para dar tempo a UUT)
     integer erros = 0, verificacoes = 0;
     always @(Q or referencia) begin
         #1;
         verificacoes = verificacoes + 1;
         if (Q !== referencia) begin
             if (erros < 10) $display("ERRO t=%0t: Q=%h (esperado %h) D=%h CE=%b CLR=%b", $time, Q, referencia, D, CE, CLR);
             erros = erros + 1;
         end
     end

//   Verificacao direta num instante (para os casos dirigidos)
     task verifica(input [3:0] esperado, input [8*40:1] caso);
         begin
             verificacoes = verificacoes + 1;
             if (Q !== esperado) begin
                 $display("ERRO t=%0t (%0s): Q=%h (esperado %h)", $time, caso, Q, esperado);
                 erros = erros + 1;
             end
         end
     endtask

//   A saida so pode mudar num flanco ascendente do relogio ou com CLR ativo
     time ultimo_flanco = -1;
     always @(posedge Clk) ultimo_flanco = $time;
     always @(Q)
         if ($time > 0 && $time != ultimo_flanco && CLR !== 1'b1) begin
             $display("ERRO t=%0t: Q mudou para %h fora do flanco do relogio e sem CLR", $time, Q);
             erros = erros + 1;
         end

     integer n, v;
     integer semente = 2026;        // semente fixa: resultado repetivel
     initial begin
         // --- Parte 1: casos dirigidos -------------------------------------------
         #1   verifica(4'h0, "valor inicial apos configuracao (INIT=0)");
         #100;                                            // configuracoes iniciais da FPGA
         // As entradas mudam a meio do periodo (relogio sobe em 5, 15, 25, ...)
         D = 4'h5; CE = 0;  #10 verifica(4'h0, "CE=0 nao carrega");
         CE = 1;            #10 verifica(4'h5, "CE=1 carrega no flanco");
         D = 4'hA;          #3  verifica(4'h5, "entre flancos a saida mantem-se");
                            #7  verifica(4'hA, "carrega A");
         CE = 0; D = 4'h3;  #50 verifica(4'hA, "CE=0 mantem durante 5 ciclos");
         #2 CLR = 1;        #1  verifica(4'h0, "CLR assincrono (sem flanco)");
         CE = 1; D = 4'hF;  #20 verifica(4'h0, "CLR tem prioridade sobre CE");
         CLR = 0;           #0.5 verifica(4'h0, "apos CLR so carrega no flanco seguinte");
                            #6.5 verifica(4'hF, "carrega F apos libertar CLR");
         // Os 16 valores possiveis, carregados um a um (cada bit em 0 e em 1)
         for (v = 0; v < 16; v = v + 1) begin
             D = v; #10 verifica(v, "carregamento dos 16 valores");
         end
         // Bits independentes: 1 a andar e 0 a andar
         for (v = 0; v < 4; v = v + 1) begin
             D = 4'b0001 << v;     #10 verifica(4'b0001 << v, "um bit a 1");
             D = ~(4'b0001 << v);  #10 verifica(~(4'b0001 << v), "um bit a 0");
         end

         // --- Parte 2: entradas aleatorias contra o modelo de referencia ----------
         for (n = 0; n < 2000; n = n + 1) begin
             // instante aleatorio entre 0 e 3ns depois do flanco descendente,
             // nunca em cima do flanco ascendente (evita corridas no testbench)
             @(negedge Clk); verifica(referencia, "ciclo aleatorio");
             #({$random(semente)} % 4);
             D   = $random(semente);
             CE  = $random(semente);
             CLR = ({$random(semente)} % 8 == 0);                  // clear em ~1/8 das vezes
         end
         #2 CLR = 0; #20;                                // sem impulsos de largura nula no CLR

         if (erros == 0) $display("Simulacao OK: Registo4 sem erros (%0d verificacoes)", verificacoes);
         else            $display("Simulacao FALHOU: Registo4 com %0d erros", erros);
         $finish;
     end
endmodule
