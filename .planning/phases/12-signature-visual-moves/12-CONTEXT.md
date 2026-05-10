# Phase 12: Signature Visual Moves — Context

**Gathered:** 2026-05-10
**Status:** Ready for planning
**Source:** Visual Identity Distinctiveness spike series (001–005), locked by user across 8+ revision rounds and split into Phase 12 (defaults) + Phase 13 (opt-ins) on 2026-05-10. This phase covers Phase 12 only — Phase 13 (C1 role labels + C3 role panels + showcase additions) is a separate phase.

<domain>
## Phase Boundary

Phase 12 implements **three default-behavior signature visual moves** that resolve the user's "generic dark Godot theme with an accent color" complaint surfaced in the 2026-05-10 production-readiness audit. The three moves are:

- **C4** — Replace `_raised_depth_color` with HSV value-darken (raised-fidelity / colored-button affordance fix).
- **C2'** — Rebind ~6–8 existing `BINDING_TABLE` slots to use `accent_color` in idle-state chrome (the **headline fix** for "accent appears practically never").
- **C6** — Give each of the 5 directions ONE non-color, non-radius signature move via `STYLE_PERSONALITY` edits (per-direction uniqueness — the greyscale-thumbnail-identifiable gate).

**Scope owned by Phase 12 (in this phase):**
- All edits to `addons/neocade_theme/scripts/neocade_theme.gd` (single concrete `NeoCadeTheme` class).
- BINDING_TABLE rebinds for C2' (no new bindings — only re-targets existing rows from neutral tokens to `accent_color`).
- `STYLE_PERSONALITY` shape edits for C6 per direction.
- Showcase scene additions sufficient to demo C2' accent presence + C6 Pulse kicker chrome.
- Greyscale-thumbnail verification gate for C6 (each direction identifiable without color cues).
- 30-config smoke regression to confirm zero public-export contract change.

**Out of scope (Phase 13 or deferred):**
- **C1** — Role Label type variations (`SuccessLabel` / `WarningLabel` / `DangerLabel` / `InfoLabel`). DEFERRED to Phase 13.
- **C3** — Role Panel type variations (`AccentPanel` / `InfoPanel` / `WarningPanel` / `DangerPanel` / `SuccessPanel`). DEFERRED to Phase 13.
- **C2** — MD3 secondary/tertiary auto-derivation. DEFERRED to a future spike + opt-in export (`use_md3_extended_palette: bool`). Phase 12 explicitly uses C2' (redistribute existing accent) NOT C2 (introduce new hues).
- **C5** — Per-direction lift thickness scaling. DEFERRED for re-evaluation after Phase 12 ships.
- **Surface tonal range expansion** — separate post-Phase-12 spike candidate.
- New top-level `@export var` properties — **forbidden** by locked success criterion #6.
- Light color mode, alternate palettes, real-device device QA — all remain post-v1 deferred per STATE.md.
- Asset Library submission, plugin.cfg, editor plugin — not on the v1 roadmap.

</domain>

<decisions>
## Implementation Decisions

### C4 — HSV value-darken depth formula (raised-fidelity)

