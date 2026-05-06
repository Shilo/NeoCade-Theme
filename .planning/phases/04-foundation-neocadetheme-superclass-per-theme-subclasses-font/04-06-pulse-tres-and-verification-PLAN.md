---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 06
type: execute
wave: 3
depends_on:
  - "04-04"
  - "04-05"
files_modified:
  - addons/neocade_theme/pulse_neocade_theme.tres
  - addons/neocade_theme/_phase4_import.gd  # extended with _save_pulse_tres()
  - addons/neocade_theme/_phase4_verify.gd  # EditorScript verifier
  - addons/neocade_theme/_phase4_verify_headless.gd  # SceneTree headless variant (Cross-AI Cycle 1 MEDIUM)
autonomous: true
requirements:
  - FOUND-03
must_haves:
  truths:
    - "`addons/neocade_theme/pulse_neocade_theme.tres` exists and is GENERATED PROGRAMMATICALLY (Cross-AI Cycle 1 C6 fix): the file is produced by an `@tool` script that does `var t := NeoCadeTheme.new(); t.base_color = Color(\"#151A2E\"); ...; ResourceSaver.save(t, \"...pulse_neocade_theme.tres\")`. The actual on-disk header (`[gd_resource type=\"NeoCadeTheme\" ...]` vs `[gd_resource type=\"Resource\" script_class=\"NeoCadeTheme\" ...]` etc.) is whatever Godot 4.6 emits — NOT hand-authored — and that emitted form is the canonical template Plan 04-07 will copy for the peer .tres files."
    - "The `.tres` saves the 9 `@export` values per DESIGN_TOKENS §5.1: `base_color = Color(\"#151A2E\")`, `accent_color = Color(\"#8BFF6A\")`, `raised = false`, `platform = 2` (Platform.AUTO), `corner_radius = 0`, `spacing = 18`, `raised_strength = 3`, `focus_thickness = 2`, `outline_width = 1`."
    - "Loading `pulse_neocade_theme.tres` in Godot Editor opens it as a `NeoCadeTheme` instance with the values above; `_regenerate_theme()` runs at load time (per `_init()` in Plan 04-01) populating all 37 BINDING_TABLE Control entries + 13 type variations."
    - "Verification (manual or scripted): after load, `theme.has_stylebox(\"normal\", \"Button\")` returns `true`; `theme.has_stylebox(\"panel\", \"Tree\")` returns `true`; `theme.has_color(\"font_color\", \"Button\")` returns `true`; `theme.get_type_variation_base(\"PrimaryButton\")` returns `\"Button\"`; `theme.has_font(\"font\", \"HeaderLarge\")` returns `true`."
    - "Toggling `raised = true` then `raised = false` on the loaded `.tres` (in Godot Editor's Inspector) triggers `_regenerate_theme()` and produces correct shadow_size values on raised-eligible Controls (verified visually or via spot-check on 1-2 stylebox slots)."
    - "Toggling `platform = MOBILE` on the loaded `.tres` triggers regeneration and produces `Button.normal.content_margin_*` values consistent with mobile platform tokens (the spacing scaling is observable)."
    - "Setting `base_color = Color(\"#F0F0F0\")` (a forced-light test) on the loaded `.tres` triggers regeneration; `theme.get_color(\"font_color\", \"Button\")` returns `Color(\"#1B2230\")` (the dark text on light surface, per DESIGN_TOKENS §6.4 `is_light` flip). After this verification the `.tres` is reverted to `Color(\"#151A2E\")`."
  artifacts:
    - addons/neocade_theme/pulse_neocade_theme.tres (Pulse direction; recommended starter; ResourceSaver-generated)
    - addons/neocade_theme/_phase4_verify.gd (EditorScript verifier; DELETE BEFORE v1)
    - addons/neocade_theme/_phase4_verify_headless.gd (SceneTree headless verifier; DELETE BEFORE v1)
  key_links:
    - ".planning/DESIGN_TOKENS.md §5.1 (Pulse @export values)"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md D-13, D-14 step 7-8"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md §7 (Pulse verification methodology)"
    - ".planning/mockups/3.4/finalist-gallery.html (Pulse 4-grid visual reference)"
---

