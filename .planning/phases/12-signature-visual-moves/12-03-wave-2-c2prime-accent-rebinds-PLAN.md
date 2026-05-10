---
phase: 12
plan: 03
type: execute
wave: 2
depends_on: [12-01, 12-02]
files_modified:
  - addons/neocade_theme/scripts/neocade_theme.gd
autonomous: true
requirements: []
must_haves:
  truths:
    - "Selected TabBar tabs render with a 2px top accent stripe (`role_primary` border color)."
    - "Selected TabContainer tabs render with a 2px top accent stripe (`role_primary` border color)."
    - "Selected ItemList rows render with a 3px left accent stripe (`role_primary` border color)."
    - "Selected (`selected_focus`) ItemList rows render with a 3px left accent stripe."
    - "Selected Tree rows render with a 3px left accent stripe (`role_primary` border color)."
    - "Selected (`selected_focus`) Tree rows render with a 3px left accent stripe."
    - "Section-header underline rebind (RESEARCH OQ2) is EXPLICITLY DEFERRED — HSeparator stylebox is shared with PopupMenu separators; collateral risk too high for the showcase footprint."
    - "The 37-row BINDING_TABLE freeze is preserved (Cycle 1 C1 invariant — only color sources change, no row added/removed)."
    - "SC#5 invariant: no new hues introduced; every rebind uses `role_primary` (the canonical accent role) — never a fresh `Color()` literal."
    - "SC#1 invariant: rebinds carry `raised_intensity: 0` (already on every C2' row); they remain flat at `raised=false` and at `raised=true`."
    - "SC#6 invariant: 12-export contract preserved."
  artifacts:
    - path: "addons/neocade_theme/scripts/neocade_theme.gd"
      provides: "6 BINDING_TABLE recipe rows rebound from neutral tokens to `role_primary` via `border_widths` + `border_role`"
      contains: "border_role\": \"role_primary"
  key_links:
    - from: "BINDING_TABLE TabBar/TabContainer.tab_selected"
      to: "role_table.role_primary (accent_color)"
      via: "border_widths: Vector4i(0, 2, 0, 0) + border_role: role_primary (top 2px stripe)"
      pattern: "tab_selected.*border_role.*role_primary"
    - from: "BINDING_TABLE ItemList.selected / ItemList.selected_focus"
      to: "role_table.role_primary"
      via: "border_widths: Vector4i(3, 0, 0, 0) + border_role: role_primary (left 3px stripe)"
      pattern: "ItemList.*selected.*border_role.*role_primary"
    - from: "BINDING_TABLE Tree.selected / Tree.selected_focus"
      to: "role_table.role_primary"
      via: "border_widths: Vector4i(3, 0, 0, 0) + border_role: role_primary (left 3px stripe)"
      pattern: "Tree.*selected.*border_role.*role_primary"
---

<objective>
Implement C2' — the headline fix per D-12.06. Rebind six existing BINDING_TABLE rows
so that selected tabs and selected list/tree rows surface the `accent_color` (via
`role_primary` token) instead of the current neutral `button_pressed` chrome. This
gives the accent airtime in idle chrome without introducing any new hues, new
BINDING_TABLE rows, or new public exports.

Purpose: at the end of Wave 2 the user's "generic dark Godot theme with an accent
color" complaint is resolved. Even if Wave 3 (C6) defers to a follow-up (per D-12.20
mid-phase fallback), Wave 1 + Wave 2 leave a shippable state with C4 depth-fidelity
fix + C2' accent-airtime fix.

Output: 1 file modified (`addons/neocade_theme/scripts/neocade_theme.gd`), six surgical
edits to BINDING_TABLE recipe rows at known line numbers, atomic commit.
</objective>

<execution_context>
@$HOME/.claude/get-shit-done/workflows/execute-plan.md
@$HOME/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/phases/12-signature-visual-moves/12-CONTEXT.md
@.planning/phases/12-signature-visual-moves/12-RESEARCH.md
@.planning/phases/12-signature-visual-moves/12-PATTERNS.md
@CLAUDE.md

