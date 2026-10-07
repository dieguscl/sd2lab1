`timescale 1ns / 1ps

// Testbench do divisor de clock.
// Verifica, para varios valores do parametro METADE, que ClockOut:
//   - tem periodo 2 x METADE ciclos de ClockIn (f_out = f_in / (2 x METADE));
//   - tem duty cycle de 50% (METADE ciclos a 1 e METADE ciclos a 0);
//   - so muda no flanco ascendente de ClockIn;
//   - mantem esse comportamento ao longo de muitos periodos.
// Inclui o valor usado na placa (METADE = 25000), simulando 12 periodos de saida (6 ms),
// e confirma que a frequencia real fica entre 1 kHz e 10 kHz.
module divisorclk_teste1();

//   Declaracao das entradas: relogio de 100 MHz (periodo de 10ns), como o da Basys3
     reg Clk = 0;
     always #5 Clk = ~Clk;

//   Declaracao das saidas
     wire Out1, Out2, Out5, Out7, OutPlaca;

//   Instanciacao das UUT com varios valores de METADE (o circuito e o mesmo)
     DivisorClock #(.METADE(1))  UUT1 (.ClockIn(Clk), .ClockOut(Out1));
     DivisorClock #(.METADE(2))  UUT2 (.ClockIn(Clk), .ClockOut(Out2));
     DivisorClock #(.METADE(5))  UUT5 (.ClockIn(Clk), .ClockOut(Out5));
     DivisorClock #(.METADE(7))  UUT7 (.ClockIn(Clk), .ClockOut(Out7));
     DivisorClock                UUTP (.ClockIn(Clk), .ClockOut(OutPlaca));   // valor por omissao

//   Instante do ultimo flanco ascendente de ClockIn
     time flanco_in = 0;
     always @(posedge Clk) flanco_in = $time;

     integer erros = 0;

//   Monitor generico de uma saida: mede tempo a 1, tempo a 0 e periodo
     task automatic monitoriza(input integer metade, input integer periodos_min, input [8*12:1] nome);
         time t_sobe, t_desce, t_sobe_ant, alto, baixo;
         integer p;
         begin
             p = 0;
             t_sobe_ant = 0;
             while (p < periodos_min + 1) begin
                 case (metade)
                     1: @(posedge Out1);  2: @(posedge Out2);  5: @(posedge Out5);
                     7: @(posedge Out7);  default: @(posedge OutPlaca);
                 endcase
                 t_sobe = $time;
                 if (t_sobe != flanco_in) begin
                     $display("ERRO %0s: ClockOut subiu fora do flanco de ClockIn (t=%0t)", nome, t_sobe);
                     erros = erros + 1;
                 end
                 if (p > 0) begin
                     alto  = t_desce - t_sobe_ant;
                     baixo = t_sobe - t_desce;
                     if (alto != metade*10 || baixo != metade*10) begin
                         $display("ERRO %0s: a 1 durante %0t ns e a 0 durante %0t ns (esperado %0d ns cada)",
                                  nome, alto, baixo, metade*10);
                         erros = erros + 1;
                     end
                 end
                 case (metade)
                     1: @(negedge Out1);  2: @(negedge Out2);  5: @(negedge Out5);
                     7: @(negedge Out7);  default: @(negedge OutPlaca);
                 endcase
                 t_desce = $time;
                 if (t_desce != flanco_in) begin
                     $display("ERRO %0s: ClockOut desceu fora do flanco de ClockIn (t=%0t)", nome, t_desce);
                     erros = erros + 1;
                 end
                 t_sobe_ant = t_sobe;
                 p = p + 1;
             end
         end
     endtask

     reg fim1 = 0, fim2 = 0, fim5 = 0, fim7 = 0, fimP = 0;
     initial begin monitoriza(1, 50, "METADE=1");  fim1 = 1; end
     initial begin monitoriza(2, 50, "METADE=2");  fim2 = 1; end
     initial begin monitoriza(5, 50, "METADE=5");  fim5 = 1; end
     initial begin monitoriza(7, 50, "METADE=7");  fim7 = 1; end
     initial begin monitoriza(25000, 12, "placa");  fimP = 1; end

     real freq;
     initial begin
         wait (fim1 && fim2 && fim5 && fim7 && fimP);
         freq = 100.0e6 / (2 * UUTP.METADE);
         $display("Frequencia de ClockOut na placa: %0.1f Hz", freq);
         if (freq < 1000.0 || freq > 10000.0) begin
             $display("ERRO: frequencia fora do intervalo 1 kHz a 10 kHz");
             erros = erros + 1;
         end
         if (erros == 0) $display("Simulacao OK: DivisorClock sem erros");
         else            $display("Simulacao FALHOU: DivisorClock com %0d erros", erros);
         $finish;
     end

//   Seguranca: termina se alguma saida nunca chegar a mudar
     initial begin
         #10_000_000;
         $display("Simulacao FALHOU: DivisorClock nao produziu os periodos esperados (fim1=%b fim2=%b fim5=%b fim7=%b placa=%b)",
                  fim1, fim2, fim5, fim7, fimP);
         $finish;
     end
endmodule