<objective>
Author the Pulse `.tres` (the recommended starter direction; FIRST per D-14 + DESIGN_TOKENS §12.4 implementation order) and verify end-to-end that loading it produces a fully-populated Theme matching the Phase 3.4 finalist mockup output. This is the Phase 4 critical path: Pulse must work before Slate / Bubble / Daybreak / Burst (Plan 04-07) follow.

Purpose: validate that the engine (Plans 04-01..05) correctly produces a renderable Theme from the Pulse `@export` values + that subsequent direction `.tres` files only need to ship data.
Output: 1 new `.tres` file at `addons/neocade_theme/pulse_neocade_theme.tres` + verification artifacts (a small GDScript helper script that loads + spot-checks values; runtime smoke evidence in the Plan 04 SUMMARY).
</objective>

<execution_context>
@$HOME/.codex/get-shit-done/workflows/execute-plan.md
@$HOME/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/DESIGN_TOKENS.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md
@.planning/mockups/3.4/finalist-gallery.html
@.planning/mockups/3.4/data/directions.json
@addons/neocade_theme/neocade_theme.gd

<interfaces>
After Plan 04-05 closes, `NeoCadeTheme` (`addons/neocade_theme/neocade_theme.gd`) is feature-complete: loading any `[gd_resource type="NeoCadeTheme"]` `.tres` with the 9 `@export` values populated triggers `_regenerate_theme()` which populates 37 Controls + 13 variations.

