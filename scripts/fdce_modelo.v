// Modelo simples da primitiva FDCE da Xilinx, so para simular com o Icarus Verilog
// (o Vivado usa a primitiva verdadeira da biblioteca UNISIM).
`timescale 1ns / 1ps
module FDCE #(parameter INIT=1'b0)(output reg Q=INIT, input C, CE, CLR, D);
  always @(posedge C or posedge CLR) if (CLR) Q <= 0; else if (CE) Q <= D;
endmodule
