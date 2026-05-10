# Visual Identity Distinctiveness — Consolidated Spike Report

**Created:** 2026-05-10
**Spike series:** 001 + 002a + 002b + 003 + 004
**Driver question (from `BRIEF.md`):** Why does NeoCade feel like a Godot Editor theme — neutral, dense, tool-like — rather than a unique, characterful Game UI with stage presence?

This report consolidates the four executed spikes and presents a single recommendation for the planned post-v1 "Signature Visual Moves" phase. Every finding cites the underlying spike for traceability.

---

## TL;DR

The user's complaint is **real, measured, and directional**. NeoCade's 5 directions average **1.6 hues** per showcase frame; Slate and Daybreak read as a single hue. MD3 expects 3+; shipped flat-modern game UIs run 5+. The user's own original prototype runs at 5 — which means their intuitive target is the shipped game-UI convention as a *class*, not a specific product.

Six signature moves catalogued; four ADOPT outright, two OPEN flagged for visual confirmation in `004/mockup-signature-moves.html`. The mockup resolved both OPEN flags toward ADOPT. **Recommended Phase 12 scope = full set (C1+C2+C3+C4+C5+C6), 12-16 hours focused implementation.**

The BRIEF's framing of `_raised_depth_color`'s defect was *partially recanted* by spike 002: the formula's hue handling is fine; the actual defect is darkness (~23% drop where HCGames-style needs ~40%). The replacement (HSV value-darken) fixes the real defect cleanly.

---

## 1. Quantified the color monoculture (BRIEF Definition-of-Done #1)

**Source:** Spike 001 — `001-color-monoculture-diagnostic/`.

### Headline numbers

| Reference | Hues | Dominant swatches |
|---|---|---|
| **Pulse** | 2 | navy 95%, green 3% |
| **Slate** | 1 | navy 100% (accent below 1.2% saturation-weighted threshold) |
| **Bubble** | 2 | purple 96%, pink 3% |
| **Daybreak** | 1 | teal-green 99% (accent below threshold) |
| **Burst** | 2 | purple 94%, amber 5% |
| MD3 reference (synthetic) | 3 | navy 77%, error 17%, tertiary 4% |
| Mobile flat-modern game UI reference (synthetic) | 5 | indigo 71%, pink 10%, cyan 10%, gold 4%, green 4% |
| **NeoCade Prototype (`.planning/inputs/`)** | 5 | navy 69%, cyan 7%, violet 7%, magenta 6%, green 2% |

### Diagnosis

NeoCade's 5 directions average **1.6 hues** per showcase frame. **Two (Slate, Daybreak) measure 1 hue** — the accent appears in such small pixel area at such low saturation-weighted share that it doesn't survive a generous threshold. The user's "navy + navy + navy + navy + dot of green = 2 hues" reading is provably accurate.

| Gap | Hues |
|---|---|
| To MD3 spec floor | ~1.4 |
| To shipped flat-modern game UI conventions | ~3.4 |
| To the user's own original prototype | ~3.4 |

The prototype and the synthetic game-UI reference both measure 5 hues with very similar dominant-color shapes. **The user's intuitive target is shipped game UI as a class** — not any specific product, not the rejected painterly arcade direction.

---

## 2. Editor-vs-game gap stated concretely (BRIEF Definition-of-Done #2)

**Source:** Spikes 001, 003, 004.

The catalog (spike 003) identified six concrete moves where shipped game UIs differ from editor themes:

| Axis | Editor convention | Game UI convention | NeoCade today |
|---|---|---|---|
| Hue count per frame | 1-2 | 3-6 | **1-2** (matches editors) |
| Severity-coded chrome | rare (transient toasts only) | steady-state (HUD pills, severity stripes) | mostly absent (DangerButton only) |
| Per-section / role tinting | no (monochrome panels) | yes (LDtk per-layer; Royal Match per-mode) | no |
| Depth strip thickness | 0-2px | 4-6px | **2-3px** (editor end of spectrum) |
| Depth strip darkness | 10-20% | 40-50% | **18-24%** (editor end of spectrum) |
| Per-direction visual differentiation | minimal (color swap in editors) | strong (each "direction" has signature) | weak (5 directions read as same theme + hex swap) |

The mockup (`004/mockup-signature-moves.html`) renders Pulse current vs proposed side-by-side at the same showcase frame so the gap is visible, not just stated.

---

