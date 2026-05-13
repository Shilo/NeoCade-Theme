---
phase: 13-role-variations
reviewed: 2026-05-11T00:00:00Z
depth: standard
files_reviewed: 3
files_reviewed_list:
  - addons/neocade_theme/scripts/neocade_theme.gd
  - showcase/showcase.tscn
  - README.md
findings:
  critical: 0
  warning: 1
  info: 4
  total: 5
status: issues_found
docs_sync: 2026-05-13
closed_findings:
  - WR-01
---

# Phase 13: Code Review Report

**Reviewed:** 2026-05-11T00:00:00Z
**Depth:** standard
**Files Reviewed:** 3
**Status:** issues_found

**Docs Sync 2026-05-13:** WR-01 is now closed in `README.md`; Role Panels are documented as replacing the panel face with a 6% role-color fill, with raised mode adding a darker role-tinted edge. The rest of this file remains a historical review snapshot.

## Summary

Reviewed the Phase 13 — Role Variations diff (`82c5ad7..HEAD`) across three
production files: `addons/neocade_theme/scripts/neocade_theme.gd`,
`showcase/showcase.tscn`, and `README.md`. The implementation is small,
focused, and cleanly wired:

- All 9 new TYPE_VARIATIONS keys are registered and bind cleanly to existing
  base types (`Label` ×4, `PanelContainer` ×5).
- BINDING_TABLE recipes for all 9 variations use only existing, defined
  role tokens (`role_success`, `role_warning`, `role_danger`, `role_info`,
  `role_primary`, `surface_panel_edge`) — verified against the role_table
  definitions at lines 339-342, 401-405, 572, and 609-621.
- All 4 Role Labels carry both explicit `set_font` and `set_font_size`
  bindings (Pitfall 1.2 mandate satisfied — lines 447-450 and 512-515).
- Role Panels (PanelContainer base) correctly omit font bindings.

**Invariants verified:**

| Invariant | Status |
|-----------|--------|
| D-01: no `Theme.clear()` additions in `neocade_theme.gd` | PASS — full-file grep returns 0 matches |
| 12-export contract: no new `@export` declarations | PASS — exports remain `style`, `raised`, `platform`, plus 7-member Style Overrides + 2-member Advanced |
| Pitfall 4: none of the 9 role keys in `EDITOR_ONLY_THEME_TYPES` | PASS — table reviewed at lines 1342-1410 |
| Pitfall 1.2: all 4 Role Labels carry `set_font` + `set_font_size` | PASS — 8 lines (447-450, 512-515) |
| Role Panels have NO font bindings | PASS — only the 4 Label variations get font calls |
| SC#3: default `Label.font_color` unchanged | PASS — line 3169 still resolves `text_strong` |
| SC#3: default `PanelContainer.panel` unchanged | PASS — lines 5011-5022 untouched |

**Issues found:** 1 Warning (consumer-facing README mischaracterization of how
the 6% tint actually composites) and 4 Info-level items (one inaccurate
source-code line reference, one node-name collision in the showcase, one
implicit behavior worth documenting, and one cosmetic comment defect).

## Warnings

### WR-01: README "6% tint" description does not match the implementation

**File:** `README.md:97-98`
**Issue:** The Role Panels section claims the variations "render a 6% tint of
the matching role color **over the per-direction panel chrome**." This phrasing
implies a compositing model where `role_xxx @ alpha=0.06` is layered ON TOP of
the existing `surface_panel` background. The actual implementation does NOT
composite — the BINDING_TABLE recipe `"role": "role_xxx"` REPLACES the panel
face role entirely (resolved in `_resolve_recipe()` at line 5524:
`bg_color = role_table.get(role, …)` followed by line 5526:
`bg_color = Color(..., alpha)`). The panel renders `role_xxx @ alpha=0.06`
directly against whatever is BEHIND the PanelContainer (its parent surface),
not against `surface_panel`.

Additionally, when the consumer enables `@export var raised = true`, the
`raised_face_edge: true` recipe option causes `_apply_raised_depth_border()`
(line 5283) to overwrite the configured `border_role: "surface_panel_edge"` —
line 5287: `sb.border_color = offset_color` — replacing the neutral edge with
`role_xxx_offset` (a darker tinted variant). The README does not mention this
raised-state behavior at all. With `raised=true`, the user sees a translucent
role-tinted face surrounded by an opaque role-tinted-darker rim, which is
visually heavier than the "6% tint" headline implies.

**Fix:** Tighten the README copy to describe the actual rendering. Suggested
replacement for lines 97-98:

```markdown
**5 Role Panels** (extend `PanelContainer`) replace the panel face with a 6%
opacity wash of the matching role color so the underlying surface shows
through. When `raised = true`, the panel also picks up a darker role-tinted
edge from the `raised_face_edge` treatment; turn `raised` off (default) for
a flat translucent banner.
```

## Info

### IN-01: Stale source-line reference in Phase 13 comment

