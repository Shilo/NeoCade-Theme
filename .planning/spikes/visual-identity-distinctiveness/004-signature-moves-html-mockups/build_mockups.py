"""
Spike 004: Build self-contained signature-moves mockup HTML.

Renders the catalogued candidate moves from spike 003 as throwaway HTML so the
user can decide visually before Phase 12. The mockups are *not* Godot-rendered;
they reproduce the proposed StyleBox math in CSS and are visually faithful enough
for the headline decision (does this lift the game-UI feel?), not for production.

Sections produced:
  1. Hero: Pulse current vs proposed (side-by-side showcase frame).
  2. All 5 directions: current row above proposed row, full showcase mini.
  3. C2 palette derivation: per-direction primary/secondary/tertiary swatches.
  4. C3 panel tinting: 5 panel role tints per direction.
  5. C6 per-direction signature isolations.
  6. Verdict legend + final pick recommendations.

The proposed math:
  - C4 depth: HSV V *= (1 - (0.20 + 0.10 * raised_strength)).
  - C5 lift: per-direction primary lift bumped (Pulse 2->4, Bubble 3->5, Burst 3->6).
  - C1 role chrome: success/warning/danger/info badges visible by default.
  - C3 panel tint: 5% mix of role color into surface_panel.
  - C6 per-direction signature: kicker / hairline / pillow / halo / oversized.
"""

from __future__ import annotations

import colorsys
from pathlib import Path

OUT = Path(__file__).parent / "mockup-signature-moves.html"


DIRECTIONS = {
    "Pulse": {
        "base": "#0E1218",
        "panel": "#151A2E",
        "surface_high": "#1E2640",
        "accent": "#8BFF6A",
        "personality": "Cabinet-arcade rectangular",
        "primary_radius": 0,
        "secondary_radius": 0,
        "tab_radius": 0,
        "current_lift_primary": 2,
        "proposed_lift_primary": 4,
        "raised_strength": 2,  # 40% darken proposed
        "current_raised_strength_value_drop": 0.23,
        "proposed_value_drop": 0.40,
        "kicker": "uppercase-tracked",
        "signature": "Tracked-uppercase kicker chrome above section headings.",
    },
    "Slate": {
        "base": "#111820",
        "panel": "#192133",
        "surface_high": "#222C44",
        "accent": "#8BD3FF",
        "personality": "iOS-premium-quiet",
        "primary_radius": 14,
        "secondary_radius": 14,
        "tab_radius": 999,
        "current_lift_primary": 2,
        "proposed_lift_primary": 2,
        "raised_strength": 2,
        "current_raised_strength_value_drop": 0.23,
        "proposed_value_drop": 0.40,
        "kicker": "small-caps-subtle",
        "signature": "1px hairline borders on every interactive surface.",
    },
    "Bubble": {
        "base": "#241326",
        "panel": "#371D3D",
        "surface_high": "#4A2A50",
        "accent": "#FFB3E6",
        "personality": "Candy-pillowy",
        "primary_radius": 999,
        "secondary_radius": 26,
        "tab_radius": 999,
        "current_lift_primary": 3,
        "proposed_lift_primary": 5,
        "raised_strength": 3,
        "current_raised_strength_value_drop": 0.24,
        "proposed_value_drop": 0.50,
        "kicker": "uppercase-tracked",
        "signature": "Forced pillow on every interactive class (no radius below 26).",
    },
    "Daybreak": {
        "base": "#0B2420",
        "panel": "#0F2E29",
        "surface_high": "#143832",
        "accent": "#76F2D1",
        "personality": "Airy-welcoming-lobby",
        "primary_radius": 8,
        "secondary_radius": 8,
        "tab_radius": 8,
        "current_lift_primary": 3,
        "proposed_lift_primary": 3,
        "raised_strength": 2,
        "current_raised_strength_value_drop": 0.23,
        "proposed_value_drop": 0.40,
        "kicker": "sentence-case",
        "signature": "Soft 4px halo ring on primary CTAs (12% accent alpha).",
    },
    "Burst": {
        "base": "#20112E",
        "panel": "#2D1841",
        "surface_high": "#3D2057",
        "accent": "#FFD166",
        "personality": "Event-celebration-statement",
        "primary_radius": 28,
        "secondary_radius": 18,
        "tab_radius": 16,
        "current_lift_primary": 3,
        "proposed_lift_primary": 6,
        "raised_strength": 3,
        "current_raised_strength_value_drop": 0.24,
        "proposed_value_drop": 0.50,
        "kicker": "uppercase-tracked",
        "signature": "Oversized primary CTA: 56px desktop / 64px mobile.",
    },
}


