---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 03
type: execute
wave: 1
depends_on: []
files_modified:
  - addons/neocade_theme/icons/check.svg
  - addons/neocade_theme/icons/checkbox_checked.svg
  - addons/neocade_theme/icons/checkbox_unchecked.svg
  - addons/neocade_theme/icons/radio_checked.svg
  - addons/neocade_theme/icons/radio_unchecked.svg
  - addons/neocade_theme/icons/toggle_on.svg
  - addons/neocade_theme/icons/toggle_off.svg
  - addons/neocade_theme/icons/arrow_down.svg
  - addons/neocade_theme/icons/clear.svg
  - addons/neocade_theme/icons/close.svg
  - addons/neocade_theme/icons/check.svg.import
  - addons/neocade_theme/icons/checkbox_checked.svg.import
  - addons/neocade_theme/icons/checkbox_unchecked.svg.import
  - addons/neocade_theme/icons/radio_checked.svg.import
  - addons/neocade_theme/icons/radio_unchecked.svg.import
  - addons/neocade_theme/icons/toggle_on.svg.import
  - addons/neocade_theme/icons/toggle_off.svg.import
  - addons/neocade_theme/icons/arrow_down.svg.import
  - addons/neocade_theme/icons/clear.svg.import
  - addons/neocade_theme/icons/close.svg.import
autonomous: true
requirements:
  - ICON-01
  - ICON-02
  - ICON-03
  - ICON-04
must_haves:
  truths:
    - "10 bespoke monochrome SVG icons exist at `addons/neocade_theme/icons/{name}.svg`: `check`, `checkbox_checked`, `checkbox_unchecked`, `radio_checked`, `radio_unchecked`, `toggle_on`, `toggle_off`, `arrow_down`, `clear`, `close`."
    - "Every SVG is authored at 32×32 reference (`viewBox=\"0 0 32 32\"`), monochrome (single fill color or `currentColor`), `modulate`-tintable (no baked color other than the strokes/fills that the icon's monochrome design needs)."
    - "Every SVG has a corresponding `.import` sidecar that explicitly sets `svg/scale=2.0` and `mipmaps/generate=true` (Linear With Mipmaps filter) per ICON-01 + STACK + PITFALLS."
    - "No Material Symbols / Lucide / Phosphor / external icon library binaries are bundled (per ICON-04 + STACK Decision 5 + D-12)."
  artifacts:
    - addons/neocade_theme/icons/ (10 SVGs + 10 .import sidecars)
  key_links:
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md D-10, D-11, D-12"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md §6"
    - ".planning/research/STACK.md (icon import contract)"
    - ".planning/research/PITFALLS.md (icon scale + filter)"
---

<objective>
Author the Button-family bespoke SVG icon set (10 icons covering Button / CheckBox / RadioButton / CheckButton / OptionButton / LineEdit clear / dialog close) at 32×32 monochrome reference, plus the matching `.import` sidecars that lock in Scale=2.0 + Linear With Mipmaps for crisp rendering across DPIs and platforms.

Purpose: ship the icon contract that Plan 04-05's `_regenerate_theme()` binding wires into Theme entries, and that Phases 6/7 follow when they author Tree / ColorPicker / FileDialog / ScrollBar icons.
Output: 10 hand-authored SVGs + 10 `.import` sidecars = 20 new files at `addons/neocade_theme/icons/`.
</objective>

<execution_context>
@$HOME/.codex/get-shit-done/workflows/execute-plan.md
@$HOME/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md
@.planning/research/STACK.md
@.planning/research/PITFALLS.md
@.planning/research/FEATURES.md

<interfaces>
Files to create (per the Button-family icon list, ICON-02 + D-10):
- 10 SVGs at `addons/neocade_theme/icons/{name}.svg`.
- 10 `.import` sidecars at `addons/neocade_theme/icons/{name}.svg.import`.

