`timescale 1ns / 1ps

// Registo de 4 bits com clear assincrono e clock enable.
// Feito com 4 primitivas FDCE (flip-flop D com CLR assincrono e CE),
// sensiveis ao flanco ascendente do relogio.
module Registo4(
    input [3:0] Data,
    input CE,
    input Clk,
    input CLR,
    output [3:0] DataOut
    );

//   Instanciacao dos 4 flip-flops FDCE, um por cada bit
     FDCE #(.INIT(1'b0)) ff0 (.Q(DataOut[0]), .C(Clk), .CE(CE), .CLR(CLR), .D(Data[0]));
     FDCE #(.INIT(1'b0)) ff1 (.Q(DataOut[1]), .C(Clk), .CE(CE), .CLR(CLR), .D(Data[1]));
     FDCE #(.INIT(1'b0)) ff2 (.Q(DataOut[2]), .C(Clk), .CE(CE), .CLR(CLR), .D(Data[2]));
     FDCE #(.INIT(1'b0)) ff3 (.Q(DataOut[3]), .C(Clk), .CE(CE), .CLR(CLR), .D(Data[3]));

endmodule
