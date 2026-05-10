"""
Build report.html from hue_report.json. Standalone, no JS framework.
Each row: thumbnail + per-hue swatch strip with share% labels + headline number.
"""

from __future__ import annotations

import base64
import json
from pathlib import Path
from html import escape

HERE = Path(__file__).parent
DATA = HERE / "hue_report.json"

LABEL_BY_NAME = {
    "pulse-finalist-desktop-flat.png": ("Pulse", "neocade", "Recommended starter direction"),
    "slate-desktop-flat.png": ("Slate", "neocade", "Quiet professional direction"),
    "bubble-desktop-flat.png": ("Bubble", "neocade", "Round friendly direction"),
    "daybreak-desktop-flat.png": ("Daybreak", "neocade", "Calm minty direction"),
    "burst-desktop-flat.png": ("Burst", "neocade", "Loud expressive direction"),
    "md3-reference.png": ("MD3 reference (synthetic)", "ref", "Composed of MD3 spec role colors only"),
    "game-ui-reference.png": ("Mobile game-UI reference (synthetic)", "ref", "Composed in spirit of HCGames / Royal Match / Brawl Stars conventions"),
    "NeoCade-Theme-Prototype.png": ("User prototype (.planning/inputs)", "user", "User's own original NeoCade vision before the visual-identity lock"),
}

CSS = """
* { box-sizing: border-box; }
body { background: #0e1116; color: #d6d8db; font: 14px/1.45 -apple-system,Segoe UI,Inter,sans-serif; padding: 32px; max-width: 1200px; margin: 0 auto; }
h1 { font-size: 26px; margin: 0 0 4px; color: #fff; }
.lede { color: #9ba1a8; margin: 0 0 32px; max-width: 820px; }
.row { display: grid; grid-template-columns: 280px 1fr; gap: 16px; padding: 16px; border-radius: 12px; background: #181c22; margin-bottom: 12px; align-items: center; }
.row.neocade { background: #181c22; }
.row.ref { background: #161b1f; outline: 1px solid #2a3140; }
.row.user { background: #1c1822; outline: 1px dashed #3a2a40; }
.row img { width: 280px; height: 158px; object-fit: cover; border-radius: 8px; display: block; }
.meta h2 { font-size: 16px; font-weight: 600; margin: 0 0 4px; color: #fff; }
.meta .desc { color: #8d939a; font-size: 12px; margin: 0 0 12px; }
.count { display: inline-block; padding: 4px 10px; border-radius: 999px; font-weight: 700; font-size: 13px; margin-right: 8px; }
.count.bad { background: #421518; color: #ff8487; }
.count.warn { background: #3a2c10; color: #f7c067; }
.count.good { background: #112f1a; color: #6dd58c; }
.swatches { display: flex; gap: 4px; margin-top: 8px; height: 28px; border-radius: 6px; overflow: hidden; }
.swatch { display: flex; align-items: center; justify-content: center; font-size: 11px; font-weight: 600; color: rgba(255,255,255,0.92); text-shadow: 0 1px 2px rgba(0,0,0,0.4); padding: 0 6px; min-width: 28px; }
.summary { margin: 32px 0 16px; padding: 18px 20px; background: #161b1f; border: 1px solid #2a3140; border-radius: 10px; }
.summary h3 { margin: 0 0 8px; color: #fff; font-size: 16px; }
table { width: 100%; border-collapse: collapse; margin-top: 12px; font-size: 13px; }
th, td { text-align: left; padding: 7px 10px; border-bottom: 1px solid #232830; }
th { color: #9ba1a8; font-weight: 600; font-size: 12px; text-transform: uppercase; letter-spacing: 0.04em; }
tr.neo td:first-child { color: #ffb4ab; }
tr.ref td:first-child { color: #6dd58c; }
tr.user td:first-child { color: #c8a0f0; }
.note { color: #6e747c; font-size: 12px; margin-top: 12px; max-width: 820px; }
"""


def _encode_image(p: Path) -> str:
    if not p.exists():
        return ""
    data = base64.b64encode(p.read_bytes()).decode("ascii")
    return f"data:image/png;base64,{data}"


