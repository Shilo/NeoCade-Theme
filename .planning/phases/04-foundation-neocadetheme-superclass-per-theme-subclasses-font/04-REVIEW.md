---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
reviewed: 2026-05-06T17:44:39Z
depth: standard
files_reviewed: 17
files_reviewed_list:
  - addons/neocade_theme/neocade_theme.gd
  - addons/neocade_theme/pulse_neocade_theme.tres
  - addons/neocade_theme/slate_neocade_theme.tres
  - addons/neocade_theme/bubble_neocade_theme.tres
  - addons/neocade_theme/daybreak_neocade_theme.tres
  - addons/neocade_theme/burst_neocade_theme.tres
  - addons/neocade_theme/fonts/Inter-Variable.tres
  - addons/neocade_theme/fonts/Inter-HeaderLarge.tres
  - addons/neocade_theme/fonts/Inter-HeaderMedium.tres
  - addons/neocade_theme/fonts/Inter-HeaderSmall.tres
  - addons/neocade_theme/fonts/Inter-Body.tres
  - addons/neocade_theme/fonts/Inter-Caption.tres
  - addons/neocade_theme/fonts/Inter-Variable.ttf.import
  - main.tscn
  - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_import.gd
  - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_verify.gd
  - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_verify_headless.gd
findings:
  blocker: 2
  warning: 11
  info: 6
  total: 19
status: blocking
---

# Phase 4: Code Review Report

**Reviewed:** 2026-05-06T17:44:39Z
**Depth:** standard
**Files Reviewed:** 17
**Status:** blocking

## Summary

Reviewed the Phase 4 foundation: the `NeoCadeTheme` class (1216 lines), the 5 direction
`.tres` peers, the 6 font resources + Inter `.ttf.import` settings, the build/verify helpers,
and `main.tscn`. The D-01 invariant (no `Theme.clear()` in `_regenerate_theme`) holds —
iteration is additive throughout. The reentry guard, the per-direction `DIRECTION_PRESETS`
hex-key lookup, the additive 37-row `BINDING_TABLE` walk, and the `is_light` luminance branch
all look structurally correct.

Two BLOCKER-class defects were found:

1. **`addons/neocade_theme/fonts/Inter-Variable.tres` ships at 1,151,164 bytes** — the
   build helper round-trips the imported `FontFile` through `ResourceSaver.save()`, which
   inlines the entire Inter Variable Roman binary into the `.tres` as a `data =
   PackedByteArray(...)`. The addon now distributes the font data twice (`.ttf` 862,936 +
   `.tres` 1,151,164 = ~2.0 MB instead of the ~810 KB pledged in PROJECT.md / FONT-REVIEW.md
   "Total bundle ~810 KB"). All 5 `FontVariation.tres` resolve `base_font = ExtResource("Inter-Variable.tres")`,
   so the duplicate copy is the canonical resolved one consumers actually use; the original
   `.ttf` is now load-time-dead weight that just inflates `git` size and Web export bundle.
2. **`InfoText` type variation slot mismatch** — the variation is registered with base type
   `RichTextLabel`, then `set_font("font", "InfoText", body_font)` is called. RichTextLabel
   does NOT use a slot named `font`; its theme font slots are `normal_font`, `bold_font`,
   `italic_font`, `bold_italic_font`, `mono_font`. The InfoText font is therefore set on a
   slot RichTextLabel will never read; consumer-facing `InfoText` content will fall back to
   `theme.default_font`. Same pattern works for the 6 Button-rooted and 5 Label-rooted
   variations because Button and Label DO use a `font` slot.

Eleven WARNING-class issues follow, plus six INFO items. Notable WARNINGs include silent
fallback in role/icon resolution that hides typos, missing `@export_range` bounds on shape
ints (focus_thickness=0 / negative outline_width crash StyleBoxFlat), border on disabled
styleboxes not alpha-faded so disabled state has full-saturation outline against alpha bg,
and `_phase4_verify.gd` mutating a `ResourceLoader.load()`-cached Theme (editor pollution).