## 3. Catalogued candidate signature moves (BRIEF Definition-of-Done #3)

**Source:** Spike 003 — `003-per-direction-signature-move-catalog/`. **Visual confirmation:** Spike 004 — `004-signature-moves-html-mockups/mockup-signature-moves.html`. **User refinement:** see "User Refinement (2026-05-10)" section below.

### Original six candidates (as catalogued by spike 003)

| # | Move | Bucket | Original Verdict | Refined Verdict |
|---|---|---|---|---|
| **C1** | Wire `role_success / warning / danger / info` into normal-state chrome | hue-lift | ADOPT (default) | **OPT-IN only via type variation** |
| **C2** | MD3 secondary/tertiary palette derivation from accent_color | hue-lift | ADOPT | **DEFERRED** — user prefers existing accent surface more first; revisit as opt-in export |
| **C3** | Per-section panel-tinting type variations | hue-lift | ADOPT — semantic names (Lobby/Match/Danger/Warning/Success) | **ADOPT but GENERIC names only** — `AccentPanel` / `InfoPanel` / `WarningPanel` / `DangerPanel` / `SuccessPanel`; opt-in via type variation, never default |
| **C4** | HSV value-darken depth formula (= 002b winner) | raised-fidelity | ADOPT | ADOPT — but scoped: helps colored-button affordance only; does NOT fix Pulse mono-tint |
| **C5** | Per-direction lift thickness scaling | raised-fidelity | ADOPT | **DEFERRED** — re-evaluate after C2'+C6 ship; current lifts are already sizable |
| **C6** | Per-direction non-color/non-radius signature | uniqueness | ADOPT | ADOPT — unchanged |

### User Refinement (2026-05-10)

User reviewed the catalog + mockup and refined scope based on three principles:

1. **MD3-Expressive alignment over MD3-strict.** "MD3 Expressive does extremely well on adding expressive colors while being very purposeful and not excessive." → Color expansion must be PURPOSEFUL, not blanket.
2. **Accent appears too rarely in idle state.** The user's primary complaint reframes the headline diagnosis: the issue is not "we need more semantic colors" but "the existing accent_color is practically never visible unless there's a confirm button". Fix: make the EXISTING accent surface in more idle-state chrome (selected tabs, active section indicators, kicker text, ItemList row stripes, etc.) — NOT introduce new hues.
3. **Role colors must be purposeful and consumer-driven.** "Those states should be used with purpose only" — they should be opt-in via type variation, never auto-bound to widget defaults.

The original C1 framing of "wire role colors into normal-state chrome" was misleading; in practice it would have meant binding role hues to existing widget defaults (e.g., a hypothetical "DangerButton normal bg" auto-tinted red) — that violates the purposeful-color principle and would also be an accessibility risk. The refined C1 is opt-in type variations only.

C2 (MD3 secondary/tertiary derivation) introduces 2 new hues per direction with no consumer control, risking palette inconsistency. Deferred until user can opt in via a future `use_md3_extended_palette` export.

C5 (lift thickness bump) lacks evidence that the current lifts are too thin in practice — the perceived "lack of 3D feel" is more plausibly about lack of accent presence than depth-strip thickness. Deferred for follow-up spike after C2'+C6 ship.

### Refined candidate set

