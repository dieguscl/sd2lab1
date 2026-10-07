`timescale 1ns / 1ps

// Multiplexer 16x4: 4 entradas de 4 bits, selecionadas por Sel[1:0].
// Construido estruturalmente com 4 multiplexers 4x1, um por cada bit.
module multiplexer16x4(
    input [3:0] DataIn0,
    input [3:0] DataIn1,
    input [3:0] DataIn2,
    input [3:0] DataIn3,
    output [3:0] DataOut,
    input [1:0] Sel
    );

//   Instanciacao do mux4x1 do bit 0 e ligacao das entradas e saidas
     multiplexer4x1 mux0 (
         .Sel1(Sel[1]),
         .Sel0(Sel[0]),
         .DataIn0(DataIn0[0]),
         .DataIn1(DataIn1[0]),
         .DataIn2(DataIn2[0]),
         .DataIn3(DataIn3[0]),
         .DataOut(DataOut[0])
     );

//   Instanciacao do mux4x1 do bit 1 e ligacao das entradas e saidas
     multiplexer4x1 mux1 (
         .Sel1(Sel[1]),
         .Sel0(Sel[0]),
         .DataIn0(DataIn0[1]),
         .DataIn1(DataIn1[1]),
         .DataIn2(DataIn2[1]),
         .DataIn3(DataIn3[1]),
         .DataOut(DataOut[1])
     );

//   Instanciacao do mux4x1 do bit 2 e ligacao das entradas e saidas
     multiplexer4x1 mux2 (
         .Sel1(Sel[1]),
         .Sel0(Sel[0]),
         .DataIn0(DataIn0[2]),
         .DataIn1(DataIn1[2]),
         .DataIn2(DataIn2[2]),
         .DataIn3(DataIn3[2]),
         .DataOut(DataOut[2])
     );

//   Instanciacao do mux4x1 do bit 3 e ligacao das entradas e saidas
     multiplexer4x1 mux3 (
         .Sel1(Sel[1]),
         .Sel0(Sel[0]),
         .DataIn0(DataIn0[3]),
         .DataIn1(DataIn1[3]),
         .DataIn2(DataIn2[3]),
         .DataIn3(DataIn3[3]),
         .DataOut(DataOut[3])
     );

endmodule