CheckButton ships only 2 of Godot 4.6's 8 actual icon slots (the 6 disabled/mirrored variants
are deferred per the in-source comment to v1.x — flagged here as a tracked WARNING since the
canonical scorecard claim "37/37 + 13 type variations populated" reads strictly per D-09).

---

## Blocker Issues

### BL-01: `Inter-Variable.tres` duplicates the entire Inter font binary (1.1 MB instead of a wrapper)

**File:** `addons/neocade_theme/fonts/Inter-Variable.tres` (1,151,164 bytes)
**Helper:** `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_import.gd:36-86`

**Issue:**
`_phase4_import.gd` step 3 calls `ResourceSaver.save(inter_ttf, "res://addons/neocade_theme/fonts/Inter-Variable.tres")`
where `inter_ttf` is the FontFile loaded from the just-imported `Inter-Variable.ttf`. Godot's
FontFile serializer writes the full font binary inline as a `data = PackedByteArray(...)`,
producing a 1.1 MB `.tres` that wraps the same 810 KB `.ttf` already present in the addon.
Effect:

- The bundled addon weighs `.ttf` (862 KB) + `.tres` (1.1 MB) ≈ **2.0 MB** for fonts alone,
  contradicting PROJECT.md ("Inter Variable Roman, OFL 1.1, ~810 KB") and FONT-REVIEW.md
  ("Total bundle ~810 KB. ... matches godot-minimal-theme's bundle exactly").
- All 5 `Inter-*.tres` `FontVariation` files reference `Inter-Variable.tres` as their
  `base_font`, so the duplicate copy is the live one. The `.ttf` is dead-weight to consumers.
- Web export will pay 2× the asset cost on the highest-risk export target (PROJECT.md
  "Web is highest-risk: font loading from `res://addons/`").
- Repo bloat: every git clone now carries the duplicate font as a tracked text file (the
  `.tres` is full of base64-like `PackedByteArray` text; no delta compression benefit).