def hex_to_rgb(h):
    h = h.lstrip("#")
    return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16))


def rgb_to_hex(r, g, b):
    return f"#{int(r):02x}{int(g):02x}{int(b):02x}"


def hsv_darken(hex_in, strength):
    r, g, b = (c / 255.0 for c in hex_to_rgb(hex_in))
    h, s, v = colorsys.rgb_to_hsv(r, g, b)
    v_new = max(v * (1 - strength), 0.04)
    nr, ng, nb = colorsys.hsv_to_rgb(h, s, v_new)
    return rgb_to_hex(nr * 255, ng * 255, nb * 255)


def md3_secondary(accent_hex):
    """Same hue, chroma * 0.55."""
    r, g, b = (c / 255.0 for c in hex_to_rgb(accent_hex))
    h, s, v = colorsys.rgb_to_hsv(r, g, b)
    nr, ng, nb = colorsys.hsv_to_rgb(h, s * 0.55, v * 0.92)
    return rgb_to_hex(nr * 255, ng * 255, nb * 255)


def md3_tertiary(accent_hex, rotation_deg):
    """Hue + rotation, retain chroma."""
    r, g, b = (c / 255.0 for c in hex_to_rgb(accent_hex))
    h, s, v = colorsys.rgb_to_hsv(r, g, b)
    h2 = (h + rotation_deg / 360.0) % 1.0
    nr, ng, nb = colorsys.hsv_to_rgb(h2, s, v)
    return rgb_to_hex(nr * 255, ng * 255, nb * 255)


def panel_tint(panel_hex, role_hex, strength=0.06):
    """Mix role into panel by strength. 6% default."""
    pr, pg, pb = hex_to_rgb(panel_hex)
    rr, rg, rb = hex_to_rgb(role_hex)
    nr = pr * (1 - strength) + rr * strength
    ng = pg * (1 - strength) + rg * strength
    nb = pb * (1 - strength) + rb * strength
    return rgb_to_hex(nr, ng, nb)


ROLE_COLORS = {
    "success": "#7EE08A",
    "warning": "#F7C067",
    "danger": "#FF5E5E",
    "info": "#9C8CF4",
    "primary": None,  # set per-direction from accent
}


