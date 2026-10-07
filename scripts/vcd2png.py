#!/usr/bin/env python3
"""Desenha as formas de onda de um ficheiro VCD (gerado pelo xsim) em PNG.

Uso: vcd2png.py <ficheiro.vcd> <saida.png> <sinal> [<sinal> ...]
Os sinais sao identificados pelo nome no testbench (ex.: S D Z). Barramentos
aparecem em hexadecimal; sinais de 1 bit como forma de onda digital.
"""
import sys
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt


def parse_vcd(path):
    ids, widths, changes, scope, t = {}, {}, {}, [], 0
    tscale = "1ns"
    with open(path) as fh:
        tokens = fh.read().split()
    i = 0
    while i < len(tokens):
        tok = tokens[i]
        if tok == "$timescale":
            j = tokens.index("$end", i)
            tscale = "".join(tokens[i + 1:j]); i = j
        elif tok == "$scope":
            scope.append(tokens[i + 2]); i += 3
        elif tok == "$upscope":
            scope.pop(); i += 1
        elif tok == "$var":
            width, code, name = int(tokens[i + 2]), tokens[i + 3], tokens[i + 4]
            if len(scope) == 1:  # so os sinais do topo do testbench
                ids.setdefault(code, name)
                widths[name] = width
                changes.setdefault(name, [])
            i = tokens.index("$end", i)
        elif tok.startswith("#"):
            t = int(tok[1:])
        elif tok[0] in "01xzXZ" and len(tok) > 1 and tok[1:] in ids:
            changes[ids[tok[1:]]].append((t, tok[0]))
        elif tok[0] in "bB":
            code = tokens[i + 1]
            if code in ids:
                changes[ids[code]].append((t, tok[1:]))
            i += 1
        i += 1
    return changes, widths, t, tscale


def scale_to_ns(ts):
    num = int("".join(c for c in ts if c.isdigit()))
    unit = ts.lstrip("0123456789")
    return num * {"s": 1e9, "ms": 1e6, "us": 1e3, "ns": 1, "ps": 1e-3, "fs": 1e-6}[unit]


def bit_changes(ch, b):
    """Extrai o bit b das mudancas de um barramento."""
    out, prev = [], None
    for t, v in ch:
        v = v.rjust(b + 1, "0")[-(b + 1)]
        if v != prev:
            out.append((t, v)); prev = v
    return out


def main():
    vcd, png, sigs = sys.argv[1], sys.argv[2], sys.argv[3:]
    changes, widths, tend, ts = parse_vcd(vcd)
    k = scale_to_ns(ts)
    tend = tend * k + 50  # o xsim nao regista o instante do $finish; mostra mais 50ns
    # cada barramento aparece como linha de valores seguida dos seus bits (como no Vivado)
    rows = []
    for s in sigs:
        rows.append((f"{s}[{widths[s]-1}:0]" if widths[s] > 1 else s, changes[s], widths[s] > 1))
        if widths[s] > 1:
            for b in reversed(range(widths[s])):
                rows.append((f"  [{b}]", bit_changes(changes[s], b), False))
    bg, fg, wave, busc = "#000000", "#e0e0e0", "#00e000", "#00e000"
    fig, ax = plt.subplots(figsize=(14, 0.42 * len(rows) + 1.2), facecolor=bg)
    ax.set_facecolor(bg)
    for row, (lbl, chs, is_bus) in enumerate(rows):
        y0 = (len(rows) - 1 - row) * 1.4
        ch = [(t * k, v) for t, v in chs] + [(tend, None)]
        for (ta, va), (tb, _) in zip(ch, ch[1:]):
            if tb <= ta:
                continue
            if not is_bus:
                lvl = y0 + (0.9 if va == "1" else 0)
                ax.plot([ta, tb], [lvl, lvl], color=wave, lw=1.6, solid_capstyle="butt")
                if tb < tend:
                    ax.plot([tb, tb], [y0, y0 + 0.9], color=wave, lw=1.6)
            else:
                d = min(4, (tb - ta) / 4)
                ax.plot([ta, ta + d, tb - d, tb, tb - d, ta + d, ta],
                        [y0 + .45, y0 + .9, y0 + .9, y0 + .45, y0, y0, y0 + .45], color=busc, lw=1.2)
                try:
                    txt = format(int(va, 2), "X")
                except ValueError:
                    txt = va
                if tb - ta > tend / 70:
                    ax.text((ta + tb) / 2, y0 + 0.45, txt, ha="center", va="center", fontsize=9, color=fg)
        ax.text(-tend * 0.01, y0 + 0.45, lbl, ha="right", va="center", fontsize=10,
                family="monospace", color=fg, weight="bold" if not lbl.startswith(" ") else "normal")
    ax.set_xlim(0, tend)
    ax.set_ylim(-0.4, 1.4 * len(rows))
    ax.set_yticks([])
    ax.set_xlabel("tempo (ns)", color=fg)
    ax.tick_params(colors=fg)
    ax.grid(axis="x", color="#444444", lw=0.6)
    for sp in ("left", "right", "top"):
        ax.spines[sp].set_visible(False)
    ax.spines["bottom"].set_color(fg)
    fig.tight_layout()
    fig.savefig(png, dpi=110, facecolor=bg)


if __name__ == "__main__":
    main()
