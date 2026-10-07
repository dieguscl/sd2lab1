`timescale 1ns / 1ps

// Testbench do contador de modulo 4
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

//   Verificacao: depois de cada flanco ascendente o estado avanca 1 (modulo 4)
     reg [1:0] esperado = 2'b00;
     integer erros = 0, n;
     initial begin
         #1;
         for (n=0; n<12; n=n+1) begin       // 3 voltas completas: 0 1 2 3 0 1 2 3 ...
             if ({Q1, Q0} !== esperado) begin
                 $display("ERRO t=%0t: Q1Q0=%b%b (esperado %b)", $time, Q1, Q0, esperado);
                 erros = erros + 1;
             end
             @(posedge Clk); #1;
             esperado = esperado + 1;
         end
         if (erros == 0) $display("Simulacao OK: Contador4 sem erros");
         else            $display("Simulacao FALHOU: %0d erros", erros);
         $finish;
     end
endmodule