CSS = """
* { box-sizing: border-box; margin: 0; padding: 0; }
:root { font: 14px/1.45 -apple-system, 'Segoe UI', Inter, sans-serif; }
body { background: #0a0c10; color: #d6d8db; padding: 32px 24px 80px; max-width: 1500px; margin: 0 auto; }
h1 { font-size: 28px; color: #fff; margin-bottom: 4px; }
.lede { color: #9ba1a8; max-width: 920px; margin-bottom: 32px; line-height: 1.55; }
section { margin-top: 56px; padding-top: 24px; border-top: 1px solid #1c1f25; }
section.first { border-top: 0; padding-top: 0; }
h2 { color: #fff; font-size: 22px; margin-bottom: 8px; }
h2 .tag { font-size: 11px; padding: 3px 8px; border-radius: 999px; background: #1f2530; color: #9ba1a8; margin-left: 10px; vertical-align: middle; font-weight: 600; letter-spacing: 0.04em; text-transform: uppercase; }
.tag.adopt { background: #112f1a; color: #aff0bf; }
.tag.open { background: #3a2c10; color: #f7c067; }
.tag.compare { background: #1f2533; color: #a5b4d8; }
h2 small { color: #9ba1a8; font-weight: 400; font-size: 14px; margin-left: 8px; }
.pull { color: #9ba1a8; font-size: 13px; max-width: 920px; margin-bottom: 18px; line-height: 1.55; }
.pull code { font-family: 'JetBrains Mono', Consolas, monospace; background: #161b1f; padding: 1px 6px; border-radius: 3px; font-size: 12px; }

/* Mockup frame */
.frame { border-radius: 14px; padding: 18px; box-shadow: 0 6px 20px rgba(0,0,0,0.4); position: relative; }
.frame .frame-label { position: absolute; top: 10px; right: 14px; font-size: 11px; color: rgba(255,255,255,0.4); font-weight: 600; text-transform: uppercase; letter-spacing: 0.06em; }
.frame .row { display: flex; gap: 8px; margin-bottom: 8px; align-items: center; flex-wrap: wrap; }
.frame .row:last-child { margin-bottom: 0; }
.frame .heading { font-size: 18px; font-weight: 700; color: #fff; margin-bottom: 12px; }
.frame .kicker { font-size: 10px; font-weight: 700; letter-spacing: 0.18em; text-transform: uppercase; margin-bottom: 4px; }
.frame .panel { padding: 14px 16px; border-radius: 10px; }
.frame .panel-header { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; margin-bottom: 8px; opacity: 0.75; }

/* Buttons (simulated raised) */
.nbtn { display: inline-block; padding: 8px 16px; font-weight: 600; font-size: 13px; cursor: pointer; user-select: none; position: relative; transition: transform .08s; }
.nbtn .face { display: block; padding: 8px 16px; border-radius: inherit; }
.nbtn-stack { position: relative; display: inline-block; }
.nbtn-depth { position: absolute; left: 0; right: 0; bottom: 0; border-radius: inherit; }
.nbtn-face { position: relative; padding: 8px 16px; font-weight: 600; font-size: 13px; border-radius: inherit; display: inline-block; line-height: 1; text-align: center; }

.badge { display: inline-flex; align-items: center; gap: 5px; padding: 3px 9px; border-radius: 999px; font-size: 11px; font-weight: 700; }
.badge::before { content: ''; width: 6px; height: 6px; border-radius: 50%; background: currentColor; }
.chip { padding: 4px 10px; border-radius: 999px; font-size: 11px; font-weight: 700; display: inline-block; }
.dot { width: 8px; height: 8px; border-radius: 50%; display: inline-block; margin-right: 6px; vertical-align: middle; }

.swatch-row { display: flex; gap: 6px; flex-wrap: wrap; }
.swatch { padding: 8px 10px; border-radius: 6px; font-family: 'JetBrains Mono', Consolas, monospace; font-size: 11px; font-weight: 600; min-width: 90px; }

.compare-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.compare-grid > * { min-height: 100%; }
.compare-grid .label { font-size: 11px; color: #6e747c; text-transform: uppercase; letter-spacing: 0.08em; font-weight: 700; margin-bottom: 8px; }

.dir-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 12px; }
.dir-card .frame { padding: 12px; }
.dir-card .frame-label { display: none; }
.dir-card h3 { color: #fff; font-size: 14px; margin-bottom: 4px; }
.dir-card p { color: #9ba1a8; font-size: 11px; margin-bottom: 10px; }

.metric { font-family: 'JetBrains Mono', Consolas, monospace; font-size: 11px; color: #6e747c; margin-top: 8px; }

footer { margin-top: 64px; padding: 24px; background: #161b1f; border: 1px solid #2a3140; border-radius: 12px; color: #d6d8db; }
footer h3 { color: #fff; font-size: 18px; margin-bottom: 12px; }
footer ul { padding-left: 20px; line-height: 1.7; }
footer li { margin-bottom: 4px; }
footer .verdict { display: inline-block; font-weight: 700; padding: 1px 6px; border-radius: 4px; font-size: 12px; }
footer .verdict.adopt { background: #112f1a; color: #aff0bf; }
footer .verdict.open { background: #3a2c10; color: #f7c067; }
"""