- **D-12.01** Replace the body of `_raised_depth_color(element: Color, base_c: Color) -> Color` at [neocade_theme.gd:800-806](addons/neocade_theme/scripts/neocade_theme.gd:800) with the HSV value-darken formula from spike 002b. `base_c` stays in the signature for callsite compatibility but is **unused** (decoupling depth from surface is intentional per HCGames anchor — depth strips stay in the button's hue family, not the surface tonal ramp).
- **D-12.02** Use this exact body:
  ```gdscript
  func _raised_depth_color(element: Color, base_c: Color) -> Color:
      var strength: float = 0.20 + 0.10 * float(raised_strength)
      var h: float = element.h
      var s: float = element.s
      var v: float = element.v * (1.0 - strength)
      var result := Color.from_hsv(h, s, max(v, 0.04))
      result.a = element.a
      return result
  ```
  Strength curve: `raised_strength=0 → 20%`, `=1 → 30%`, `=2 → 40%`, `=3 → 50%` value-darken. The `max(v, 0.04)` floor prevents already-very-dark element colors from clamping to black at high strength.
- **D-12.03** No callsite changes — every existing call to `_raised_depth_color` continues to work because the signature is preserved.
- **D-12.04** Verification target: hue rotation across all five direction palettes × accent/role colors × disabled colors measures `0.0°` (within float epsilon). Saturation drop `0%`. Value drop `= strength` exactly. Numbers per spike 002b iteration 2.
- **D-12.05** Hard gate from spike 002b: this move only fires when `raised=true`. When `raised=false`, the existing zero-3D code path is preserved (locked success criterion #1).

### C2' — Accent expansion in idle chrome (headline fix)

- **D-12.06** **The headline fix.** Rebind existing `BINDING_TABLE` rows to use `accent_color` (or `accent_offset` / `accent_subtle` per existing helpers) in **idle state** for the following six surface families. No new bindings — only re-targets the color side of existing rows from neutral/surface tokens to accent-derived tokens. Same palette per direction — accent simply gets more airtime.
- **D-12.07** The six C2' rebind targets (final list, locked):
  1. **Selected TabBar / TabContainer top stripe** — the `tab_selected` stylebox's top-edge accent stripe currently reads as the same chrome as unselected tabs. Rebind to `accent_color`.
  2. **Selected ItemList row left-stripe** — ItemList `selected` / `selected_focused` stylebox's left-edge border or accent fill should pull from `accent_color`, replacing the current neutral selection treatment.
  3. **Selected Tree row left-stripe** — Tree `selected` / `selected_focused` selection chrome should also pull `accent_color` for the row indicator (consistent with ItemList per Phase 6 convention).
  4. **Section kicker text color** — wherever a kicker / overline label is rendered, its `font_color` should resolve to `accent_color` (currently neutral). This becomes the visual hook for the Pulse C6 kicker signature.
  5. **Slider / Range value labels** (active state) and **active section indicators** — active value/section indicators should read accent-tinted.
  6. **Section-header underlines** — any `separator` / underline chrome under section headers should pick `accent_color` (or the existing `_tint_toward_base(accent, 0.30)` helper if full accent reads too loud).
- **D-12.08** Rebinds happen by editing existing `BINDING_TABLE` entries (not adding new rows). Each rebind preserves the existing slot name, type, and recipe shape — only the source-color token changes. The planner must identify the existing rows in the 37-key BINDING_TABLE freeze (Cycle 1 C1) and rewire the color source.
- **D-12.09** Hue invariant (locked success criterion #5): no new hues are introduced. Every C2' change must use `accent_color`, `accent_offset`, or `accent_subtle` — never a fresh `Color()` literal and never a derived hue rotation.
- **D-12.10** Mobile path: existing platform branch in `_regenerate_theme()` continues to apply; C2' rebinds must hold on both DESKTOP and MOBILE paths.

### C6 — Per-direction non-color/non-radius signature moves (uniqueness)

- **D-12.11** Each direction gets exactly ONE C6 signature move. The move must be on an axis NO other direction uses, so even greyscale renders make each direction identifiable. Coverage per direction:

| Direction | C6 Move | STYLE_PERSONALITY Edit |
|---|---|---|
| **Pulse** | Tracked-uppercase kicker chrome on `SectionKicker` Label variation | `shape.kicker_style` already `&"uppercase-tracked-accent"` — bind via new `SectionKicker` type variation (10px, uppercase, ~+0.08em tracking, accent-colored). |
| **Slate** | 1px hairline borders on every interactive surface + quiet-pill primary | Add `shape.hairline_thickness = 1` (others = 0); update stylebox borders to use this value when set. |
| **Bubble** | Forced ≥26 corner radius across ALL chrome (pillow silhouette everywhere) | Floor `secondary_radius`, `tab_radius`, `chip_radius`, `card_radius`, `hero_radius`, and any other radius-bearing personality keys to `max(existing, 26)`; primary stays 999 pill. Sliders/scrollbars use 999 grabbers. |
| **Daybreak** | 1px outer mint outline on primary buttons (3px offset) + generous primary padding | **NO halo, NO glow.** The 2026-05-10 user constraint reverted the original halo design. Use a flat 1px outline drawn 3px outside the primary stylebox edge (StyleBoxFlat outline; matches no-shadow rule) + bump primary_padding to a generous value (e.g., `Vector2i(20, 14)` vs current `Vector2i(15, 9)`). |
| **Burst** | Oversized 56–64px primary CTAs with thicker depth strip | Add `shape.primary_min_height = 56` desktop / `64` mobile; bound to `Button.minimum_size.height` for primary slots only. Burst's existing `raised_lifts.primary = 3` stays. |

- **D-12.12** **Locked invariant (success criterion #1):** `raised=false` must show ZERO 3D elements anywhere. Every C6 move must verify it leaves a flat result when `raised=false` — no depth strips, no halos, no glows, no bevels, no offset duplicates. (Pulse kicker, Slate hairlines, Bubble pillow, Daybreak outline, Burst oversized are all flat-compatible by design — the planner must double-check stylebox stacking does not leak depth when `raised=false`.)
- **D-12.13** **No glow halos** (success criterion #3, locked from PROJECT.md out-of-scope). Daybreak's original spike-003 halo proposal was reverted. Outline + padding is the locked replacement.
- **D-12.14** Greyscale-thumbnail-identifiable gate (success criterion #4): every direction must be identifiable at small scale without color cues. Verification is a render-and-greyscale comparison across all 5 directions; if any two directions are mistakable in greyscale, the corresponding C6 move must be strengthened.
- **D-12.15** C6 changes live in `STYLE_PERSONALITY` and its dependent recipe code (where stylebox borders, kickers, and primary-min-height are resolved). Keep the existing per-direction values; add only what each direction's signature requires.

### Public API and contract invariants (locked)

- **D-12.16** **Zero public-export changes.** The 12-export contract (`style`, `raised`, `platform`, `base_color`, `accent_color`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`, `use_runtime_popup_selection_icons`, `texture_cache`) is preserved. Any new constant introduced for C6 (`hairline_thickness`, `primary_min_height`, etc.) lives inside `STYLE_PERSONALITY.shape`, not as a new `@export`.
- **D-12.17** `Style.CUSTOM` graceful fallback: when consumers use `Style.CUSTOM`, C6 moves are gated on the explicit style enum (they're keyed by `Style.PULSE` / `Style.SLATE` / etc.); CUSTOM gets the default personality with no C6 signature. C2' rebinds apply universally because they only redistribute `accent_color` (which CUSTOM has).
- **D-12.18** Existing 5 styles in `addons/neocade_theme/neocade_theme.tres` re-render with new visuals automatically on next theme regenerate; no `.tres` migration required.
- **D-12.19** No new SVGs are required by Phase 12 (kicker / outline / oversized CTA / hairline / pillow are all stylebox + Label work).
- **D-12.20** **Mid-phase fallback if execution runs long:** after C4 + C2' (~3–4h), the headline complaint is resolved. C6 may defer to a follow-up phase if the wave runs out of budget. Wave-1 = C4 alone (~30 min, atomic). Wave-2 = C2' (~2–3h, headline). Wave-3 = C6 (~4–6h, per-direction). The planner should structure plans so a partial completion at C4 + C2' still leaves a shippable state.

### Showcase additions (Phase 12 scope)

- **D-12.21** Demo Pulse's `SectionKicker` chrome in the existing "Buttons" or a new "Identity" section of `showcase/showcase.tscn`. The kicker text should read at the accent color above section headings.
- **D-12.22** C2' changes are visible automatically in existing showcase chrome (selected tabs, ItemList selection, Tree selection, sliders, section headers).
- **D-12.23** No new opt-in role variations are demoed (those belong to Phase 13). The showcase remains a baseline-chrome demo, not a type-variation demo.

### Verification gates (locked success criteria, all six)

- **D-12.24** **SC#1 — `raised=false` ZERO 3D.** Verification: snapshot each direction with `raised=false`; pixel-diff against a reference that contains no depth strips / halos / bevels. Hard gate.
- **D-12.25** **SC#2 — `raised=true` keeps current lift subset.** Panels and buttons lift; tabs stay flat. Verification: confirm `raised_lifts.selected_tab`, `unselected_tab` and TabBar/TabContainer styleboxes do not gain depth.
- **D-12.26** **SC#3 — No glow halos in any state.** Verification: no `Color()` with alpha `< 1.0` and `> 0.0` is bound as an outline / shadow / outer-border slot. Outline borders are full-alpha 1px (Daybreak) or absent.
- **D-12.27** **SC#4 — Greyscale thumbnail-identifiable.** Verification: render each direction at 256×144, convert to greyscale, present 5 thumbnails to user. Each must be identifiable by direction name. Bubble pillow + Burst oversized + Slate hairline are strong by construction; Pulse kicker + Daybreak outline-padding need verification render.
- **D-12.28** **SC#5 — No new hues introduced.** Verification: extract every `Color()` literal touched by Phase 12 commits; confirm each resolves to `base_color`, `accent_color`, or existing per-direction surface tokens. No fresh hex values.
- **D-12.29** **SC#6 — Zero public-export changes.** Verification: count `@export` declarations in `neocade_theme.gd` before and after Phase 12 — must equal 12. The `NeoCadeThemeOptionButton` and `neocade_theme.tres` resource shape are unchanged.

### Claude's Discretion

- The exact stylebox-stacking technique for Daybreak's outline (StyleBoxFlat `border_width_*` + outer offset vs. StyleBoxFlat `expand_margin_*`) — pick the simplest path that respects no-shadow rules. Document the choice in the relevant plan.
- The exact Pulse `SectionKicker` Label registration (extending `Label` via `theme_type_variation` vs a new TYPE_VARIATIONS entry) — match the existing TYPE_VARIATIONS pattern. Note: `SectionKicker` may live in the C6 wave OR be deferred — if it overlaps too much with Phase 13's role-label TYPE_VARIATIONS, register it minimally here and let Phase 13 build on the precedent.
- The exact ordering of BINDING_TABLE rebinds for C2' (alphabetical vs by Control class vs by surface family) — match the existing BINDING_TABLE convention.
- Greyscale-thumbnail verification tooling (Godot CLI render + ImageMagick desaturate vs runtime screenshot helper) — pick whatever the existing Phase 9 showcase tooling supports.
- 30-config smoke matrix dimensions (style × raised × platform × base_color × accent_color) — derive from existing Phase 4 verify helpers if feasible; otherwise hand-curate ~30 representative configs.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Spike series (decision provenance — read in order)
- `.planning/spikes/visual-identity-distinctiveness/BRIEF.md` — original mandate framing the "generic theme" complaint and the four BRIEF Definition-of-Done axes.
- `.planning/spikes/visual-identity-distinctiveness/REPORT.md` — consolidated spike report with the final 5 locked success criteria, the User Refinement (2026-05-10), and the Phase 12/13 split rationale.
- `.planning/spikes/visual-identity-distinctiveness/001-color-monoculture-diagnostic/README.md` — the 1.6-hue diagnostic, MD3 spec floor, NeoCade vs prototype hue-count tables.
- `.planning/spikes/visual-identity-distinctiveness/002b-raised-depth-formula-hsv-darken/README.md` — C4 formula verdict, 6-line implementation snippet, calibration via `raised_strength`.
- `.planning/spikes/visual-identity-distinctiveness/003-per-direction-signature-move-catalog/README.md` — full catalog of all six candidates with feasibility, references, effort, aesthetic-risk per candidate. Section "C6" enumerates the per-direction signature variants.
- `.planning/spikes/visual-identity-distinctiveness/004-signature-moves-html-mockups/mockup-signature-moves.html` — visual evidence of the candidate moves; resolved the OPEN flags.
- `.planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/mockup-refined-plan.html` — the AFTER-state mockup that is the visual contract for Phase 12 execution.
- `.planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/comparison.html` — the BEFORE-state baseline.

### Project decisions / locked architecture
- `CLAUDE.md` — visual identity locked 2026-05-04 (flat MD3 / no textures / no patterns / no gradients on chrome / no synthwave / no pixel art / no glow halos); 12-export current architecture.
- `.planning/STATE.md` — STATE entry tracking the post-v1 visual-identity initiative; v1 mechanically ship-ready status; UATs closed by user attestation 2026-05-10.
- `.planning/PROJECT.md` — out-of-scope rules (no glow halos, no shadows, no gradients on chrome, no patterns/textures).
- `.planning/ROADMAP.md` — Phase 12 overview (lines 81–143) and Phase 12 structured entry (lines 585+).
- `.planning/DESIGN_TOKENS.md` — per-direction palette + shape language already in production.
- `.planning/MOBILE-DESIGN-SPEC.md` — mobile-sizing tokens (tap-target floors must hold).

### Implementation surface (read before editing)
- `addons/neocade_theme/scripts/neocade_theme.gd:800-806` — current `_raised_depth_color` to be replaced (C4).
- `addons/neocade_theme/scripts/neocade_theme.gd:913-1156` — `STYLE_PERSONALITY` per-direction dictionaries to edit (C6).
- `addons/neocade_theme/scripts/neocade_theme.gd:1212-1759` — `TYPE_VARIATIONS` dictionary, location for any new SectionKicker Label variation.
- `addons/neocade_theme/scripts/neocade_theme.gd:1760+` — `BINDING_TABLE` 37-row canonical scorecard. C2' rebinds happen here. The 37-key freeze (Cycle 1 C1) must be preserved — only color sources change, not the row count.
- `addons/neocade_theme/scripts/neocade_theme.gd:1158-1211` — `STYLE_PERSONALITY_DEFAULT` fallback for `Style.CUSTOM` users.
- `addons/neocade_theme/neocade_theme.tres` — canonical resource (regenerates automatically; no migration).
- `addons/neocade_theme/scripts/neocade_theme_option_button.gd` — reusable style picker (UNTOUCHED by Phase 12).
- `showcase/showcase.tscn` — showcase scene; demo C2' visibility (automatic) + Pulse kicker (one-line scene edit + one `SectionKicker` label).

### Verification reference points
- Phase 4 verify helpers (`addons/neocade_theme/scripts/...` and `.planning/phases/04-.../helpers/`) for the dual EditorScript + headless verify pattern.
- Phase 9 showcase verify infrastructure for thumbnail rendering.

</canonical_refs>

<specifics>
## Specific Ideas

### Concrete C4 implementation (verbatim from spike 002b)
```gdscript
func _raised_depth_color(element: Color, base_c: Color) -> Color:
    var strength: float = 0.20 + 0.10 * float(raised_strength)
    var h: float = element.h
    var s: float = element.s
    var v: float = element.v * (1.0 - strength)
    var result := Color.from_hsv(h, s, max(v, 0.04))
    result.a = element.a
    return result
```

### Concrete C2' rebind list (six families — must be addressed)
1. TabBar `tab_selected` top stripe → accent
2. TabContainer `tab_selected` top stripe → accent
3. ItemList `selected` / `selected_focused` row indicator → accent
4. Tree `selected` / `selected_focused` row indicator → accent
5. Section `Kicker` label `font_color` (Pulse uses uppercase-tracked; other directions inherit accent kicker color)
6. Slider / Range active value label `font_color` → accent
7. Section-header underline (`separator` / heading-rule) → accent or `_tint_toward_base(accent, 0.30)` if full accent reads too loud

(The list intentionally exceeds 6 to bound the planner — the locked count is 6–8.)

### Concrete C6 per-direction edits

**Pulse** — `STYLE_PERSONALITY[Style.PULSE].shape.kicker_style` is already `&"uppercase-tracked-accent"`; bind it via a new `SectionKicker` entry in `TYPE_VARIATIONS` (extends Label, 10px font_size, +0.08em tracking via `font_constants` if supported, accent `font_color`). Approximate ~3 BINDING_TABLE rows added for the kicker font/color/size.

**Slate** — add `hairline_thickness: 1` to `STYLE_PERSONALITY[Style.SLATE].shape`; update relevant `_make_stylebox` recipes to read this when set (others have it as 0 / absent). Adjust primary radius/strategy to "quiet-pill" if it isn't already — note Slate already uses `quiet-pill`, so this is a verification/no-op.

**Bubble** — floor `secondary_radius`, `tab_radius`, `chip_radius`, `card_radius`, `hero_radius` to `max(existing, 26)`; current values already match (`secondary_radius: 26`, `tab_radius: 999`, `chip_radius: 999`, `card_radius: 26`, `hero_radius: 26`). The C6 edit is primarily ensuring sliders/scrollbar grabbers and any OptionButton/CheckBox shape also respect `≥26`. Add `min_radius_floor: 26` for Bubble; thread through stylebox builders.

**Daybreak** — bump `primary_padding` from `Vector2i(15, 9)` to `Vector2i(20, 14)` (generous primary padding). Add `shape.primary_outline_color: &"accent"` and `shape.primary_outline_offset: 3` + `shape.primary_outline_width: 1`. Thread through the primary-stylebox builder to draw a 1px flat accent outline at 3px outer offset. **Verify the outline is full-alpha and not blurred** (no halo, success criterion #3).

**Burst** — add `shape.primary_min_height: 56` (desktop) / `64` (mobile). Thread through Button minimum_size resolver; ensure only `primary` slots (primary buttons) pick this up — not secondary/ghost/chip. Burst's existing thicker depth strip (`raised_lifts.primary = 3`) is preserved; C4 will automatically make it read more strongly via the new HSV darken.

### Existing patterns to follow
- The `STYLE_PERSONALITY` per-direction shape dict was extended for Phase 6 (Tree/ItemList) and Phase 7 (Popup/Dialog) — new keys are added per direction; absent keys fall back to `STYLE_PERSONALITY_DEFAULT`. Phase 12 follows the same pattern.
- `BINDING_TABLE` rebinds preserve row count (Cycle 1 C1 freeze at 37 keys) and slot-name freeze (Cycle 2 C1 at 22 Controls × CANONICAL_SLOT_NAMES). Only the color source changes.
- Verify helpers live in `.planning/phases/XX-.../helpers/_phaseXX_verify.gd` and `_phaseXX_verify_headless.gd` (dual EditorScript + headless), per the Phase 4 precedent.

</specifics>

<deferred>
## Deferred Ideas

These are ideas surfaced during the spike series that are explicitly NOT in Phase 12. The planner must NOT include any of these in plans:

- **C1 — Role Label type variations** (`SuccessLabel` / `WarningLabel` / `DangerLabel` / `InfoLabel`). Deferred to Phase 13.
- **C3 — Role Panel type variations** (`AccentPanel` / `InfoPanel` / `WarningPanel` / `DangerPanel` / `SuccessPanel`). Deferred to Phase 13.
- **C2 — MD3 secondary/tertiary auto-derivation from accent** (introduces 2 new hues per direction). Rejected by user 2026-05-10 in favor of C2' (which redistributes existing accent without new hues). Revisit only as opt-in `use_md3_extended_palette: bool` export in a future spike.
- **C5 — Per-direction lift thickness scaling** (HCGames-style 4–6px depth strips). No evidence the current 2–3px lifts are too thin once C2' lifts accent presence and C6 differentiates directions. Defer; re-open only if the "3D game UI" feel still doesn't land after Phase 12 ships.
- **Surface tonal range expansion** (user idea: HSV value-range lift for surface ramp). Separate spike candidate; would touch every surface stop and is higher risk than C4.
- **Light color mode** (still v2 deferred per PROJECT.md).
- **Real-device Android / iOS validation** of the new chrome (deferred-from-v1 obligation in STATE.md; closed by user attestation 2026-05-10).
- **Asset Library submission** (not on v1 roadmap).
- **New top-level `@export` properties** (would violate locked success criterion #6).
- **Bespoke severity SVGs** (Phase 12+1 polish; not in Phase 12 or 13).
- **Halo / glow / shadow** chrome (locked out by PROJECT.md and success criterion #3 — the original Daybreak halo design was explicitly reverted to outline + padding).
- **Animations beyond Godot StyleBox transitions** (out-of-scope per spike constraint filter).

</deferred>

---

*Phase: 12-signature-visual-moves*
*Context gathered: 2026-05-10 via spike series consolidation (no interactive discuss-phase — the 8+ revision rounds during spike series 001–005 served as the discussion).*