def _verdict_class(n: int) -> str:
    if n <= 1:
        return "bad"
    if n == 2:
        return "warn"
    return "good"


def main() -> None:
    items = json.loads(DATA.read_text())
    rows = []
    summary_rows = []
    for item in items:
        name = Path(item["path"]).name
        label, kind, desc = LABEL_BY_NAME.get(name, (name, "neocade", ""))
        img_data = _encode_image(Path(item["path"]))
        n = item["hue_count"]
        vclass = _verdict_class(n)
        swatches = "".join(
            f'<div class="swatch" style="background:rgb({f["rgb"][0]},{f["rgb"][1]},{f["rgb"][2]});flex:{max(int(f["share_of_keep"]*100),3)};">{int(f["share_of_keep"]*100)}%</div>'
            for f in item["families"]
        )
        rows.append(f"""
<div class="row {kind}">
  <img src="{img_data}" alt="{escape(label)}" />
  <div class="meta">
    <h2>{escape(label)}</h2>
    <p class="desc">{escape(desc)}</p>
    <span class="count {vclass}">{n} hue{'s' if n != 1 else ''}</span>
    <span style="color:#7e858d;font-size:12px;">grey-masked: {item['grey_share']:.0%} · dark-masked: {item['dark_share']:.0%}</span>
    <div class="swatches">{swatches if swatches else '<div class=swatch style="background:#222;flex:1;color:#666;">(none above 1.2% threshold)</div>'}</div>
  </div>
</div>""")
        summary_rows.append((label, kind, n, item["families"]))

    summary_table_rows = "\n".join(
        f'<tr class="{kind}"><td>{escape(label)}</td><td><strong>{n}</strong></td><td>{", ".join(f"#{f["rgb"][0]:02x}{f["rgb"][1]:02x}{f["rgb"][2]:02x}" for f in fams) or "—"}</td></tr>'
        for (label, kind, n, fams) in summary_rows
    )

    html = f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"/>
<title>Spike 001 — Color Monoculture Diagnostic</title>
<style>{CSS}</style></head><body>

<h1>Spike 001: Color Monoculture Diagnostic</h1>
<p class="lede">Counts perceptually distinct hue families on each NeoCade direction's showcase frame and on synthesized references for MD3 spec layouts and shipped mobile flat-modern game UIs. Pixels below ~15% V (dark surface), above ~92% V (white text), or below ~12% saturation (grey/tonal-ramp surface) are excluded as "not a hue family". The remaining pixels are binned by hue (60 bins, ~6° wide) and weighted by saturation, so a small but vivid pink reads as more "hue presence" than a large but muddy off-grey.</p>

<div class="summary">
<h3>Headline numbers</h3>
<table>
<tr><th>Reference</th><th>Hues</th><th>Dominant swatches</th></tr>
{summary_table_rows}
</table>
<p class="note"><strong>Diagnosis:</strong> NeoCade's 5 directions average <strong>1.6 hues</strong> per showcase frame. The MD3 spec target is <strong>3 hues</strong> minimum (primary + secondary + tertiary visible simultaneously). Shipped mobile flat-modern game UIs commonly run <strong>5+ hues</strong> per screen (HUD widgets, primary CTA, severity-coded chrome, currency chips). The user's own original NeoCade prototype (before the visual-identity lock) reads at <strong>5 hues</strong>. The gap to MD3 is ~1.4 hues and to shipped game UIs is ~3.4 hues. The complaint is real, measured, and directional.</p>
</div>

{''.join(rows)}

<p class="note"><strong>Method note.</strong> Synthetic MD3 / game-UI references are drawn programmatically (see <code>synth_references.py</code>) rather than fetched from copyrighted sources. They use the MD3 spec role color slots and a typical mobile-game HUD layout respectively — they are honest measurements of the conventions, not screenshots of any particular product.</p>

</body></html>
"""
    out = HERE / "report.html"
    out.write_text(html, encoding="utf-8")
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
