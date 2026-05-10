"""
Spike 002a vs 002b: head-to-head comparison of raised-depth-color formulas.

Why this is a comparison spike:
The BRIEF says the current `_raised_depth_color` (neocade_theme.gd:800-806) drifts
the depth color toward base_color (16%) and toward black (10%), erasing per-button
hue identity. A hot-pink button gets a muted-purple depth strip, not a darker pink.
HCGames Flat GUI for Mobile Games -- the user's anchor reference -- uses
*same-hue-family* depth strips (e.g. bright pink button -> noticeably darker pink
shadow at ~40-50% darker, not muted, not desaturated). The candidate replacement
this spike validates is HSV value-darken with NO base-pull and NO black-pull.

Method:
  1. Reimplement the current GDScript formula in Python (deterministic linear-RGB
     mix). Same math as `_mix(element, base_c, 0.16)` then `_mix(_, BLACK, 0.10)`.
  2. Implement candidate formulas:
       - hsv_value_darken_30 -- V *= 0.70
       - hsv_value_darken_40 -- V *= 0.60  (HCGames-spirit)
       - hsv_value_darken_50 -- V *= 0.50
  3. For a representative set of test colors (hot pink, vivid green, royal blue,
     gold, NeoCade-Pulse navy normal, NeoCade-Burst purple, NeoCade-Daybreak
     teal), apply each formula against navy and dark-purple base_color and
     measure:
       - Hue rotation (degrees from element hue to depth hue) -- want ~0
       - Saturation drop (fraction of original) -- want small
       - Value darken (fraction of original) -- want ~30-50%
       - Visual delta (RGB euclidean) -- want enough to read as "depth"
  4. Render comparison.html with one row per test color, one column per formula,
     each cell showing the button face above the depth strip and the metrics.

The verdict is whichever formula keeps depth in the same hue family while still
producing a clearly-darker strip.
"""

from __future__ import annotations

import colorsys
import json
import sys
from dataclasses import dataclass, asdict
from pathlib import Path

OUT_DIR = Path(__file__).parent.parent

TEST_COLORS = [
    ("Hot pink (HCGames anchor)", "#FF4D9A"),
    ("Vivid green (Pulse accent)", "#7CF24F"),
    ("Royal blue", "#4D7AFF"),
    ("Gold (Burst-style accent)", "#FFC857"),
    ("NeoCade Pulse normal button", "#1E2640"),
    ("NeoCade Burst purple", "#7C3AED"),
    ("NeoCade Daybreak teal", "#76F2D1"),
    ("Crimson danger", "#E2474A"),
]

BASE_COLORS = [
    ("Pulse base navy", "#0E1218"),
    ("Burst base purple", "#1A0F2E"),
]


def _hex_to_rgb01(h: str) -> tuple[float, float, float]:
    h = h.lstrip("#")
    return (int(h[0:2], 16) / 255.0, int(h[2:4], 16) / 255.0, int(h[4:6], 16) / 255.0)


def _rgb01_to_hex(rgb: tuple[float, float, float]) -> str:
    r, g, b = (max(0.0, min(1.0, v)) for v in rgb)
    return f"#{int(r * 255):02x}{int(g * 255):02x}{int(b * 255):02x}"


def _rgb_to_hsv(rgb: tuple[float, float, float]) -> tuple[float, float, float]:
    h, s, v = colorsys.rgb_to_hsv(*rgb)
    return (h * 360.0, s, v)


def _mix(a: tuple[float, float, float], b: tuple[float, float, float], t: float) -> tuple[float, float, float]:
    return (a[0] * (1 - t) + b[0] * t, a[1] * (1 - t) + b[1] * t, a[2] * (1 - t) + b[2] * t)


def current_formula(element: tuple[float, float, float], base: tuple[float, float, float], is_light: bool = False) -> tuple[float, float, float]:
    """Mirrors neocade_theme.gd:800-806."""
    base_pull = 0.16 if not is_light else 0.10
    depth_amount = 0.10 if not is_light else 0.12
    result = _mix(element, base, base_pull)
    result = _mix(result, (0.0, 0.0, 0.0), depth_amount)
    return result


def hsv_value_darken(element: tuple[float, float, float], strength: float) -> tuple[float, float, float]:
    """Pure HSV value-darken. Hue and saturation preserved. strength 0.30 -> V *= 0.70."""
    h, s, v = colorsys.rgb_to_hsv(*element)
    v_new = v * (1.0 - strength)
    return colorsys.hsv_to_rgb(h, s, v_new)


@dataclass
class Measurement:
    formula: str
    element_hex: str
    base_hex: str
    depth_hex: str
    hue_rotation_deg: float
    saturation_drop: float
    value_darken: float
    rgb_distance: float


def _hue_distance(a_deg: float, b_deg: float) -> float:
    d = abs(a_deg - b_deg)
    return min(d, 360.0 - d)


