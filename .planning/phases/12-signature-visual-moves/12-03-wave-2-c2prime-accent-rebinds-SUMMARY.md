---
phase: 12
plan: 03
subsystem: ui
tags: [wave-2, c2prime, accent-rebind, binding-table, gdscript, phase12]
dependency_graph:
  requires:
    - .planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd
    - .planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd
    - addons/neocade_theme/scripts/neocade_theme.gd (_raised_depth_color HSV body from Wave 1)
  provides:
    - addons/neocade_theme/scripts/neocade_theme.gd (6 BINDING_TABLE recipe rows rebound to role_primary via border_widths + border_role)
  affects:
    - Phase 12 Wave 3 (C6 per-direction signatures)
    - Phase 13 (role variations)
tech_stack:
  added: []
  patterns:
    - C2' accent rebind: border_role token swap + border_widths Vector4i stripe (no new Color literals, no new rows)
    - 2px top-stripe idiom for tab_selected (Vector4i(0, 2, 0, 0))
    - 3px left-stripe idiom for row selection in ItemList and Tree (Vector4i(3, 0, 0, 0))
    - Deferred decision documented in code with RESEARCH OQ2 anchor above affected function
key_files:
  created: []
  modified:
    - addons/neocade_theme/scripts/neocade_theme.gd (6 BINDING_TABLE rows + 1 comment block)
key_decisions:
  - "C2' rebinds use role_primary token (not accent_color string) — consistent with Phase 5-7 idiom"
  - "border_width: 0 field removed when border_widths: Vector4i present (resolver ignores border_width in that branch)"
  - "hovered_selected and hovered_selected_focus rows intentionally NOT rebound — preserves hover-vs-selected visual hierarchy"
  - "Section-header underline rebind DEFERRED (RESEARCH OQ2): HSeparator shares StyleBoxLine with PopupMenu separators (Phase 7 convention)"
  - "Mid-phase fallback achieved: Wave 1 (C4) + Wave 2 (C2') produce a shippable state per D-12.20"
patterns_established:
  - "Stripe accent rebind: pair border_role: role_primary WITH border_widths: Vector4i to specify per-side widths"
  - "Deferred design decisions get RESEARCH OQ2-style anchors above the affected function for discoverability"
requirements_completed: []
duration: ~20min
completed: "2026-05-11"
---

# Phase 12 Plan 03: Wave 2 C2' Accent Rebinds Summary

**Six BINDING_TABLE rows rebound from neutral `button_pressed` chrome to `role_primary` accent token, giving the accent color airtime in idle selected-state chrome via 2px top stripes on tabs and 3px left stripes on ItemList/Tree rows.**

## Performance

- **Duration:** ~20 min
- **Started:** 2026-05-11
- **Completed:** 2026-05-11
- **Tasks:** 3
- **Files modified:** 1 (addons/neocade_theme/scripts/neocade_theme.gd)

## Accomplishments