def render_kicker(d, text="01 ACTION PANEL"):
    style = d["kicker"]
    if style == "uppercase-tracked":
        return f'<div class="kicker" style="color:{d["accent"]};letter-spacing:0.22em;">{text}</div>'
    if style == "small-caps-subtle":
        return f'<div class="kicker" style="color:{d["accent"]};opacity:0.75;letter-spacing:0.12em;font-size:11px;">{text}</div>'
    if style == "sentence-case":
        return f'<div class="kicker" style="color:{d["accent"]};letter-spacing:0.05em;text-transform:none;font-weight:600;">Action Panel</div>'
    return f'<div class="kicker" style="color:{d["accent"]};">{text}</div>'


def render_button(d, label="START", *, primary=True, depth_factor=None, height_extra=0, halo=False, sig_pillow=False):
    radius = d["primary_radius"] if primary else d["secondary_radius"]
    if sig_pillow and radius < 26:
        radius = 26
    radius_css = f"{radius}px" if radius < 999 else "9999px"
    if depth_factor is None:
        depth_factor = d["current_raised_strength_value_drop"]
    accent = d["accent"] if primary else d["surface_high"]
    text_color = "#0d141b" if primary else "#e9edf3"
    depth_color = hsv_darken(accent, depth_factor)
    lift_px = d["proposed_lift_primary"] if depth_factor > 0.30 else d["current_lift_primary"]
    if not primary:
        lift_px = max(lift_px - 1, 1)
    pad_y = 10 + height_extra
    pad_x = 18
    depth_offset = lift_px
    halo_html = ""
    if halo:
        halo_html = f'<div style="position:absolute;inset:-5px;border-radius:{radius_css};border:4px solid {d["accent"]};opacity:0.20;pointer-events:none;"></div>'

    return f"""
<div class="nbtn-stack" style="margin-right:8px;">
  {halo_html}
  <div class="nbtn-depth" style="background:{depth_color};border-radius:{radius_css};height:{pad_y * 2 + 16 + depth_offset}px;"></div>
  <div class="nbtn-face" style="background:{accent};color:{text_color};border-radius:{radius_css};padding:{pad_y}px {pad_x}px;margin-bottom:{depth_offset}px;">{label}</div>
</div>
"""


def render_role_badges(d):
    return f"""
<span class="badge" style="background:{ROLE_COLORS['success']}22;color:{ROLE_COLORS['success']};">SUCCESS</span>
<span class="badge" style="background:{ROLE_COLORS['warning']}22;color:{ROLE_COLORS['warning']};">WARN</span>
<span class="badge" style="background:{ROLE_COLORS['danger']}22;color:{ROLE_COLORS['danger']};">DANGER</span>
<span class="badge" style="background:{ROLE_COLORS['info']}22;color:{ROLE_COLORS['info']};">INFO</span>
"""


def render_pulse_current() -> str:
    d = DIRECTIONS["Pulse"]
    return f"""
<div class="frame" style="background:{d['base']};">
  <div class="frame-label">CURRENT</div>
  <div class="heading" style="color:{d['accent']};">Pulse</div>
  <div class="row">
    <div class="panel" style="background:{d['panel']};flex:1;">
      <div class="panel-header" style="color:{d['accent']};">01 ACTION PANEL</div>
      {render_button(d, "START", primary=True)}
      {render_button(d, "Options", primary=False)}
      <div style="margin-top:14px;color:#7e858d;font-size:12px;">No badges. No tertiary. One accent on focus only.</div>
    </div>
    <div class="panel" style="background:{d['panel']};width:240px;">
      <div class="panel-header" style="color:{d['accent']};">02 LIST</div>
      <div style="color:#e9edf3;font-size:13px;padding:6px 0;">Cabinet A · ready</div>
      <div style="color:#7e858d;font-size:13px;padding:6px 0;">Mini-game list · 3 new</div>
      <div style="color:#7e858d;font-size:13px;padding:6px 0;">Settings row · stable</div>
    </div>
  </div>
  <div class="metric">measured: 2 hues (navy 95% + green 3%) · depth ~23% darker</div>
</div>
"""