This plan ships only the Pulse direction's `.tres` data + verification. Plan 04-07 ships the remaining 4 directions; Plan 04-08 ships metadata.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Generate addons/neocade_theme/pulse_neocade_theme.tres PROGRAMMATICALLY via ResourceSaver (Cross-AI Cycle 1 C6 fix)</name>
  <read_first>
    - .planning/DESIGN_TOKENS.md (§5.1 Pulse table)
    - addons/neocade_theme/neocade_theme.gd (verify NeoCadeTheme class is loadable as a resource type)
    - addons/neocade_theme/_phase4_import.gd (Plan 04-02 — extend this helper)
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md (D-14 step 7)
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-REVIEWS.md (Cycle 1 HIGH C6)
  </read_first>
  <files>
    - addons/neocade_theme/_phase4_import.gd (modify — extend with Pulse .tres save block)
    - addons/neocade_theme/pulse_neocade_theme.tres (GENERATED via ResourceSaver.save)
  </files>
  <action>
    **Cross-AI Cycle 1 C6 fix:** `pulse_neocade_theme.tres` is NOT hand-authored. The hand-written `[gd_resource type="NeoCadeTheme" script_class="NeoCadeTheme"]` header may not match Godot's actual saved format for a `class_name NeoCadeTheme extends Theme`. Instead, append a Pulse-save block to `_phase4_import.gd` (created in Plan 04-02), run the helper via Godot, and commit the file Godot serializes.

    **Stage A — Extend `_phase4_import.gd`:**

    Append a new function and call it from `_run()`:

    ```gdscript

    ## Plan 04-06 add-on: generate pulse_neocade_theme.tres via ResourceSaver.save().
    ## NeoCadeTheme.new() triggers _init() which triggers _regenerate_theme(); the saved
    ## .tres carries the 9 @export values. Loading the saved .tres re-triggers regeneration.
    func _save_pulse_tres() -> void:
        var pulse: NeoCadeTheme = NeoCadeTheme.new()
        pulse.base_color = Color("#151A2E")
        pulse.accent_color = Color("#8BFF6A")
        pulse.raised = false
        pulse.platform = NeoCadeTheme.Platform.AUTO
        pulse.corner_radius = 0
        pulse.spacing = 18
        pulse.raised_strength = 3
        pulse.focus_thickness = 2
        pulse.outline_width = 1
        var path := "res://addons/neocade_theme/pulse_neocade_theme.tres"
        var ok := ResourceSaver.save(pulse, path)
        assert(ok == OK, "pulse save failed: %d" % ok)

        # Cross-AI Cycle 1 C6: capture the actual header Godot emits, log it for Plan 04-07's
        # peer .tres template + for documentation.
        var fa := FileAccess.open(path, FileAccess.READ)
        var first_line := fa.get_line()
        fa.close()
        print("✓ Pulse .tres saved. Godot header (canonical for Plan 04-07): ", first_line)

    func _run() -> void:
        # ... existing font materialization ...
        _save_pulse_tres()
    ```

    **Stage B — Run the helper:**

    Run `_phase4_import.gd` via Godot Editor's File → Run, OR `godot --headless --editor --script addons/neocade_theme/_phase4_import.gd`. The Pulse `.tres` file is materialized at `addons/neocade_theme/pulse_neocade_theme.tres`. Capture the printed first line — that's the canonical header Godot emits for `NeoCadeTheme` resources, and Plan 04-07 will use the EXACT same form for Slate/Bubble/Daybreak/Burst.

    Color value reference (informational; Godot's serializer produces these float values):
    - `base_color = Color("#151A2E")` → `Color(0.0823529, 0.101961, 0.180392, 1)`.
    - `accent_color = Color("#8BFF6A")` → `Color(0.545098, 1, 0.415686, 1)`.

    Platform value reference: `Platform.AUTO` serializes as `2` (third enum value: DESKTOP=0, MOBILE=1, AUTO=2).

    The Plan 04-06 commit captures the actual saved file. Future Plan 04-07 commits use the same saved-file-as-template approach for the peer themes.
  </action>
  <acceptance_criteria>
    - `addons/neocade_theme/_phase4_import.gd` contains a `func _save_pulse_tres() -> void:` declaration.
    - `_phase4_import.gd` `_save_pulse_tres` body contains `NeoCadeTheme.new()`, sets all 9 @export values, and calls `ResourceSaver.save(pulse, "res://addons/neocade_theme/pulse_neocade_theme.tres")`.
    - `_phase4_import.gd` `_run()` calls `_save_pulse_tres()`.
    - `addons/neocade_theme/pulse_neocade_theme.tres` exists (generated by running the helper).
    - File first line begins with `[gd_resource` and includes `format=3`.
    - File contains a `[resource]` section.
    - File contains `base_color = Color(0.0823529, 0.101961, 0.180392, 1)` (the float-encoded `#151A2E` produced by Godot's serializer).
    - File contains `accent_color = Color(0.545098, 1, 0.415686, 1)` (the float-encoded `#8BFF6A`).
    - File contains `raised = false`.
    - File contains `platform = 2` (Platform.AUTO).
    - File contains `corner_radius = 0`.
    - File contains `spacing = 18`.
    - File contains `raised_strength = 3`.
    - File contains `focus_thickness = 2`.
    - File contains `outline_width = 1`.
    - File contains `NeoCadeTheme` somewhere in the header line (whatever exact form Godot uses — `script_class="NeoCadeTheme"` OR `type="NeoCadeTheme"` OR a `script = ExtResource(...)` line referencing `neocade_theme.gd`; the canonical-header verification is performed at runtime via `ResourceLoader.load("res://addons/neocade_theme/pulse_neocade_theme.tres") is NeoCadeTheme`).
    - LOW concern fix: the file PASSES `ResourceLoader.load()` + `is NeoCadeTheme` + `has_stylebox("normal", "Button")` assertions at runtime (verified by `_phase4_verify.gd` in Task 2).
    - File is between 200 and 1500 bytes (Godot may serialize slightly larger than hand-authored; sanity-bound widened).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$h='addons/neocade_theme/_phase4_import.gd'; if (-not (Test-Path $h)) { throw '_phase4_import.gd missing — Plan 04-02 must run first' }; $hg=Get-Content -Raw $h; foreach($n in 'func _save_pulse_tres() -> void:','NeoCadeTheme.new()','base_color = Color(\"#151A2E\")','accent_color = Color(\"#8BFF6A\")','ResourceSaver.save(pulse, \"res://addons/neocade_theme/pulse_neocade_theme.tres\")','_save_pulse_tres()') { if ($hg -notmatch [regex]::Escape($n)) { throw \"_phase4_import.gd missing: $n\" } }; $p='addons/neocade_theme/pulse_neocade_theme.tres'; if (-not (Test-Path $p)) { throw 'pulse_neocade_theme.tres missing — run _phase4_import.gd' }; $g=Get-Content -Raw $p; foreach($n in '[gd_resource','format=3','[resource]','base_color = Color(0.0823529, 0.101961, 0.180392, 1)','accent_color = Color(0.545098, 1, 0.415686, 1)','raised = false','platform = 2','corner_radius = 0','spacing = 18','raised_strength = 3','focus_thickness = 2','outline_width = 1') { if ($g -notmatch [regex]::Escape($n)) { throw \"pulse .tres missing: $n\" } }; if ($g -notmatch 'NeoCadeTheme') { throw 'NeoCadeTheme reference missing in pulse .tres header' }; $size=(Get-Item $p).Length; if ($size -lt 200 -or $size -gt 1500) { throw \"file size $size bytes outside 200-1500 range\" }"
    </automated>
  </verify>
  <done>Pulse `.tres` ships the recommended-starter direction's `@export` values; the engine produces a renderable theme on load.</done>
</task>

<task type="auto">
  <name>Task 2: Author a verification helper at addons/neocade_theme/_phase4_verify.gd and run smoke checks</name>
  <read_first>
    - addons/neocade_theme/pulse_neocade_theme.tres
    - addons/neocade_theme/neocade_theme.gd
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md (§7 verification methodology, §11 verification gates)
  </read_first>
  <files>
    - addons/neocade_theme/_phase4_verify.gd (NEW — temp helper, deleted in Phase 11)
  </files>
  <action>
    Author a verification helper that loads `pulse_neocade_theme.tres` and asserts:
    1. Loaded resource is a `NeoCadeTheme` instance (Cross-AI Cycle 1 LOW — explicit `ResourceLoader.load() + is NeoCadeTheme + has_*` assertion).
    2. The 9 `@export` values match the §5.1 spec.
    3. Theme `default_font` is set to Inter-Body.tres (Cross-AI Cycle 1 C3 fix; FONT-06).
    4. After `_regenerate_theme()` (which `_init()` triggers): every BINDING_TABLE root key has `has_stylebox` / `has_color` / `has_constant` / `has_font` / `has_icon` returning true for at least one slot.
    5. `BINDING_TABLE.size() == 37` exactly (Cross-AI Cycle 1 C1 fix).
    6. `TYPE_VARIATIONS.size() == 14` exactly (Cross-AI Cycle 1 C4 fix — was previously 13; CodeLabel restored).
    7. Every TYPE_VARIATIONS key returns `get_type_variation_base()` == its base type.
    8. `is_light` is `false` (Pulse base `#151A2E` luminance < 0.5).
    9. Spot-check derived values: `theme.get_stylebox("normal", "Button")` returns a non-null StyleBoxFlat; `theme.get_color("font_color", "Label")` is a non-default Color; `theme.has_font("font", "HeaderLarge")` is true; `theme.has_font("font", "CodeLabel")` is true.
    10. Toggling `raised = true` produces `Button.normal.shadow_size > 0` (per Plan 04-05 BINDING_TABLE `raised_intensity = 1` for Button.normal — Cross-AI Cycle 1 MEDIUM reconcile fix).

    **Cross-AI Cycle 1 MEDIUM fix (headless verification):** the helper is split into TWO files for autonomous-executor friendliness:
    - `addons/neocade_theme/_phase4_verify.gd` — `extends EditorScript` (run via Godot Editor; the original).
    - `addons/neocade_theme/_phase4_verify_headless.gd` — `extends SceneTree` (run via `godot --headless --script` WITHOUT `--editor`; CI-friendly).

    Both files share the same assertion logic (extracted into a shared inner function); the editor variant prints to the Output panel, the headless variant prints to stdout + `quit()`s.

    EditorScript file content:

    ```gdscript
    @tool
    extends EditorScript

    ## Phase 4 verification helper (EditorScript variant). Run via Godot Editor → File → Run.
    ## DELETE this file in Phase 11 before distribution (alongside _phase4_verify_headless.gd
    ## and _phase4_import.gd).

    func _run() -> void:
        _verify_pulse()

    func _verify_pulse() -> void:
        var path := "res://addons/neocade_theme/pulse_neocade_theme.tres"
        var loaded: Resource = ResourceLoader.load(path)
        assert(loaded != null, "ResourceLoader.load returned null for pulse_neocade_theme.tres")
        assert(loaded is NeoCadeTheme, "loaded resource is not a NeoCadeTheme — header form may be wrong")
        var theme: NeoCadeTheme = loaded
        assert(theme.has_stylebox("normal", "Button"), "pulse missing Button.normal stylebox after load+regenerate")

        # 1. Verify @export values
        assert(theme.base_color == Color("#151A2E"), "base_color mismatch")
        assert(theme.accent_color == Color("#8BFF6A"), "accent_color mismatch")
        assert(theme.raised == false, "raised mismatch")
        assert(theme.platform == NeoCadeTheme.Platform.AUTO, "platform mismatch")
        assert(theme.corner_radius == 0, "corner_radius mismatch")
        assert(theme.spacing == 18, "spacing mismatch")
        assert(theme.raised_strength == 3, "raised_strength mismatch")
        assert(theme.focus_thickness == 2, "focus_thickness mismatch")
        assert(theme.outline_width == 1, "outline_width mismatch")
        assert(theme.is_light == false, "is_light should be false for Pulse #151A2E")

        # 2. Verify BINDING_TABLE coverage — EXACT 37 (Cross-AI Cycle 1 C1 fix)
        var binding_table = theme.get_script().get_script_constant_map().get("BINDING_TABLE", {})
        assert(binding_table.size() == 37, "BINDING_TABLE size %d != 37 (canonical scorecard)" % binding_table.size())
        var canonical_37 := ["AcceptDialog","Button","CheckBox","CheckButton","CodeEdit","ColorPicker","ColorPickerButton","ConfirmationDialog","FileDialog","FoldableContainer","GraphEdit","HScrollBar","HSlider","HSplitContainer","ItemList","Label","LineEdit","LinkButton","MenuBar","MenuButton","OptionButton","Panel","PopupMenu","PopupPanel","ProgressBar","RichTextLabel","SpinBox","TabBar","TabContainer","TextEdit","TooltipLabel","TooltipPanel","Tree","VScrollBar","VSlider","VSplitContainer","Window"]
        for t in canonical_37:
            assert(binding_table.has(t), "BINDING_TABLE missing canonical key: %s" % t)

        var sampled_types := ["Button", "Tree", "LineEdit", "PopupMenu", "Window", "HScrollBar"]
        for t in sampled_types:
            assert(theme.has_stylebox("normal", t) or theme.has_stylebox("panel", t) or theme.has_stylebox("scroll", t) or theme.has_stylebox("embedded_border", t), "%s has no stylebox after regenerate" % t)

        # 3. Verify TYPE_VARIATIONS registration — EXACT 14 (Cross-AI Cycle 1 C4 fix; CodeLabel included)
        var type_variations = theme.get_script().get_script_constant_map().get("TYPE_VARIATIONS", {})
        assert(type_variations.size() == 14, "TYPE_VARIATIONS size %d != 14" % type_variations.size())
        assert(type_variations.has("CodeLabel"), "TYPE_VARIATIONS missing CodeLabel (Cross-AI Cycle 1 C4)")
        for variation in type_variations.keys():
            var base_type: String = type_variations[variation]
            assert(theme.get_type_variation_base(variation) == base_type,
                "%s should derive from %s" % [variation, base_type])

        # 3b. Verify theme defaults are set (Cross-AI Cycle 1 C3 fix; FONT-06)
        assert(theme.default_font != null, "theme.default_font not set (Cross-AI Cycle 1 C3)")
        assert(theme.default_font_size > 0, "theme.default_font_size not set")

        # 4. Verify explicit fonts on header + code variations (PITFALLS 1.2)
        for v in ["HeaderLarge", "HeaderMedium", "HeaderSmall", "Caption", "CodeLabel", "InfoText"]:
            assert(theme.has_font("font", v), "%s missing explicit font (PITFALLS 1.2)" % v)

        # 5. Spot-check 3 derived values
        var btn_normal: StyleBox = theme.get_stylebox("normal", "Button")
        assert(btn_normal != null, "Button.normal stylebox null")
        var label_color: Color = theme.get_color("font_color", "Label")
        assert(label_color != Color(0, 0, 0, 1), "Label.font_color is engine default — derivation didn't run")

        # 6. Toggle test: raised true → false → check shadow_size flips
        theme.raised = true
        var btn_raised: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
        if btn_raised:
            assert(btn_raised.shadow_size > 0, "raised=true should set shadow_size > 0")
        theme.raised = false
        var btn_flat: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
        if btn_flat:
            assert(btn_flat.shadow_size == -1, "raised=false should set shadow_size = -1")

        # 7. is_light flip test
        theme.base_color = Color("#F0F0F0")
        assert(theme.is_light == true, "is_light should flip to true on #F0F0F0")
        var light_label_color: Color = theme.get_color("font_color", "Label")
        assert(light_label_color.r < 0.5, "is_light=true should produce dark text (#1B2230 family)")
        # Revert
        theme.base_color = Color("#151A2E")

        print("✓ Phase 4 verification: pulse_neocade_theme.tres passes all gates.")
    ```

    **Headless-friendly variant — `_phase4_verify_headless.gd` (Cross-AI Cycle 1 MEDIUM fix):**

    Author a second file `addons/neocade_theme/_phase4_verify_headless.gd` that uses `extends SceneTree` (NOT EditorScript) so it can run via `godot --headless --script ...` WITHOUT needing the editor:

    ```gdscript
    extends SceneTree

    ## Phase 4 verification helper (headless variant). Run autonomously via:
    ##   godot --headless --quit --script addons/neocade_theme/_phase4_verify_headless.gd
    ## DELETE this file in Phase 11 (alongside _phase4_verify.gd + _phase4_import.gd).

    func _init() -> void:
        var path := "res://addons/neocade_theme/pulse_neocade_theme.tres"
        var loaded: Resource = ResourceLoader.load(path)
        if loaded == null:
            push_error("FAIL: ResourceLoader.load returned null for %s" % path)
            quit(1)
            return
        if not (loaded is NeoCadeTheme):
            push_error("FAIL: loaded resource is not NeoCadeTheme")
            quit(1)
            return
        var theme: NeoCadeTheme = loaded

        # Inline the same assertion logic as _phase4_verify.gd._verify_pulse() — duplicated
        # rather than `load`-ed to keep this file standalone (the helper file is a few KB; KISS).
        var failures: Array[String] = []
        if theme.base_color != Color("#151A2E"): failures.append("base_color mismatch")
        if theme.accent_color != Color("#8BFF6A"): failures.append("accent_color mismatch")
        if theme.raised: failures.append("raised should be false")
        if theme.platform != NeoCadeTheme.Platform.AUTO: failures.append("platform mismatch")
        if theme.corner_radius != 0: failures.append("corner_radius mismatch")
        if theme.spacing != 18: failures.append("spacing mismatch")
        if theme.is_light: failures.append("is_light should be false for #151A2E")
        if theme.default_font == null: failures.append("default_font not set (FONT-06)")
        if theme.default_font_size <= 0: failures.append("default_font_size not set")

        var binding_table = theme.get_script().get_script_constant_map().get("BINDING_TABLE", {})
        if binding_table.size() != 37:
            failures.append("BINDING_TABLE size %d != 37" % binding_table.size())
        var type_variations = theme.get_script().get_script_constant_map().get("TYPE_VARIATIONS", {})
        if type_variations.size() != 14:
            failures.append("TYPE_VARIATIONS size %d != 14" % type_variations.size())
        if not type_variations.has("CodeLabel"):
            failures.append("TYPE_VARIATIONS missing CodeLabel")

        if not theme.has_stylebox("normal", "Button"): failures.append("Button.normal stylebox missing")
        if not theme.has_stylebox("panel", "Tree"): failures.append("Tree.panel stylebox missing")
        if not theme.has_font("font", "HeaderLarge"): failures.append("HeaderLarge font missing")
        if not theme.has_font("font", "CodeLabel"): failures.append("CodeLabel font missing")

        # Raised toggle test (Cross-AI Cycle 1 MEDIUM reconcile)
        theme.raised = true
        var raised_btn: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
        if raised_btn != null and raised_btn.shadow_size <= 0:
            failures.append("raised=true: Button.normal shadow_size %d not > 0" % raised_btn.shadow_size)
        theme.raised = false

        if failures.size() > 0:
            print("FAIL — Phase 4 headless verify failures:")
            for f in failures:
                print("  - ", f)
            quit(1)
            return

        print("PASS — Phase 4 headless verification: pulse_neocade_theme.tres passes all gates.")
        quit(0)
    ```

    Run paths (the executor picks whichever the environment supports; both are valid evidence):
    1. **Editor variant:** `_phase4_verify.gd` via Godot Editor → File → Run.
    2. **Headless variant (preferred for autonomous execution):** `godot --headless --quit --script addons/neocade_theme/_phase4_verify_headless.gd` — exits 0 on PASS, 1 on FAIL.

    Capture the stdout output (PASS line + any failure log) and include in Plan 04-06's commit message + Plan 04 SUMMARY.

    NOTE: BOTH helper files live at `addons/neocade_theme/` (NOT distributed) and are deleted in Phase 11 before publication, alongside `_phase4_import.gd`. Each file MUST contain a comment header with the literal substring `DELETE BEFORE v1 PUBLICATION` so a Phase 11 grep can locate them.
  </action>
  <acceptance_criteria>
    - File `addons/neocade_theme/_phase4_verify.gd` exists.
    - File contains `@tool` and `extends EditorScript`.
    - File contains `func _run() -> void:` and `func _verify_pulse() -> void:`.
    - File contains header comment with `DELETE BEFORE v1 PUBLICATION` (anchors Phase 11 cleanup).
    - File contains `ResourceLoader.load(path)` (Cross-AI Cycle 1 LOW assertion).
    - File contains `loaded is NeoCadeTheme` assertion.
    - File contains assertions for all 9 `@export` properties.
    - File contains assertion `theme.default_font != null` (Cross-AI Cycle 1 C3 fix).
    - File contains assertion `binding_table.size() == 37` (Cross-AI Cycle 1 C1 fix; EXACT 37, not >=37).
    - File contains assertion `type_variations.size() == 14` (Cross-AI Cycle 1 C4 fix; was 13).
    - File contains assertion `type_variations.has("CodeLabel")` (Cross-AI Cycle 1 C4 fix).
    - File contains assertion that all 37 canonical types are present in BINDING_TABLE.
    - File contains the raised toggle test asserting `shadow_size > 0` after `theme.raised = true`.
    - File contains the `is_light` flip test (`theme.base_color = Color("#F0F0F0")`).
    - File `addons/neocade_theme/_phase4_verify_headless.gd` exists (Cross-AI Cycle 1 MEDIUM headless fix).
    - Headless file contains `extends SceneTree` (NOT EditorScript).
    - Headless file contains `func _init() -> void:` and `quit(0)` / `quit(1)` exit paths.
    - Headless file contains `BINDING_TABLE.size() != 37` failure check and `TYPE_VARIATIONS.size() != 14` failure check.
    - When the headless variant is run via `godot --headless --quit --script ...`, it prints the PASS line on success and exits with status 0.
    - When the EditorScript variant is run via Godot Editor's File → Run, it completes without assertion failures.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/_phase4_verify.gd'; if (-not (Test-Path $p)) { throw '_phase4_verify.gd missing' }; $g=Get-Content -Raw $p; foreach($n in '@tool','extends EditorScript','func _run() -> void:','func _verify_pulse() -> void:','DELETE BEFORE','ResourceLoader.load(path)','loaded is NeoCadeTheme','theme.default_font != null','base_color == Color(\"#151A2E\")','accent_color == Color(\"#8BFF6A\")','raised == false','corner_radius == 0','spacing == 18','raised_strength == 3','focus_thickness == 2','outline_width == 1','is_light == false','binding_table.size() == 37','type_variations.size() == 14','type_variations.has(\"CodeLabel\")','theme.raised = true','theme.raised = false','theme.base_color = Color(\"#F0F0F0\")','theme.is_light == true') { if ($g -notmatch [regex]::Escape($n)) { throw \"_phase4_verify.gd missing: $n\" } }; $h='addons/neocade_theme/_phase4_verify_headless.gd'; if (-not (Test-Path $h)) { throw '_phase4_verify_headless.gd missing (Cross-AI Cycle 1 MEDIUM)' }; $hg=Get-Content -Raw $h; foreach($n in 'extends SceneTree','func _init() -> void:','ResourceLoader.load(path)','loaded is NeoCadeTheme','binding_table.size() != 37','type_variations.size() != 14','type_variations.has(\"CodeLabel\")','quit(0)','quit(1)','DELETE BEFORE') { if ($hg -notmatch [regex]::Escape($n)) { throw \"_phase4_verify_headless.gd missing: $n\" } }"
    </automated>
  </verify>
  <done>BOTH the EditorScript and headless verification variants exist; Pulse loads, regenerates, populates 37 Controls + 14 variations, raised + is_light toggles work; canonical 37 + 14 counts asserted exactly. Cross-AI Cycle 1 C4/C6/MEDIUM/LOW addressed.</done>
</task>

<task type="auto">
  <name>Task 3: Atomic commit — Pulse .tres + verification helper</name>
  <read_first>
    - addons/neocade_theme/pulse_neocade_theme.tres
    - addons/neocade_theme/_phase4_verify.gd
  </read_first>
  <files>(commit only)</files>
  <action>
    Stage the 3 modified/new files (Pulse .tres + 2 verify helpers + extended _phase4_import.gd) and commit:

    ```
    feat(04-06): ship Pulse .tres (Godot-serialized) + dual verification helpers

    Plan 04-06 wave-3 (depends on Plans 04-04, 04-05; Cross-AI Cycle 1 fixes):
    - C6 fix: addons/neocade_theme/pulse_neocade_theme.tres — generated via
      _phase4_import.gd ResourceSaver.save() pass; header is whatever Godot
      4.6 emits for NeoCadeTheme (canonical for Plan 04-07 peer .tres files)
    - addons/neocade_theme/_phase4_import.gd — extended with _save_pulse_tres()
    - addons/neocade_theme/_phase4_verify.gd — EditorScript helper; asserts
      BINDING_TABLE.size() == 37 (C1), TYPE_VARIATIONS.size() == 14 (C4),
      CodeLabel present, theme.default_font set (C3), explicit header fonts,
      raised toggle behavior, is_light flip on #F0F0F0; DELETED IN PHASE 11.
    - addons/neocade_theme/_phase4_verify_headless.gd — SceneTree-based variant
      runs via `godot --headless --quit --script ...` for autonomous CI
      verification (Cross-AI Cycle 1 MEDIUM); DELETED IN PHASE 11.

    Pulse @export values per DESIGN_TOKENS §5.1: base=#151A2E, accent=#8BFF6A,
    raised=false, platform=AUTO, corner_radius=0, spacing=18, raised_strength=3,
    focus_thickness=2, outline_width=1.

    Verification: Pulse loads via ResourceLoader.load + is NeoCadeTheme,
    _regenerate_theme() populates all 37 Controls + 14 variations, raised toggle
    flips Button.normal.shadow_size from -1 to >0 (MEDIUM reconcile fix),
    is_light flip produces dark text on light surfaces. SC#7 strict-reading
    first verification.

    Refs: FOUND-03 (Pulse subset), FONT-06 (default_font asserted)
    Plan: 04-06
    ```

    `git add` the modified `_phase4_import.gd` (M) + 3 new files (A); commit. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-06):`.
    - `git log -1 --name-status` shows `A addons/neocade_theme/pulse_neocade_theme.tres`, `A addons/neocade_theme/_phase4_verify.gd`, `A addons/neocade_theme/_phase4_verify_headless.gd`, and `M addons/neocade_theme/_phase4_import.gd`.
    - `git status --porcelain` is empty for all 4 files.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-06\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; foreach($f in 'addons/neocade_theme/pulse_neocade_theme\\.tres','addons/neocade_theme/_phase4_verify\\.gd','addons/neocade_theme/_phase4_verify_headless\\.gd') { if ($ns -notmatch \"A\\s+$f\") { throw \"commit missing $f\" } }; if ($ns -notmatch 'M\\s+addons/neocade_theme/_phase4_import\\.gd') { throw 'commit missing _phase4_import.gd modification' }"
    </automated>
  </verify>
  <done>Pulse + dual verification helpers land as a single atomic commit. Pulse is Godot-serialized (C6); BINDING_TABLE asserts 37 (C1) + TYPE_VARIATIONS asserts 14 (C4) + default_font asserted (C3); headless variant supports autonomous CI (MEDIUM); ResourceLoader assertion satisfied (LOW).</done>
</task>

</tasks>