- Six BINDING_TABLE rows rebound: TabBar.tab_selected, TabContainer.tab_selected, ItemList.selected, ItemList.selected_focus, Tree.selected, Tree.selected_focus
- BINDING_TABLE row count = 140 (unchanged — C1 freeze preserved)
- Zero new `Color(...)` literals introduced (SC#5 confirmed via `git diff | grep '^+.*Color('` = 0 lines)
- Deferred HSeparator underline rebind documented in code with discoverable `RESEARCH OQ2` anchor
- Wave 2 ship state verified — Wave 3 (C6 per-direction signatures) is optional polish from here

## Exact 6 Rebound Rows — Before / After

### Target 1: TabBar.tab_selected

**BEFORE:**
```gdscript
"tab_selected":     {"role": "button_pressed", "border_role": "button_border_pressed",
                        "raised_intensity": 0, "border_width": 0,
                        "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                        "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

**AFTER:**
```gdscript
# Phase 12 C2' (D-12.06/07): 2px top accent stripe via role_primary border_role.
# Vector4i layout = (left, top, right, bottom) per _resolve_recipe lines 5386-5389.
"tab_selected":     {"role": "button_pressed", "border_role": "role_primary",
                        "raised_intensity": 0,
                        "border_widths": Vector4i(0, 2, 0, 0),
                        "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                        "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

### Target 2: TabContainer.tab_selected

**BEFORE:**
```gdscript
"tab_selected":     {"role": "button_pressed", "border_role": "button_border_pressed",
                        "raised_intensity": 0, "border_width": 0,
                        "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                        "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

**AFTER:**
```gdscript
# Phase 12 C2' (D-12.06/07): 2px top accent stripe (matches TabBar tab_selected idiom).
"tab_selected":     {"role": "button_pressed", "border_role": "role_primary",
                        "raised_intensity": 0,
                        "border_widths": Vector4i(0, 2, 0, 0),
                        "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                        "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

### Target 3: ItemList.selected

**BEFORE:**
```gdscript
"selected":               {"role": "button_pressed", "border_role": "button_pressed",
                            "raised_intensity": 0, "border_width": 0},
```

**AFTER:**
```gdscript
# Phase 12 C2' (D-12.06/07): 3px left accent stripe via role_primary border_role.
"selected":               {"role": "button_pressed", "border_role": "role_primary",
                            "raised_intensity": 0,
                            "border_widths": Vector4i(3, 0, 0, 0)},
```

### Target 4: ItemList.selected_focus

**BEFORE:**
```gdscript
"selected_focus":         {"role": "button_pressed", "border_role": "button_pressed",
                            "raised_intensity": 0, "border_width": 0},
```

**AFTER:**
```gdscript
# Phase 12 C2' (D-12.06/07): 3px left accent stripe (matches ItemList.selected).
"selected_focus":         {"role": "button_pressed", "border_role": "role_primary",
                            "raised_intensity": 0,
                            "border_widths": Vector4i(3, 0, 0, 0)},
```

### Target 5: Tree.selected

**BEFORE:**
```gdscript
"selected":               {"role": "button_pressed", "raised_intensity": 0,
                            "border_role": "button_pressed", "border_width": 0},
```

**AFTER:**
```gdscript
# Phase 12 C2' (D-12.06/07): 3px left accent stripe (matches ItemList.selected idiom).
"selected":               {"role": "button_pressed", "raised_intensity": 0,
                            "border_role": "role_primary",
                            "border_widths": Vector4i(3, 0, 0, 0)},
```

### Target 6: Tree.selected_focus

**BEFORE:**
```gdscript
"selected_focus":         {"role": "button_pressed", "raised_intensity": 0,
                            "border_role": "button_pressed", "border_width": 0},
```

**AFTER:**
```gdscript
# Phase 12 C2' (D-12.06/07): 3px left accent stripe.
"selected_focus":         {"role": "button_pressed", "raised_intensity": 0,
                            "border_role": "role_primary",
                            "border_widths": Vector4i(3, 0, 0, 0)},
```

## Task Commits

1. **Task 1: Rebind TabBar + TabContainer tab_selected to 2px top accent stripe** - `15839fa` (feat)
2. **Task 2: Rebind ItemList + Tree selected/selected_focus to 3px left accent stripe** - `d8ab6d1` (feat)
3. **Task 3: Add deferred HSeparator accent rebind note** - `a31d9fb` (docs)

## Verification Output

### architecture stage (BINDING_TABLE row count gate)

```
PHASE12_VERIFY: architecture OK (BINDING_TABLE=140, TYPE_VARIATIONS=52)
PHASE12_VERIFY: PASS — stage 'architecture' all assertions green
```

### --stage full

```
PHASE12_VERIFY: stage=full
PHASE12_VERIFY: architecture OK (BINDING_TABLE=140, TYPE_VARIATIONS=52)
PHASE12_VERIFY: sc1 OK (no depth chrome with raised=false across all selectable styles)
PHASE12_VERIFY: sc2 OK (tabs flat at raised=true across all selectable styles)
PHASE12_VERIFY: sc3 OK (2060 styleboxes inspected, 50 graph-type rows skipped)
PHASE12_VERIFY: sc6 OK (12 exports)
PHASE12_VERIFY: PASS — stage 'full' all assertions green
```

### Smoke matrix

```
PHASE12_SMOKE: begin
PHASE12_SMOKE: 30 configs queued
PHASE12_SMOKE: PASS — 30 configs regenerated cleanly, invariants held
```

## SC#5 Confirmation (no new Color literals)

```
git diff feat/signature-visual-moves~3..HEAD -- addons/neocade_theme/scripts/neocade_theme.gd | grep -E '^\+.*Color\('
(no output — 0 new Color() literals introduced)
```

## SC#6 Confirmation (12 exports)

`grep -c '^@export ' addons/neocade_theme/scripts/neocade_theme.gd` returns **12**.

## Deferred HSeparator Note

Comment placed above `_apply_separator_styleboxes` at line 746:

```gdscript
# Phase 12 C2' note (RESEARCH OQ2 / D-12.07 item 6): the section-header underline
# accent rebind was DEFERRED. HSeparator's stylebox is shared with PopupMenu
# separators (Phase 7 convention); rebinding here would surface accent inside
# dropdown menu separators — wrong visual. Re-evaluate after Wave 3 ships if
# accent airtime in headings still feels under-served.
```

Discoverable via `grep -n "RESEARCH OQ2" addons/neocade_theme/scripts/neocade_theme.gd` returning 1 hit at line 746.

## Mid-Phase Fallback Statement

**Mid-phase fallback achieved — Wave 1 + Wave 2 leave a shippable Phase 12 state per D-12.20.**

- C4 (Wave 1): HSV value-darken depth formula gives raised buttons colored depth in their own hue family.
- C2' (Wave 2): Six BINDING_TABLE rows now surface the accent color in idle selected chrome — resolving the "generic dark Godot theme with an accent color" complaint.

Wave 3 (C6 per-direction signature moves) is additional polish that can proceed or defer independently. The heading complaint from the production-readiness audit is resolved by this wave.

## Deviations from Plan

None — plan executed exactly as written. All 6 rebind targets matched their exact `BEFORE` text at the planned line numbers. No line drift required corrective search.

## Known Stubs

None.

## Threat Flags

None. All six rebinds use the string token `"role_primary"` (existing canonical accent key in `role_table`). No new network endpoints, auth paths, file access patterns, or schema changes. The `role_table.get("role_primary", role_table.outline_color)` fallback (line 5378) means an unknown role string silently falls back to `outline_color` — not a panic (T-12.03-03 accepted).

## Self-Check: PASSED

- `addons/neocade_theme/scripts/neocade_theme.gd` modified: CONFIRMED
- `grep -c 'Vector4i(0, 2, 0, 0)' addons/neocade_theme/scripts/neocade_theme.gd` = 2: CONFIRMED
- `grep -c 'Vector4i(3, 0, 0, 0)' addons/neocade_theme/scripts/neocade_theme.gd` = 4: CONFIRMED
- `grep -cE '"border_role": "role_primary"' addons/neocade_theme/scripts/neocade_theme.gd` >= 6: CONFIRMED (13)
- `grep -c '^@export '` = 12: CONFIRMED
- `grep -c 'RESEARCH OQ2'` = 1: CONFIRMED
- Task 1 commit 15839fa: CONFIRMED
- Task 2 commit d8ab6d1: CONFIRMED
- Task 3 commit a31d9fb: CONFIRMED
- `--stage full` exits 0: CONFIRMED
- Smoke matrix exits 0: CONFIRMED
- Zero new `Color(...)` literals: CONFIRMED
