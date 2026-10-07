`timescale 1ns / 1ps


//module descodificador2x4 (
//  input Bit1,
//  input Bit0,
//  input En0,
//  input En1,
//  input En2,
//  input En3,
//  output Out0,
//  output Out1,
//  output Out2,
//  output Out3
//);

module descodificador2x4_teste1();

//   Declaracao das entradas
     reg [1:0] B;
     reg [3:0] E;
     wire [3:0] Z;

//   Instanciacao da UUT e ligacao das entradas e saidas
     descodificador2x4 UUT (
         .Bit1(B[1]),
         .Bit0(B[0]),
         .En0(E[0]),
         .En1(E[1]),
         .En2(E[2]),
         .En3(E[3]),
         .Out0(Z[0]),
         .Out1(Z[1]),
         .Out2(Z[2]),
         .Out3(Z[3])
     );

//   Declaracao de vars auxiliares
     integer n;            // Contador para o ciclo for
     integer erros = 0;    // Numero de saidas diferentes do esperado

////   Verificacao automatica: a saida deve ser sempre igual a entrada selecionada
//     always @(S or D) begin
//         #1;
//         if (Z !== D[S]) begin
//             $display("ERRO t=%0t: S=%b D=%b Z=%b (esperado %b)", $time, S, D, Z, D[S]);
//             erros = erros + 1;
//         end
//     end

//   Definicao do valor das entradas ao longo do tempo
//   Para cada selecao: liga so a entrada selecionada (Z=1), depois liga todas
//   as outras exceto a selecionada (Z=0), mostrando que so a selecionada passa.
     initial begin
         B = 2'b00;        // Valor inicial das vars de selecao
         E = 4'b0000;      // Valor inicial das vars de entrada (Z=0)

         #200;             // Aguardar 200ns para simular o tempo
                           // das configuracoes iniciais da FPGA

         for (n=0; n<16; n=n+1)
         begin
             #50;                           // Passam 50ns a cada ciclo de n
             case (n)
                  0: E = 4'b0001;           // Enable saída 1
                  1: B = 4'b01;           // Ativar saída 2
                  2: E = 2'b0010;             // Ativar saída 2, desativar saída 1
                  3: B = 4'b10;           // Ativar saída 3
                  4: E = 4'b0110;           // Ativar saída 3
//                  5: B = 2'b10;             // Seleciona a entrada 2 (Z=1)
//                  6: E = 4'b0100;           // So a entrada 2 a 1 (Z=1)
//                  7: E = 4'b1011;           // Todas a 1 menos a 2 (Z=0)
//                  8: B = 2'b11;             // Seleciona a entrada 3 (Z=1)
//                  9: E = 4'b1000;           // So a entrada 3 a 1 (Z=1)
//                 10: E = 4'b0111;           // Todas a 1 menos a 3 (Z=0)
//                 11: E = 4'b1111;           // Todas a 1 (Z=1)
//                 12: B = 2'b10;             // Seleciona a entrada 2 (Z=1)
//                 13: B = 2'b01;             // Seleciona a entrada 1 (Z=1)
//                 14: B = 2'b00;             // Seleciona a entrada 0 (Z=1)
//                 15: E = 4'b0000;           // Todas a 0 (Z=0)
             endcase
         end
         #50;
         if (erros == 0) $display("Simulacao OK: descodificador2x4 sem erros");
         else            $display("Simulacao FALHOU: %0d erros", erros);
         $finish;
    end
endmodule