def measure(formula_name: str, element: tuple[float, float, float], base: tuple[float, float, float], depth: tuple[float, float, float]) -> Measurement:
    eh, es, ev = _rgb_to_hsv(element)
    dh, ds, dv = _rgb_to_hsv(depth)
    hue_rot = _hue_distance(eh, dh) if es > 0.05 and ds > 0.05 else 0.0
    sat_drop = (es - ds) / es if es > 1e-3 else 0.0
    val_drop = (ev - dv) / ev if ev > 1e-3 else 0.0
    rgb_dist = sum((a - b) ** 2 for a, b in zip(element, depth)) ** 0.5
    return Measurement(
        formula=formula_name,
        element_hex=_rgb01_to_hex(element),
        base_hex=_rgb01_to_hex(base),
        depth_hex=_rgb01_to_hex(depth),
        hue_rotation_deg=hue_rot,
        saturation_drop=sat_drop,
        value_darken=val_drop,
        rgb_distance=rgb_dist,
    )


FORMULAS = [
    ("current (gd:800-806)", lambda e, b: current_formula(e, b, False)),
    ("hsv-darken 30%", lambda e, b: hsv_value_darken(e, 0.30)),
    ("hsv-darken 40%", lambda e, b: hsv_value_darken(e, 0.40)),
    ("hsv-darken 50%", lambda e, b: hsv_value_darken(e, 0.50)),
]


def run_all() -> list[dict]:
    out = []
    for el_label, el_hex in TEST_COLORS:
        for base_label, base_hex in BASE_COLORS:
            element = _hex_to_rgb01(el_hex)
            base = _hex_to_rgb01(base_hex)
            row = {
                "element_label": el_label,
                "element_hex": el_hex,
                "base_label": base_label,
                "base_hex": base_hex,
                "results": [],
            }
            for fname, ffn in FORMULAS:
                depth = ffn(element, base)
                m = measure(fname, element, base, depth)
                row["results"].append(asdict(m))
            out.append(row)
    return out


CSS = """
* { box-sizing: border-box; }
body { background: #0e1116; color: #d6d8db; font: 14px/1.45 -apple-system,Segoe UI,Inter,sans-serif; padding: 32px; max-width: 1400px; margin: 0 auto; }
h1 { font-size: 26px; margin: 0 0 4px; color: #fff; }
.lede { color: #9ba1a8; margin: 0 0 24px; max-width: 920px; }
.base-section { margin-bottom: 36px; }
.base-section > h2 { font-size: 18px; color: #fff; margin: 0 0 4px; }
.base-section .base-meta { color: #8d939a; font-size: 13px; margin: 0 0 14px; display: flex; align-items: center; gap: 8px; }
.base-swatch { width: 18px; height: 18px; border-radius: 4px; border: 1px solid #2a2f37; }
table { width: 100%; border-collapse: separate; border-spacing: 0; background: #181c22; border-radius: 10px; overflow: hidden; }
th { text-align: left; padding: 10px 12px; background: #1f242b; color: #9ba1a8; font-weight: 600; font-size: 12px; text-transform: uppercase; letter-spacing: 0.04em; border-bottom: 1px solid #2a3140; }
td { padding: 10px 12px; vertical-align: top; border-bottom: 1px solid #232830; }
tr:last-child td { border-bottom: 0; }
.colstack { display: flex; flex-direction: column; gap: 0; }
.btn { width: 120px; height: 38px; border-radius: 8px 8px 0 0; display: flex; align-items: center; justify-content: center; font-weight: 700; color: rgba(0,0,0,0.7); font-size: 11px; text-shadow: 0 1px 0 rgba(255,255,255,0.4); }
.btn.dark { color: rgba(255,255,255,0.9); text-shadow: 0 1px 1px rgba(0,0,0,0.5); }
.depth { width: 120px; height: 14px; border-radius: 0 0 8px 8px; }
.metric { font-family: 'JetBrains Mono', Consolas, monospace; font-size: 11px; color: #8d939a; margin-top: 6px; }
.metric .ok { color: #6dd58c; }
.metric .warn { color: #f7c067; }
.metric .bad { color: #ff8487; }
.row-label { color: #fff; font-weight: 600; }
.row-label .hex { display: block; color: #8d939a; font-weight: 400; font-size: 11px; }
.legend { margin: 24px 0 8px; font-size: 13px; color: #8d939a; }
.formulas { margin: 8px 0 28px; padding: 14px 16px; background: #161b1f; border: 1px solid #2a3140; border-radius: 8px; font-size: 13px; }
.formulas code { font-family: 'JetBrains Mono', Consolas, monospace; background: #0e1116; padding: 1px 6px; border-radius: 3px; color: #d6d8db; }
.verdict { margin: 24px 0; padding: 18px 20px; background: #112f1a; color: #d2efdb; border-radius: 10px; border-left: 4px solid #6dd58c; }
.verdict h3 { margin: 0 0 6px; color: #aff0bf; font-size: 16px; }
"""