| # | Move | Default? | Effort | Wins on |
|---|---|---|---|---|
| **C2'** *(new, replaces C2)* | Accent expansion in idle chrome: rebind selected TabBar indicator, selected ItemList/Tree row left-stripe, kicker text color, active section indicators, slider/range value labels, section-header underlines to use `accent_color` | Yes (rebinds existing BINDING_TABLE rows) | 2-3h | **HEADLINE FIX** — addresses "accent appears practically never" without introducing new hues |
| **C6** | Per-direction signature moves (Pulse uppercase-tracked kicker / Slate 1px hairlines / Bubble forced ≥26 radius / Daybreak 4px soft halo / Burst oversized 56-64px primary CTAs) | Yes (per-direction `STYLE_PERSONALITY` edits) | 4-6h | 5 directions read uniquely beyond color+radius |
| **C4** | HSV value-darken depth formula at strength `0.20 + 0.10 × raised_strength` | Yes (replaces `_raised_depth_color`) | ~30 min | Same-hue darker shadow strips on colored buttons (accent fills, role-colored CTAs). Does NOT help dark-tonal neutral buttons (face and depth converge into base_color — but those are quiet UI and don't need strong depth) |
| **C1** *(refined)* | Generic role Label type variations: `SuccessLabel` / `WarningLabel` / `DangerLabel` / `InfoLabel` | **Opt-in only** — consumer applies via `theme_type_variation`, never bound to widget defaults | 1.5h | Available semantic chrome when consumer needs it; showcase demos them |
| **C3** *(refined)* | Generic role Panel type variations: `AccentPanel` / `InfoPanel` / `WarningPanel` / `DangerPanel` / `SuccessPanel` | **Opt-in only** — consumer applies via `theme_type_variation`, never bound to widget defaults | 2-3h | Available role-tinted panels when consumer needs them; showcase demos them |
| ~~C2~~ | MD3 secondary/tertiary auto-derivation | **DEFERRED** | — | — |
| ~~C5~~ | Lift thickness bump | **DEFERRED** | — | — |

Per-candidate rationale, references, feasibility analysis, aesthetic-risk assessment, and Phase 12 implementation snippets are documented in detail at `003-per-direction-signature-move-catalog/README.md` (one section per candidate).

### Coverage

| Direction | Hue moves | Raised moves | Uniqueness moves | Total |
|---|---|---|---|---|
| Pulse | C1, C2, C3 | C4, C5 | C6 (uppercase-tracked kicker) | **6** |
| Slate | C1, C2, C3 | C4 | C6 (1px hairline borders) | **5** |
| Bubble | C1, C2, C3 | C4, C5 | C6 (forced pillow ≥26 radius) | **6** |
| Daybreak | C1, C2, C3 | C4 | C6 (4px soft halo on primary CTAs) | **5** |
| Burst | C1, C2, C3 | C4, C5 | C6 (oversized 56-64px primary CTAs) | **6** |

Every direction served by ≥5 moves. Every BRIEF mandate item addressed. Every candidate passes the constraint filter (no shaders, no textures, no gradients, no animations, no public-export breakage).

---

## 4. Throwaway HTML mockup (BRIEF Definition-of-Done #4)

**Deliverable:** `004-signature-moves-html-mockups/mockup-signature-moves.html` — single self-contained file, 31 KB, opens in any browser.

Six sections:
1. **Hero — Pulse current vs proposed.** Side-by-side. The proposed cell shows ~5 visible hues (navy + accent + success + warning + info-tinted panel + danger dot) where current shows 2.
2. **All 5 directions current vs proposed.** Each direction in a mini showcase. Confirms uniqueness — even at thumbnail scale, each proposed cell reads distinctly.
3. **C2 MD3 palette derivation.** Per-direction `accent → secondary → tertiary` swatches. All 5 default tertiaries look deliberate — visually resolved the OPEN flag toward ADOPT.
4. **C3 panel tinting demo.** 5 role-coded panels (LobbyPanel, MatchPanel, DangerPanel, WarningPanel, SuccessPanel) on Pulse base. The 6%-mix tint reads unambiguously without changing the dark identity.
5. **C6 per-direction signature isolation.** Daybreak halo reads as soft welcoming decoration, not as focus state — visually resolved that OPEN flag toward ADOPT.
6. **Recommendation footer.**

The mockup uses real Pulse / Slate / Bubble / Daybreak / Burst base + accent + panel tones (sourced from `addons/neocade_theme/scripts/neocade_theme.gd:913-1156`), not approximations. The HSV value-darken math (C4) and the panel tint mix (C3) are reproduced in CSS using `colorsys.rgb_to_hsv` so the cells render the proposed math exactly.

---

## 5. Recommendation (BRIEF Definition-of-Done #5)

**Phase 12 scope (refined by user 2026-05-10): adopt C2'+C6+C4 as default behavior; C1+C3 as opt-in type variations; defer C2 and C5.**

**Phase 12 implementation order:**

1. **C4** — XS, ~6 lines replacing `_raised_depth_color`. Helps colored-button affordance. (~30 min)
2. **C2'** — S, rebind existing BINDING_TABLE rows to use `accent_color` in more idle-state slots: selected TabBar indicator, selected ItemList/Tree row left-stripe, kicker color, active section indicators, slider/range value labels, section-header underlines. The HEADLINE FIX. (~2-3h)
3. **C6** — M, 5 mini-features (one per direction). Seals direction uniqueness. (~4-6h)
4. **C1** — S, register 4 generic Label type variations (`SuccessLabel` / `WarningLabel` / `DangerLabel` / `InfoLabel`) with role-color bindings. Opt-in only. Showcase demos them. (~1.5h)
5. **C3** — S-M, register 5 generic Panel type variations (`AccentPanel` / `InfoPanel` / `WarningPanel` / `DangerPanel` / `SuccessPanel`) with role-tint bindings. Opt-in only. Showcase demos them. (~2-3h)

**Total estimate: 10-13 hours focused implementation.** Plus ~2 hours of showcase scene additions to demonstrate the new chrome (accent now visible in idle state via C2'; opt-in role labels/panels in a "Role Variations" showcase section).

**Deferred to follow-up spikes:**
- **C2 (MD3 secondary/tertiary auto-derivation)** — introduces 2 new hues per direction; user prefers existing accent to surface more often first. Revisit as opt-in export (e.g., `use_md3_extended_palette: bool`) after Phase 12 ships and the accent-expansion fix is validated in practice.
- **C5 (lift thickness bump)** — no evidence current lifts are too thin once C2' lifts accent presence and C6 differentiates directions. Re-evaluate visually after Phase 12 ships; only re-open if the "3D game UI" feel still doesn't land.
- **Surface tonal range expansion** (user idea: "HSV value range with more brightness also") — separate spike. Would lift face brightness across the 5-stop ramp so dark themes like Pulse have more contrast between panel and button. Higher risk than C4 because it touches every surface stop.

### Public API impact

**Zero breaking changes** to the 12-export public contract. Every candidate is implemented inside `STYLE_PERSONALITY`, `BINDING_TABLE`, or new internal helpers. No new top-level `@export var` is required by any candidate.

### Backwards compatibility

Existing consumer code that uses `Style.PULSE` / `Style.SLATE` / etc. with default exports gets the new visual moves automatically. Consumers who use `Style.CUSTOM` and override every value get a graceful fallback (C2's tertiary derivation has a per-direction safety hatch; C3's tinted panels are opt-in via type variation; C6's per-direction signatures are gated on the explicit `style` enum).

### Showcase scene additions

The current `showcase/showcase.tscn` does not currently exercise:
- Accent in idle-state chrome (selected tabs, ItemList stripes, kicker text) — needed to demo C2'
- Section kickers (C6 Pulse signature)
- Opt-in role labels (`SuccessLabel` / `WarningLabel` / `DangerLabel` / `InfoLabel` — C1)
- Opt-in role panels (`AccentPanel` / `InfoPanel` / `WarningPanel` / `DangerPanel` / `SuccessPanel` — C3)

The role labels and panels should be shown in a dedicated "Role Variations" showcase section so consumers see they exist without forcing them into the baseline chrome. Showcase additions are part of the Phase 12 scope, not separate work.

### What this report does NOT decide

- Real-device Android / iOS validation of the new chrome — that remains the deferred-from-v1 obligation in `STATE.md`.
- Light-color-mode variants — still v2 deferred per PROJECT.md.
- Whether to add a `secondary_color` public export — explicitly *not* recommended; C2 derives secondary from `accent_color` instead, preserving the 12-export contract.

---

## 6. Hand-off

When the user is ready to proceed:

```
/gsd-phase add "Signature Visual Moves" --before <next-version>
/gsd-discuss-phase signature-visual-moves
/gsd-plan-phase signature-visual-moves
```

Phase context inputs (read-only references):

- `.planning/spikes/MANIFEST.md` — overall spike index
- `.planning/spikes/visual-identity-distinctiveness/BRIEF.md` — original mandate
- `.planning/spikes/visual-identity-distinctiveness/REPORT.md` — this report
- `.planning/spikes/visual-identity-distinctiveness/001-color-monoculture-diagnostic/README.md` — diagnostic numbers
- `.planning/spikes/visual-identity-distinctiveness/002a-raised-depth-formula-current/README.md` — what the current formula does + the BRIEF recantation
- `.planning/spikes/visual-identity-distinctiveness/002b-raised-depth-formula-hsv-darken/README.md` — winner formula + Phase 12 snippet
- `.planning/spikes/visual-identity-distinctiveness/003-per-direction-signature-move-catalog/README.md` — full catalog with feasibility, references, effort
- `.planning/spikes/visual-identity-distinctiveness/004-signature-moves-html-mockups/mockup-signature-moves.html` — visual evidence

Phase 12 owns all addon code edits. The spike series produces only `.planning/`-scoped artifacts.