def render_pulse_proposed() -> str:
    d = DIRECTIONS["Pulse"]
    success = ROLE_COLORS['success']
    info = ROLE_COLORS['info']
    warning = ROLE_COLORS['warning']
    return f"""
<div class="frame" style="background:{d['base']};">
  <div class="frame-label">PROPOSED · C1+C4+C5+C6</div>
  <div class="heading" style="color:{d['accent']};">Pulse</div>
  <div class="row">
    <div class="panel" style="background:{d['panel']};flex:1;">
      <div class="kicker" style="color:{d['accent']};letter-spacing:0.22em;font-size:10px;font-weight:700;text-transform:uppercase;">— C6 KICKER —</div>
      <div class="panel-header" style="color:#fff;font-size:13px;">01 ACTION PANEL</div>
      {render_button(d, "START", primary=True, depth_factor=0.40)}
      {render_button(d, "Options", primary=False, depth_factor=0.40)}
      <div style="margin-top:12px;display:flex;gap:6px;">
        <span class="badge" style="background:{success}22;color:{success};">CONNECTED</span>
        <span class="badge" style="background:{warning}22;color:{warning};">2 PENDING</span>
      </div>
      <div class="metric" style="color:#aff0bf;">+C1 role badges · +C4 40% depth · +C5 lift=4px</div>
    </div>
    <div class="panel" style="background:{panel_tint(d['panel'], info, 0.06)};width:260px;border-left:3px solid {info};">
      <div class="panel-header" style="color:{info};">02 LIST · INFO PANEL</div>
      <div style="color:#e9edf3;font-size:13px;padding:6px 0;"><span class="dot" style="background:{success};"></span>Cabinet A · ready</div>
      <div style="color:#7e858d;font-size:13px;padding:6px 0;"><span class="dot" style="background:{ROLE_COLORS['danger']};"></span>Mini-game list · 3 new</div>
      <div style="color:#7e858d;font-size:13px;padding:6px 0;"><span class="dot" style="background:{d['accent']};"></span>Settings row · stable</div>
      <div class="metric" style="color:#aff0bf;">+C3 InfoPanel tint · stripe</div>
    </div>
  </div>
  <div class="metric" style="color:#aff0bf;font-weight:700;">measured target: 4-5 hues · navy + accent + success + info + warning + tinted panel</div>
</div>
"""


def render_dir_card_current(name) -> str:
    d = DIRECTIONS[name]
    return f"""
<div class="dir-card">
  <div class="frame" style="background:{d['base']};">
    <h3 style="color:{d['accent']};">{name}</h3>
    <p>current</p>
    <div class="panel" style="background:{d['panel']};">
      <div style="color:{d['accent']};font-size:9px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;margin-bottom:6px;">SECTION</div>
      <div style="margin-bottom:8px;">{render_button(d, "Start", primary=True, height_extra=-2)}</div>
      <div style="color:#7e858d;font-size:11px;">Mono accent only.</div>
    </div>
  </div>
</div>
"""


