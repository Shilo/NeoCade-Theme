# Phase 13: Role Variations — Pattern Map

**Mapped:** 2026-05-11
**Files analyzed:** 6 (2 modifications + 3 new helpers + 1 README append)
**Analogs found:** 6 / 6

---

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `addons/neocade_theme/scripts/neocade_theme.gd` (TYPE_VARIATIONS insertion) | config (theme registry) | data-driven dict literal | Same dict, existing 47 entries (lines 1257-1317) | exact (same dict) |
| `addons/neocade_theme/scripts/neocade_theme.gd` (BINDING_TABLE insertion — 4 Labels) | config (theme recipe) | data-driven dict literal | `Caption` entry (lines 4937-4944) + Label.font_color recipe at line 3147 | exact |
| `addons/neocade_theme/scripts/neocade_theme.gd` (BINDING_TABLE insertion — 5 Panels) | config (theme recipe) | data-driven dict literal | `CardPanel` (lines 5015-5034) + `PanelContainer` (lines 4989-5000) | exact |
| `addons/neocade_theme/scripts/neocade_theme.gd` (`_regenerate_theme()` font calls) | controller (regeneration loop) | request-response (single regenerate pass) | Existing `set_font/set_font_size` block for Caption/Kicker (lines 444, 449, 504, 513) | exact |
| `showcase/showcase.tscn` (10th ScrollContainer) | component (scene data) | scene-load / data | Buttons ScrollContainer (lines 108-336); Token Gallery ScrollContainer (lines 1032-1122) | exact |
| `.planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd` (NEW) | test (headless verifier) | event-driven (stage dispatch) | `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` | exact |
| `.planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd` (NEW) | test (30-config smoke) | batch | `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd` | exact |
| `.planning/phases/13-role-variations/helpers/_phase13_role_render.gd` (NEW, contingency) | test (visual evidence) | render-to-file (sync) | `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render_runtime.gd` | exact |
| `README.md` (repo root — NOT `addons/neocade_theme/README.md`) | docs | append-only | Existing "Usage" section at lines 32-63 (style/raised/platform consumer pattern) | role-match |

---

## Pattern Assignments

### 1. `addons/neocade_theme/scripts/neocade_theme.gd` — TYPE_VARIATIONS additive insertion

**Analog:** Same `const TYPE_VARIATIONS` dict (lines 1257-1317), specifically the existing 5-entry Label family (lines 1278-1283) and 3-entry Panel family (lines 1288-1291).

**Insertion point:** After line 1316 (existing `"NoBorderHorizontalBottom": "NoBorderHorizontal",`), before the closing brace on line 1317.

**Reference excerpt — existing Label and Panel families** (lines 1278-1291):
```gdscript
	# Label / heading family (TYPEVAR-02) — 5
	"HeaderLarge":  "Label",
	"HeaderMedium": "Label",
	"HeaderSmall":  "Label",
	"Caption":      "Label",
	"CodeLabel":    "Label",     # Cross-AI Cycle 1 C4 fix: INCLUDED (was previously dropped)
	# Kicker (TYPEVAR-02 + D-09; Plan 05-04 closes DESIGN_TOKENS §8.6 todo) — 1
	"Kicker":       "Label",
	# InfoText (TYPEVAR-03; rich-text small body) — 1
	"InfoText":     "RichTextLabel",
	# Panel family (TYPEVAR-04) plus embedded Window content surface — 3
	"CardPanel": "PanelContainer",
	"HeroPanel": "PanelContainer",
	"WindowContentPanel": "PanelContainer",
```

**New entries to add** (insert after line 1316, format-matched to existing block):
```gdscript
	# Phase 13 § C1: Role Label opt-in type variations (4)
	"SuccessLabel": "Label",
	"WarningLabel": "Label",
	"DangerLabel":  "Label",
	"InfoLabel":    "Label",
	# Phase 13 § C3: Role Panel opt-in type variations (5)
	"AccentPanel":  "PanelContainer",
	"InfoPanel":    "PanelContainer",
	"WarningPanel": "PanelContainer",
	"DangerPanel":  "PanelContainer",
	"SuccessPanel": "PanelContainer",
```

**Conventions/invariants:**
- Indentation: **tab**, single tab (mirrors existing block).
- Key alignment: pad colon-aligned to longest key in the local group (existing block aligns `"HeaderLarge":  "Label"` with two spaces after colon; mirror that for the 4 Labels and 5 Panels).
- Base type strings must be exactly `"Label"` and `"PanelContainer"` — no quotes-aliasing.
- **DO NOT add any of these 9 keys to `EDITOR_ONLY_THEME_TYPES`** (lines 1320-1388 dict). Pitfall 4 in RESEARCH: doing so silently strips them from runtime themes.

**Pitfalls flagged:**
- Pitfall 4 (RESEARCH § Pitfall 4): editor-only filter at line 640 silently skips entries listed in `EDITOR_ONLY_THEME_TYPES`. None of the 9 new keys belong there.

---

### 2. `addons/neocade_theme/scripts/neocade_theme.gd` — BINDING_TABLE insertion (4 Role Labels)

**Analog:** Existing `Caption` Label-variation block (lines 4937-4944) + base Label `font_color` recipe at line 3147.

**Insertion point:** After line 5056 (closing `}` of `HeroPanel` block) and before line 5057 (closing brace of `BINDING_TABLE`).

**Reference excerpt — Caption pattern** (lines 4937-4944):
```gdscript
	# 47. Caption — Label variation (TYPEVAR-02). Caption is the small-body
	#     supporting label; uses text_default (one tonal step softer than
	#     text_strong) to read as secondary content.
	"Caption": {
		"color": {
			"font_color": {"role": "text_default"},
		},
	},
```

