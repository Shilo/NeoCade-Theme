---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 04
type: execute
wave: 2
depends_on:
  - "04-01"
files_modified:
  - addons/neocade_theme/neocade_theme.gd
autonomous: true
requirements:
  - TOKEN-01
  - TOKEN-02
  - TOKEN-03
  - TOKEN-06
  - TOKEN-08
  - TOKEN-09
must_haves:
  truths:
    - "`addons/neocade_theme/neocade_theme.gd` implements `_mix(a: Color, b: Color, amount: float) -> Color` (linear RGB lerp) per DESIGN_TOKENS §6.1."
    - "`addons/neocade_theme/neocade_theme.gd` implements `_tint_toward_base(element: Color, base_c: Color, ratio: float = 0.40) -> Color` per DESIGN_TOKENS §6.1."
    - "`_regenerate_theme()` derives the 5-stop surface ramp (`surface_base`, `surface_low`, `surface_panel`, `surface_high`, `surface_overlay`) + `outline_color` per DESIGN_TOKENS §6.2 with `elevate_target = Color.BLACK if is_light else Color.WHITE` and `surface_low` always mixing toward BLACK regardless of `is_light`."
    - "`_regenerate_theme()` derives the 5 raised offset tokens (`accent_offset`, `surface_high_offset`, `surface_panel_offset`, `surface_overlay_offset`, `surface_low_offset`) via `_tint_toward_base(...)` per DESIGN_TOKENS §6.3."
    - "`_regenerate_theme()` derives `text_strong`, `text_default`, `text_muted` with the `is_light` branch values per DESIGN_TOKENS §6.4 (`#1B2230` / `#5A6478` for light; `#F7F8FB` / `#B9C1D0` for dark)."
    - "`_regenerate_theme()` derives `state_hover` and `state_pressed` per DESIGN_TOKENS §6.5; `state_hover` flips target with `is_light`; `state_pressed` always mixes toward BLACK."
    - "Helper `_make_raised_stylebox(bg: Color, offset_color: Color, raised_intensity: int) -> StyleBoxFlat` exists; sets `shadow_color = offset_color`, `shadow_size = raised_intensity` (or `-1` when `raised=false`), `shadow_offset = Vector2(0, raised_intensity)` (or `Vector2.ZERO` when flat)."
    - "Helper `_resolve_platform() -> Platform` resolves `Platform.AUTO` to MOBILE/DESKTOP via `OS.has_feature(\"mobile\")` per DESIGN_TOKENS §10.2."
    - "Helper `_platform_tokens(p: Platform) -> Dictionary` returns the 14 platform tokens (buttonMin, primaryButtonMin, inputMin, toggleMin, checkboxSize, body, label_, h1, h2, kicker, rowMin, tabMin, tapPadding, densityScale) per DESIGN_TOKENS §10.1 with the correct desktop/mobile values."
    - "Role token derivation populates `role.primary` from `accent_color`, plus `accent_rim = _mix(accent_color, Color.WHITE, 0.5)`."
    - "No `clear()` call anywhere in the regeneration path (D-01 invariant preserved from Plan 04-01)."
  artifacts:
    - addons/neocade_theme/neocade_theme.gd (formula helpers + role/state derivation added; entry population still empty for Plan 04-05)
  key_links:
    - ".planning/DESIGN_TOKENS.md §6, §7, §9.2, §10.1, §10.2"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md D-14 step 5"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md §1, §8"
    - ".planning/mockups/3.4/src/neocade-mockups.js (renderer formulas — port verbatim)"
---

<objective>
Port the renderer's color/derivation formulas + state-layer model + raised-stylebox helper + platform branch into `addons/neocade_theme/neocade_theme.gd` as private helper functions, and wire `_regenerate_theme()` to compute the per-call derivation block (surface ramp + offsets + text colors + state layers + role tokens) BEFORE Plan 04-05 walks the BINDING_TABLE.

Purpose: feed the entry-population pass (Plan 04-05) all the precomputed colors it needs to populate every theme entry without duplicating math per-Control.
Output: `addons/neocade_theme/neocade_theme.gd` extended with ~80-150 lines of formula helpers + a populated derivation block in `_regenerate_theme()`.
</objective>

<execution_context>
@$HOME/.codex/get-shit-done/workflows/execute-plan.md
@$HOME/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/DESIGN_TOKENS.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md
@.planning/mockups/3.4/src/neocade-mockups.js
@.planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd
@addons/neocade_theme/neocade_theme.gd

