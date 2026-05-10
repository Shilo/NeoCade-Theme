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

**Source:** Spike 003 — `003-per-direction-signature-move-catalog/`. **Visual confirmation:** Spike 004 — `004-signature-moves-html-mockups/mockup-signature-moves.html`.

### Six candidates

| # | Move | Bucket | Verdict | Hue Δ | Effort | Risk |
|---|---|---|---|---|---|---|
| **C1** | Wire `role_success / warning / danger / info` into normal-state chrome | hue-lift | ADOPT | +2 | S | Low |
| **C2** | MD3 secondary/tertiary palette derivation from accent_color | hue-lift | ADOPT (was OPEN; visually confirmed in 004) | +1-2 | M | Medium |
| **C3** | Per-section panel-tinting type variations (Lobby / Match / Danger / Warning / Success) | hue-lift | ADOPT | +2-4 in consumer UIs | S-M | Low |
| **C4** | HSV value-darken depth formula (= 002b winner) | raised-fidelity | ADOPT | 0 | XS (6 lines) | Low |
| **C5** | Per-direction lift thickness scaling (Pulse 2→4, Bubble 3→5, Burst 3→6; Slate, Daybreak unchanged) | raised-fidelity | ADOPT | 0 | XS | Low-Medium |
| **C6** | Per-direction non-color/non-radius signature (kicker / hairline / forced-pillow / halo / oversized) | uniqueness | ADOPT — Daybreak halo OPEN→ADOPT confirmed in 004 | 0 | M | Mixed |

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

**Phase 12 scope: ADOPT all six candidates (C1, C2, C3, C4, C5, C6).**

Both OPEN flags resolved toward ADOPT in spike 004:
- **C2** — All 5 default-palette tertiary derivations look deliberate and on-brand.
- **C6 Daybreak halo** — Reads as soft welcoming decoration; does not clash with the focus state.

**Phase 12 implementation order (per spike 003 effort estimates):**

1. **C4** — XS, ~6 lines replacing `_raised_depth_color`. Closes the raised-fidelity defect cheaply. (≤30 min)
2. **C5** — XS, 5 dictionary value edits in `STYLE_PERSONALITY`. Pairs with C4 to make the affordance bold. (≤30 min)
3. **C1** — S, ~14 new BINDING_TABLE rows for role-coded type variations. Lifts the headline hue number. (~2-3h)
4. **C3** — S-M, 5 new type variations on Panel/PanelContainer + per-direction tint calibration + README addition for consumer use. (~2-3h)
5. **C6** — M, 5 mini-features (one per direction). Seals direction uniqueness. (~4-6h)
6. **C2** — M, palette helper + per-direction rotation calibration + 6 BINDING_TABLE rows + safety hatch (`STYLE_PERSONALITY` per-direction `md3_extension_disabled` override for problem palettes). (~3-4h)

**Total estimate: 12-16 hours focused implementation.** Plus ~2-3 hours of showcase scene additions to demonstrate the new chrome (severity badges, tinted info panel, kicker chrome).

### Public API impact

**Zero breaking changes** to the 12-export public contract. Every candidate is implemented inside `STYLE_PERSONALITY`, `BINDING_TABLE`, or new internal helpers. No new top-level `@export var` is required by any candidate.

### Backwards compatibility

Existing consumer code that uses `Style.PULSE` / `Style.SLATE` / etc. with default exports gets the new visual moves automatically. Consumers who use `Style.CUSTOM` and override every value get a graceful fallback (C2's tertiary derivation has a per-direction safety hatch; C3's tinted panels are opt-in via type variation; C6's per-direction signatures are gated on the explicit `style` enum).

### Showcase scene additions

The current `showcase/showcase.tscn` does not currently exercise:
- Role-coded badges as steady-state chrome (C1)
- Tinted role panels (C3)
- Section kickers (C6 Pulse signature)

These need to be added to the showcase so the new moves are visible in the user-facing demo. Showcase additions are part of the Phase 12 scope, not separate work.

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