<interfaces>
<!-- Recipe-resolution facts extracted from addons/neocade_theme/scripts/neocade_theme.gd -->

# _resolve_recipe() stylebox branch behavior the rebinds rely on:
# (lines 5276-5391; key segment for border handling at lines 5376-5391)

var border_width: int = int(recipe.get("border_width", outline_width))      # line 5376
var border_role: String = recipe.get("border_role", "outline_color")        # line 5377
var border_color: Color = role_table.get(border_role, role_table.outline_color)  # line 5378
var border_alpha: float = float(recipe.get("border_alpha", 1.0))            # line 5379
# ...
var border_widths_raw: Variant = recipe.get("border_widths", null)          # line 5382
if border_widths_raw != null and typeof(border_widths_raw) == TYPE_VECTOR4I:
    var widths := border_widths_raw as Vector4i
    sb.border_color = border_color
    sb.border_width_left = maxi(0, widths.x)                                # line 5386
    sb.border_width_top = maxi(0, widths.y)                                 # line 5387
    sb.border_width_right = maxi(0, widths.z)                               # line 5388
    sb.border_width_bottom = maxi(0, widths.w)                              # line 5389
else:
    _apply_outline_border(sb, border_color, maxi(0, border_width))          # line 5391

# CRITICAL implications for this plan:
# (a) When `border_widths: Vector4i(...)` is present, `border_width` is IGNORED.
#     => Remove the `"border_width": 0` field from rebound rows (it's noise).
# (b) `border_role: "role_primary"` resolves to `role_table.role_primary` which IS
#     `accent_color` (verified in role_table builder at line ~598 — `role_primary` is
#     the canonical accent role).
# (c) `corner_profile: "tab_connected"` (TabBar/TabContainer tab_selected rows) is
#     handled by `_set_tab_connected_radius` at line 5370-5371; it zeros bottom
#     corners. The rebind must NOT remove this key — preserve it.
# (d) Vector4i layout is (x, y, z, w) → (left, top, right, bottom) per the
#     line-5386..5389 assignments. Top stripe = Vector4i(0, 2, 0, 0). Left stripe = Vector4i(3, 0, 0, 0).

# role_table key for accent (lines 598+ in _resolve_role_table):
role_table.role_primary  # IS accent_color; canonical accent role used across the codebase
</interfaces>

<exact_target_rows>
## The six rebind targets (with EXACT current source and target text)

### Target 1: TabBar.tab_selected — line 3443-3446
**BEFORE (current source):**
```gdscript
"tab_selected":     {"role": "button_pressed", "border_role": "button_border_pressed",
                        "raised_intensity": 0, "border_width": 0,
                        "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                        "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```
**AFTER (rebound — 2px top accent stripe):**
```gdscript
"tab_selected":     {"role": "button_pressed", "border_role": "role_primary",
                        "raised_intensity": 0,
                        "border_widths": Vector4i(0, 2, 0, 0),
                        "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                        "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```
Diff: `border_role` neutral→`role_primary`; replace `"border_width": 0` with `"border_widths": Vector4i(0, 2, 0, 0)`.

### Target 2: TabContainer.tab_selected — line 3495-3498
**BEFORE:**
```gdscript
"tab_selected":     {"role": "button_pressed", "border_role": "button_border_pressed",
                        "raised_intensity": 0, "border_width": 0,
                        "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                        "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```
**AFTER (identical rebind to Target 1 — TabBar and TabContainer share idiom):**
```gdscript
"tab_selected":     {"role": "button_pressed", "border_role": "role_primary",
                        "raised_intensity": 0,
                        "border_widths": Vector4i(0, 2, 0, 0),
                        "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                        "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

### Target 3: ItemList.selected — line 3019-3020
**BEFORE:**
```gdscript
"selected":               {"role": "button_pressed", "border_role": "button_pressed",
                            "raised_intensity": 0, "border_width": 0},
