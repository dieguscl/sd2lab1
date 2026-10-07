`timescale 1ns / 1ps

// Divisor de clock: gera ClockOut a partir do relogio de 100 MHz da Basys3.
// ClockOut inverte a cada METADE ciclos de ClockIn, logo
// f_out = f_in / (2 * METADE) = 100 MHz / 50000 = 2 kHz (entre 1 e 10 kHz).
// Para debug visual (displays a piscar) usar, por exemplo, METADE = 25_000_000 (2 Hz).
module DivisorClock #(
    parameter METADE = 25000
    )(
    input ClockIn,
    output reg ClockOut = 1'b0
    );

     reg [31:0] contagem = 0;

     always @(posedge ClockIn)
         if (contagem == METADE - 1) begin
             contagem <= 0;
             ClockOut <= ~ClockOut;
         end
         else
             contagem <= contagem + 1;

endmodule