def render_dir_card_proposed(name) -> str:
    d = DIRECTIONS[name]
    success = ROLE_COLORS['success']
    info = ROLE_COLORS['info']
    danger = ROLE_COLORS['danger']
    secondary = md3_secondary(d['accent'])

    sig_extras = ""
    pillow = False
    halo = False
    height_extra = -2
    if name == "Pulse":
        sig_extras = f'<div style="color:{d["accent"]};font-size:8px;font-weight:700;letter-spacing:0.22em;text-transform:uppercase;">— SECTION —</div>'
    if name == "Slate":
        sig_extras = f'<div style="border:1px solid {d["accent"]}33;padding:6px;margin-bottom:6px;color:#9ba1a8;font-size:10px;">hairline border</div>'
    if name == "Bubble":
        pillow = True
    if name == "Daybreak":
        halo = True
    if name == "Burst":
        height_extra = 4

    return f"""
<div class="dir-card">
  <div class="frame" style="background:{d['base']};outline:2px solid {d['accent']}55;">
    <h3 style="color:{d['accent']};">{name}</h3>
    <p style="color:#aff0bf;">proposed</p>
    <div class="panel" style="background:{panel_tint(d['panel'], info, 0.04)};border-left:2px solid {info}88;">
      {sig_extras}
      <div style="margin-bottom:8px;">
        {render_button(d, "Start", primary=True, depth_factor=d['proposed_value_drop'], height_extra=height_extra, halo=halo, sig_pillow=pillow)}
      </div>
      <div style="display:flex;gap:4px;flex-wrap:wrap;">
        <span class="badge" style="background:{success}22;color:{success};font-size:9px;">OK</span>
        <span class="badge" style="background:{danger}22;color:{danger};font-size:9px;">!</span>
        <span class="chip" style="background:{secondary};color:#0d141b;font-size:9px;">2nd</span>
      </div>
    </div>
  </div>
</div>
"""


def render_c2_palette() -> str:
    cards = []
    for name, d in DIRECTIONS.items():
        rotation = +60 if name in ("Pulse", "Bubble", "Burst") else -60
        secondary = md3_secondary(d["accent"])
        tertiary = md3_tertiary(d["accent"], rotation)
        cards.append(f"""
<div style="background:{d['base']};padding:14px;border-radius:8px;">
  <div style="color:{d['accent']};font-weight:700;margin-bottom:8px;">{name}</div>
  <div style="font-size:11px;color:#9ba1a8;margin-bottom:4px;">accent → secondary → tertiary ({rotation:+d}°)</div>
  <div class="swatch-row">
    <div class="swatch" style="background:{d['accent']};color:#0d141b;">{d['accent']}<br/>primary</div>
    <div class="swatch" style="background:{secondary};color:#0d141b;">{secondary}<br/>secondary</div>
    <div class="swatch" style="background:{tertiary};color:#0d141b;">{tertiary}<br/>tertiary</div>
  </div>
</div>""")
    return "<div style=\"display:grid;grid-template-columns:repeat(2,1fr);gap:14px;\">" + "".join(cards) + "</div>"


def render_c3_panel_tinting() -> str:
    d = DIRECTIONS["Pulse"]
    panels = [
        ("LobbyPanel", d['accent'], "Lobby UI · welcome screen"),
        ("MatchPanel", ROLE_COLORS['info'], "Match UI · game in progress"),
        ("DangerPanel", ROLE_COLORS['danger'], "Danger UI · disconnects"),
        ("WarningPanel", ROLE_COLORS['warning'], "Warning UI · low battery"),
        ("SuccessPanel", ROLE_COLORS['success'], "Success UI · achievement"),
    ]
    cells = []
    for label, role, desc in panels:
        tinted = panel_tint(d['panel'], role, 0.06)
        cells.append(f"""
<div style="background:{d['base']};padding:8px;border-radius:6px;">
  <div class="panel" style="background:{tinted};border-left:3px solid {role};">
    <div class="panel-header" style="color:{role};">{label}</div>
    <div style="color:#e9edf3;font-size:12px;">{desc}</div>
  </div>
</div>""")
    return f"""
<div style="display:grid;grid-template-columns:repeat(5,1fr);gap:8px;">
{"".join(cells)}
</div>
<p class="metric">Each panel is the same Pulse base + 6% mix of its role color into <code>surface_panel</code>. Reads as "this section is X-coded" without changing the dark identity.</p>
"""


