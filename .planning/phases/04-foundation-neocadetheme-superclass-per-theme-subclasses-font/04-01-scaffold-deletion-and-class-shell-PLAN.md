---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - addons/neocade_theme/neocade_theme.tres
  - addons/neocade_theme/neocade_theme.gd
  - main.tscn
autonomous: true
requirements:
  - FOUND-01
  - FOUND-02
  - TOKEN-05
  - TOKEN-07
must_haves:
  truths:
    - "`addons/neocade_theme/neocade_theme.tres` is DELETED — the empty scaffold from project init is gone."
    - "`addons/neocade_theme/neocade_theme.gd` declares `@tool class_name NeoCadeTheme extends Theme` with all 9 `@export` properties: 4 Core (`base_color: Color`, `accent_color: Color`, `raised: bool`, `platform: Platform`) and 5 Shape under `@export_group(\"Shape\")` (`corner_radius: int`, `spacing: int`, `raised_strength: int`, `focus_thickness: int`, `outline_width: int`)."
    - "Class declares `enum Platform { DESKTOP, MOBILE, AUTO }` and a non-exported `is_light: bool` field."
    - "Every `@export` setter fires `_regenerate_theme()` and applies an equality short-circuit to avoid no-op regenerations."
    - "`_regenerate_theme()` exists with a skeleton body that sets `is_light = base_color.get_luminance() >= 0.5` and uses a reentry guard `_regenerating: bool`. NO `clear()` call anywhere in the regeneration path (D-01)."
    - "Class header docstring documents the binding-mechanism choice (slot-name + property-name table compiled into `.gd`) as REVISABLE per CONTEXT.md `<specifics>` and D-03."
    - "`main.tscn` no longer references the deleted `neocade_theme.tres`; both the `[ext_resource ...]` line for the scaffold and the `theme = ExtResource(...)` property line on the root Control block are REMOVED entirely (Cycle 6 F2 fix 2026-05-06: no placeholder comment — Godot 4.6 .tscn comments use `;` not `#`, AND comments are discarded on save, so the placeholder strategy is fragile per `engine_details/file_formats/tscn.md`). The root `[node ...]` block parses cleanly without a `theme` line at all. Plan 04-07 reintroduces a live `theme = ExtResource(\"1_pulse_theme\")` property line pointing at Pulse. The scene loads without a missing-resource error during Plans 04-02..06."
    - "Class defaults match DESIGN_TOKENS §3 / CONTEXT.md D-13 sensible-neutral values (NOT Pulse-flavored): `base_color=#111820`, `accent_color=#8BD3FF`, `raised=false`, `platform=AUTO`, `corner_radius=12`, `spacing=4`, `raised_strength=3`, `focus_thickness=2`, `outline_width=1`."
  artifacts:
    - addons/neocade_theme/neocade_theme.gd
    - main.tscn (theme override cleared)
  key_links:
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md D-01, D-13, D-14, <specifics>"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md §3, §4, §10.1"
    - ".planning/DESIGN_TOKENS.md §3, §4.1, §4.2, §4.3, §4.4, §12.2"
    - ".planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd (structural reference; do NOT copy clear())"
---

<objective>
Delete the empty `addons/neocade_theme/neocade_theme.tres` scaffold; clear the broken theme reference from `main.tscn`; author the production `addons/neocade_theme/neocade_theme.gd` class shell with all 9 `@export` properties, the Platform enum, the `is_light` derivation, the reentry-guarded `_regenerate_theme()` skeleton, and the class-header docstring documenting the binding mechanism as revisable.

Purpose: unblock all subsequent Phase 4 work by establishing the file presence + class shape that Plans 04-04 / 04-05 / 04-06 / 04-07 build on.
Output: 1 deleted file, 1 modified scene, 1 new GDScript class shell.
</objective>

<execution_context>
@$HOME/.codex/get-shit-done/workflows/execute-plan.md
@$HOME/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
@.planning/REQUIREMENTS.md
@.planning/DESIGN_TOKENS.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md
@.planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd
@.planning/spikes/dynamic-theme/VERIFY-RESULTS.md

<interfaces>
Files to create:
- `addons/neocade_theme/neocade_theme.gd` — the production class shell.