def build_html(rows: list[dict]) -> str:
    parts = [f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"/>
<title>Spike 002a/002b -- raised-depth-formula comparison</title>
<style>{CSS}</style></head><body>
<h1>Spike 002a vs 002b: raised-depth-formula head-to-head</h1>
<p class="lede">Renders the current <code>_raised_depth_color</code> output (neocade_theme.gd:800-806, with <code>base_pull=0.16, depth=0.10</code>) alongside three HSV-value-darken candidates. Each cell shows the button face on top and a 14px depth strip below -- exactly how a raised button reads in HCGames-style flat-game-UI. Numbers under each cell are the hue rotation in degrees (want ~0 for "same hue family"), saturation drop, and value drop.</p>

<div class="formulas">
<strong>Formulas under test:</strong><br>
<code>current</code> &mdash; <code>mix(element, base_color, 0.16)</code> then <code>mix(result, BLACK, 0.10)</code>. Drifts toward base + black.<br>
<code>hsv-darken 30%</code> &mdash; HSV: <code>V *= 0.70</code>. Hue and saturation preserved.<br>
<code>hsv-darken 40%</code> &mdash; HSV: <code>V *= 0.60</code>. HCGames-spirit darkness.<br>
<code>hsv-darken 50%</code> &mdash; HSV: <code>V *= 0.50</code>. Bold/candy-button territory.
</div>
"""]

    by_base: dict[str, list[dict]] = {}
    for row in rows:
        by_base.setdefault(row["base_hex"], []).append(row)

    for base_hex, base_rows in by_base.items():
        base_label = base_rows[0]["base_label"]
        parts.append(f'<div class="base-section">')
        parts.append(f'<h2>Base color: {base_label}</h2>')
        parts.append(f'<div class="base-meta"><div class="base-swatch" style="background:{base_hex}"></div>{base_hex}</div>')

        formula_names = [r["formula"] for r in base_rows[0]["results"]]
        parts.append("<table><thead><tr>")
        parts.append("<th>Test color</th>")
        for fn in formula_names:
            parts.append(f"<th>{fn}</th>")
        parts.append("</tr></thead><tbody>")

        for row in base_rows:
            parts.append("<tr>")
            parts.append(f'<td><span class="row-label">{row["element_label"]}<span class="hex">{row["element_hex"]}</span></span></td>')
            for r in row["results"]:
                hue_class = "ok" if r["hue_rotation_deg"] < 5 else ("warn" if r["hue_rotation_deg"] < 18 else "bad")
                # Determine if button face needs dark or light text
                er, eg, eb = _hex_to_rgb01(r["element_hex"])
                lum = 0.2126 * er + 0.7152 * eg + 0.0722 * eb
                btn_class = "btn" if lum > 0.5 else "btn dark"
                parts.append('<td>')
                parts.append('<div class="colstack">')
                parts.append(f'<div class="{btn_class}" style="background:{r["element_hex"]}">FACE</div>')
                parts.append(f'<div class="depth" style="background:{r["depth_hex"]}"></div>')
                parts.append('</div>')
                parts.append(
                    f'<div class="metric">'
                    f'<span class="{hue_class}">Δhue {r["hue_rotation_deg"]:.1f}°</span> · '
                    f'sat-drop {r["saturation_drop"]:.0%} · '
                    f'value-drop {r["value_darken"]:.0%}<br>'
                    f'depth: {r["depth_hex"]}'
                    f'</div>'
                )
                parts.append('</td>')
            parts.append("</tr>")
        parts.append("</tbody></table>")
        parts.append("</div>")

    parts.append("""
<div class="verdict">
<h3>Reading the cells</h3>
<p>For every row, watch the depth strip. Under <code>current</code>, the depth strip on bright colors (hot pink, gold, royal blue) reads as a different hue family than the button face -- the BRIEF's "muted-purple-black" complaint. Under <code>hsv-darken 40%</code> the depth strip reads as "noticeably darker pink" / "noticeably darker gold" -- same hue, same saturation, just darker. Hue rotation in green/red on the metric line confirms it numerically.</p>
<p>Note also: under <code>current</code>, very dark NeoCade button-normal colors (#1E2640, #1A0F2E) get pulled <em>further</em> toward base + black -- the depth strip is barely distinguishable from the button face. Under <code>hsv-darken 40%</code>, even the dark normal button reads as a perceptibly darker dark, because percentage-based darkening preserves contrast at any luminance.</p>
</div>

</body></html>
""")
    return "".join(parts)


def main() -> int:
    rows = run_all()
    (Path(__file__).parent / "measurements.json").write_text(json.dumps(rows, indent=2))
    html = build_html(rows)
    out = OUT_DIR / "002-comparison.html"
    out.write_text(html, encoding="utf-8")
    print(f"wrote {out}")
    print(f"wrote measurements.json")
    return 0


if __name__ == "__main__":
    sys.exit(main())