<interfaces>
The class shell from Plan 04-01 has the 9 `@export` properties, the Platform enum, the `is_light` field, the `_regenerating` reentry guard, and an empty `_regenerate_theme()` skeleton. This plan extends that file by:
1. Adding private helper methods (`_mix`, `_tint_toward_base`, `_resolve_platform`, `_platform_tokens`, `_make_raised_stylebox`).
2. Adding the derivation block at the top of `_regenerate_theme()` that computes surface ramp + offsets + text colors + state layers + role tokens.
3. Storing the derived values as locals (or as private fields if Plan 04-05 needs them across helper calls) for Plan 04-05's BINDING_TABLE walk.

Plan 04-05 then uses these locals to populate Theme entries via the BINDING_TABLE walk.

Wave 2 — depends on Plan 04-01 only. Parallel-eligible with Plan 04-05 if 04-05 finishes its BINDING_TABLE design without needing 04-04's helpers; otherwise sequential.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Add color helpers _mix and _tint_toward_base to neocade_theme.gd</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd (current state from Plan 04-01)
    - .planning/DESIGN_TOKENS.md (§6.1 — color helpers)
    - .planning/mockups/3.4/src/neocade-mockups.js
  </read_first>
  <files>
    - addons/neocade_theme/neocade_theme.gd (modify — append helpers)
  </files>
  <action>
    Append the following helper methods to `addons/neocade_theme/neocade_theme.gd`, BELOW the existing `_regenerate_theme()` skeleton. These are the canonical port of the renderer's `hexToRgb` + `rgbToHex` mix pipeline + `tintTowardBase`.

    ```gdscript

    # ─── Color helpers (DESIGN_TOKENS §6.1) ─────────────────────────────────────────────────────

    ## Linear RGB lerp matching the renderer's `lerp(a, b, t)` in `neocade-mockups.js`.
    func _mix(a: Color, b: Color, amount: float) -> Color:
        return Color(
            a.r + (b.r - a.r) * amount,
            a.g + (b.g - a.g) * amount,
            a.b + (b.b - a.b) * amount,
            1.0
        )

    ## Element shifted partway toward `base_c` — preserves hue at every brightness, replacing the
    ## HSL-darken-floored-at-0 antipattern. Default ratio 0.40 per MOCKUP-REVISION-3-HANDOFF.md.
    func _tint_toward_base(element: Color, base_c: Color, ratio: float = 0.40) -> Color:
        return _mix(element, base_c, ratio)
    ```

    Implementation note: place these AFTER the `_regenerate_theme()` body. Use `func` (not `static func`) — the methods read no instance state but stay on the instance for clarity + future extensibility (per-direction overrides could subclass and override; not in v1, but cheap to allow).
  </action>
  <acceptance_criteria>
    - File `addons/neocade_theme/neocade_theme.gd` contains a `func _mix(a: Color, b: Color, amount: float) -> Color:` declaration.
    - File contains a `func _tint_toward_base(element: Color, base_c: Color, ratio: float = 0.40) -> Color:` declaration.
    - The body of `_mix` uses `a.r + (b.r - a.r) * amount` (or equivalent — `lerp(a.r, b.r, amount)` is also acceptable).
    - The body of `_tint_toward_base` calls `_mix(element, base_c, ratio)`.
    - The default value `0.40` (or `0.4`) appears in `_tint_toward_base`'s signature.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; foreach($n in 'func _mix(a: Color, b: Color, amount: float) -> Color:','func _tint_toward_base(element: Color, base_c: Color, ratio: float = 0.40) -> Color:','_mix(element, base_c, ratio)') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }; if (-not (($g -match 'a.r \+ \(b.r - a.r\) \* amount') -or ($g -match 'lerp\\(a.r, b.r, amount\\)'))) { throw 'mix body missing valid lerp implementation' }"
    </automated>
  </verify>
  <done>The two color helpers are defined and ready for the derivation block to consume.</done>
</task>