This plan is parallel-eligible with Plans 04-01 and 04-02 (Wave 1).
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Author the 10 Button-family monochrome SVG icons at 32×32 reference</name>
  <read_first>
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md (D-10, D-11, D-12)
    - .planning/research/STACK.md
    - .planning/research/FEATURES.md (35-class Control coverage matrix)
  </read_first>
  <files>
    - addons/neocade_theme/icons/check.svg (NEW)
    - addons/neocade_theme/icons/checkbox_checked.svg (NEW)
    - addons/neocade_theme/icons/checkbox_unchecked.svg (NEW)
    - addons/neocade_theme/icons/radio_checked.svg (NEW)
    - addons/neocade_theme/icons/radio_unchecked.svg (NEW)
    - addons/neocade_theme/icons/toggle_on.svg (NEW)
    - addons/neocade_theme/icons/toggle_off.svg (NEW)
    - addons/neocade_theme/icons/arrow_down.svg (NEW)
    - addons/neocade_theme/icons/clear.svg (NEW)
    - addons/neocade_theme/icons/close.svg (NEW)
  </files>
  <action>
    Author each icon as a hand-written SVG at 32×32 reference, monochrome (single `fill="currentColor"` or `fill="#FFFFFF"` so Godot's icon `modulate` can tint per accent role). The shapes are intentionally simple geometric primitives suitable for a flat MD3 system; no gradients, no outlines beyond the icon's own line-art definition, no patterns.

    Each file uses this template (substitute the icon-specific path data):

    ```xml
    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32" fill="none">
        <!-- icon paths here, fill="#FFFFFF" or stroke="#FFFFFF" so Godot modulate tints them -->
    </svg>
    ```

    Per-icon path content (concrete; the executor authors these as-given so visual identity is consistent):

    1. **check.svg** — generic checkmark (used inside Buttons, in PopupMenu indicators, etc.):
       ```xml
       <path d="M6 17 L13 24 L26 9" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
       ```

    2. **checkbox_checked.svg** — square box with checkmark inside:
       ```xml
       <rect x="4" y="4" width="24" height="24" rx="3" stroke="#FFFFFF" stroke-width="2" fill="#FFFFFF" fill-opacity="0.0"/>
       <rect x="4" y="4" width="24" height="24" rx="3" fill="#FFFFFF"/>
       <path d="M9 16.5 L14 21.5 L23 11" stroke="#000000" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
       ```
       (filled box, dark check inside — Godot's modulate will recolor; the modulate-tintable convention is that the box uses fill="#FFFFFF" and the check uses a contrasting color so consumers know which token to use; alternative: ship the box only and let StyleBoxFlat back the check fill — but bespoke convention is easier).

       NOTE: if the dual-color approach above complicates `modulate` tinting, simplify to a single-color outlined-box-with-inset-check version and let consumers compose colors via the Theme's `font_color` slot. The simplest version that works:
       ```xml
       <rect x="4" y="4" width="24" height="24" rx="3" stroke="#FFFFFF" stroke-width="2" fill="none"/>
       <path d="M9 16.5 L14 21.5 L23 11" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
       ```
       Use the simpler single-color version. Aesthetic + modulate-tintable + monochrome.

    3. **checkbox_unchecked.svg** — square box outline only:
       ```xml
       <rect x="4" y="4" width="24" height="24" rx="3" stroke="#FFFFFF" stroke-width="2" fill="none"/>
       ```

    4. **radio_checked.svg** — circle outline with filled inner dot:
       ```xml
       <circle cx="16" cy="16" r="12" stroke="#FFFFFF" stroke-width="2" fill="none"/>
       <circle cx="16" cy="16" r="6" fill="#FFFFFF"/>
       ```

    5. **radio_unchecked.svg** — circle outline only:
       ```xml
       <circle cx="16" cy="16" r="12" stroke="#FFFFFF" stroke-width="2" fill="none"/>
       ```

    6. **toggle_on.svg** — rounded pill with knob to the right (CheckButton on-state):
       ```xml
       <rect x="2" y="8" width="28" height="16" rx="8" fill="#FFFFFF"/>
       <circle cx="22" cy="16" r="6" fill="#000000"/>
       ```
       Single-color version (knob carved out via Godot modulate tricks):
       ```xml
       <rect x="2" y="8" width="28" height="16" rx="8" fill="#FFFFFF"/>
       <circle cx="22" cy="16" r="5" fill="#FFFFFF" fill-opacity="0"/>
       ```
       Use the simpler dual-color version as authored above (`fill="#FFFFFF"` track, `fill="#000000"` knob). Theme bindings supply both colors.

    7. **toggle_off.svg** — rounded pill with knob to the left (CheckButton off-state):
       ```xml
       <rect x="2" y="8" width="28" height="16" rx="8" stroke="#FFFFFF" stroke-width="2" fill="none"/>
       <circle cx="10" cy="16" r="5" fill="#FFFFFF"/>
       ```

    8. **arrow_down.svg** — chevron pointing down (OptionButton arrow, MenuButton arrow):
       ```xml
       <path d="M8 12 L16 22 L24 12" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
       ```

    9. **clear.svg** — X mark inside a circle (LineEdit clear button):
       ```xml
       <circle cx="16" cy="16" r="12" fill="#FFFFFF"/>
       <path d="M11 11 L21 21 M21 11 L11 21" stroke="#000000" stroke-width="3" stroke-linecap="round"/>
       ```
       Or simpler single-color version:
       ```xml
       <circle cx="16" cy="16" r="12" stroke="#FFFFFF" stroke-width="2" fill="none"/>
       <path d="M11 11 L21 21 M21 11 L11 21" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round"/>
       ```
       Use single-color version (cleaner monochrome).

    10. **close.svg** — bare X mark (window/dialog close):
        ```xml
        <path d="M8 8 L24 24 M24 8 L8 24" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round"/>
        ```

    Implementation: write each file with PowerShell `Set-Content -Encoding UTF8` (no BOM). The exact path data above is the production icon set; do not deviate (the visual identity is locked at this baseline; per-direction icon variations are not in scope for v1).

    For the dual-color icons (`checkbox_checked`, `toggle_on`, `clear`, optionally), the dual-color authoring is acceptable IF Godot's icon modulate is not used as a complete recolor (the bespoke pattern is that Godot icon `modulate` multiplies; multi-color icons preserve the design's relative contrast under tint). The simpler single-color versions are preferred where they read as cleanly. Use these single-color versions for `checkbox_checked` (just the check), `clear` (single-color X-in-circle outline). For `toggle_on`/`toggle_off`, the dual-color (filled track + contrasting knob) authoring is intentional — toggles need to read as "knob on track" and a single-color version doesn't communicate state.

    Final per-file authoring:
    - `check.svg`: single path (the checkmark), `stroke="#FFFFFF"`, no fill.
    - `checkbox_checked.svg`: outlined box + inset check, both `stroke="#FFFFFF"`, no fill.
    - `checkbox_unchecked.svg`: outlined box only, `stroke="#FFFFFF"`, no fill.
    - `radio_checked.svg`: outlined circle + filled inner dot, `stroke="#FFFFFF"` outer, `fill="#FFFFFF"` inner.
    - `radio_unchecked.svg`: outlined circle, `stroke="#FFFFFF"`, no fill.
    - `toggle_on.svg`: filled track + dark knob (dual-color, intentional).
    - `toggle_off.svg`: outlined track + filled knob, `stroke="#FFFFFF"` track, `fill="#FFFFFF"` knob.
    - `arrow_down.svg`: chevron path, `stroke="#FFFFFF"`, no fill.
    - `clear.svg`: outlined circle + inset X, both `stroke="#FFFFFF"`, no fill.
    - `close.svg`: bare X, `stroke="#FFFFFF"`, no fill.
  </action>
  <acceptance_criteria>
    - All 10 SVG files exist at `addons/neocade_theme/icons/{name}.svg`.
    - Every file's first line begins with `<?xml version="1.0"`.
    - Every file's `<svg>` tag contains `width="32"`, `height="32"`, `viewBox="0 0 32 32"`.
    - Every file is monochrome (uses only `#FFFFFF` and/or `#000000` fills/strokes — no other colors; the `toggle_on.svg` dual-color authoring uses `#FFFFFF` track + `#000000` knob and is the only file with `#000000`).
    - Every file is under 2 KB (sanity check — these are simple geometric SVGs).
    - File `check.svg` contains a `<path` element with `M6 17 L13 24 L26 9` (or equivalent path data — the checkmark stroke).
    - File `arrow_down.svg` contains a `<path` element with `M8 12 L16 22 L24 12` (or equivalent — the chevron).
    - File `close.svg` contains the path data for the X (`M8 8 L24 24 M24 8 L8 24` or equivalent).
    - File `radio_checked.svg` contains 2 `<circle` elements.
    - File `radio_unchecked.svg` contains 1 `<circle` element.
    - File `checkbox_checked.svg` contains 1 `<rect` element AND 1 `<path` element.
    - File `checkbox_unchecked.svg` contains 1 `<rect` element AND 0 `<path` elements (rect outline only).
    - File `toggle_on.svg` contains 1 `<rect` element AND 1 `<circle` element.
    - File `toggle_off.svg` contains 1 `<rect` element AND 1 `<circle` element.
    - File `clear.svg` contains 1 `<circle` element AND 1 `<path` element.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$base='addons/neocade_theme/icons'; $names=@('check','checkbox_checked','checkbox_unchecked','radio_checked','radio_unchecked','toggle_on','toggle_off','arrow_down','clear','close'); foreach($n in $names) { $p=\"$base/$n.svg\"; if (-not (Test-Path $p)) { throw \"$n.svg missing\" }; $g=Get-Content -Raw $p; if ($g -notmatch '^<\\?xml version=\"1\\.0\"') { throw \"$n.svg missing XML decl\" }; if ($g -notmatch 'width=\"32\"') { throw \"$n.svg missing width=32\" }; if ($g -notmatch 'height=\"32\"') { throw \"$n.svg missing height=32\" }; if ($g -notmatch 'viewBox=\"0 0 32 32\"') { throw \"$n.svg missing viewBox\" }; if ((Get-Item $p).Length -gt 2048) { throw \"$n.svg too large (>2KB)\" } }; foreach($n in 'radio_checked','radio_unchecked','toggle_on','toggle_off','clear') { $g=Get-Content -Raw \"$base/$n.svg\"; if ($g -notmatch '<circle') { throw \"$n.svg missing <circle>\" } }; foreach($n in 'checkbox_checked','checkbox_unchecked','toggle_on','toggle_off') { $g=Get-Content -Raw \"$base/$n.svg\"; if ($g -notmatch '<rect') { throw \"$n.svg missing <rect>\" } }; foreach($n in 'check','arrow_down','close','checkbox_checked','clear') { $g=Get-Content -Raw \"$base/$n.svg\"; if ($g -notmatch '<path') { throw \"$n.svg missing <path>\" } }"
    </automated>
  </verify>
  <done>10 monochrome Button-family SVG icons authored at 32×32 reference per the locked NeoCade icon contract.</done>
</task>

<task type="auto">
  <name>Task 2: Author 10 .import sidecars enforcing Scale=2.0 + Linear With Mipmaps</name>
  <read_first>
    - addons/neocade_theme/icons/check.svg (and the other 9 SVGs)
    - .planning/research/STACK.md
    - .planning/research/PITFALLS.md
  </read_first>
  <files>
    - addons/neocade_theme/icons/check.svg.import (NEW)
    - addons/neocade_theme/icons/checkbox_checked.svg.import (NEW)
    - addons/neocade_theme/icons/checkbox_unchecked.svg.import (NEW)
    - addons/neocade_theme/icons/radio_checked.svg.import (NEW)
    - addons/neocade_theme/icons/radio_unchecked.svg.import (NEW)
    - addons/neocade_theme/icons/toggle_on.svg.import (NEW)
    - addons/neocade_theme/icons/toggle_off.svg.import (NEW)
    - addons/neocade_theme/icons/arrow_down.svg.import (NEW)
    - addons/neocade_theme/icons/clear.svg.import (NEW)
    - addons/neocade_theme/icons/close.svg.import (NEW)
  </files>
  <action>
    For each of the 10 SVGs, author a `.svg.import` sidecar with this template (substitute the icon's filename for `<name>`):

    ```ini
    [remap]

    importer="texture"
    type="CompressedTexture2D"
    uid="uid://neocade_icon_<name>_v1"
    path="res://.godot/imported/<name>.svg-<hash>.ctex"
    metadata={
    "vram_texture": false
    }

    [deps]

    source_file="res://addons/neocade_theme/icons/<name>.svg"
    dest_files=["res://.godot/imported/<name>.svg-<hash>.ctex"]

    [params]

    compress/mode=0
    compress/high_quality=false
    compress/lossy_quality=0.7
    compress/hdr_compression=1
    compress/normal_map=0
    compress/channel_pack=0
    mipmaps/generate=true
    mipmaps/limit=-1
    roughness/mode=0
    roughness/src_normal=""
    process/fix_alpha_border=true
    process/premult_alpha=false
    process/normal_map_invert_y=false
    process/hdr_as_srgb=false
    process/hdr_clamp_exposure=false
    process/size_limit=0
    detect_3d/compress_to=1
    svg/scale=2.0
    editor/scale_with_editor_scale=false
    editor/convert_colors_with_editor_theme=false
    ```

    The KEY values per ICON-01 + STACK + PITFALLS:
    - `svg/scale=2.0` (icons render at 2× their 32×32 reference = 64×64 baseline texture, so scaling down is crisp).
    - `mipmaps/generate=true` (Linear With Mipmaps when assigned with default texture filter).
    - `compress/mode=0` (lossless — these are vector-derived bitmaps, lossy compression would degrade edge crispness).
    - `process/fix_alpha_border=true` (cleans premultiplied-alpha bleed at icon edges).

    The synthetic UIDs and `<hash>` placeholders will be normalized by Godot on first import; the verification checks param values, not UID format.

    Step-by-step: write each `.import` sidecar with PowerShell `Set-Content -Encoding UTF8`. Substitute `<name>` and the path-references for each of the 10 icons. The `[params]` block is identical across all 10 files.
  </action>
  <acceptance_criteria>
    - All 10 `.svg.import` files exist at `addons/neocade_theme/icons/{name}.svg.import`.
    - Every file contains `importer="texture"`.
    - Every file contains `type="CompressedTexture2D"`.
    - Every file contains `svg/scale=2.0`.
    - Every file contains `mipmaps/generate=true`.
    - Every file contains `compress/mode=0` (lossless).
    - Every file contains `process/fix_alpha_border=true`.
    - Every file's `source_file` line correctly points at the matching `.svg` file.
    - Every file is under 2 KB.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$base='addons/neocade_theme/icons'; $names=@('check','checkbox_checked','checkbox_unchecked','radio_checked','radio_unchecked','toggle_on','toggle_off','arrow_down','clear','close'); foreach($n in $names) { $p=\"$base/$n.svg.import\"; if (-not (Test-Path $p)) { throw \"$n.svg.import missing\" }; $g=Get-Content -Raw $p; foreach($req in 'importer=\"texture\"','type=\"CompressedTexture2D\"','svg/scale=2.0','mipmaps/generate=true','compress/mode=0','process/fix_alpha_border=true',\"source_file=`\"res://addons/neocade_theme/icons/$n.svg`\"\") { if ($g -notmatch [regex]::Escape($req)) { throw \"$n.svg.import missing: $req\" } }; if ((Get-Item $p).Length -gt 2048) { throw \"$n.svg.import too large\" } }"
    </automated>
  </verify>
  <done>All 10 icons have correctly-configured import sidecars locking in Scale=2.0 + Linear With Mipmaps + lossless compression.</done>
</task>

<task type="auto">
  <name>Task 3: Atomic commit — Button-family icons + import sidecars</name>
  <read_first>
    - addons/neocade_theme/icons/check.svg
    - addons/neocade_theme/icons/check.svg.import
  </read_first>
  <files>(commit only)</files>
  <action>
    Stage all 20 new files (10 SVGs + 10 `.import` sidecars) and commit:

    ```
    feat(04-03): author Button-family bespoke icons + import contract

    Plan 04-03 wave-1 icons:
    - 10 monochrome SVGs at 32×32 reference at addons/neocade_theme/icons/:
      check, checkbox_checked, checkbox_unchecked, radio_checked, radio_unchecked,
      toggle_on, toggle_off, arrow_down, clear, close
    - 10 .import sidecars enforcing svg/scale=2.0 + mipmaps/generate=true
      (Linear With Mipmaps) + lossless compression per ICON-01 + STACK + PITFALLS
    - No external icon library bundled (per ICON-04 + STACK Decision 5 + D-12)

    Refs: ICON-01, ICON-02, ICON-03, ICON-04
    Plan: 04-03
    ```

    `git add` all 20 files; `git commit -m "..."`. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-03):`.
    - `git log -1 --name-status` shows 20 `A` entries — 10 `.svg` + 10 `.svg.import` paths under `addons/neocade_theme/icons/`.
    - `git status --porcelain` is empty for all 20 paths.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-03\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; $names=@('check','checkbox_checked','checkbox_unchecked','radio_checked','radio_unchecked','toggle_on','toggle_off','arrow_down','clear','close'); foreach($n in $names) { foreach($ext in '.svg','.svg.import') { $f = \"addons/neocade_theme/icons/$n$ext\"; $pattern = \"A\\s+$([regex]::Escape($f))\"; if ($ns -notmatch $pattern) { throw \"commit missing $f\" } } }"
    </automated>
  </verify>
  <done>The Button-family icon set lands as a single atomic commit; Wave 1 icons portion of Phase 4 is complete.</done>
</task>

</tasks>