```
**AFTER (3px left accent stripe):**
```gdscript
"selected":               {"role": "button_pressed", "border_role": "role_primary",
                            "raised_intensity": 0,
                            "border_widths": Vector4i(3, 0, 0, 0)},
```

### Target 4: ItemList.selected_focus — line 3021-3022
**BEFORE:**
```gdscript
"selected_focus":         {"role": "button_pressed", "border_role": "button_pressed",
                            "raised_intensity": 0, "border_width": 0},
```
**AFTER (identical to Target 3):**
```gdscript
"selected_focus":         {"role": "button_pressed", "border_role": "role_primary",
                            "raised_intensity": 0,
                            "border_widths": Vector4i(3, 0, 0, 0)},
```

### Target 5: Tree.selected — line 4040-4041
**BEFORE:**
```gdscript
"selected":               {"role": "button_pressed", "raised_intensity": 0,
                            "border_role": "button_pressed", "border_width": 0},
```
**AFTER (3px left accent stripe — note: Tree row has `raised_intensity` BEFORE `border_role`, preserve relative ordering for git-diff cleanliness):**
```gdscript
"selected":               {"role": "button_pressed", "raised_intensity": 0,
                            "border_role": "role_primary",
                            "border_widths": Vector4i(3, 0, 0, 0)},
```

### Target 6: Tree.selected_focus — line 4042-4043
**BEFORE:**
```gdscript
"selected_focus":         {"role": "button_pressed", "raised_intensity": 0,
                            "border_role": "button_pressed", "border_width": 0},
```
**AFTER (identical to Target 5):**
```gdscript
"selected_focus":         {"role": "button_pressed", "raised_intensity": 0,
                            "border_role": "role_primary",
                            "border_widths": Vector4i(3, 0, 0, 0)},