<task type="auto">
  <name>Task 2: Add platform helpers _resolve_platform and _platform_tokens</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd
    - .planning/DESIGN_TOKENS.md (§10.1, §10.2)
    - .planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd (for the AUTO resolution pattern; web platform branch handling)
  </read_first>
  <files>
    - addons/neocade_theme/neocade_theme.gd (modify — append helpers)
  </files>
  <action>
    Append two more helpers below the color helpers from Task 1:

    ```gdscript

    # ─── Platform helpers (DESIGN_TOKENS §10.1, §10.2) ──────────────────────────────────────────

    ## Resolve `Platform.AUTO` to MOBILE or DESKTOP via Godot's feature flags.
    ## DESKTOP / MOBILE are forced and bypass detection.
    func _resolve_platform() -> Platform:
        if platform == Platform.AUTO:
            return Platform.MOBILE if OS.has_feature("mobile") else Platform.DESKTOP
        return platform

    ## Returns the 14-key platform-tokens table for the given resolved Platform per DESIGN_TOKENS §10.1.
    ## The return is a Dictionary so Plan 04-05's BINDING_TABLE walk can read tokens by string key.
    func _platform_tokens(p: Platform) -> Dictionary:
        if p == Platform.MOBILE:
            return {
                "buttonMin": 48,
                "primaryButtonMin": 56,
                "inputMin": 56,
                "toggleMin": 32,
                "checkboxSize": 20,
                "body": 16,
                "label_": 14,
                "h1": 32,
                "h2": 22,
                "kicker": 13,
                "rowMin": 56,
                "tabMin": 48,
                "tapPadding": 12,
                "densityScale": 1.5,
            }
        return {  # DESKTOP (or AUTO that resolved to DESKTOP)
            "buttonMin": 36,
            "primaryButtonMin": 44,
            "inputMin": 34,
            "toggleMin": 22,
            "checkboxSize": 18,
            "body": 14,
            "label_": 12,
            "h1": 36,
            "h2": 22,
            "kicker": 12,
            "rowMin": 36,
            "tabMin": 32,
            "tapPadding": 8,
            "densityScale": 1.0,
        }
    ```
  </action>
  <acceptance_criteria>
    - File contains `func _resolve_platform() -> Platform:`.
    - The body of `_resolve_platform` contains `OS.has_feature("mobile")`.
    - The body of `_resolve_platform` checks `platform == Platform.AUTO`.
    - File contains `func _platform_tokens(p: Platform) -> Dictionary:`.
    - The MOBILE branch contains the literal strings: `"buttonMin": 48`, `"primaryButtonMin": 56`, `"inputMin": 56`, `"toggleMin": 32`, `"checkboxSize": 20`, `"body": 16`, `"rowMin": 56`, `"tabMin": 48`, `"tapPadding": 12`, `"densityScale": 1.5`.
    - The DESKTOP branch contains the literal strings: `"buttonMin": 36`, `"primaryButtonMin": 44`, `"inputMin": 34`, `"toggleMin": 22`, `"checkboxSize": 18`, `"body": 14`, `"rowMin": 36`, `"tabMin": 32`, `"tapPadding": 8`, `"densityScale": 1.0`.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; foreach($n in 'func _resolve_platform() -> Platform:','OS.has_feature(\"mobile\")','platform == Platform.AUTO','func _platform_tokens(p: Platform) -> Dictionary:','\"buttonMin\": 48','\"primaryButtonMin\": 56','\"inputMin\": 56','\"toggleMin\": 32','\"checkboxSize\": 20','\"body\": 16','\"rowMin\": 56','\"tabMin\": 48','\"tapPadding\": 12','\"densityScale\": 1.5','\"buttonMin\": 36','\"primaryButtonMin\": 44','\"inputMin\": 34','\"toggleMin\": 22','\"checkboxSize\": 18','\"body\": 14','\"rowMin\": 36','\"tabMin\": 32','\"tapPadding\": 8','\"densityScale\": 1.0') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }"
    </automated>
  </verify>
  <done>Platform resolution and per-platform token table are in place; mobile and desktop variants render with correct sizing.</done>
</task>

