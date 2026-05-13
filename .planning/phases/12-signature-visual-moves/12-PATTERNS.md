# Phase 12: Signature Visual Moves — Pattern Map

**Mapped:** 2026-05-10
**Files analyzed:** 1 production file (`neocade_theme.gd`), 1 showcase scene, 4 new verify helpers.
**Analogs found:** 10 / 10 (every Phase 12 surface has an existing in-codebase analog).

Phase 12 is unusual: almost every production edit lands in ONE file (`addons/neocade_theme/scripts/neocade_theme.gd`, 5765 lines). Each edit is a *surgical* extension of an existing pattern — replace one function body (C4), add keys to an existing per-direction dict (C6), change `role`/`border_role` strings on existing dict rows (C2'). The analogs below show the exact idiom the planner should mirror.

---

## File Classification

| Target file | Operation | Role | Data flow | Closest analog | Match quality |
|---|---|---|---|---|---|
| `addons/neocade_theme/scripts/neocade_theme.gd` (lines 800–806) | modify — replace function body | color helper | transform | self (the function it is replacing) | exact |
| `addons/neocade_theme/scripts/neocade_theme.gd` (lines 913–1094 — `STYLE_PERSONALITY`) | modify — add keys per direction | data table | lookup | self (existing per-direction shape dicts) | exact |
| `addons/neocade_theme/scripts/neocade_theme.gd` (lines 1158–1189 — `STYLE_PERSONALITY_DEFAULT`) | modify — add no-op default keys | data table | lookup | self (existing default shape dict) | exact |
| `addons/neocade_theme/scripts/neocade_theme.gd` (lines 2932–2952, 3008–3050, 3435–3491, 3493–3549, 4017–4075, 4909–4913 — selected `BINDING_TABLE` rows) | modify — change `role`/`border_role` strings | data table | recipe | adjacent rows in BINDING_TABLE that already use `role_primary` (e.g., `LineEdit.caret_color` at 3117, `Tree.drop_position_color` at 4062) | exact |
| `addons/neocade_theme/scripts/neocade_theme.gd` (lines 5276+ — `_resolve_recipe` stylebox branch) | modify — thread new shape keys | recipe resolver | dispatch | self (existing `radius`/`padding`/`raised_intensity` shape-lookup branches at 5359–5421) | exact |
| `showcase/showcase.tscn` (around line 121, inside `Buttons/Margin/Grid`) | modify — add ONE `Kicker` Label node | scene data | n/a | existing PrimaryStack.Label at lines 136–139 (`Kicker` variation above PrimaryButton) | exact |
| `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd` | create | verify helper (in-editor) | runtime check | `.planning/phases/04-…/helpers/_phase4_verify.gd` | role+flow match |
| `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` | create | verify helper (CLI) | runtime check | `.planning/phases/05-…/helpers/_phase5_verify_headless.gd` (for `--stage` parsing) + `_phase4_verify_headless.gd` (for asserts shape) | role+flow match |
| `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd` | create | render helper | file I/O + introspection | none in repo — new pattern (SceneTree + viewport capture + `Image.adjust_bcs` + PNG save) | partial (no prior thumbnail render helper exists) |
| `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd` | create | matrix runner | iteration | `_phase4_verify_headless.gd` peers-loop (lines 133–156: iterates configs, asserts per-config invariants) | role+flow match |

---

## Pattern Assignments

### 1. `_raised_depth_color` body rewrite (C4)

**Target:** `addons/neocade_theme/scripts/neocade_theme.gd`, lines 800–806.
**Operation:** modify (replace function body in place; signature is preserved).

**Closest analog — adjacent color helpers in the same color-helper block (lines 767–833).** These show the codebase's color-helper idiom: short pure functions that mutate a `Color`, preserve alpha as the last step, no setters, no `print`, no allocator churn beyond a `Color()` constructor.

**Excerpt (file: `addons/neocade_theme/scripts/neocade_theme.gd`):**

```gdscript
# Lines 767–778 — _mix and _tint_toward_base; the canonical "short color helper" shape.
func _mix(a: Color, b: Color, amount: float) -> Color:
    return Color(
        a.r + (b.r - a.r) * amount,
        a.g + (b.g - a.g) * amount,
        a.b + (b.b - a.b) * amount,
        1.0
    )

func _tint_toward_base(element: Color, base_c: Color, ratio: float = 0.40) -> Color:
    return _mix(element, base_c, ratio)


# Lines 781–791 — _button_tonal_color demonstrates the HSV-axis mutation idiom that C4 mirrors
# (var result := Color(source); mutate v/s in place; restore alpha; return).
func _button_tonal_color(source: Color, brightness_offset: float, saturation_multiplier: float) -> Color:
    var result := Color(source)
    var amount := clampf(0.35 * absf(brightness_offset), 0.0, 1.0)
    var dark_theme := not is_light
    if dark_theme == (brightness_offset > 0.0):
        result.v = lerpf(result.v, 1.0, amount)
    else:
        result.v = lerpf(result.v, 0.0, amount)
    result.s = clampf(result.s * saturation_multiplier, 0.0, 1.0)
    result.a = source.a
    return result


# Lines 800–806 — current _raised_depth_color (TO BE REPLACED in Wave 1).
func _raised_depth_color(element: Color, base_c: Color) -> Color:
    var base_pull := 0.16 if not is_light else 0.10
    var depth_amount := 0.10 if not is_light else 0.12
    var result := _mix(element, base_c, base_pull)
    result = _mix(result, Color.BLACK, depth_amount)
    result.a = element.a
    return result
```

**Notes for planner:**
- The replacement body is verbatim from CONTEXT.md D-12.02 — do not paraphrase, do not re-derive. The strength curve `0.20 + 0.10 * float(raised_strength)` and the `max(v, 0.04)` floor are both load-bearing per spike 002b iteration 5.
- `Color.from_hsv(h, s, v)` is the Godot 4.6 stdlib (verified Context7); `element.h`, `element.s`, `element.v` are read-only properties on Color. `Color.from_hsv` is preferred over manual HSL math — see RESEARCH `Don't Hand-Roll` table.
- **Do not change the signature.** `base_c` stays a parameter (callsites at lines 343–345, 394–405 keep working). The body just stops using it — that is intentional per D-12.01 (depth decouples from surface).
- Mirror the alpha-restore pattern from `_button_tonal_color` line 790: `result.a = element.a` before `return result`.
- **No `@export` additions.** Strength is read from the existing `raised_strength: int` export (line 109).
- **Hard gate from spike 002b:** the function is only called from the `if raised:` code path. Verify by grep that every callsite is inside a `raised`-gated block before merging — this is the SC#1 invariant.

---

### 2. `STYLE_PERSONALITY` per-direction shape key extension (C6)

**Target:** `addons/neocade_theme/scripts/neocade_theme.gd`, lines 913–1094 (each `Style.<X>` row) and lines 1158–1189 (`STYLE_PERSONALITY_DEFAULT`).
**Operation:** modify — add keys per direction; mirror absent keys in DEFAULT with no-op values.

**Closest analog — the existing per-direction shape dicts themselves.** The dict shape was established by Phase 5 Plan 05-02; Phase 6/7 extended it. Phase 12 follows the same idiom: each direction has a `shape: Dictionary` sub-dict; keys are accessed via dotted-path strings (`"shape.kicker_style"`, `"shape.primary_padding"`) through `_lookup_shape()` at line 5014.

**Excerpt — Slate (the C6 hairline target) at lines 950–985:**

```gdscript
Style.SLATE: {
    "spread_factor": 0.7, "hover_pct": 4.0, "pressed_pct": -6.0,  "disabled_opacity": 0.50,
    "shape": {
        "primary_radius":        14,
        "primary_padding":       Vector2i(14, 9),
        "primary_strategy":      &"quiet-pill",
        "ghost_strategy":        &"thin-accent-outline",
        "regular_radius":      14,
        "tab_radius":            999,
        "chip_radius":           999,
        "card_radius":           14,
        "hero_radius":           14,
        "surface_alpha_panels":  1.00,
        "surface_alpha_popup":   0.92,
        "surface_alpha_buttons": 1.00,
        "raised_lifts": {
            "primary":         2,
            "regular":       1,
            "ghost":           1,
            "selected_tab":    1,
            "unselected_tab":  1,
            "panel":           2,
            "dialog":          2,
            "list":            2,
            "mark":            2,
            "selected_row":    1,
            "chip":            2,
        },
        "focus_offset":  2,
        "kicker_style":  &"small-caps-subtle",
    },
},
```

**Excerpt — `STYLE_PERSONALITY_DEFAULT` at lines 1158–1189 (the SC#5 / Pitfall-5 mirror target):**

```gdscript
const STYLE_PERSONALITY_DEFAULT: Dictionary = {
    "spread_factor": 1.0, "hover_pct": 8.0, "pressed_pct": -12.0, "disabled_opacity": 0.38,
    "shape": {
        "primary_radius":        8,
        "primary_padding":       Vector2i(16, 11),
        "primary_strategy":      &"friendly-generous",
        "ghost_strategy":        &"soft-outline",
        "regular_radius":      8,
        "tab_radius":            8,
        "chip_radius":           8,
        "card_radius":           8,
        "hero_radius":           8,
        "surface_alpha_panels":  1.00,
        "surface_alpha_popup":   1.00,
        "surface_alpha_buttons": 1.00,
        "raised_lifts": { …elided… },
        "focus_offset":  2,
        "kicker_style":  &"sentence-case-accent",
    },
}
```

**Notes for planner:**
- **Shape keys are `String` literal-keyed Dictionary entries** (no `&StringName` for the dict keys themselves; only value enums like `primary_strategy: &"quiet-pill"` use `StringName`). When adding new keys, use plain `String` for the key: `"hairline_thickness": 1`, not `&"hairline_thickness": 1`.
- **Value types matter.** Match the surrounding types exactly:
  - `int` for thicknesses/offsets/widths/heights (e.g., `"hairline_thickness": 1`, `"primary_outline_offset": 3`, `"primary_outline_width": 1`, `"primary_min_height": 56`, `"min_radius_floor": 26`).
  - `&StringName` for token references that flow through `role_table.get(...)` (e.g., `"primary_outline_color": &"role_primary"`).
- **Pitfall 5 mirror invariant (RESEARCH § Common Pitfalls):** every new key MUST appear in `STYLE_PERSONALITY_DEFAULT.shape` AND in ALL FIVE per-direction shape dicts. The no-op default values are documented in CONTEXT.md / RESEARCH:
  - `hairline_thickness: 0` (Slate adds 1)
  - `min_radius_floor: 0` (Bubble adds 26)
  - `primary_outline_color: &"role_primary"` (Daybreak adds same — safe default, gated by width)
  - `primary_outline_offset: 0` (Daybreak adds 3)
  - `primary_outline_width: 0` (Daybreak adds 1; **width=0 is the disable gate**)
  - `primary_min_height: 0` (Burst adds 56)
- **Reading shape values:** always via `_lookup_shape(style_personality, "shape.<key>")` (the function at line 5014). It returns `null` if a key is missing — so the recipe-side code MUST check for `null` AND check the disable-sentinel (`<= 0` for ints, `""` / empty StringName for strings). The existing pattern in `_resolve_recipe` at lines 5283–5290, 5295–5302 (raised_intensity / alpha) is the precedent for `shape.<key>` lookup with safe int coercion.

---

### 3. `BINDING_TABLE` color-source rebind (C2')

**Target:** `addons/neocade_theme/scripts/neocade_theme.gd` — these specific rows:

| Row | Lines | Current source | Target source (per CONTEXT D-12.07) |
|---|---|---|---|
| `HSlider.stylebox.grabber_area_highlight` | 2938 | `"role": "accent_offset"` (already accent-derived) | confirm — likely no change needed |
| `ItemList.stylebox.selected` / `selected_focus` | 3019 / 3021 | `"role": "button_pressed", "border_role": "button_pressed"` | add `"border_widths": Vector4i(3, 0, 0, 0)` + `"border_role": "role_primary"` |
| `TabBar.stylebox.tab_selected` | 3443 | `"border_role": "button_border_pressed", "border_width": 0` | replace `border_width: 0` with `"border_widths": Vector4i(0, 2, 0, 0)` + `"border_role": "role_primary"` |
| `TabContainer.stylebox.tab_selected` | 3495 | same as TabBar tab_selected | same rebind |
| `Tree.stylebox.selected` / `selected_focus` | 4040 / 4042 | `"role": "button_pressed", "border_role": "button_pressed"` | same as ItemList.selected rebind |
| `Kicker.color.font_color` | 4910–4911 | already `{"kicker_style": "shape.kicker_style"}` → resolves accent via `_apply_kicker_style` | no change needed — already accent for Pulse/Bubble/Daybreak/Burst |

**Operation:** modify — preserve the row's slot name and recipe shape; change only the `role` / `border_role` / `border_widths` keys.

**Closest analog — existing rows that already bind to `role_primary` in idle/selected chrome.** These prove the recipe-resolution path already supports the target tokens (no resolver changes needed).

**Excerpt (file: `addons/neocade_theme/scripts/neocade_theme.gd`):**

```gdscript
# Lines 3117 — LineEdit.color.caret_color already binds role_primary; representative of the
# resolved-token shape the rebinds aim for.
"caret_color":           {"role": "role_primary"},

# Lines 3031–3032 — ItemList.color.font_selected_color already binds role_primary; this
# proves role_primary is a live key in role_table for every direction.
"font_selected_color":         {"role": "role_primary"},
"font_hovered_selected_color": {"role": "role_primary"},

# Lines 4062, 4067, 4069 — Tree.color rows that already use role_primary on selected/drop.
"drop_position_color":         {"role": "role_primary"},
"font_hovered_selected_color": {"role": "role_primary"},
"font_selected_color":         {"role": "role_primary"},

# Lines 3472, 3528 — TabBar / TabContainer drop_mark_color already role_primary.
"drop_mark_color":       {"role": "role_primary"},
```

**Excerpt — TabBar `tab_selected` row to rebind (lines 3443–3446 BEFORE):**

```gdscript
"tab_selected":     {"role": "button_pressed", "border_role": "button_border_pressed",
                        "raised_intensity": 0, "border_width": 0,
                        "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                        "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},

# AFTER (preserves face color; adds 2px top accent stripe via existing border_widths handling
# at lines 5382–5389):
"tab_selected":     {"role": "button_pressed", "border_role": "role_primary",
                        "raised_intensity": 0,
                        "border_widths": Vector4i(0, 2, 0, 0),
                        "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                        "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

**Excerpt — the recipe-side `border_widths: Vector4i` handler that makes the rebind work (lines 5382–5391):**

```gdscript
var border_widths_raw: Variant = recipe.get("border_widths", null)
if border_widths_raw != null and typeof(border_widths_raw) == TYPE_VECTOR4I:
    var widths := border_widths_raw as Vector4i
    sb.border_color = border_color
    sb.border_width_left = maxi(0, widths.x)
    sb.border_width_top = maxi(0, widths.y)
    sb.border_width_right = maxi(0, widths.z)
    sb.border_width_bottom = maxi(0, widths.w)
else:
    _apply_outline_border(sb, border_color, maxi(0, border_width))
```

**Notes for planner:**
- **Recipe shape is frozen at 37 rows** (Cycle 1 C1). Rebinds REPLACE field values inside an existing row dict; do NOT add a new top-level BINDING_TABLE entry.
- **`role_primary` is the canonical key**, not `accent_color`. Per role_table (built in `_resolve_role_table` — exists in the file; see `role_table.role_primary` references throughout `_resolve_recipe`), `role_primary` is the resolved accent color. Using `role_primary` over `accent_color` matches Phase 5–7 idiom (see SC#5 hue invariant — RESEARCH "Anti-Patterns to Avoid" sixth bullet).
- **Vector4i layout is `(left, top, right, bottom)`** per Phase 6 BINDING_TABLE convention (verified by reading the assignment at lines 5386–5389). Top stripe = `Vector4i(0, 2, 0, 0)`. Left stripe = `Vector4i(3, 0, 0, 0)`.
- **When `border_widths` is present, the recipe-side handler ignores `border_width`** — see the `else` branch above. Remove `"border_width": 0` from the row when introducing `border_widths`.
- **Replace `border_role: button_border_pressed` → `border_role: role_primary`**. This is what gives the stripe its accent color.
- **`corner_profile: tab_connected` must be preserved** — see lines 3445, 3497. The recipe resolution at 5369–5374 routes tab styleboxes through `_set_tab_connected_radius` which zeros bottom corners; do not break this.
- **Mobile path (D-12.10):** the `mobile_padding` key is unchanged. Density scaling at lines 5398–5421 applies only to padding, not to `border_widths` — RESEARCH § Cross-cutting concerns confirms this. 2px top stripe stays 2px on MOBILE.
- **Pitfall check:** the assumption that BOTH `border_role: "role_primary"` AND `border_widths` are needed (you cannot rely on `border_role` alone — the default `border_width: 0` path zeros all four sides). Always pair them.

---

### 4. Daybreak C6 — flat outline at 3px offset via `expand_margin_*` + `border_width_*`

**Target:** `addons/neocade_theme/scripts/neocade_theme.gd` — three new shape keys in `Style.DAYBREAK.shape` (around line 1030), and a recipe-side thread-through inside `_resolve_recipe()` stylebox branch (after line 5391, before line 5450).
**Operation:** modify — add keys; add gated mutation block.

**Closest analog 1 — focus-ring stylebox at lines 5305–5346.** It is the only existing pattern that combines `expand_margin_*` with `border_width_*` on a StyleBoxFlat. The focus-ring uses 4-sided expand_margin to push the ring outside the control rect — exactly the technique Daybreak's outline needs.

**Excerpt (file: `addons/neocade_theme/scripts/neocade_theme.gd`):**

```gdscript
# Lines 5305–5346 — focus_ring stylebox: bg transparent, border_color = accent,
# expand_margin_* used to push the ring outside the control rect. This is the
# only existing usage of expand_margin per-side on a generated StyleBoxFlat.
if role == "focus_ring":
    var focus_sb := StyleBoxFlat.new()
    focus_sb.bg_color = Color(0, 0, 0, 0)
    focus_sb.border_color = role_table.role_primary
    focus_sb.border_width_left = focus_thickness
    focus_sb.border_width_top = focus_thickness
    focus_sb.border_width_right = focus_thickness
    focus_sb.border_width_bottom = focus_thickness
    # … radius / corner_profile resolution …
    var focus_offset_v: Variant = _lookup_shape(style_personality, "shape.focus_offset")
    var focus_offset_int: int = 2
    if focus_offset_v != null and (typeof(focus_offset_v) == TYPE_INT or typeof(focus_offset_v) == TYPE_FLOAT):
        focus_offset_int = int(focus_offset_v)
    focus_sb.expand_margin_left = focus_offset_int
    focus_sb.expand_margin_top = focus_offset_int
    focus_sb.expand_margin_right = focus_offset_int
    focus_sb.expand_margin_bottom = focus_offset_int
    focus_sb.shadow_size = 0
    return focus_sb
```

**Closest analog 2 — `_set_expand_margins` helper at lines 5084–5088** for the Vector4i-driven path:

```gdscript
func _set_expand_margins(sb: StyleBoxFlat, margins: Vector4i) -> void:
    sb.expand_margin_left = margins.x
    sb.expand_margin_top = margins.y
    sb.expand_margin_right = margins.z
    sb.expand_margin_bottom = margins.w
```

**Closest analog 3 — `_apply_outline_border` at lines 5091–5097** (border-width setter, the helper Daybreak should call to install the 1px line):

```gdscript
func _apply_outline_border(sb: StyleBoxFlat, color: Color, width: int = -1) -> void:
    var resolved_width := outline_width if width < 0 else width
    sb.border_color = color
    sb.border_width_left = resolved_width
    sb.border_width_top = resolved_width
    sb.border_width_right = resolved_width
    sb.border_width_bottom = resolved_width
```

**Closest analog 4 — `_apply_primary_strategy` "friendly-generous" branch at lines 5165–5168** (where Daybreak primary currently lives; the planner's outline thread-through must run AFTER this so it can override `border_color`):

```gdscript
"friendly-generous":
    # Daybreak: accent fill; padding/radius already applied by shape.* recipe rows.
    sb.bg_color = role_table.get("role_primary", role_table.surface_panel)
    sb.border_color = role_table.get("accent_rim", role_table.outline_color)
```

**Notes for planner:**
- **`expand_margin_*` is the right primitive.** RESEARCH § "Don't Hand-Roll" confirms: Godot 4.6 `expand_margin_*` is designed for "border outside control rect"; no need to stack styleboxes or wrap with a Control.
- **`expand_margin_*` is a `float`** field per Godot 4.6 (verified Context7 in research § Standard Stack). The focus_ring assignment at 5341–5344 stores an `int` into a `float` field, which Godot accepts. Follow the same idiom: `sb.expand_margin_left = int(outline_offset_v)` is fine.
- **Gate the outline on `raised`** (Pitfall 1 in RESEARCH). The cleanest path is to wrap the mutation block in `if raised and outline_width > 0:`. SC#1 verifier MUST see flat output when `raised=false`.
- **Daybreak's outline overrides the strategy-applied border.** `_apply_primary_strategy("friendly-generous", …)` runs before the planner's outline block (dispatch order at lines 5444–5447), so the outline block must explicitly set `sb.border_color = role_table.get(outline_color_key, role_table.role_primary)` to override `accent_rim` (which `friendly-generous` set at line 5168).
- **Trigger condition** (RESEARCH § Pattern 5): the outline applies only to PRIMARY-button styleboxes. Detect by checking the recipe has `"strategy": "shape.primary_strategy"` (the only recipes that opt into primary strategy dispatch). Alternative: detect via `theme_type in ["Button", "PrimaryButton", "OptionButton", "MenuButton"]` — but the strategy-key check is more local.
- **Full alpha mandatory** (SC#3, Pitfall 3). The outline must use the default `border_alpha = 1.0`. Do NOT introduce a `border_alpha < 1.0` setting — the GL Compatibility renderer over-renders alpha (Godot issue #23640), which is exactly the "halo" failure mode the constraint forbids.
- **Use `_apply_outline_border(sb, outline_color, outline_width)`** to install the 4-sided border (matches the existing helper-call idiom). Then set the 4 `expand_margin_*` fields directly (no helper takes a uniform `int` value, so write them out — focus_ring at 5341–5344 is the precedent for direct assignment).
- **Bump `primary_padding` from `Vector2i(15, 9)` to `Vector2i(20, 14)`** in Daybreak's shape dict at line 1030. This is a separate change from the outline thread-through; do not conflate.

---

### 5. Slate C6 — `hairline_thickness` thread-through

**Target:** `addons/neocade_theme/scripts/neocade_theme.gd` — add `hairline_thickness` key to Slate shape (around line 968) + default in all other directions + DEFAULT; gate `border_width` override in `_resolve_recipe` stylebox branch (after line 5376).
**Operation:** modify — add data; insert one conditional block.

**Closest analog — the existing `border_width` resolution at line 5376** in `_resolve_recipe` stylebox branch:

```gdscript
# Line 5376 — current border_width derivation; the planner's hairline gate overrides this.
var border_width: int = int(recipe.get("border_width", outline_width))
```

The hairline gate should run AFTER this assignment and force-override `border_width` when `hairline_thickness > 0`:

```gdscript
# Planner-introduced (post-line-5376), follows the existing `_lookup_shape + int-coercion` idiom
# from raised_intensity (lines 5285–5290) and alpha (5295–5302).
var hairline_raw: Variant = _lookup_shape(style_personality, "shape.hairline_thickness")
var hairline: int = 0
if hairline_raw != null and (typeof(hairline_raw) == TYPE_INT or typeof(hairline_raw) == TYPE_FLOAT):
    hairline = int(hairline_raw)
if hairline > 0 and recipe.has("border_role"):
    border_width = hairline
```

**Notes for planner:**
- **The trigger condition `recipe.has("border_role")`** scopes the hairline to "chrome that has a border" — i.e., the interactive surfaces (Button, LineEdit, OptionButton, etc.). Recipes without `border_role` (e.g., `{"empty": true}` styleboxes at lines 3093–3094, panel backgrounds with `surface_panel_edge`, etc.) keep their existing widths.
- **DO NOT apply hairline override inside the `border_widths: Vector4i` branch** (lines 5383–5389). When a row specifies its own per-side widths (C2' rebinds!), the recipe-side widths must win over hairline. The override should only affect the `else` branch (`_apply_outline_border` path at line 5391).
- The cleaner placement: insert the gate right before line 5391 (`_apply_outline_border(sb, border_color, maxi(0, border_width))`) and update only the `border_width` variable used by that single call.
- **`_lookup_shape` returns `null` for missing keys** (line 5028). All five directions + DEFAULT must have `hairline_thickness` in their shape dict (Pitfall 5) — but the planner's `null` check is defense-in-depth for any future `Style.CUSTOM` user who replaces `STYLE_PERSONALITY_DEFAULT`.

---

### 6. Bubble C6 — `min_radius_floor` thread-through

**Target:** `addons/neocade_theme/scripts/neocade_theme.gd` — add `min_radius_floor` key to Bubble shape (around line 1003) + default in others + DEFAULT; floor `resolved_radius` in `_resolve_recipe` stylebox branch (after line 5368).
**Operation:** modify — add data; insert one conditional `max()` line.

**Closest analog — radius resolution at lines 5359–5368** in `_resolve_recipe`:

```gdscript
# Lines 5359–5368 — existing radius lookup.
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
```

**Planner edit — insert between the resolution and `_set_radius_all` call:**

```gdscript
# Bubble C6 floor: enforce min_radius_floor without clamping pill radii (max not min).
var min_floor_raw: Variant = _lookup_shape(style_personality, "shape.min_radius_floor")
if min_floor_raw != null and (typeof(min_floor_raw) == TYPE_INT or typeof(min_floor_raw) == TYPE_FLOAT):
    var floor_v: int = int(min_floor_raw)
    if floor_v > 0:
        resolved_radius = maxi(resolved_radius, floor_v)
_set_radius_all(sb, resolved_radius)
```

**Notes for planner:**
- **`max`, not `min`** (Pitfall 4 in RESEARCH). Bubble's `primary_radius=999` must remain 999 — the floor only lifts small radii to 26.
- **`corner_profile` paths at lines 5369–5374** (`_set_tab_connected_radius`, `_set_top_only_radius`, `_set_bottom_only_radius`) take `resolved_radius` after the floor. The floor must be applied BEFORE the corner-profile dispatch so it propagates through. Insert the floor block BEFORE line 5369 (the `var corner_profile := …` line).
- **Bubble's existing values already satisfy the floor for chrome** (RESEARCH § Bubble specifics): `regular_radius=26`, `tab_radius=999`, `chip_radius=999`, `card_radius=26`, `hero_radius=26`. The floor is *insurance* — but it must also cover recipes that hardcode small `radius:` integers and recipes that fall back to the @export `corner_radius` (which may be 0 for `Style.CUSTOM` users).

---

### 7. Burst C6 — `primary_min_height` thread-through

**Target:** `addons/neocade_theme/scripts/neocade_theme.gd` — add `primary_min_height` key to Burst shape (around line 1088) + default in others + DEFAULT; floor content_margin top/bottom in `_resolve_recipe` stylebox branch (after padding application around line 5421).
**Operation:** modify — add data; insert one conditional block.

**Closest analog — padding application at lines 5398–5423** (the existing `_set_content_margin_from_padding` call site that drives Button minimum-size today). The planner's min-height block runs AFTER this, so it can read the applied content_margin and lift it as needed.

**Excerpt (file: `addons/neocade_theme/scripts/neocade_theme.gd`):**

```gdscript
# Lines 5398–5423 — existing padding application. Content margins are set here; minimum_size
# is computed by Godot as content_margin_top + content_margin_bottom + content height.
if tokens.get("densityScale", 1.0) > 1.0 and mobile_padding_raw != null and typeof(mobile_padding_raw) == TYPE_VECTOR2I:
    _set_content_margin_from_padding(sb, mobile_padding_raw as Vector2i)
    applied_padding = true
# … other padding branches …
if not applied_padding:
    _set_content_margin_from_padding(sb, Vector2i.ZERO)
```

**Planner edit — insert after line 5423 (after padding application closes):**

```gdscript
# Burst C6 floor: ensure primary buttons hit a per-direction minimum visual height by
# lifting content_margin_top/bottom symmetrically when below the target. Gated on the
# recipe carrying a primary_strategy (so only primary buttons get oversized).
if recipe.has("strategy") and String(recipe.get("strategy", "")).ends_with(".primary_strategy"):
    var min_h_raw: Variant = _lookup_shape(style_personality, "shape.primary_min_height")
    if min_h_raw != null and (typeof(min_h_raw) == TYPE_INT or typeof(min_h_raw) == TYPE_FLOAT):
        var min_h: int = int(min_h_raw)
        if min_h > 0:
            # Default body font_size is the most consistent proxy for content height.
            var content_h: int = int(tokens.get("body", default_font_size))
            var current_min: int = sb.content_margin_top + content_h + sb.content_margin_bottom
            if current_min < min_h:
                var extra: int = min_h - current_min
                var half: int = extra / 2
                sb.content_margin_top += half
                sb.content_margin_bottom += extra - half
```

**Notes for planner:**
- **Primary-only trigger** uses the same condition as Daybreak's outline: `recipe.strategy ends with ".primary_strategy"`. This avoids over-applying min-height to regular buttons / chips / tabs.
- **Mobile path:** `tokens.body` on MOBILE = 16 (line 853); on DESKTOP = the desktop body token. The `tokens` Dictionary passed in already reflects the resolved platform — so `content_h` is platform-aware automatically.
- **Mobile min_height vs desktop:** D-12.11 says "56 desktop / 64 mobile". The simplest approach is to read `tokens.primaryButtonMin` (which is 56 mobile / 44 desktop per lines 850, 867) as the floor, OR add a separate `primary_min_height_mobile` shape key. RESEARCH § Burst specifics recommends the `tokens.primaryButtonMin` approach but flags it as a discretion call. The plan should pick ONE path and document the trade-off.
- **Even-split the extra padding** (top vs bottom) — uses `half = extra / 2; bottom = extra - half` to handle odd integer divisions without losing a pixel. Mirrors the focus_offset symmetric-application idiom at lines 5341–5344.

---

### 8. Pulse C6 — showcase Kicker addition (no code changes)

**Target:** `showcase/showcase.tscn` — add ONE Kicker Label above the "Buttons" section heading inside `RootMargin/RootStack/ShowcaseTabs/Buttons/Margin/Grid`.
**Operation:** modify — append ~5 lines of `.tscn` syntax.

**Closest analog — existing Kicker-label pattern at lines 136–139** (the Label above PrimaryButton inside PrimaryStack). Already-canonical for the codebase: the showcase has 12 Kicker labels distributed across "Text Inputs" and "Token Gallery" tabs.

**Excerpt (file: `showcase/showcase.tscn`):**

```gdscript-tres
# Lines 128–139 — existing PrimaryPanel + PrimaryStack + Kicker Label pattern.
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

**Notes for planner:**
- **RESEARCH § Open Question 1 recommends reusing `Kicker`** rather than registering a new `SectionKicker` TYPE_VARIATION. The existing `Kicker` is already accent-colored for Pulse via `_apply_kicker_style("uppercase-tracked-accent", ...)` → `role_primary` (line 5251).
- **The Pulse C6 signature is therefore primarily a showcase scene edit, not a code edit.** Add a single Kicker Label that reads (e.g.) `"BUTTONS · IDENTITY"` directly above the "Buttons" grid so the chrome is visible on the most-frequented showcase tab.
- **`theme_type_variation = &"Kicker"` is mandatory** — this is what dispatches the Label to the Kicker variation's `font_color` recipe (BINDING_TABLE row at lines 4909–4913).
- **Uppercase content is content-side** — Godot 4.6 Label has no letter-spacing slot (documented at neocade_theme.gd:1203–1211). Write the Label `text =` field in uppercase to match the "tracked-uppercase" feel.
- **`unique_id` integers must not collide** with existing nodes. The Godot scene file generator handles this if you let the editor save the scene; if hand-editing, pick a value > 2_500_000_000 (no existing nodes reach there per a grep of `unique_id=` in the file).
- **Do NOT add a `SectionKicker` to BINDING_TABLE / TYPE_VARIATIONS** unless the planner decides the visual distinction is needed (RESEARCH OQ1 says: defer). Registering a new variation also adds churn to SC#6's TYPE_VARIATIONS-count assertion in the verify helper.

---

### 9. Wave 0 verify helper — EditorScript variant

**Target:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd` — create.
**Operation:** create.

**Closest analog — `.planning/phases/04-…/helpers/_phase4_verify.gd`** (the EditorScript precedent for "load canonical resource, run assertions in-editor"). Pattern: `@tool extends EditorScript`, single `_run()` entry, hand-written `assert(…)` calls, no signaling back to caller beyond the editor console.

**Excerpt (file: `.planning/phases/04-…/helpers/_phase4_verify.gd`):**

```gdscript
# Lines 1–22 — header + load + sanity assertions; this is the load-and-verify idiom.
@tool
extends EditorScript

## Phase 4 verification helper (EditorScript variant). Run via Godot Editor → File → Run.
## NOT distributed with the addon (lives outside addons/neocade_theme/).

func _run() -> void:
    _verify_pulse()
    _verify_peers()

func _verify_pulse() -> void:
    var path := "res://addons/neocade_theme/pulse_neocade_theme.tres"   # ⚠ STALE — see Pitfall 6
    var loaded: Resource = ResourceLoader.load(path)
    assert(loaded != null, "ResourceLoader.load returned null for pulse_neocade_theme.tres")
    assert(loaded is NeoCadeTheme, "loaded resource is not a NeoCadeTheme")
    var theme: NeoCadeTheme = loaded
    assert(theme.has_stylebox("normal", "Button"), "pulse missing Button.normal stylebox after load+regenerate")
```

**Notes for planner:**
- **MUST update load path to canonical resource:** `res://addons/neocade_theme/neocade_theme.tres` (NOT `pulse_neocade_theme.tres` — that file was deleted 2026-05-08; Pitfall 6 in RESEARCH).
- **Per-direction testing uses the `style` setter, not separate `.tres` files:** `theme.style = NeoCadeTheme.Style.SLATE` triggers `_apply_style_exports` (line 58) which regenerates. Loop styles via `NeoCadeTheme.selectable_styles()` (line 171).
- **Use `assert(…)` not `push_error + quit(1)`** — this is the EditorScript variant; assertions surface in the Godot editor's Output panel.
- **Body is duplicated, not loaded** (per Phase 4 KISS comment at `_phase4_verify_headless.gd:22–23`): the EditorScript and the SceneTree headless variant share the same assertion battery, copy-pasted, to keep each helper standalone.

---

### 10. Wave 0 verify helper — headless SceneTree variant

**Target:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` — create.
**Operation:** create.

**Closest analog 1 — `_phase4_verify_headless.gd`** (lines 1–20) for the `extends SceneTree` + `_init()` + `ResourceLoader.load` + `quit(code)` shape.

**Closest analog 2 — `_phase5_verify_headless.gd`** (lines 250–286) for the `--stage <name>` argparse pattern (CRITICAL for Phase 12, which needs `--stage architecture | sc1-no-3d-when-flat | sc2-tabs-flat-when-raised | sc3-no-glow-halo | sc6-export-count | smoke-30 | full`).

**Excerpt — argparse from `_phase5_verify_headless.gd:256–286`:**

```gdscript
var _stage: String = "tooling"
var _failures: Array[String] = []
var _pending: Array[String] = []
var _ok_markers: Array[String] = []

func _init() -> void:
    _parse_args()
    _run_verifier()
    _emit_summary_and_quit()


func _parse_args() -> void:
    # Godot 4.6 splits CLI args at the literal `--`. Args before `--` go to
    # OS.get_cmdline_args() (engine args + --script <path>); args after `--`
    # go to OS.get_cmdline_user_args() (user-supplied script args). The plan
    # verifies via `... --script <path> -- --stage tooling`, so we read
    # get_cmdline_user_args() first and fall back to get_cmdline_args() so
    # the script also works if someone forgets the `--` separator.
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
    if _stage != "tooling" and _stage != "strict" and …:
        push_error("PHASE5_VERIFY FAIL: unknown --stage '%s'" % _stage)
        _stage = "tooling"
    print("PHASE5_VERIFY: stage=%s" % _stage)
```

**Excerpt — exit code reporting from `_phase4_verify_headless.gd:158–166`:**

```gdscript
if failures.size() > 0:
    print("FAIL — Phase 4 headless verify failures:")
    for f in failures:
        print("  - ", f)
    quit(1)
    return

print("PASS — Phase 4 headless verification: pulse_neocade_theme.tres passes all gates.")
quit(0)
```

**Notes for planner:**
- **`extends SceneTree`** (NOT EditorScript) — this lets the script run via `godot --headless --quit --script <path>`.
- **`_init()` is the entry point** (not `_run()`); SceneTree subclasses execute body at process start.
- **CLI invocation pattern** (from RESEARCH § Test Framework): `godot --headless --quit --script "<absolute path>" -- --stage <stage>`. The double-dash `--` separates engine args from user args. The `_phase5_verify_headless.gd` parser reads both `OS.get_cmdline_user_args()` and `OS.get_cmdline_args()` for forgiveness.
- **Exit code 0 = pass, 1 = fail.** CI relies on this. Always call `quit(0)` or `quit(1)` at the end; `quit()` without arg is undefined-status.
- **Print prefix convention:** Phase 4 uses `"PASS — Phase 4 headless verification: …"` / `"FAIL — Phase 4 headless verify failures:"`. Phase 5 uses `"PHASE5_VERIFY: stage=%s"` markers (lines 254 + emitted via `_emit_summary_and_quit`). Phase 12 should follow Phase 5's marker convention so CI can grep for `PHASE12_VERIFY:` lines.
- **Stage list (from VALIDATION.md):** `architecture`, `sc1-no-3d-when-flat`, `sc2-tabs-flat-when-raised`, `sc3-no-glow-halo`, `sc6-export-count`, `smoke-30`, `full`. `full` runs all stages. Unknown stage → push_error + fallback to `architecture` (Phase 5 idiom).
- **SC#3 grep stage** (no glow halos): the simplest implementation is to iterate every generated StyleBoxFlat on the live theme (per style × raised), call `get_color("border_color", …)` / read `sb.border_color`, and assert `border_color.a == 1.0 OR border_color.a == 0.0` (no intermediate alpha). This is faster and more robust than text-grep of `Color(...)` literals.
- **SC#6 export-count assertion** (from RESEARCH § Verify helper skeleton): walk `theme.get_script().get_property_list()`, count entries with `PROPERTY_USAGE_SCRIPT_VARIABLE` set, assert == 12. The existing 12 are listed in CONTEXT.md D-12.16.

---

### 11. Wave 0 thumbnail render helper (SC#4)

**Target:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd` — create.
**Operation:** create.

**Closest analog:** *None in the repo.* This is a new pattern (no thumbnail / viewport-capture helper exists). The planner should:
1. `extends SceneTree`.
2. `await get_root().tree_changed` or one-frame yield after instancing the showcase scene to let layouts settle.
3. Load `res://showcase/showcase.tscn`, instantiate, add to root, iterate `Style.PULSE..BURST`, set `theme.style = <style>` on the showcase's root theme override, capture via `get_viewport().get_texture().get_image()`, resize to 256×144, call `image.adjust_bcs(0.0, 0.0, 0.0)` (A1 assumption — RESEARCH § Verification tooling — empirically test saturation=0 vs saturation=-1; pick the value that produces grey).
4. Save to `.planning/phases/12-signature-visual-moves/artifacts/thumbnails/<style>-raised<bool>.png` via `image.save_png(path)`.

**Notes for planner:**
- **`Image.adjust_bcs` saturation semantics** are documented but not iron-clad — RESEARCH Assumption A1 calls this out. The helper should test both `0.0` and `-1.0` empirically in dev and pick the one that produces a greyscale image; document the choice inline.
- **Headless viewport capture** requires the engine to actually render a frame. Without a window, `get_viewport().get_texture().get_image()` returns a transparent surface. Either run non-headless (Godot Editor) for thumbnail generation OR use the `--rendering-driver opengl3` + offscreen render path. **The simplest first cut is to require this helper run from inside the Godot Editor (File → Run), not headless** — document this in the helper's docstring and keep the headless verifier separate.
- **Output is 5 PNGs** (one per style, `raised=true` only — the locked greyscale gate is per-direction identifiability with the signature C6 moves visible, which only manifest at raised=true for Daybreak/Burst). The user attests pass/fail per Phase 9/10 precedent.

---

### 12. Wave 0 smoke matrix helper (SC#6 + 30-config gate)

**Target:** `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd` — create.
**Operation:** create.

**Closest analog — `_phase4_verify_headless.gd` peer-iteration block (lines 132–157):**

```gdscript
# Lines 132–157 — peer .tres iteration pattern. Phase 12's smoke matrix
# uses the same shape: iterate configs, load/instantiate per config, assert
# per-config invariants, collect failures, exit code based on count.
var peers := [
    {"file": "slate_neocade_theme.tres",    "expected_spread": 0.7, "base": Color("#111820")},
    {"file": "bubble_neocade_theme.tres",   "expected_spread": 1.0, "base": Color("#241326")},
    {"file": "daybreak_neocade_theme.tres", "expected_spread": 1.0, "base": Color("#0B2420")},
    {"file": "burst_neocade_theme.tres",    "expected_spread": 1.3, "base": Color("#20112E")},
]
for d in peers:
    var peer_path: String = "res://addons/neocade_theme/" + str(d.file)
    var peer_loaded: Resource = ResourceLoader.load(peer_path)
    if peer_loaded == null:
        failures.append("peer load null: %s" % d.file)
        continue
    if not (peer_loaded is NeoCadeTheme):
        failures.append("peer not NeoCadeTheme: %s" % d.file)
        continue
    var pt: NeoCadeTheme = peer_loaded
    if not pt.has_stylebox("normal", "Button"):
        failures.append("peer %s missing Button.normal stylebox" % d.file)
    # … additional per-peer assertions …
```

**Notes for planner:**
- **Phase 12 cannot use peer `.tres` files** (they're deleted). Replace the load-from-file loop with an in-memory matrix:
  ```gdscript
  var configs := []
  for style_v in NeoCadeTheme.selectable_styles():
      for raised_v in [true, false]:
          for platform_v in [NeoCadeTheme.Platform.DESKTOP, NeoCadeTheme.Platform.MOBILE]:
              configs.append({"style": style_v, "raised": raised_v, "platform": platform_v})
  # Truncate / curate to 30 entries per VALIDATION.md
  ```
- **The 30-subset selection rule is in RESEARCH § 30-config smoke matrix (line 740):** 5 styles × 2 raised × 1 platform=DESKTOP × default base/accent = 10; 5 styles × raised=true × MOBILE × default = 5; CUSTOM × 2 raised × 3 platforms = 6; 5 styles × raised=true × AUTO × custom base/accent = 5; 4 edge cases (very dark/light base, accent=base, accent over WCAG floor) = 4. Total 30.
- **Per-config assertions:**
  - `theme.has_stylebox("normal", "Button")` (regenerate produced Button chrome).
  - `theme.has_stylebox("panel", "PanelContainer")` (regenerate produced panel chrome).
  - `theme.get_script().get_script_constant_map().get("BINDING_TABLE", {}).size() == 37` (Cycle 1 C1 freeze).
  - Export count == 12 (SC#6).
- **Pattern same as `_phase4_verify_headless.gd:158–166`:** collect `failures: Array[String]`; if size > 0, print each and `quit(1)`; else `quit(0)`.

---

## Shared Patterns

### Shape-key resolution

**Source:** `addons/neocade_theme/scripts/neocade_theme.gd:5014–5030` (`_lookup_shape`).
**Apply to:** every new C6 thread-through (Slate hairline, Bubble floor, Daybreak outline, Burst min-height).

```gdscript
func _lookup_shape(style_personality: Dictionary, dotted_path: String) -> Variant:
    if not (dotted_path is String) or not dotted_path.begins_with("shape."):
        return null
    if not style_personality.has("shape"):
        return null
    var current: Variant = style_personality["shape"]
    var segments: PackedStringArray = dotted_path.substr(6).split(".")
    for seg in segments:
        if seg == "":
            return null
        if typeof(current) != TYPE_DICTIONARY:
            return null
        var d: Dictionary = current
        if not d.has(seg):
            return null
        current = d[seg]
    return current
```

**Usage idiom (extracted from `_resolve_recipe` lines 5285–5290 — raised_intensity lookup):**

```gdscript
var raw: Variant = _lookup_shape(style_personality, "shape.<key>")
var resolved: int = 0
if raw != null and (typeof(raw) == TYPE_INT or typeof(raw) == TYPE_FLOAT):
    resolved = int(raw)
if resolved > 0:
    # apply mutation
```

Always check for `null` AND apply the disable-sentinel (`<= 0` or `""`) — this satisfies Pitfall 5 (CUSTOM users with incomplete `STYLE_PERSONALITY_DEFAULT.shape`).

### Role-table color lookup

**Source:** `addons/neocade_theme/scripts/neocade_theme.gd:5347, 5378, 5150, etc.` (`role_table.get(<role>, <fallback>)`).
**Apply to:** every place a new color flows into a stylebox (C2' rebinds, Daybreak outline, etc.).

```gdscript
# Idiom: get(<canonical_role>, role_table.<safe_fallback>). Never use `Color()` literal as
# fallback (would be a new hue per SC#5).
var bg_color: Color = role_table.get(role, role_table.surface_panel)
var border_color: Color = role_table.get(border_role, role_table.outline_color)
```

`role_primary` is the canonical accent key (NOT `accent_color`); `accent_offset`, `accent_rim` are accent-derived. RESEARCH § Anti-Patterns bullet 6: "C2' rebinds should use `role_primary` for consistency."

### Raised gating (SC#1 invariant)

**Source:** `addons/neocade_theme/scripts/neocade_theme.gd:5353` (`var sb_intensity: int = (raised_strength * raised_intensity) if raised else 0`).
**Apply to:** Daybreak outline + any C6 move that has potential 3D leakage.

The existing `raised` gate is per-stylebox: `if raised else 0`. Every C6 mutation that introduces visible chrome NOT present at `raised=false` MUST be wrapped in an `if raised:` block (Pitfall 1). The SC#1 verify stage iterates every (style, raised=false) combination and asserts no chrome changed vs a pre-Phase-12 snapshot.

### No glow halos (SC#3 invariant)

**Source:** `addons/neocade_theme/scripts/neocade_theme.gd:5379` (`var border_alpha: float = float(recipe.get("border_alpha", 1.0))`).
**Apply to:** every C2' / C6 border addition.

**Never** set `border_alpha < 1.0` for newly-added borders. RESEARCH Pitfall 3: GL Compatibility renderer over-renders alpha (issue #23640). The default 1.0 is correct. Verifier stage `sc3-no-glow-halo` should assert every generated stylebox has `border_color.a ∈ {0.0, 1.0}` (full transparent or full opaque).

---

## No Analog Found

| File | Role | Reason |
|---|---|---|
| `_phase12_thumbnail_render.gd` | render helper | Repository has no prior viewport-capture / image-save helper. Pattern is new. RESEARCH § Verification tooling provides the recipe; planner authors it from the Godot 4.6 stdlib (`get_viewport().get_texture().get_image()`, `Image.resize`, `Image.adjust_bcs`, `Image.save_png`). |

All other Phase 12 surfaces have at least a role-match analog in the existing codebase.

---

## Metadata

**Analog search scope:**
- `addons/neocade_theme/scripts/neocade_theme.gd` (full file, 5765 lines — targeted reads only)
- `addons/neocade_theme/neocade_theme.tres` (canonical — confirmed unchanged)
- `showcase/showcase.tscn` (targeted via Grep for `Kicker`, `Buttons]`)
- `.planning/phases/04-…/helpers/_phase4_verify.gd`, `_phase4_verify_headless.gd`
- `.planning/phases/05-…/helpers/_phase5_verify_headless.gd` (argparse precedent only)

**Files scanned:** 8
**Pattern extraction date:** 2026-05-10