The intent (per code comment line 79-80: "wrapper exists so consumers have a stable
preload-able resource path") was a thin wrapper that points back at the `.ttf`. ResourceSaver
does not produce a wrapper for a fully-loaded FontFile; it serializes its full state.

**Fix (pick one):**
Option A — delete the wrapper, point `FontVariation.base_font` directly at the `.ttf`:
```gdscript
# In _phase4_import.gd step 4:
var inter_base: FontFile = inter_ttf  # already loaded; skip the round-trip save
# Remove the ResourceSaver.save(inter_ttf, inter_tres_path) call entirely.
# Update each Inter-*.tres in step 4 (and the 5 already-saved files) to:
# base_font = ExtResource("Inter-Variable.ttf")
```
And update `neocade_theme.gd:164`:
```gdscript
var inter_file := preload("res://addons/neocade_theme/fonts/Inter-Variable.ttf") as FontFile
```

Option B — keep `.tres` but make it a wrapper without inlined data. Godot's recommended
pattern for a font wrapper resource is to load it via `[ext_resource type="FontFile"
path="res://addons/neocade_theme/fonts/Inter-Variable.ttf"]` inside a tiny `[gd_resource
type="FontFile"]` `.tres` (or use `FontFile.set_load_path` / loading semantics). Hand-author
the `.tres` rather than `ResourceSaver.save()`-ing the data-laden FontFile.

Either way the `.tres` should drop from 1.1 MB to a few hundred bytes.

**Verification:** after fix, `Get-Item Inter-Variable.tres | Select Length` should report
< 5 KiB. README's "~810 KB total bundle" claim becomes truthful.

---

### BL-02: `set_font("font", "InfoText", body_font)` writes to a slot RichTextLabel does not read

**File:** `addons/neocade_theme/neocade_theme.gd:185, 201, 404`

**Issue:**
The `TYPE_VARIATIONS` constant (line 404) registers `"InfoText": "RichTextLabel"`. RichTextLabel
in Godot 4.6 does NOT theme a font under the slot name `"font"`. Per the Godot 4.6 RichTextLabel
class reference, its font theme entries are `normal_font`, `bold_font`, `italic_font`,
`bold_italic_font`, and `mono_font` (and corresponding `*_font_size` constants). The line
`set_font("font", "InfoText", body_font)` writes a font under a slot RichTextLabel will never
look up; the same applies to `set_font_size("font_size", "InfoText", tokens.body)`.

Net effect at runtime: any node configured with type variation `InfoText` will fall back to
`theme.default_font` (the FontFile, not the FontVariation `body_font`) for its text rendering.
The PITFALLS 1.2 mandate that "type variations don't inherit fonts" is technically obeyed
(a font WAS set), but the slot is semantically wrong, so the fix the mandate exists to enforce
is null-and-void for InfoText. Phase 4 SC#7 ("13 type variations populated with required fonts")
fails strictly read for this variation.

The other 12 variations (6 Button-rooted, 5 Label-rooted, 1 PanelContainer-rooted) are fine
because Button, Label, and PanelContainer do use the slot name `"font"` (Button + Label) or
do not require a font slot (PanelContainer is style-only).

**Fix:**
```gdscript
# Replace lines 185 + 201:
set_font("normal_font", "InfoText", body_font)
set_font_size("normal_font_size", "InfoText", tokens.body)
# Optionally also bold/italic if InfoText should bold consistently:
# set_font("bold_font", "InfoText", header_small_font)  # if InfoText [b] should be heavier
```

Then update `_phase4_verify.gd:81` and `_phase4_verify_headless.gd:47` from
`theme.has_font("font", v)` to a per-variation check that knows InfoText needs `normal_font`,
or assert the consumer-facing `theme.has_font("normal_font", "InfoText")`.

---

## Warning Issues

### WR-01: Silent fallback in `_resolve_recipe` masks role typos in `BINDING_TABLE`

**File:** `addons/neocade_theme/neocade_theme.gd:1161, 1165, 1197`

**Issue:**
The stylebox/color branches do `role_table.get(role, role_table.surface_panel)` (or
`surface_panel_offset` / `text_strong`) when the named role is not in `role_table`. A typo
like `"role": "rolle_primary"` or `"role": "stat_hover"` (vs `state_hover`) is silently
substituted with the fallback color. The BINDING_TABLE has 200+ recipes; a single typo would
ship visually-wrong but-passing-tests state colors with no surfaced error.

**Fix:** push_error on missing role and return `null` (caller already skips on null per D-04):
```gdscript
if not role_table.has(role):
    push_error("BINDING_TABLE: unknown role '%s' in recipe (data_type=%s)" % [role, data_type])
    return null
var bg_color: Color = role_table[role]
```
Apply at lines 1161, 1165, 1197. Run the verify helpers; if any role is unreachable they will
now error rather than silently substitute. The same treatment should apply to the
`role + "_offset"` lookup (line 1165) — for `role == "state_hover"` etc. there is no
`state_hover_offset` in role_table, so every state-hover stylebox in raised mode borrows
`surface_panel_offset` even though its bg is `state_hover` (mixed-family offset).

---

### WR-02: Disabled styleboxes apply alpha to bg only — border stays opaque

**File:** `addons/neocade_theme/neocade_theme.gd:1138-1163, 1172-1176`

**Issue:**
For a recipe with `"disabled": true`, `alpha = presets.disabled_opacity` (e.g. 0.42 for Pulse).
The bg gets `Color(r, g, b, 0.42)` (line 1163), but the border is set later to `outline_color`
without alpha (line 1172). A disabled Button thus renders as a 42%-opacity panel surrounded
by a 100%-opacity outline — visually the button looks "ghosted" inside but "framed" by a
fully-saturated rectangle, defeating the disabled state visual cue. M3's disabled spec (per
`presets.disabled_opacity`) is meant to apply uniformly to chrome, not to bg only.

