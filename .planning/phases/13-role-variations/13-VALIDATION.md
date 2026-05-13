---
phase: 13
slug: role-variations
status: complete
nyquist_compliant: true
wave_0_complete: true
created: 2026-05-11
updated: 2026-05-13
---

# Phase 13 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.
> Derived from `13-RESEARCH.md` § Validation Architecture (authoritative source).

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Godot 4.6 native (no external test framework). Verify helpers are `extends SceneTree` (headless CLI variant), per Phase 12 precedent. |
| **Config file** | None — helper scripts are standalone. |
| **Quick run command** | `godot --headless --quit --script ".planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd" -- --stage architecture` |
| **Full suite command** | `godot --headless --quit --script ".planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd" -- --stage full` then `godot --headless --quit --script ".planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd"` |
| **Estimated runtime** | ~5–10 seconds per stage; ~15–25 seconds for the 30-config smoke; total full suite ~30 seconds |

---

## Sampling Rate

- **After every task commit:** `--stage architecture` (~5 seconds; asserts the current `BINDING_TABLE.size() == 150` and `TYPE_VARIATIONS.size() == 62` counts hold).
- **After every plan wave:** `--stage full` + `_phase13_smoke_matrix.gd` (~30 seconds).
- **Before `/gsd-verify-work`:** Full suite must be green plus visual inspection of showcase Role Variations section against the locked design intent (subtle 6% tint per panel; legible color font on each label).
- **Max feedback latency:** ~30 seconds (full suite).

---

## Per-Task Verification Map

Phase 13 has **no REQUIREMENTS.md REQ-IDs** (per ROADMAP.md). Validation maps to the **3 locked success criteria**:

| SC ID | Behavior | Test Type | Automated Command | File Exists | Status |
|-------|----------|-----------|-------------------|-------------|--------|
| **SC#1** | Default chrome unchanged from Phase 12 baseline. Smoke-test 30 configs (5 styles × 2 raised × 3 platforms) where no Role Variation widget is placed. | runtime (headless) + diff-against-Phase-12-baseline | `godot --headless --quit --script ".../_phase13_smoke_matrix.gd"` (current invariant counts: BT==150, TV==62, exports==12; Button.normal/PanelContainer.panel/Label.font_color recipes remain non-role defaults) | ✅ existing | ✅ green |
| **SC#2** | All 4 Labels + 5 Panels visible in the new Showcase section. Headless verification confirms each `TYPE_VARIATIONS` entry appears in the live registry AND in the showcase scene. | runtime (headless registry introspection) + scene-load assertion | `_phase13_verify_headless.gd --stage role-variations-registered` + `--stage role-variations-in-showcase` | ✅ existing | ✅ green |
| **SC#3** | Type variations only activate when consumer applies `theme_type_variation` — never auto-bound to widget defaults. Default Label and default PanelContainer chrome remain non-role defaults. | static (BINDING_TABLE diff vs frozen Phase 12 baseline) + runtime introspection | `--stage default-chrome-unchanged`; DI-13-01 documents the historical over-strict Daybreak alpha-band false-red, not a product regression | ✅ existing | ✅ green with documented verifier caveat |
| **architecture** | Canonical .tres loads, BINDING_TABLE.size() == 150, TYPE_VARIATIONS.size() == 62, @export count == 12 | runtime (headless) | `--stage architecture` | ✅ existing | ✅ green |
| **smoke-30** | All 30 representative configs regenerate without error post-Phase-13 (invariants: BT==150, TV==62, @export==12, Button.normal exists, PanelContainer.panel exists, all 9 new variations resolve to a StyleBox or Color value, not null) | runtime (headless) | `_phase13_smoke_matrix.gd` | ✅ existing | ✅ green |
| **fonts-explicit** | Each of the 4 new Role Labels has an explicit `font` slot bound (per PITFALLS 1.2 mandate). | runtime (headless) | `--stage role-label-fonts` (asserts `theme.get_font("font", "SuccessLabel") != null` × 4) | ✅ existing | ✅ green |
| **panel-alpha-renders-cleanly** (Pitfall 1 contingency) | A Role Panel with `bg_color.a == 0.06` renders cleanly under GL Compatibility (no halo). | tooled (headless render) + manual visual confirmation | Render via `_phase13_role_render.gd`; visual diff against the precomputed-mix fallback's render | ✅ existing | manual/contingency only |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

Before Phase 13 implementation can begin, Wave 0 must create the following helpers (mirror Phase 12 precedent):

- [x] `.planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd` — SceneTree headless verifier with stages: `architecture`, `role-variations-registered`, `role-variations-in-showcase`, `default-chrome-unchanged`, `role-label-fonts`, `full`. Mirrors Phase 12 `_phase12_verify_headless.gd` structure and now pins current 2026-05-13 live counts.
- [x] `.planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd` — Direct port of `_phase12_smoke_matrix.gd` with current live counts and an invariant block asserting all 9 Phase 13 variations exist in TYPE_VARIATIONS and produce non-null stylebox/color values for the 30 configs.
- [x] `.planning/phases/13-role-variations/helpers/_phase13_role_render.gd` (optional, Pitfall 1 contingency only) — Renders showcase.tscn at Pulse style with the Role Variations tab active, saves PNG to `.planning/phases/13-role-variations/artifacts/`, for visual halo inspection.
- [x] Framework install: **NONE** — Godot CLI path already documented at `.planning/phases/05-.../helpers/godot-cli-path.txt` per Phase 12 precedent.

If Godot CLI is unavailable on the executor machine: defer SC#1/SC#2 smoke tests to manual UAT per Phase 4 `BINDING_TABLE_SEED.txt` fallback precedent. The static SC#3 check (default chrome unchanged) can still run via grep / introspection-by-reading-source.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Visual inspection of showcase Role Variations section against locked design intent (subtle 6% tint per panel; legible color font on each label) | SC#2 + design intent | Pixel-level "looks right" judgment is not automatable | Open `showcase/showcase.tscn` in Godot editor with the canonical theme applied; switch to the Role Variations tab; visually confirm each of 5 Panels is a *subtle* tinted rectangle (not a solid block) and each of 4 Labels is legibly colored on the surface background. |
| Pitfall 1 contingency — `bg_color.a == 0.06` halo under GL Compatibility (Godot #23640) | Pitfall validation | Renderer-specific edge case; halo presence requires eyeball check | If `_phase13_role_render.gd` is invoked: open the saved PNG, look for any halo / over-rendered alpha on the Role Panel borders. If present, switch to the precomputed-mix fallback path documented in RESEARCH.md Pattern 3 + Pitfall 1. |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references
- [x] No watch-mode flags
- [x] Feedback latency < 30s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** complete, with manual visual inspection retained as optional owner UAT.
