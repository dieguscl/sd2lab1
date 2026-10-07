//`timescale 1ns / 1ps

////module descodificador2x4 (
////  input Bit1,
////  input Bit0,
////  input En0,
////  input En1,
////  input En2,
////  input En3,
////  output Out0,
////  output Out1,
////  output Out2,
////  output Out3
////);

//// Testbench do descodificador 2x4 com enables individuais nas saidas
//module descodificador2x4_teste1();

////   Declaracao das entradas
//     reg [1:0] B;          // Bit1, Bit0
//     reg [3:0] E;          // En3..En0

////   Declaracao das saidas
//     wire [3:0] O;         // Out3..Out0

////   Instanciacao da UUT e ligacao das entradas e saidas
//     descodificador2x4 UUT (
//         .Bit1(B[1]),
//         .Bit0(B[0]),
//         .En0(E[0]),
//         .En1(E[1]),
//         .En2(E[2]),
//         .En3(E[3]),
//         .Out0(O[0]),
//         .Out1(O[1]),
//         .Out2(O[2]),
//         .Out3(O[3])
//     );

////   Declaracao de vars auxiliares
//     integer n;            // Contador para o ciclo for
//     integer erros = 0;    // Numero de saidas diferentes do esperado

////   Verificacao automatica: so a saida B pode estar ativa, e so se En[B]=1
//     always @(B or E) begin
//         #1;
//         if (O !== ((4'b0001 << B) & E)) begin
//             $display("ERRO t=%0t: B=%b E=%b O=%b (esperado %b)", $time, B, E, O, (4'b0001 << B) & E);
//             erros = erros + 1;
//         end
//     end

////   Definicao do valor das entradas ao longo do tempo
//     initial begin
//         B = 2'b00;        // Valor inicial das vars de entrada
//         E = 4'b0000;      // Todas as saidas desativadas (O=0000)

//         #200;             // Aguardar 200ns para simular o tempo
//                           // das configuracoes iniciais da FPGA

//         for (n=0; n<16; n=n+1)
//         begin
//             #50;                           // Passam 50ns a cada ciclo de n
//             case (n)
//                  0: E = 4'b1111;           // Ativa todos os enables (O=0001)
//                  1: B = 2'b01;             // Descodifica 1 (O=0010)
//                  2: B = 2'b10;             // Descodifica 2 (O=0100)
//                  3: B = 2'b11;             // Descodifica 3 (O=1000)
//                  4: E = 4'b0111;           // Desativa En3: saida 3 apaga (O=0000)
//                  5: B = 2'b10;             // Descodifica 2 (O=0100)
//                  6: E = 4'b0011;           // Desativa En2 (O=0000)
//                  7: B = 2'b01;             // Descodifica 1 (O=0010)
//                  8: E = 4'b0001;           // Desativa En1 (O=0000)
//                  9: B = 2'b00;             // Descodifica 0 (O=0001)
//                 10: E = 4'b1110;           // So En0 desativado (O=0000)
//                 11: B = 2'b11;             // Descodifica 3 (O=1000)
//                 12: E = 4'b0100;           // So En2 ativo, mas B=3 (O=0000)
//                 13: B = 2'b10;             // Descodifica 2 (O=0100)
//                 14: E = 4'b1011;           // Todos menos En2, B=2 (O=0000)
//                 15: E = 4'b0000;           // Desativa tudo (O=0000)
//             endcase
//         end
//         #50;
//         if (erros == 0) $display("Simulacao OK: descodificador2x4 sem erros");
//         else            $display("Simulacao FALHOU: %0d erros", erros);
//         $finish;
//    end
//endmodule