<task type="auto">
  <name>Task 3: Add raised-stylebox helper _make_raised_stylebox</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd
    - .planning/DESIGN_TOKENS.md (§9.1, §9.2 — raised contract)
  </read_first>
  <files>
    - addons/neocade_theme/neocade_theme.gd (modify — append helper)
  </files>
  <action>
    Append the raised-stylebox helper below `_platform_tokens`:

    ```gdscript

    # ─── Raised stylebox helper (DESIGN_TOKENS §9) ──────────────────────────────────────────────

    ## Construct a StyleBoxFlat configured for flat or raised mode based on `raised` + `intensity`.
    ##
    ## - `raised = false`: shadow_size = -1 (Godot's "no shadow" sentinel per #98162); shadow_offset = ZERO.
    ## - `raised = true`: shadow_color = offset_color, shadow_size = intensity, shadow_offset = (0, intensity).
    ##   Hard offset, no blur — the extruded-flat 3D primitive (per FLAT-3D-UI-RESEARCH.md).
    ##
    ## Caller is responsible for setting bg_color + corner_radius_* + border_width_* + content_margin_*
    ## per the Control's slot semantics.
    func _make_raised_stylebox(bg: Color, offset_color: Color, intensity: int) -> StyleBoxFlat:
        var sb := StyleBoxFlat.new()
        sb.bg_color = bg
        if raised:
            sb.shadow_color = offset_color
            sb.shadow_size = intensity
            sb.shadow_offset = Vector2(0, intensity)
        else:
            sb.shadow_size = -1
            sb.shadow_offset = Vector2.ZERO
        return sb
    ```

    Notes:
    - The helper does NOT set corner_radius / border_width / margins — those are Control-specific and Plan 04-05 sets them per binding-table entry.
    - The `raised = false` branch uses `shadow_size = -1` per Godot #98162 + TOKEN-08 + SUMMARY Conflict 3 (no drop shadows in v1).
    - Per `intensity` parameter: callers pass `raised_strength * <family-multiplier>` per DESIGN_TOKENS §9.3 (e.g., panel = `raised_strength * 1.0`, slider grabber = `raised_strength * 0.5`).
  </action>
  <acceptance_criteria>
    - File contains `func _make_raised_stylebox(bg: Color, offset_color: Color, intensity: int) -> StyleBoxFlat:`.
    - The body contains `var sb := StyleBoxFlat.new()` (or equivalent).
    - The body contains `sb.bg_color = bg`.
    - The body contains `sb.shadow_size = -1` (the flat-mode branch).
    - The body contains `sb.shadow_size = intensity` (the raised-mode branch).
    - The body contains `sb.shadow_offset = Vector2(0, intensity)`.
    - The body contains `sb.shadow_color = offset_color`.
    - The body's flat branch sets `sb.shadow_offset = Vector2.ZERO`.
    - The body uses `if raised:` to branch.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; foreach($n in 'func _make_raised_stylebox(bg: Color, offset_color: Color, intensity: int) -> StyleBoxFlat:','StyleBoxFlat.new()','sb.bg_color = bg','sb.shadow_size = -1','sb.shadow_size = intensity','sb.shadow_offset = Vector2(0, intensity)','sb.shadow_color = offset_color','sb.shadow_offset = Vector2.ZERO','if raised:') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }"
    </automated>
  </verify>
  <done>Raised-stylebox primitive helper is in place; all subsequent entry construction can use it.</done>
</task>