**Fix:**
```gdscript
var border_alpha: float = alpha  # honor the disabled fade on the outline too
var bordered_outline := Color(role_table.outline_color.r, role_table.outline_color.g,
                              role_table.outline_color.b, border_alpha)
sb.border_color = bordered_outline
```

---

### WR-03: Missing `@export_range` on shape ints — `focus_thickness=0` makes focus invisible; negative `outline_width` errors StyleBoxFlat

**File:** `addons/neocade_theme/neocade_theme.gd:53-81`

**Issue:**
The 5 Shape `@export var <name>: int` properties have no `@export_range(min, max)` clauses.
Consumers (or accidental drag-in-inspector zero-out) can set:
- `focus_thickness = 0` → focus_ring stylebox renders with 0-width borders; PITFALLS 1.1
  ("focus indicator visible on all focusable controls") regression.
- `outline_width = -1` → `border_width_left = -1` is rejected by StyleBoxFlat; logs a warning
  and clamps. Bigger negative values produce undefined/clipped rendering.
- `corner_radius = -5` → invalid; corners render with engine clamp.
- `raised_strength = 0` → with `raised = true`, all "raised" styleboxes get `shadow_size = 0`
  (effectively flat), defeating the toggle.
- `spacing = 0` → content_margin_* collapse to tap_pad alone; OK on mobile but tight on
  desktop (densityScale=1.0 + spacing=0 + tap_pad=8 = 8px content-margin, no breathing room).

**Fix:**
```gdscript
@export_range(0, 64, 1) var corner_radius: int = 12: ...
@export_range(0, 32, 1) var spacing: int = 4: ...
@export_range(0, 16, 1) var raised_strength: int = 3: ...
@export_range(1, 8, 1) var focus_thickness: int = 2: ...   # min 1 — focus must be visible
@export_range(0, 8, 1) var outline_width: int = 1: ...
```
Choose ranges per DESIGN_TOKENS §4.1 / approved direction values; the suggested ranges
above bracket all 5 approved direction values plus reasonable consumer headroom.

---

### WR-04: `_phase4_verify.gd` mutates the `ResourceLoader.load()`-cached Theme (editor pollution)

**File:** `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_verify.gd:91-126, 132-141`

**Issue:**
`_verify_pulse()` does `theme.raised = true`, then later `theme.base_color = Color("#F0F0F0")`,
then `theme.platform = NeoCadeTheme.Platform.MOBILE` — mutating the in-memory cached Resource
returned by `ResourceLoader.load("res://addons/neocade_theme/pulse_neocade_theme.tres")`.
Godot's resource cache returns the same instance to every subsequent loader call until the
resource is explicitly reloaded or the editor restarts. After running this verify script via
File → Run, any other in-editor system that has a reference to pulse will see:
- `raised` toggled back to `false` at the end (lines 95, 106 reverts), but in between,
  another script reading the resource sees `raised = true`.
- `base_color` flipped to `#F0F0F0` and reverted to `#151A2E` — but if the verifier crashes
  between lines 102 and 106, pulse stays at `#F0F0F0` until editor restart.
- `platform` reverted to AUTO at line 126 — same crash-window risk.

The headless variant (`_phase4_verify_headless.gd`) is fine because the SceneTree exits and
the cache dies with the process.

**Fix:** clone before mutating, or reload after each test phase:
```gdscript
var theme: NeoCadeTheme = (loaded as NeoCadeTheme).duplicate(true)  # standalone copy
# ... run all mutation tests on the copy; original cached pulse stays clean.
```
Alternatively, push a try/finally pattern: snapshot `original_base_color = theme.base_color`
at the start, restore in a deferred guard.

---

### WR-05: Silent `null` return on missing icon SVG hides typos in `BINDING_TABLE` icon recipes

**File:** `addons/neocade_theme/neocade_theme.gd:1207-1213`