def render_c6_signatures() -> str:
    cells = []
    for name, d in DIRECTIONS.items():
        if name == "Pulse":
            sig_html = f'<div style="color:{d["accent"]};font-size:9px;letter-spacing:0.24em;font-weight:700;text-transform:uppercase;margin-bottom:4px;">— PULSE KICKER —</div><div style="color:#fff;font-weight:700;font-size:14px;">Section heading</div>'
        elif name == "Slate":
            sig_html = f'<div style="border:1px solid {d["accent"]}55;padding:8px;border-radius:14px;color:#9ba1a8;font-size:11px;">1px hairline · iOS-quiet</div>'
        elif name == "Bubble":
            sig_html = f'<div style="display:flex;gap:6px;align-items:center;flex-wrap:wrap;"><div style="background:{d["accent"]};color:#3d1029;padding:8px 16px;border-radius:9999px;font-size:11px;font-weight:700;">PILL</div><div style="background:{d["accent"]}77;color:#3d1029;padding:6px 14px;border-radius:9999px;font-size:11px;">chip</div><div style="background:{d["accent"]}33;color:#fff;padding:5px 10px;border-radius:9999px;font-size:10px;">tab</div></div>'
        elif name == "Daybreak":
            sig_html = f'<div class="nbtn-stack" style="position:relative;display:inline-block;"><div style="position:absolute;inset:-5px;border-radius:14px;border:4px solid {d["accent"]};opacity:0.22;pointer-events:none;"></div><div style="background:{d["accent"]};color:#0d2421;padding:9px 18px;border-radius:8px;font-size:12px;font-weight:700;">START</div></div><div class="metric" style="color:#f7c067;">⚠ OPEN — confirm</div>'
        else:  # Burst
            sig_html = f'<div style="background:{d["accent"]};color:#3d1029;padding:18px 28px;border-radius:28px;font-size:15px;font-weight:800;">PLAY</div><div class="metric">56px desktop / 64px mobile</div>'
        cells.append(f"""
<div style="background:{d['base']};padding:14px;border-radius:8px;">
  <div style="color:{d['accent']};font-weight:700;margin-bottom:6px;font-size:13px;">{name}</div>
  <div style="color:#9ba1a8;font-size:11px;margin-bottom:10px;">{d['signature']}</div>
  {sig_html}
</div>""")
    return f"""
<div style="display:grid;grid-template-columns:repeat(5,1fr);gap:10px;">
{"".join(cells)}
</div>
<p class="metric">Each direction's signature is on a non-color, non-radius axis. Even in greyscale, the directions are distinguishable.</p>
"""


def render_all_directions_compare() -> str:
    rows = ""
    for name in DIRECTIONS:
        rows += f"""
<div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:10px;">
  {render_dir_card_current(name)}
  {render_dir_card_proposed(name)}
</div>"""
    return rows


def main():
    pulse_current = render_pulse_current()
    pulse_proposed = render_pulse_proposed()
    c2_html = render_c2_palette()
    c3_html = render_c3_panel_tinting()
    c6_html = render_c6_signatures()
    all_dirs = render_all_directions_compare()

    html = f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8"/>
<title>Spike 004 — Signature Moves Mockups</title>
<style>{CSS}</style></head><body>

<h1>Spike 004: Signature Moves Mockups</h1>
<p class="lede">Throwaway HTML mockups of the catalogued moves from spike 003. Mockups simulate the proposed StyleBox math in CSS — visually faithful enough for the headline decision, not for production. Sections: Pulse current vs proposed (the headline), all 5 directions side-by-side, C2 palette derivation (resolves the C2 OPEN flag), C3 panel tinting demo, C6 per-direction signature isolation (resolves the Daybreak halo OPEN flag).</p>

<section class="first">
<h2>Headline: Pulse current vs proposed <span class="tag compare">side-by-side</span></h2>
<p class="pull">Same Pulse direction, same showcase shapes, two passes. Left: today, after the entire Phase 4-11 build. Right: with C1 (role-token chrome) + C4 (HSV-darken depth, 40% on raised_strength=2) + C5 (lift bumped 2→4) + C6 (kicker chrome) + C3 (info-coded tinted list panel).</p>
<div class="compare-grid">
  {pulse_current}
  {pulse_proposed}
