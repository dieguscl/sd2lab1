#!/usr/bin/env python3
"""Teste de mutacoes dos testbenches da aula 2 (precisa do Icarus Verilog).

Introduz erros tipicos numa copia de cada modulo e confirma que o testbench
respetivo deteta todos: se um testbench deixasse passar um modulo errado, nao
serviria para certificar o modulo certo.
Uso (na raiz do repositorio): python3 scripts/teste_mutacoes.py
"""
import subprocess, os, tempfile
raiz = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(os.path.join(raiz, 'vivado/displayBCD/displayBCD.srcs'))
S = tempfile.mkdtemp()
os.makedirs(f'{S}/mut')
src = 'sources_1/new'
stub = os.path.join(raiz, 'scripts/fdce_modelo.v')   # modelo da primitiva FDCE para o Icarus
# Registo4 em comportamental equivalente, para poder introduzir erros de comportamento
reg_beh = '''`timescale 1ns / 1ps
module Registo4(input [3:0] Data, input CE, input Clk, input CLR, output reg [3:0] DataOut = 0);
  always @(%s) if (%s) DataOut <= 0; else if (%s) DataOut <= %s;
endmodule
'''
muts = [
 ('registo4', 'registo4.v', 'CE ignorado',          reg_beh % ('posedge Clk or posedge CLR','CLR','1','Data')),
 ('registo4', 'registo4.v', 'clear sincrono',       reg_beh % ('posedge Clk','CLR','CE','Data')),
 ('registo4', 'registo4.v', 'CLR ignorado',         reg_beh % ('posedge Clk','0','CE','Data')),
 ('registo4', 'registo4.v', 'flanco descendente',   reg_beh % ('negedge Clk or posedge CLR','CLR','CE','Data')),
 ('registo4', 'registo4.v', 'bits 0 e 1 trocados',  reg_beh % ('posedge Clk or posedge CLR','CLR','CE','{Data[3:2],Data[0],Data[1]}')),
 ('registo4', 'registo4.v', 'bit 3 preso a 0',      reg_beh % ('posedge Clk or posedge CLR','CLR','CE','{1\'b0,Data[2:0]}')),
 ('transcod7seg', 'transcod7seg.v', '7 com segmento f',  ("4'd7:  Segmentos = 7'b0001111", "4'd7:  Segmentos = 7'b0001101")),
 ('transcod7seg', 'transcod7seg.v', 'ativo a High',      ("always @(*)", "wire [6:0] x; always @(*)")),
 ('transcod7seg', 'transcod7seg.v', 'G igual a 6',       ("4'd13: Segmentos = 7'b0100001", "4'd13: Segmentos = 7'b0100000")),
 ('transcod7seg', 'transcod7seg.v', 'valor 15 em falta', ("4'd15: Segmentos = 7'b1111110;", "")),
 ('divisorclk', 'divisorCLK.v', 'conta METADE+1',    ("contagem == METADE - 1", "contagem == METADE")),
 ('divisorclk', 'divisorCLK.v', 'flanco descendente',("posedge ClockIn", "negedge ClockIn")),
 ('divisorclk', 'divisorCLK.v', 'METADE por omissao 250', ("parameter METADE = 25000", "parameter METADE = 250")),
 ('contador4', 'contador4.v', 'conta a descer',     ("estado <= estado + 1", "estado <= estado - 1")),
 ('contador4', 'contador4.v', 'modulo 3',           ("estado <= estado + 1", "estado <= (estado == 2) ? 0 : estado + 1")),
 ('contador4', 'contador4.v', 'flanco descendente', ("posedge Clock", "negedge Clock")),
 ('contador4', 'contador4.v', 'Q1 e Q0 trocados',   ("assign Q1 = estado[1];", "assign Q1 = estado[0]; //")),
 ('displaybcd', 'displayBCD.v', 'anodos nao negados', ("assign Anodos = ~Liga;", "assign Anodos = Liga;")),
 ('displaybcd', 'displayBCD.v', 'ponto aceso',        ("assign DotPoint = 1'b1;", "assign DotPoint = 1'b0;")),
]
apanhados = 0
for tb, f, nome, m in muts:
    files = {x: open(f'{src}/{x}').read() for x in os.listdir(src)}
    if isinstance(m, tuple):
        if nome == 'ativo a High':
            files[f] = files[f].replace("output reg [6:0] Segmentos", "output [6:0] Segmentos").replace("always @(*)", "reg [6:0] s; assign Segmentos = ~s; always @(*)").replace("Segmentos = 7'", "s = 7'")
        else:
            assert m[0] in files[f], (nome, m[0]); files[f] = files[f].replace(m[0], m[1])
    else:
        files[f] = m
    paths = []
    for x, c in files.items():
        p = f'{S}/mut/{x}'; open(p, 'w').write(c); paths.append(p)
    if not isinstance(m, str): paths.append(stub)
    vvp = f'{S}/mut/t.vvp'
    r = subprocess.run(['iverilog', '-g2012', '-o', vvp, *paths, f'sim_1/new/{tb}_teste1.v', '-s', f'{tb}_teste1'], capture_output=True, text=True)
    if r.returncode: print('COMPILACAO FALHOU', nome, r.stderr[:300]); continue
    out = subprocess.run(['vvp', vvp], capture_output=True, text=True, timeout=600).stdout
    ok = 'Simulacao OK' in out
    apanhados += not ok
    print(f"{'NAO DETETADO' if ok else 'detetado    '}  {tb:13s} {nome}")
print(f'{apanhados}/{len(muts)} erros detetados')
