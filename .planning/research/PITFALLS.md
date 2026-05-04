# Pitfalls Research — NeoCade Theme

**Domain:** Godot 4.6 UI Theme addon (drop-in `.tres` resource + bundled fonts)
**Researched:** 2026-05-04
**Confidence:** HIGH for items backed by GitHub issues / official docs; MEDIUM for items synthesised from multiple community sources; flagged inline.

This document is opinionated. For each pitfall:
- **Severity** — High = blocks shipping; Med = visible regression; Low = polish.
- **Phase** — research / design / implementation / QA / distribution.
- **Warning signs** — early detection signal.
- **Prevention** — concrete checklist item, not a principle.

Categories:
1. Godot Theme API gotchas
2. Editor-vs-Runtime divergence
3. HD/DPI/scaling
4. Accessibility
5. Fonts & icons (especially distribution from `addons/`)
6. Borrowing from godot-minimal-theme
7. Visual identity drift (arcade -> cyberpunk)
8. MCP usage
9. Distribution (Asset Library, addon detection, .tres format)
10. Showcase scene risks

---

## 1. Godot Theme API Gotchas

### 1.1 Focus stylebox is an OVERLAY, not a state — it loses to pressed/checked **[NON-OBVIOUS, HIGH]**

**What goes wrong:**
A user tabs to a `CheckButton` that's already checked. The focus ring you carefully designed never appears: the `pressed`/`checked` stylebox replaces `normal`, and your `focus` stylebox — which is *not* a state but an overlay-only entry — has nowhere to attach. Worse, `font_focus_color` only kicks in when the control is otherwise in `normal` state; on hover-then-focus it's masked by `font_hover_color`.

**Why it happens:**
Godot's button-state model treats `normal/hover/pressed/disabled/hover_pressed` as *replacement* styleboxes, while `focus` is composited *on top* but does not have pressed/hovered variants. There is no `pressed_focus` or `hover_focus`. Multiple long-standing issues confirm this is the documented behaviour, not a bug.

**Prevention checklist:**
- [ ] Design the focus indicator as an **outer** ring that visually survives over any background stylebox (e.g. a 2px outline drawn outside the corner radius, with a transparent fill).
- [ ] Verify focus visibility on each base stylebox: `normal`, `hover`, `pressed`, `disabled`, `hover_pressed`, plus `checked`/`unchecked` for CheckButton/CheckBox.
- [ ] Do not rely on `font_focus_color` alone to indicate focus — the stylebox must do the work.
- [ ] Test focus under `Control.FOCUS_ALL` for every interactive control class in the showcase.
- [ ] In the showcase scene, include an explicit "focus walkthrough" — Tab through every control with a screen recording.

**Warning signs:**
- Focus ring works on `Button` but disappears on `CheckBox` when checked.
- Focus is visible only on first hover, then fades when mouse moves.

**Phase:** design (focus token spec) -> implementation (focus stylebox per type) -> QA (Tab-walkthrough screenshot test).