**File:** `addons/neocade_theme/scripts/neocade_theme.gd:5079-5080`
**Issue:** The comment block above the `SuccessLabel` recipe states:

> "Opt-in only; default `Label.font_color` remains `text_strong` at line 3147 — SC#3 invariant."

Line 3147 actually contains `"font_outline_color": {"role": "surface_low", "alpha": 0.0}` from the
**ItemList** recipe at lines 3142-3150. The correct line for default
`Label.font_color = text_strong` is **line 3169** inside the
`"Label": { ... "color": { "font_color": {"role": "text_strong"} } }` recipe.
The SC#3 invariant itself holds — the comment merely points at the wrong line,
which will mislead any future reviewer who navigates to line 3147 to verify
the claim.

**Fix:**
```gdscript
# 55. SuccessLabel — Label variation (Phase 13 § C1). Opt-in only; default
#     Label.font_color remains text_strong at line 3169 — SC#3 invariant.
```

### IN-02: Duplicate `DangerPanel` node names in `showcase.tscn`

**File:** `showcase/showcase.tscn:193` and `showcase/showcase.tscn:1493`
**Issue:** Two nodes named `DangerPanel` now exist in the showcase scene:

1. `RootMargin/RootStack/ShowcaseTabs/Buttons/Margin/Grid/DangerPanel` (line 193) —
   a pre-existing `PanelContainer` chrome wrapper around the "DangerButton" demo
   with NO `theme_type_variation` (renders as plain `PanelContainer`).
2. `RootMargin/RootStack/ShowcaseTabs/Role Variations/Margin/Stack/PanelGrid/DangerPanel`
   (line 1493) — a Phase 13 demo cell with `theme_type_variation = &"DangerPanel"`
   (renders the new opt-in variation).

Godot allows same-name siblings under different parents and the `unique_id`s
do not collide (1284280837 vs 2700000026), so this is **not a functional bug**.
However, the duplicate name is confusing — the two nodes render very
differently and future scene edits could conflate them. The first one was
named after the **child** "DangerButton" and predates the type-variation system.

**Fix (optional):** Either rename the pre-existing wrapper (e.g.,
`DangerButtonPanel` to match the sibling pattern `PrimaryPanel` / `GhostPanel`)
or leave both with a comment noting the distinction. Renaming is technically
a non-Phase-13 change and may belong to a separate cleanup PR.

### IN-03: `raised=true` behavior on Role Panels is undocumented

**File:** `addons/neocade_theme/scripts/neocade_theme.gd:5104-5118` (and the
4 analogous entries through line 5172)
**Issue:** The 5 Role Panel recipes specify `raised_intensity: "shape.raised_lifts.panel"`
and `raised_face_edge: true`, mirroring the default `PanelContainer` recipe
(lines 5011-5022). When the consumer's `@export var raised: bool` is true,
`_apply_raised_depth_border()` overwrites the configured
`border_role: "surface_panel_edge"` with `role_xxx_offset` (see WR-01). This is
consistent with every other raised-aware recipe in BINDING_TABLE (e.g., Panel
@ 2121, Button styleboxes @ 2055-2087), so it is **intentional**. But neither
the recipe comments nor the user-facing README mentions the interaction. A
maintainer reading the recipe would reasonably believe `surface_panel_edge`
always wins.

**Fix:** Add a one-line comment to the AccentPanel recipe (the first of the 5)
clarifying the raised composition, e.g.:

```gdscript
# 59. AccentPanel — PanelContainer variation (Phase 13 § C3). 6%-mix tint
#     of role_primary over the per-direction panel chrome. Opt-in only;
#     default PanelContainer.panel at lines 5011-5022 stays unchanged — SC#3.
#     Note: when @export raised=true, raised_face_edge overrides the
#     surface_panel_edge border with role_primary_offset (consistent with
#     all other raised_face_edge recipes).
```

### IN-04: Magic-number repetition for `alpha: 0.06`

**File:** `addons/neocade_theme/scripts/neocade_theme.gd:5111, 5125, 5139, 5153, 5167`
**Issue:** The translucency value `0.06` is duplicated across all 5 Role Panel
recipes. Future tuning (e.g., bumping to 0.08 for higher legibility in
Daybreak's already-translucent `surface_alpha_panels=0.96`) requires editing
5 sites. Other BINDING_TABLE entries also use alpha literals (0.10, 0.18, 0.20,
0.32, 0.55, 0.72), so a one-off literal here is **stylistically consistent**
with the file's prevailing pattern — but the 5-way duplication is unique to
Phase 13.

**Fix (low priority):** Either accept the duplication (matches existing style)
or hoist to a module-level `const` such as:

```gdscript
const ROLE_PANEL_TINT_ALPHA: float = 0.06  # Phase 13 § C3
```

and reference it in each recipe via the existing `shape.<key>` lookup
mechanism. Not blocking; flag for follow-up if the tint is re-tuned during UAT.

---

_Reviewed: 2026-05-11T00:00:00Z_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
