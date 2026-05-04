# Architecture Research — NeoCade Theme

**Domain:** Godot 4.6 UI Theme — Visual Design System
**Researched:** 2026-05-04
**Confidence:** HIGH (Material 3 type/state values pulled from official material-web SCSS source; LDtk values pulled from real source; godot-minimal-theme values from upstream README; WCAG ratios computed via the W3C luminance formula)

---

## 0. Scope of "Architecture" for a Theme Project

For NeoCade, "architecture" is **not** software architecture — it is the **visual design system** that the `.tres` resource encodes. This document specifies:

1. Three concrete color palette proposals with full WCAG math
2. Typography stack (text + display) with rendering notes
3. Type scale (sizes, line heights, tracking)
4. Spacing / radius / stroke / elevation scales
5. Interaction state system as deterministic transforms
6. Mockup production strategy and approval gate
7. Synthesis of references and explicit anti-cyberpunk rules
8. Critique of the current `NeoCade-Theme-Prototype.png`

Phase planners turn each section into mockup tasks and `.tres` implementation specs. Section 1 (palette) and Section 5 (states) are the most prescriptive; everything else feeds into the same source-of-truth tokens.

---

## 1. Color Palette Proposals

### Architectural Approach: Material 3 Tonal Surface Ramp

We follow Material 3's **5-step neutral surface ramp** ([m3.material.io/styles/color/roles](https://m3.material.io/styles/color/roles)) instead of an ad-hoc Base/Secondary/Panel/Raised/Elevated set, because:

- It maps 1:1 to Godot's needs: panels, raised buttons, popups, headers, tooltips
- It reserves the lowest tone for "scrim/window background" and the highest for "elevated popup/menu" — exactly what `Window`, `PopupMenu`, `PopupPanel`, `AcceptDialog` need
- It is independent from accent color; we can ship alternate accents in v2 without redesigning the surface ramp

Each palette below provides:

| Token | Role |
|---|---|
| `surface` | Window background, root Control |
| `surface-container-low` | Tab inactive, scroll track |
| `surface-container` | Panel, PanelContainer default, GraphEdit grid |
| `surface-container-high` | Button normal, LineEdit, dropdown |
| `surface-container-highest` | Popup, tooltip, raised modal |
| `outline` | Border default |
| `on-surface` | Primary text |
| `on-surface-variant` | Secondary text |
| `on-surface-muted` | Disabled hint, placeholder |

All accent colors meet WCAG 2.1 SC 1.4.11 (Non-text Contrast, 3:1) against panel and raised surfaces, so they remain perceivable as UI components. All text vs surface combinations meet WCAG 2.1 SC 1.4.3 (4.5:1) at AA, and most exceed AAA (7:1).

---

### Palette A — "Midnight Marquee" (refined prototype)

The prototype's existing direction, cleaned up. **Cool blue surface, warm secondary accents.** This is what the user already has, with two corrections: (a) the prototype's accent magenta is pushed toward warmer pink to step away from synthwave, (b) a warm amber tertiary is introduced as the focus/marquee color.

| Token | Hex | Notes |
|---|---|---|
| `surface` | `#0F1626` | Deep navy, slightly desaturated |
| `surface-container-low` | `#141C2F` | |
| `surface-container` | `#1A2440` | Default panel |
| `surface-container-high` | `#243154` | Button normal |
| `surface-container-highest` | `#2E3D68` | Popups |
| `outline` | `#3B4D7C` | |
| `on-surface` | `#E8EFFC` | |
| `on-surface-variant` | `#B5C2DD` | |
| `on-surface-muted` | `#94A6C5` | Bumped from prototype to clear AA on raised |
| `primary` (accent) | `#4FB8FF` | Cyan-blue |
| `secondary` | `#FF7BAC` | Warm pink (NOT magenta) |
| `tertiary` / `focus` | `#FFC857` | Warm amber — marquee gold |
| `success` | `#5BD99B` | |
| `warning` | `#FFB454` | |
| `danger` | `#FF6B6B` | |

**Verified contrast (WCAG 2.1):**

