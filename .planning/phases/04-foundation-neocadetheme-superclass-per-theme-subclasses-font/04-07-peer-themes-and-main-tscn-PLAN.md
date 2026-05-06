---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 07
type: execute
wave: 4
depends_on:
  - "04-06"
files_modified:
  - addons/neocade_theme/slate_neocade_theme.tres
  - addons/neocade_theme/bubble_neocade_theme.tres
  - addons/neocade_theme/daybreak_neocade_theme.tres
  - addons/neocade_theme/burst_neocade_theme.tres
  - main.tscn
autonomous: true
requirements:
  - FOUND-03
must_haves:
  truths:
    - "`addons/neocade_theme/slate_neocade_theme.tres` exists, is `[gd_resource type=\"NeoCadeTheme\"]`, with §5.2 values: base=#111820, accent=#8BD3FF, raised=false, platform=AUTO, corner_radius=14, spacing=22, raised_strength=2, focus_thickness=2, outline_width=1."
    - "`addons/neocade_theme/bubble_neocade_theme.tres` exists with §5.3 values: base=#241326, accent=#FFB3E6, raised=false, platform=AUTO, corner_radius=26, spacing=22, raised_strength=6, focus_thickness=3, outline_width=1."
    - "`addons/neocade_theme/daybreak_neocade_theme.tres` exists with §5.4 values: base=#0B2420, accent=#76F2D1, raised=false, platform=AUTO, corner_radius=8, spacing=24, raised_strength=3, focus_thickness=2, outline_width=1."
    - "`addons/neocade_theme/burst_neocade_theme.tres` exists with §5.5 values: base=#20112E, accent=#FFD166, raised=false, platform=AUTO, corner_radius=18, spacing=22, raised_strength=5, focus_thickness=3, outline_width=1."
    - "Each peer `.tres` references `addons/neocade_theme/neocade_theme.gd` via `[ext_resource type=\"Script\"]`."
    - "Loading any of the 4 peer `.tres` produces a `NeoCadeTheme` instance with `_regenerate_theme()` populating all 37 BINDING_TABLE Controls + 13 type variations (same engine as Pulse; only `@export` values differ)."
    - "`main.tscn` references `addons/neocade_theme/pulse_neocade_theme.tres` as its theme override (`theme = ExtResource(...)` on the root Control), restoring the theme that Plan 04-01 cleared."
    - "Spot-check distinct visual identity per direction: each direction's loaded theme has different `corner_radius` values (Slate=14, Bubble=26, Daybreak=8, Burst=18) reflected in `Button.normal` stylebox `corner_radius_top_left` after regenerate. (Pulse=0 already verified in Plan 04-06.)"
  artifacts:
    - addons/neocade_theme/slate_neocade_theme.tres
    - addons/neocade_theme/bubble_neocade_theme.tres
    - addons/neocade_theme/daybreak_neocade_theme.tres
    - addons/neocade_theme/burst_neocade_theme.tres
    - main.tscn (Pulse theme reassigned)
  key_links:
    - ".planning/DESIGN_TOKENS.md §5.2, §5.3, §5.4, §5.5"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md D-14 step 9"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md §12 (Plan 04-07 scope)"
---

<objective>
Author the 4 peer direction `.tres` files (Slate, Bubble, Daybreak, Burst) per DESIGN_TOKENS §5.2-§5.5, and reassign `main.tscn`'s theme override to the recommended starter `pulse_neocade_theme.tres` (Plan 04-01 cleared the override; Plan 04-06 produced Pulse; this plan reconnects).

Purpose: complete the FOUND-03 5-direction set and restore the project showcase scene's theme reference. After this plan, all 5 directions ship as data-only `.tres` files; the engine + `.tres` data architecture is fully validated.
Output: 4 new `.tres` files at the addon root + 1 modified `main.tscn`.
</objective>

<execution_context>
@$HOME/.codex/get-shit-done/workflows/execute-plan.md
@$HOME/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/DESIGN_TOKENS.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md
@addons/neocade_theme/neocade_theme.gd
@addons/neocade_theme/pulse_neocade_theme.tres
@main.tscn