```

## NOT rebound (intentionally — per RESEARCH § Open Question 1 + D-12.07)

- **Kicker.font_color (line 4910-4911)** — already `{"kicker_style": "shape.kicker_style"}`,
  which resolves to `role_primary` for Pulse/Bubble/Daybreak/Burst via `_apply_kicker_style`
  at line ~5251. No code change needed; the C2' kicker rebind is a no-op.
- **HSlider.grabber_area_highlight (line 2938)** — already `"role": "accent_offset"`, an
  accent-derived token. Already C2'-compliant.
- **Slider/Range active value labels** — Godot 4.6 does not expose a separate
  "active value label" theme slot; consumer-side concern. Out of scope.
- **Section-header underlines / HSeparator stylebox** — DEFERRED per the planning
  constraint. HSeparator's stylebox is shared with PopupMenu separators; rebinding it
  would surface accent inside dropdown menu separators, which is the wrong visual.
  Phase 13 (or a future micro-spike) can re-evaluate after measuring whether the 6
  tabular/list rebinds alone produce sufficient accent airtime.
</exact_target_rows>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Rebind TabBar.tab_selected + TabContainer.tab_selected to a 2px top accent stripe</name>
  <files>addons/neocade_theme/scripts/neocade_theme.gd</files>
  <read_first>
    - addons/neocade_theme/scripts/neocade_theme.gd lines 3435-3492 (the full TabBar BINDING_TABLE entry — see the `tab_unselected`, `tab_hovered`, `tab_disabled`, `tab_focus` rows that MUST stay unchanged)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 3492-3549 (the full TabContainer BINDING_TABLE entry — same neighbor recipes; same preservation rule)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 5382-5391 (the `border_widths` handler that consumes the new field — confirms Vector4i layout x=left, y=top, z=right, w=bottom)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 3 "BINDING_TABLE color-source rebind (C2')" + "Notes for planner" especially the `corner_profile: tab_connected must be preserved` warning
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "Pattern 2: BINDING_TABLE color rebind (C2')"
  </read_first>
  <action>
Edit `addons/neocade_theme/scripts/neocade_theme.gd`. Make two surgical edits — one at TabBar.tab_selected (line 3443-3446) and one at TabContainer.tab_selected (line 3495-3498).

**Edit 1 — TabBar.tab_selected (line 3443-3446):**

Find this exact block (use a precise multi-line match; the leading whitespace is tabs):

```gdscript
			"tab_selected":     {"role": "button_pressed", "border_role": "button_border_pressed",
									"raised_intensity": 0, "border_width": 0,
									"radius": "shape.tab_radius", "corner_profile": "tab_connected",
									"padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

Replace it with:

```gdscript
			# Phase 12 C2' (D-12.06/07): 2px top accent stripe via role_primary border_role.
			# Vector4i layout = (left, top, right, bottom) per _resolve_recipe lines 5386-5389.
			"tab_selected":     {"role": "button_pressed", "border_role": "role_primary",
									"raised_intensity": 0,
									"border_widths": Vector4i(0, 2, 0, 0),
									"radius": "shape.tab_radius", "corner_profile": "tab_connected",
									"padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

**Edit 2 — TabContainer.tab_selected (line 3495-3498):**

Find this exact block:

```gdscript
			"tab_selected":     {"role": "button_pressed", "border_role": "button_border_pressed",
									"raised_intensity": 0, "border_width": 0,
									"radius": "shape.tab_radius", "corner_profile": "tab_connected",
									"padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

Replace it with (identical structure — TabBar and TabContainer share idiom per Phase 6 convention):

```gdscript
			# Phase 12 C2' (D-12.06/07): 2px top accent stripe (matches TabBar tab_selected idiom).
			"tab_selected":     {"role": "button_pressed", "border_role": "role_primary",
									"raised_intensity": 0,
									"border_widths": Vector4i(0, 2, 0, 0),
									"radius": "shape.tab_radius", "corner_profile": "tab_connected",
									"padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

CRITICAL invariants:
- DO NOT change `tab_unselected`, `tab_hovered`, `tab_disabled`, or `tab_focus` rows. They are NOT part of C2'.
- DO NOT change the `font_selected_color` / `font_unselected_color` / `drop_mark_color` color rows below the stylebox section — those use different role tokens already.
- The `"role": "button_pressed"` face stays unchanged — the selected tab face is still the pressed-button surface tint; only the BORDER (which the user reads as "the selected indicator") becomes accent.
- The 4-tab grid (`tab_selected`, `tab_unselected`, `tab_hovered`, `tab_disabled`) must remain visually distinct. Hover/unselected/disabled keep their neutral borders so the accent stripe is unambiguously the SELECTED state's signal.
- Verify the 37-row BINDING_TABLE freeze: after the edit, `BINDING_TABLE.size()` must still be 37.

Use tab indentation matching the surrounding lines (verified: TabBar/TabContainer recipes are indented with leading 3 tabs).
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage architecture && godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc2-tabs-flat-when-raised && godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc3-no-glow-halo</automated>
  </verify>
  <acceptance_criteria>
    - The file contains exactly TWO `tab_selected.*border_role.*role_primary` matches (one for TabBar, one for TabContainer). Verify with `grep -E 'tab_selected.*role_primary' addons/neocade_theme/scripts/neocade_theme.gd | wc -l` returning 2.
    - The file contains exactly TWO `Vector4i(0, 2, 0, 0)` occurrences (the top-stripe layout for the two tab_selected rows). Verify with `grep -c 'Vector4i(0, 2, 0, 0)' addons/neocade_theme/scripts/neocade_theme.gd` returning 2.
    - The string `"border_role": "button_border_pressed"` no longer appears in the `tab_selected` rows. Verify by reading lines 3440-3500 — `button_border_pressed` appears only in `button_pressed` recipe rows (NOT in `tab_selected`).
    - BINDING_TABLE row count check via verifier: `--stage architecture` exits 0 (asserts size == 37).
    - SC#2 still green: `--stage sc2-tabs-flat-when-raised` exits 0 (tabs still have `raised_intensity: 0` and no shadow).
    - SC#3 still green: `--stage sc3-no-glow-halo` exits 0 (border_alpha defaults to 1.0 — no halo introduced).
    - All 4 sibling tab rows (`tab_unselected`, `tab_hovered`, `tab_disabled`, `tab_focus`) in both TabBar and TabContainer entries are unchanged. Verify with `grep -E '"tab_unselected"|"tab_hovered"|"tab_disabled"|"tab_focus"' addons/neocade_theme/scripts/neocade_theme.gd | wc -l` returning 8 (4 per Control × 2 Controls).
  </acceptance_criteria>
  <done>TabBar and TabContainer selected tabs now render a 2px top accent stripe; sibling tab states unchanged; BINDING_TABLE row count = 37; full verifier stages green.</done>
</task>

<task type="auto">
  <name>Task 2: Rebind ItemList + Tree selected/selected_focus rows to a 3px left accent stripe</name>
  <files>addons/neocade_theme/scripts/neocade_theme.gd</files>
  <read_first>
    - addons/neocade_theme/scripts/neocade_theme.gd lines 3006-3050 (the full ItemList BINDING_TABLE entry — see how `cursor`, `cursor_unfocused`, `hovered`, `hovered_selected`, `hovered_selected_focus` neighbor rows MUST stay unchanged)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 4017-4090 (the full Tree BINDING_TABLE entry — same preservation rule; note Tree has BOTH `selected`/`selected_focus` AND `hovered_selected`/`hovered_selected_focus`)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 3 "BINDING_TABLE color-source rebind (C2')" — especially "DO NOT apply hairline override inside the border_widths: Vector4i branch" note (relevant for Plan 04, mentioned here for awareness)
  </read_first>
  <action>
Edit `addons/neocade_theme/scripts/neocade_theme.gd`. Make four surgical edits — one at each of ItemList.selected, ItemList.selected_focus, Tree.selected, Tree.selected_focus.

**Edit 1 — ItemList.selected (line 3019-3020):**

Find this exact block:

```gdscript
			"selected":               {"role": "button_pressed", "border_role": "button_pressed",
										"raised_intensity": 0, "border_width": 0},
```

Replace with:

```gdscript
			# Phase 12 C2' (D-12.06/07): 3px left accent stripe via role_primary border_role.
			"selected":               {"role": "button_pressed", "border_role": "role_primary",
										"raised_intensity": 0,
										"border_widths": Vector4i(3, 0, 0, 0)},
```

**Edit 2 — ItemList.selected_focus (line 3021-3022):**

Find this exact block:

```gdscript
			"selected_focus":         {"role": "button_pressed", "border_role": "button_pressed",
										"raised_intensity": 0, "border_width": 0},
```

Replace with:

```gdscript
			# Phase 12 C2' (D-12.06/07): 3px left accent stripe (matches ItemList.selected).
			"selected_focus":         {"role": "button_pressed", "border_role": "role_primary",
										"raised_intensity": 0,
										"border_widths": Vector4i(3, 0, 0, 0)},
```

**Edit 3 — Tree.selected (line 4040-4041):**

Find this exact block (note: Tree row's `raised_intensity` precedes `border_role` — preserve that ordering):

```gdscript
			"selected":               {"role": "button_pressed", "raised_intensity": 0,
										"border_role": "button_pressed", "border_width": 0},
```

Replace with:

```gdscript
			# Phase 12 C2' (D-12.06/07): 3px left accent stripe (matches ItemList.selected idiom).
			"selected":               {"role": "button_pressed", "raised_intensity": 0,
										"border_role": "role_primary",
										"border_widths": Vector4i(3, 0, 0, 0)},
```

**Edit 4 — Tree.selected_focus (line 4042-4043):**

Find this exact block:

```gdscript
			"selected_focus":         {"role": "button_pressed", "raised_intensity": 0,
										"border_role": "button_pressed", "border_width": 0},
```

Replace with:

```gdscript
			# Phase 12 C2' (D-12.06/07): 3px left accent stripe.
			"selected_focus":         {"role": "button_pressed", "raised_intensity": 0,
										"border_role": "role_primary",
										"border_widths": Vector4i(3, 0, 0, 0)},
```

CRITICAL invariants:
- DO NOT modify `hovered_selected` or `hovered_selected_focus` rows in either ItemList or Tree. The user-locked C2' targets are *only* `selected` and `selected_focus` (per D-12.07 items 2 & 3). The hover-on-selected states keep their existing chrome to preserve the visual hierarchy (the user can see the difference between "this is selected" and "I am hovering over this selected row").
- DO NOT modify `cursor` / `cursor_unfocused` rows. They use `alpha: 0.72` / `0.46` for the overlay effect — they are NOT part of C2'.
- DO NOT modify the `font_selected_color` or `font_hovered_selected_color` color rows below the stylebox section. Per the existing code at lines 3031-3032 and 4067/4069, they ALREADY use `role_primary` — no change needed.
- ItemListSecondary at lines 3051+ is a separate dictionary entry that is NOT part of C2'. Leave it untouched.

Use tab indentation matching the surrounding lines (3 leading tabs for the ItemList block; 3 leading tabs for the Tree block).
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full && godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"</automated>
  </verify>
  <acceptance_criteria>
    - The file contains exactly FOUR `Vector4i(3, 0, 0, 0)` occurrences (2 ItemList + 2 Tree left-stripe rebinds). Verify with `grep -c 'Vector4i(3, 0, 0, 0)' addons/neocade_theme/scripts/neocade_theme.gd` returning 4.
    - Counting all 6 rebinds: `grep -cE '"border_role": "role_primary"' addons/neocade_theme/scripts/neocade_theme.gd` returns at least 6 (2 tabs + 4 list/tree rows; any pre-existing role_primary border_role bindings increase the count further but the floor is 6).
    - All four target rows now contain `"border_role": "role_primary"` (verifiable via grep on each row's surrounding `selected` / `selected_focus` keyword + role_primary).
    - The four target rows no longer contain `"border_role": "button_pressed"` (verify the count of `"border_role": "button_pressed"` in the file dropped by exactly 4 from baseline; the remaining `button_pressed` border_role bindings are in `hovered_selected` / `hovered_selected_focus` rows for ItemList/Tree).
    - `hovered_selected` and `hovered_selected_focus` rows still contain `"border_role": "button_pressed"` (verify by inspection of lines 3023-3026 for ItemList and 4044-4047 for Tree).
    - BINDING_TABLE row count check: `--stage architecture` exits 0.
    - SC#1 still green: `--stage sc1-no-3d-when-flat` exits 0 (`raised_intensity: 0` preserved on every rebound row).
    - SC#2 still green: `--stage sc2-tabs-flat-when-raised` exits 0.
    - SC#3 still green: `--stage sc3-no-glow-halo` exits 0.
    - SC#6 still green: 12 exports preserved (`grep -c '^@export ' addons/neocade_theme/scripts/neocade_theme.gd` returns 12).
    - 30-config smoke matrix exits 0 with `PHASE12_SMOKE: PASS`.
    - `--stage full` exits 0.
  </acceptance_criteria>
  <done>ItemList and Tree selected/selected_focus rows render a 3px left accent stripe; hover-on-selected states and cursor overlays unchanged; full verifier suite green; smoke matrix green.</done>
</task>

<task type="auto">
  <name>Task 3: Document the deferred section-header underline rebind in code comments and the plan summary</name>
  <files>addons/neocade_theme/scripts/neocade_theme.gd</files>
  <read_first>
    - addons/neocade_theme/scripts/neocade_theme.gd — grep for `HSeparator` and `_apply_separator_styleboxes` to confirm the shared-stylebox concern is real (HSeparator's stylebox is used by PopupMenu separators per Phase 7 conventions)
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "Open Question 2" — the section-header underline rebind concern
    - .planning/phases/12-signature-visual-moves/12-CONTEXT.md D-12.07 item 6 (the "Section-header underlines" target, locked to be re-evaluable in a follow-up)
  </read_first>
  <action>
This task adds a single one-line code comment near `_apply_separator_styleboxes` (or wherever HSeparator styleboxes are defined) documenting the deferred decision. This is for code-readers: future contributors looking for the section-header underline accent should find a clear "we considered this, here's why we deferred" anchor.

Step 1 — find the HSeparator declaration site. Grep the file for `HSeparator` and identify which BINDING_TABLE row(s) define its stylebox. There is likely a row like `"HSeparator": { "stylebox": { ... } }`. If `_apply_separator_styleboxes` is a function that drives HSeparator's stylebox declaratively, anchor the comment above its call site.

Step 2 — insert ONE comment line above the HSeparator entry (or above `_apply_separator_styleboxes` if BINDING_TABLE delegates to it). Use exactly this text:

```gdscript
# Phase 12 C2' note (RESEARCH OQ2 / D-12.07 item 6): the section-header underline
# accent rebind was DEFERRED. HSeparator's stylebox is shared with PopupMenu
# separators (Phase 7 convention); rebinding here would surface accent inside
# dropdown menu separators — wrong visual. Re-evaluate after Wave 3 ships if
# accent airtime in headings still feels under-served.
```

Use tab indentation matching the surrounding context (typically 1 leading tab if it's BINDING_TABLE-adjacent, 0 if it's a top-level function).

Step 3 — do NOT change any HSeparator code. This is a comment-only edit.

If the HSeparator row does not exist in BINDING_TABLE (it may be entirely handled by `_apply_separator_styleboxes` outside the table), place the comment above that function's `func` line instead. Whichever location the executor picks, the comment must be discoverable by `grep -n "RESEARCH OQ2"` returning at least one hit.
  </action>
  <verify>
    <automated>grep -c 'RESEARCH OQ2' addons/neocade_theme/scripts/neocade_theme.gd</automated>
  </verify>
  <acceptance_criteria>
    - The file contains the literal string `RESEARCH OQ2` exactly once (verifiable via `grep -c 'RESEARCH OQ2' addons/neocade_theme/scripts/neocade_theme.gd` returning 1).
    - The file contains the literal string `DEFERRED` (uppercase) on the same line or within 5 lines of `RESEARCH OQ2`.
    - The file contains the literal phrase `HSeparator` AND `PopupMenu separators` in the deferred-note comment block (proving the rationale is recorded).
    - No production code lines were changed in this task (verify with `git diff --stat addons/neocade_theme/scripts/neocade_theme.gd` showing only comment-line additions — no `-` lines from this commit other than the 6 rebound recipe rows from prior tasks).
    - `--stage architecture` still exits 0 (comments do not affect runtime).
  </acceptance_criteria>
  <done>The deferred section-header underline rebind is documented in code with a discoverable anchor (`RESEARCH OQ2`) so future readers can find it and reopen the decision if needed.</done>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| BINDING_TABLE recipe data → `_resolve_recipe()` stylebox builder | Internal data flow; recipes are project-controlled constants. |
| Recipe `border_role` string → `role_table.get(...)` lookup | Project-controlled string; falls back to `outline_color` on unknown role per line 5378. |

## STRIDE Threat Register

| Threat ID | Category | Component | Disposition | Mitigation Plan |
|-----------|----------|-----------|-------------|-----------------|
| T-12.03-01 | Tampering | BINDING_TABLE row count drift | mitigate | The `--stage architecture` verifier asserts BINDING_TABLE.size() == 37. Any accidental row add/remove during the edit fails the gate immediately. |
| T-12.03-02 | Information disclosure | Accent color leakage | accept | The accent color is the `accent_color` `@export var` — already a public part of the API. Surfacing it in selected chrome is the intended outcome. |
| T-12.03-03 | Spoofing | Unknown role string → silent fallback | mitigate | `role_table.get("role_primary", role_table.outline_color)` (line 5378) — if `role_primary` were somehow missing, the fallback is `outline_color`, NOT a panic. RESEARCH § "Anti-Patterns" bullet 6 confirms `role_primary` is the canonical role key. Verified to exist at line ~598 in `_resolve_role_table`. |
| T-12.03-04 | Denial of service | Vector4i parsing in `_resolve_recipe` | accept | The handler at line 5382-5389 is typed-checked (`typeof(border_widths_raw) == TYPE_VECTOR4I`) and falls back to the `else` branch on mismatch. No null-deref or crash risk. |
| T-12.03-05 | Elevation of privilege | None applicable | accept | Pure data-only change; no new code paths, no new privileges. |
</threat_model>

<verification>
After all 3 tasks complete, the full Phase 12 verifier suite + smoke matrix MUST be green:

```bash
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"
```

Both MUST exit 0.

Specific SC anchors:
- **SC#5 (no new hues):** `git diff feat/signature-visual-moves~..HEAD -- addons/neocade_theme/scripts/neocade_theme.gd | grep -E '^\+.*Color\('` should return ZERO new `Color(...)` literals introduced by this plan. The rebinds use string token names (`"role_primary"`) — no fresh color literals.
- **SC#1 (raised=false zero 3D):** `--stage sc1-no-3d-when-flat` green; every rebound row still has `raised_intensity: 0`.
- **SC#2 (tabs flat when raised):** `--stage sc2-tabs-flat-when-raised` green; the new top stripe is a 2px border, NOT a depth offset.
- **SC#3 (no glow halos):** `--stage sc3-no-glow-halo` green; `border_alpha` defaults to 1.0 per recipe — no intermediate alpha introduced.
- **SC#6 (12-export contract):** `grep -c '^@export ' addons/neocade_theme/scripts/neocade_theme.gd` returns exactly 12.

**Mid-phase fallback boundary (D-12.20):** at the end of Plan 03 / Wave 2, the user's
"generic dark Godot theme" complaint is resolved. C4 (Wave 1) fixed raised-button
affordance; C2' (Wave 2) gave accent airtime in idle chrome. Wave 3 (C6 per-direction
signatures) is additional polish that can defer to a follow-up if execution runs long.
The plan summary should explicitly state "Wave 2 ship state is verified — Wave 3 is
optional polish from here."
</verification>

<success_criteria>
- 6 BINDING_TABLE rows rebound (2 tab_selected, 2 ItemList selected*, 2 Tree selected*).
- BINDING_TABLE row count = 37 (unchanged from baseline; Cycle 1 C1 freeze preserved).
- 0 new `Color(...)` literals introduced (SC#5).
- 12 `@export var` declarations preserved (SC#6).
- 1 comment-only note documenting the deferred HSeparator rebind (`RESEARCH OQ2` anchor).
- `--stage full` and 30-config smoke matrix both exit 0.
- Mid-phase fallback boundary reached: Phase 12 is shippable at the end of Wave 2 if Wave 3 defers.
</success_criteria>

<output>
After completion, create `.planning/phases/12-signature-visual-moves/12-03-SUMMARY.md` documenting:
- The exact 6 rebound rows with before/after diffs (paste each `BEFORE` and `AFTER` block).
- Confirmation of BINDING_TABLE row count = 37 (paste `PHASE12_VERIFY: architecture OK` line).
- Confirmation of no new `Color(...)` literals (paste output of `git diff feat/signature-visual-moves~..HEAD -- addons/neocade_theme/scripts/neocade_theme.gd | grep -cE '^\+.*Color\('` — should be 0).
- Output of `--stage full` and the smoke matrix (paste the final PASS lines).
- The deferred HSeparator note text (proves Task 3 landed) and the line number where it was placed.
- Explicit statement: "Mid-phase fallback achieved — Wave 1 + Wave 2 leave a shippable Phase 12 state per D-12.20."
</output>
