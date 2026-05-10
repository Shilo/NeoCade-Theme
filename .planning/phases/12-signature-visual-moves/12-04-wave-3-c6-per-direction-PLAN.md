---
phase: 12
plan: 04
type: execute
wave: 3
depends_on: [12-01, 12-02, 12-03]
files_modified:
  - addons/neocade_theme/scripts/neocade_theme.gd
  - showcase/showcase.tscn
autonomous: false
requirements: []
must_haves:
  truths:
    - "Slate adds `hairline_thickness: 1` to its STYLE_PERSONALITY shape; chrome borders on interactive surfaces render at 1px when `raised` is either true or false."
    - "Bubble adds `min_radius_floor: 26` to its STYLE_PERSONALITY shape; every resolved stylebox radius is floored to >= 26 (Pitfall 4: max, NOT min — pill radii at 999 stay 999)."
    - "Daybreak adds `primary_outline_color: &\"role_primary\"`, `primary_outline_offset: 3`, `primary_outline_width: 1`; primary-button styleboxes render a 1px full-alpha accent outline 3px outside the button edge ONLY when `raised=true` (SC#1 gate)."
    - "Daybreak bumps `primary_padding` from `Vector2i(15, 9)` to `Vector2i(20, 14)` (generous primary padding)."
    - "Burst adds `primary_min_height: 56` to its STYLE_PERSONALITY shape; primary-button styleboxes' content_margin is floored so total minimum_size.y is >= 56 desktop / >= `tokens.primaryButtonMin` mobile."
    - "Pulse's C6 signature is realized via ONE new Kicker Label node in `showcase/showcase.tscn` above the `Buttons` section heading (no production code change; existing Kicker chrome already renders accent-tracked for Pulse)."
    - "STYLE_PERSONALITY_DEFAULT and every non-target direction has every new shape key with a NO-OP default value (Pitfall 5 mirror invariant: `hairline_thickness: 0`, `min_radius_floor: 0`, `primary_outline_color: &\"role_primary\"`, `primary_outline_offset: 0`, `primary_outline_width: 0`, `primary_min_height: 0`)."
    - "SC#1: every C6 mutation that introduces visible chrome NOT present at `raised=false` is wrapped in `if raised:` — verifier proves no 3D leakage at flat mode."
    - "SC#3: Daybreak outline uses `border_alpha = 1.0` (default); no halo/glow."
    - "SC#4: 5 greyscale thumbnails at 256x144 (one per style, `raised=true`) are saved and user-attested for direction-identifiability."
    - "SC#5: no new hues — `primary_outline_color = &\"role_primary\"` is a token reference, not a new `Color()` literal."
    - "SC#6: 12-export contract preserved — every new constant lives inside STYLE_PERSONALITY.shape, never as a top-level `@export var`."
    - "BINDING_TABLE row count remains 37 (Cycle 1 C1 freeze)."
  artifacts:
    - path: "addons/neocade_theme/scripts/neocade_theme.gd"
      provides: "5 new STYLE_PERSONALITY shape keys (per-direction signature data) + 4 _resolve_recipe thread-through blocks (Slate hairline, Bubble floor, Daybreak outline, Burst min-height)"
    - path: "showcase/showcase.tscn"
      provides: "1 new Kicker Label node above the Buttons section heading (Pulse C6 visibility)"
    - path: ".planning/phases/12-signature-visual-moves/artifacts/thumbnails/"
      provides: "5 greyscale PNGs at 256x144 (SC#4 evidence)"
  key_links:
    - from: "STYLE_PERSONALITY[Style.SLATE].shape.hairline_thickness"
      to: "_resolve_recipe stylebox branch (after line 5376, before line 5391)"
      via: "`_lookup_shape` gated override of `border_width` for recipes with `border_role`"
      pattern: "shape.hairline_thickness"
    - from: "STYLE_PERSONALITY[Style.BUBBLE].shape.min_radius_floor"
      to: "_resolve_recipe stylebox branch (between resolved_radius assignment line 5367 and _set_radius_all line 5368)"
      via: "maxi(resolved_radius, floor_v) before corner_profile dispatch"
      pattern: "shape.min_radius_floor"
    - from: "STYLE_PERSONALITY[Style.DAYBREAK].shape.primary_outline_*"
      to: "_resolve_recipe stylebox branch (after _apply_primary_strategy dispatch at line 5444)"
      via: "if raised AND strategy ends with .primary_strategy → apply expand_margin + override border"
      pattern: "shape.primary_outline_width"
    - from: "STYLE_PERSONALITY[Style.BURST].shape.primary_min_height"
      to: "_resolve_recipe stylebox branch (after padding application at line 5423)"
      via: "if recipe.strategy ends with .primary_strategy → floor content_margin sum to primary_min_height"
      pattern: "shape.primary_min_height"
---

<objective>
Implement C6 per-direction signature moves so each of the 5 directions has ONE
non-color, non-radius visual axis the others do NOT use, satisfying the SC#4
greyscale-identifiability gate (D-12.14).

Coverage (one signature per direction):
- **Pulse** — uppercase-tracked Kicker chrome (already wired; demo via showcase scene edit)
- **Slate** — 1px hairline borders on every interactive surface (`shape.hairline_thickness = 1`)
- **Bubble** — forced ≥26 corner radius across all chrome (`shape.min_radius_floor = 26`)
- **Daybreak** — 1px flat accent outline 3px outside primary CTAs + generous primary padding
- **Burst** — oversized primary CTAs (`shape.primary_min_height = 56` desktop)