**Issue:**
```gdscript
var path: String = "res://addons/neocade_theme/icons/" + icon_name + ".svg"
var icon: Texture2D = load(path) as Texture2D
return icon
```
If `icon_name = "checkbtton_checked"` (typo) or the icon was renamed without a recipe sweep,
`load()` returns `null`, the cast remains `null`, the caller's `if value == null: continue`
skips the slot, and the engine default icon renders. No warning, no error. Same masking
problem as WR-01 but for icons.

**Fix:**
```gdscript
var icon: Texture2D = load(path) as Texture2D
if icon == null:
    push_error("BINDING_TABLE: missing icon SVG at %s (recipe: %s)" % [path, recipe])
    return null
return icon
```
Run the verify helpers; mismatches surface as editor errors.

---

### WR-06: Helper `_phase4_import.gd` uses regex `replace` whose substitution string is not escaped

**File:** `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_import.gd:65-73`

**Issue:**
```gdscript
mutated = pattern.sub(mutated, "%s=%s" % [k, required[k]])
```
`RegEx.sub()` in Godot 4.6 may interpret `$N` / `\N` as backreferences in the replacement
string (depending on flags). The values being substituted are simple ints/bools (`"1"`,
`"true"`), so no backreference char appears today — but a future addition of a value
containing `$` or `\` (e.g. a path) would silently corrupt the `.import` file. Defensive
escape is cheap.

Additional concern: the sub call is missing the `all` parameter. `RegEx.sub(text, repl)`
without explicit `all=true` replaces only the first match by default in Godot 4.6. With the
`(?m)^antialiasing=...$` pattern this is fine because each key only appears once, but the
appended-when-missing branch (line 73) uses plain `replace("[params]\n", ...)` which
substitutes only the first occurrence — also fine here, only one `[params]` in an `.import`.
Note in code is recommended.

**Fix:**
```gdscript
var safe_repl := "%s=%s" % [k, str(required[k]).c_escape()]
# Or simpler: explicitly escape regex meta in the value if any future change adds dynamic content.
mutated = pattern.sub(mutated, safe_repl, true)  # all=true; defensive
```

---

### WR-07: CheckButton ships only 2 of 8 icon slots — incomplete coverage versus SC#7 strict-read

**File:** `addons/neocade_theme/neocade_theme.gd:637-659, 446-455`

**Issue:**
Godot 4.6 CheckButton has 8 icon theme slots: `checked`, `unchecked`,
`checked_disabled`, `checked_disabled_mirrored`, `checked_mirrored`,
`unchecked_disabled`, `unchecked_disabled_mirrored`, `unchecked_mirrored`. Phase 4 ships
only `checked` and `unchecked`; the in-source comment (lines 446-451) acknowledges the gap
("the 6 disabled/mirrored variants are deferred to v1.x").

D-09 in 04-CONTEXT.md reads: "SC#7 (`ALL 37 Controls + 13 type variations populated`) is
read STRICTLY — every Control type has every required slot present." The 6 missing slots
mean disabled/RTL CheckButton renders with engine-default monochrome icons, breaking the
NeoCade visual identity for those states.

This is documented as deferred, but the `CANONICAL_SLOT_NAMES["CheckButton"]` array
(line 452-454) only lists the 2 shipped slots, so the verifier passes — i.e. the verifier
freezes incomplete coverage as canonical. If Phase 5/6/7 reads this freeze as the
ground-truth "what we ship", the missing 6 slots will never be added.

**Fix:** add the 6 deferred slots to `CANONICAL_SLOT_NAMES["CheckButton"]["icon"]` as a
TODO marker, OR add a v1.x backlog item explicitly to ROADMAP.md or CHANGELOG.md
"Documented limitations" so Phase 11 can refer:
```gdscript
"CheckButton": {
    "icon": ["checked", "unchecked"],  # v1.0 ships base 2; disabled/mirrored deferred to v1.x
    # TODO(v1.x): "checked_disabled", "checked_disabled_mirrored", "checked_mirrored",
    #             "unchecked_disabled", "unchecked_disabled_mirrored", "unchecked_mirrored"
    ...
}
```
Same audit needed for Button's `_mirrored` slot family (line 432-433 mentions 12 styleboxes
upstream vs the 6 NeoCade ships).

---

### WR-08: `_init() -> void: _regenerate_theme()` fires 7-9× during `.tres` deserialization

**File:** `addons/neocade_theme/neocade_theme.gd:88-89`

**Issue:**
When loading any direction `.tres`, Godot:
1. Constructs the resource → `_init()` runs → `_regenerate_theme()` call 1 (with all-default values).
2. Deserializes each `@export` property → each setter that detects a change calls
   `_regenerate_theme()` again.

For Pulse, that's: `base_color` (changed → call 2), `accent_color` (changed → call 3),
`raised` (false → equals default → short-circuit), `platform` (AUTO → equals default →
short-circuit), `corner_radius` (0 → vs default 12 → call 4), `spacing` (18 → vs 4 →
call 5), `raised_strength` (3 → equals default → short-circuit), `focus_thickness` (2 →
equals default → short-circuit), `outline_width` (1 → equals default → short-circuit). Total:
**5 regenerations** for Pulse on cold load. For directions with all 7 non-default exports,
up to 8 regenerations.

Each regeneration walks the 37-row × 5-data-type BINDING_TABLE and instantiates ~150
StyleBoxFlat resources, runs 5+ `preload()` calls, etc. On `.tres` load the 5 wasted
regenerations are throwaway garbage.

The reentry `_regenerating` guard prevents recursion, but does NOT debounce inter-setter
calls during deserialization.

**Fix:** defer the regeneration to a single post-load pass. Pattern:
```gdscript
var _pending_regen: bool = false