**Sources:** [godot/issues/30856 — focus layer covering up pressed, hover, disabled](https://github.com/godotengine/godot/issues/30856), [godot/issues/74489 — focus color replaced by font hover color](https://github.com/godotengine/godot/issues/74489), [godot-proposals/issues/8134 — Change focus styling](https://github.com/godotengine/godot-proposals/issues/8134), [godot-proposals/issues/12242 — make hover replace focus](https://github.com/godotengine/godot-proposals/issues/12242).

---

### 1.2 Type variations don't inherit fonts (or icons) the way the docs imply **[NON-OBVIOUS, MED]**

**What goes wrong:**
You define `HeadingLabel` as a Type Variation with base type `Label`. You set the font on `Label`, expecting `HeadingLabel` to inherit. It does not — `HeadingLabel` falls back to the *project default font*, not the parent type's font. Stylebox inheritance works fine, masking the bug.

**Why it happens:**
Documented regression in font inheritance: type variations resolve fonts from theme defaults rather than the base type's font assignment. Other properties (StyleBoxes) inherit correctly, which makes the bug confusing.

**Prevention checklist:**
- [ ] Set fonts **explicitly on every type variation**, do not rely on inheritance.
- [ ] Or set fonts only on the theme default font (not per-type) so inheritance is moot.
- [ ] When you author a variation in the Theme editor, verify in the showcase that the font matches expectations — do not trust the editor's inspector preview.
- [ ] Confirm Type Variation dropdown shows your variations (it occasionally goes empty even when the variation exists; type-in works as fallback).

**Warning signs:**
- Variation control renders correctly in the Theme Editor preview but uses a different font in the showcase scene.
- "Type variation" dropdown appears empty when it shouldn't.

**Phase:** implementation (variation authoring) -> QA (per-variation visual diff).

**Sources:** [godot/issues/80731 — Font not inherited in type variation](https://github.com/godotengine/godot/issues/80731), [godot/issues/82199 — Type variations don't work for Panel/Label/Button/Tree](https://github.com/godotengine/godot/issues/82199), [godot/issues/80732 — Type Variation dropdown empty](https://github.com/godotengine/godot/issues/80732), [godot/issues/67010 — Theme inheritance broken for custom types](https://github.com/godotengine/godot/issues/67010).

---

### 1.3 Theme overrides on a node DO NOT cascade to children **[HIGH]**

**What goes wrong:**
You apply `add_theme_color_override("font_color", ...)` on a parent `Container`, expecting children to pick it up. They don't. Theme *overrides* are local-only; only Theme *resources* assigned to `Control.theme` propagate down the tree.

**Why it happens:**
Two distinct mechanisms with similar names: `theme_override_*` (local-only) vs `theme` (cascading resource). Children, when resolving `get_theme_color`, walk the ancestor chain looking for a `theme` resource and skip past local overrides on ancestors.

**Prevention checklist:**
- [ ] In the showcase, **never** demonstrate "global tinting" via overrides on a parent — assign a Theme resource instead.
- [ ] Document this in user-facing docs: "To tint a section, build a Theme resource, not an override."
- [ ] Type variations should be the recommended path for sectional restyling.

**Warning signs:**
- Override "works" on the node it's applied to, vanishes one level down.
- Tooltips, popups, and submenus ignore the override.

**Phase:** design (token system) -> implementation (use Theme resource only) -> docs.

**Sources:** [bugnet.io — Theme override not applying to child controls](https://bugnet.io/blog/fix-godot-theme-override-not-applying), [Theme Type Variations docs](https://docs.godotengine.org/en/stable/tutorials/ui/gui_theme_type_variations.html).

---

### 1.4 StyleBoxFlat shadow & anti-aliasing render at over-strong alpha **[MED]**

**What goes wrong:**
You design a soft shadow at alpha 0.25, it renders as alpha ~0.5 in-engine. Modulating the control's `modulate.a` makes the shadow even more intense relative to the fill — exactly opposite of expected.

**Why it happens:**
Long-standing bug in StyleBoxFlat: opacity of border, shadow and AA is multiplied through an extra channel. Also, `shadow_size = 0` no longer disables shadows after a recent PR — value `-1` does, while `0` produces sharp un-feathered shadows.

**Prevention checklist:**
- [ ] Visually calibrate shadow alpha **in-engine**, not in the design tool. Expect to halve the value you'd use in Figma.
- [ ] Use `shadow_size = -1` (not 0) when a control should have no shadow.
- [ ] Avoid heavy reliance on `modulate` for fades on shadowed controls; toggle visibility instead.
- [ ] Render every shadow stylebox in the showcase against both Base and Elevated surfaces — shadows on dark-on-dark are easy to over-tune.

**Warning signs:**
- Shadow looks correct in editor preview, way too strong in running scene.
- Disabled state with `modulate.a = 0.5` shows shadow stronger than fill.

**Phase:** design (shadow token spec) -> implementation -> QA.

**Sources:** [godot/issues/23640 — shadow opacity too strong](https://github.com/godotengine/godot/issues/23640), [godot/pull/98162 — shadow_size=-1 disables shadows](https://github.com/godotengine/godot/pull/98162).

---

### 1.5 GL Compatibility renderer quirks impact StyleBoxFlat shadows / AA

**What goes wrong:**
You author the theme on the default Forward+ project, then NeoCade is set to GL Compatibility. Shadows look subtly different, AA edges feather differently, and certain blend modes render at higher contrast than authored.

**Why it happens:**
GL Compatibility uses different shader paths for 2D AA and shadow blur (PCF approximations on lights, simpler 2D fill). Project setting locks renderer; shadow blur properties are partially ignored on Compatibility.

**Prevention checklist:**
- [ ] Author and screenshot-QA the theme **with the project running on GL Compatibility** (matches NeoCade's project.godot setting).
- [ ] Don't rely on heavy shadow blurs as a primary visual identity feature — substitute with a coloured border + minimal shadow.
- [ ] Add a CI/QA pass: compare side-by-side Forward+ vs Compatibility screenshots, flag any deltas >2% pixel diff on a control.

**Warning signs:**
- Theme looks "correct" in the Theme editor preview (which uses editor renderer) but different at runtime.
- Issue reports from users on web/mobile builds (Compatibility-only).

**Phase:** implementation -> QA (mandatory dual-renderer screenshot pass).

**Sources:** [godot/issues/82504 — OpenGL Light3D shadow blur ignored](https://github.com/godotengine/godot/issues/82504), [forum — How to make Compatibility look good](https://forum.godotengine.org/t/how-to-make-compatibility-renderer-look-good/84139).

---

### 1.6 Custom (scripted) StyleBox in the project theme can crash on launch

**What goes wrong:**
Out of curiosity you extend StyleBox with a script for a "scanline" effect. The theme works in the editor. At runtime, project crashes or prints `Parameter 'SceneTree::get_singleton()' is null`.

**Why it happens:**
A scripted StyleBox in the *main project theme* loads before SceneTree exists; if the script touches singletons in `_init` or property setters, it crashes.

**Prevention checklist:**
- [ ] **Hard rule for v1:** no scripted StyleBoxes. Use only built-in `StyleBoxFlat`, `StyleBoxTexture`, `StyleBoxLine`, `StyleBoxEmpty`. (Already a project constraint — enforce in code review.)
- [ ] If a script-based effect is ever needed, attach it via runtime `add_theme_stylebox_override`, not in the main `.tres`.

**Warning signs:**
- Random crash on game start that disappears when theme is detached.
- "null SceneTree::get_singleton()" in console.

**Phase:** design (decision to bar custom StyleBox scripts) -> implementation review.

**Sources:** [godot/issues/74267 — crash with scripted StyleBox in project theme](https://github.com/godotengine/godot/issues/74267), [godot/issues/110548 — error messages with custom StyleBox](https://github.com/godotengine/godot/issues/110548).

---

### 1.7 PopupMenu / OptionButton popup is a separate Window — it doesn't inherit theme overrides or texture filter from its parent **[NON-OBVIOUS, HIGH]**

**What goes wrong:**
You style `OptionButton` beautifully. You click the dropdown — the popup is unstyled, has the wrong texture filter (Linear when project is Nearest, or vice-versa), and ignores the MarginContainer above it. It looks like a different addon.

**Why it happens:**
Popups (PopupMenu, OptionButton's dropdown, AcceptDialog etc.) are *Windows*: they own their own Viewport, their own texture-filter context, and their own theme resolution chain. They do not inherit `theme_override` from the spawning control.

**Prevention checklist:**
- [ ] Theme **`PopupMenu`** explicitly as a top-level type in the .tres — separate from `OptionButton`.
- [ ] Theme **`PopupPanel`**, **`Window`**, **`AcceptDialog`**, **`ConfirmationDialog`**, **`FileDialog`** as their own types.
- [ ] Theme **`TooltipPanel`** and **`TooltipLabel`** so tooltips match.
- [ ] Showcase must include an open OptionButton, a Tree right-click context menu, an AcceptDialog with focus on a button, AND a FileDialog (which has its own scrollbars/tree inside) — visually verified.
- [ ] If using textures in popups, verify texture filter mode matches the rest of the theme.

**Warning signs:**
- Dropdown opens and looks like Godot default while the rest is NeoCade.
- Tooltip background is white/grey while the rest is dark.

**Phase:** design (catalogue every Popup-class control) -> implementation -> QA (open every popup at least once).

**Sources:** [godot/issues/113872 — PopupMenu doesn't inherit Texture Filter](https://github.com/godotengine/godot/issues/113872), [godot/issues/93644 — Popup Menu style overridden](https://github.com/godotengine/godot/issues/93644), [godot/issues/81107 — PopupMenu position doesn't respect MarginContainer theme](https://github.com/godotengine/godot/issues/81107), [forum — How to modulate PopupMenu items](https://forum.godotengine.org/t/how-to-modulate-a-popupmenus-items/54136).

---

### 1.8 Editing the theme in the inspector can crash the editor in Godot 4.6 **[HIGH, ENVIRONMENTAL]**

**What goes wrong:**
You assign `neocade_theme.tres` on a Control, click into the Theme inspector to tweak — Godot crashes. You lose unsaved work.

**Why it happens:**
Active issue in 4.6 where editing a Theme assigned to a Control crashes the editor. Clicking a StyleBox in the Theme inspector has crashed multiple times across 4.x.

**Prevention checklist:**
- [ ] Author the theme **always via the dedicated Theme editor tab** (open the .tres directly), never from a Control's inspector context.
- [ ] Save after every meaningful edit (Ctrl+S).
- [ ] Use git as a checkpoint mechanism — commit theme state every ~10 minutes during authoring sessions.
- [ ] Test on the latest stable Godot 4.6.x — point releases may fix this.

**Warning signs:**
- Crash log mentions Theme/StyleBox.
- Pattern: crashes correlated with clicking StyleBox in inspector.

**Phase:** implementation (process discipline) -> QA.

**Sources:** [godot/issues/115500 — UI Theme edit crashes editor in 4.6](https://github.com/godotengine/godot/issues/115500), [godot/issues/68774 — Clicking Theme StyleBox in inspector crashes](https://github.com/godotengine/godot/issues/68774).

---

### 1.9 Project theme application timing — children read theme on `_ready` from the cached chain

**What goes wrong:**
Loading a Theme dynamically in main scene's `_ready` — you expect children to pick it up. Children's `_ready` already ran (bottom-up), they cached their resolved theme values, and changes don't reflect.

**Why it happens:**
`_ready` runs deepest-first; children initialise before the parent assigns the theme. Theme resource changes do propagate via signals, but any logic that called `get_theme_*` during child `_ready` already captured stale values.

**Prevention checklist:**
- [ ] Set the project theme via **Project Settings -> GUI -> Theme -> Custom**, not via runtime `_ready` assignment.
- [ ] If runtime swap is needed (toggle button), call it via deferred call and ensure children re-query after `theme_changed` signal.
- [ ] In the showcase scene's **NeoCade <-> Godot default** toggle, listen for `theme_changed` and force redraws on dynamic content.

**Warning signs:**
- Theme works on a fresh launch, breaks after toggling.
- Some controls update on toggle, others don't.

**Phase:** implementation (theme toggle) -> QA.

**Sources:** [kidscancode.org — Tree ready order](https://kidscancode.org/godot_recipes/4.x/basics/tree_ready_order/index.html), [godot Window class docs](https://docs.godotengine.org/en/stable/classes/class_window.html).

---

## 2. Editor-vs-Runtime Divergence

### 2.1 The Theme Editor preview is rendered with the editor's scale + filter, not the runtime's **[NON-OBVIOUS, HIGH]**

**What goes wrong:**
You tweak buttons in the Theme editor at editor scale 1.0; runtime project at 1080p with `content_scale_factor = 1.5` shows blurry icons or wrong stylebox proportions. The "Preview" looks crisp; the running game looks soft.

**Why it happens:**
The Theme editor preview uses editor scale + editor texture filter (typically Linear). Runtime uses `Window.content_scale_*` settings + the project's default texture filter (which can differ).

**Prevention checklist:**
- [ ] Always validate via `main.tscn` running, never the Theme editor preview alone.
- [ ] Take MCP screenshots at 1080p, 1440p, 4K, and at content_scale_factor 1.0/1.25/1.5/2.0.
- [ ] Set explicit `texture_filter` per icon entry where it matters (Linear With Mipmaps for SVG-rasterised PNG icons).
- [ ] Document the project settings the theme expects (scale mode, default texture filter) in the addon README.

**Warning signs:**
- Theme looks great in editor; blurry/sharp/jaggy in run.
- Same icon renders crisp in inspector preview, fuzzy in the running button.

**Phase:** QA (mandatory runtime screenshot per scale).

**Sources:** [godot/issues/73491 — Custom SVG icons blurry in editor at 200%](https://github.com/godotengine/godot/issues/73491), [godot/issues/112700 — Button icons crisp/blurry by nesting level](https://github.com/godotengine/godot/issues/112700).

---

### 2.2 Project theme intended for game leaks into the editor **[NON-OBVIOUS, HIGH]**

**What goes wrong:**
User installs NeoCade and sets it as Project theme via Project Settings -> GUI -> Theme. Now their *editor's* LineEdits, Buttons, dialogs render with NeoCade. They didn't ask for that.

**Why it happens:**
A Project theme is also applied to *editor-side* Controls in tool scripts, plugin UI, certain dialogs (LineEdit override is the most reported case). Setting "project theme" doesn't mean "runtime theme only".

**Prevention checklist:**
- [ ] Document this clearly in the README: "Setting NeoCade as Project Theme will also affect plugin/editor controls written in tool mode."
- [ ] Recommend two install paths:
  1. **Game-only**: assign `neocade_theme.tres` to your root Control via `theme` property (not project setting).
  2. **Project-wide**: accept editor leak.
- [ ] Test the theme against common addons (Dialogue Manager, Phantom Camera, etc.) to flag breakage.
- [ ] Provide a "compatible with editor as project theme" sub-claim only after explicit testing.

**Warning signs:**
- User reports "my editor LineEdits look weird now."
- Plugin UI elements render with wrong colours.

**Phase:** distribution (README) + QA (manual cross-test).

**Sources:** [godot/issues/76119 — Project LineEdit override breaks editor LineEdits](https://github.com/godotengine/godot/issues/76119), [godot/issues/97902 — hover_pressed in custom project theme affects editor](https://github.com/godotengine/godot/issues/97902).

---

### 2.3 Plugins assume specific stylebox structure — minimal/empty styleboxes break them **[NON-OBVIOUS, MED]**

**What goes wrong:**
NeoCade uses `StyleBoxEmpty` for some sub-elements (e.g. flat menu items). A user's installed plugin tries `style.set_corner_radius_all(...)` on the resolved stylebox and crashes with "non-existent function on StyleBoxEmpty".

**Why it happens:**
Plugins reach into the project's editor theme via `EditorInterface.get_editor_theme()` and assume `StyleBoxFlat` methods are available. `StyleBoxEmpty` doesn't have them. This was a real issue with godot-minimal-theme.

**Prevention checklist:**
- [ ] Prefer `StyleBoxFlat` with transparent fill and zero borders over `StyleBoxEmpty` whenever the slot might be queried by third-party plugins.
- [ ] Document in README: "If used as editor theme, some plugins assume StyleBoxFlat structure — file issues for any plugin we should accommodate."
- [ ] Reserve `StyleBoxEmpty` for runtime-only contexts.

**Warning signs:**
- Errors in editor console mentioning method-not-found on StyleBoxEmpty.
- Plugins look broken when NeoCade is editor theme.

**Phase:** implementation (stylebox choices) + distribution (README caveat).

**Sources:** [passivestar/godot-minimal-theme/issues/19 — Plugins throw nonexistent function with minimal theme](https://github.com/passivestar/godot-minimal-theme/issues/19).

---

### 2.4 Mouse filter `Pass` vs `Stop` are nearly identical — tooltips don't fall through to controls below

**What goes wrong:**
You add a transparent overlay Control (e.g. a focus glow indicator) on top of a button with `mouse_filter = PASS`, expecting the button below to still emit `mouse_entered` and show its tooltip. It doesn't.

**Why it happens:**
`PASS` consumes the event then forwards to the *parent*, not to siblings *below*. `STOP` and `PASS` are functionally similar for tooltip purposes; only `IGNORE` truly passes through.

**Prevention checklist:**
- [ ] Any decorative overlay Control in the theme/showcase must use `MOUSE_FILTER_IGNORE`.
- [ ] Do not nest a focus indicator as a sibling Control with `PASS` — use a `StyleBox` overlay or `_draw` hook instead.
- [ ] Document expected `mouse_filter` setting for any showcase composite (e.g. card with hover overlay).

**Warning signs:**
- Tooltips don't appear on hover where they should.
- `mouse_entered` signals fire on parent but not on the intended target.

**Phase:** implementation (showcase composites) + QA.

**Sources:** [godot/issues/55430 — Tooltips behave identical Pass/Stop](https://github.com/godotengine/godot/issues/55430), [godot/issues/10511 — Mouse filters Stop/Pass no difference](https://github.com/godotengine/godot/issues/10511).

---

### 2.5 Editor accessibility warnings spam the console for the showcase scene

**What goes wrong:**
Godot 4.5+ added an editor setting that warns about Controls missing `accessibility_name`. NeoCade's showcase has dozens of controls — console floods with warnings, hides real errors.

**Why it happens:**
Default accessibility warnings in 4.6 surface unset accessibility metadata on every Control.

**Prevention checklist:**
- [ ] Set `accessibility_name` on every showcase Control (it's also good practice).
- [ ] Document recommended accessibility names for each Control type variation.
- [ ] Don't suppress the warning globally — fix the metadata.
- [ ] Add a CI check: `grep` showcase .tscn for any Control without `accessibility_name`.

**Warning signs:**
- Editor console flooded with accessibility warnings on showcase open.

**Phase:** implementation (showcase authoring) + accessibility QA.

**Sources:** [godot/issues/117159 — Accessibility warnings on controls misleading](https://github.com/godotengine/godot/issues/117159), [Godot 4.5 release — accessibility](https://godotengine.org/releases/4.5/).

---

## 3. HD/DPI/Scaling

### 3.1 SVG icons are rasterised at import — they don't auto-scale at runtime **[HIGH]**

**What goes wrong:**
You drop SVGs into `addons/neocade_theme/icons/`. At 4K with `content_scale_factor = 2.0`, they look pixellated. The promise of "vector = sharp at any scale" doesn't apply.

**Why it happens:**
Godot rasterises SVG to an ImageTexture at import using a fixed scale (default 1.0). The bitmap doesn't redraw at higher resolutions. Auto-scalable SVG textures exist for editor icons but the runtime story for theme icons is uneven.

**Prevention checklist:**
- [ ] In each SVG's import settings, set **Scale** to match the maximum target (e.g. 2.0 or 4.0) — accept the larger texture size.
- [ ] Or pre-render PNG variants at @1x, @2x, @4x and pick at load via project settings.
- [ ] Set **Filter: Linear With Mipmaps** for icons that may downscale.
- [ ] Test every icon at 1080p / 4K with content_scale 1.0 / 2.0 — flag any that aliases.
- [ ] Avoid icons smaller than 16x16 pre-rasterisation — they antialias poorly.

**Warning signs:**
- Icons look jagged on a HiDPI test display.
- Icons look fine at editor scale but blur in the running scene.

**Phase:** design (icon production pipeline) -> implementation -> QA.

**Sources:** [godot/issues/73491 — Custom SVG icons blurry](https://github.com/godotengine/godot/issues/73491), [godot/issues/16880 — SVG rendering issues](https://github.com/godotengine/godot/issues/16880), [forum — Leverage SVG scalability](https://forum.godotengine.org/t/how-to-leverage-the-scalability-of-svg-in-godot/82292).

---

### 3.2 `DisplayServer.screen_get_scale()` is platform-dependent — don't bake it into the theme

**What goes wrong:**
You write a small helper in the addon: `theme.default_base_scale = DisplayServer.screen_get_scale()`. On Windows and Linux X11 it returns 1.0 always, regardless of actual DPI. On macOS / iOS / web it works. Theme renders correctly on Mac, undersized on Windows HiDPI.

**Why it happens:**
`screen_get_scale()` is implemented only on macOS, iOS, HTML5 as of recent versions. Windows/Linux fall back to 1.0.

**Prevention checklist:**
- [ ] Don't ship runtime DPI auto-scaling logic in v1. Stay declarative — let users configure `Window.content_scale_factor` themselves.
- [ ] Document recommended `content_scale_*` settings in the README.
- [ ] If auto-scale is desired later, fall back to `DisplayServer.screen_get_dpi()` with a heuristic, not `screen_get_scale()`.

**Warning signs:**
- Theme reports correct on Mac, "tiny" on Windows.
- Bug reports correlate with platform.

**Phase:** distribution (README content_scale guidance).

**Sources:** [godot-proposals/issues/2661 — Implement screen_get_scale on Windows/Linux](https://github.com/godotengine/godot-proposals/issues/2661), [forum — What does screen_get_scale actually get](https://forum.godotengine.org/t/what-does-displayserver-screen-get-scale-actually-get/108567).

---

### 3.3 Texture filter mode mismatch — theme icons look wrong when project is Nearest

**What goes wrong:**
VirtuCade is pixel-art, project default texture filter is **Nearest**. Theme icons (HD SVG-rasterised) look pixellated and broken.

**Why it happens:**
Project default `2d/textures/canvas_textures/default_texture_filter` applies to theme icons unless overridden. PopupMenu specifically does not inherit this from parents.

**Prevention checklist:**
- [ ] Set **Linear With Mipmaps** as the filter on each theme icon resource explicitly (override per-resource).
- [ ] Document in README: "NeoCade icons override texture filter to Linear With Mipmaps; this won't conflict with your pixel-art content."
- [ ] In the showcase scene, test with project set to Nearest filter to verify icons survive.

**Warning signs:**
- Icons crisp in tutorial projects, jaggy in the consuming game.
- PopupMenu icons inconsistent with rest of theme.

**Phase:** implementation -> QA (test with Nearest project filter).

**Sources:** [godot/issues/113872 — PopupMenu doesn't inherit Texture Filter](https://github.com/godotengine/godot/issues/113872).

---

### 3.4 Stylebox sizes hard-coded in pixels don't scale with `content_scale_factor`

**What goes wrong:**
You set `corner_radius = 8` for buttons. At `content_scale_factor = 2.0`, the radius is now 4 effective pixels — buttons look sharper than designed.

**Why it happens:**
StyleBox numeric properties are in raw pixels. `content_scale_factor` scales the rendering of Controls, but does not scale stylebox border/radius/shadow values automatically.

**Prevention checklist:**
- [ ] Author all stylebox dimensions assuming `content_scale_factor = 1.0`. Document this baseline.
- [ ] Use `Theme.default_base_scale` if you need a single global scale knob — but be aware not all properties multiply by it.
- [ ] Make corner radii ratios of font size where possible (e.g. radius = 0.5x font_size) so they scale together via type variations.

**Warning signs:**
- Theme looks softer/sharper than designed when run at non-1.0 scale.

**Phase:** design (token system: choose pixel sizes that survive 0.5x-2.0x).

**Sources:** [Multiple resolutions docs](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html), [godot/issues/19887 — Add scale factor to Theme](https://github.com/godotengine/godot/issues/19887).

---

## 4. Accessibility

### 4.1 Focus indicator that vanishes under hover **[HIGH — see also 1.1]**

**What goes wrong:**
Mouse hovers a button after keyboard Tab focused it. Focus ring disappears under hover stylebox replacement.

**Prevention checklist:**
- [ ] Hover styleboxes must **preserve** the focus ring area — design the focus ring as an outline outside the stylebox bounds, not inside.
- [ ] Test focus visibility under every state combination: focus + hover, focus + pressed, focus + disabled, focus + checked.

**Severity:** High — accessibility regression, fails WCAG 2.4.7 Focus Visible.

**Phase:** design + accessibility QA.

**Sources:** [godot/issues/30856](https://github.com/godotengine/godot/issues/30856).

---

### 4.2 Neon palette fails colour-blind safety — magenta/cyan look identical to deuteranopes **[NON-OBVIOUS, HIGH]**

**What goes wrong:**
NeoCade ships with cyan = primary, magenta = secondary, neon green = success, hot pink = danger. To users with deuteranopia (~6% of males), pink/red blend; to users with protanopia, cyan/grey blend. State communicated by colour alone is invisible.

**Why it happens:**
Neon palettes pile saturation on hue but produce similar luminance values for hues that colour-blind users already confuse. Cyan + magenta on dark is high-contrast for trichromats but indistinguishable for many CVD types.

**Prevention checklist:**
- [ ] Run every state combination through deuteranopia, protanopia, tritanopia simulators (e.g. ColorOracle). Not optional.
- [ ] Pair every colour-coded state with a **shape, icon, or text** indicator. (E.g. danger button has both red tint AND warning icon AND bold-weight text.)
- [ ] Ensure luminance contrast >= 4.5:1 for text, >=3:1 for non-text UI elements per WCAG 2.1 AA.
- [ ] Test secondary states (focused vs hovered vs pressed): differentiate by **luminance change**, not hue change.
- [ ] Document the colour-blind validation results in a `ACCESSIBILITY.md` shipped with the addon.

**Warning signs:**
- Primary and secondary buttons look identical in greyscale.
- A simulator pass shows "danger" indistinguishable from "default".

**Phase:** design (palette gate) -> mockup approval -> QA.

**Sources:** [Section 508 — Making Color Usage Accessible](https://www.section508.gov/create/making-color-usage-accessible/), [a11y-collective — Color Blindness Accessibility Guidelines](https://www.a11y-collective.com/blog/color-blind-accessibility-guidelines/).

---

### 4.3 Tooltip readability at small sizes — neon-on-dark loses subpixel hinting

**What goes wrong:**
Tooltip text at 12px in cyan-on-near-black at 1080p — Godot's font subpixel positioning struggles, kerning looks off.

**Why it happens:**
Subpixel positioning provides sharper kerning at small sizes but its quality depends on font hinting and contrast. Low-luminance hue contrast on a dark background can hide hinting artifacts that are still bad on edge devices.

**Prevention checklist:**
- [ ] Tooltip text in NeoCade should use **off-white** (high luminance), not accent colours.
- [ ] Set tooltip font size >= 13px at base scale (avoid 11-12px).
- [ ] Enable subpixel positioning on the bundled Inter font; verify on a non-Retina display.
- [ ] Audit text-on-accent-fill combos for >= 4.5:1 luminance contrast.

**Warning signs:**
- Tooltip readable on Mac Retina, blurry on Windows 1080p.

**Phase:** design (tooltip token) -> QA.

**Sources:** [godot/issues/74694 — Incorrect font rendering despite disabling subpixel](https://github.com/godotengine/godot/issues/74694), [godot/issues/67401 — Kerning issues low resolution](https://github.com/godotengine/godot/issues/67401).

---

### 4.4 Theme defeats Godot 4.5+ accessibility focus-mode behaviour

**What goes wrong:**
Godot 4.5 added screen-reader integration via AccessKit and an accessibility-aware focus mode. NeoCade overrides the focus mode visuals so completely that the accessibility-driven focus indicators (high-contrast, OS-level) are masked.

**Why it happens:**
Theme focus stylebox draws on top of any accessibility focus highlight; OS-level focus assistance can't show through.

**Prevention checklist:**
- [ ] When `accessibility/general/screen_reader_enabled` is detected at runtime, dial down or remove the theme's focus stylebox so OS focus shows through. (Optional v1 nice-to-have; v2 must.)
- [ ] At minimum, ensure the theme's focus stylebox is high-contrast (>=3:1 against any background it sits on) so it works for users without OS-level assistance.
- [ ] Test with Windows Narrator / macOS VoiceOver / NVDA at least once.
- [ ] Don't override `Control.focus_mode` in the theme.

**Warning signs:**
- Bug reports from screen-reader users.

**Phase:** accessibility QA (v1 sanity-check; deeper integration is v2).

**Sources:** [Godot 4.5 release — accessibility](https://godotengine.org/releases/4.5/), [godot/issues/112247 — Accessibility focus mode breaks grab_focus](https://github.com/godotengine/godot/issues/112247).

---

## 5. Fonts & Icons (Distribution from `addons/`)

### 5.1 `res://addons/...` font path doesn't survive when consumer copies only the .tres **[NON-OBVIOUS, HIGH]**

**What goes wrong:**
A user copies `neocade_theme.tres` into their project but forgets the fonts in `addons/neocade_theme/fonts/`. Theme loads, every Label renders Godot's fallback font. Or: user moves the addon folder out of `addons/`, all font paths break.

**Why it happens:**
`.tres` references fonts via `res://addons/neocade_theme/fonts/Inter-Regular.ttf` ext_resource paths. If the folder isn't at exactly that path, references resolve to `null` and Godot silently uses the fallback font.

**Prevention checklist:**
- [ ] Document **the canonical install path** prominently: `res://addons/neocade_theme/`. Don't ask users to choose.
- [ ] Add a runtime assertion/warning helper script (optional) that checks `ResourceLoader.exists(font_path)` and prints a user-friendly error.
- [ ] On Asset Library README, lead with the install instruction screenshot.
- [ ] Use the `uid://` scheme (e.g. `uid://dyblavdboqhji`) for ext_resource references where supported — UIDs survive renames better than paths. (NB: current scaffold already uses a UID for the Theme itself; ensure font references are similarly UID-resolved.)
- [ ] CI check: load the theme in a fresh Godot project, verify no missing font warnings.

**Warning signs:**
- "Theme works but text looks like default Godot font."
- Error: "Failed to load resource '...' from theme."

**Phase:** distribution + QA.

**Sources:** [Godot Using Fonts docs](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html), [Asset Library submission docs](https://docs.godotengine.org/en/stable/community/asset_library/submitting_to_assetlib.html).

---

### 5.2 OFL "reserved name" footgun — don't rename or modify Inter casually **[NON-OBVIOUS, HIGH]**

**What goes wrong:**
You rename `Inter-Regular.ttf` to `NeoCade-Regular.ttf` in the addon. This may violate OFL section 3 (no modification under reserved names) AND OFL section 4 (no use of reserved name in derivative works) — Inter has reserved names.

**Why it happens:**
OFL allows redistribution but restricts certain modifications and use of reserved names. Renaming the file alone may be tolerated but rebranding the *font name inside metadata* is not.

**Prevention checklist:**
- [ ] **Keep all bundled font files at their original filenames** (`Inter-Regular.ttf`, `NotoSans-Regular.ttf`, etc.).
- [ ] Do not rebrand or modify the font binaries.
- [ ] Bundle each font's `OFL.txt` alongside the binary in the same folder.
- [ ] Include a `LICENSE-FONTS.md` aggregating all font licenses with copyright holder names.
- [ ] In Asset Library description, list the bundled fonts explicitly with their licenses.

**Warning signs:**
- Legal complaint from font author.
- Asset Library moderation flag.

**Phase:** distribution (license compliance gate before submission).

**Sources:** [SIL OFL FAQ](https://openfontlicense.org/ofl-faq/), [Inter OFL.txt](https://github.com/google/fonts/blob/main/ofl/inter/OFL.txt), [Inter GitHub](https://github.com/rsms/inter).

---

### 5.3 Tofu boxes appear when text contains glyphs Inter doesn't cover **[MED]**

**What goes wrong:**
A consumer's game has Russian or Korean text. Inter doesn't cover Cyrillic in some weights (improving over time; verify), and definitely doesn't cover CJK. User sees Tofu placeholders. Bug reports come in.

**Why it happens:**
Inter is European-script focused. Without an explicit fallback, Godot tries to use system fonts, which fails on web exports entirely (web export does not load system fonts).

**Prevention checklist:**
- [ ] Bundle **Noto Sans** as the explicit FallBack on the theme's default `Font`.
- [ ] Verify fallback chain works: `default_font.fallbacks = [NotoSans, NotoSansCJK_optional, NotoSansArabic_optional]`.
- [ ] Document additional Noto bundles users can drop in for CJK / Arabic / Devanagari / Hebrew / Thai if they need them.
- [ ] Test the theme by setting a Label to `한국어 中文 Русский العربية` and verify no Tofu — at minimum, Russian + a CJK sample.
- [ ] Be aware: bundling full Noto CJK adds ~30MB; consider whether v1 ships it or documents how to add it.

**Warning signs:**
- "Tofu" boxes in non-Latin text screenshots.
- Issue reports specifically about a language.

**Phase:** implementation (font stack) + QA (multi-script test).

**Sources:** [Godot Using Fonts](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html), [shiena/godot-font-baker](https://github.com/shiena/godot-font-baker), [godot-proposals/issues/9043 — multiple fonts per glyph unit](https://github.com/godotengine/godot-proposals/issues/9043).

---

### 5.4 BMFont vs DynamicFont kerning differences (irrelevant to v1, but a future trap)

**What goes wrong:**
A consumer wants pixel-art UI inside their game and tries to use NeoCade alongside a BMFont for in-game labels. Kerning is computed differently: BMFont uses pre-baked kerning pairs, DynamicFont can use OpenType kern table. Spacing looks inconsistent.

**Prevention checklist:**
- [ ] Bundle DynamicFonts only (Inter, Noto Sans). Document this.
- [ ] Don't ship a BMFont in v1.
- [ ] If a future variant ships pixel-style fonts, use DynamicFont with `subpixel_positioning = OFF` and `oversampling = 0` rather than a true BMFont.

**Phase:** scope discipline (v1 — no BMFont).

**Sources:** [godot/issues/74200 — BMFont .fnt don't work in Godot 4](https://github.com/godotengine/godot/issues/74200).

---

### 5.5 Subpixel-positioning warning misfires on bundled fonts

**What goes wrong:**
After import, Godot prints a warning that subpixel positioning is "auto-disabled" or "selected" inappropriately. Looks like a real issue, ignored, masks a real one.

**Prevention checklist:**
- [ ] Set Inter's subpixel_positioning to **AUTO** explicitly in import settings.
- [ ] Audit imports for warnings; document any spurious ones in CONTRIBUTING.md so contributors don't chase them.

**Phase:** implementation.

**Sources:** [godot/issues/102509 — subpixel warning auto-disabled for pixel fonts](https://github.com/godotengine/godot/issues/102509).

---

## 6. Borrowing from godot-minimal-theme

### 6.1 Minimal-theme values are tuned for **editor scale**, not runtime small UI **[NON-OBVIOUS, HIGH]**

**What goes wrong:**
You copy `corner_radius = 4`, `font_size = 14`, padding values from godot-minimal-theme. They look great in editor (which runs at editor scale ~1.0-1.5). At runtime in a game UI at 1080p without `content_scale_factor`, controls feel slightly off — too tight, too small.

**Why it happens:**
godot-minimal-theme was tuned for the editor environment with `EDSCALE` factors. Many places use non-integer multiplications (1.5 * EDSCALE). Lifting those numbers verbatim doesn't account for runtime baseline.

**Prevention checklist:**
- [ ] Treat godot-minimal-theme as **structural reference** (what entries exist, which controls have what kinds of styleboxes), NOT as numeric source.
- [ ] Author NeoCade numerics from a clean design system — pick base font size 14-16px for runtime, derive spacing/radius from that.
- [ ] Validate at small (640x480 windowed game), medium (1080p), large (4K) — minimal-theme isn't designed for the small case.
- [ ] Document the runtime-first sizing philosophy in `STACK.md` / design tokens.

**Warning signs:**
- Theme looks "correct" in showcase but cramped in a small game window.
- Numeric values match minimal-theme exactly (red flag in code review).

**Phase:** design (token derivation from scratch) -> implementation review.

**Sources:** [godot/issues/112700 — Button icons crisp/blurry by nesting level](https://github.com/godotengine/godot/issues/112700), [passivestar/godot-minimal-theme](https://github.com/passivestar/godot-minimal-theme).

---

### 6.2 Minimal theme is single-accent — multi-accent arcade palette needs full re-architecture

**What goes wrong:**
Minimal theme uses one accent (`#569eff`). NeoCade wants primary/secondary/tertiary accents (e.g. cyan/magenta/green). Naively copying minimal's "set accent everywhere" approach gives every button the same colour.

**Why it happens:**
Single-accent themes use one colour token in many slots. Multi-accent requires **type variations** (PrimaryButton vs SecondaryButton vs DangerButton) at every interactive control + per-state colour mapping.

**Prevention checklist:**
- [ ] Plan type variations **first** in the design phase — list every variation needed (PrimaryButton, SecondaryButton, DangerButton, GhostButton, IconButton, etc.) before authoring.
- [ ] Decide on a 1-of-N pattern: which controls get variation, which use the default. (Default Button -> primary accent, named variations for others.)
- [ ] Don't introduce more than ~3 accent colours; arcade richness comes from **saturation and luminance**, not from many hues.
- [ ] Author one variation completely (incl. all states) before doing the next, so you can compare the cost.

**Warning signs:**
- Variation explosion (>15 variations per control class).
- Same button visual repeated across "primary"/"secondary"/"tertiary" because the accent system wasn't planned.

**Phase:** design (variations spec is a deliverable) -> implementation.

**Sources:** [Theme type variations docs](https://docs.godotengine.org/en/stable/tutorials/ui/gui_theme_type_variations.html), [passivestar/godot-minimal-theme/issues/8 — feedback](https://github.com/passivestar/godot-minimal-theme/issues/8).

---

### 6.3 Minimal theme's StyleBoxEmpty usage breaks plugin assumptions (see 2.3)

Already covered in section 2. Repeats here as a "borrowing trap" because copying `StyleBoxEmpty` choices without understanding why they were made carries forward the problem.

**Prevention:** see 2.3.

---

## 7. Visual Identity Drift (Arcade -> Cyberpunk)

> The user has explicitly rejected cyberpunk/synthwave/vaporwave/scanline aesthetics and the prior research report leaned into them. Drift detection is critical.

### 7.1 Drift trigger: dark-on-dark + neon = synthwave by default **[NON-OBVIOUS, HIGH]**

**What goes wrong:**
Dark background + saturated neon accents is the *literal definition of synthwave*. Designer adds glow effects "for arcade", drops in cyan + magenta, ends up at synthwave/vaporwave without intending to.

**Why it happens:**
Synthwave's visual cocktail: pastels + neons, sunsets, magenta/cyan/violet on dark. Cyberpunk: neon + dark + Japanese kanji + holographic. Both share the dark + neon palette base. Without strong differentiating moves, dark+neon naturally lands in this aesthetic territory.

**Prevention checklist (arcade differentiators to enforce):**
- [ ] **Multiple accent hues, not just two**: include warm colours (orange, yellow, red) — synthwave doesn't use warms heavily.
- [ ] **Higher saturation, higher value**: arcade is bright/cheerful, synthwave is twilight/moody. NeoCade colours should test ABOVE 60% lightness on dark surfaces, not below.
- [ ] **No grid backgrounds, no horizon lines, no chrome typography**: these are explicit synthwave signatures.
- [ ] **No uniform vignette glow**: arcade UIs have dotted "marquee bulbs" feel — discrete, multiple light sources, not haze.
- [ ] **Use rounded/rounded-square shapes prominently**: synthwave/cyberpunk lean angular. Arcade buttons are friendly, rounded, ticket-stub-like.
- [ ] **Daylight references**: arcade-by-day is the brief — surfaces should feel illuminated rather than glowing-in-the-dark.

**Detection ritual (mockup gate):**
- [ ] For each mockup, ask: "Could this be the menu screen of a Hotline Miami / Cyberpunk 2077 / Tron clone?" If yes -> drift.
- [ ] Side-by-side: NeoCade mockup vs reference (Round 1 / Dave & Buster's interior photo / Pac-Man arcade cabinet). Visual kinship should be clear.

**Severity:** High — wrong identity ships, user must rework.

**Phase:** design (mockup gate) -> mockup approval (must be approved against this checklist).

**Sources:** [Lethal Audio — Synthwave/Cyberpunk shared aesthetic](https://www.lethalaudio.com/the-shared-aesthetics-of-synthwave-and-cyberpunk/), [Aesthetics Wiki — Synthwave](https://aesthetics.fandom.com/wiki/Synthwave), [Aesthetics Wiki — Cyberpunk](https://aesthetics.fandom.com/wiki/Cyberpunk), [Joel Chan — Outrun aesthetic deconstructed](https://medium.com/@cywjoel/outrun-the-aesthetic-deconstructed-dbd3cd8679b7).

---

### 7.2 Drift trigger: glow effects creep in via "soft shadow" or "outer stroke"

**What goes wrong:**
Designer adds a 4px outer glow to focus indicators "to make them pop". Adds gentle inner glow to buttons "for depth". The cumulative result is every control bleeding light — synthwave neon-sign aesthetic.

**Why it happens:**
Each glow is locally justified ("needed for visibility"); the cumulative effect crosses the line.

**Prevention checklist:**
- [ ] Hard rule: **No more than 1 glowing element on screen at a time.** If a control has a glow, others must not.
- [ ] Reserve "glow" for a single semantic role (e.g. focus only) and use solid edges everywhere else.
- [ ] Audit each mockup with a "count the glows" check.
- [ ] **DO NOT use drop shadows for elevation in v1.** Per `SUMMARY.md` Conflict 3, `FEATURES.md` AF-13, and `ARCHITECTURE.md` elevation-via-color: drop shadows are categorically forbidden in v1 because GL Compatibility over-renders shadow alpha (~2×, Godot issue #23640) and the StyleBoxFlat shadow path renders behind content as a "ghosted clone." Glows are synthwave-native and forbidden too. **Convey elevation through the tonal surface ramp (color stops) only.** Optional: 1px lighter top-bevel border on raised buttons (`border_width_top=1` + lighter color) — implements arcade button cap highlight without engaging the broken shadow path.

**Detection ritual:**
- [ ] If a screenshot of the showcase scene at 50% opacity still looks bright everywhere, glow is everywhere.

**Phase:** design (glow budget) -> mockup approval -> QA.

**Sources:** [Steam Community — Synthwave/Vaporwave/OutRun guide](https://steamcommunity.com/sharedfiles/filedetails/?id=2355896312).

---

### 7.3 Drift trigger: scanlines, grids, holograms in textures or "decorative" StyleBoxes

**What goes wrong:**
A `StyleBoxTexture` is used for a panel and the texture has scanlines or a tron-grid pattern. Or LineEdit borders have a barcode pattern. Each is "fun arcade detail" individually; collectively they tip into cyberpunk-coded territory.

**Prevention checklist:**
- [ ] Forbid scanline patterns, hologram fringes, cathode-ray-tube curvature textures, monospaced kanji glyphs, glitch artefacts in the v1 texture set.
- [ ] If using StyleBoxTexture, prefer flat or noise-free textures; arcade texture cues are limited to ticket stubs / button caps / marquee bulbs / chrome edges.
- [ ] Maintain a curated mood board of explicitly-arcade visual references; reject mood-board contributions matching synthwave imagery.

**Phase:** design (mood board curation, texture set discipline).

**Sources:** [Joel Chan — Outrun aesthetic](https://medium.com/@cywjoel/outrun-the-aesthetic-deconstructed-dbd3cd8679b7), [Pixso — Cyberpunk UI review](https://pixso.net/tips/cyberpunk-ui/).

---

### 7.4 Drift trigger: typographic choices

**What goes wrong:**
Designer "adds arcade flair" with chrome 3D titles, italic-skewed headings, racing-stripe underlines. These cues are synthwave/Outrun-coded, not arcade-coded.

**Prevention checklist:**
- [ ] Stick to Inter (or similar geometric sans-serif) for **all** UI text including headings.
- [ ] No 3D bevels, no chrome gradients on text, no pixel fonts in v1 (already a project constraint).
- [ ] Headings: bold weight + larger size. That's it.
- [ ] Letter spacing variation is allowed but should be subtle (<5% tracking), not Outrun-style wide spacing.

**Phase:** design (typography tokens locked early).

**Sources:** Project decision logs (NeoCade explicitly rejects pixel/synthwave typography per PROJECT.md).

---

## 8. MCP Usage Pitfalls

### 8.1 MCP screenshot timing — capture before Control has rendered post-theme-swap **[NON-OBVIOUS, MED]**

**What goes wrong:**
You toggle the theme in the showcase and immediately capture a screenshot via MCP. The screenshot shows mid-transition state or stale theme.

**Why it happens:**
Theme propagation runs after the next frame's `theme_changed` signal fires; redraws happen on the subsequent frame. MCP screenshot calls don't await frames.

**Prevention checklist:**
- [ ] Insert a deliberate `await get_tree().process_frame` (or 2 frames) between theme apply and screenshot in MCP-driven QA scripts.
- [ ] When automating QA, prefer launching the project fresh per theme variant rather than toggling at runtime.
- [ ] Verify each captured screenshot shows the expected state — a hash of expected theme markers (e.g. accent colour at known pixel) catches stale captures.

**Phase:** QA (MCP automation harness).

**Sources:** [godot Window class docs](https://docs.godotengine.org/en/stable/classes/class_window.html), [HaD0Yun/godot-mcp](https://github.com/HaD0Yun/Gopeak-godot-mcp).

---

### 8.2 Headless rendering: `--headless` disables ALL rendering — can't screenshot

**What goes wrong:**
You assume `--headless` lets you capture screenshots in CI without a display. It doesn't — `--headless` disables the rendering pipeline entirely.

**Why it happens:**
`--headless` is meant for editor scripting / asset import / test runs, not for visual capture. Off-screen rendering exists as a proposal but isn't shipped.

**Prevention checklist:**
- [ ] Run MCP screenshot QA against a **windowed** Godot session, not headless.
- [ ] On CI, use a virtual display (e.g. Xvfb on Linux, headless mode is not equivalent).
- [ ] Document the QA harness requirements in CONTRIBUTING.md.

**Phase:** QA (infra).

**Sources:** [godot-proposals/issues/5790 — off-screen rendering](https://github.com/godotengine/godot-proposals/issues/5790).

---

### 8.3 Scene state staleness — MCP scene CRUD doesn't auto-reload editor view

**What goes wrong:**
You modify the showcase scene via MCP, then capture from a still-open editor. The editor displays the pre-edit state.

**Prevention checklist:**
- [ ] Reload the scene in the editor after MCP edits, or close-and-reopen.
- [ ] Or run MCP edits against a saved scene then launch a fresh project run for capture.

**Phase:** QA (process).

---

### 8.4 MCP screenshot resolution defaults to viewport size, not designed scale

**What goes wrong:**
Screenshots are captured at the running viewport's actual pixels, which may be lower than the user's HiDPI native. You sign off the theme based on a 1280x720 capture; users see it on 4K and find issues.

**Prevention checklist:**
- [ ] Set explicit window size before capturing: capture at 1080p AND 1440p AND 4K for sign-off.
- [ ] Don't trust default capture resolution.

**Phase:** QA harness.

---

## 9. Distribution Pitfalls

### 9.1 Asset Library: addon detection requires `addons/...` folder structure

**What goes wrong:**
You ship NeoCade with files in repo root. Asset Library install drops files into the consumer's project root, polluting their tree.

**Prevention checklist:**
- [ ] Repo structure must place all addon files under `addons/neocade_theme/` from the **repo root**.
- [ ] Test the install via Asset Library before submission — install into a fresh project, verify only `addons/neocade_theme/` is created.
- [ ] Include `.gitignore` and `.gitattributes` in repo root.
- [ ] License file (LICENSE / LICENSE.md) at repo root AND a copy inside `addons/neocade_theme/`.

**Phase:** distribution.

**Sources:** [Asset Library submission docs](https://docs.godotengine.org/en/stable/community/asset_library/submitting_to_assetlib.html).

---

### 9.2 No `plugin.cfg` is fine, but the README must say so explicitly

**What goes wrong:**
Users expect every addon to have `plugin.cfg` and look for it in Project Settings -> Plugins to "enable". They don't find it and report the addon as broken.

**Why it happens:**
NeoCade is not an editor plugin (no `EditorPlugin` script) — just a Theme resource + fonts. No `plugin.cfg` needed. But user expectation is otherwise.

**Prevention checklist:**
- [ ] README explicitly states: "This addon is not an editor plugin. Do not look for it in Project Settings -> Plugins. Apply the theme via [step-by-step]."
- [ ] Lead with a 30-second install GIF or screenshot.
- [ ] Show both install paths: "Apply per-scene" (recommended) and "Apply project-wide" (with caveat re: editor leak — see 2.2).

**Phase:** distribution (README).

**Sources:** [Installing plugins docs](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html).

---

### 9.3 `.tres` text vs binary: keep `.tres` for git-ability, accept the size cost

**What goes wrong:**
You convert to `.res` binary "to reduce size" before submission. Users can no longer diff theme changes; contributions become harder.

**Prevention checklist:**
- [ ] Ship the theme as `.tres` (text format). Already the project decision.
- [ ] Add `.gdignore` in any folder containing development artefacts (mockups, references) so Godot doesn't try to import them.
- [ ] Beware: "Convert Text Resources To Binary On Export" project setting can cause remapped resource loading failures — leave it OFF for the addon's own resources.

**Phase:** distribution.

**Sources:** [godot/issues/63606 — Remapped resources fail with binary on export](https://github.com/godotengine/godot/issues/63606).

---

### 9.4 The `uid://` scheme survives renames; bare `res://` paths don't

**What goes wrong:**
A user's project has a different UID for `addons/neocade_theme/neocade_theme.tres` because they re-imported. Internal references break.

**Prevention checklist:**
- [ ] Use `uid://` references inside the .tres for cross-resource references (font files, icon files).
- [ ] When exporting, ensure UIDs are stable across re-imports.
- [ ] Test fresh install: install addon, immediately open showcase scene, verify no `Failed to load 'res://...'` warnings.

**Phase:** distribution + QA.

**Sources:** [Asset Library submission docs](https://docs.godotengine.org/en/stable/community/asset_library/submitting_to_assetlib.html).

---

### 9.5 Asset Library icon URL must be raw, square, >=128x128

**What goes wrong:**
You submit with a Markdown-rendered GitHub URL. Asset Library can't fetch it. Submission rejected.

**Prevention checklist:**
- [ ] Icon URL must be `raw.githubusercontent.com/...` direct link.
- [ ] Icon must be square (1:1) and >= 128x128.
- [ ] PNG, not SVG (Asset Library may not render SVG correctly).

**Phase:** distribution.

**Sources:** [Asset Library submission docs](https://docs.godotengine.org/en/stable/community/asset_library/submitting_to_assetlib.html).

---

## 10. Showcase Scene Risks

### 10.1 Some controls render empty/invisible without explicit content **[MED]**

**What goes wrong:**
Showcase shows a `Tree` node with no items — looks like a blank rectangle. `RichTextLabel` with no `bbcode_text` — empty box. `ItemList` with no items — empty. Reviewers see "broken styling" when it's "no content".

**Prevention checklist:**
- [ ] Every control in the showcase must have realistic sample content.
  - `Tree`: at least 3 levels of items with icons, expanded.
  - `RichTextLabel`: paragraph with bold/italic/link/quote/code-block to exercise BBCode styling.
  - `ItemList`: 5-10 items with icons.
  - `TextEdit`: multi-line text with syntax highlighting if used.
  - `OptionButton`: at least 5 options.
  - `MenuButton`: with 2-level submenu.
  - `Tabs/TabContainer`: at least 3 tabs with distinct content.
  - `ProgressBar`: shown at 0%, 50%, 100%, indeterminate.
  - `ColorPicker`: with a sample colour selected.
  - `Tree` with selection, focus, multi-column.
- [ ] Document the showcase scope in `SHOWCASE.md` matching gui/control_gallery.

**Phase:** showcase implementation.

**Sources:** [godot-demo-projects gui/control_gallery](https://github.com/godotengine/godot-demo-projects/tree/master/gui/control_gallery).

---

### 10.2 Some control entries crash if a referenced sub-resource is missing

**What goes wrong:**
You omit `tab_unselected` stylebox on `TabContainer`, expecting a default. At runtime, errors flood the console; tab area renders incorrectly.

**Prevention checklist:**
- [ ] For each control class, enumerate **every** theme entry (color, constant, stylebox, font, font_size, icon) and verify it's defined.
- [ ] Use Godot's Theme editor "Add All Items" feature per control type to seed the entry list.
- [ ] CI check: open the .tres, walk every theme entry against the Control's expected set; flag missing.

**Phase:** implementation (entry-completeness audit) + QA.

**Sources:** [godot/issues/81235 — Error on stylebox + theme overrides](https://github.com/godotengine/godot/issues/81235), [godot/issues/110548 — Error messages with custom StyleBox](https://github.com/godotengine/godot/issues/110548).

---

### 10.3 Theme toggle button must survive its own state when the theme is detached

**What goes wrong:**
The "NeoCade <-> Godot default" toggle button is itself styled by NeoCade. When toggled to Godot default, the button's hover/focus states fall back to default theme, looking jarring next to the floating panel that documents what's happening.

**Prevention checklist:**
- [ ] Style the toggle button with **inline theme overrides on the button itself**, not via the project theme. This way it stays consistent across toggle states.
- [ ] Or: design the toggle to look identical under Godot default and NeoCade — use neutral styling (rounded grey button with a clear icon).
- [ ] Make the toggle visibly bigger than other controls per project requirement, but ensure its identity is anchored independent of the theme being toggled.

**Phase:** showcase implementation.

---

## Technical Debt Patterns

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Copy stylebox values from godot-minimal-theme verbatim | Fast initial styling | Tuning inherits editor-scale assumptions; produces a theme that looks "minimal-ish" without identity (6.1) | Never for v1 — defeats the goal of a distinct identity |
| Use `StyleBoxEmpty` for transparent slots | Easy to author | Plugins assuming StyleBoxFlat methods crash (2.3) | Runtime-only contexts where editor leak is impossible |
| Skip type variations, override on instances | Faster authoring | Inconsistent multi-accent palette; redundant overrides; (1.3) | MVP only — must refactor before v1 release |
| Hard-code pixel sizes without scale factor | Predictable rendering | Doesn't scale to HiDPI; wrong on 4K (3.4) | Acceptable since project constraint is no scale-aware; document the baseline |
| Single accent colour | Consistent palette | Misses arcade richness | Never — multi-accent is core to identity |
| Pre-rasterise PNG icons at @1x only | Smaller addon size | Blurs at HiDPI (3.1) | Never — bundle SVG with explicit import scale |
| Bundle Inter only, no Noto fallback | Smaller download | Tofu boxes for non-Latin users (5.3) | Never — at minimum bundle Noto Sans Regular |
| Use `--headless` for screenshot CI | Simpler infra | No rendering happens (8.2) | Never — virtual display required |

## Integration Gotchas

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| Godot Asset Library | Repo root is the addon root | Root must be repo root; addon files under `addons/neocade_theme/` |
| Project Settings -> GUI -> Theme -> Custom | Assume runtime-only | Editor controls in tool scripts also use this — document leak (2.2) |
| AccessKit / screen reader | Theme overrides accessibility focus | Lower theme focus assertiveness when accessibility detected (4.4) |
| Font fallback chain | Set on Theme but not on Font resource | `default_font.fallbacks = [NotoSans, ...]` on the FontFile, not the Theme |
| MCP screenshot capture | Capture immediately after theme apply | Await 1-2 frames; or relaunch project per capture (8.1) |
| Plugin theme expectations | Expect StyleBoxFlat methods | Plugins call methods that fail on StyleBoxEmpty (2.3) |
| Web export | Assume system fonts available | Web has no system fonts; bundle ALL fallbacks |
| GL Compatibility | Tune on Forward+ | Tune and screenshot on Compatibility (1.5) |

## Performance Traps

Themes themselves rarely have perf traps at the UI scale the addon serves. Documented anyway:

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Hundreds of unique StyleBoxFlat instances per type variation | Memory growth on theme load | Reuse StyleBox instances across variations where state visually matches | Beyond ~200 distinct stylebox resources in one theme |
| Heavy shadow blur on many simultaneously-visible controls | 2D draw stutter on low-end | Cap shadow_size; prefer flat depth cues | Visible at 60+ shadowed controls on screen, GL Compat |
| Large bundled CJK font (~30MB) | Slow project import / load | Defer CJK to optional add-on bundle | Always; document the size before bundling |

## Security Mistakes

The theme addon has minimal security surface. Notable:

| Mistake | Risk | Prevention |
|---------|------|------------|
| Bundling fonts under wrong license claim | OFL/Apache violation; possible takedown | Verify each font's license; bundle license file alongside; never modify font internals (5.2) |
| Allowing external resource fetch in stylebox script | Arbitrary code on theme load | No scripted styleboxes (1.6); v1 is pure data |
| Linking to outside CDN for icons | Network requirement at runtime | Bundle all assets locally; no external paths |

## UX Pitfalls

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| Theme silently swallows user content (Tree with no items, see 10.1) | Reviewer thinks NeoCade is broken | Showcase populated with realistic content always |
| Theme applied to editor breaks plugins (2.3, 2.2) | User reverts theme, blames NeoCade | Document the "editor leak" caveat prominently; recommend per-scene application |
| Focus ring hidden by hover (1.1, 4.1) | Keyboard-only / accessibility users lost | Focus as outer ring outside stylebox bounds |
| Tooltips render with default theme (1.7) | Inconsistent user experience | Theme TooltipPanel + TooltipLabel explicitly |
| Drift to cyberpunk identity (Section 7) | User installed expecting "arcade" — gets dark/edgy | Mockup-gate against arcade reference photos, not synthwave imagery |
| Tofu glyphs in non-Latin text (5.3) | Localised builds look broken | Bundle Noto Sans fallback with explicit chain |

## "Looks Done But Isn't" Checklist

Things that pass casual review but hide gaps:

- [ ] **Every Control class styled?** Verify against Godot 4.6 class list (Button, MenuButton, OptionButton, CheckBox, CheckButton, ColorPickerButton, LinkButton, TextureButton, Label, RichTextLabel, LineEdit, TextEdit, CodeEdit, SpinBox, ProgressBar, HSlider, VSlider, HScrollBar, VScrollBar, Tree, ItemList, OptionButton, PopupMenu, PopupPanel, AcceptDialog, ConfirmationDialog, FileDialog, ColorPicker, Calendar, GraphEdit, GraphNode, TabContainer, TabBar, SplitContainer, ScrollContainer, Panel, PanelContainer, Window, MarginContainer, Separator, ReferenceRect, TooltipPanel, TooltipLabel, FoldableContainer if applicable). Don't trust "looks complete" without an explicit checklist.
- [ ] **Every state styled?** For each interactive control: normal, hover, pressed, disabled, focus, hover_pressed, checked/unchecked where applicable. CheckBox + CheckButton both have all 8.
- [ ] **Focus visible on every state?** Walk Tab key through showcase, screenshot every focus ring, verify visibility against the underlying stylebox.
- [ ] **Tooltip styled?** Hover every showcase Control with tooltip text — confirm popup matches theme.
- [ ] **Popup-class Controls styled?** OptionButton dropdown, MenuButton submenu, ColorPickerButton picker, PopupMenu standalone, AcceptDialog, ConfirmationDialog, FileDialog — open each, screenshot.
- [ ] **Multi-script text rendered?** A label set to `English 한국어 中文 Русский العربية ਪੰਜਾਬੀ` — no tofu in any script the addon claims to support.
- [ ] **Colour-blind validation passed?** Each state distinguishable in deuteranopia / protanopia / tritanopia simulations.
- [ ] **WCAG 2.1 AA contrast met?** Every text/background combo measured (>=4.5:1 for body, >=3:1 for large text and non-text UI).
- [ ] **GL Compatibility renderer screenshot pass?** All visual checks repeated under Compatibility, not just default renderer.
- [ ] **HD scale screenshot pass?** Showcase at 1080p, 1440p, 4K with content_scale 1.0, 1.5, 2.0.
- [ ] **Asset Library install dry-run?** Fresh project, install via Asset Library, verify single-folder install at `addons/neocade_theme/`, no errors on showcase open.
- [ ] **Theme-as-editor-theme cross-test?** Set NeoCade as editor theme, verify common plugins (Dialogue Manager, etc.) don't break.
- [ ] **No StyleBoxEmpty breakage?** No editor console errors when used as project theme.
- [ ] **Font license files bundled?** OFL.txt for Inter, OFL.txt for Noto, LICENSE-FONTS.md aggregated.
- [ ] **README install paths documented?** Both per-scene and project-wide, with caveats.
- [ ] **README explicitly says "not an editor plugin"?** Prevents Project Settings -> Plugins confusion.
- [ ] **Toggle button works?** Showcase NeoCade<->Godot default toggle survives multiple toggles without state loss.
- [ ] **Visual identity gate?** A neutral viewer asked "what genre?" answers "arcade", not "synthwave/cyberpunk/Tron".

## Recovery Strategies

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Identity drift discovered post-mockup-approval | HIGH | Re-do mockup phase; do not ship; treat as full design re-spin (Section 7) |
| Tofu in non-Latin text reported post-release | LOW | Patch release adding/fixing Noto fallback; document language coverage |
| Plugin breakage from StyleBoxEmpty (2.3) | MED | Replace StyleBoxEmpty with transparent StyleBoxFlat, point release |
| OFL violation flagged | HIGH | Restore original font filenames + metadata; reissue with corrected bundle; update license docs; possible Asset Library re-submission |
| Editor-theme leak surprise (2.2) | LOW | Add docs caveat + recommended install path; no code change |
| Font path break from `addons/` move (5.1) | MED | Switch ext_resources to UID; re-test fresh install |
| Focus ring invisible (1.1) | MED | Re-author focus stylebox as outer ring; verify all states |
| HD blur from SVG raster (3.1) | LOW | Adjust import scale per icon; re-import; ship point release |
| Crash on theme inspector edit (1.8) | N/A (env issue) | Document workaround; await Godot point release |

## Pitfall-to-Phase Mapping

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| 1.1 Focus stylebox overlay | design + impl | Tab-walkthrough screenshots, all states |
| 1.2 Type variation font inheritance | impl | Per-variation visual diff vs spec |
| 1.3 Theme override doesn't cascade | impl | Doc-only verification; don't use overrides for cascading |
| 1.4 StyleBoxFlat shadow alpha bug | impl | In-engine shadow tuning, screenshot diff |
| 1.5 GL Compat differences | impl + QA | Dual-renderer screenshot pass |
| 1.6 Scripted StyleBox crash | design (constraint) | Code review: no Stylebox script files |
| 1.7 PopupMenu separate Window | impl | Open every popup in showcase, screenshot |
| 1.8 Inspector crash (env) | process | Save-often discipline, git checkpoints |
| 1.9 Theme application timing | impl | Toggle button stress test |
| 2.1 Editor preview vs runtime | QA | Runtime-only screenshot sign-off |
| 2.2 Project theme editor leak | distribution | README documents leak |
| 2.3 Plugin StyleBoxEmpty crash | impl | Cross-test with common plugins |
| 2.4 Mouse filter Pass/Stop | impl | Tooltip behavior verification |
| 2.5 Accessibility warning spam | impl | Set accessibility_name on showcase |
| 3.1 SVG icon raster scale | impl | HiDPI screenshot pass |
| 3.2 screen_get_scale platform-spec | distribution | README content_scale guidance |
| 3.3 Texture filter mismatch | impl | Test with Nearest project filter |
| 3.4 Pixel sizes don't scale | design | Token system documents baseline |
| 4.1 Focus disappears under hover | design + a11y QA | Tab walkthrough |
| 4.2 Colour-blind safety | design (palette gate) + a11y QA | Simulator runs |
| 4.3 Tooltip readability | design + a11y QA | Small-screen test |
| 4.4 Accessibility focus mode | a11y QA | Screen reader test (sanity) |
| 5.1 Font path break from addons/ | distribution | Fresh-install test |
| 5.2 OFL reserved name violation | distribution | License compliance gate |
| 5.3 Tofu missing glyphs | impl | Multi-script label test |
| 5.4 BMFont vs DynamicFont | scope (no BMFont) | N/A |
| 5.5 Subpixel warning | impl | Import settings audit |
| 6.1 Minimal-theme editor scale | design | Token derivation from scratch |
| 6.2 Single-accent vs multi-accent | design | Variations spec deliverable |
| 7.1-7.4 Identity drift | design (mockup gate) + ongoing | Reference-photo comparison gate |
| 8.1-8.4 MCP usage | QA infra | Capture harness validation |
| 9.1 Asset Library folder structure | distribution | Fresh-install dry-run |
| 9.2 No plugin.cfg confusion | distribution | README clarity |
| 9.3 .tres vs .res | distribution | Resource format set |
| 9.4 UID resolution | distribution | Fresh-install dry-run |
| 9.5 Asset Library icon URL | distribution | Pre-submission checklist |
| 10.1 Empty controls in showcase | impl | Showcase content audit |
| 10.2 Missing theme entries crash | impl + QA | Entry completeness audit |
| 10.3 Toggle button state | impl | Multi-toggle stress test |

## Top 5 NON-OBVIOUS Pitfalls (highest-leverage flags)

1. **Focus stylebox is overlay, not a state — invisible on pressed/checked controls (1.1).** Most teams discover this only when an accessibility audit fails. Worth a dedicated sub-task in the design phase.
2. **PopupMenu / OptionButton dropdown is a separate Window — doesn't inherit overrides, theme, or texture filter (1.7).** Almost every theme ships with mismatched popup styling on first release.
3. **Type variations don't inherit fonts from base type (1.2).** Looks correct in theme editor preview, breaks in showcase. Hours of debugging unless flagged.
4. **Dark + neon = synthwave by default; arcade requires explicit warm-hue and high-luminance moves (7.1).** The biggest identity risk and the hardest to detect without a curated reference set.
5. **Minimal-theme numeric values are tuned for editor scale; lifting them produces a theme that looks "minimal-ish" without distinct identity (6.1).** Tempting shortcut that defeats the project's distinctness goal.

## Sources

### Official Godot docs
- [Godot StyleBox class reference](https://docs.godotengine.org/en/stable/classes/class_stylebox.html)
- [Godot Theme class reference](https://docs.godotengine.org/en/stable/classes/class_theme.html)
- [Theme Type Variations](https://docs.godotengine.org/en/stable/tutorials/ui/gui_theme_type_variations.html)
- [Using Theme Editor](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_theme_editor.html)
- [Using Fonts](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html)
- [Multiple Resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html)
- [Asset Library Submission](https://docs.godotengine.org/en/stable/community/asset_library/submitting_to_assetlib.html)
- [Installing Plugins](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html)
- [Window class](https://docs.godotengine.org/en/stable/classes/class_window.html)
- [Godot 4.6 Release notes](https://godotengine.org/releases/4.6/)
- [Godot 4.5 Release (accessibility)](https://godotengine.org/releases/4.5/)

### Issues & PRs
- [godot/issues/30856 — Focus layer covering pressed/hover/disabled](https://github.com/godotengine/godot/issues/30856)
- [godot/issues/74489 — Focus color replaced by font hover color](https://github.com/godotengine/godot/issues/74489)
- [godot-proposals/issues/8134 — Change focus styling](https://github.com/godotengine/godot-proposals/issues/8134)
- [godot-proposals/issues/12242 — Hover styles replace focus](https://github.com/godotengine/godot-proposals/issues/12242)
- [godot/issues/80731 — Font not inherited in type variation](https://github.com/godotengine/godot/issues/80731)
- [godot/issues/82199 — Type variations don't work for Panel/Label/etc](https://github.com/godotengine/godot/issues/82199)
- [godot/issues/80732 — Type variation dropdown empty](https://github.com/godotengine/godot/issues/80732)
- [godot/issues/67010 — Theme inheritance broken for custom types](https://github.com/godotengine/godot/issues/67010)
- [godot/issues/23640 — StyleBoxFlat shadow opacity too strong](https://github.com/godotengine/godot/issues/23640)
- [godot/pull/98162 — shadow_size=-1 disables shadows](https://github.com/godotengine/godot/pull/98162)
- [godot/issues/82504 — OpenGL Light3D Shadow Blur ignored](https://github.com/godotengine/godot/issues/82504)
- [godot/issues/74267 — Crash with scripted StyleBox in project theme](https://github.com/godotengine/godot/issues/74267)
- [godot/issues/110548 — Custom StyleBox error messages](https://github.com/godotengine/godot/issues/110548)
- [godot/issues/115500 — UI Theme edit crashes editor in 4.6](https://github.com/godotengine/godot/issues/115500)
- [godot/issues/68774 — Clicking Theme StyleBox in inspector crashes](https://github.com/godotengine/godot/issues/68774)
- [godot/issues/113872 — PopupMenu doesn't inherit Texture Filter](https://github.com/godotengine/godot/issues/113872)
- [godot/issues/93644 — Popup Menu style overridden](https://github.com/godotengine/godot/issues/93644)
- [godot/issues/81107 — PopupMenu position doesn't respect MarginContainer](https://github.com/godotengine/godot/issues/81107)
- [godot/issues/55430 — Tooltips behave identical Pass/Stop](https://github.com/godotengine/godot/issues/55430)
- [godot/issues/10511 — Mouse filters Stop/Pass no difference](https://github.com/godotengine/godot/issues/10511)
- [godot/issues/76119 — Project LineEdit override breaks editor](https://github.com/godotengine/godot/issues/76119)
- [godot/issues/97902 — hover_pressed in custom theme affects editor](https://github.com/godotengine/godot/issues/97902)
- [godot/issues/73491 — Custom SVG icons blurry in editor](https://github.com/godotengine/godot/issues/73491)
- [godot/issues/16880 — SVG rendering issues](https://github.com/godotengine/godot/issues/16880)
- [godot/issues/112700 — Button icons crisp/blurry by nesting level](https://github.com/godotengine/godot/issues/112700)
- [godot/issues/74694 — Incorrect font rendering despite disabling subpixel](https://github.com/godotengine/godot/issues/74694)
- [godot/issues/67401 — Kerning issues low resolution](https://github.com/godotengine/godot/issues/67401)
- [godot/issues/74200 — BMFont .fnt don't work in Godot 4](https://github.com/godotengine/godot/issues/74200)
- [godot/issues/102509 — Subpixel warning misfires](https://github.com/godotengine/godot/issues/102509)
- [godot/issues/63606 — Remapped resources fail with binary on export](https://github.com/godotengine/godot/issues/63606)
- [godot/issues/19887 — Add scale factor to Theme](https://github.com/godotengine/godot/issues/19887)
- [godot-proposals/issues/2661 — Implement screen_get_scale Windows/Linux](https://github.com/godotengine/godot-proposals/issues/2661)
- [godot-proposals/issues/5790 — Off-screen rendering](https://github.com/godotengine/godot-proposals/issues/5790)
- [godot-proposals/issues/9043 — Multiple fonts per glyph unit](https://github.com/godotengine/godot-proposals/issues/9043)
- [godot/issues/117159 — Accessibility warnings misleading](https://github.com/godotengine/godot/issues/117159)
- [godot/issues/112247 — Accessibility focus mode breaks grab_focus](https://github.com/godotengine/godot/issues/112247)
- [passivestar/godot-minimal-theme/issues/19 — Plugins crash with minimal theme](https://github.com/passivestar/godot-minimal-theme/issues/19)
- [passivestar/godot-minimal-theme/issues/8 — Feedback / suggestions](https://github.com/passivestar/godot-minimal-theme/issues/8)

### Aesthetic / identity references
- [Lethal Audio — Synthwave/Cyberpunk shared aesthetics](https://www.lethalaudio.com/the-shared-aesthetics-of-synthwave-and-cyberpunk/)
- [Aesthetics Wiki — Synthwave](https://aesthetics.fandom.com/wiki/Synthwave)
- [Aesthetics Wiki — Cyberpunk](https://aesthetics.fandom.com/wiki/Cyberpunk)
- [Joel Chan — Outrun aesthetic deconstructed](https://medium.com/@cywjoel/outrun-the-aesthetic-deconstructed-dbd3cd8679b7)
- [Steam — Retrowave/Synthwave/Vaporwave/OutRun guide](https://steamcommunity.com/sharedfiles/filedetails/?id=2355896312)
- [Pixso — Cyberpunk UI review](https://pixso.net/tips/cyberpunk-ui/)

### Accessibility
- [Section 508 — Color usage accessibility](https://www.section508.gov/create/making-color-usage-accessible/)
- [a11y-collective — Color blindness guidelines](https://www.a11y-collective.com/blog/color-blind-accessibility-guidelines/)
- [MDN — Web Accessibility colors and luminance](https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Colors_and_Luminance)

### Fonts & licensing
- [SIL OFL FAQ](https://openfontlicense.org/ofl-faq/)
- [Inter font GitHub](https://github.com/rsms/inter)
- [Inter on Google Fonts](https://fonts.google.com/specimen/Inter)
- [Inter OFL.txt](https://github.com/google/fonts/blob/main/ofl/inter/OFL.txt)

### Tooling
- [HaD0Yun/Gopeak-godot-mcp](https://github.com/HaD0Yun/Gopeak-godot-mcp)
- [shiena/godot-font-baker — bake CJK MSDF without bundling binaries](https://github.com/shiena/godot-font-baker)

### Community resources
- [bugnet.io — Theme override not applying to children](https://bugnet.io/blog/fix-godot-theme-override-not-applying)
- [forum — How to leverage SVG scalability](https://forum.godotengine.org/t/how-to-leverage-the-scalability-of-svg-in-godot/82292)
- [forum — How to make Compatibility renderer look good](https://forum.godotengine.org/t/how-to-make-compatibility-renderer-look-good/84139)
- [forum — How to modulate PopupMenu items](https://forum.godotengine.org/t/how-to-modulate-a-popupmenus-items/54136)
- [kidscancode — Tree ready order](https://kidscancode.org/godot_recipes/4.x/basics/tree_ready_order/index.html)
- [godot-demo-projects gui/control_gallery](https://github.com/godotengine/godot-demo-projects/tree/master/gui/control_gallery)

---
*Pitfalls research for: Godot 4.6 UI Theme addon (NeoCade)*
*Researched: 2026-05-04*
*Confidence: HIGH on issue-cited claims; MED on synthesised claims (esp. visual identity drift, sections 7.x).*