| Pair | Ratio | Result |
|---|---|---|
| `on-surface` (#E8EFFC) vs `surface` (#0F1626) | **15.63:1** | AAA |
| `on-surface` vs `surface-container-high` | **11.07:1** | AAA |
| `on-surface-variant` (#B5C2DD) vs `surface-container` | **8.56:1** | AAA |
| `on-surface-muted` (#94A6C5) vs `surface-container-high` | **5.19:1** | AA |
| `primary` (#4FB8FF) vs `surface` | **8.28:1** | OK (>3:1 non-text) |
| `secondary` (#FF7BAC) vs `surface` | **7.46:1** | OK |
| `tertiary` (#FFC857) vs `surface` | **11.74:1** | OK |
| `danger` (#FF6B6B) vs `surface-container-high` | **4.61:1** | OK |
| BLACK label on `primary` | **9.08:1** | AAA |
| BLACK label on `tertiary` | **12.87:1** | AAA |
| BLACK label on `danger` | **7.13:1** | AAA |

**Verdict:** Use BLACK (#0A0A0A) text on every accent fill — none of them carry white text at AA.

---

### Palette B — "Boardwalk Sunset" *(RECOMMENDED — warmer arcade direction)*

A **warm-neutral surface** built around amber/coral/teal — the actual color signature of Round1, Dave & Buster's interior, and classic 80s/90s American arcade halls. The brown-tinted near-black reads "ticket booth wood + warm cabinet lights" instead of "computer terminal." Cyan is replaced by mint-teal so we don't drift toward Tron.

| Token | Hex | Notes |
|---|---|---|
| `surface` | `#1A1410` | Warm near-black, brown undertone |
| `surface-container-low` | `#221A14` | |
| `surface-container` | `#2C2218` | Default panel — like a stained pine cabinet |
| `surface-container-high` | `#3A2C20` | Button normal |
| `surface-container-highest` | `#4A3828` | Popups, tooltips |
| `outline` | `#5C4632` | |
| `on-surface` | `#FBF1E4` | Warm cream |
| `on-surface-variant` | `#D9C7B0` | |
| `on-surface-muted` | `#9F8A72` | |
| `primary` (accent) | `#FFB347` | Marquee gold / arcade amber |
| `secondary` | `#FF6B8A` | Ticket-stub pink/coral |
| `tertiary` | `#5DD3C3` | Mint-teal — game counter accent |
| `success` | `#9CD168` | Pinball-bumper green |
| `warning` | `#FFD166` | Soft yellow |
| `danger` | `#E84855` | Cherry red |
| `focus` | `#FFB347` | Same as primary — single focus signature |

**Verified contrast (WCAG 2.1):**

| Pair | Ratio | Result |
|---|---|---|
| `on-surface` (#FBF1E4) vs `surface` (#1A1410) | **16.33:1** | AAA |
| `on-surface` vs `surface-container-highest` | **9.96:1** | AAA |
| `on-surface-variant` (#D9C7B0) vs `surface-container` | **9.45:1** | AAA |
| `on-surface-muted` (#9F8A72) vs `surface` | **5.52:1** | AA |
| `on-surface-muted` vs `surface-container` | **4.71:1** | AA |
| `primary` (#FFB347) vs `surface` | **10.24:1** | OK |
| `secondary` (#FF6B8A) vs `surface-container` | **5.72:1** | OK |
| `tertiary` (#5DD3C3) vs `surface-container` | **8.58:1** | OK |
| `danger` (#E84855) vs `surface-container-high` | **3.52:1** | OK (>3:1) |
| BLACK on `primary` | **11.12:1** | AAA |
| BLACK on `secondary` | **7.28:1** | AAA |
| BLACK on `danger` | **5.18:1** | AA |

**Why this is the recommended direction:** The prototype's cool slate panel + magenta CTA reads "Cyber Cafe at midnight." `Boardwalk Sunset`'s warm pine + amber + coral reads "walking into Round1 at 7pm." It's the smallest possible move from the existing prototype that achieves the user's stated mental model ("vibrant arcade hall by day"). It also leaves cyan/electric blue on the table for a v2 alt palette without forcing a redesign.

---

### Palette C — "Cabinet Chrome" (LDtk-inspired, neutral charcoal + signature orange)

The **most disciplined** of the three. LDtk's actual palette (`#1e2229` / `#2e333f` / `#ffcc00` orange) extracted from `app.scss` (verified at `C:\Programming_Files\ldtk-master\app\assets\css\app.scss` lines 1–24) and tuned brighter for the larger contrast surface area Godot has. Single signature accent, cooler-blue secondary, single-CTA red. This is the closest to godot-minimal-theme's ethos but warmer.

| Token | Hex | Notes |
|---|---|---|
| `surface` | `#1E2229` | LDtk's `$bgDark` |
| `surface-container-low` | `#252A33` | |
| `surface-container` | `#2E333F` | LDtk's `$bgMed` |
| `surface-container-high` | `#3A404D` | |
| `surface-container-highest` | `#475065` | Approximately LDtk's `$bgLight` |
| `outline` | `#545D73` | |
| `on-surface` | `#F2F5FA` | |
| `on-surface-variant` | `#C1CFEB` | LDtk's `$almostWhite` |
| `on-surface-muted` | `#8E99B8` | Bumped from LDtk's `$bgLighter` for AA on raised |
| `primary` (accent) | `#FFB020` | LDtk-inspired marquee orange |
| `secondary` | `#5C9CFF` | Cool blue counterpoint |
| `tertiary` / CTA | `#FF7849` | Warm orange-red (replaces LDtk's `$red`; bumped to AA on raised) |
| `success` | `#7FD984` | |
| `warning` | `#FFCC00` | LDtk's `$orange` |
| `danger` | `#FF7849` | Same as tertiary — single danger-CTA color |
| `focus` | `#FFB020` | |

**Verified contrast (WCAG 2.1):**

| Pair | Ratio | Result |
|---|---|---|
| `on-surface` vs `surface` | **14.6:1** | AAA |
| `on-surface-variant` vs `surface-container` | **8.06:1** | AAA |
| `on-surface-muted` (#8E99B8) vs `surface-container` | **4.34:1** | AA-large; for body text use `on-surface-variant` |
| `primary` (#FFB020) vs `surface` | **8.73:1** | OK |
| `secondary` (#5C9CFF) vs `surface` | **5.82:1** | OK |
| `danger` (#FF7849) vs `surface-container-high` | **3.98:1** | OK |
| BLACK on `primary` | **10.83:1** | AAA |

**Verdict:** This is the safest, most "editor-feels-right" option but the least arcade-personality. Recommend it as a fallback if `Boardwalk Sunset` doesn't survive mockup review.

---

### Recommended Palette: **B — Boardwalk Sunset**

Concrete reasons:

1. The user explicitly rejected synthwave/scanline/cyberpunk; `Midnight Marquee` is still cool-and-blue and reads techy. `Boardwalk Sunset` is warm-and-amber and reads "place where humans go to play."
2. Real-world reference: Dave & Buster's signature blue + orange brand palette ([1000logos.net/dave-busters-logo](https://1000logos.net/dave-busters-logo/)); their interior color story leans warm wood + amber + accent blue, not cool slate + pink. Boardwalk Sunset captures that more honestly.
3. Material 3 surface ramps are tonal-neutral — Boardwalk's warm tint is achieved by 8°–12° hue rotation toward orange across all surface stops, so the system stays self-consistent.
4. Amber `#FFB347` as a single focus color is highly visible on every surface stop (10.24:1 down to 7.55:1) and reads as "arcade" without needing glow effects.
5. We can fall back to `Cabinet Chrome` if the user finds the warmth oppressive, or fork to `Midnight Marquee` if they prefer the existing prototype direction.

**All three palettes will be produced as mockups for the user's pick** — see Section 6.

---

## 2. Typography Stack

### Core Stack: Inter (UI) + Noto Sans (fallback)

Locked by the user. Both are SIL OFL, both bundle into the addon legally. Specific files to bundle:

- **Inter Variable** — `Inter-VariableFont_slnt,wght.ttf` (single file covers all weights + slant) — [github.com/rsms/inter](https://github.com/rsms/inter)
- **Noto Sans Variable** — `NotoSans-VariableFont_wdth,wght.ttf` + targeted scripts (`NotoSansCJK-VF.otf.ttc` for CJK, `NotoSansArabic-VariableFont_wdth,wght.ttf`) — bundle as Godot fallback chain

**Godot configuration:** Set `Inter` as the theme's `default_font` (FontVariation pointing at the variable file). Set Noto Sans variants in `default_font.fallbacks` so unsupported glyphs cascade. In `project.godot`:
```
gui/theme/default_font_subpixel_positioning=1     # Auto
```

**Subpixel rendering note (CRITICAL):** Godot 4.6 GL Compatibility renderer has a bug where mixing fonts with LCD subpixel antialiasing and fonts without it produces incorrect colors ([godotengine/godot#77443](https://github.com/godotengine/godot/issues/77443)). **Set every bundled font to "Grayscale" antialiasing**, not LCD. Use `hinting=Light` (default) and `subpixel_positioning=Auto`. This produces crisp text at every Godot-supported size on every renderer ([Godot fonts docs](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html)).

### Display Font: ADD a third "marquee" font for headings only

> **SUPERSEDED 2026-05-04 (Option D, FINAL):** No third display font. No Outfit. Headings use Inter Variable Roman at `opsz=32` + heavier `wght` (700-800). v1 ships **only Inter Variable Roman**. See `.planning/research/FONT-REVIEW.md` and SUMMARY.md Conflict 1 final. Section below is historical research context.

After evaluating five candidates, the recommendation is **Outfit** with a fallback to Inter. Outfit's geometric construction with rounded terminals and 45° cuts hits the "modern arcade signage" feel without leaning retro/synthwave. Smaller, secondary recommendation is **Space Grotesk** if Outfit feels too rounded.

| Font | Designer | License | Weights | Variable axes | Lang coverage | Small-size | Arcade fit | Verdict |
|---|---|---|---|---|---|---|---|---|
| **Outfit** | Rodrigo Fuenzalida + Smartsheet | OFL 1.1 | 100–900 | weight | Latin Extended, Vietnamese | OK at 18px+, avoid <14px | Strong (rounded geometric, "approachable arcade marquee") | **PRIMARY** |
| Space Grotesk | Florian Karsten | OFL 1.1 | 300–700 | weight | Latin Extended | Excellent | Modern-techy; risks synthwave drift | Backup |
| Bungee | DJR / Google | OFL 1.1 | Layered display only | none | Latin only | **Bad** at small sizes (display-only) | Too theme-park; reads "vintage signage" not "modern arcade" | Reject |
| Cabinet Grotesk | Indian Type Foundry | OFL 1.1 | 100–900 | weight | Latin only | Good | Sharp condensed; reads editorial not arcade | Reject |
| Pally | Indian Type Foundry | OFL 1.1 | 100–700 | weight | Latin only | Good | Bouncy, friendly; second-best arcade fit | Backup |

**Final stack (in `default_font.fallbacks` order):**
1. **Outfit** — used for `H1`/`H2`/`Window Title`/marquee labels via Theme Type Variations
2. **Inter** — default UI font for everything else
3. **Noto Sans + Noto Sans CJK + Noto Sans Arabic** — script fallback chain

**Rejected: pixel font for logos.** PROJECT.md explicitly forbids it (HD-only constraint). Outfit fills the "this looks arcade-y at 24px+" need without breaking that rule.

**Bundle size budget:**
- Inter Variable: ~810 KB
- Noto Sans Variable (Latin/Cyrillic/Greek): ~580 KB
- Noto Sans CJK (TC subset): ~12 MB → defer to v2 or ship as optional download
- Noto Sans Arabic: ~250 KB
- Outfit Variable: ~210 KB

→ v1 ships ~1.85 MB of fonts (excluding CJK). Acceptable for an addon. Add a `README` note on how to swap in CJK fallback for users who need it.

---

## 3. Type Scale

We use Material 3's type scale ([m3.material.io/styles/typography/type-scale-tokens](https://m3.material.io/styles/typography/type-scale-tokens)) as the spine, simplified to the subset Godot Controls actually need. Values pulled from the official `_md-sys-typescale.scss` v0.192 source (verified via raw GitHub fetch at `tokens/versions/v0_192/_md-sys-typescale.scss`). Ratio between adjacent body sizes: 14→16 = **1.143** (close to the 1.125 minor-second scale Material 3 uses). Headings use a separate larger interval (16→22→28→32→36 = ~1.36 average — close to major-third 1.25 with one explicit jump for H1).

| Role | Godot Theme Variation | px | Line Height (px) | Tracking | Weight | Font |
|---|---|---|---|---|---|---|
| `display-small` | `H1` (page hero) | 36 | 44 | 0.0 | 400 | **Outfit** |
| `headline-small` | `H2` | 24 | 32 | 0.0 | 500 | **Outfit** |
| `title-large` | `H3` | 20 | 28 | 0.0 | 500 | Outfit/Inter |
| `title-medium` | `H4` / Window title | 16 | 24 | 0.15 | 500 | Inter |
| `body-large` | Body emphasis | 16 | 24 | 0.5 | 400 | Inter |
| `body-medium` | **Default body / button label** | 14 | 20 | 0.25 | 400 | Inter |
| `body-small` | Caption / hint | 12 | 16 | 0.4 | 400 | Inter |
| `label-large` | Tab label, ToolButton | 14 | 20 | 0.1 | 500 | Inter |
| `label-small` | Status / chip | 11 | 16 | 0.5 | 500 | Inter |
| `code` (mono) | Code / debug / hex values | 13 | 20 | 0.0 | 400 | JetBrains Mono (OFL) |

**Mono font rationale:** Godot uses a monospace font for `CodeEdit`, hex inspectors, debug consoles. **JetBrains Mono** (Apache 2.0; full ligatures; OFL alternative is **IBM Plex Mono**) renders distinctly at 13px in Godot 4.6 with grayscale AA. Bundle ~340 KB.

**Tracking note:** Godot's Theme system supports `font_outline_size` and `letter_spacing` per-control via Theme Properties. Letter-spacing values above are in px (Godot's `Letter Spacing` theme constant accepts integer pixels — round 0.15 → 0, 0.5 → 1 for body-large). Most are effectively 0 at our sizes; only `body-large` (16px) uses +1px tracking.

**Math check (1.125 minor-second from 14px base):**
- 14 → 15.75 → 17.72 → 19.94 → 22.43 → 25.23 → 28.39
- We use 14, 16, 20, 24, 28, 36 → close enough to the curve, with anchored stops on Material 3 tokens. The discrepancy at 16 (vs 15.75) is intentional: 16 is the universal "large body" size and 14 is the universal "default body" size in modern UI ([m3.material.io](https://m3.material.io/styles/typography/type-scale-tokens), [Inter design intent](https://rsms.me/inter/)).

---

## 4. Spacing / Radius / Stroke / Elevation Scales

### Spacing Scale (4-step base, exponential)

```
xs   = 4px    # icon padding, badge inset
sm   = 8px    # button vertical padding, list-item gap
md   = 12px   # button horizontal padding, panel inner pad
lg   = 16px   # section gap, panel-to-content
xl   = 24px   # window margin, group separator
2xl  = 32px   # major section, hero spacing
3xl  = 48px   # page-level spacing
```

Rationale: 4-step base aligns with Material 3 ([m3.material.io/foundations/layout/applying-layout/spacing](https://m3.material.io/foundations/layout/applying-layout/spacing)), Inter's design grid, and Godot's snap defaults. Avoid 6/10/14 — they create rendering ambiguity at 1.0× DPI.

### Corner Radius Scale

```
none  = 0px    # dividers, tab strip
xs    = 2px    # checkbox, small chip
sm    = 4px    # button default, LineEdit, panel inner ← godot-minimal-theme uses 4-5
md    = 8px    # PanelContainer, AcceptDialog
lg    = 12px   # Window, large card, popup
full  = 999px  # pill button, circular avatar
```

**Decision:** Default is **4px**, matching godot-minimal-theme's recommended setting. We do NOT go below 4px on filled buttons (3px and below looks "amateur" at HD; 6px+ reads as "consumer mobile app" not "professional editor"). Use `md=8px` for `PopupPanel`/`Window`, and `lg=12px` only for floating dialogs/onboarding cards.

### Stroke Width Set

```
hairline  = 1px   # outline default, table separator
thin      = 2px   # focus ring inner, border emphasis
thick     = 3px   # focus ring outer, danger emphasis
```

Godot's `border_width_*` in StyleBoxFlat is integer pixels — 1.5px not supported. All strokes are integer px.

### Elevation / Surface Ramp

The surface-container-low → surface-container-highest ramp **is** the elevation system. We do **not** use box shadows — Godot's StyleBoxFlat shadow_offset and shadow_color exist but rendering quality on GL Compatibility is inconsistent ([godotengine/godot#76123](https://github.com/godotengine/godot/issues/) — generally avoid). Instead:

| "Elevation" | Surface token | Godot example |
|---|---|---|
| 0 | `surface` | Root window, scene background |
| 1 | `surface-container-low` | Tab bar inactive, scroll track |
| 2 | `surface-container` | `PanelContainer`, `MarginContainer` |
| 3 | `surface-container-high` | `Button.normal`, `LineEdit`, `OptionButton`, `MenuBar` |
| 4 | `surface-container-highest` | `PopupMenu`, `PopupPanel`, `Tooltip`, `AcceptDialog` |

Optional accent: a 1px top-bevel (1px lighter-than-surface highlight on the top edge of `surface-container-high` buttons) can simulate the "arcade button" tactile feel without shadow rendering. Implemented via `StyleBoxFlat.border_width_top=1` + lighter `border_color`.

---

## 5. Interaction State System

States are **deterministic transforms** of base colors via Material 3's state-layer model ([m3.material.io/foundations/interaction/states/state-layers](https://m3.material.io/foundations/interaction/states/state-layers); opacity values verified against `material-web/tokens/versions/v0_192/_md-sys-state.scss`):

| State | Overlay color | Opacity |
|---|---|---|
| Hover | `on-surface` (or `on-primary` for primary buttons) | **0.08** |
| Focus | `on-surface` | **0.12** + 2px focus ring |
| Pressed | `on-surface` | **0.12** |
| Dragged | `on-surface` | **0.16** |
| Disabled | `on-surface` | opacity multiplier = **0.38** on text, **0.12** on container |

### Concrete transforms (Palette B example)

For **filled primary button** with `bg=#FFB347`, `label=BLACK`:

| State | Bg color | Label | Border | Notes |
|---|---|---|---|---|
| Normal | `#FFB347` | `#0A0A0A` | none | |
| Hover | `#FFB956` | `#0A0A0A` | none | overlay `#FFFFFF` @ 8% |
| Focus | `#FFB347` | `#0A0A0A` | 2px solid `#FFB347` outer + 2px transparent gap + focus ring | see below |
| Pressed | `#E09E3E` | `#0A0A0A` | none | overlay `#000000` @ 12% (visible darkening) |
| Disabled | `surface-container-high` `@ 0.12 alpha overlay` = `#3D3328` | `on-surface @ 0.38` = `#675F50` | none | matches Material 3 disabled |

For **outlined / secondary button** with `bg=transparent`, `label=on-surface`, `border=outline`:

| State | Bg color | Label | Border |
|---|---|---|---|
| Normal | `transparent` | `#FBF1E4` | 1px `#5C4632` |
| Hover | `#3D3328` (panel + 8% on-surface overlay) | `#FBF1E4` | 1px `#5C4632` |
| Focus | `#3D3328` | `#FBF1E4` | 2px `#FFB347` |
| Pressed | `#453B30` (panel + 12% on-surface overlay) | `#FBF1E4` | 1px `#5C4632` |
| Disabled | `transparent` | `#675F50` | 1px `#3A2C20` |

### Focus indicator — the most important non-text contrast element

WCAG 2.1 SC 1.4.11 requires focus indicators at 3:1 against the adjacent surface. Implementation:

- **2px solid `focus` color** (always `primary` color in our palettes) drawn as the outer border
- For Palette B: 2px `#FFB347` ring → 10.24:1 vs surface, 8.74:1 vs panel — far exceeds 3:1 ✓
- We deliberately do **not** use a glow / box-shadow / chromatic-aberration focus effect — see Section 7's anti-cyberpunk rules

### Color transform helpers (Godot GDScript reference)

The `.tres` file is hand-edited, but for the docs/tooling phase we'll provide a helper script that generates state colors from base:

```gdscript
# Reference only — tokens are baked into the .tres
func state_overlay(base: Color, overlay: Color, alpha: float) -> Color:
    return base.lerp(overlay, alpha)

# Hover variant of primary
var primary_hover = state_overlay(primary, Color.WHITE, 0.08)
# Pressed variant of primary
var primary_pressed = state_overlay(primary, Color.BLACK, 0.12)
# Disabled label
var disabled_text = on_surface
disabled_text.a = 0.38
```

This produces **deterministic, reproducible** state colors so designers don't hand-pick variants.

---

## 6. Mockup Strategy

### Approval Gate Workflow

```
┌─────────────────────────────────────────────────────────────┐
│  Design phase (BEFORE any .tres styling commits)            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Step 1: Claude produces 3 HTML/SVG mockups                 │
│          (one per palette: A, B, C)                         │
│              ↓                                              │
│  Step 2: User reviews → picks ONE palette                   │
│              ↓                                              │
│  Step 3: Claude produces 2-3 typography variants            │
│          on the picked palette                              │
│              ↓                                              │
│  Step 4: User reviews → picks ONE typography combo          │
│              ↓                                              │
│  Step 5: Claude produces ONE high-fidelity full-control     │
│          mockup (every Godot Control class) on chosen       │
│          palette + typography                               │
│              ↓                                              │
│  Step 6: User APPROVES → unlocks .tres implementation       │
│          User REVISES → loop back to Step 5 (max 3 rounds)  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Mockup Production: Tools and Format

**Primary tool: HTML/SVG mockups produced by Claude**, rendered as `.html` files in `.planning/mockups/`. Why:

- Claude can write HTML/CSS/SVG natively and produce them in seconds
- The user can open them in a browser at any zoom; verifies high-DPI rendering
- They're cheap to iterate (re-color via CSS variables)
- They produce screenshot-quality images for any approval workflow
- They embed real fonts (Inter, Outfit) via Google Fonts CDN for true rendering fidelity
- They can be committed alongside the design spec as historical record

**Why NOT Figma:** No MCP available; would require user-side import; Claude can't iterate on it.

**Why NOT in-Godot screenshots before approval:** chicken-and-egg — the `.tres` doesn't exist yet, and we don't want to write throwaway StyleBox code we'll discard.

**Why NOT Claude image generation:** doesn't faithfully reproduce typography, contrast, or pixel-perfect alignment.

### Mockup Scope Per Step

**Step 1 (palette mockups, 3 files):**
- One HTML file per palette: `mockup-palette-A-midnight-marquee.html`, `mockup-palette-B-boardwalk-sunset.html`, `mockup-palette-C-cabinet-chrome.html`
- Each shows: 5 surface stops as stacked panels, 6 accent swatches with hex labels, 1 button (primary filled), 1 button (secondary outlined), 1 LineEdit, 1 Tab strip, 1 PopupMenu, sample text in 3 sizes (body, heading, code)
- Side-by-side render so user can compare at a glance
- ~60 lines of CSS each, semantic class names match our token names

**Step 3 (typography mockups, 2–3 files):**
- All on chosen palette
- Variant 1: Inter-only (no Outfit)
- Variant 2: Inter body + Outfit headings (recommended)
- Variant 3 (optional): Inter body + Space Grotesk headings
- Each shows the same H1/H2/H3/body/code/button-label sample text

**Step 5 (full-fidelity desktop mockup, 1 file):**
- One large HTML file simulating every Godot Control class from `control_gallery` ([github.com/godotengine/godot-demo-projects/tree/master/gui/control_gallery](https://github.com/godotengine/godot-demo-projects/tree/master/gui/control_gallery))
- Buttons: normal/hover/focused/pressed/disabled — all 5 states visible per button type
- LineEdit / TextEdit / SpinBox / Slider / ProgressBar / CheckBox / OptionButton / Tabs / PopupMenu / Tree / ItemList / GraphEdit (sketched)
- Window/AcceptDialog/ConfirmationDialog
- Approximately 1500 lines of HTML+CSS, organized by control group with subheadings

**Step 5b (mobile-variant mockup, 1 file) — ADDED 2026-05-04 per CROSS-PLATFORM and MAJ-6:**
Mobile variant is a v1 must-have, so the mockup gate must include a mobile mockup before `.tres` work begins.
- One HTML file showing the same Controls at mobile sizes (e.g. 360×800 and 768×1024 viewports)
- Tap-target overlays visible (44pt iOS / 48dp Android minimums highlighted; every interactive Control ≥48px in the mockup)
- Body type at 16px (vs desktop 14px), spacing scale +50% on space.4 and above; corner radii identical to desktop
- Same accent palette / surface ramp / typography stack as Step 5 — only scale and density differ
- User APPROVES desktop and mobile together (not separately) — one approval gate covers both variants

**Step 6 (combined approval):**
- User approves Step 5 + Step 5b together as a single design package, OR sends back specific feedback for revision (max 3 rounds total across both variants).
- Output on approval: `DESIGN_TOKENS.md` finalized with both desktop and mobile token blocks; `.planning/mockups/*.html` archived; `.tres` work UNLOCKED.

### After Approval

Once Step 6 unlocks: produce `.tres` via Godot Theme editor + manual `.tres` text edits, then in-Godot screenshot QA against the approved Step-5 mockup using the Godot MCP `mcp__godot__*` screenshot tools.

### Subagent Roles

| Phase | Subagent | Output |
|---|---|---|
| Mockup production | `mockup-designer` (writes HTML/SVG) | `.planning/mockups/*.html` |
| Mockup review | `mockup-reviewer` (separate eyes; checks against this spec) | review notes appended to mockup file |
| Implementation | `theme-implementer` (writes `.tres`) | `addons/neocade_theme/neocade_theme.tres` |
| Visual QA | `theme-qa` (runs Godot MCP, captures screenshots, diffs vs mockup) | `.planning/qa/*.png` + diff report |

---

## 7. Synthesis: References and Anti-Cyberpunk Discipline

### LDtk's clarity → NeoCade's surface ramp

LDtk's actual palette (extracted from `app.scss`: `$bgDark: #1e2229; $bgMed: #2e333f; $bgLight: #545d73; $orange: #ffcc00`) tells a clear story: **a single warm signature accent against a 4-stop neutral ramp, with no glow effects at all**. Its UI feels precise because there's no ambiguity about which surface a thing sits on, and because the orange is used sparingly — only for "this is the active interactive thing" signal. NeoCade adopts the same discipline: 5-stop ramp (we add one stop above LDtk's because Godot has more popup chrome), single primary accent, all elevation expressed through tonal value rather than shadows.

### Material 3's polish → NeoCade's tokens, type scale, and state system

Material 3 contributes the **vocabulary** ([m3.material.io](https://m3.material.io/)): tonal surface containers, type scale tokens, state-layer overlays at canonical opacities (8/12/12/16). We don't borrow Material's pill-shaped buttons or 24px corner radii — those read iOS-mobile and clash with Godot editor expectations. We borrow Material's **system architecture**: any color decision is a token, any state is a layer, any size is a scale step. This is what lets us produce a v2 light theme later without rewriting anything — only the token values change.

### godot-minimal-theme's discipline → NeoCade's "feels right in Godot" baseline

godot-minimal-theme ([github.com/passivestar/godot-minimal-theme](https://github.com/passivestar/godot-minimal-theme), now Godot 4.6's default) sets the floor: `4-5px corner radius`, `Inter font`, `0.3 contrast`, `2.0 icon saturation`, `#272727` base, `#569eff` accent. Our `Cabinet Chrome` palette explicitly mirrors its structure; even `Boardwalk Sunset` keeps the same proportions (small radii, Inter as default body, tonal-only elevation, single accent dominance). We deviate on the accent: `#569eff` is generic-cool-blue; we replace it with arcade-amber to give NeoCade a recognizable identity without breaking the discipline that makes the editor feel right.

### Real arcades' personality → NeoCade's warmth (NOT synthwave)

Round1, Dave & Buster's, Two Bit Circus, and classic 80s American arcade halls share a visual signature that the synthwave aesthetic completely misses: **warm interior lighting, painted/wood cabinets, branded marquee gold, ticket-counter coral and red, soft mint and pinball-bumper green**. Dave & Buster's official brand palette is deep blue + vibrant orange ([1000logos.net](https://1000logos.net/dave-busters-logo/)) — not neon pink + cyan. The cyberpunk/synthwave palette (saturated magenta, electric cyan, scanlines, glitch text) is a **fictional 1980s sci-fi vision** of arcades, not the real thing. Real arcades feel **inviting and warm at human eye level**, with a few small bright accents — exactly what `Boardwalk Sunset` encodes.

### Explicit anti-cyberpunk rules (apply to ALL mockups and the final .tres)

| Forbidden | Why | What to do instead |
|---|---|---|
| Chromatic aberration on focus / text | Reads as "hacker terminal glitch" | 2px solid focus ring in primary color |
| Diagonal stripe / grid overlays | Reads "Tron" | Plain solid surfaces, optional 1px top-bevel only |
| Scanline textures | The user explicitly rejected this | None — flat tonal surfaces |
| Outer glow / box-shadow halos on buttons | Reads "neon sign" | Tonal hover (8% lighten) only |
| Drop-shadow / radial glow on text | Looks dated, hurts AA contrast | Solid color text only |
| Saturated cyan + magenta paired | Synthwave signature | Use amber + coral + mint combination |
| Monospace / "console" font for body text | Cyber-terminal aesthetic | Inter + Outfit |
| `#000000` pure black surface | Reads "matrix terminal" | Warm near-black `#1A1410` (Boardwalk) or neutral `#1E2229` (Cabinet) |
| ALL CAPS body labels | Reads SF action-movie HUD | Sentence case body, Title Case for buttons |
| Sci-fi terminology in tooltips/labels | Drift toward dystopia | Plain UI English |
| Hex-grid backgrounds, fake circuitry | Cyberpunk cliché | Plain solid surfaces |
| "TRANSMISSION", "SYSTEM", glitch text effects | Cyberpunk cliché | Plain typography |

---

## 8. Critique of the Current Prototype (`NeoCade-Theme-Prototype.png`)

After visual inspection of the user's prototype: it has real strengths and the user's instinct that "the chrome leans too futuristic" is **correct**. Specific findings:

### What the prototype gets RIGHT (preserve these)

1. **Surface ramp structure is sound.** The Base/Secondary/Panel/Raised/Elevated stops in the upper-left palette legend are exactly the 5-step Material 3 ramp we want; only the hue values need adjustment.
2. **Comprehensive Control coverage.** The right-hand "Godot Controls" column shows nearly every interactive Control class (Button, OptionButton, CheckBox, RadioButton, Slider, SpinBox, ColorPicker, Tabs, ProgressBar, MenuBar, Tree, ItemList, file dialog). This is the right scope to mirror in the showcase scene — no scope changes needed.
3. **Theme-toggle modal is well-conceived.** The center "Apply Theme" dialog (Apply/Cancel + "Open Theme Editor" link) is a clean pattern the showcase scene should keep.
4. **Type hierarchy is visible.** "VirtuCade Godot Theme" + subtitle + control labels show clear H1/H2/body separation — the type scale is on the right track.
5. **Status indicators on the bottom strip.** The `0.5` / "Layer: Arcade Props" / "Project saved" pill row is exactly the kind of status-bar styling Godot has and we need to cover.

### What the prototype gets WRONG (must change)

1. **Theme is mislabeled "VirtuCade Godot Theme".** Per PROJECT.md: theme is **NeoCade**; VirtuCade is the consuming game. Every label, header, screenshot caption must say **NeoCade**.
2. **Magenta-on-cyan accent pair drifts toward synthwave.** The bright magenta/pink chrome in the upper toolbar plus electric cyan tab highlights is the exact aesthetic the user rejected. **Fix:** in `Boardwalk Sunset`, this becomes amber primary + coral secondary; in `Midnight Marquee`, it becomes blue primary + warm pink secondary (warmer than magenta).
3. **Glow halos on the active tab and primary button.** There are visible outer glows / soft halos that read as "neon sign" — direct cyberpunk drift. **Fix:** remove all glow; use the 8% tonal hover overlay and solid 2px focus ring only.
4. **Backdrop chrome is too cold.** The deep navy + magenta combination reads "computer at night," not "arcade by day." The user's "leans too futuristic" feeling is real. **Fix:** switch to `Boardwalk Sunset` warm-neutral surface ramp.
5. **No clear focus indicator.** The prototype shows hover-ish styling on tabs/buttons but no dedicated 2px solid focus ring — accessibility regression vs spec. **Fix:** every focusable Control gets a 2px `focus` color ring per Section 5.
6. **Status icons feel synthwave-coded.** The pill icons at the bottom (CRT-styled, glowing) reinforce the cyberpunk drift. **Fix:** flat material-style icons in monochrome accent fill, no glow.

### Recommendation to the user

Treat the prototype as a **structural reference (which Controls to cover, where to place panels, how big the toolbar is)**, not a visual reference. The hue palette, glow effects, and "VirtuCade" labeling all need to change. `Boardwalk Sunset` is the smallest move that respects the prototype's structural strengths while addressing the "too futuristic" complaint.

---

## Sources

### Primary documentation (HIGH confidence)

- Material Design 3 type scale — pulled values from upstream SCSS: `https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-typescale.scss`
- Material Design 3 state layer opacities — pulled values from upstream SCSS: `https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-state.scss` (hover 0.08, focus 0.12, pressed 0.12, dragged 0.16)
- [Material Design 3 — Color roles](https://m3.material.io/styles/color/roles)
- [Material Design 3 — Type scale tokens](https://m3.material.io/styles/typography/type-scale-tokens)
- [Material Design 3 — State layers](https://m3.material.io/foundations/interaction/states/state-layers)
- [Flutter TextTheme reference (canonical M3 type scale values)](https://api.flutter.dev/flutter/material/TextTheme-class.html)
- [WCAG 2.1 Understanding SC 1.4.3 Contrast (Minimum)](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html)
- [WCAG 2.1 SC 1.4.11 Non-text Contrast](https://www.w3.org/WAI/WCAG21/quickref/#non-text-contrast)
- [godot-minimal-theme (GitHub) — recommended editor settings](https://github.com/passivestar/godot-minimal-theme)
- [Godot fonts and text rendering](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html)
- [Godot issue #77443 — LCD subpixel + GL Compatibility bug](https://github.com/godotengine/godot/issues/77443)
- LDtk source — `C:\Programming_Files\ldtk-master\app\assets\css\app.scss` (palette extracted lines 1–24)

### Type research (HIGH confidence)

- [Outfit on Google Fonts](https://fonts.google.com/specimen/Outfit)
- [Space Grotesk on Google Fonts](https://fonts.google.com/specimen/Space+Grotesk)
- [Inter (rsms.me)](https://rsms.me/inter/)
- [Noto Sans (Google)](https://fonts.google.com/noto)
- [JetBrains Mono](https://www.jetbrains.com/lp/mono/)
- [SIL Open Font License](https://openfontlicense.org/)

### Visual reference (MEDIUM confidence — visual interpretation)

- [Dave & Buster's brand palette](https://1000logos.net/dave-busters-logo/)
- [Round One Corporation](https://en.wikipedia.org/wiki/Round_One_Corporation)
- [Arcadecore aesthetic](https://aesthetics.fandom.com/wiki/Arcadecore)
- [Material Theme Builder](https://material-foundation.github.io/material-theme-builder/) — for v2 alt-palette generation
- [Tints.dev](https://www.tints.dev/) — recommended for ramp generation in implementation phase
- [Huey.design](https://huey.design/) — recommended for accent harmony exploration

### WCAG calculation

All contrast ratios in this document computed via the W3C formula:
- Relative luminance: `L = 0.2126·R + 0.7152·G + 0.0722·B` (after sRGB linearization)
- Contrast ratio: `(L_lighter + 0.05) / (L_darker + 0.05)`
- Implementation: Python script run during research; values rounded to two decimals

---

*Architecture research for: NeoCade Theme — Godot 4.6 dark theme visual design system*
*Researched: 2026-05-04*