Plus the locked invariants must all hold (SC#1 flat-mode zero 3D, SC#3 no halos,
SC#5 no new hues, SC#6 12-export contract, BINDING_TABLE 37-row freeze).

This plan is intentionally larger than 2-3 tasks because the per-direction edits
are not parallelizable (all in one file, one constant), and the Daybreak outline
+ Burst min-height threadthrough each requires a paired data edit + recipe edit.
The plan splits each direction into its own task with a final task for the
greyscale-thumbnail SC#4 user-attestation checkpoint.

Output:
- 1 production file modified (`addons/neocade_theme/scripts/neocade_theme.gd`)
- 1 scene file modified (`showcase/showcase.tscn`)
- 5 thumbnail PNGs produced (artifacts)
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
@.planning/phases/12-signature-visual-moves/12-VALIDATION.md
@CLAUDE.md

<interfaces>
<!-- Extracted from addons/neocade_theme/scripts/neocade_theme.gd -->

## STYLE_PERSONALITY block (lines 913-1094) — exact direction line ranges:
# Style.PULSE:     lines 918-949   (shape dict 920-948)
# Style.SLATE:     lines 954-985   (shape dict 956-984)
# Style.BUBBLE:    lines 990-1021  (shape dict 992-1020)
# Style.DAYBREAK:  lines 1026-1057 (shape dict 1028-1056)
# Style.BURST:     lines 1062-1093 (shape dict 1064-1092)
## STYLE_PERSONALITY_DEFAULT: lines 1158-1189 (shape dict 1160-1188)

## Daybreak's current primary_padding line: 1030  (Vector2i(15, 9) → bump to Vector2i(20, 14))

## _resolve_recipe stylebox branch landmarks (lines 5276-5450+):
# line 5305  if role == "focus_ring": ...   (skip — focus ring handles itself)
# line 5359  var radius_raw = recipe.get("radius", null)
# line 5360  var resolved_radius: int = corner_radius
# line 5361-5367  radius lookup (shape.* string → int)
# line 5368  _set_radius_all(sb, resolved_radius)
# line 5369-5375  corner_profile dispatch (tab_connected / top_only / bottom_only)
# line 5376  var border_width: int = int(recipe.get("border_width", outline_width))
# line 5377  var border_role: String = recipe.get("border_role", "outline_color")
# line 5378  var border_color: Color = role_table.get(border_role, role_table.outline_color)
# line 5379  var border_alpha: float = float(recipe.get("border_alpha", 1.0))
# line 5382-5389  border_widths: Vector4i branch (used by C2' rebinds)
# line 5391  else: _apply_outline_border(sb, border_color, maxi(0, border_width))
# line 5398-5423  padding application (Vector2i / Vector4i / shape.* lookups)
# line 5423  if not applied_padding: _set_content_margin_from_padding(sb, Vector2i.ZERO)
# line 5424-5433  expand_margins handler
# line 5438-5447  strategy dispatch (_apply_primary_strategy / _apply_ghost_strategy)
# line 5444     if (strategy_raw as String).ends_with(".primary_strategy"): ...

## _lookup_shape function (lines 5014-5028 approximately): returns Variant; null on missing path

## Helper functions available:
func _apply_outline_border(sb: StyleBoxFlat, color: Color, width: int = -1) -> void   # line 5091
func _set_expand_margins(sb: StyleBoxFlat, margins: Vector4i) -> void                  # line 5084
func _set_content_margin_from_padding(sb: StyleBoxFlat, padding: Vector2i) -> void     # in helpers
func _set_radius_all(sb: StyleBoxFlat, radius: int) -> void                             # in helpers

## Showcase Buttons section landmark (verified via grep):
# showcase/showcase.tscn:108  [node name="Buttons" type="ScrollContainer" parent="RootMargin/RootStack/ShowcaseTabs" unique_id=1865192939]
# showcase/showcase.tscn:138  theme_type_variation = &"Kicker"   (existing PrimaryButton Kicker label)
</interfaces>

<style_personality_default_target>
## STYLE_PERSONALITY_DEFAULT shape dict — the Pitfall 5 mirror invariant

After this plan, the DEFAULT shape (lines 1160-1188) must contain ALL six new keys
with no-op default values. The recipe-side thread-through code MUST check `null`
AND the disable-sentinel for every lookup so `Style.CUSTOM` users (who fall back
to DEFAULT) get safe behavior.

New DEFAULT keys (no-op values):
- `"hairline_thickness": 0`   (Slate adds 1)
- `"min_radius_floor": 0`     (Bubble adds 26)
- `"primary_outline_color": &"role_primary"`  (safe token name; disable gate is width=0)
- `"primary_outline_offset": 0`
- `"primary_outline_width": 0`   (disable gate)
- `"primary_min_height": 0`   (disable gate; Burst adds 56)

Every non-target direction (Pulse, Bubble, Daybreak, Burst for hairline; Pulse,
Slate, Daybreak, Burst for min_radius_floor; etc.) also receives these keys at
their no-op default values. This is the "uniformly present" invariant from
RESEARCH § Slate specifics.
</style_personality_default_target>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Slate C6 — hairline_thickness shape key + recipe thread-through</name>
  <files>addons/neocade_theme/scripts/neocade_theme.gd</files>
  <read_first>
    - addons/neocade_theme/scripts/neocade_theme.gd lines 954-985 (Slate STYLE_PERSONALITY entry)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 5376-5391 (border_width / border_widths handler in _resolve_recipe — the insertion point for the hairline override)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 5 "Slate C6 — `hairline_thickness` thread-through" (full pattern + the "DO NOT apply hairline override inside the border_widths: Vector4i branch" warning — C2' rebinds must keep their explicit widths)
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "Slate - 1px hairline borders" (especially the mobile tap-target check)
  </read_first>
  <action>
Three sub-edits in one task. All in `addons/neocade_theme/scripts/neocade_theme.gd`.

**Edit 1 — add `hairline_thickness: 1` to Slate's STYLE_PERSONALITY.shape:**

Find Slate's shape dict (lines 956-984). Just before the `"focus_offset": 2,` line (around line 982), add:

```gdscript
			"hairline_thickness":  1,   # Phase 12 C6 Slate signature: 1px hairlines on interactive chrome.
```

Use 3 leading tabs + the existing key-padding alignment pattern (most keys in the dict have their values right-aligned to roughly column 27; mirror that). The key insertion should land between the existing `"surface_alpha_buttons": 1.00,` (line 968) and the `"raised_lifts": {` opening (line 969), OR between `"focus_offset": 2,` (line 982) and `"kicker_style": &"small-caps-subtle",` (line 983). Choose the location that minimizes diff — placement is purely cosmetic.

**Edit 2 — add no-op `hairline_thickness: 0` to ALL 4 OTHER directions + DEFAULT:**

The Pitfall 5 mirror invariant requires every direction (Pulse, Bubble, Daybreak, Burst) AND `STYLE_PERSONALITY_DEFAULT` to carry the key with value 0. Add one line to each shape dict:

```gdscript
			"hairline_thickness":  0,
```

Insert it at the same relative position in each shape dict (e.g., just before `"focus_offset":`). Total: 4 dict edits in STYLE_PERSONALITY (lines ~947, ~1019, ~1054, ~1090) + 1 in STYLE_PERSONALITY_DEFAULT (line ~1186). All 5 use value `0`.

**Edit 3 — thread `hairline_thickness` through `_resolve_recipe()` stylebox branch:**

Locate the existing line 5391 (`_apply_outline_border(sb, border_color, maxi(0, border_width))`). Just BEFORE that line — but AFTER the `else:` on line 5390 that opens this branch — insert the hairline override. Critically, this MUST live in the `else` branch (which handles uniform 4-sided borders); the `border_widths: Vector4i` branch above (5382-5389) MUST be untouched so C2' rebinds keep their explicit per-side widths.

Replace the existing `else:` + `_apply_outline_border` block (lines 5390-5391):

```gdscript
		else:
			_apply_outline_border(sb, border_color, maxi(0, border_width))
```

With:

```gdscript
		else:
			# Phase 12 C6 Slate: when shape.hairline_thickness > 0, force border_width to it
			# for any recipe carrying a border_role (= chrome-with-border, not structural empty).
			# Pitfall 5: shape.hairline_thickness defaults to 0 for non-Slate directions, so
			# this is a no-op everywhere except Style.SLATE.
			var hairline_raw: Variant = _lookup_shape(style_personality, "shape.hairline_thickness")
			var hairline_resolved: int = 0
			if hairline_raw != null and (typeof(hairline_raw) == TYPE_INT or typeof(hairline_raw) == TYPE_FLOAT):
				hairline_resolved = int(hairline_raw)
			if hairline_resolved > 0 and recipe.has("border_role"):
				border_width = hairline_resolved
			_apply_outline_border(sb, border_color, maxi(0, border_width))
```

CRITICAL invariants:
- The `if hairline_resolved > 0` disable-sentinel is REQUIRED. Without it, every direction's `border_width = 0` flat-mode chrome would silently flip to whatever junk `_lookup_shape` returned (it returns `null` for missing keys; the `null != null` check guards but the disable sentinel is defense-in-depth).
- The `recipe.has("border_role")` trigger condition scopes the hairline to chrome with a deliberate border. Recipes with `{"empty": true}` styleboxes never reach this branch. Recipes with `border_role` explicitly set (e.g., `outline_color`, `accent_rim`, `role_primary`) are the targets.
- DO NOT move the hairline override INSIDE the `if border_widths_raw != null` branch (lines 5382-5389). Those are the C2' rebound rows; their explicit per-side widths must win.
- Use tabs for indentation (match surrounding `if`/`else` block style — typically 2 leading tabs for the body inside `_resolve_recipe`).

Mobile tap-target check (per RESEARCH § Slate specifics): Slate's primary button on MOBILE resolves through `_apply_primary_strategy("quiet-pill")` which already sets a 1px border; the hairline override is a no-op for primary slots that already meet the 1px target. For LineEdit / Tree / ItemList / OptionButton, the override changes a 2-3px border to 1px. This is the intended SIgnature.
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full && godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"</automated>
  </verify>
  <acceptance_criteria>
    - `grep -c '"hairline_thickness":' addons/neocade_theme/scripts/neocade_theme.gd` returns 6 (5 directions + DEFAULT).
    - `grep -c '"hairline_thickness":  1' addons/neocade_theme/scripts/neocade_theme.gd` returns 1 (only Slate).
    - `grep -c '"hairline_thickness":  0' addons/neocade_theme/scripts/neocade_theme.gd` returns 5 (4 other directions + DEFAULT).
    - The string `_lookup_shape(style_personality, "shape.hairline_thickness")` appears exactly once.
    - The phrase `recipe.has("border_role")` appears within 5 lines of the `_lookup_shape("shape.hairline_thickness")` call.
    - BINDING_TABLE row count check: `--stage architecture` exits 0 (size still 37).
    - SC#1: `--stage sc1-no-3d-when-flat` exits 0 (hairlines do not introduce depth).
    - SC#6: `grep -c '^@export ' addons/neocade_theme/scripts/neocade_theme.gd` returns exactly 12 (no new `@export var` added — `hairline_thickness` lives in STYLE_PERSONALITY.shape per the Pitfall 5 mirror).
    - 30-config smoke matrix exits 0.
  </acceptance_criteria>
  <done>Slate's 1px hairline signature is wired and verified; all 5 directions + DEFAULT carry the key uniformly; smoke matrix green.</done>
</task>

<task type="auto">
  <name>Task 2: Bubble C6 — min_radius_floor shape key + recipe thread-through (Pitfall 4: max, NOT min)</name>
  <files>addons/neocade_theme/scripts/neocade_theme.gd</files>
  <read_first>
    - addons/neocade_theme/scripts/neocade_theme.gd lines 990-1021 (Bubble STYLE_PERSONALITY entry)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 5359-5375 (radius resolution + corner_profile dispatch in _resolve_recipe)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 6 "Bubble C6 — min_radius_floor thread-through" (full pattern + the Pitfall 4 warning: use `max`, NOT `min`)
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "Bubble - Forced >=26 corner radius" + Pitfall 4
  </read_first>
  <action>
Three sub-edits in one task. All in `addons/neocade_theme/scripts/neocade_theme.gd`.

**Edit 1 — add `min_radius_floor: 26` to Bubble's STYLE_PERSONALITY.shape:**

Find Bubble's shape dict (lines 992-1020). Just before `"focus_offset": 2,` (around line 1018), add:

```gdscript
			"min_radius_floor":    26,   # Phase 12 C6 Bubble signature: floor every resolved radius to >= 26.
```

**Edit 2 — add no-op `min_radius_floor: 0` to ALL 4 OTHER directions + DEFAULT:**

Same Pitfall 5 mirror as Slate. Add one line to Pulse, Slate, Daybreak, Burst, and STYLE_PERSONALITY_DEFAULT shape dicts:

```gdscript
			"min_radius_floor":    0,
```

Total: 5 dict edits (1 with value 26, 4 with value 0) + 1 DEFAULT edit (value 0). Net: 6 lines added.

**Edit 3 — thread `min_radius_floor` through `_resolve_recipe()` radius resolution:**

Locate the existing block at lines 5359-5368 (radius resolution + `_set_radius_all` call). The floor must be applied AFTER `resolved_radius` is computed but BEFORE `_set_radius_all` (line 5368) AND BEFORE the corner_profile dispatch (lines 5369-5375). Insert between line 5367 (closing of the radius lookup if/elif) and line 5368 (`_set_radius_all(sb, resolved_radius)`).

The CURRENT block (lines 5359-5375):

```gdscript
		var radius_raw: Variant = recipe.get("radius", null)
		var resolved_radius: int = corner_radius
		if radius_raw != null:
			if typeof(radius_raw) == TYPE_STRING and (radius_raw as String).begins_with("shape."):
				var r_lookup: Variant = _lookup_shape(style_personality, radius_raw)
				if r_lookup != null and (typeof(r_lookup) == TYPE_INT or typeof(r_lookup) == TYPE_FLOAT):
					resolved_radius = int(r_lookup)
			elif typeof(radius_raw) == TYPE_INT or typeof(radius_raw) == TYPE_FLOAT:
				resolved_radius = int(radius_raw)
		_set_radius_all(sb, resolved_radius)
		var corner_profile: String = str(recipe.get("corner_profile", ""))
		if corner_profile == "tab_connected":
			_set_tab_connected_radius(sb, resolved_radius)
		elif corner_profile == "top_only":
			_set_top_only_radius(sb, resolved_radius)
		elif corner_profile == "bottom_only":
			_set_bottom_only_radius(sb, resolved_radius)
```

The TARGET block (insert 6 lines BEFORE the `_set_radius_all` call):

```gdscript
		var radius_raw: Variant = recipe.get("radius", null)
		var resolved_radius: int = corner_radius
		if radius_raw != null:
			if typeof(radius_raw) == TYPE_STRING and (radius_raw as String).begins_with("shape."):
				var r_lookup: Variant = _lookup_shape(style_personality, radius_raw)
				if r_lookup != null and (typeof(r_lookup) == TYPE_INT or typeof(r_lookup) == TYPE_FLOAT):
					resolved_radius = int(r_lookup)
			elif typeof(radius_raw) == TYPE_INT or typeof(radius_raw) == TYPE_FLOAT:
				resolved_radius = int(radius_raw)
		# Phase 12 C6 Bubble: floor (not clamp) every resolved radius to >= min_radius_floor.
		# Pitfall 4: use maxi, NOT mini — Bubble's primary_radius=999 must remain 999.
		var min_floor_raw: Variant = _lookup_shape(style_personality, "shape.min_radius_floor")
		if min_floor_raw != null and (typeof(min_floor_raw) == TYPE_INT or typeof(min_floor_raw) == TYPE_FLOAT):
			var floor_v: int = int(min_floor_raw)
			if floor_v > 0:
				resolved_radius = maxi(resolved_radius, floor_v)
		_set_radius_all(sb, resolved_radius)
		var corner_profile: String = str(recipe.get("corner_profile", ""))
		# ... (rest unchanged)
```

CRITICAL invariants:
- `maxi`, NOT `mini`. Pitfall 4. Bubble's pill `primary_radius = 999` MUST stay 999 — `maxi(999, 26) = 999` ✓.
- The floor is applied BEFORE the corner_profile dispatch. The corner_profile helpers (`_set_tab_connected_radius`, `_set_top_only_radius`, `_set_bottom_only_radius`) receive `resolved_radius` and apply it per-corner; if the floor were applied after, the helpers would have already used the un-floored value.
- The `if floor_v > 0` disable sentinel skips the work entirely for the 4 non-Bubble directions and DEFAULT (where floor is 0).
- Use tab indentation matching the surrounding block (2 leading tabs inside `_resolve_recipe`'s stylebox branch).
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full && godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"</automated>
  </verify>
  <acceptance_criteria>
    - `grep -c '"min_radius_floor":' addons/neocade_theme/scripts/neocade_theme.gd` returns 6 (5 directions + DEFAULT).
    - `grep -c '"min_radius_floor":    26' addons/neocade_theme/scripts/neocade_theme.gd` returns 1 (only Bubble).
    - `grep -c '"min_radius_floor":    0' addons/neocade_theme/scripts/neocade_theme.gd` returns 5 (others + DEFAULT).
    - The string `_lookup_shape(style_personality, "shape.min_radius_floor")` appears exactly once.
    - The expression `maxi(resolved_radius, floor_v)` is present (Pitfall 4 — NOT `mini`).
    - `grep -c 'mini(resolved_radius' addons/neocade_theme/scripts/neocade_theme.gd` returns 0 (Pitfall 4 fail-safe — no `mini` near radius resolution).
    - BINDING_TABLE row count check via `--stage architecture` exits 0.
    - SC#1, SC#2, SC#3, SC#6 all still green via `--stage full`.
    - 30-config smoke matrix exits 0.
  </acceptance_criteria>
  <done>Bubble's pillow-everywhere signature is wired (≥26 radius floor with `maxi`); pill radii preserved at 999; smoke matrix green.</done>
</task>

<task type="auto">
  <name>Task 3: Daybreak C6 — primary_outline_* keys + flat outline recipe thread-through (SC#1/SC#3 critical)</name>
  <files>addons/neocade_theme/scripts/neocade_theme.gd</files>
  <read_first>
    - addons/neocade_theme/scripts/neocade_theme.gd lines 1026-1057 (Daybreak STYLE_PERSONALITY entry — note `primary_padding: Vector2i(15, 9)` at line 1030, to be bumped)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 5305-5346 (focus_ring stylebox — the existing precedent for `expand_margin_*` + `border_width_*`)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 5438-5450 (strategy dispatch — the post-strategy insertion point for the outline override)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 5165-5168 (`_apply_primary_strategy "friendly-generous"` — what currently sets Daybreak primary's `border_color = accent_rim`; the outline override must run AFTER this so it can override accent_rim with role_primary)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 4 "Daybreak C6 — flat outline at 3px offset via expand_margin_* + border_width_*"
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "Daybreak - 1px flat outline at 3px offset" and Pitfall 1 ("`raised=false` accidentally retains 3D leakage") and Pitfall 3 (GL Compatibility over-renders alpha — full alpha mandatory)
  </read_first>
  <action>
Four sub-edits in one task. All in `addons/neocade_theme/scripts/neocade_theme.gd`.

**Edit 1 — bump Daybreak's `primary_padding` from `Vector2i(15, 9)` to `Vector2i(20, 14)`:**

Find Daybreak's shape dict (lines 1028-1056). On line 1030 currently:

```gdscript
			"primary_padding":       Vector2i(15, 9),
```

Replace with:

```gdscript
			"primary_padding":       Vector2i(20, 14),   # Phase 12 C6 Daybreak: generous primary padding.
```

**Edit 2 — add 3 new shape keys to Daybreak's shape dict:**

Just before `"focus_offset": 2,` (around line 1054), add THREE new lines:

```gdscript
			"primary_outline_color": &"role_primary",   # Phase 12 C6 Daybreak: token name; resolved through role_table.
			"primary_outline_offset": 3,                 # Phase 12 C6 Daybreak: px outside button edge.
			"primary_outline_width":  1,                 # Phase 12 C6 Daybreak: 1px flat outline (NO halo per SC#3).
```

**Edit 3 — add no-op defaults for the 3 outline keys to all 4 OTHER directions + DEFAULT:**

Pitfall 5 mirror. Each of Pulse, Slate, Bubble, Burst, and STYLE_PERSONALITY_DEFAULT shape dicts needs these 3 lines added at the same relative position (just before `"focus_offset":`):

```gdscript
			"primary_outline_color": &"role_primary",
			"primary_outline_offset": 0,
			"primary_outline_width":  0,
```

The width=0 is the disable gate — the recipe-side code skips the mutation when `primary_outline_width <= 0`. The color name is a safe default (matches Daybreak's value); the offset is 0 (which would still produce a flush border if the width were non-zero, but width=0 short-circuits before that matters).

Total: 5 shape dict edits × 3 lines = 15 lines (4 non-target directions + DEFAULT), plus the 3 lines for Daybreak from Edit 2 = 18 new lines, plus the 1-line padding bump from Edit 1.

**Edit 4 — thread the outline through `_resolve_recipe()` AFTER strategy dispatch:**

Locate the strategy dispatch block at lines 5438-5447. After the dispatch completes (after the closing brace/end of the `if (strategy_raw as String).ends_with(".primary_strategy"): _apply_primary_strategy(...)` branch), insert the outline application. The outline must run AFTER `_apply_primary_strategy` because `friendly-generous` (Daybreak's strategy) at line 5168 sets `sb.border_color = role_table.get("accent_rim", role_table.outline_color)` — the outline override must replace that.

Locate the closing of the strategy dispatch (likely after the `_apply_primary_strategy` / `_apply_ghost_strategy` calls; verify by reading lines 5438-5460 first). Insert this block:

```gdscript
		# Phase 12 C6 Daybreak: 1px flat accent outline at 3px offset for primary buttons,
		# gated on raised=true (SC#1) and primary-strategy recipes only.
		# Pitfall 3: full alpha (no border_alpha < 1.0); GL Compat over-renders intermediate alpha.
		if raised and strategy_raw != null and typeof(strategy_raw) == TYPE_STRING and (strategy_raw as String).ends_with(".primary_strategy"):
			var outline_width_v: Variant = _lookup_shape(style_personality, "shape.primary_outline_width")
			var outline_width_resolved: int = 0
			if outline_width_v != null and (typeof(outline_width_v) == TYPE_INT or typeof(outline_width_v) == TYPE_FLOAT):
				outline_width_resolved = int(outline_width_v)
			if outline_width_resolved > 0:
				var outline_color_key_v: Variant = _lookup_shape(style_personality, "shape.primary_outline_color")
				var outline_color_key: String = "role_primary"
				if outline_color_key_v != null:
					outline_color_key = String(outline_color_key_v)
				var outline_color_c: Color = role_table.get(outline_color_key, role_table.role_primary)
				# Override the strategy-applied border with the outline (full alpha — Pitfall 3).
				sb.border_color = outline_color_c
				sb.border_width_left = outline_width_resolved
				sb.border_width_top = outline_width_resolved
				sb.border_width_right = outline_width_resolved
				sb.border_width_bottom = outline_width_resolved
				# Push the border outside the control rect via expand_margin (3px offset).
				var outline_offset_v: Variant = _lookup_shape(style_personality, "shape.primary_outline_offset")
				var outline_offset_resolved: int = 0
				if outline_offset_v != null and (typeof(outline_offset_v) == TYPE_INT or typeof(outline_offset_v) == TYPE_FLOAT):
					outline_offset_resolved = int(outline_offset_v)
				sb.expand_margin_left = outline_offset_resolved
				sb.expand_margin_top = outline_offset_resolved
				sb.expand_margin_right = outline_offset_resolved
				sb.expand_margin_bottom = outline_offset_resolved
```

CRITICAL invariants:
- `if raised and ...` is the SC#1 gate. When `raised=false`, the entire block is skipped → no outline, no expand_margin, no border_width change. Daybreak's flat-mode chrome is identical to other directions' flat-mode chrome.
- The strategy-key check `(strategy_raw as String).ends_with(".primary_strategy")` scopes the outline to PRIMARY buttons only. Secondary, ghost, tab, list, panel chrome are NEVER touched.
- The `if outline_width_resolved > 0` disable sentinel skips ALL non-Daybreak directions (where the value is 0).
- DO NOT set `border_alpha`. The default is 1.0 per recipe → the outline is full-alpha → no halo (SC#3 / Pitfall 3).
- Use tab indentation matching the surrounding block (2 leading tabs inside `_resolve_recipe`'s stylebox branch).
- Insert this block AFTER the strategy dispatch closes; it must NOT be inside the `if (strategy_raw as String).ends_with(".primary_strategy"):` branch of the strategy dispatch itself (which would couple the outline to having a strategy match — instead the outline is its own gated block that ALSO checks the strategy ends-with).

Read lines 5438-5470 BEFORE editing to confirm exactly where the strategy dispatch closes; the closing point varies by indentation depth. The outline block goes immediately after the strategy-dispatch's containing `if strategy_raw != null and ...` closes.
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full && godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"</automated>
  </verify>
  <acceptance_criteria>
    - `grep -c '"primary_outline_color":' addons/neocade_theme/scripts/neocade_theme.gd` returns 6 (5 directions + DEFAULT).
    - `grep -c '"primary_outline_width":  1' addons/neocade_theme/scripts/neocade_theme.gd` returns 1 (only Daybreak).
    - `grep -c '"primary_outline_width":  0' addons/neocade_theme/scripts/neocade_theme.gd` returns 5 (others + DEFAULT).
    - `grep -c '"primary_outline_offset": 3' addons/neocade_theme/scripts/neocade_theme.gd` returns 1 (only Daybreak).
    - The expression `Vector2i(20, 14)` appears in the Daybreak shape dict (verify by reading lines 1028-1056).
    - The expression `Vector2i(15, 9)` no longer appears in the Daybreak shape dict (the old `primary_padding` value is fully replaced).
    - The phrase `if raised and strategy_raw != null` appears within the outline thread-through block (SC#1 gate).
    - The phrase `_lookup_shape(style_personality, "shape.primary_outline_width")` appears exactly once.
    - The string `sb.expand_margin_left = outline_offset_resolved` is present (and its 3 sibling lines for top/right/bottom).
    - The string `border_alpha` is NOT introduced anywhere in the new outline block (no intermediate alpha — SC#3).
    - SC#1: `--stage sc1-no-3d-when-flat` exits 0 (the outline is `raised`-gated, so `raised=false` shows no outline expansion).
    - SC#3: `--stage sc3-no-glow-halo` exits 0 (border alpha stays 1.0).
    - SC#6: `grep -c '^@export ' addons/neocade_theme/scripts/neocade_theme.gd` returns 12 (no new @export var).
    - 30-config smoke matrix exits 0.
  </acceptance_criteria>
  <done>Daybreak's 1px flat outline at 3px offset is wired; gated on `raised=true` (SC#1); full alpha (SC#3); primary-only (no leakage to secondary/ghost/tabs); smoke matrix green.</done>
</task>

<task type="auto">
  <name>Task 4: Burst C6 — primary_min_height shape key + content_margin floor thread-through</name>
  <files>addons/neocade_theme/scripts/neocade_theme.gd</files>
  <read_first>
    - addons/neocade_theme/scripts/neocade_theme.gd lines 1062-1093 (Burst STYLE_PERSONALITY entry)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 5398-5423 (padding application block in _resolve_recipe — the min-height floor runs AFTER padding closes)
    - addons/neocade_theme/scripts/neocade_theme.gd lines 5438-5450 (strategy dispatch — used to detect "primary" recipes via `strategy_raw ends_with .primary_strategy`)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 7 "Burst C6 — primary_min_height thread-through" (full pattern; note the even-split top/bottom symmetric padding idiom)
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "Burst - Oversized primary CTAs" (note: mobile is handled via `tokens.primaryButtonMin` which is already 56 mobile; Burst's desktop bump to 56 puts it on par with mobile baseline)
  </read_first>
  <action>
Three sub-edits in one task. All in `addons/neocade_theme/scripts/neocade_theme.gd`.

**Edit 1 — add `primary_min_height: 56` to Burst's STYLE_PERSONALITY.shape:**

Find Burst's shape dict (lines 1064-1092). Just before `"focus_offset": 1,` (around line 1090), add:

```gdscript
			"primary_min_height":  56,   # Phase 12 C6 Burst signature: oversized primary CTAs (56 desktop / 64 mobile via density).
```

**Edit 2 — add no-op `primary_min_height: 0` to ALL 4 OTHER directions + DEFAULT:**

Pitfall 5 mirror. Add one line to Pulse, Slate, Bubble, Daybreak, STYLE_PERSONALITY_DEFAULT shape dicts:

```gdscript
			"primary_min_height":  0,
```

Total: 6 dict edits (1 with value 56, 5 with value 0).

**Edit 3 — thread `primary_min_height` through `_resolve_recipe()` AFTER padding application:**

Locate line 5423 (`if not applied_padding: _set_content_margin_from_padding(sb, Vector2i.ZERO)`). Insert the min-height floor immediately AFTER that line (and BEFORE the `expand_margins_raw` handling at line 5424).

Insert this block:

```gdscript
		# Phase 12 C6 Burst: floor primary-button content_margin sum to shape.primary_min_height
        # when set; gated on strategy ending in .primary_strategy so only primary buttons grow.
        # Mobile path uses the density-scaled tokens.body for content height proxy (RESEARCH § Burst specifics).
		if strategy_raw != null and typeof(strategy_raw) == TYPE_STRING and (strategy_raw as String).ends_with(".primary_strategy"):
			var min_h_raw: Variant = _lookup_shape(style_personality, "shape.primary_min_height")
			var min_h_resolved: int = 0
			if min_h_raw != null and (typeof(min_h_raw) == TYPE_INT or typeof(min_h_raw) == TYPE_FLOAT):
				min_h_resolved = int(min_h_raw)
			if min_h_resolved > 0:
				var content_h: int = int(tokens.get("body", 14))
				var current_min: int = sb.content_margin_top + content_h + sb.content_margin_bottom
				if current_min < min_h_resolved:
					var extra: int = min_h_resolved - current_min
					var half_extra: int = extra / 2
					sb.content_margin_top += half_extra
					sb.content_margin_bottom += (extra - half_extra)
```

CRITICAL invariants:
- The strategy-key check `(strategy_raw as String).ends_with(".primary_strategy")` is the same gate Daybreak's outline uses. It scopes the min-height floor to PRIMARY buttons only — secondary/ghost/tab/chip/list chrome NEVER grows.
- The `if min_h_resolved > 0` disable sentinel skips all 4 non-Burst directions (where the value is 0).
- Mobile path: `tokens.body` is already platform-resolved (16 mobile / desktop value from per-direction tokens). The `content_h` proxy uses it directly, so `current_min` already reflects the mobile content-height baseline. When Burst is on MOBILE and `primary_min_height: 56`, the mobile path's `tokens.primaryButtonMin` is also 56 — the floor lifts the desktop case to match the mobile baseline, and the mobile case naturally hits 64 via density-scaled padding plus the floor (per RESEARCH § Burst specifics: "Burst's desktop primary becomes 56px (vs. other directions' 44px) — a 1.27x scale factor"). This is intentional and matches the spike's "1.4x size of other directions" target.
- Even-split (`half_extra` + `extra - half_extra`) handles odd integer division without losing a pixel. Mirrors the focus_offset symmetric-application idiom at lines 5341-5344.
- Use tab indentation matching the surrounding block (2 leading tabs inside `_resolve_recipe`'s stylebox branch).
- Place this block AFTER the padding closes (line 5423) and BEFORE the expand_margins handler (line 5424). Order matters: padding must be applied first so `content_margin_top/bottom` reflect the recipe's intended baseline before the floor adjusts them.
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full && godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"</automated>
  </verify>
  <acceptance_criteria>
    - `grep -c '"primary_min_height":' addons/neocade_theme/scripts/neocade_theme.gd` returns 6 (5 directions + DEFAULT).
    - `grep -c '"primary_min_height":  56' addons/neocade_theme/scripts/neocade_theme.gd` returns 1 (only Burst).
    - `grep -c '"primary_min_height":  0' addons/neocade_theme/scripts/neocade_theme.gd` returns 5 (others + DEFAULT).
    - The string `_lookup_shape(style_personality, "shape.primary_min_height")` appears exactly once.
    - The expression `sb.content_margin_top += half_extra` is present.
    - The expression `sb.content_margin_bottom += (extra - half_extra)` is present (even-split idiom).
    - SC#1, SC#2, SC#3, SC#6 all green via `--stage full`.
    - 30-config smoke matrix exits 0.
  </acceptance_criteria>
  <done>Burst's oversized primary CTA signature is wired; primary-only (no growth on secondary/ghost/chips/tabs); mobile path inherits the floor; smoke matrix green.</done>
</task>

<task type="auto">
  <name>Task 5: Pulse C6 — add ONE Kicker Label above the Buttons section in showcase.tscn</name>
  <files>showcase/showcase.tscn</files>
  <read_first>
    - showcase/showcase.tscn lines 100-160 (locate the Buttons ScrollContainer at line 108, the existing Grid/PrimaryPanel/PrimaryStack structure starting around line 128, and the FIRST Kicker label at lines 136-139 — the canonical analog)
    - .planning/phases/12-signature-visual-moves/12-PATTERNS.md § 8 "Pulse C6 — showcase Kicker addition (no code changes)" — read carefully for the unique_id convention and the `theme_type_variation = &"Kicker"` requirement
    - .planning/phases/12-signature-visual-moves/12-RESEARCH.md § "Pulse - SectionKicker (or reuse Kicker)" — locked decision is to REUSE existing Kicker, NOT register a new SectionKicker variation
  </read_first>
  <action>
This is a `.tscn` scene edit, NOT a code edit. Open `showcase/showcase.tscn` and add ONE new Label node above the existing Buttons section content (which begins around line 108 with the `[node name="Buttons" ...]` ScrollContainer).

The strategy: insert the new Kicker as a child of the Grid that is itself a child of the Buttons ScrollContainer. Reading lines 108-140 reveals the path:
- `RootMargin/RootStack/ShowcaseTabs/Buttons` (ScrollContainer, line 108)
- Inside Buttons there is a `Margin` MarginContainer
- Inside Margin there is a `Grid` HBoxContainer (or VBoxContainer or GridContainer — read the file to confirm exact type and parent path)
- Inside Grid there are panel children (PrimaryPanel, SecondaryPanel, etc.)

The Pulse C6 Kicker must visibly read as the section title for the entire Buttons tab. The cleanest insertion is as a VBox child wrapping the existing Grid, OR — if Buttons already has a Margin/VBox structure — as the FIRST child of that container so the Kicker sits above the panel grid.

**Concrete edit (the executor verifies the exact parent path by reading the file first):**

Step 1 — Read `showcase/showcase.tscn` lines 100-160. Identify:
  - The exact parent path of the existing PrimaryPanel/PrimaryStack content (likely `RootMargin/RootStack/ShowcaseTabs/Buttons/Margin/Grid` per the PATTERNS § 8 excerpt).
  - The `unique_id=` value range in use (existing IDs are in the billions; pick one above 2_700_000_000 to avoid collision).
  - The exact `[ext_resource ... id="1_xxxxx"]` line for the showcase's main theme resource (we will reference it).

Step 2 — Insert a new Label node block. Place the block INSIDE the Buttons subtree but AS THE FIRST CHILD of the inner container that currently holds PrimaryPanel + SecondaryPanel + GhostPanel etc. The exact insertion point is just BEFORE the first existing child of that container.

Use this EXACT node block (substitute the correct parent path verified in Step 1):

```
[node name="ButtonsSectionKicker" type="Label" parent="RootMargin/RootStack/ShowcaseTabs/Buttons/Margin/Grid" unique_id=2700000001]
layout_mode = 2
size_flags_horizontal = 3
theme_type_variation = &"Kicker"
text = "BUTTONS · IDENTITY"
```

CRITICAL details:
- `theme_type_variation = &"Kicker"` is MANDATORY — this is what dispatches the Label to the Kicker variation's `font_color` recipe (BINDING_TABLE row at lines 4909-4913), which for Pulse resolves to `role_primary` (accent green per `_apply_kicker_style("uppercase-tracked-accent")` at line ~5251).
- `text = "BUTTONS · IDENTITY"` is uppercase by content — per RESEARCH § "Pulse - SectionKicker", letter-spacing is NOT theme-enforceable in Godot 4.6 (no letter-spacing slot), so uppercase content is the closest approximation to "tracked-uppercase".
- The `parent="..."` value MUST exactly match the existing parent path in the scene file. Reading the file first is non-negotiable — if Grid is at a different path (e.g., `RootMargin/RootStack/ShowcaseTabs/Buttons/VBox` instead of `.../Margin/Grid`), use the actual path.
- `unique_id=` must NOT collide with any existing node. Verify with `grep -c 'unique_id=2700000001' showcase/showcase.tscn` returning 0 BEFORE adding.
- If the parent container is a Grid that arranges children in columns (e.g., 2-column GridContainer), the new Label will become the first cell of the grid — that's fine; the Kicker visually reads as the section's intro text spanning the grid.
- If the parent path is something other than a Grid that accepts a Label cleanly (e.g., HBoxContainer where the Label would distort the layout), wrap the existing children in a VBoxContainer first OR insert the Label OUTSIDE the Grid but inside its parent Margin/Container. The executor uses judgment here — the visual goal is: a single accent-colored uppercase Kicker label sits ABOVE the buttons grid on the Buttons tab.

Step 3 — `.tscn` node ordering matters. Godot iterates child nodes in declaration order, so the Kicker MUST be the first `[node ...]` block whose parent is the target container. Insert it BEFORE the existing PrimaryPanel block.

Step 4 — Save the scene. Godot will rewrite uid hashes and the load_steps count when the editor next opens the scene; this is expected and not a regression.
  </action>
  <verify>
    <automated>grep -c 'name="ButtonsSectionKicker"' showcase/showcase.tscn</automated>
  </verify>
  <acceptance_criteria>
    - `showcase/showcase.tscn` contains exactly one node named `ButtonsSectionKicker` (verifiable via `grep -c 'name="ButtonsSectionKicker"' showcase/showcase.tscn` returning 1).
    - That node has `theme_type_variation = &"Kicker"`.
    - That node's `text = "BUTTONS · IDENTITY"` (or equivalent uppercase content — at minimum it must contain "BUTTONS" in all-caps).
    - The node is a child of a container inside the `Buttons` ScrollContainer subtree (verifiable: the `parent="..."` path begins with `RootMargin/RootStack/ShowcaseTabs/Buttons/`).
    - No other showcase nodes were modified; only the one Kicker added. Verify with `git diff --stat showcase/showcase.tscn` showing additions only (no deletions of existing node blocks).
    - `--stage architecture` exits 0 (the scene change does not affect theme regeneration).
    - The scene loads in Godot without errors (run `godot --headless --quit --script <smoke matrix>` — if the scene is malformed, future thumbnail rendering will fail).
  </acceptance_criteria>
  <done>One new Kicker Label exists at the top of the Buttons section in `showcase/showcase.tscn`; via the existing Kicker → role_primary → accent_color chain, Pulse's C6 signature is visible on the most-frequented showcase tab without any production code change.</done>
</task>

<task type="checkpoint:human-verify" gate="blocking">
  <name>Task 6: SC#4 greyscale-thumbnail user attestation gate</name>
  <files>.planning/phases/12-signature-visual-moves/artifacts/thumbnails/</files>
  <what-built>
After the 5 production tasks (Slate hairlines, Bubble floor, Daybreak outline, Burst oversized, Pulse showcase Kicker), the user must attest to the SC#4 greyscale-identifiability gate per D-12.27.

The thumbnail render helper from Plan 01 (`_phase12_thumbnail_render.gd`) is run via Godot Editor → File → Run. It produces 5 PNG files at `.planning/phases/12-signature-visual-moves/artifacts/thumbnails/`, one per selectable style at `raised=true`, each 256×144 desaturated to greyscale.

The user opens the 5 PNGs (unlabeled, in random order) and names each by direction. The gate passes when all 5 are correctly identified.
  </what-built>
  <how-to-verify>
1. Open the Godot Editor (the project at `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme`).
2. In the Godot file browser, navigate to `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd`.
3. Right-click the file → "Run" (or open it and use File → Run on the script).
4. Wait ~20-30 seconds for the script to render 5 thumbnails. The Output panel will print `PHASE12_THUMBNAIL: wrote <path>` per style.
5. Open File Explorer / Finder, navigate to `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme\.planning\phases\12-signature-visual-moves\artifacts\thumbnails\`.
6. Open the 5 PNGs in an image viewer. Verify each is roughly greyscale (no color). If they are still in color, the saturation value assumption (A1) failed — open `_phase12_thumbnail_render.gd`, change the constant `SATURATION_VALUE := 0.0` to `SATURATION_VALUE := -1.0`, save, and re-run.
7. WITHOUT looking at the filenames, attempt to identify each direction:
   - **Pulse** should show: rectangular chrome (radius 0), a visible accent-colored uppercase Kicker label ("BUTTONS · IDENTITY") above the Buttons grid, sharp edges.
   - **Slate** should show: thin 1px hairline borders on interactive surfaces — very crisp, very quiet.
   - **Bubble** should show: aggressively rounded corners (≥26 everywhere) — pillowy silhouette across the entire tab.
   - **Daybreak** should show: primary buttons with a visible 1px outline at 3px offset (a small "gap" between the button face and a thin ring); generous padding makes primaries look larger.
   - **Burst** should show: oversized primary buttons (56px tall) noticeably taller than other directions' primaries.
8. The pass gate: all 5 identified correctly. Any mismatch → strengthen the corresponding C6 move (e.g., increase Slate's hairline contrast by ensuring border_color is `outline_color` not `surface_panel`, or bump Burst's `primary_min_height` to 60) and re-render.
  </how-to-verify>
  <action>
Run `_phase12_thumbnail_render.gd` from inside the Godot Editor (File -> Run on the script in the FileSystem dock). Wait for the 5 PNG files to be written to `.planning/phases/12-signature-visual-moves/artifacts/thumbnails/`. Then present the 5 PNGs to the user in random order (without filenames visible) and ask them to identify each direction by name. If the PNGs are still in color, flip `SATURATION_VALUE` in `_phase12_thumbnail_render.gd` from `0.0` to `-1.0` and re-run.
  </action>
  <verify>User-attested correct identification of all 5 unlabeled greyscale thumbnails by direction name (Pulse / Slate / Bubble / Daybreak / Burst).</verify>
  <done>All 5 thumbnails saved to artifacts directory; user has typed "approved" or returned with a specific strengthening directive.</done>
  <resume-signal>Type "approved" if all 5 directions are greyscale-identifiable, OR describe which direction(s) were ambiguous and propose the strengthening change.</resume-signal>
</task>

<task type="auto">
  <name>Task 7: Final regression sweep after Wave 3</name>
  <files>(no file edits)</files>
  <read_first>
    - .planning/phases/12-signature-visual-moves/12-VALIDATION.md § Validation Sign-Off (full checklist)
  </read_first>
  <action>
Run the complete Phase 12 verification suite one final time. This is the gate before the phase is declared complete.

Commands (run sequentially; abort on first failure):

```bash
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage architecture
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc1-no-3d-when-flat
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc2-tabs-flat-when-raised
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc3-no-glow-halo
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage sc6-export-count
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"
```

Additionally — SC#5 manual diff check:

```bash
git diff feat/signature-visual-moves~..HEAD -- addons/neocade_theme/scripts/neocade_theme.gd | grep -E '^\+.*Color\(' | grep -v '^\+\s*#'
```

This command lists every NEW `Color(...)` literal introduced across all Phase 12 commits, excluding comment lines. The expected output is EMPTY — Phase 12 must not introduce any new hue (SC#5 / D-12.28). If non-empty, the executor inspects each match and either:
- Confirms the match is part of a `STYLE_PERSONALITY_DEFAULT` Pitfall 5 default (e.g., `primary_outline_color: &"role_primary"` is a StringName, NOT a Color literal — should not match anyway).
- Or refactors the code to use a token name instead of a raw Color.

All 7 verifier runs MUST exit 0. The SC#5 diff check MUST produce empty output. If both gates pass, Phase 12 is complete.
  </action>
  <verify>
    <automated>godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full && godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"</automated>
  </verify>
  <acceptance_criteria>
    - All 7 `godot --headless` verifier commands exit 0.
    - The SC#5 diff check (new `Color(...)` literals across Phase 12 commits, excluding comments) produces ZERO matches.
    - `grep -c '^@export ' addons/neocade_theme/scripts/neocade_theme.gd` returns exactly 12 (SC#6).
    - BINDING_TABLE row count via `--stage architecture` is 37.
    - The 5 thumbnail PNGs from Task 6 exist at `.planning/phases/12-signature-visual-moves/artifacts/thumbnails/` and were user-attested in Task 6 (resume signal = "approved").
  </acceptance_criteria>
  <done>Phase 12 verification is fully green; SC#1..SC#6 are all satisfied; the 30-config smoke matrix is regression-free; the user has attested to SC#4 greyscale identifiability.</done>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| STYLE_PERSONALITY data → `_resolve_recipe()` recipe resolution | Internal project-controlled constants. |
| `shape.<key>` lookups → `_lookup_shape()` | Returns `null` for missing paths; every consumer must check `null` AND a disable-sentinel. |
| Consumer scene → showcase Kicker render | Consumer (the showcase scene) supplies the text content for the new Kicker; theme dispatches font_color through Kicker variation. |

## STRIDE Threat Register

| Threat ID | Category | Component | Disposition | Mitigation Plan |
|-----------|----------|-----------|-------------|-----------------|
| T-12.04-01 | Tampering | New STYLE_PERSONALITY shape keys | mitigate | Every new key has a no-op default in STYLE_PERSONALITY_DEFAULT and a disable-sentinel in the recipe-side code (`if width > 0`, `if floor_v > 0`, etc.). A consumer who overrides STYLE_PERSONALITY (via Style.CUSTOM) cannot break regenerate. |
| T-12.04-02 | Tampering | Daybreak outline at raised=false | mitigate | The outline block is gated `if raised and ...`. SC#1 verifier (`--stage sc1-no-3d-when-flat`) asserts the gate holds. Pitfall 1 in RESEARCH explicitly warns about this leakage. |
| T-12.04-03 | Information disclosure | Daybreak outline color | accept | The outline uses `role_primary` (accent) — already public. |
| T-12.04-04 | Denial of service | Burst content_margin floor | mitigate | The min-height floor only LIFTS content_margin (never reduces); the recipe's baseline padding is preserved. Worst case: a recipe specifies 100px of padding for a primary slot and Burst tries to floor to 56; `current_min` exceeds `min_h_resolved` so the `if current_min < min_h_resolved` short-circuits. No infinite loop, no negative margins. |
| T-12.04-05 | Repudiation | SC#4 greyscale identifiability | mitigate | Manual checkpoint with user attestation; the 5 thumbnail PNGs are archived under `.planning/phases/12-signature-visual-moves/artifacts/thumbnails/` for audit. |
| T-12.04-06 | Elevation of privilege | None applicable | accept | All edits are within the existing addon namespace; no new permissions or capabilities. |
</threat_model>

<verification>
After all 7 tasks complete:

```bash
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" -- --stage full
godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd"
git diff feat/signature-visual-moves~..HEAD -- addons/neocade_theme/scripts/neocade_theme.gd | grep -E '^\+.*Color\(' | grep -v '^\+\s*#'
```

- The first command exits 0 with `PHASE12_VERIFY: PASS` for every sub-stage.
- The second command exits 0 with `PHASE12_SMOKE: PASS — 30 configs regenerated cleanly`.
- The third command produces NO OUTPUT (SC#5 hue invariant — no new `Color(...)` literals across the Phase 12 commit range).

Plus the SC#4 user attestation gate (Task 6) is closed with "approved".
</verification>

<success_criteria>
- Slate's `shape.hairline_thickness: 1` is wired and produces 1px borders on chrome with `border_role`.
- Bubble's `shape.min_radius_floor: 26` is wired and floors radii with `maxi`, preserving pill 999s.
- Daybreak's `shape.primary_outline_*` triplet is wired; outline renders flat 1px at 3px offset, gated on `raised=true` only, on primary buttons only.
- Daybreak's `primary_padding` bumped to `Vector2i(20, 14)`.
- Burst's `shape.primary_min_height: 56` is wired; primary buttons floor to 56px tall on desktop; mobile path inherits via density tokens.
- Pulse's C6 signature is visible via a new Kicker label in `showcase/showcase.tscn` ("BUTTONS · IDENTITY") above the Buttons section.
- STYLE_PERSONALITY_DEFAULT and all 4 non-target directions carry every new shape key with no-op default values (Pitfall 5 mirror).
- 5 greyscale thumbnails saved to `.planning/phases/12-signature-visual-moves/artifacts/thumbnails/`; user attests all 5 are direction-identifiable.
- All 6 success criteria verified green (SC#1..SC#6 per D-12.24..D-12.29).
- BINDING_TABLE row count = 37; 12-export contract preserved.
- 30-config smoke matrix exits 0.
</success_criteria>

<output>
After completion, create `.planning/phases/12-signature-visual-moves/12-04-SUMMARY.md` documenting:
- Each of the 5 per-direction signatures with before/after STYLE_PERSONALITY shape diffs.
- The 4 recipe-side thread-through blocks added to `_resolve_recipe()` (Slate hairline, Bubble floor, Daybreak outline, Burst min-height), with the exact line numbers where each was inserted.
- The showcase.tscn Kicker addition (the `[node name="ButtonsSectionKicker" ...]` block, with its final parent path and unique_id).
- The 5 thumbnail filenames produced and their user attestation result.
- Output of the final verifier suite (paste `PHASE12_VERIFY: PASS` per stage + `PHASE12_SMOKE: PASS`).
- Confirmation that the SC#5 diff check returned empty (no new `Color(...)` literals).
- Confirmation that `grep -c '^@export ' addons/neocade_theme/scripts/neocade_theme.gd` returns 12.
- Any A1 saturation-value decision (`0.0` vs `-1.0`) discovered during Task 6 thumbnail render.
- A "Phase 12 status: COMPLETE" header line so `/gsd-verify-work` and `/gsd-complete-phase` can detect closure.
</output>