**Reference excerpt — default Label.font_color recipe** (line 3147, MUST stay unchanged for SC#3):
```gdscript
	# 16. Label — text-only chrome; focus is an outline overlay, never a filled panel.
	"Label": {
		"stylebox": {
			"normal": {"empty": true},
			"focus": {"role": "focus_ring"},
		},
		"color": {
			"font_color": {"role": "text_strong"},
		},
	},
```

**New entries to add** (mirror Caption shape; single-key recipe — `font_color` only, no alpha):
```gdscript
	# 55. SuccessLabel — Label variation (Phase 13 § C1). Opt-in only; default
	#     Label.font_color remains text_strong at line 3147 — SC#3 invariant.
	"SuccessLabel": {
		"color": {
			"font_color": {"role": "role_success"},
		},
	},
	# 56. WarningLabel — Label variation (Phase 13 § C1).
	"WarningLabel": {
		"color": {
			"font_color": {"role": "role_warning"},
		},
	},
	# 57. DangerLabel — Label variation (Phase 13 § C1).
	"DangerLabel": {
		"color": {
			"font_color": {"role": "role_danger"},
		},
	},
	# 58. InfoLabel — Label variation (Phase 13 § C1).
	"InfoLabel": {
		"color": {
			"font_color": {"role": "role_info"},
		},
	},
```

**Conventions/invariants:**
- Each entry numbered sequentially in the comment header (55, 56, 57, 58, then 59-63 for the panels). Existing convention: every BINDING_TABLE entry has a numbered comment leading line — see lines 4937 ("47."), 4945 ("48."), 4954 ("49."), 4972 ("50."), 4985 ("51."), 5001 ("52."), 5015 ("53."), 5035 ("54.").
- Role token names — `role_success`, `role_warning`, `role_danger`, `role_info` — already exist in `role_table` (lines 603-606). Verified.
- Single-key `font_color` recipe — no `border_role`, no `alpha`. Caption uses identical shape.
- **DO NOT touch the default Label entry at lines 3141-3149** — SC#3 invariant.

**Pitfalls flagged:**
- Pitfall 2 (RESEARCH § Pitfall 2): variations do NOT inherit fonts. The new Role Label `font_color` binding is registered automatically by the BINDING_TABLE walk at lines 639-662, but the `font` slot must be set in `_regenerate_theme()` separately (see file #3 below). Forgetting this is the highest-impact bug.

---

### 3. `addons/neocade_theme/scripts/neocade_theme.gd` — BINDING_TABLE insertion (5 Role Panels)

**Analog:** Existing `CardPanel` block (lines 5015-5034) + base `PanelContainer` block (lines 4985-5000).

**Insertion point:** Immediately after the 4 Role Label entries (file #2), before line 5057.

**Reference excerpt — CardPanel pattern** (lines 5015-5034):
```gdscript
	# 53. CardPanel — PanelContainer variation (TYPEVAR-04). Uses
	#     shape.card_radius for per-direction radius personality (Pulse 0,
	#     Slate 14, Bubble 26, Daybreak 8, Burst 18) plus the panel
	#     surface_alpha and raised lift.
	"CardPanel": {
		"stylebox": {
			"panel": {
				"role":             "surface_panel",
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"alpha":            "shape.surface_alpha_panels",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
		"color": {
			"font_color": {"role": "text_strong"},
		},
	},
```

**Reference excerpt — base PanelContainer recipe** (lines 4989-5000, MUST stay unchanged for SC#3):
```gdscript
	"PanelContainer": {
		"stylebox": {
			"panel": {
				"role":             "surface_panel",
				"border_role":      "surface_panel_edge",
				"alpha":            "shape.surface_alpha_panels",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(10, 8),
			},
		},
	},
```

**New entries to add** (full CardPanel-shape recipe; swap `role` to `role_<x>`, swap `alpha` literal `0.06`):
```gdscript
	# 59. AccentPanel — PanelContainer variation (Phase 13 § C3). 6%-mix tint
	#     of role_primary over the per-direction panel chrome. Opt-in only.
	"AccentPanel": {
		"stylebox": {
			"panel": {
				"role":             "role_primary",
				"alpha":            0.06,
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
	},
	# 60. InfoPanel — PanelContainer variation (Phase 13 § C3).
	"InfoPanel": {
		"stylebox": {
			"panel": {
				"role":             "role_info",
				"alpha":            0.06,
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
	},
	# 61. WarningPanel — PanelContainer variation (Phase 13 § C3).
	"WarningPanel": {
		"stylebox": {
			"panel": {
				"role":             "role_warning",
				"alpha":            0.06,
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
	},
	# 62. DangerPanel — PanelContainer variation (Phase 13 § C3).
	"DangerPanel": {
		"stylebox": {
			"panel": {
				"role":             "role_danger",
				"alpha":            0.06,
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
	},
	# 63. SuccessPanel — PanelContainer variation (Phase 13 § C3).
	"SuccessPanel": {
		"stylebox": {
			"panel": {
				"role":             "role_success",
				"alpha":            0.06,
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
	},
```

**Conventions/invariants:**
- Field order matches CardPanel: `role`, `alpha`, `border_role`, `radius`, `raised_intensity`, `raised_face_edge`, `padding` (RESEARCH Pattern 3 example).
- `alpha: 0.06` is a literal float — NOT a `"shape.<key>"` lookup. The resolver at lines 5353-5360 accepts both forms; the literal 0.06 produces the documented 6% tint.
- `padding: Vector2i(12, 10)` matches CardPanel exactly. **Do not** use the base PanelContainer `Vector2i(10, 8)` — Role Panels are intended to read like Cards.
- `border_role: "surface_panel_edge"` — same border family as default panel. **Do not** use `border_role: "role_<x>_edge"` (no such role exists in role_table).
- **No `color` block.** Unlike CardPanel which carries `font_color`, the Role Panels are content surfaces only; their inner `Label` (when present) keeps default Label color, or the consumer can opt into a Role Label as the inner content.
- **DO NOT touch lines 4985-5000** — base PanelContainer chrome must stay byte-identical (SC#3).

**Pitfalls flagged:**
- **Pitfall 1 (RESEARCH § Pitfall 1, CONTINGENCY):** `bg_color.a == 0.06` may halo under GL Compatibility. Wave 0 smoke must visually verify; fallback is to precompute `_mix(surface_panel, role_<x>, 0.06)` in `_regenerate_theme()` and inject as new `role_<x>_panel_tint` keys (see RESEARCH lines 305-313). The planner should include this fallback as an explicit contingency task with a "skip-if-clean-render" gate.
- Pitfall 3 (RESEARCH § Pitfall 3): Godot REPLACES (not merges) styleboxes by (slot, type). Each Role Panel recipe MUST be complete — `border_role` + `radius` + `raised_intensity` + `raised_face_edge` + `padding` all required. The recipe above is complete.
- Pitfall 5 in RESEARCH note: `shape.surface_alpha_panels` is the per-direction translucency for the default panel; we deliberately replace it with literal `0.06` for Role Panels. This is intentional.

---

### 4. `addons/neocade_theme/scripts/neocade_theme.gd` — `_regenerate_theme()` explicit fonts (PITFALLS 1.2)

**Analog:** Existing explicit `set_font`/`set_font_size` block for Caption/Kicker (lines 444, 449, 504, 513).

**Insertion points:**
- **`set_font` insertions** — within block at lines 441-462. Insert after line 444 (`set_font("font", "Caption", body_font)`).
- **`set_font_size` insertions** — within block at lines 498-527. Insert after line 504 (`set_font_size("font_size", "Caption", tokens.label_)`).

**Reference excerpt — Caption set_font pattern** (lines 441-449):
```gdscript
	set_font("font", "HeaderLarge",  header_large_font)
	set_font("font", "HeaderMedium", header_medium_font)
	set_font("font", "HeaderSmall",  header_small_font)
	set_font("font", "Caption",      body_font)
	set_font("font", "CodeLabel",    body_font)   # consumer can override to a mono per FONT-04 stricken
	# Kicker (D-09 / Plan 05-04): Inter Variable Roman body weight per UD-4 Option D / D-17.
	# Per PITFALLS 1.2 type variations DO NOT inherit fonts from Label, so this
	# explicit set_font is mandatory — without it Kicker falls back to default_font.
	set_font("font", "Kicker",       body_font)
```

**Reference excerpt — Caption set_font_size pattern** (lines 498-513):
```gdscript
	set_font_size("font_size", "HeaderLarge",  tokens.h1)
	set_font_size("font_size", "HeaderMedium", tokens.h2)
	# ...
	set_font_size("font_size", "HeaderSmall",  tokens.body)
	set_font_size("font_size", "Caption",      tokens.label_)
	set_font_size("font_size", "CodeLabel",    tokens.label_)
	# ... Kicker comment ...
	set_font_size("font_size", "Kicker",       tokens.kicker)
```

**New lines to add — in the `set_font` block** (after existing Caption line 444):
```gdscript
	# Phase 13 § C1: explicit font binding for Role Label variations (PITFALLS 1.2 —
	# type variations do NOT inherit fonts from their base type).
	set_font("font", "SuccessLabel", body_font)
	set_font("font", "WarningLabel", body_font)
	set_font("font", "DangerLabel",  body_font)
	set_font("font", "InfoLabel",    body_font)
```

**New lines to add — in the `set_font_size` block** (after existing Caption line 504):
```gdscript
	# Phase 13 § C1: explicit font_size binding for Role Label variations.
	set_font_size("font_size", "SuccessLabel", tokens.body)
	set_font_size("font_size", "WarningLabel", tokens.body)
	set_font_size("font_size", "DangerLabel",  tokens.body)
	set_font_size("font_size", "InfoLabel",    tokens.body)
```

**Conventions/invariants:**
- Slot name is `"font"` (not `"normal_font"`) — Role Labels are `Label` variations, not `RichTextLabel`. Compare with InfoText at line 454 which uses `"normal_font"` because RichTextLabel reads that slot.
- Size token is `tokens.body` (per RESEARCH Example 3 note: Role Labels are general-purpose body labels; Caption uses `tokens.label_` because Caption is a small supporting label).
- `body_font` is defined at line 426 (`var body_font := inter_file`) and is already in scope within `_regenerate_theme()`.
- `tokens.body` is defined in the tokens dict assembled earlier in `_regenerate_theme()` (used at line 425 as `default_font_size = tokens.body`).
- **No font lines for the 5 Role Panels.** PanelContainer doesn't render text. CardPanel/HeroPanel set fonts at lines 461-462 only because their content layout expects a specific font for nested labels; the Role Panels don't carry that contract.

**Pitfalls flagged:**
- Pitfall 2 (RESEARCH § Pitfall 2): omitting these 8 lines silently breaks fonts under any consumer default_font override. Must run `--stage role-label-fonts` verifier (file #5 below) to assert each variation has a `font` slot bound.
- Pitfall 6 (RESEARCH § Pitfall 6): both `set_font` AND `set_font_size` are required. Forgetting size produces wrong rendering on mobile (where `tokens.body` scales from 14 to 16).

---

### 5. `showcase/showcase.tscn` — 10th ScrollContainer section

**Analog:** Existing 9 ScrollContainer tabs at `RootMargin/RootStack/ShowcaseTabs/`. The Buttons section (lines 108-336) is the canonical template for a grid-of-cells layout; the Coverage 37 of 37 section (lines 1124-1244+) shows the Banner-Kicker-Grid pattern; the Token Gallery section (lines 1032-1122) shows the use of `theme_type_variation` per cell.

**Insertion point:** After line 1405 (end of last `Player10` Label inside Window/.../ScoreRows). The new ScrollContainer becomes a sibling of `Coverage 37 of 37` under `RootMargin/RootStack/ShowcaseTabs`. Append to end of file before EOF (line 1406 is currently the file end after a final blank/newline).

**Reference excerpt — Buttons section header template** (lines 108-145):
```gdscript
[node name="Buttons" type="ScrollContainer" parent="RootMargin/RootStack/ShowcaseTabs" unique_id=1865192939]
layout_mode = 2
horizontal_scroll_mode = 1
metadata/_tab_index = 0

[node name="Margin" type="MarginContainer" parent="RootMargin/RootStack/ShowcaseTabs/Buttons" unique_id=1817353600]
layout_mode = 2
size_flags_horizontal = 3
theme_override_constants/margin_left = 12
theme_override_constants/margin_top = 12
theme_override_constants/margin_right = 12
theme_override_constants/margin_bottom = 24

[node name="Grid" type="GridContainer" parent="RootMargin/RootStack/ShowcaseTabs/Buttons/Margin" unique_id=264717698]
layout_mode = 2
size_flags_horizontal = 3
theme_override_constants/h_separation = 14
theme_override_constants/v_separation = 14
columns = 3

[node name="ButtonsSectionKicker" type="Label" parent="RootMargin/RootStack/ShowcaseTabs/Buttons/Margin/Grid" unique_id=2700000001]
layout_mode = 2
size_flags_horizontal = 3
theme_type_variation = &"Kicker"
text = "BUTTONS · IDENTITY"

[node name="PrimaryPanel" type="PanelContainer" parent="RootMargin/RootStack/ShowcaseTabs/Buttons/Margin/Grid" unique_id=1547979300]
layout_mode = 2
size_flags_horizontal = 3

[node name="PrimaryStack" type="VBoxContainer" parent="RootMargin/RootStack/ShowcaseTabs/Buttons/Margin/Grid/PrimaryPanel" unique_id=1361153025]
layout_mode = 2
theme_override_constants/separation = 8

[node name="Label" type="Label" parent="RootMargin/RootStack/ShowcaseTabs/Buttons/Margin/Grid/PrimaryPanel/PrimaryStack" unique_id=391799810]
layout_mode = 2
theme_type_variation = &"Kicker"
text = "PrimaryButton"
```

**Reference excerpt — Token Gallery per-cell `theme_type_variation` pattern** (lines 1094-1122):
```gdscript
[node name="HeaderLarge" type="Label" parent="RootMargin/RootStack/ShowcaseTabs/Token Gallery/Margin/Stack/TypeGrid" unique_id=1857062798]
layout_mode = 2
theme_type_variation = &"HeaderLarge"
text = "HeaderLarge - The quick arcade lobby"

[node name="HeaderMedium" type="Label" parent="RootMargin/RootStack/ShowcaseTabs/Token Gallery/Margin/Stack/TypeGrid" unique_id=1426686235]
layout_mode = 2
theme_type_variation = &"HeaderMedium"
text = "HeaderMedium - The quick arcade lobby"
```

**Conventions/invariants:**
- Top-level node names are simple human-readable strings: `Buttons`, `Inputs`, `Controls`, `Choices`, `Containers`, `Editor`, `Receipt`, `Token Gallery`, `Coverage 37 of 37`. Phase 13 uses **`Role Variations`** (with the space; matches the existing pluralized form).
- `metadata/_tab_index` is **0-indexed** and contiguous. Existing values: 0 (Buttons) through 8 (Coverage 37 of 37). New section: `metadata/_tab_index = 9`.
- All non-visible tabs (every tab except index 0) carry `visible = false` (see Token Gallery line 1033, Coverage line 1125). Index 0 (Buttons) at line 108 has no `visible` line, meaning visible by default. **Phase 13's tab gets `visible = false`** since it's not index 0.
- `unique_id` is a positive int. Existing showcase reserves `2700000001+` for Kicker-namespace labels (line 128). RESEARCH (Pattern 4 + Pitfall 5) reserves **2700000010 through 2700000050** for Phase 13. Cross-check via grep against existing IDs before commit.
- Section uses `[node name="<X>SectionKicker" type="Label" ... theme_type_variation = &"Kicker" text = "<UPPERCASE TITLE>"]` — the in-section title pattern. See lines 128-132 (Buttons section).
- All `Grid` GridContainers use `theme_override_constants/h_separation = 14`, `v_separation = 14`. See lines 124-125 (Buttons), 1053-1054 (Token Gallery), 1160-1161 (Coverage).
- Outer `Margin` MarginContainer uses `margin_left = 12, margin_top = 12, margin_right = 12, margin_bottom = 24`. See lines 116-119 (Buttons), 1041-1044 (Token Gallery), 1133-1136 (Coverage).
- Per-cell `theme_type_variation` uses the `&"<Name>"` StringName literal syntax — see line 131, 144, 151, 164, 1096, 1101, etc. **All 9 Phase 13 cells use this exact form.**
- For Panel cells: wrap a content `Label` inside a `PanelContainer` with `theme_type_variation = &"<X>Panel"`. The Buttons section's `PrimaryPanel` (lines 134-152) is the canonical pattern — `PanelContainer` parent + `VBoxContainer` stack + Kicker Label + content widget. Phase 13 simplifies: `PanelContainer (theme_type_variation = &"<X>Panel")` + `MarginContainer` + content `Label`.

**Recommended layout (RESEARCH Pattern 4):**
- 1 Kicker label: `text = "ROLE VARIATIONS · OPT-IN"` at the top of the grid (full-row span).
- 4 Role Label demo cells (`SuccessLabel`/`WarningLabel`/`DangerLabel`/`InfoLabel`) — each is a `Label` node with realistic consumer-style text.
- 5 Role Panel demo cells (`AccentPanel`/`InfoPanel`/`WarningPanel`/`DangerPanel`/`SuccessPanel`) — each is a `PanelContainer` wrapping a `Label` so the tint is visible.
- `columns = 3` reads cleanly (3 rows × 3 cells = 9 demo cells + 1 Kicker row); `columns = 5` is acceptable if the user prefers labels and panels on separate rows.

**Pitfalls flagged:**
- Pitfall 5 (RESEARCH § Pitfall 5): `unique_id` collisions corrupt the scene. Reserve `2700000010` through `2700000050` for Phase 13 (RESEARCH Pattern 4). Verify uniqueness with a Grep over existing IDs before commit.
- `metadata/_tab_index = 9` MUST be unique. Existing values go 0-8 (verified at lines 111, 1036, 1128). 9 is free.
- The scene loads `addons/neocade_theme/neocade_theme.tres` via `ext_resource` at line 3. The new section will display the live 9 type variations once the canonical .tres is regenerated by the Phase 13 production edits.

---

### 6. `.planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd` (NEW)

**Analog:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` (full file, 254 lines).

**Structural skeleton** (mirror exactly):
```gdscript
extends SceneTree

## Phase 13 headless verifier. Invoke via:
##   godot --headless --quit --script ".planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd" -- --stage <stage>
##
## Stages (per 13-VALIDATION.md):
##   architecture                     — canonical .tres loads, BINDING_TABLE.size() == 149, TYPE_VARIATIONS == 56, @export == 12
##   role-variations-registered       — SC#2 part 1: 9 new keys exist in TYPE_VARIATIONS + live theme registries
##   role-variations-in-showcase      — SC#2 part 2: showcase.tscn contains 9 nodes with the expected theme_type_variation
##   default-chrome-unchanged         — SC#3: Label.font_color and PanelContainer.panel resolve to non-role-color values
##   role-label-fonts                 — Pitfall 2/6: each Role Label has an explicit `font` slot (and font_size)
##   full                             — all stages above
##
## Exit code 0 = pass, 1 = fail. Marker prefix: `PHASE13_VERIFY:` for CI grep.

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_EXPORT_COUNT := 12
const EXPECTED_BINDING_TABLE_ROWS := 149  # Phase 12 baseline 140 + 9 Phase 13 additions
const EXPECTED_TYPE_VARIATIONS_COUNT := 56  # Phase 12 baseline 47 + 9 Phase 13 additions
const PHASE_13_NEW_LABEL_VARIATIONS := ["SuccessLabel", "WarningLabel", "DangerLabel", "InfoLabel"]
const PHASE_13_NEW_PANEL_VARIATIONS := ["AccentPanel", "InfoPanel", "WarningPanel", "DangerPanel", "SuccessPanel"]

const VALID_STAGES := [
	"architecture",
	"role-variations-registered",
	"role-variations-in-showcase",
	"default-chrome-unchanged",
	"role-label-fonts",
	"full",
]

var _stage: String = "architecture"
var _failures: Array[String] = []
```

**Reference excerpt — _parse_args (Phase 12 lines 45-65, copy verbatim, swap PHASE12_VERIFY → PHASE13_VERIFY):**
```gdscript
func _parse_args() -> void:
	# Godot 4.6 splits CLI at the literal `--`. User script args come from
	# OS.get_cmdline_user_args(); fall back to OS.get_cmdline_args() if the
	# caller forgot the separator.
	var sources := [OS.get_cmdline_user_args(), OS.get_cmdline_args()]
	var found := false
	for source in sources:
		var args: PackedStringArray = source
		var i := 0
		while i < args.size():
			var a: String = args[i]
			if a == "--stage" and i + 1 < args.size():
				_stage = args[i + 1]
				found = true
				break
			i += 1
		if found:
			break
	if not VALID_STAGES.has(_stage):
		push_error("PHASE13_VERIFY: unknown --stage '%s' — falling back to 'architecture'" % _stage)
		_stage = "architecture"
```

**Reference excerpt — _stage_architecture (Phase 12 lines 88-111, update expected counts):**
```gdscript
func _stage_architecture() -> void:
	var theme: Resource = ResourceLoader.load(CANONICAL_TRES)
	if theme == null:
		_fail("architecture: canonical .tres failed to load (%s)" % CANONICAL_TRES)
		return
	if not (theme is NeoCadeTheme):
		_fail("architecture: loaded resource is not a NeoCadeTheme")
		return
	var nct: NeoCadeTheme = theme

	var script: Script = nct.get_script() as Script
	var consts: Dictionary = script.get_script_constant_map()
	var bt: Dictionary = consts.get("BINDING_TABLE", {})
	if bt.size() != EXPECTED_BINDING_TABLE_ROWS:
		_fail("architecture: BINDING_TABLE.size() = %d (expected %d)" % [bt.size(), EXPECTED_BINDING_TABLE_ROWS])
	var tv: Dictionary = consts.get("TYPE_VARIATIONS", {})
	if tv.size() != EXPECTED_TYPE_VARIATIONS_COUNT:
		_fail("architecture: TYPE_VARIATIONS.size() = %d (expected %d)" % [tv.size(), EXPECTED_TYPE_VARIATIONS_COUNT])

	if not nct.has_stylebox("normal", "Button"):
		_fail("architecture: theme regenerate produced no Button.normal stylebox")
	if not nct.has_stylebox("panel", "PanelContainer"):
		_fail("architecture: theme regenerate produced no PanelContainer.panel stylebox")
	print("PHASE13_VERIFY: architecture OK (BINDING_TABLE=%d, TYPE_VARIATIONS=%d)" % [bt.size(), tv.size()])
```

**Reference excerpt — _stage_role_variations_registered (NEW — see RESEARCH Example 4 lines 627-653):**
```gdscript
func _stage_role_variations_registered() -> void:
	# SC#2 part 1: TYPE_VARIATIONS registry includes 9 new keys; theme runtime has the slots.
	var theme: NeoCadeTheme = _fresh_theme()
	if theme == null: return
	var script: Script = theme.get_script() as Script
	var tv: Dictionary = script.get_script_constant_map().get("TYPE_VARIATIONS", {})
	for v in PHASE_13_NEW_LABEL_VARIATIONS + PHASE_13_NEW_PANEL_VARIATIONS:
		if not tv.has(v):
			_fail("role-variations-registered: TYPE_VARIATIONS missing %s" % v)
	for v in PHASE_13_NEW_LABEL_VARIATIONS:
		if tv.get(v) != "Label":
			_fail("role-variations-registered: %s base type = %s (expected Label)" % [v, tv.get(v)])
	for v in PHASE_13_NEW_PANEL_VARIATIONS:
		if tv.get(v) != "PanelContainer":
			_fail("role-variations-registered: %s base type = %s (expected PanelContainer)" % [v, tv.get(v)])
	# Live registry: each Label variation must produce a font_color binding.
	for v in PHASE_13_NEW_LABEL_VARIATIONS:
		if not theme.has_color("font_color", v):
			_fail("role-variations-registered: theme.has_color(font_color, %s) == false" % v)
	# Live registry: each Panel variation must produce a panel stylebox.
	for v in PHASE_13_NEW_PANEL_VARIATIONS:
		if not theme.has_stylebox("panel", v):
			_fail("role-variations-registered: theme.has_stylebox(panel, %s) == false" % v)
	if _failures.is_empty():
		print("PHASE13_VERIFY: role-variations-registered OK (9 new variations live)")
```

**Reference excerpt — _fresh_theme + _fail + _emit_and_quit (Phase 12 lines 222-253, copy verbatim, swap PHASE12 → PHASE13):**
```gdscript
func _fresh_theme() -> NeoCadeTheme:
	var loaded: Resource = ResourceLoader.load(CANONICAL_TRES)
	if loaded == null or not (loaded is NeoCadeTheme):
		_fail("could not load canonical theme")
		return null
	var dup := (loaded as NeoCadeTheme).duplicate(true)
	return dup as NeoCadeTheme


func _fail(msg: String) -> void:
	_failures.append(msg)
	push_error("PHASE13_VERIFY FAIL: %s" % msg)


func _emit_and_quit() -> void:
	if _failures.size() > 0:
		print("PHASE13_VERIFY: FAIL — %d failure(s):" % _failures.size())
		for f in _failures:
			print("  - %s" % f)
		quit(1)
		return
	print("PHASE13_VERIFY: PASS — stage '%s' all assertions green" % _stage)
	quit(0)
```

**Conventions/invariants:**
- File starts with `extends SceneTree` (NOT `extends EditorScript`). Headless CLI execution.
- Marker prefix is `PHASE13_VERIFY:` for CI grep. Match Phase 12's `PHASE12_VERIFY:` pattern.
- `_failures: Array[String]` accumulated; print all on quit; exit 0/1.
- **WR-01/WR-02 gate** (Phase 12 lines 171-173, 215-217): each stage's `print(... OK ...)` line gated on `if _failures.is_empty():` — applied to every new stage so a stage with failures never falsely advertises success.
- `_run_stage()` dispatches by string match. `"full"` runs every stage in sequence.
- The `_phase12_verify_headless.gd` includes `_count_top_level_exports(script)` helper at lines 231-237 — copy verbatim into Phase 13's helper.

**Pitfalls flagged:**
- The 149/56 counts MUST be updated post-Phase-13 implementation, not before. If Wave 0 creates this helper before Wave 1's BINDING_TABLE/TYPE_VARIATIONS additions land, the `--stage architecture` will RED until the production edits land. That's expected Wave 0 behavior (RESEARCH lines 416-423).
- `theme.has_color("font_color", "<X>Label")` confirms the Label binding is registered. `theme.has_stylebox("panel", "<X>Panel")` confirms the Panel binding. These are the existence checks; `_stage_default_chrome_unchanged` adds the value checks.

---

### 7. `.planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd` (NEW)

**Analog:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd` (full file, 122 lines).

**Direct port — change 4 constants and the prefix string:**
```gdscript
extends SceneTree

## Phase 13 30-config smoke matrix runner.
## Invoke via: godot --headless --quit --script ".planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd"
##
## Exits 0 if all 30 configs regenerate cleanly AND maintain invariants
## (BINDING_TABLE == 149 rows, TYPE_VARIATIONS == 56, @export count == 12, Button.normal stylebox produced,
## all 9 Phase 13 variations produce non-null bindings).
## Exits 1 on first invariant violation (with collected failure list).

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_EXPORT_COUNT := 12
const EXPECTED_BINDING_TABLE_ROWS := 149  # Phase 12 baseline 140 + 9 Phase 13 additions
const EXPECTED_TYPE_VARIATIONS_COUNT := 56
const PHASE_13_NEW_LABEL_VARIATIONS := ["SuccessLabel", "WarningLabel", "DangerLabel", "InfoLabel"]
const PHASE_13_NEW_PANEL_VARIATIONS := ["AccentPanel", "InfoPanel", "WarningPanel", "DangerPanel", "SuccessPanel"]

var _failures: Array[String] = []
```

**Per-config invariant block** (extend Phase 12 lines 47-58 with Phase 13 assertions):
```gdscript
# Phase 12 baseline invariants (copy verbatim):
if not t.has_stylebox("normal", "Button"):
	_failures.append("config %d (%s): no Button.normal stylebox" % [idx, _label(cfg)])
var script: Script = t.get_script() as Script
var consts: Dictionary = script.get_script_constant_map()
var bt: Dictionary = consts.get("BINDING_TABLE", {})
if bt.size() != EXPECTED_BINDING_TABLE_ROWS:
	_failures.append("config %d (%s): BINDING_TABLE = %d rows (expected %d)" % [idx, _label(cfg), bt.size(), EXPECTED_BINDING_TABLE_ROWS])
var tv: Dictionary = consts.get("TYPE_VARIATIONS", {})
if tv.size() != EXPECTED_TYPE_VARIATIONS_COUNT:
	_failures.append("config %d (%s): TYPE_VARIATIONS = %d (expected %d)" % [idx, _label(cfg), tv.size(), EXPECTED_TYPE_VARIATIONS_COUNT])
var export_count: int = _count_top_level_exports(script)
if export_count != EXPECTED_EXPORT_COUNT:
	_failures.append("config %d (%s): @export count = %d (expected %d)" % [idx, _label(cfg), export_count, EXPECTED_EXPORT_COUNT])

# Phase 13 NEW invariants (add):
for v in PHASE_13_NEW_LABEL_VARIATIONS:
	if not t.has_color("font_color", v):
		_failures.append("config %d (%s): missing font_color for %s" % [idx, _label(cfg), v])
for v in PHASE_13_NEW_PANEL_VARIATIONS:
	if not t.has_stylebox("panel", v):
		_failures.append("config %d (%s): missing panel stylebox for %s" % [idx, _label(cfg), v])
```

**Curated 30-config builder (Phase 12 lines 72-105 — copy VERBATIM, no changes):**
The 30 configs are identical between phases. The 5 groups (10 + 5 + 6 + 5 + 4) total 30.

**Conventions/invariants:**
- File extends `SceneTree` and runs in `_init()` (NOT `_ready()`). Phase 12 pattern (line 22).
- `assert(configs.size() == 30, ...)` invariant at the top — copy verbatim from Phase 12 line 26.
- Marker prefix `PHASE13_SMOKE:` (mirror Phase 12 `PHASE12_SMOKE:`).
- `_count_top_level_exports(script)` helper copied verbatim from Phase 12 lines 115-121.
- `_label(cfg)` helper copied verbatim from Phase 12 lines 108-112.

**Pitfalls flagged:**
- The curated 30 configs are EXACTLY the Phase 12 set — including the 4 edge cases on CUSTOM with extreme colors (very dark, very light, low contrast, accent-over-WCAG-floor). This catches any role-color edge case in the new Role Panel bindings.
- The smoke matrix asserts both Phase 12 and Phase 13 invariants. It does NOT replace `_phase12_smoke_matrix.gd` — both helpers coexist; Phase 12's is historical evidence (asserts 140/47), Phase 13's asserts 149/56.

---

### 8. `.planning/phases/13-role-variations/helpers/_phase13_role_render.gd` (NEW, OPTIONAL — Pitfall 1 contingency)

**Analog:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render_runtime.gd` (88 lines) — runtime variant, NOT the EditorScript variant. Runtime is more reliable per Phase 12 PATTERNS § 11.

**Reference excerpt — runtime render boilerplate** (Phase 12 lines 1-50):
```gdscript
extends Control

## Phase 13 Role Variations visual render — Pitfall 1 contingency helper.
##
## Renders showcase.tscn at Pulse style with raised=true, captures the main window
## viewport as a full-color PNG (NOT desaturated — visual halo inspection requires color),
## saves to .planning/phases/13-role-variations/artifacts/role-variations-pulse.png.
##
## Used as Pitfall 1 evidence: if a Role Panel `bg_color.a == 0.06` produces a visible
## halo under GL Compatibility, the rendered PNG will show it. Fallback path: precompute
## the mix and inject role_table keys (RESEARCH lines 305-313).

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const SHOWCASE_SCENE := "res://showcase/showcase.tscn"
const OUTPUT_DIR := "res://.planning/phases/13-role-variations/artifacts"
const OUTPUT_NAME := "role-variations-pulse.png"


func _ready() -> void:
	print("PHASE13_ROLE_RENDER: begin (runtime, main-viewport mode)")
	set_anchors_preset(Control.PRESET_FULL_RECT)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUTPUT_DIR))

	var theme_res: Resource = ResourceLoader.load(CANONICAL_TRES)
	assert(theme_res != null and theme_res is NeoCadeTheme, "PHASE13_ROLE_RENDER: cannot load canonical .tres")

	var scene: PackedScene = ResourceLoader.load(SHOWCASE_SCENE)
	assert(scene != null, "PHASE13_ROLE_RENDER: cannot load showcase scene")

	await get_tree().create_timer(0.4).timeout

	var t: NeoCadeTheme = (theme_res as NeoCadeTheme).duplicate(true) as NeoCadeTheme
	t.style = NeoCadeTheme.Style.PULSE
	t.raised = true

	var instance := scene.instantiate()
	if instance is Control:
		(instance as Control).theme = t
		(instance as Control).set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(instance)

	await get_tree().create_timer(1.0).timeout
	await RenderingServer.frame_post_draw
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
```

**Reference excerpt — viewport capture + save** (Phase 12 lines 56-87, simplify — no desaturate):
```gdscript
	var img: Image = get_viewport().get_texture().get_image()
	if img == null:
		push_error("PHASE13_ROLE_RENDER: viewport.get_image() returned null")
		get_tree().quit(1)
		return

	# Phase 13: NO resize, NO desaturate. Halo inspection wants full-color full-res.
	# (Phase 12 used resize 256×144 + adjust_bcs(1.0, 1.0, 0.0) for greyscale SC#4.)

	var out_path := "%s/%s" % [OUTPUT_DIR, OUTPUT_NAME]
	var save_path := ProjectSettings.globalize_path(out_path)
	var err: int = img.save_png(save_path)
	if err != OK:
		push_error("PHASE13_ROLE_RENDER: save_png failed (err=%d) for %s" % [err, save_path])
		get_tree().quit(1)
		return
	print("PHASE13_ROLE_RENDER: wrote %s" % save_path)
	instance.queue_free()
	await get_tree().process_frame
	get_tree().quit(0)
```

**Conventions/invariants:**
- Extends `Control` (NOT `SceneTree`). Phase 12 found that runtime Control-rooted scripts capture the main viewport more reliably than SubViewport timing (Phase 12 lines 5-8 docstring).
- `set_anchors_preset(Control.PRESET_FULL_RECT)` so the scene takes the whole window.
- `await` chain: `create_timer(1.0)` then `RenderingServer.frame_post_draw` then `process_frame` then `RenderingServer.frame_post_draw`. Phase 12 lines 52-55 — this exact sequence is what produced the SC#4 attestation PNGs.
- `adjust_bcs(1.0, 1.0, ...)` requires `1.0` for brightness/contrast multipliers (NOT 0.0 — Phase 12 fix at lines 65-67). Phase 13 doesn't desaturate at all, but the contributors gotcha bears noting.
- Output is a single PNG (NOT 5 like Phase 12) because we just need Pulse evidence for halo presence/absence.

**Pitfalls flagged:**
- **Only build this helper if Pitfall 1 is actually triggered** (RESEARCH lines 300-314). Default expectation is the 0.06 alpha pathway renders cleanly; this helper is the visual fact-check.
- Output directory `.planning/phases/13-role-variations/artifacts/` may not exist — `DirAccess.make_dir_recursive_absolute` creates it (Phase 12 line 24 pattern).
- To run: invoke Godot CLI with this script as the main scene OR via `--script` (Control-rooted = needs main scene). Phase 12 had a sibling `.tscn` for runtime helpers; Phase 13 can use the same pattern if needed.

---

### 9. `README.md` (repo root, NOT `addons/neocade_theme/README.md`) — append "Role Variations (opt-in)" section

**IMPORTANT:** The task prompt referenced `addons/neocade_theme/README.md`, but RESEARCH § "Architectural Responsibility Map" row 7 + "Recommended Project Structure" line 139 + FOUND-01 say docs live at the **repo root** (`README.md`). The addons directory has no README (verified — `addons/neocade_theme/` contains only `fonts/`, `icons/`, `neocade_theme.tres`, `scripts/`). The planner should target the repo-root `README.md`.

**Analog:** Existing "Usage" section in repo-root `README.md` (lines 32-63), specifically the consumer-pattern code block at lines 39-46.

**Reference excerpt — existing Usage section style** (lines 32-63):
```markdown
## Usage

See [docs/usage.md](docs/usage.md) for style details, custom theme authoring,
and font fallback patterns.

Apply NeoCade to a root `Control`:

\`\`\`gdscript
extends Control

const NEOCADE_THEME := preload("res://addons/neocade_theme/neocade_theme.tres")

func _ready() -> void:
    theme = NEOCADE_THEME
\`\`\`

For runtime style or variant toggles, duplicate before mutating:

\`\`\`gdscript
var active_theme: NeoCadeTheme = NEOCADE_THEME.duplicate(true)
active_theme.style = NeoCadeTheme.Style.BUBBLE
active_theme.raised = true
active_theme.platform = NeoCadeTheme.Platform.MOBILE
theme = active_theme
\`\`\`
```

**Insertion point:** A new `## Role Variations (opt-in)` section after the existing `## Showcase` section (lines 65-79) and before `## Design Rules` (line 81). This keeps consumer-facing usage docs grouped at the top.

**Recommended new section** (mirror Usage section's tone — terse, code-led):
```markdown
## Role Variations (opt-in)

NeoCade ships 9 opt-in type variations that consumers can apply when a widget
semantically represents success / warning / danger / info / accent state. Default
`Label` and `PanelContainer` chrome stay unchanged; the variations only activate
when the consumer assigns `theme_type_variation`.

**4 Role Labels** (extend `Label`) recolor `font_color` to the matching role token:

| Variation       | Color token   |
|-----------------|---------------|
| `SuccessLabel`  | `role_success` |
| `WarningLabel`  | `role_warning` |
| `DangerLabel`   | `role_danger`  |
| `InfoLabel`     | `role_info`    |

**5 Role Panels** (extend `PanelContainer`) render a 6% tint of the matching role
color over the per-direction panel chrome:

| Variation       | Tint role      |
|-----------------|----------------|
| `AccentPanel`   | `role_primary` |
| `InfoPanel`     | `role_info`    |
| `WarningPanel`  | `role_warning` |
| `DangerPanel`   | `role_danger`  |
| `SuccessPanel`  | `role_success` |

Apply via the Inspector's `Theme Type Variation` field or in code:

\`\`\`gdscript
my_label.theme_type_variation = &"SuccessLabel"
my_panel.theme_type_variation = &"AccentPanel"
\`\`\`

The 10th showcase section in `showcase/showcase.tscn` ("Role Variations")
demonstrates each one with consumer-style content.
```

**Conventions/invariants:**
- Section headers use `## <Title>` (h2). Phase 13's section is h2 — same level as `## Usage`, `## Showcase`, `## Design Rules`.
- Inline code uses backticks; multi-line code uses ` ```gdscript ` fenced blocks. See lines 39, 50.
- Use the `&"<Name>"` StringName literal syntax in code samples (matches `showcase.tscn` convention; matches how Godot displays variations in the Inspector).
- Markdown tables use `| col | col |` syntax with header separator. The existing README uses one at lines 30-36 (in docs/usage.md, which the README links to).
- No emoji (per CLAUDE.md visual rules).

**Pitfalls flagged:**
- The 6% tint contract is a documentation-level claim. If Pitfall 1 forces the precomputed-mix fallback, the README copy stays valid (still "6% tint of the matching role color") but the implementation path changes.
- The 9 variations are addressable via Godot Inspector's `Theme Type Variation` autocomplete field — once the theme's `set_type_variation` calls run (line 433 of neocade_theme.gd), Godot picks up the new variation names automatically.

---

## Shared Patterns

### Pattern A: BINDING_TABLE recipe shape — "additive opt-in" rule

**Source:** `addons/neocade_theme/scripts/neocade_theme.gd` lines 4937-4944 (Caption) + lines 5015-5034 (CardPanel)

**Apply to:** Files #2 and #3 (BINDING_TABLE additions)

**Rule:** Each new top-level BINDING_TABLE entry is a fully-specified recipe — Godot REPLACES (not merges) by (slot, type). Mirror the closest existing variation entry verbatim; swap only the role tokens and tint alpha as needed. DO NOT modify the base type's entry (e.g., default `Label`, default `PanelContainer`) — that would silently re-bind defaults and break SC#3.

### Pattern B: PITFALLS 1.2 — explicit fonts for type variations

**Source:** `addons/neocade_theme/scripts/neocade_theme.gd` lines 435-462 (set_font block) + lines 497-527 (set_font_size block)

**Apply to:** File #4 (Role Label fonts)

**Rule:** Every Label-family type variation needs a matching `set_font("font", "<Name>", body_font)` AND `set_font_size("font_size", "<Name>", tokens.body)` in `_regenerate_theme()`. PanelContainer-family variations need NO font calls unless their content layout demands one (CardPanel and HeroPanel set fonts at lines 461-462 for nested layout but that's a content-side choice, not a theme requirement).

### Pattern C: Headless verifier skeleton

**Source:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` lines 1-254 (full file)

**Apply to:** File #6 (Phase 13 verifier)

**Rule:** Phase verifiers are `extends SceneTree` GDScript files that:
1. Parse `--stage <name>` from `OS.get_cmdline_user_args()` with fallback to `OS.get_cmdline_args()` (Phase 12 lines 45-65).
2. Dispatch via `match` on stage name (Phase 12 lines 68-83).
3. Collect failures into `_failures: Array[String]`, print all on quit, exit 0/1 (Phase 12 lines 240-253).
4. Each stage's success print is gated on `_failures.is_empty()` — WR-01/WR-02 invariant (Phase 12 lines 171-173, 215-217).
5. Marker prefix `PHASE<N>_VERIFY:` for CI grep.
6. Provide `_fresh_theme()` that loads the canonical .tres and duplicates (avoids cross-test contamination) — Phase 12 lines 222-228.

### Pattern D: Showcase ScrollContainer section

**Source:** `showcase/showcase.tscn` lines 108-336 (Buttons), 1032-1122 (Token Gallery), 1124-1244+ (Coverage 37 of 37)

**Apply to:** File #5 (10th showcase tab)

**Rule:** Each section is a `ScrollContainer` direct child of `RootMargin/RootStack/ShowcaseTabs`, with:
- Required attrs: `layout_mode = 2`, `horizontal_scroll_mode = 1`, `metadata/_tab_index = <next-0-indexed>`
- `visible = false` for every non-index-0 tab
- Children: `Margin` (MarginContainer with `theme_override_constants/margin_* = 12/12/12/24`) → either `Grid` (GridContainer) or `Stack` (VBoxContainer) → cells
- Each cell uses `theme_type_variation = &"<Name>"` to demonstrate the variation
- Each section opens with a `<Name>SectionKicker` Label using `theme_type_variation = &"Kicker"` and uppercase title text

### Pattern E: `theme_type_variation` consumer apply

**Source:** `showcase/showcase.tscn` per-cell usage (e.g., lines 130-131, 143-144, 150-151, 1095-1096, 1100-1101) + repo-root `README.md` lines 50-55

**Apply to:** Files #5 (showcase cells) and #9 (README sample code)

**Rule:** Consumers opt into a variation with `node.theme_type_variation = &"<Name>"`. The `&` prefix denotes a StringName literal — required for the property type. Existing showcase nodes use this verbatim; README sample code should mirror it.

---

## No Analog Found

All 9 file targets have a strong analog. No "no analog" rows.

---

## Cross-Cutting Decisions

| Decision | Locked Value | Source |
|----------|--------------|--------|
| `EXPECTED_BINDING_TABLE_ROWS` post-Phase-13 | `149` | RESEARCH line 597 + 140 baseline + 9 additions |
| `EXPECTED_TYPE_VARIATIONS_COUNT` post-Phase-13 | `56` | RESEARCH line 599 + 47 baseline + 9 additions |
| Role Panel tint alpha | `0.06` literal float | RESEARCH Pattern 3 + ROADMAP Phase 13 § C3 ("6%-mix tint") |
| Role Panel border_role | `"surface_panel_edge"` (NOT `role_<x>_edge`) | Mirrors base PanelContainer; no per-role edge token exists |
| Role Panel padding | `Vector2i(12, 10)` | Mirrors CardPanel; reads like a Card |
| Role Label font_size | `tokens.body` (NOT `tokens.label_`) | RESEARCH Example 3 — body-weight labels, not small captions |
| README target | repo-root `README.md` | RESEARCH § Recommended Project Structure line 139 + FOUND-01 |
| `unique_id` reservation | `2700000010` – `2700000050` | RESEARCH Pattern 4 + Pitfall 5 |
| `metadata/_tab_index` for new section | `9` | Existing tabs occupy 0-8 (verified lines 111/1036/1128) |
| Section name | `"Role Variations"` (with space) | Matches plural-noun convention of existing tabs |

---

## Metadata

**Analog search scope:**
- `addons/neocade_theme/scripts/neocade_theme.gd` (5,679 lines) — production addon (full structure surveyed; specific line ranges read)
- `showcase/showcase.tscn` (1,406 lines) — showcase scene (sections surveyed, Buttons template + Token Gallery + Coverage 37/37 read in detail)
- `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` (254 lines) — verifier analog (full read)
- `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd` (122 lines) — smoke matrix analog (full read)
- `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd` (101 lines) — EditorScript render variant (full read)
- `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render_runtime.gd` (88 lines) — runtime render variant (full read; preferred analog)
- `README.md` (116 lines, repo root — full read)
- `.planning/ROADMAP.md` Phase 13 section (lines 590-619)
- `.planning/phases/13-role-variations/13-RESEARCH.md` (~700 lines, partial: lines 1-400 + 400-700)

**Files scanned:** 8 source files + 1 ROADMAP excerpt + 1 RESEARCH document

**Pattern extraction date:** 2026-05-11
