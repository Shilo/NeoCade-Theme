---
phase: 12
slug: signature-visual-moves
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-10
---

# Phase 12 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution. Distilled from `12-RESEARCH.md` § "Validation Architecture".

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Godot 4.6 native (no external test framework). Verify helpers are `@tool extends EditorScript` (in-editor) + `extends SceneTree` (headless). |
| **Config file** | None. Helper scripts are standalone. |
| **Quick run command** | `godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage architecture` |
| **Full suite command** | `godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full` |
| **Estimated runtime** | ~5–10 seconds (headless theme regeneration + introspection); SC#4 thumbnail render ~15–25 seconds additional. |

---

## Sampling Rate

- **After every task commit:** Run `--stage architecture` (canonical resource loads, BINDING_TABLE row count == 37, TYPE_VARIATIONS entry count, `@export` count == 12)
- **After every plan wave:** Run `--stage full` (all SC stages + 30-config smoke matrix)
- **Before `/gsd-verify-work`:** Full suite must be green + SC#4 greyscale thumbnail render + user attestation on greyscale identifiability
- **Max feedback latency:** ~10 seconds for quick run; ~30 seconds for full suite

---

## Per-Task Verification Map

Phase 12 maps validation to the **6 locked success criteria** (D-12.24..D-12.29 in `12-CONTEXT.md`), not to REQ-IDs (Phase 12 is post-v1 visual-identity work without REQUIREMENTS.md REQ-IDs).

| SC ID | Plan / Wave | Behavior | Test Type | Automated Command | File Exists | Status |
|---|---|---|---|---|---|---|
| **SC#1** | All waves | `raised=false` shows ZERO 3D elements for every style | runtime (headless) | `godot --headless --quit --script ".../_phase12_verify_headless.gd" -- --stage sc1-no-3d-when-flat` | ❌ W0 | ⬜ pending |
| **SC#2** | C2'/C6 waves | `raised=true` lifts panels + buttons; tabs stay flat | runtime (headless) | `godot --headless --quit --script ".../_phase12_verify_headless.gd" -- --stage sc2-tabs-flat-when-raised` | ❌ W0 | ⬜ pending |
| **SC#3** | C6 wave (Daybreak) | No glow halos — no `Color()` with `alpha ∈ (0.0, 1.0)` on outline/shadow/outer-border slots | static (grep) + runtime introspection | `grep` + `--stage sc3-no-glow-halo` | ❌ W0 | ⬜ pending |
| **SC#4** | After all waves | Every direction identifiable at thumbnail scale via greyscale render | tooled + manual attestation | `godot --headless --quit --script ".../_phase12_thumbnail_render.gd"` → user attestation | ❌ W0 | ⬜ pending |
| **SC#5** | C2'/C6 waves | No new hues — every Phase-12-touched color literal resolves to `base_color`/`accent_color`/existing token | static (grep on diff) | `git diff feat/signature-visual-moves~..HEAD -- addons/neocade_theme/scripts/neocade_theme.gd \| grep -E 'Color\\('` + plan diff review | ❌ W0 | ⬜ pending |
| **SC#6** | All waves | `@export` count remains 12 before and after Phase 12 | static (script introspection) | `godot --headless --quit --script ".../_phase12_verify_headless.gd" -- --stage sc6-export-count` | ❌ W0 | ⬜ pending |
| **architecture** | Any | Canonical `.tres` loads; BINDING_TABLE == 37 rows; TYPE_VARIATIONS holds (existing + Kicker recheck); regenerate is reentry-safe | runtime (headless) | `--stage architecture` | ❌ W0 | ⬜ pending |
| **30-config smoke** | After all waves | All 30 representative `(style × raised × platform × base × accent)` configs regenerate without error | runtime (headless) | `--stage smoke-30` (calls `_phase12_smoke_matrix.gd`) | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

Phase 12 ships its own verify helpers because the existing Phase 4/8 helpers reference stale paths (`pulse_neocade_theme.tres`, `neocade_mobile_theme.tres` — deleted in 2026-05-08 consolidation per Pitfall 6 in `12-RESEARCH.md`).

- [ ] `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd` — EditorScript variant (in-editor fallback path)
- [ ] `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` — SceneTree headless variant (CLI default)
- [ ] `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd` — SC#4 SceneTree script (renders showcase per style, desaturates to greyscale via `Image.adjust_bcs(0, 0, 0)`, saves 5 PNGs at 256×144 for user attestation)
- [ ] `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd` — 30-config smoke matrix (curated from 144-axis full matrix)

**Framework install:** none. Godot CLI path is already documented at `.planning/phases/05-.../helpers/godot-cli-path.txt` (per Phase 5+ verify scripts).

**Empirical check before Wave 1 closes:** Confirm `Image.adjust_bcs(0, 0, 0)` semantics produce greyscale (saturation arg = 0 → grey). If not, fall back to per-pixel luminance computation in GDScript. Tracked as Assumption A1 in `12-RESEARCH.md`.

---

## Manual-Only Verifications

| Behavior | SC ID | Why Manual | Test Instructions |
|----------|-------|------------|-------------------|
| Greyscale identifiability of all 5 directions at thumbnail scale | SC#4 | Subjective: the locked criterion is "each must be identifiable by direction name" — only a human reader can confirm | (1) Run `_phase12_thumbnail_render.gd` to produce 5 PNGs at 256×144 saved to `.planning/phases/12-signature-visual-moves/artifacts/`. (2) Present the 5 unlabeled thumbnails to the user. (3) User names each by direction. (4) Pass requires correct identification of all 5; any mismatch → strengthen the corresponding C6 move and re-render. |
| Pulse `Kicker` accent-tracked feel in showcase (chrome reads as intended) | C6 Pulse | Visual aesthetics judgment | Open `showcase/showcase.tscn` after Phase 12 Wave 3, set `style = PULSE`, confirm the new Kicker label above the "Buttons" section reads as uppercase, accent-colored, and unmistakably Pulse-signature. |
| Daybreak outline does not visually read as a halo/glow on busy backgrounds | SC#3 (Daybreak C6) | Visual confirmation that 1px full-alpha outline at 3px offset is read as "outline" not "halo" | Open `showcase/showcase.tscn` with `style = DAYBREAK`, `raised = true`. Confirm primary CTAs show a 1px sharp mint outline, not a soft glow. Compare visually against `mockup-refined-plan.html` Daybreak cell. |

---

## Validation Sign-Off

- [ ] All Wave 0 helper scripts created and runnable
- [ ] SC#1 (zero 3D when flat): automated, green for all 6 styles × DESKTOP+MOBILE
- [ ] SC#2 (tabs flat when raised): automated, green
- [ ] SC#3 (no glow halos): automated (grep + introspection), green; Daybreak outline visually confirmed
- [ ] SC#4 (greyscale identifiability): tooled render + user attestation passed
- [ ] SC#5 (no new hues): plan diff reviewed, no new `Color()` literals
- [ ] SC#6 (12-export contract): script introspection asserts `@export` count == 12
- [ ] 30-config smoke matrix: all configs regenerate cleanly
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