func _regenerate_theme() -> void:
    if Engine.is_editor_hint() or not is_inside_tree():
        # editor or pre-tree: schedule a deferred regen; coalesce multiple setter
        # calls into one.
        if not _pending_regen:
            _pending_regen = true
            call_deferred("_do_regenerate")
        return
    _do_regenerate()

func _do_regenerate() -> void:
    _pending_regen = false
    if _regenerating: return
    _regenerating = true
    # ... existing body ...
```
Or simpler: in `_init()`, set a `_loading: bool = true` flag, skip regenerate while true,
and clear the flag in a `call_deferred` at the end of `_init`. Loaders complete property
deserialization before deferred runs.

---

### WR-09: Setters check `==` on `Color` and `enum Platform` — Color equality is float-strict; Platform.AUTO short-circuit may starve auto-detect refresh

**File:** `addons/neocade_theme/neocade_theme.gd:27-48`

**Issue (a) — Color equality:**
`if base_color == value: return` uses Godot's `Color.operator==` which is exact float
equality. If a consumer programmatically sets `base_color = Color(0.0823529, 0.101961,
0.180392, 1)` (the Pulse value already in the .tres), the comparison may fail due to
serialization round-trip imprecision (e.g. an extra digit of precision in the assignment),
triggering an unnecessary regeneration. Conversely, two near-identical colors that visually
look the same but differ in 1e-7 will both regenerate.

**Issue (b) — Platform enum short-circuit:**
Setting `platform = Platform.AUTO` when it already IS `AUTO` short-circuits. But
`_resolve_platform()` reads `OS.has_feature("mobile")` at every regenerate. If the consumer
has `platform = AUTO` set, then later wants to FORCE a regenerate (e.g. they hot-reloaded
or know the platform feature changed), they cannot — the assignment short-circuits because
the value didn't change. There's no public `regenerate()` method to force a fresh pass.

**Fix:**
- For (a): document that floating-point Color equality is the equality contract, OR widen
  to a tolerance compare (`base_color.is_equal_approx(value)`).
- For (b): add a public `regenerate() -> void: _regenerate_theme()` so consumers / verify
  helpers can force a refresh without a sentinel value swap.
```gdscript
## Force a regeneration pass even if no @export changed (e.g. after platform feature flip).
func regenerate() -> void:
    _regenerate_theme()