<task type="auto">
  <name>Task 4: Wire derivation block into _regenerate_theme() body</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd
    - .planning/DESIGN_TOKENS.md (§6.2, §6.3, §6.4, §6.5, §7.1)
  </read_first>
  <files>
    - addons/neocade_theme/neocade_theme.gd (modify — extend _regenerate_theme body)
  </files>
  <action>
    Replace the `_regenerate_theme()` skeleton body from Plan 04-01 with a fuller version that computes the derivation block. The replacement preserves: the reentry guard, the `is_light` derivation, the no-`clear()` invariant. It adds: a fixed `spread_factor` placeholder (Plan 04-05 will replace with per-direction lookup or fold-into-binding-table), the 5-stop ramp, the 5 raised offset tokens, text colors with `is_light` flip, state layers, role tokens.

    The new body:

    ```gdscript
    func _regenerate_theme() -> void:
        if _regenerating: return
        _regenerating = true
        var t0 := Time.get_ticks_usec()

        is_light = base_color.get_luminance() >= 0.5
        var p: Platform = _resolve_platform()
        var tokens: Dictionary = _platform_tokens(p)

        # ── Surface ramp (DESIGN_TOKENS §6.2) ──
        # spread_factor is the per-direction surface-ramp width control. Plan 04-05 will source this
        # per-direction (Pulse=1.3 wide, Slate=0.7 narrow, Bubble=1.0 medium, Daybreak=1.0 medium,
        # Burst=1.3 wide). For now, derive a sensible default from `spacing` so the engine is
        # functional without per-direction lookup; Plan 04-05 supersedes this.
        var spread_factor: float = 1.0
        var elevate_target: Color = Color.BLACK if is_light else Color.WHITE

        var surface_base: Color    = base_color
        var surface_low: Color     = _mix(base_color, Color.BLACK, 0.18 * spread_factor)
        var surface_panel: Color   = _mix(base_color, elevate_target, 0.06 * spread_factor)
        var surface_high: Color    = _mix(base_color, elevate_target, 0.13 * spread_factor)
        var surface_overlay: Color = _mix(base_color, elevate_target, 0.20 * spread_factor)
        var outline_color: Color   = _mix(base_color, elevate_target, 0.24 * spread_factor)

        # ── Per-color tinted offsets for raised mode (DESIGN_TOKENS §6.3) ──
        var accent_offset: Color          = _tint_toward_base(accent_color, base_color)
        var surface_high_offset: Color    = _tint_toward_base(surface_high, base_color)
        var surface_panel_offset: Color   = _tint_toward_base(surface_panel, base_color)
        var surface_overlay_offset: Color = _tint_toward_base(surface_overlay, base_color)
        var surface_low_offset: Color     = _tint_toward_base(surface_low, base_color)

        # ── Text colors with is_light flip (DESIGN_TOKENS §6.4) ──
        var text_strong: Color
        var text_default: Color
        var text_muted: Color
        if is_light:
            text_strong  = Color("#1B2230")
            text_default = Color("#1B2230")
            text_muted   = Color("#5A6478")
        else:
            text_strong  = Color("#F7F8FB")
            text_default = Color("#F7F8FB")
            text_muted   = Color("#B9C1D0")

        # ── State-layer overlays (DESIGN_TOKENS §6.5) ──
        # Per-direction hover_pct / pressed_pct / disabled_opacity come from the .tres or BINDING_TABLE
        # in Plan 04-05; for now, use M3 baseline 8% / 12% / 0.38 per TOKEN-09.
        var hover_pct: float = 8.0
        var pressed_pct: float = 12.0
        var disabled_opacity: float = 0.38
        var state_hover_target: Color = Color.BLACK if is_light else Color.WHITE
        var state_hover: Color = _mix(base_color, state_hover_target, hover_pct / 100.0)
        var state_pressed: Color = _mix(base_color, Color.BLACK, pressed_pct / 100.0)

        # ── Role tokens (DESIGN_TOKENS §7.1) ──
        var role_primary: Color = accent_color
        var accent_rim: Color = _mix(accent_color, Color.WHITE, 0.5)

        # ── BINDING_TABLE walk lands here (Plan 04-05). ──
        # The locals above are the precomputed inputs every entry-population path consumes.
        # NO `clear()` permitted; iteration is additive only (D-01).

        _last_regeneration_usec = Time.get_ticks_usec() - t0
        _regenerating = false
    ```

    Important: the existing skeleton from Plan 04-01 already has the reentry guard + `is_light` derivation. This task REPLACES the body between `is_light = base_color.get_luminance() >= 0.5` and `_last_regeneration_usec = Time.get_ticks_usec() - t0` with the full derivation block. The `_regenerating = false` and `_last_regeneration_usec` lines stay at the end.

    NOTE on `spread_factor`, `hover_pct`, `pressed_pct`, `disabled_opacity`: these are intentionally hard-coded to sensible defaults in this plan. Plan 04-05 supersedes them with per-direction values via the BINDING_TABLE or by reading direction metadata. The current values let the engine be functional + verifiable (a freshly-loaded `pulse_neocade_theme.tres` produces non-empty derived colors immediately) without coupling Plan 04-04 to Plan 04-05's BINDING_TABLE design.
  </action>
  <acceptance_criteria>
    - `_regenerate_theme()` body contains `var spread_factor: float = 1.0`.
    - Body contains `var elevate_target: Color = Color.BLACK if is_light else Color.WHITE`.
    - Body contains `var surface_base: Color    = base_color` (literal — derivation start).
    - Body contains `var surface_low: Color     = _mix(base_color, Color.BLACK, 0.18 * spread_factor)`.
    - Body contains `var surface_panel: Color   = _mix(base_color, elevate_target, 0.06 * spread_factor)`.
    - Body contains `var surface_high: Color    = _mix(base_color, elevate_target, 0.13 * spread_factor)`.
    - Body contains `var surface_overlay: Color = _mix(base_color, elevate_target, 0.20 * spread_factor)`.
    - Body contains `var outline_color: Color   = _mix(base_color, elevate_target, 0.24 * spread_factor)`.
    - Body contains `var accent_offset: Color          = _tint_toward_base(accent_color, base_color)`.
    - Body contains `var surface_panel_offset: Color   = _tint_toward_base(surface_panel, base_color)`.
    - Body contains `if is_light:` (the text-color branch).
    - Body contains both `Color("#1B2230")` and `Color("#F7F8FB")` (the is_light text branch values).
    - Body contains `var role_primary: Color = accent_color`.
    - Body contains `var accent_rim: Color = _mix(accent_color, Color.WHITE, 0.5)`.
    - Body contains `var state_hover: Color = _mix(base_color, state_hover_target, hover_pct / 100.0)`.
    - Body contains `var state_pressed: Color = _mix(base_color, Color.BLACK, pressed_pct / 100.0)`.
    - The string `clear()` does NOT appear anywhere in `neocade_theme.gd` (D-01 invariant).
    - The reentry-guard structure (`if _regenerating: return`, `_regenerating = true`, `_regenerating = false`) is preserved from Plan 04-01.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; $g=Get-Content -Raw $p; foreach($n in 'var spread_factor: float = 1.0','var elevate_target: Color = Color.BLACK if is_light else Color.WHITE','var surface_base: Color','var surface_low: Color','_mix(base_color, Color.BLACK, 0.18 * spread_factor)','_mix(base_color, elevate_target, 0.06 * spread_factor)','_mix(base_color, elevate_target, 0.13 * spread_factor)','_mix(base_color, elevate_target, 0.20 * spread_factor)','_mix(base_color, elevate_target, 0.24 * spread_factor)','_tint_toward_base(accent_color, base_color)','_tint_toward_base(surface_panel, base_color)','if is_light:','Color(\"#1B2230\")','Color(\"#F7F8FB\")','var role_primary: Color = accent_color','_mix(accent_color, Color.WHITE, 0.5)','_mix(base_color, state_hover_target, hover_pct / 100.0)','_mix(base_color, Color.BLACK, pressed_pct / 100.0)','if _regenerating: return','_regenerating = true','_regenerating = false') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }; if ($g -match '\\bclear\\(\\)') { throw 'clear() call found — D-01 forbids' }"
    </automated>
  </verify>
  <done>The full derivation block lives in `_regenerate_theme()` body. Plan 04-05 walks the BINDING_TABLE consuming these locals; no Control-specific math is duplicated.</done>