</div>
</section>

<section>
<h2>All 5 directions: current vs proposed <span class="tag compare">coverage</span></h2>
<p class="pull">Each direction in a mini showcase panel. Top of each pair: current. Bottom: proposed (C1+C3+C4+C5+C6 applied per direction). Confirms uniqueness — even at thumbnail scale, each proposed cell reads distinctly: Pulse kicker, Slate hairline, Bubble pillow, Daybreak halo, Burst oversized.</p>
{all_dirs}
</section>

<section>
<h2>C2 — MD3 secondary / tertiary palette derivation <span class="tag open">OPEN flag check</span></h2>
<p class="pull">For each direction, tertiary is computed as accent rotated <code>+60°</code> (Pulse, Bubble, Burst — louder hue swing for celebratory directions) or <code>−60°</code> (Slate, Daybreak — calmer for quieter directions). Secondary is same hue, chroma × 0.55. Eyeball each row: does any tertiary look broken or clashing? If all 5 read as deliberate-looking color palettes, C2 graduates to ADOPT. If any look ugly, that direction needs a custom rotation (e.g., Daybreak teal at −60° lands on cyan-blue which is fine, but Pulse green at +60° lands on bright cyan which may compete with accent).</p>
{c2_html}
</section>

<section>
<h2>C3 — Per-section panel tinting demo <span class="tag adopt">ADOPT</span></h2>
<p class="pull">5 type variations on PanelContainer. Same Pulse base color, 6% mix of role color into <code>surface_panel</code>. Reads as "this section is role-coded" without changing the direction's dark identity. The leverage move that LDtk + every shipped game UI uses; deliverable via 5 cheap type variations and zero public-export changes.</p>
{c3_html}
</section>

<section>
<h2>C6 — Per-direction signature isolation <span class="tag adopt">ADOPT (4)</span> <span class="tag open">OPEN (Daybreak halo)</span></h2>
<p class="pull">Each direction's one non-color, non-radius signature, isolated. Visual confirmation that the directions are distinguishable on a colorblind / greyscale read. Daybreak's halo is the OPEN flag from spike 003 — does the 4px halo ring look soft/welcoming as intended, or does it read as a focus-state default and clash with the actual focus ring (offset=2)?</p>
{c6_html}
</section>

<footer>
<h3>Recommendation for Phase 12</h3>
<p>If the headline mockup (current vs proposed Pulse) looks like a meaningful lift, recommend adopting the <strong>C1 + C3 + C4 + C5</strong> subset for Phase 12 v0 (low-risk, ~6-8h of work, lifts hue count to ≥3 on every direction). C6 ships in v0 except for Daybreak halo (decide based on the C6 isolation row). C2 ships in v0+1 once tertiary palette derivation is visually confirmed across the 5 default + 3 stress-test custom palettes.</p>
<ul>
<li><span class="verdict adopt">ADOPT</span> C1 — Wire role tokens into normal-state chrome</li>
<li><span class="verdict adopt">ADOPT</span> C3 — Per-section panel tinting type variations</li>
<li><span class="verdict adopt">ADOPT</span> C4 — HSV-darken depth formula (= 002b winner)</li>
<li><span class="verdict adopt">ADOPT</span> C5 — Per-direction lift thickness scaling (Pulse, Bubble, Burst)</li>
<li><span class="verdict adopt">ADOPT</span> C6 — Per-direction signatures (Pulse, Slate, Bubble, Burst); <span class="verdict open">OPEN</span> Daybreak halo (decide visually here)</li>
<li><span class="verdict open">OPEN</span> C2 — MD3 tonal-palette derivation (ship in v0+1 after palette-stress confirmation)</li>
</ul>
</footer>

</body></html>
"""
    OUT.write_text(html, encoding="utf-8")
    print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