```
(Helpers `_phase4_verify.gd:117-126` and `_phase4_verify_headless.gd:83-91` are already
forced to swap-and-restore platform values to trigger regenerate; a public `regenerate()`
makes the test cleaner and removes the cache-pollution risk in WR-04.)

---

### WR-10: `tokens` Dictionary is loosely typed — `tokens.body` returns `Variant`, no compile-time guard against typos

**File:** `addons/neocade_theme/neocade_theme.gd:166, 196-207, 1181-1182, 1203-1205`

**Issue:**
`tokens` is a `Dictionary` returned from `_platform_tokens()`. Access patterns:
- `default_font_size = tokens.body` — `tokens` is Variant-typed dictionary access; if a key
  is renamed (e.g. `body` → `bodySize`), the GDScript parser does NOT error at compile-time;
  a runtime "Invalid get index" is the failure mode.
- `tokens.label_` (note trailing underscore — line 199, 200) — the underscore-suffix is a
  visible code smell. `label` is not a GDScript keyword nor a built-in identifier; the
  trailing `_` was likely workaround for a different concern that no longer exists.
- The dotted access in 1181-1182 (`tokens.get("densityScale", 1.0)`) defends with a default,
  but elsewhere (lines 196-207) the bare `tokens.body` etc. doesn't.

**Fix:**
- Either type the platform-tokens table as a `class PlatformTokens extends RefCounted` with
  typed `var body: int` etc. (compile-time-checked), OR
- Replace bare `tokens.body` with `tokens.get("body", 14)` defensively, OR
- Rename `tokens.label_` → `tokens.label` (no GDScript collision) for symmetry. Search-and-
  replace across the file. INFO-tier on its own; bundled here because it shares the
  loose-typing root cause.

---

### WR-11: Editor-time `_regenerate_theme()` reads `OS.has_feature("mobile")` returning the *editor's* platform, not the export target's

**File:** `addons/neocade_theme/neocade_theme.gd:284-287`

**Issue:**
With `@tool` scripts, `_regenerate_theme()` runs in the editor when an `@export` setter
fires. `_resolve_platform()` calls `OS.has_feature("mobile")`, which on the editor running
on a Windows desktop returns `false`. So `platform = AUTO` resolves to `DESKTOP` in editor,
even when the consumer's project will export to iOS/Android.

The serialized `.tres` does NOT bake the resolved platform — only the unresolved `platform =
2` (AUTO) value is saved. At runtime on the target device, the `_init()`/setter chain
re-runs and `_resolve_platform()` correctly returns MOBILE. So shipped behavior is right.

But editor preview is wrong: a designer authoring the showcase scene with `Platform.AUTO`
sees DESKTOP-sized buttons, never MOBILE, even when previewing for a mobile target. There
is no in-editor way to test the MOBILE branch without manually setting `platform = MOBILE`
on each `.tres`. Phase 9 showcase would benefit from a "preview platform" toggle on
NeoCadeTheme, but this is also a foot-gun for current `@tool` design feedback — easy to
miss tap-target regressions in editor.

**Fix:** document the editor-vs-runtime divergence in the README ("AUTO resolves to the
editor's platform when previewing in editor; force `MOBILE`/`DESKTOP` to test the other
branch"). Optionally add a debug `@export var preview_platform_override: Platform = AUTO`
that takes precedence in editor only, so the showcase scene can flip without touching
exports. Defer to Phase 8 (mobile design) or Phase 9 (showcase).

---

## Info Issues

### IN-01: `Inter-Body.tres` and `Inter-Caption.tres` are byte-identical FontVariation files (both `wght=400`, no `opsz`)

**File:** `addons/neocade_theme/fonts/Inter-Body.tres`, `addons/neocade_theme/fonts/Inter-Caption.tres`

**Issue:** Both files set `variation_opentype = {"wght": 400}` and reference the same
`base_font`. They differ only in filename. Two preload entries, two `.import` UID
allocations, identical runtime behavior.

**Fix:** drop one and have `set_font("font", "Caption", body_font)` reuse the body variation
— OR if a future `Caption` variant should differ (e.g. opsz=14, slightly heavier weight per
M3 caption guidance), update the helper at `_phase4_import.gd:101` and re-run. Document the
intent in code so the duplication isn't accidentally consolidated later.

---

### IN-02: `tokens.label_` trailing underscore is a leftover

**File:** `addons/neocade_theme/neocade_theme.gd:199, 200, 300, 318`

**Issue:** The trailing `_` on `label_` reads as a parser-collision workaround. `label` is
not a reserved GDScript identifier. The four call sites (token-dict definition + read sites)
should be renamed.

**Fix:** rename `"label_"` → `"label"` in `_platform_tokens()` + usage sites. No behavioral
change.

---

### IN-03: Hard-coded addon path `"res://addons/neocade_theme/icons/"` in `_resolve_recipe`

**File:** `addons/neocade_theme/neocade_theme.gd:1211`

**Issue:** If a downstream consumer relocates the addon (rare but legal — e.g. flat-bundling
into `res://lib/themes/`), the hardcoded literal breaks icon load. CONST extraction makes
the dependency explicit.

