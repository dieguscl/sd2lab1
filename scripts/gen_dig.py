#!/usr/bin/env python3
"""Gera os esquemas Digital (.dig) do multiplexer 4x1 e do descodificador 2x4.

Layout: entradas a esquerda, cada sinal desce num barramento vertical,
portas logicas ligam-se aos barramentos por fios horizontais.
"""
import itertools, sys
from xml.sax.saxutils import escape

G = 20  # grelha do Digital
INV_OFF = G  # a bolinha de negacao desloca o pino uma posicao para a esquerda


def gate_inputs(n):
    """Offsets y dos pinos de entrada de uma porta com n entradas (forma simetrica)."""
    ys = [i * G for i in range(n)]
    if n % 2 == 0:  # nas portas com n par o Digital deixa um espaco no meio
        ys = [y if i < n // 2 else y + G for i, y in enumerate(ys)]
    return ys


def gate_output(n):
    return 3 * G, (n // 2) * G


class Circuit:
    def __init__(self):
        self.elems, self.wires = [], []

    def el(self, name, x, y, attrs=None):
        a = ""
        for k, v in (attrs or {}).items():
            if k == "inverterConfig":
                inner = "".join(f"<string>{s}</string>" for s in v)
                a += f"<entry><string>inverterConfig</string><inverterConfig>{inner}</inverterConfig></entry>"
            elif isinstance(v, int):
                a += f"<entry><string>{k}</string><int>{v}</int></entry>"
            elif k == "Testdata":
                a += f"<entry><string>Testdata</string><testData><dataString>{escape(v)}</dataString></testData></entry>"
            else:
                a += f"<entry><string>{k}</string><string>{escape(v)}</string></entry>"
        self.elems.append(f"<visualElement><elementName>{name}</elementName>"
                          f"<elementAttributes>{a}</elementAttributes><pos x=\"{x}\" y=\"{y}\"/></visualElement>")

    def w(self, x1, y1, x2, y2):
        if (x1, y1) != (x2, y2):
            self.wires.append(f"<wire><p1 x=\"{x1}\" y=\"{y1}\"/><p2 x=\"{x2}\" y=\"{y2}\"/></wire>")

    def xml(self):
        return ('<?xml version="1.0" encoding="utf-8"?>\n<circuit>\n  <version>2</version>\n  <attributes/>\n'
                "  <visualElements>\n    " + "\n    ".join(self.elems) + "\n  </visualElements>\n"
                "  <wires>\n    " + "\n    ".join(self.wires) + "\n  </wires>\n  <measurementOrdering/>\n</circuit>\n")


def build(inputs, gates, outputs, test, gate_dy=120):
    """inputs: nomes; gates: lista de (tipo, [(sinal, invertido)], nome_saida);
    outputs: {nome_saida_circuito: ligacao}, onde ligacao e o nome de uma porta."""
    c = Circuit()
    top, x_in = 40, 100
    bus_x = {s: 200 + 40 * k for k, s in enumerate(inputs)}
    taps = {}
    gx = max(bus_x.values()) + 120
    for k, s in enumerate(inputs):
        y = top + 40 * k
        c.el("In", x_in, y, {"Label": s})
        c.w(x_in, y, bus_x[s], y)
        taps[s] = [y]
    gy = top + 40 * len(inputs) + 40
    gate_out = {}
    for name, (typ, ins, out) in enumerate(gates):
        n = len(ins)
        inv = [f"In_{i+1}" for i, (_, neg) in enumerate(ins) if neg]
        attrs = {"Inputs": n} if n != 2 else {}
        if inv:
            attrs["inverterConfig"] = inv
        c.el(typ, gx, gy, attrs)
        for (s, neg), dy in zip(ins, gate_inputs(n)):
            c.w(bus_x[s], gy + dy, gx - (INV_OFF if neg else 0), gy + dy)
            taps[s].append(gy + dy)
        ox, oy = gate_output(n)
        gate_out[out] = (gx + ox, gy + oy)
        gy += gate_dy
    # barramentos partidos em segmentos em cada derivacao (o Digital so liga fios pelas pontas)
    for s, ys in taps.items():
        ys = sorted(set(ys))
        for y1, y2 in zip(ys, ys[1:]):
            c.w(bus_x[s], y1, bus_x[s], y2)
    return c, gate_out, gx


def add_test(c, test, x, y):
    c.el("Testcase", x, y, {"Label": "teste", "Testdata": test})


def truth(inputs, outputs, f):
    lines = [" ".join(inputs + outputs)]
    for vals in itertools.product([0, 1], repeat=len(inputs)):
        env = dict(zip(inputs, vals))
        lines.append(" ".join(map(str, list(vals) + f(env))))
    return "\n".join(lines) + "\n"


def mux4x1():
    ins = ["Sel1", "Sel0", "DataIn0", "DataIn1", "DataIn2", "DataIn3"]
    gates = [("And", [("Sel1", s1 == 0), ("Sel0", s0 == 0), (f"DataIn{i}", False)], f"a{i}")
             for i, (s1, s0) in enumerate([(0, 0), (0, 1), (1, 0), (1, 1)])]
    c, go, gx = build(ins, gates, None, None)
    # OR de 4 entradas
    ys = gate_inputs(4)
    orx = gx + 260
    ory = go["a1"][1] + 20
    c.el("Or", orx, ory, {"Inputs": 4})
    for i in range(4):
        ax, ay = go[f"a{i}"]
        xm = ax + 40 + 20 * i
        c.w(ax, ay, xm, ay)
        c.w(xm, ay, xm, ory + ys[i])
        c.w(xm, ory + ys[i], orx, ory + ys[i])
    ox, oy = gate_output(4)
    c.el("Out", orx + ox + 60, ory + oy, {"Label": "DataOut"})
    c.w(orx + ox, ory + oy, orx + ox + 60, ory + oy)
    f = lambda e: [e[f"DataIn{2*e['Sel1'] + e['Sel0']}"]]
    add_test(c, truth(ins, ["DataOut"], f), orx, ory + 200)
    return c


def descodificador2x4():
    ins = ["Bit1", "Bit0", "En0", "En1", "En2", "En3"]
    gates = [("And", [("Bit1", b1 == 0), ("Bit0", b0 == 0), (f"En{i}", False)], f"Out{i}")
             for i, (b1, b0) in enumerate([(0, 0), (0, 1), (1, 0), (1, 1)])]
    c, go, gx = build(ins, gates, None, None)
    for i in range(4):
        ax, ay = go[f"Out{i}"]
        c.el("Out", ax + 80, ay, {"Label": f"Out{i}"})
        c.w(ax, ay, ax + 80, ay)
    outs = [f"Out{i}" for i in range(4)]
    f = lambda e: [int(e[f"En{i}"] and (2 * e["Bit1"] + e["Bit0"]) == i) for i in range(4)]
    add_test(c, truth(ins, outs, f), gx + 200, go["Out3"][1] + 100)
    return c


if __name__ == "__main__":
    out = sys.argv[1]
    for name, fn in [("multiplexer4x1", mux4x1), ("descodificador2x4", descodificador2x4)]:
        with open(f"{out}/{name}.dig", "w") as fh:
            fh.write(fn().xml())
