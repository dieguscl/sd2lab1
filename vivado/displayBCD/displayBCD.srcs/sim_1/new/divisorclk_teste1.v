`timescale 1ns / 1ps

// Testbench do divisor de clock.
// Com METADE = 25000 seriam precisos 500 us de simulacao por cada periodo de saida,
// por isso a UUT e instanciada com METADE = 5 (100 MHz / 10 = 10 MHz).
// O circuito e o mesmo; muda so o valor do parametro.
module divisorclk_teste1();

//   Declaracao das entradas
     reg Clk = 0;

//   Declaracao da saida
     wire ClkOut;

//   Instanciacao da UUT e ligacao das entradas e saidas
     DivisorClock #(.METADE(5)) UUT (
         .ClockIn(Clk),
         .ClockOut(ClkOut)
     );

//   Relogio de 100 MHz (periodo de 10ns)
     always #5 Clk = ~Clk;

//   Mede o periodo de ClockOut entre flancos ascendentes
     time ultimo = 0;
     integer flancos = 0, erros = 0;
     always @(posedge ClkOut) begin
         if (flancos > 0 && ($time - ultimo) != 100) begin
             $display("ERRO t=%0t: periodo de ClockOut = %0t ns (esperado 100 ns)", $time, $time - ultimo);
             erros = erros + 1;
         end
         ultimo = $time;
         flancos = flancos + 1;
     end

     initial begin
         #1000;                   // 10 periodos de ClockOut
         if (erros == 0 && flancos >= 9) $display("Simulacao OK: DivisorClock sem erros (%0d periodos)", flancos);
         else                            $display("Simulacao FALHOU: %0d erros, %0d flancos", erros, flancos);
         $finish;
     end
endmodule
