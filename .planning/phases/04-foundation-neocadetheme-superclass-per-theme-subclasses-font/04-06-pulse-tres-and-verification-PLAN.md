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
    - "**Cross-AI Cycle 3 N4 fix (Fix A — textual post-process) + Cross-AI Cycle 4 N5 fix (script linkage preservation):** AFTER `ResourceSaver.save()`, the helper invokes `_strip_theme_entries(path)` which (a) reads the freshly-saved `.tres` back as text, (b) strips ALL `[sub_resource ...]` blocks and their bodies, (c) strips ALL `theme_data/` lines AND all per-Control / per-variation entry sections from the `[resource]` block, (d) keeps the `[gd_resource ...]` header (Godot-emitted; preserves Cycle 1 C6 fix), (e) **Cycle 4 N5: keeps ANY `[ext_resource type=\"Script\" ...]` block intact** — Godot may serialize `class_name NeoCadeTheme extends Theme` in the script-backed form (`[gd_resource type=\"Theme\" ...]` header + `[ext_resource type=\"Script\" path=\"...\" id=\"...\"]` + `script = ExtResource(\"id\")` line inside `[resource]`); dropping that ext_resource block makes the resource load as plain `Theme`, failing `loaded is NeoCadeTheme`, (f) keeps the 9 `@export` property lines on the `[resource]` block PLUS any `script = ExtResource(...)` / `script_class = ...` line (Cycle 4 N5), (g) **strips the `load_steps=...` attribute from the `[gd_resource ...]` header** so Godot recomputes it on load (preserved blocks may be fewer than the originally-serialized count; mismatched `load_steps` makes Godot reject the file), (h) writes the trimmed file back. SC#6 (`saved .tres files stay data-oriented`) is satisfied by construction; regenerated baseline entries are recomputed at load time when `_init()` runs. Final on-disk size MUST be < 2048 bytes (2 KiB) — preserved script ext_resource block adds ~80-150 bytes; well under the cap."
    - "The `.tres` saves the 9 `@export` values per DESIGN_TOKENS §5.1: `base_color = Color(\"#151A2E\")`, `accent_color = Color(\"#8BFF6A\")`, `raised = false`, `platform = 2` (Platform.AUTO), `corner_radius = 0`, `spacing = 18`, `raised_strength = 3`, `focus_thickness = 2`, `outline_width = 1`."
    - "Loading `pulse_neocade_theme.tres` in Godot Editor opens it as a `NeoCadeTheme` instance with the values above; `_regenerate_theme()` runs at load time (per `_init()` in Plan 04-01) populating all 37 BINDING_TABLE Control entries + 14 type variations (Cross-AI Cycle 1 C4: count fixed to 14 with CodeLabel included)."
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
After Plan 04-05 closes, `NeoCadeTheme` (`addons/neocade_theme/neocade_theme.gd`) is feature-complete: loading any `[gd_resource type="NeoCadeTheme"]` `.tres` with the 9 `@export` values populated triggers `_regenerate_theme()` which populates 37 Controls + 14 variations (Cross-AI Cycle 1 C4 fix).

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

    ## Plan 04-06 add-on: generate pulse_neocade_theme.tres via ResourceSaver.save(),
    ## then post-process the file to strip serialized theme entries (Cross-AI Cycle 3 N4
    ## Fix A — keeps SC#6 "saved .tres files stay data-oriented"). NeoCadeTheme.new()
    ## triggers _init() which triggers _regenerate_theme() (populates hundreds of stylebox/
    ## color/constant/font/icon entries); ResourceSaver.save() serializes EVERYTHING
    ## (header + 9 @exports + sub_resources + theme_data/* entries). The strip pass
    ## removes the regenerated entry bloat and keeps only the Godot-emitted [gd_resource
    ## ...] header (preserves Cycle 1 C6 fix) + the 9 @export property lines. Loading
    ## the trimmed .tres re-triggers _init() → _regenerate_theme() → entries repopulate.
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

        # Cross-AI Cycle 3 N4 Fix A — strip serialized theme entries. ResourceSaver.save()
        # serializes _regenerate_theme()'s output into the .tres; the entry bloat
        # contradicts SC#6 ("saved .tres files stay data-oriented") and Plan 04-06's
        # < 2KiB sanity bound. Strip everything except the [gd_resource ...] header +
        # the 9 @export lines on the [resource] block. Re-loading the stripped file
        # produces the same NeoCadeTheme instance (regeneration runs at load time).
        _strip_theme_entries(path)

    ## Cross-AI Cycle 3 N4 Fix A — textual post-process to data-only the saved .tres.
    ## Cross-AI Cycle 4 N5 Fix — preserve `[ext_resource type="Script" ...]` blocks
    ## AND `script = ExtResource(...)` / `script_class = ...` lines inside `[resource]`,
    ## because Godot 4.6 may serialize `class_name NeoCadeTheme extends Theme` as
    ## either form 1 (`[gd_resource type="NeoCadeTheme" ...]` header alone — script
    ## linkage carried in header attributes) OR form 2 (`[gd_resource type="Theme" ...]`
    ## header + `[ext_resource type="Script" ...]` block + `script = ExtResource("id")`
    ## line in `[resource]`). Form 2's script linkage is REQUIRED for the file to load
    ## as `NeoCadeTheme`; dropping it makes `_init()` never fire and `loaded is
    ## NeoCadeTheme` assert fail. Also strips the `load_steps=N` attribute from the
    ## `[gd_resource ...]` header (preserved-block count differs from original; Godot
    ## tolerates a missing `load_steps` and recomputes on load).
    ##
    ## Reads `path`, keeps the [gd_resource ...] header (whatever Godot emitted, with
    ## `load_steps=...` stripped), keeps any `[ext_resource type="Script" ...]` block
    ## (Cycle 4 N5), drops all `[sub_resource ...]` blocks (font/stylebox/etc. payloads
    ## regenerated at load), drops all OTHER `[ext_resource ...]` blocks (non-script
    ## sub-asset refs that regeneration would re-create — Phase 4 has none, but be
    ## defensive), drops the [resource] body's `theme_data/...` lines and any
    ## per-Control entry sections, and keeps the 9 @export property lines
    ## (base_color, accent_color, raised, platform, corner_radius, spacing,
    ## raised_strength, focus_thickness, outline_width) PLUS the `script = ExtResource(...)`
    ## / `script_class = ...` lines if Godot serialized them inside `[resource]`.
    ## Asserts post-strip size < 2048 bytes (SC#6 + size sanity).
    static func _strip_theme_entries(path: String) -> void:
        var src := FileAccess.open(path, FileAccess.READ)
        assert(src != null, "strip: cannot open %s for read" % path)
        var text := src.get_as_text()
        src.close()

        # Whitelist of @export property names; lines whose left-hand side is one of
        # these survive in the [resource] block. Anything else (theme_data/...,
        # SubResource references, per-Control state entries) is dropped — EXCEPT the
        # `script = ExtResource(...)` / `script_class = ...` lines (Cycle 4 N5),
        # which are detected by prefix below and preserved separately.
        var EXPORT_KEYS := [
            "base_color", "accent_color", "raised", "platform",
            "corner_radius", "spacing", "raised_strength",
            "focus_thickness", "outline_width",
        ]

        var lines := text.split("\n")
        var out: PackedStringArray = []
        var section: String = ""        # tracks current [section] block
        var skip_section: bool = false  # true while inside dropped section bodies
        for raw_line in lines:
            var line: String = raw_line
            var stripped := line.strip_edges()
            if stripped.begins_with("[") and stripped.ends_with("]"):
                # Section header transition.
                # Cycle 4 N5: PRESERVE [ext_resource type="Script" ...] blocks
                # (script linkage required for form-2 serialization) — keep the
                # entire 1-line section as-is.
                if stripped.begins_with("[ext_resource") and stripped.find("type=\"Script\"") != -1:
                    skip_section = false
                    section = "ext_resource_script"
                    out.append(line)
                    continue
                # Drop other [ext_resource ...] blocks (non-script sub-asset refs).
                if stripped.begins_with("[ext_resource"):
                    skip_section = true
                    section = "ext_resource_other"
                    continue
                # Drop [sub_resource ...] blocks entirely (regenerated at load).
                if stripped.begins_with("[sub_resource"):
                    skip_section = true
                    section = "sub_resource"
                    continue
                skip_section = false
                section = stripped
                # Keep [gd_resource ...] header (with load_steps stripped — see
                # below) and [resource] header; everything else (per-Control entry
                # sections Godot may emit) is dropped.
                if stripped.begins_with("[gd_resource"):
                    # Cycle 4 N5: strip `load_steps=N` so Godot recomputes on load.
                    # Preserved block count (gd_resource + maybe-1 ext_resource_script
                    # + resource) typically differs from the originally-serialized
                    # count, and a stale load_steps causes Godot to reject the file.
                    var cleaned_header := _strip_load_steps_attr(line)
                    out.append(cleaned_header)
                elif stripped == "[resource]":
                    out.append(line)
                continue
            if skip_section:
                continue
            if section == "[resource]":
                if stripped == "":
                    # collapse blank lines inside [resource] — final assembly re-adds spacing
                    continue
                # Cycle 4 N5: preserve script linkage lines inside [resource]
                # (form-2 serialization). These are NOT in EXPORT_KEYS — detect by
                # prefix match. Pattern matches `script = ExtResource("id")` and
                # `script_class = "NeoCadeTheme"` (Godot may use either or both).
                if stripped.begins_with("script = ExtResource(") or stripped.begins_with("script_class ="):
                    out.append(line)
                    continue
                # Keep whitelisted @export property assignments.
                var key := stripped.split("=", true, 1)[0].strip_edges()
                if EXPORT_KEYS.has(key):
                    out.append(line)
                # Otherwise (theme_data/..., SubResource(...) refs, etc.) drop.
                continue
            # Pre-[gd_resource] preamble: Godot rarely emits content here; pass-through.
            if section == "":
                out.append(line)

        var final_text := "\n".join(out)
        # Ensure trailing newline.
        if not final_text.ends_with("\n"):
            final_text += "\n"

        var dst := FileAccess.open(path, FileAccess.WRITE)
        assert(dst != null, "strip: cannot open %s for write" % path)
        dst.store_string(final_text)
        dst.close()

        var size := FileAccess.get_file_as_bytes(path).size()
        assert(size < 2048,
            "N4 strip regression: %s post-strip size %d bytes >= 2048 (SC#6 < 2 KiB violated)"
                % [path, size])
        print("✓ Stripped theme entries from %s — %d bytes (data-only)." % [path, size])

    ## Cross-AI Cycle 4 N5 Fix helper — strip the `load_steps=N` attribute (and any
    ## surrounding whitespace) from a `[gd_resource ...]` header line. Returns the
    ## header with `load_steps` removed; Godot recomputes the value on load.
    ## Examples:
    ##   `[gd_resource type="Theme" load_steps=42 format=3 uid="uid://..."]`
    ##   → `[gd_resource type="Theme" format=3 uid="uid://..."]`
    ##   `[gd_resource type="NeoCadeTheme" format=3]`
    ##   → `[gd_resource type="NeoCadeTheme" format=3]` (no-op when absent)
    static func _strip_load_steps_attr(header_line: String) -> String:
        # Match ` load_steps=<digits>` (with leading space) OR `load_steps=<digits> `
        # (with trailing space). Use regex for both cases.
        var rx := RegEx.new()
        rx.compile(r"\s*load_steps=\d+")
        var cleaned: String = rx.sub(header_line, "", true)
        # Tidy any double-space introduced by removal.
        var rx2 := RegEx.new()
        rx2.compile(r" {2,}")
        cleaned = rx2.sub(cleaned, " ", true)
        return cleaned

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
    - **Cross-AI Cycle 3 N4 Fix A:** `_phase4_import.gd` contains a `static func _strip_theme_entries(path: String) -> void:` declaration.
    - **Cross-AI Cycle 3 N4 Fix A:** `_save_pulse_tres()` body invokes `_strip_theme_entries(path)` AFTER `ResourceSaver.save(...)` and AFTER the C6 first-line capture.
    - **Cross-AI Cycle 3 N4 Fix A:** `_strip_theme_entries()` body contains a `EXPORT_KEYS` array with all 9 export property names AND a `[sub_resource` skip branch AND a `< 2048` post-strip size assertion.
    - **Cross-AI Cycle 4 N5 Fix:** `_strip_theme_entries()` body contains a branch that PRESERVES `[ext_resource type="Script" ...]` blocks (detected via `begins_with("[ext_resource")` AND `find("type=\"Script\"") != -1`) — these blocks are appended to `out` rather than skipped.
    - **Cross-AI Cycle 4 N5 Fix:** `_strip_theme_entries()` body contains a branch inside the `[resource]` section that PRESERVES lines beginning with `script = ExtResource(` OR `script_class =` — these lines are appended to `out` rather than dropped (form-2 script linkage).
    - **Cross-AI Cycle 4 N5 Fix:** `_strip_theme_entries()` body invokes `_strip_load_steps_attr(line)` on the `[gd_resource ...]` header line before appending it (preserved-block count differs from originally-serialized; stale `load_steps` causes Godot to reject the file).
    - **Cross-AI Cycle 4 N5 Fix:** `_phase4_import.gd` contains a `static func _strip_load_steps_attr(header_line: String) -> String:` declaration that removes the `load_steps=<digits>` attribute (use a `RegEx` substitution).
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
    - **Cross-AI Cycle 3 N4 fix:** File contains NO `[sub_resource` blocks (stripped post-save) AND no `theme_data/` lines (the strip pass drops all regenerated entries).
    - **Cross-AI Cycle 3 N4 fix:** File post-strip size is < 2048 bytes (data-only; SC#6 satisfied).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$h='addons/neocade_theme/_phase4_import.gd'; if (-not (Test-Path $h)) { throw '_phase4_import.gd missing — Plan 04-02 must run first' }; $hg=Get-Content -Raw $h; foreach($n in 'func _save_pulse_tres() -> void:','NeoCadeTheme.new()','base_color = Color(\"#151A2E\")','accent_color = Color(\"#8BFF6A\")','ResourceSaver.save(pulse, \"res://addons/neocade_theme/pulse_neocade_theme.tres\")','_save_pulse_tres()','static func _strip_theme_entries(path: String) -> void:','_strip_theme_entries(path)','EXPORT_KEYS','[sub_resource','< 2048','[ext_resource','type=\"Script\"','script = ExtResource(','script_class =','_strip_load_steps_attr','static func _strip_load_steps_attr(header_line: String) -> String:','load_steps=') { if ($hg -notmatch [regex]::Escape($n)) { throw \"_phase4_import.gd missing: $n\" } }; $p='addons/neocade_theme/pulse_neocade_theme.tres'; if (-not (Test-Path $p)) { throw 'pulse_neocade_theme.tres missing — run _phase4_import.gd' }; $g=Get-Content -Raw $p; foreach($n in '[gd_resource','format=3','[resource]','base_color = Color(0.0823529, 0.101961, 0.180392, 1)','accent_color = Color(0.545098, 1, 0.415686, 1)','raised = false','platform = 2','corner_radius = 0','spacing = 18','raised_strength = 3','focus_thickness = 2','outline_width = 1') { if ($g -notmatch [regex]::Escape($n)) { throw \"pulse .tres missing: $n\" } }; if ($g -notmatch 'NeoCadeTheme') { throw 'NeoCadeTheme reference missing in pulse .tres header' }; if ($g -match '\\[sub_resource') { throw 'N4 fix regression: pulse .tres contains [sub_resource ...] blocks (strip pass did not run)' }; if ($g -match 'theme_data/') { throw 'N4 fix regression: pulse .tres contains theme_data/ lines (strip pass did not run)' }; if ($g -match 'load_steps=') { throw 'N5 fix regression: pulse .tres header still contains load_steps= attribute (should be stripped so Godot recomputes on load)' }; $size=(Get-Item $p).Length; if ($size -ge 2048) { throw \"N4 fix regression: file size $size bytes >= 2048 (SC#6 < 2 KiB violated)\" }"
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
    6. **Cross-AI Cycle 2 C1 fix — CANONICAL_SLOT_NAMES iteration.** For every `(theme_type, data_type, slot_name)` tuple frozen in `CANONICAL_SLOT_NAMES` (Plan 04-05 Task 2.5), assert the matching `theme.has_stylebox/color/constant/font_size/icon(slot_name, theme_type)` returns true. This catches wrong slot names that would otherwise pass row-count checks.
    7. `TYPE_VARIATIONS.size() == 14` exactly (Cross-AI Cycle 1 C4 fix — was previously 13; CodeLabel restored).
    8. Every TYPE_VARIATIONS key returns `get_type_variation_base()` == its base type.
    9. `is_light` is `false` (Pulse base `#151A2E` luminance < 0.5).
    10. Spot-check derived values: `theme.get_stylebox("normal", "Button")` returns a non-null StyleBoxFlat; `theme.get_color("font_color", "Label")` is a non-default Color; `theme.has_font("font", "HeaderLarge")` is true; `theme.has_font("font", "CodeLabel")` is true.
    11. Toggling `raised = true` produces `Button.normal.shadow_size > 0` (per Plan 04-05 BINDING_TABLE `raised_intensity = 1` for Button.normal — Cross-AI Cycle 1 MEDIUM reconcile fix).
    12. **Cross-AI Cycle 2 M2 fix — platform margin observable change.** Toggling `platform = MOBILE` then `platform = DESKTOP` on the loaded `.tres` produces measurably different `Button.normal` `content_margin_left` values (MOBILE > DESKTOP), proving `tokens.densityScale` + `tokens.tapPadding` reach the stylebox layer.
    13. **Cross-AI Cycle 2 L2 fix — cross-direction differentiation smoke test.** Load `slate_neocade_theme.tres` (when Plan 04-07 has shipped it; OR construct a transient in-memory NeoCadeTheme with `base_color = Color("#111820")`) and assert its `_resolve_direction_presets().spread_factor` differs from Pulse's 1.3 (Slate's 0.7). This catches hex-key float round-trip silent-fallback regressions where all directions collapse to DEFAULT (1.0).
    14. **Cross-AI Cycle 2 C2 fix — disabled alpha sourced from presets.** Assert that `theme.get_color("font_disabled_color", "Button").a` equals Pulse's `disabled_opacity` (0.42), NOT 0.38. Catches regressions where the recipe still hard-codes 0.38.

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

        # 2b. Cross-AI Cycle 2 C1 fix — CANONICAL_SLOT_NAMES iteration.
        # Iterate the frozen slot-name table from Plan 04-05 Task 2.5 and assert each declared
        # slot exists on the loaded theme. Catches wrong slot names that pass row-count checks.
        var canonical_slots = theme.get_script().get_script_constant_map().get("CANONICAL_SLOT_NAMES", {})
        assert(canonical_slots.size() >= 22, "CANONICAL_SLOT_NAMES freeze coverage too small: %d (expected >= 22)" % canonical_slots.size())
        for theme_type in canonical_slots.keys():
            var by_data_type: Dictionary = canonical_slots[theme_type]
            for dt in by_data_type.keys():
                var slot_list: Array = by_data_type[dt]
                for slot_name in slot_list:
                    var present := false
                    match dt:
                        "stylebox":  present = theme.has_stylebox(slot_name, theme_type)
                        "color":     present = theme.has_color(slot_name, theme_type)
                        "constant":  present = theme.has_constant(slot_name, theme_type)
                        "font_size": present = theme.has_font_size(slot_name, theme_type)
                        "icon":      present = theme.has_icon(slot_name, theme_type)
                        _: present = true  # unknown data_type — skip
                    assert(present, "CANONICAL_SLOT_NAMES freeze fail: %s.%s.%s missing" % [theme_type, dt, slot_name])

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

        # 8. Cross-AI Cycle 2 C2 fix — disabled alpha sourced from DIRECTION_PRESETS, not 0.38.
        # Pulse's DIRECTION_PRESETS sub-dict has disabled_opacity = 0.42; Button's
        # font_disabled_color recipe carries "disabled": true so its alpha equals 0.42.
        var btn_disabled: Color = theme.get_color("font_disabled_color", "Button")
        assert(abs(btn_disabled.a - 0.42) < 0.001,
            "C2 fix regression: Button.font_disabled_color.a = %f; expected Pulse's 0.42" % btn_disabled.a)

        # 9. Cross-AI Cycle 2 M2 fix — platform tokens reach stylebox margins.
        # Toggling MOBILE produces visibly larger Button.normal content_margin than DESKTOP.
        theme.platform = NeoCadeTheme.Platform.DESKTOP
        var btn_desktop: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
        var desktop_margin: int = btn_desktop.content_margin_left if btn_desktop else -1
        theme.platform = NeoCadeTheme.Platform.MOBILE
        var btn_mobile: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
        var mobile_margin: int = btn_mobile.content_margin_left if btn_mobile else -1
        assert(mobile_margin > desktop_margin,
            "M2 fix regression: MOBILE margin %d not > DESKTOP %d (densityScale/tapPadding not wired)" % [mobile_margin, desktop_margin])
        # Revert
        theme.platform = NeoCadeTheme.Platform.AUTO

        # 10. Cross-AI Cycle 2 L2 fix — cross-direction smoke test (Pulse spread != Slate spread).
        # Construct a transient Slate to verify hex-key lookup works under .tres reload.
        # If both directions resolve to DIRECTION_PRESET_DEFAULT (1.0) due to float round-trip,
        # this assertion fails — surfacing the silent-fallback regression.
        var pulse_presets: Dictionary = theme._resolve_direction_presets()
        assert(abs(pulse_presets.spread_factor - 1.3) < 0.001,
            "L2 fix: Pulse spread_factor %f != 1.3 (hex-key lookup may be falling through to DEFAULT)" % pulse_presets.spread_factor)
        var slate_test: NeoCadeTheme = NeoCadeTheme.new()
        slate_test.base_color = Color("#111820")
        var slate_presets: Dictionary = slate_test._resolve_direction_presets()
        assert(abs(slate_presets.spread_factor - 0.7) < 0.001,
            "L2 fix: Slate spread_factor %f != 0.7 (hex-key lookup may be falling through to DEFAULT)" % slate_presets.spread_factor)
        assert(abs(pulse_presets.spread_factor - slate_presets.spread_factor) > 0.5,
            "L2 fix: Pulse and Slate spread_factor too close (%f vs %f) — directions not differentiated" % [pulse_presets.spread_factor, slate_presets.spread_factor])

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

        # Cross-AI Cycle 2 C1 fix — CANONICAL_SLOT_NAMES iteration. Iterate the frozen
        # slot-name table and assert each declared slot exists on the loaded theme.
        var canonical_slots = theme.get_script().get_script_constant_map().get("CANONICAL_SLOT_NAMES", {})
        if canonical_slots.size() < 22:
            failures.append("CANONICAL_SLOT_NAMES freeze coverage too small: %d (expected >= 22)" % canonical_slots.size())
        for theme_type in canonical_slots.keys():
            var by_data_type: Dictionary = canonical_slots[theme_type]
            for dt in by_data_type.keys():
                var slot_list: Array = by_data_type[dt]
                for slot_name in slot_list:
                    var present := false
                    match dt:
                        "stylebox":  present = theme.has_stylebox(slot_name, theme_type)
                        "color":     present = theme.has_color(slot_name, theme_type)
                        "constant":  present = theme.has_constant(slot_name, theme_type)
                        "font_size": present = theme.has_font_size(slot_name, theme_type)
                        "icon":      present = theme.has_icon(slot_name, theme_type)
                        _: present = true
                    if not present:
                        failures.append("CANONICAL_SLOT_NAMES freeze fail: %s.%s.%s missing" % [theme_type, dt, slot_name])

        # Raised toggle test (Cross-AI Cycle 1 MEDIUM reconcile)
        theme.raised = true
        var raised_btn: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
        if raised_btn != null and raised_btn.shadow_size <= 0:
            failures.append("raised=true: Button.normal shadow_size %d not > 0" % raised_btn.shadow_size)
        theme.raised = false

        # Cross-AI Cycle 2 C2 fix — disabled alpha sourced from presets, not 0.38.
        var btn_disabled: Color = theme.get_color("font_disabled_color", "Button")
        if abs(btn_disabled.a - 0.42) > 0.001:
            failures.append("C2 fix regression: Button.font_disabled_color.a = %f; expected Pulse 0.42" % btn_disabled.a)

        # Cross-AI Cycle 2 M2 fix — platform tokens reach stylebox margins.
        theme.platform = NeoCadeTheme.Platform.DESKTOP
        var btn_desktop: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
        var desktop_margin: int = btn_desktop.content_margin_left if btn_desktop else -1
        theme.platform = NeoCadeTheme.Platform.MOBILE
        var btn_mobile: StyleBoxFlat = theme.get_stylebox("normal", "Button") as StyleBoxFlat
        var mobile_margin: int = btn_mobile.content_margin_left if btn_mobile else -1
        if mobile_margin <= desktop_margin:
            failures.append("M2 fix regression: MOBILE margin %d not > DESKTOP %d" % [mobile_margin, desktop_margin])
        theme.platform = NeoCadeTheme.Platform.AUTO

        # Cross-AI Cycle 2 L2 fix — Pulse vs Slate cross-direction smoke test.
        var pulse_presets: Dictionary = theme._resolve_direction_presets()
        if abs(pulse_presets.spread_factor - 1.3) > 0.001:
            failures.append("L2 fix: Pulse spread_factor %f != 1.3 (hex-key lookup falling to DEFAULT?)" % pulse_presets.spread_factor)
        var slate_test: NeoCadeTheme = NeoCadeTheme.new()
        slate_test.base_color = Color("#111820")
        var slate_presets: Dictionary = slate_test._resolve_direction_presets()
        if abs(slate_presets.spread_factor - 0.7) > 0.001:
            failures.append("L2 fix: Slate spread_factor %f != 0.7 (hex-key lookup falling to DEFAULT?)" % slate_presets.spread_factor)
        if abs(pulse_presets.spread_factor - slate_presets.spread_factor) <= 0.5:
            failures.append("L2 fix: Pulse and Slate spread_factor not differentiated (%f vs %f)" % [pulse_presets.spread_factor, slate_presets.spread_factor])

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
    - **Cross-AI Cycle 2 C1 fix:** File contains `CANONICAL_SLOT_NAMES` reference and `for theme_type in canonical_slots.keys():` loop with nested `match dt:` branches for `"stylebox"`, `"color"`, `"constant"`, `"font_size"`, `"icon"` data types.
    - **Cross-AI Cycle 2 C1 fix:** File contains the failure-message format `"CANONICAL_SLOT_NAMES freeze fail: %s.%s.%s missing"` (or close equivalent).
    - **Cross-AI Cycle 2 C2 fix:** File contains assertion that `Button.font_disabled_color.a` equals Pulse's `0.42` (literal `0.42`), NOT `0.38`.
    - **Cross-AI Cycle 2 M2 fix:** File contains `theme.platform = NeoCadeTheme.Platform.DESKTOP` AND `theme.platform = NeoCadeTheme.Platform.MOBILE` toggles + a `mobile_margin > desktop_margin` assertion.
    - **Cross-AI Cycle 2 L2 fix:** File contains the cross-direction smoke test — constructs a `slate_test: NeoCadeTheme` with `base_color = Color("#111820")` and asserts its `_resolve_direction_presets().spread_factor` differs from Pulse's by > 0.5.
    - File `addons/neocade_theme/_phase4_verify_headless.gd` exists (Cross-AI Cycle 1 MEDIUM headless fix).
    - Headless file contains `extends SceneTree` (NOT EditorScript).
    - Headless file contains `func _init() -> void:` and `quit(0)` / `quit(1)` exit paths.
    - Headless file contains `BINDING_TABLE.size() != 37` failure check and `TYPE_VARIATIONS.size() != 14` failure check.
    - **Headless file ALSO contains the same Cross-AI Cycle 2 C1/C2/M2/L2 assertions** as the EditorScript variant (CANONICAL_SLOT_NAMES iteration, 0.42 disabled-alpha check, MOBILE>DESKTOP margin check, Pulse vs Slate spread differentiation check).
    - When the headless variant is run via `godot --headless --quit --script ...`, it prints the PASS line on success and exits with status 0.
    - When the EditorScript variant is run via Godot Editor's File → Run, it completes without assertion failures.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/_phase4_verify.gd'; if (-not (Test-Path $p)) { throw '_phase4_verify.gd missing' }; $g=Get-Content -Raw $p; foreach($n in '@tool','extends EditorScript','func _run() -> void:','func _verify_pulse() -> void:','DELETE BEFORE','ResourceLoader.load(path)','loaded is NeoCadeTheme','theme.default_font != null','base_color == Color(\"#151A2E\")','accent_color == Color(\"#8BFF6A\")','raised == false','corner_radius == 0','spacing == 18','raised_strength == 3','focus_thickness == 2','outline_width == 1','is_light == false','binding_table.size() == 37','type_variations.size() == 14','type_variations.has(\"CodeLabel\")','theme.raised = true','theme.raised = false','theme.base_color = Color(\"#F0F0F0\")','theme.is_light == true','CANONICAL_SLOT_NAMES','for theme_type in canonical_slots.keys():','match dt:','\"stylebox\":  present = theme.has_stylebox','\"color\":     present = theme.has_color','\"constant\":  present = theme.has_constant','\"font_size\": present = theme.has_font_size','\"icon\":      present = theme.has_icon','CANONICAL_SLOT_NAMES freeze fail','0.42','NeoCadeTheme.Platform.DESKTOP','NeoCadeTheme.Platform.MOBILE','mobile_margin > desktop_margin','slate_test: NeoCadeTheme','Color(\"#111820\")','spread_factor') { if ($g -notmatch [regex]::Escape($n)) { throw \"_phase4_verify.gd missing: $n\" } }; $h='addons/neocade_theme/_phase4_verify_headless.gd'; if (-not (Test-Path $h)) { throw '_phase4_verify_headless.gd missing (Cross-AI Cycle 1 MEDIUM)' }; $hg=Get-Content -Raw $h; foreach($n in 'extends SceneTree','func _init() -> void:','ResourceLoader.load(path)','loaded is NeoCadeTheme','binding_table.size() != 37','type_variations.size() != 14','type_variations.has(\"CodeLabel\")','quit(0)','quit(1)','DELETE BEFORE','CANONICAL_SLOT_NAMES','for theme_type in canonical_slots.keys():','CANONICAL_SLOT_NAMES freeze fail','0.42','NeoCadeTheme.Platform.DESKTOP','NeoCadeTheme.Platform.MOBILE','mobile_margin <= desktop_margin','slate_test: NeoCadeTheme','Color(\"#111820\")','spread_factor') { if ($hg -notmatch [regex]::Escape($n)) { throw \"_phase4_verify_headless.gd missing: $n\" } }"
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
    feat(04-06): ship Pulse .tres (Godot-serialized + stripped) + dual verification helpers

    Plan 04-06 wave-3 (depends on Plans 04-04, 04-05; Cross-AI Cycle 1, Cycle 2,
    Cycle 3 fixes):
    - C6 fix: addons/neocade_theme/pulse_neocade_theme.tres — generated via
      _phase4_import.gd ResourceSaver.save() pass; header is whatever Godot
      4.6 emits for NeoCadeTheme (canonical for Plan 04-07 peer .tres files)
    - N4 fix (Cycle 3): _save_pulse_tres() now invokes _strip_theme_entries(path)
      AFTER ResourceSaver.save() — strips [sub_resource] blocks + theme_data/
      entries, keeps only the [gd_resource ...] header (C6) + the 9 @export
      property lines on [resource]. Saved .tres stays data-oriented per SC#6;
      regenerated baseline entries recomputed at load time. Post-strip size
      asserted < 2048 bytes (2 KiB).
    - N5 fix (Cycle 4): _strip_theme_entries() now PRESERVES script linkage
      so the file loads as NeoCadeTheme (not plain Theme). Specifically:
      (a) [ext_resource type="Script" ...] blocks are kept (form-2 serialization);
      (b) `script = ExtResource(...)` and `script_class = ...` lines inside
      [resource] are kept; (c) load_steps=N is stripped from the [gd_resource]
      header so Godot recomputes on load (preserved-block count differs from
      originally-serialized count). Other [ext_resource ...] blocks (non-script)
      are still dropped — defensive against future sub-asset refs.
    - addons/neocade_theme/_phase4_import.gd — extended with _save_pulse_tres()
      AND with the static _strip_theme_entries(path) helper (N4 Fix A) AND with
      the static _strip_load_steps_attr(header_line) RegEx helper (N5 Fix)
    - addons/neocade_theme/_phase4_verify.gd — EditorScript helper; asserts
      BINDING_TABLE.size() == 37 (C1), TYPE_VARIATIONS.size() == 14 (C4),
      CodeLabel present, theme.default_font set (C3), explicit header fonts,
      raised toggle behavior, is_light flip on #F0F0F0; DELETED IN PHASE 11.
    - addons/neocade_theme/_phase4_verify_headless.gd — SceneTree-based variant
      runs via `godot --headless --quit --script ...` for autonomous CI
      verification (Cross-AI Cycle 1 MEDIUM); DELETED IN PHASE 11.
    - Cycle 2 C1 fix: BOTH verifiers now iterate CANONICAL_SLOT_NAMES (Plan
      04-05 Task 2.5) and assert each frozen slot exists per Control type —
      catches wrong slot names that would pass row-count checks alone.
    - Cycle 2 C2 fix: BOTH verifiers assert Button.font_disabled_color.a ==
      0.42 (Pulse's DIRECTION_PRESETS.disabled_opacity), NOT 0.38.
    - Cycle 2 M2 fix: BOTH verifiers toggle MOBILE/DESKTOP and assert
      Button.normal content_margin_left differs (densityScale + tapPadding
      reach the stylebox layer in Plan 04-05 _resolve_recipe).
    - Cycle 2 L2 fix: BOTH verifiers construct an in-memory Slate (#111820)
      and assert its spread_factor (0.7) differs from Pulse's (1.3) by > 0.5
      — catches hex-key float round-trip silent-fallback regressions.

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