<interfaces>
This plan is parallel-eligible with Plan 04-08 (metadata + README), since neither modifies the engine `.gd` file. Both depend on Plan 04-06 (Pulse exists as the engine's smoke-test exemplar).

Per DESIGN_TOKENS §5, each direction's `.tres` ships ONLY the 9 `@export` values + (optionally) Theme Editor authored entry overrides for personality. Phase 4 ships the `@export` values only; Phases 5/6/7 polish per-direction Theme Editor overrides per the §5.x "Theme Editor override intent" lines.

Each `.tres` is structurally identical to `pulse_neocade_theme.tres` — only the `@export` values differ.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Author Slate, Bubble, Daybreak, Burst .tres files</name>
  <read_first>
    - .planning/DESIGN_TOKENS.md (§5.2 Slate, §5.3 Bubble, §5.4 Daybreak, §5.5 Burst)
    - addons/neocade_theme/pulse_neocade_theme.tres (template)
  </read_first>
  <files>
    - addons/neocade_theme/slate_neocade_theme.tres (NEW)
    - addons/neocade_theme/bubble_neocade_theme.tres (NEW)
    - addons/neocade_theme/daybreak_neocade_theme.tres (NEW)
    - addons/neocade_theme/burst_neocade_theme.tres (NEW)
  </files>
  <action>
    For each direction, author the `.tres` file with the structure of `pulse_neocade_theme.tres` (Plan 04-06) but with that direction's `@export` values from DESIGN_TOKENS §5.x. Color values are float-encoded RGBA from the hex; platform=2 (AUTO).

    **Slate (`slate_neocade_theme.tres`) — §5.2:**
    Hex → float:
    - `base_color = Color("#111820")` → `Color(0.0666667, 0.0941176, 0.12549, 1)` (17/255, 24/255, 32/255).
    - `accent_color = Color("#8BD3FF")` → `Color(0.545098, 0.827451, 1, 1)` (139/255, 211/255, 255/255).

    Content:
    ```
    [gd_resource type="NeoCadeTheme" script_class="NeoCadeTheme" load_steps=2 format=3 uid="uid://neocade_slate_v1"]

    [ext_resource type="Script" path="res://addons/neocade_theme/neocade_theme.gd" id="1_script"]

    [resource]
    script = ExtResource("1_script")
    base_color = Color(0.0666667, 0.0941176, 0.12549, 1)
    accent_color = Color(0.545098, 0.827451, 1, 1)
    raised = false
    platform = 2
    corner_radius = 14
    spacing = 22
    raised_strength = 2
    focus_thickness = 2
    outline_width = 1
    ```

    **Bubble (`bubble_neocade_theme.tres`) — §5.3:**
    Hex → float:
    - `base_color = Color("#241326")` → `Color(0.141176, 0.0745098, 0.14902, 1)` (36/255, 19/255, 38/255).
    - `accent_color = Color("#FFB3E6")` → `Color(1, 0.701961, 0.901961, 1)` (255/255, 179/255, 230/255).

    Content:
    ```
    [gd_resource type="NeoCadeTheme" script_class="NeoCadeTheme" load_steps=2 format=3 uid="uid://neocade_bubble_v1"]

    [ext_resource type="Script" path="res://addons/neocade_theme/neocade_theme.gd" id="1_script"]

    [resource]
    script = ExtResource("1_script")
    base_color = Color(0.141176, 0.0745098, 0.14902, 1)
    accent_color = Color(1, 0.701961, 0.901961, 1)
    raised = false
    platform = 2
    corner_radius = 26
    spacing = 22
    raised_strength = 6
    focus_thickness = 3
    outline_width = 1
    ```

    **Daybreak (`daybreak_neocade_theme.tres`) — §5.4:**
    Hex → float:
    - `base_color = Color("#0B2420")` → `Color(0.0431373, 0.141176, 0.12549, 1)` (11/255, 36/255, 32/255).
    - `accent_color = Color("#76F2D1")` → `Color(0.462745, 0.94902, 0.819608, 1)` (118/255, 242/255, 209/255).

    Content:
    ```
    [gd_resource type="NeoCadeTheme" script_class="NeoCadeTheme" load_steps=2 format=3 uid="uid://neocade_daybreak_v1"]

    [ext_resource type="Script" path="res://addons/neocade_theme/neocade_theme.gd" id="1_script"]

    [resource]
    script = ExtResource("1_script")
    base_color = Color(0.0431373, 0.141176, 0.12549, 1)
    accent_color = Color(0.462745, 0.94902, 0.819608, 1)
    raised = false
    platform = 2
    corner_radius = 8
    spacing = 24
    raised_strength = 3
    focus_thickness = 2
    outline_width = 1
    ```

    **Burst (`burst_neocade_theme.tres`) — §5.5:**
    Hex → float:
    - `base_color = Color("#20112E")` → `Color(0.12549, 0.0666667, 0.180392, 1)` (32/255, 17/255, 46/255).
    - `accent_color = Color("#FFD166")` → `Color(1, 0.819608, 0.4, 1)` (255/255, 209/255, 102/255).

    Content:
    ```
    [gd_resource type="NeoCadeTheme" script_class="NeoCadeTheme" load_steps=2 format=3 uid="uid://neocade_burst_v1"]

    [ext_resource type="Script" path="res://addons/neocade_theme/neocade_theme.gd" id="1_script"]

    [resource]
    script = ExtResource("1_script")
    base_color = Color(0.12549, 0.0666667, 0.180392, 1)
    accent_color = Color(1, 0.819608, 0.4, 1)
    raised = false
    platform = 2
    corner_radius = 18
    spacing = 22
    raised_strength = 5
    focus_thickness = 3
    outline_width = 1
    ```

    Implementation: write each file with PowerShell `Set-Content -Encoding UTF8` (no BOM). The synthetic UIDs are normalized by Godot on first import.
  </action>
  <acceptance_criteria>
    - All 4 files exist at `addons/neocade_theme/{slate,bubble,daybreak,burst}_neocade_theme.tres`.
    - Each file's first line begins with `[gd_resource` and contains `format=3`.
    - Each file references `res://addons/neocade_theme/neocade_theme.gd` via `[ext_resource type="Script"`.
    - Each file contains `script_class="NeoCadeTheme"` OR `type="NeoCadeTheme"` in the header.
    - **Slate** file contains: `base_color = Color(0.0666667, 0.0941176, 0.12549, 1)`, `accent_color = Color(0.545098, 0.827451, 1, 1)`, `corner_radius = 14`, `spacing = 22`, `raised_strength = 2`, `focus_thickness = 2`, `outline_width = 1`, `raised = false`, `platform = 2`.
    - **Bubble** file contains: `base_color = Color(0.141176, 0.0745098, 0.14902, 1)`, `accent_color = Color(1, 0.701961, 0.901961, 1)`, `corner_radius = 26`, `spacing = 22`, `raised_strength = 6`, `focus_thickness = 3`, `outline_width = 1`.
    - **Daybreak** file contains: `base_color = Color(0.0431373, 0.141176, 0.12549, 1)`, `accent_color = Color(0.462745, 0.94902, 0.819608, 1)`, `corner_radius = 8`, `spacing = 24`, `raised_strength = 3`, `focus_thickness = 2`, `outline_width = 1`.
    - **Burst** file contains: `base_color = Color(0.12549, 0.0666667, 0.180392, 1)`, `accent_color = Color(1, 0.819608, 0.4, 1)`, `corner_radius = 18`, `spacing = 22`, `raised_strength = 5`, `focus_thickness = 3`, `outline_width = 1`.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$base='addons/neocade_theme'; $checks=@{ 'slate_neocade_theme.tres' = @('Color(0.0666667, 0.0941176, 0.12549, 1)','Color(0.545098, 0.827451, 1, 1)','corner_radius = 14','spacing = 22','raised_strength = 2','focus_thickness = 2'); 'bubble_neocade_theme.tres' = @('Color(0.141176, 0.0745098, 0.14902, 1)','Color(1, 0.701961, 0.901961, 1)','corner_radius = 26','raised_strength = 6','focus_thickness = 3'); 'daybreak_neocade_theme.tres' = @('Color(0.0431373, 0.141176, 0.12549, 1)','Color(0.462745, 0.94902, 0.819608, 1)','corner_radius = 8','spacing = 24','raised_strength = 3'); 'burst_neocade_theme.tres' = @('Color(0.12549, 0.0666667, 0.180392, 1)','Color(1, 0.819608, 0.4, 1)','corner_radius = 18','raised_strength = 5','focus_thickness = 3') }; foreach($k in $checks.Keys) { $p=\"$base/$k\"; if (-not (Test-Path $p)) { throw \"$k missing\" }; $g=Get-Content -Raw $p; if ($g -notmatch '^\\[gd_resource') { throw \"$k bad header\" }; if ($g -notmatch 'NeoCadeTheme') { throw \"$k missing NeoCadeTheme reference\" }; foreach($req in $checks[$k]) { if ($g -notmatch [regex]::Escape($req)) { throw \"$k missing: $req\" } } }"
    </automated>
  </verify>
  <done>4 peer direction `.tres` files ship; the FOUND-03 5-direction set is complete (Pulse + 4 peers).</done>
</task>

<task type="auto">
  <name>Task 2: Reassign main.tscn theme override to pulse_neocade_theme.tres</name>
  <read_first>
    - main.tscn (current state — Plan 04-01 cleared the theme override)
    - addons/neocade_theme/pulse_neocade_theme.tres
  </read_first>
  <files>
    - main.tscn (modify — re-add theme reference)
  </files>
  <action>
    Plan 04-01 removed the theme override line from `main.tscn` (`theme = ExtResource(...)`) and removed the corresponding `[ext_resource ...]` declaration. This task restores the reference, but pointing at `pulse_neocade_theme.tres` instead of the deleted scaffold.

    Steps:
    1. Read current `main.tscn`.
    2. Add a new `[ext_resource]` line (typically near the top of the file, in the same block as any other ext_resource declarations) referencing the Pulse `.tres`:
       ```
       [ext_resource type="Theme" path="res://addons/neocade_theme/pulse_neocade_theme.tres" id="1_pulse_theme"]
       ```
       (`uid` is optional in `[ext_resource]` and is auto-generated by Godot on first save; `path` + `type` + `id` are sufficient.)
       NOTE: depending on how Godot 4.6 serializes `NeoCadeTheme`-typed resources in `.tscn` files, the `type` may need to be `"NeoCadeTheme"` instead of `"Theme"`. Either form should resolve correctly because `NeoCadeTheme extends Theme`. Use `type="Theme"` for maximum compatibility (the resource will load as its actual subclass at runtime).
    3. Add `theme = ExtResource("1_pulse_theme")` to the root node block (the `[node ...]` block representing the scene's root Control).
    4. Verify: `main.tscn` parses, opens in Godot Editor without errors, and the root node's theme override resolves to the Pulse `.tres`.

    Implementation note: the existing `main.tscn` may have a `load_steps` count that needs to be incremented when adding a new `[ext_resource]`. Godot 4.6 expects `load_steps = N+1` where N is the count of `[ext_resource]` and `[sub_resource]` blocks. The executor MUST update `load_steps` accordingly OR remove it entirely (Godot's parser tolerates a missing `load_steps`).

    Use Edit / Write to update the file.
  </action>
  <acceptance_criteria>
    - `main.tscn` contains an `[ext_resource]` line referencing `res://addons/neocade_theme/pulse_neocade_theme.tres`.
    - `main.tscn` contains a `theme = ExtResource(` line on the root Control node.
    - The `[ext_resource]` and `theme = ExtResource("...")` lines reference the same id.
    - `main.tscn` first line is still `[gd_scene` and the file parses as a valid scene.
    - `main.tscn` does NOT contain any reference to the deleted `neocade_theme.tres` scaffold (sanity check: Plan 04-01's deletion stays intact).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='main.tscn'; $g=Get-Content -Raw $p; if ($g -notmatch '^\\[gd_scene') { throw 'main.tscn header broken' }; if ($g -notmatch 'res://addons/neocade_theme/pulse_neocade_theme\\.tres') { throw 'pulse_neocade_theme.tres ext_resource missing' }; if ($g -notmatch 'theme = ExtResource\\(') { throw 'theme override line missing' }; if ($g -match 'res://addons/neocade_theme/neocade_theme\\.tres\\b') { throw 'main.tscn still references deleted scaffold' }; $ext_match = [regex]::Match($g, 'ext_resource type=\"(?:Theme|NeoCadeTheme)\"[^]]*?id=\"([^\"]+)\"[^]]*?path=\"res://addons/neocade_theme/pulse_neocade_theme\\.tres\"'); $theme_match = [regex]::Match($g, 'theme = ExtResource\\(\"([^\"]+)\"\\)'); if (-not $ext_match.Success) { $ext_match = [regex]::Match($g, 'ext_resource type=\"(?:Theme|NeoCadeTheme)\"[^]]*?path=\"res://addons/neocade_theme/pulse_neocade_theme\\.tres\"[^]]*?id=\"([^\"]+)\"') }; if ($ext_match.Success -and $theme_match.Success) { if ($ext_match.Groups[1].Value -ne $theme_match.Groups[1].Value) { throw \"ext_resource id $($ext_match.Groups[1].Value) does not match theme= id $($theme_match.Groups[1].Value)\" } }"
    </automated>
  </verify>
  <done>main.tscn loads with Pulse as the recommended-starter theme, restoring the showcase scene's theme reference (Plan 04-01 cleared, Plan 04-07 reassigns).</done>
</task>

<task type="auto">
  <name>Task 3: Atomic commit — peer themes + main.tscn reassignment</name>
  <read_first>
    - addons/neocade_theme/slate_neocade_theme.tres
    - addons/neocade_theme/bubble_neocade_theme.tres
    - addons/neocade_theme/daybreak_neocade_theme.tres
    - addons/neocade_theme/burst_neocade_theme.tres
    - main.tscn
  </read_first>
  <files>(commit only)</files>
  <action>
    Stage the 4 new `.tres` files + the modified `main.tscn` and commit:

    ```
    feat(04-07): ship Slate/Bubble/Daybreak/Burst .tres + reassign main.tscn

    Plan 04-07 wave-4 (depends on Plan 04-06 Pulse):
    - addons/neocade_theme/slate_neocade_theme.tres — §5.2: base=#111820, accent=#8BD3FF,
      corner_radius=14, spacing=22, raised_strength=2, focus_thickness=2
    - addons/neocade_theme/bubble_neocade_theme.tres — §5.3: base=#241326, accent=#FFB3E6,
      corner_radius=26, spacing=22, raised_strength=6, focus_thickness=3
    - addons/neocade_theme/daybreak_neocade_theme.tres — §5.4: base=#0B2420, accent=#76F2D1,
      corner_radius=8, spacing=24, raised_strength=3, focus_thickness=2
    - addons/neocade_theme/burst_neocade_theme.tres — §5.5: base=#20112E, accent=#FFD166,
      corner_radius=18, spacing=22, raised_strength=5, focus_thickness=3
    - main.tscn — re-add theme override pointing at pulse_neocade_theme.tres
      (recommended starter, per CONTEXT.md D-13). Plan 04-01 cleared the scaffold reference.

    Refs: FOUND-03 (full 5-direction set)
    Plan: 04-07
    ```

    `git add` the 5 paths; commit. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-07):`.
    - `git log -1 --name-status` shows 4 `A` entries (the peer .tres files) AND 1 `M main.tscn` entry.
    - `git status --porcelain` is empty for all 5 paths.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-07\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; foreach($f in 'addons/neocade_theme/slate_neocade_theme\\.tres','addons/neocade_theme/bubble_neocade_theme\\.tres','addons/neocade_theme/daybreak_neocade_theme\\.tres','addons/neocade_theme/burst_neocade_theme\\.tres') { if ($ns -notmatch \"A\\s+$f\") { throw \"commit missing $f\" } }; if ($ns -notmatch 'M\\s+main\\.tscn') { throw 'commit missing main.tscn modification' }"
    </automated>
  </verify>
  <done>4 peer themes + main.tscn reassignment land as a single atomic Wave 4 commit. The full 5-direction set ships.</done>
</task>

</tasks>