</task>

<task type="auto">
  <name>Task 5: Atomic commit — color formulas + role tokens + helpers</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd
  </read_first>
  <files>(commit only)</files>
  <action>
    Stage `addons/neocade_theme/neocade_theme.gd` and commit:

    ```
    feat(04-04): port color formulas + role tokens + raised helper + platform branch

    Plan 04-04 wave-2 formulas (depends on Plan 04-01 class shell):
    - Helpers: _mix, _tint_toward_base (DESIGN_TOKENS §6.1)
    - Helpers: _resolve_platform, _platform_tokens (DESIGN_TOKENS §10.1, §10.2)
    - Helper: _make_raised_stylebox (DESIGN_TOKENS §9)
    - _regenerate_theme() body now derives: 5-stop surface ramp + 5 raised offsets +
      text colors (is_light flip) + state layers + role tokens (accent_rim).
    - is_light = base_color.get_luminance() >= 0.5; surface_low always mixes toward
      BLACK; elevated tier flips target on is_light.
    - Hard-coded spread_factor / hover_pct / pressed_pct / disabled_opacity defaults
      will be superseded per-direction by Plan 04-05 BINDING_TABLE.
    - D-01 invariant preserved: no clear() anywhere in regeneration path.

    Refs: TOKEN-01, TOKEN-02, TOKEN-03, TOKEN-08, TOKEN-09
    Plan: 04-04
    ```

    `git add addons/neocade_theme/neocade_theme.gd`; `git commit -m "..."`. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-04):`.
    - `git log -1 --name-status` shows `M addons/neocade_theme/neocade_theme.gd`.
    - `git status --porcelain` is empty for `addons/neocade_theme/neocade_theme.gd`.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-04\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; if ($ns -notmatch 'M\\s+addons/neocade_theme/neocade_theme\\.gd') { throw 'commit missing neocade_theme.gd modification' }; $st = git status --porcelain | Where-Object { $_ -match 'addons/neocade_theme/neocade_theme\\.gd' }; if ($st) { throw 'unexpected leftover changes' }"
    </automated>
  </verify>
  <done>Color formulas + role tokens + platform helpers + raised helper land as a single atomic Wave 2 commit.</done>
</task>

</tasks>
