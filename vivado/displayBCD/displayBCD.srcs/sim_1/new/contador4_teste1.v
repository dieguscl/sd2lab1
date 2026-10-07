`timescale 1ns / 1ps

// Testbench do contador de modulo 4.
// Verifica:
//   - o estado inicial (0 apos a configuracao da FPGA);
//   - a sequencia 0, 1, 2, 3, 0, ... durante 100 flancos (25 voltas);
//   - que as saidas so mudam no flanco ascendente (nunca no descendente nem entre flancos);
//   - que muda exatamente uma vez por ciclo de relogio.
module contador4_teste1();

//   Declaracao das entradas
     reg Clk = 0;

//   Declaracao das saidas
     wire Q1, Q0;

//   Instanciacao da UUT e ligacao das entradas e saidas
     Contador4 UUT (
         .Clock(Clk),
         .Q1(Q1),
         .Q0(Q0)
     );

//   Relogio com periodo de 20ns
     always #10 Clk = ~Clk;

//   As saidas so podem mudar no instante de um flanco ascendente
     time flanco = -1;
     integer erros = 0, mudancas = 0;
     always @(posedge Clk) flanco = $time;
     always @(Q1 or Q0)
         if ($time > 0) begin
             mudancas = mudancas + 1;
             if ($time != flanco) begin
                 $display("ERRO t=%0t: Q1Q0 mudou para %b%b fora do flanco ascendente", $time, Q1, Q0);
                 erros = erros + 1;
             end
         end

//   Verificacao do estado depois de cada flanco ascendente
     reg [1:0] esperado = 2'b00;
     integer n;
     initial begin
         #1;
         if ({Q1, Q0} !== 2'b00) begin
             $display("ERRO: estado inicial %b%b (esperado 00)", Q1, Q0);
             erros = erros + 1;
         end
         for (n=0; n<100; n=n+1) begin
             @(posedge Clk); #1;
             esperado = esperado + 1;           // modulo 4: 3 + 1 = 0 em 2 bits
             if ({Q1, Q0} !== esperado) begin
                 $display("ERRO t=%0t: Q1Q0=%b%b (esperado %b)", $time, Q1, Q0, esperado);
                 erros = erros + 1;
             end
             @(negedge Clk); #1;                // a meio do ciclo continua igual
             if ({Q1, Q0} !== esperado) begin
                 $display("ERRO t=%0t: Q1Q0 mudou no flanco descendente", $time);
                 erros = erros + 1;
             end
         end
         // Em 100 ciclos: Q0 muda 100 vezes e Q1 50 vezes; o bloco always conta
         // eventos de mudanca de {Q1,Q0}, que sao 100 (um por ciclo)
         if (mudancas != 100) begin
             $display("ERRO: %0d mudancas em 100 ciclos (esperado 100)", mudancas);
             erros = erros + 1;
         end
         if (erros == 0) $display("Simulacao OK: Contador4 sem erros (100 ciclos)");
         else            $display("Simulacao FALHOU: Contador4 com %0d erros", erros);
         $finish;
     end
endmodule