**Fix:**
```gdscript
const ICONS_DIR := "res://addons/neocade_theme/icons/"
# ...
var path: String = ICONS_DIR + icon_name + ".svg"
```

---

### IN-04: `load()` per-icon-recipe per-regenerate; preload cache is fine but explicit preload reads better

**File:** `addons/neocade_theme/neocade_theme.gd:1212`

**Issue:** Every `_regenerate_theme()` call re-resolves icons via `load()`. Godot caches the
loaded resource, so the second+ call is fast. But the call sites are scattered (~10 distinct
icons across PopupMenu/CheckBox/OptionButton/LineEdit/Button), each `load()` happens once
per regenerate. Out of v1 scope (perf) but worth a `preload(...)` const block to make the
dependencies grep-able.

**Fix:** add at file head (after const TYPE_VARIATIONS):
```gdscript
const ICON_CHECKBOX_CHECKED := preload("res://addons/neocade_theme/icons/checkbox_checked.svg")
const ICON_CHECKBOX_UNCHECKED := preload("res://addons/neocade_theme/icons/checkbox_unchecked.svg")
# ... etc, 10 entries.
```
Then `_resolve_recipe` for icons looks them up by name. Bonus: Godot's static-analysis
flags missing icons at compile time, addressing WR-05 too.

---

### IN-05: `_last_regeneration_usec` measured but never logged

**File:** `addons/neocade_theme/neocade_theme.gd:86, 94, 259`

**Issue:** The diagnostic is captured (line 259) and documented (line 86 comment "logged via
Output in editor") but no `print()` exists. The variable can be read by external tooling, but
the comment is misleading.

**Fix:** either add the editor-only log:
```gdscript
if Engine.is_editor_hint():
    print("[NeoCadeTheme] regenerate: %d µs" % _last_regeneration_usec)
```
or remove the misleading comment.

---

### IN-06: Variable shadowing within `_resolve_recipe` (separate branches but lint-noise)

**File:** `addons/neocade_theme/neocade_theme.gd:1134, 1191`

**Issue:** `var role: String` declared in the stylebox branch (1134) AND the color branch
(1191). They are in disjoint `if`/`elif` branches so no actual shadowing at runtime, but the
GDScript Editor flags `var role` re-declaration in the same function as a "variable already
defined in this scope" warning depending on parser strictness.

**Fix:** declare `var role: String` once at the top of the function (or rename one of them).
INFO-tier; cosmetic only.

---

_Reviewed: 2026-05-06T17:44:39Z_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