Files to delete:
- `addons/neocade_theme/neocade_theme.tres` — empty scaffold from project init (per DESIGN_TOKENS §12.2 + CONTEXT.md D-14 step 1).

Files to modify:
- `main.tscn` — remove the broken `theme = ExtResource(...)` reference to the deleted scaffold. Plan 04-07 will reassign `pulse_neocade_theme.tres`.

The class shell is intentionally MINIMAL in this plan. The full `_regenerate_theme()` body lands in Plans 04-04 (formulas) + 04-05 (binding-table walk + variations + icons). This plan creates only the file presence + shape so Wave 1 parallel plans (04-02 fonts, 04-03 icons) can land without depending on engine code.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Delete the empty scaffold root .tres and clear main.tscn theme reference</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.tres
    - main.tscn
    - .planning/DESIGN_TOKENS.md  (§12.2 — Files Phase 4 MUST delete)
  </read_first>
  <files>
    - addons/neocade_theme/neocade_theme.tres (DELETE)
    - main.tscn (modify — remove theme override + ext_resource line for the deleted scaffold)
  </files>
  <action>
    Step 1. Inspect `main.tscn` to find the `[ext_resource ...]` line referencing `neocade_theme.tres` and the `theme = ExtResource("...")` property line on the root Control. Capture both verbatim for the delete operation.

    Step 2. Delete the file at `addons/neocade_theme/neocade_theme.tres` from the working tree (using `git rm` so the deletion is staged).

    Step 3. Edit `main.tscn` (Cycle 6 F2 fix 2026-05-06: no placeholder comment, just remove both lines cleanly):
      a) DELETE the `[ext_resource type="Theme" uid="..." path="res://addons/neocade_theme/neocade_theme.tres" id="..."]` line entirely (the dangling reference must go).
      b) DELETE the `theme = ExtResource("...")` property line from the root `[node ...]` Control block entirely. Do NOT replace with a placeholder comment.

       Rationale: Godot 4.6 `.tscn` files use `;` (semicolon), not `#` (hash), for single-line comments per `engine_details/file_formats/tscn.md` ("A TSCN file may contain single-line comments starting with a semicolon (;)"). Beyond syntax, comments are DISCARDED on save by Godot's parser — any placeholder comment vanishes the first time a user opens and saves the scene in the editor, which makes the placeholder strategy brittle. The cleanest contract is: remove the line entirely; the `[node ...]` block remains valid `.tscn` without a `theme` property; Plan 04-07 re-adds the live `theme = ExtResource("1_pulse_theme")` line pointing at Pulse. The scene parses and loads without missing-resource errors.

       Result: `main.tscn` opens cleanly in Godot Editor without a "missing resource" error and without any reference to the deleted scaffold. No placeholder comment — Plan 04-07 reintroduces the line.

    Step 4. Verify both file states via PowerShell test commands.

    NOTE: this scaffold is line-1 `[gd_resource type="Theme" format=3 uid="uid://dyblavdboqhji"]` + line-3 `[resource]` (already verified). It carries no theme content. Deletion is non-destructive.
  </action>
  <acceptance_criteria>
    - `addons/neocade_theme/neocade_theme.tres` does not exist (PowerShell `Test-Path` returns `False`).
    - `main.tscn` does not contain the literal substring `neocade_theme.tres` anywhere in the file.
    - `main.tscn` does not contain ANY `theme = ExtResource(` line (Cycle 6 F2 fix: line removed entirely, no placeholder comment — Godot discards comments on save).
    - `main.tscn` does not contain a placeholder `# theme = ExtResource` or `; theme = ExtResource` comment line referencing the removal (the line is gone, not commented).
    - `main.tscn` parses as a valid `.tscn` (the file's first line is `[gd_scene ...]` and the root node block is intact).
    - Git status shows `D addons/neocade_theme/neocade_theme.tres` and `M main.tscn`.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "if (Test-Path 'addons/neocade_theme/neocade_theme.tres') { throw 'scaffold .tres still exists' }; $tscn = Get-Content -Raw 'main.tscn'; if ($tscn -match 'neocade_theme\.tres') { throw 'main.tscn still references deleted scaffold (Cycle 6 F2: line must be removed entirely, no placeholder)' }; if ($tscn -match 'theme = ExtResource\(') { throw 'main.tscn still has theme override line (Cycle 6 F2: line must be removed entirely, not commented)' }; if ($tscn -match '(?m)^\s*[#;]\s*theme = ExtResource') { throw 'main.tscn still has placeholder comment for theme override (Cycle 6 F2: must be removed, not commented — Godot discards comments on save)' }; if ($tscn -notmatch '^\[gd_scene') { throw 'main.tscn is not a valid scene file' }"
    </automated>
  </verify>
  <done>The scaffold `.tres` is deleted; `main.tscn` no longer references it; the scene file remains parseable.</done>
</task>

<task type="auto">
  <name>Task 2: Author the NeoCadeTheme class shell at addons/neocade_theme/neocade_theme.gd</name>
  <read_first>
    - .planning/DESIGN_TOKENS.md  (§4.1 the 9 @export properties; §4.2 naming discipline; §4.3 is_light; §4.4 lifecycle)
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md  (D-01, D-13, <specifics>)
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md  (§3 deserialization order, §4 reentry guard, §8 minimal shape)
    - .planning/spikes/dynamic-theme/SpikeNeoCadeTheme.gd  (structural reference; do NOT copy clear() or backing-field pattern)
  </read_first>
  <files>addons/neocade_theme/neocade_theme.gd</files>
  <action>
    Create `addons/neocade_theme/neocade_theme.gd` with EXACTLY this top-level structure (the inner method bodies are placeholders for now; Plans 04-04 / 04-05 fill in the formula and binding-table logic):

    ```gdscript
    @tool
    class_name NeoCadeTheme
    extends Theme

    ## NeoCade Theme — single concrete `@tool extends Theme` class for the NeoCade addon.
    ##
    ## Architecture (locked 2026-05-06f, D-31): one concrete instantiable class + N data-only `.tres`
    ## peers at `addons/neocade_theme/{name}_neocade_theme.tres`. Per-direction unique mood lives in
    ## Theme Editor entry overrides per `.tres`, NOT in additional `@export` properties.
    ##
    ## Setters on every `@export` property trigger `_regenerate_theme()`, which walks an internal
    ## BINDING_TABLE (Plan 04-05) to populate every formula-owned theme entry. Slots NOT in the
    ## binding table are LEFT UNTOUCHED (D-04 escape hatch — Theme Editor authored content survives).
    ##
    ## Binding mechanism (D-03 TENTATIVE): the current implementation uses a slot-name + property-name
    ## table compiled into this file. The user has signaled this may be revised toward a property-name
    ## convention or a metadata-tagged Resource model post-Phase-4. **This implementation is REVISABLE
    ## without breaking the public `@export` surface or the `.tres` file format** — only the internal
    ## binding mechanism would change.
    ##
    ## See: .planning/DESIGN_TOKENS.md, .planning/phases/04-.../04-RESEARCH.md, .planning/phases/04-.../04-CONTEXT.md.

    enum Platform { DESKTOP, MOBILE, AUTO }

    # ─── Core exports (DESIGN_TOKENS §4.1 rows 1-4) ─────────────────────────────────────────────
    @export var base_color: Color = Color("#111820"):
        set(value):
            if base_color == value: return
            base_color = value
            _regenerate_theme()

    @export var accent_color: Color = Color("#8BD3FF"):
        set(value):
            if accent_color == value: return
            accent_color = value
            _regenerate_theme()

    @export var raised: bool = false:
        set(value):
            if raised == value: return
            raised = value
            _regenerate_theme()

    @export var platform: Platform = Platform.AUTO:
        set(value):
            if platform == value: return
            platform = value
            _regenerate_theme()

    # ─── Shape exports (DESIGN_TOKENS §4.1 rows 5-9) ────────────────────────────────────────────
    @export_group("Shape")

    @export var corner_radius: int = 12:
        set(value):
            if corner_radius == value: return
            corner_radius = value
            _regenerate_theme()

    @export var spacing: int = 4:
        set(value):
            if spacing == value: return
            spacing = value
            _regenerate_theme()

    @export var raised_strength: int = 3:
        set(value):
            if raised_strength == value: return
            raised_strength = value
            _regenerate_theme()

    @export var focus_thickness: int = 2:
        set(value):
            if focus_thickness == value: return
            focus_thickness = value
            _regenerate_theme()

    @export var outline_width: int = 1:
        set(value):
            if outline_width == value: return
            outline_width = value
            _regenerate_theme()

    # ─── Internal state (NOT exported) ──────────────────────────────────────────────────────────
    var is_light: bool = false  # derived from base_color.get_luminance() at every regenerate
    var _regenerating: bool = false  # reentry guard (per RESEARCH.md §4)
    var _last_regeneration_usec: int = 0  # diagnostic; logged via Output in editor

    func _init() -> void:
        _regenerate_theme()

    func _regenerate_theme() -> void:
        if _regenerating: return
        _regenerating = true
        var t0 := Time.get_ticks_usec()

        is_light = base_color.get_luminance() >= 0.5

        # SKELETON ONLY — Plans 04-04 (formulas) and 04-05 (binding-table walk) populate this body.
        # NO `clear()` call permitted in this method per D-01 (additive iteration).

        _last_regeneration_usec = Time.get_ticks_usec() - t0
        _regenerating = false
    ```

    Constraints (re-emphasized for verification):
    - The string `clear()` MUST NOT appear inside `_regenerate_theme()` or any helper it calls. The skeleton has no helpers yet, but the comment placeholder reminds future plans.
    - The 9 `@export` properties must appear in EXACTLY the order shown (Core 4 first, then Shape 5 under `@export_group("Shape")`).
    - Default values must EXACTLY match DESIGN_TOKENS §3 / CONTEXT.md D-13: `#111820`, `#8BD3FF`, `false`, `AUTO`, `12`, `4`, `3`, `2`, `1`.
    - `is_light` is `var`, NOT `@export var` — it's computed, not user-set.
    - Class-header docstring must contain the literal substrings: `REVISABLE`, `D-03`, `D-31`, `D-04 escape hatch`, `binding`. (Anchors for grep verification.)
  </action>
  <acceptance_criteria>
    - File `addons/neocade_theme/neocade_theme.gd` exists.
    - File begins with `@tool` on line 1, `class_name NeoCadeTheme` on line 2, `extends Theme` on line 3 (in some order on lines 1-3 if formatter prefers `extends Theme` second; the three tokens MUST all be present in the first 3 non-blank non-comment lines).
    - File contains the literal string `enum Platform { DESKTOP, MOBILE, AUTO }`.
    - File contains 9 `@export` declarations: `@export var base_color`, `@export var accent_color`, `@export var raised`, `@export var platform`, `@export var corner_radius`, `@export var spacing`, `@export var raised_strength`, `@export var focus_thickness`, `@export var outline_width`. Order: 4 Core then 5 Shape.
    - File contains `@export_group("Shape")` exactly once, between the Core block and the Shape block.
    - File contains the literal default-value strings: `Color("#111820")`, `Color("#8BD3FF")`, ` = false`, ` = Platform.AUTO`, ` = 12`, ` = 4`, ` = 3`, ` = 2`, ` = 1` (the `corner_radius = 12` etc.).
    - File contains a non-exported `var is_light: bool` declaration (NOT `@export var is_light`).
    - File contains a non-exported `var _regenerating: bool` declaration.
    - File contains exactly one `func _regenerate_theme() -> void:` definition.
    - The body of `_regenerate_theme()` contains `if _regenerating: return` and `_regenerating = true` and `_regenerating = false`.
    - The body of `_regenerate_theme()` contains `is_light = base_color.get_luminance() >= 0.5`.
    - The string `clear()` does NOT appear in the file (case-sensitive grep — the skeleton enforces D-01 from day 1).
    - File contains `func _init() -> void:` calling `_regenerate_theme()`.
    - Each of the 9 `@export` setters contains an equality short-circuit (the substring `if ` followed by the property name followed by ` == value: return` appears for every property).
    - Class-header docstring contains all of: `REVISABLE`, `D-03`, `D-31`, `D-04 escape hatch`, `binding`.
    - Godot Editor parses the file without errors (Godot's GDScript parser; verified by opening the file in editor or running `godot --check-only` if the binary supports it; manual verification via `godot --headless --quit` is acceptable).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/neocade_theme.gd'; if (-not (Test-Path $p)) { throw 'file missing' }; $g=Get-Content -Raw $p; foreach($n in '@tool','class_name NeoCadeTheme','extends Theme','enum Platform { DESKTOP, MOBILE, AUTO }','@export var base_color','@export var accent_color','@export var raised','@export var platform','@export_group(\"Shape\")','@export var corner_radius','@export var spacing','@export var raised_strength','@export var focus_thickness','@export var outline_width','Color(\"#111820\")','Color(\"#8BD3FF\")','Platform.AUTO','var is_light: bool','var _regenerating: bool','func _regenerate_theme() -> void:','if _regenerating: return','_regenerating = true','_regenerating = false','is_light = base_color.get_luminance() >= 0.5','func _init() -> void:','REVISABLE','D-03','D-31','D-04 escape hatch','binding') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing required substring: $n\" } }; if ($g -match '\\bclear\\(\\)') { throw 'clear() call found — D-01 forbids' }; foreach($prop in 'base_color','accent_color','raised','platform','corner_radius','spacing','raised_strength','focus_thickness','outline_width') { if ($g -notmatch ('if ' + $prop + ' == value: return')) { throw \"missing equality short-circuit for $prop\" } }"
    </automated>
  </verify>
  <done>The class shell exists with all 9 @exports, the Platform enum, is_light, the reentry guard, the no-clear() invariant, and the revisability docstring — ready for Wave 2 to fill the formula + iteration body.</done>
</task>

<task type="auto">
  <name>Task 3: Atomic commit — scaffold deletion + class shell</name>
  <read_first>
    - addons/neocade_theme/neocade_theme.gd
    - main.tscn
  </read_first>
  <files>(commit only — no file edits)</files>
  <action>
    Stage the three changes (deletion + scene edit + new file) and commit as a single atomic Phase 4 / Plan 01 commit so the working tree never holds a half-applied state. Use the message:

    ```
    feat(04-01): delete scaffold .tres + scene ref + author NeoCadeTheme class shell

    Plan 04-01 wave-1 foundation (Cycle 6 F2 fix incorporated 2026-05-06):
    - Deleted addons/neocade_theme/neocade_theme.tres (empty scaffold from project init)
    - Removed main.tscn theme override + ext_resource lines entirely (no placeholder
      comment — Godot 4.6 .tscn comments use `;` not `#` AND comments are discarded
      on save per engine_details/file_formats/tscn.md). Plan 04-07 reassigns Pulse.
    - Authored addons/neocade_theme/neocade_theme.gd with @tool class_name NeoCadeTheme
      extends Theme, 9 @export properties (4 Core + 5 Shape), Platform enum, is_light
      derivation, _regenerating reentry guard, no-clear() invariant, binding-mechanism
      revisability docstring per CONTEXT.md D-03

    Refs: FOUND-01 (partial — addon layout), FOUND-02 (partial — class shape)
    Plan: 04-01
    ```

    Run `git add` for the three paths, then `git commit -m "..."`. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-01):`.
    - `git log -1 --name-status` shows the three expected entries: `D addons/neocade_theme/neocade_theme.tres`, `M main.tscn`, `A addons/neocade_theme/neocade_theme.gd`.
    - `git status --porcelain` is empty for all three files (no leftover staged/unstaged changes).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-01\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; if ($ns -notmatch 'D\\s+addons/neocade_theme/neocade_theme\\.tres') { throw 'commit missing scaffold deletion' }; if ($ns -notmatch 'M\\s+main\\.tscn') { throw 'commit missing main.tscn modification' }; if ($ns -notmatch 'A\\s+addons/neocade_theme/neocade_theme\\.gd') { throw 'commit missing new class shell' }; $st = git status --porcelain | Where-Object { $_ -match 'addons/neocade_theme/neocade_theme\\.(tres|gd)|main\\.tscn' }; if ($st) { throw \"unexpected leftover changes: $st\" }"
    </automated>
  </verify>
  <done>The atomic commit lands; the working tree is clean for the three Plan 04-01 paths.</done>
</task>

</tasks>
