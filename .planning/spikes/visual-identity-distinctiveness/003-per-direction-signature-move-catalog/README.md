---
spike: 003
name: per-direction-signature-move-catalog
type: standard
validates: "Given the 5 directions, when each is forced to differ on at least one non-color/non-radius axis, then they no longer read as same theme + hex swap; AND given the 1.6-hue average, when at least one move per direction binds additional hue-bearing chrome, then on-screen hue count lifts to >=3 per the MD3 spec floor."
verdict: VALIDATED
related: [001, 002a, 002b]
tags: [identity, direction, catalog]
---

# Spike 003: Per-direction signature-move catalog

## What This Validates

**Given** the 5 NeoCade directions — Pulse, Slate, Bubble, Daybreak, Burst — and the diagnostic findings from 001 (avg 1.6 hues, MD3 floor = 3) and 002b (HSV depth-darken fix), **when** a catalog of 3-6 candidate signature moves is drafted such that (a) at least one move addresses the color-monoculture diagnosis, (b) at least one addresses raised-mode fidelity, (c) every direction gets at least one signature move on a non-color, non-radius axis, **then** the catalog lifts every direction toward visual uniqueness AND lifts on-screen hue count toward the ≥3 spec floor.

## Research

### Sources cross-referenced

| Source | Used for |
|---|---|
| `.planning/spikes/visual-identity-distinctiveness/BRIEF.md` | The mandate axes (color monoculture, raised fidelity, per-direction signature) |
| `001-color-monoculture-diagnostic/` verdict | The numeric target (≥3 hues per direction) |
| `002b-raised-depth-formula-hsv-darken/` verdict | Move C4 — depth formula replacement |
| `.planning/research/THEME-DIRECTIONS.md` | Personality intents (Pulse arcade-cabinet, Slate iOS-premium-quiet, Bubble candy-pillowy, Daybreak airy-welcoming-lobby, Burst event-celebration-statement) |
| `.planning/research/MD3-RESEARCH.md` | MD3 dynamic-color tonal palette derivation rules (primary → secondary/tertiary at ±60°/±120°) |
| `.planning/research/FLAT-3D-UI-RESEARCH.md` | HCGames raised-mode anchor (5 hues per screen, same-family depth strips, pillow silhouettes, HUD widget chrome) |
| `.planning/research/LDTK-UI-MINING.md` | Per-section/per-role panel tinting pattern (LDtk's color-coded layer panels) |
| `addons/neocade_theme/scripts/neocade_theme.gd:913-1156` | `STYLE_PERSONALITY` dictionary — the existing per-direction extension point |
| `addons/neocade_theme/scripts/neocade_theme.gd:343-405` | Existing `role_success/warning/danger/info` and `_raised_depth_color` callsites — the shape of any binding addition |

### Why this spike doesn't build code

The deliverable is a structured catalog — not running code. Every candidate's feasibility is checked against the live `neocade_theme.gd` source (which Theme entries it would touch, which `STYLE_PERSONALITY.shape` keys it adds, whether new public exports are required). The interactive deliverable is spike 004 (HTML mockups of the highest-impact subset). 003's job is to bound the design space and assign verdicts so 004 has a clear sub-set to mock.

### Constraint filter applied to every candidate

Per the BRIEF's "Out of Scope" hard guardrails — every candidate must pass:

- ✓ Pure Theme / StyleBox primitives (no shaders, no GDExtension, no plugin.cfg)
- ✓ No textures, patterns, embossing, painterly chrome, gradients on chrome
- ✓ No drop shadows on chrome (GL Compatibility renders them wrong)
- ✓ No animations beyond Godot StyleBox transitions
- ✓ Anti-cyberpunk (no synthwave/neon-noir/scanline/neon-grit)
- ✓ Inter-only bundled font in v1 (consumer override pattern allowed)
- ✓ Does not break the 12-export public contract

Candidates that fail any of these are rejected up front and not catalogued.

## How to Run

This spike is read-only. Open this README. Cross-reference `addons/neocade_theme/scripts/neocade_theme.gd` lines cited per candidate to verify feasibility claims.

## Investigation Trail

### Iteration 1 — exhaustive candidate enumeration
Walked the BRIEF's 4 mandate items and 6 reference axes. Generated ~14 candidate moves; 8 dropped at the constraint filter (drop-shadow elevation, color-coded glow rings, animated hover lift, painterly badge stickers, shader-blurred backdrop, beyond-functional ornamental icons that violate the anti-painterly rule, custom font-stack additions, custom render layers).

### Iteration 2 — coverage check
6 surviving candidates, classified into three buckets:
- **Hue-count lift** (addresses 001 diagnosis): C1, C2, C3
- **Raised-mode fidelity** (addresses BRIEF axis b'/b''): C4, C5
- **Per-direction uniqueness** (addresses BRIEF axis c): C6

Each direction is served by C1 + C5 + C6 at minimum. C2 is direction-agnostic. C3 is consumer-facing (lifts real game UI hue count even when the showcase doesn't).

### Iteration 3 — verdict pass
For each candidate, scored on (Aesthetic Risk: low/medium/high), (Effort: S/M/L), (Hue-count delta: per-screen lift), (Personality fit: which directions). Final verdict per candidate:

- **ADOPT** when low risk + clear hue/uniqueness lift + small effort.
- **OPEN** when material risk, or palette-dependent, or per-direction conditional — needs visual confirmation in 004 before final yes.
- **REJECT** — none in this final set; rejected candidates were dropped at the constraint filter.

## Results

### Verdict: **VALIDATED — 6 candidates catalogued, 4 ADOPT / 2 OPEN, all 5 directions covered**

---

### C1 — Wire `role_success / warning / danger / info` into normal-state chrome

**Description.** The role tokens exist already (resolved per call in `neocade_theme.gd:300-405` and offset variants for raised mode). Currently they surface only on `DangerButton` and `PrimaryButton` type variations and on a few transient slots. The move: extend `BINDING_TABLE` so role colors appear as **steady-state chrome** on a small set of new type variations:

- `SuccessLabel` / `SuccessIcon` — `role_success` text + icon modulation
- `WarningPanel` — `role_warning` 8% tint on PanelContainer surface, full-strength on its title bar
- `DangerBadge` / `WarningBadge` / `InfoBadge` — Chip-derived badge type-variations using role colors
- `InfoBanner` — banner-shaped CenterContainer / HBoxContainer with `role_info` left-edge stripe

**References.** MD3 dynamic-color spec for severity-coded chrome; HCGames raised-mode reference (red heart HUD, gold coin chip — domain-coded chrome, not transient alerts).

**Personality served.** All 5. Burst leans into it (celebratory severity tags), Slate stays subtle (hairline-only severity), Pulse uses uppercase tracked accent for severity labels.

**Hue-count delta.** +2 on the showcase frame (success green badge + warning amber chip = 2 new hues on top of accent + base). Lifts Pulse, Slate, Daybreak from 1-2 hues toward MD3's 3 floor.

**Godot 4.6 feasibility.**
- Theme entries touched: ~14 new `BINDING_TABLE` rows (one per new type variation × N slots each).
- `STYLE_PERSONALITY.shape` impact: none (uses existing role tokens, not new shape constants).
- Public export impact: **zero** — role colors are already auto-derived from `accent_color` plus a fixed semantic palette in `_resolve_role_table()`.
- New SVGs needed: 0 (badges use existing chip/dot SVGs at 16px; severity icons can reuse `clear` / `arrow_down` inverted as info/warn glyphs in v1; bespoke severity SVGs are a Phase 12+1 polish pass).

**Aesthetic risk.** Low. Severity colors are MD3-canonical; the constraint filter passes (no textures, no gradients, no animation).

**Effort.** S — pure data additions to BINDING_TABLE. ~1 hour of binding work + ~30 min of showcase scene additions to demonstrate.

**Verdict.** ✓ **ADOPT.** Cheapest path to lifting the headline number, and it makes severity-coded chrome a first-class citizen rather than a tagalong of `DangerButton`.

---

### C2 — MD3 tonal-palette derive `secondary` and `tertiary` from `accent_color`

**Description.** MD3's dynamic-color algorithm derives a `secondary` role from `primary` by retaining hue and reducing chroma, and a `tertiary` role by rotating hue +60° and retaining chroma. NeoCade already has a `role_table` but it's keyed off `base_color` luminance variants only; `secondary` and `tertiary` are not derived. The move: add a hidden `_resolve_md3_extension_palette(accent_color, direction)` helper that produces:

- `accent_secondary` = same hue as accent, chroma × 0.55
- `accent_tertiary` = accent hue + 60° (Pulse, Bubble, Burst) or accent hue − 60° (Slate, Daybreak — calmer rotation), full chroma

Bind these to:
- `SecondaryButton` type variation — secondary fill, paler-accent text
- `TertiaryButton` / `Chip` — tertiary fill on chip backgrounds (currency-chip-like)
- Selected-tab-active-bar — tertiary instead of accent for tertiary-context tabs

**References.** Material 3 dynamic-color spec. fajrulaslim UI Button Flat Design (the BRIEF's companion exemplar) — uses 3 button family hues per screen.

**Personality served.** All 5; the rotation direction (+60° vs −60°) is the per-direction calibration.

**Hue-count delta.** +1 to +2 on the showcase frame.

**Godot 4.6 feasibility.**
- Theme entries: ~6 new `BINDING_TABLE` rows for SecondaryButton / TertiaryButton / Chip / TabBar variations.
- `STYLE_PERSONALITY.shape` impact: add an `md3_tertiary_rotation_deg` per-direction constant (defaults: Pulse +60°, Slate −60°, Bubble +60°, Daybreak −60°, Burst +60°). Hidden, not exported.
- Public export impact: **zero** — derived from existing `accent_color` export.
- New SVGs: 0.

**Aesthetic risk.** **Medium.** A 60° rotation of every accent can produce ugly hues for some `accent_color` choices (e.g., a yellowish accent rotated +60° lands on harsh orange-red). Mitigated by:
- Per-direction sign of rotation (above).
- Floor on tertiary chroma to prevent washed-out tertiaries.
- `CUSTOM` style users get a graceful fallback that reads `accent_color` as both primary and (slightly desaturated) secondary, no tertiary.

**Effort.** M — palette helper + per-direction tuning + 6 BINDING_TABLE rows + visual sanity-check on all 5 default palettes plus 2-3 user-likely overrides.

**Verdict.** ⚠ **OPEN.** Has the most upside on the headline number but the aesthetic risk needs a visual check in 004. Mock the palette derivation for all 5 default directions and confirm tertiary doesn't look broken on any.

---

### C3 — Per-section panel-tinting via consumer-driven type variation

**Description.** LDtk's level-editor chrome — despite being a tool — communicates section role through **hue-tinted panel surfaces**: layer panels are blue-tinted, entity panels are green-tinted, world panels are amber-tinted. Same architecture, different tint per role. The move: NeoCade exposes a small set of public `theme_type_variation` names that consumers (VirtuCade, third parties) attach to PanelContainers to get a faint role-tinted surface:

- `LobbyPanel` — surface pulls 4-6% toward `role_primary`
- `MatchPanel` — surface pulls 4-6% toward `role_info`
- `DangerPanel` — surface pulls 4-6% toward `role_danger`
- `WarningPanel` — surface pulls 4-6% toward `role_warning`
- `SuccessPanel` — surface pulls 4-6% toward `role_success`

Tint amount stays small (4-6%) to preserve dark-theme legibility and survive accessibility. The default `Panel` / `PanelContainer` keeps its current `surface_panel` value; the new type variations are *opt-in*.

**References.** LDtk per-layer color coding (the BRIEF cites this as "the color-expressive lesson from LDtk we keep, while rejecting LDtk's tool conventions"). HCGames HUD chrome (heart panel ≠ coin chip).

**Personality served.** All 5. Slate uses 3-4% tint (quieter); Burst uses 6-8% tint (statement). Per-direction calibration in `STYLE_PERSONALITY.shape.panel_tint_strength`.

**Hue-count delta.** **+2 to +4 in real consumer UIs.** Showcase impact depends on whether the showcase scene gets new tinted-panel demonstrations (recommended). The headline lift is bigger in a real lobby/match/HUD scene than in the existing showcase, which is one reason this is a *high-leverage* move even though the showcase number doesn't change much.

**Godot 4.6 feasibility.**
- Theme entries: 5 new type variations on Panel / PanelContainer with tinted-surface styleboxes.
- `STYLE_PERSONALITY.shape.panel_tint_strength`: 1 new constant per direction (Pulse 5%, Slate 3%, Bubble 6%, Daybreak 5%, Burst 7%).
- Public export impact: **zero** — uses existing `role_*` tokens.
- New SVGs: 0.

**Aesthetic risk.** Low. Faint tints (≤7%) survive every accessibility threshold and the anti-painterly rule. The only risk is consumers stacking tinted panels and the cumulative tint becoming garish — mitigated by docs ("tinted panels should not contain other tinted panels").

**Effort.** S-M — 5 BINDING_TABLE rows + per-direction tint calibration + a section in `addons/neocade_theme/README.md` documenting consumer use.

**Verdict.** ✓ **ADOPT.** Highest leverage in real consumer UIs, lowest aesthetic risk, no public-API change. Even if the showcase number stays modest, this gives VirtuCade and third parties the convention to lift their own hue counts from 2-3 to 5+.

---

### C4 — HSV-darken depth formula (= 002b winner, restated for the catalog)

**Description.** Replace `_raised_depth_color(element, base_c)` with HSV value-darken:

```gdscript
func _raised_depth_color(element: Color, base_c: Color) -> Color:
    var strength: float = 0.20 + 0.10 * float(raised_strength)
    var v: float = element.v * (1.0 - strength)
    var result := Color.from_hsv(element.h, element.s, max(v, 0.04))
    result.a = element.a
    return result
```

`base_c` retained in signature for callsite compatibility but unused.

**References.** HCGames Flat GUI for Mobile Games (the BRIEF's anchor reference). Spike 002b verdict.

**Personality served.** All 5. Calibration via existing per-direction `raised_strength` defaults (Pulse=2 → 40% darken; Slate=2 → 40%; Bubble=3 → 50%; Daybreak=2 → 40%; Burst=3 → 50%).

**Hue-count delta.** 0 directly, but enables the visual *reading* of "candy buttons" rather than "tool shadow lines", which makes accent and role colors feel more present.

**Godot 4.6 feasibility.**
- ~6 lines replacing existing `_raised_depth_color`. Plumbed through existing `raised_strength` export.
- No public export impact, no new tokens, no new SVGs.

**Aesthetic risk.** Low. Verified mathematically in 002b — hue and saturation are preserved by construction.

**Effort.** XS — single function rewrite; no callsite changes.

**Verdict.** ✓ **ADOPT.** Trivial code; spike 002b already validated.

---

### C5 — Per-direction lift thickness scaling

**Description.** HCGames-style depth strips read at ~4-6px on standard-sized buttons. Current per-direction `STYLE_PERSONALITY.shape.raised_lifts.primary` values are 2/2/3/3/3 (Pulse/Slate/Bubble/Daybreak/Burst). The BRIEF notes 2px reads as "tool shadow line", not "press me affordance". The move: rebalance per-direction lifts to match each personality's "loudness":

| Direction | Current `primary` lift | Proposed | Rationale |
|---|---|---|---|
| Pulse (cabinet bold) | 2 | **4** | Cabinet-arcade hardware reads as solid; thicker base |
| Slate (iOS quiet) | 2 | **2** (no change) | Quiet personality — keep subtle |
| Bubble (candy pillow) | 3 | **5** | Candy buttons need clearly-pressable depth |
| Daybreak (airy lobby) | 3 | **3** (no change) | Airy means light; not heavy |
| Burst (event statement) | 3 | **6** | Statement chrome demands bold affordance |

Other lift slots (`secondary`, `panel`, `dialog`, `chip`, etc.) scale proportionally per direction.

**References.** HCGames per-button depth-strip thickness measurements. fajrulaslim UI Button Flat Design 4-5px depth strips.

**Personality served.** Pulse, Bubble, Burst gain visible "candy button" affordance; Slate and Daybreak stay quiet by design choice.

**Hue-count delta.** 0 directly; like C4, this lifts the *reading* of color presence by giving every accented affordance more visible depth.

**Godot 4.6 feasibility.**
- Pure data update inside `STYLE_PERSONALITY` (`addons/neocade_theme/scripts/neocade_theme.gd:913-1156`).
- Public export impact: **zero** — `raised_lifts` is internal personality data, not exported.
- Care needed: thicker primary lifts increase total button height. Cross-check against `MOBILE-DESIGN-SPEC.md` 44px minimum tap target — at primary_padding 16×10, primary lift 6 still leaves the face at 36px which would underrun the tap target. Solution: lift moves *inside* the existing tap target (the depth strip is part of the click region) rather than adding to total height.

**Aesthetic risk.** Low-medium. Thicker lifts on Pulse and Burst could read as "shouty"; need visual confirmation in 004 mockups.

**Effort.** XS — 5 dictionary value edits; visual check.

**Verdict.** ✓ **ADOPT** for Pulse, Bubble, Burst. Slate and Daybreak unchanged.

---

### C6 — Each direction gets ONE non-color, non-radius signature move

**Description.** Currently directions differ on color, radius, and minor padding. Force each direction to claim one *additional* axis that no other direction uses, so even greyscale-rendered all 5 directions read as distinct. Per direction:

- **Pulse — Tracked-uppercase kicker chrome.** `STYLE_PERSONALITY.shape.kicker_style: "uppercase-tracked-accent"` already exists but is not bound. Bind to a new `SectionKicker` type variation: tiny (10px), tracked (+0.08em), uppercase, accent-colored Label, used above section headings as a small overline. Pulse's only direction with this treatment.
- **Slate — Hairline borders everywhere.** Slate already uses `spread_factor=0.7`; extend to a "hairline mode": 1px borders on every interactive surface, 0.5px on every non-interactive surface. No other direction has visible 1px hairlines as a primary visual move.
- **Bubble — Forced pillow silhouette on every interactive class.** Currently only `primary_radius=999` is fully pilled; secondary 26 is rounded but not pillow. Extend so EVERY Bubble interactive control (Slider grabber, ScrollBar grabber, Tab, Chip, OptionButton) gets `999` or `26` minimum. Other directions never go below 8.
- **Daybreak — Soft halo on primary CTAs.** Add a 4px-thick `accent_color @ 12% alpha` outline ring around primary buttons (StyleBoxFlat outer-shadow simulated via an additional dilated stylebox). Survives the no-drop-shadow rule because it's a flat color ring, not a blurred shadow. No other direction has a halo treatment.
- **Burst — Oversized primary CTA.** Currently `primary_radius=28` is the biggest. Extend to `primary_min_height = 56px desktop / 64px mobile` (vs other directions' 40-48px). Burst's primary CTAs are visually 1.4× the size of other directions' — an unmistakable signature even in greyscale.

**References.** Per-direction personality intents in `THEME-DIRECTIONS.md`. Material Design 3 typography (kicker / overline). HCGames primary CTA hierarchy.

**Personality served.** All 5 — each direction gets exactly one.

**Hue-count delta.** 0 directly. But: the BRIEF says one measure of "game UI" vs "editor theme" is whether each direction is unmistakably distinct. Currently they aren't (the user's #1 complaint of #4 is "5 directions read as same theme + hex swap"). C6 fixes that on a non-color axis, which is the anti-fragile fix — if a colorblind reader looks at the showcase, they should still be able to name each direction.

**Godot 4.6 feasibility.**
- Pulse kicker: 1 new `SectionKicker` type variation. ~3 BINDING_TABLE rows.
- Slate hairlines: 1 new `STYLE_PERSONALITY.shape.hairline_thickness` constant (Slate=1, others=0). Updated stylebox borders.
- Bubble forced pillow: per-class radius floors in Bubble's `STYLE_PERSONALITY.shape`. ~5 entries.
- Daybreak halo: additional StyleBoxFlat per primary button — Godot supports stacked styleboxes via the BG and FG slot pair on most controls (or via a wrapping PanelContainer in consumer code; v1 may need to ship the wrapping pattern as a docs note rather than a Theme entry).
- Burst oversized: 1 new `STYLE_PERSONALITY.shape.primary_min_height` constant; bound to `Button.minimum_size_height`.

**Aesthetic risk.** Mixed. Pulse kicker / Slate hairlines / Bubble pillow / Burst oversized — all low-medium risk. **Daybreak halo is the riskiest** — flat 12%-alpha rings look fine on simple backgrounds but can clash on busy dialog stacks. Needs visual check in 004.

**Effort.** M — 5 mini-features. Each is small (XS-S) but they collectively touch all 5 directions. Estimate 4-6 hours including showcase additions.

**Verdict.** ✓ **ADOPT** for Pulse, Slate, Bubble, Burst. ⚠ **OPEN** for Daybreak halo — confirm in 004 before adopting.

---

## Summary Table

| # | Move | Bucket | Verdict | Hue Δ | Effort | Risk |
|---|---|---|---|---|---|---|
| C1 | Wire role tokens into normal-state chrome | hue-lift | **ADOPT** | +2 | S | Low |
| C2 | MD3 tonal-palette secondary/tertiary derivation | hue-lift | **OPEN** | +1-2 | M | Medium |
| C3 | Per-section panel-tinting type variations | hue-lift | **ADOPT** | +2-4 (consumer) | S-M | Low |
| C4 | HSV-darken depth formula (002b winner) | raised-fidelity | **ADOPT** | 0 | XS | Low |
| C5 | Per-direction lift thickness scaling | raised-fidelity | **ADOPT** (3 of 5) | 0 | XS | Low-Medium |
| C6 | Per-direction non-color signature (kicker / hairline / pillow / halo / oversized) | uniqueness | **ADOPT** (4 of 5) / **OPEN** (Daybreak halo) | 0 | M | Mixed |

**Coverage by direction.**

| Direction | Hue moves | Raised moves | Uniqueness moves | Total |
|---|---|---|---|---|
| Pulse | C1, C2, C3 | C4, C5 | C6 (kicker) | **6** |
| Slate | C1, C2, C3 | C4 | C6 (hairlines) | **5** |
| Bubble | C1, C2, C3 | C4, C5 | C6 (pillow) | **6** |
| Daybreak | C1, C2, C3 | C4 | C6 (halo, OPEN) | **5** |
| Burst | C1, C2, C3 | C4, C5 | C6 (oversized) | **6** |

Every direction is served by ≥5 moves. Every BRIEF mandate item is addressed.

### Surprises

1. **C3 has the highest leverage but lowest visibility on the showcase.** Per-section panel tinting is the convention that LDtk + every shipped game UI uses. NeoCade can provide it via 5 cheap type variations and zero public-export changes. The showcase doesn't change much, but VirtuCade and any consumer who attaches `LobbyPanel` to a PanelContainer instantly lifts their on-screen hue count by 2-4. This should be a Phase 12 priority even though it doesn't move the showcase number.

2. **C6 is the single highest-effort candidate but does the most for differentiation.** "Same theme + hex swap" is the user's #1 complaint about the 5 directions. Color/radius alone don't differentiate enough. C6's 5 sub-features each pick a non-color axis no other direction uses, so the directions remain distinct under colorblind / greyscale reads.

3. **C2 is the only candidate flagged OPEN purely on aesthetic risk.** Every other OPEN flag (Daybreak halo) is conditional on personality fit. C2's risk is "the math might produce ugly hues for some user palettes" — needs a visual check on the 5 default palettes plus ~3 stress-test custom palettes in spike 004.

### Signal for spike 004

Mock the following in spike 004 HTML mockups:
- **Showcase frame with C1 + C4 + C5 applied (all directions).** Headline: hue lift + depth fidelity, lowest-risk subset.
- **Showcase frame with C2 applied.** Verify tertiary derivation for all 5 directions doesn't produce ugly hues.
- **Daybreak frame with C6 halo applied.** Resolve the OPEN flag visually.
- **Side-by-side: current Pulse vs proposed Pulse with C1+C4+C5+C6.** The headline mockup the user can react to.

### Signal for Phase 12

The recommended Phase 12 scope, in implementation order:
1. C4 (XS, 6 lines, no risk) — closes raised-fidelity defect cheaply.
2. C5 (XS, data update) — pairs with C4 to make the affordance bold.
3. C1 (S, ~14 BINDING_TABLE rows) — lifts the headline number.
4. C3 (S-M, 5 type variations + docs) — unlocks consumer convention.
5. C6 (M, 5 mini-features) — seals direction uniqueness.
6. C2 (M, palette helper + per-direction calibration) — pending 004 confirmation.

Estimated total: 12-16 hours of focused implementation if mockups in 004 confirm all OPEN flags resolve to ADOPT.
