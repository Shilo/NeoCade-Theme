# Feature Research — NeoCade Theme

**Domain:** Godot 4.6 native UI Theme (.tres) addon — feature surface is the COVERAGE MATRIX (which Controls are styled, which theme entries, which type variations, which showcase sections)
**Researched:** 2026-05-04
**Confidence:** HIGH for Control coverage and theme-entry enumeration (cross-checked with official Godot 4.6 docs and the godot-minimal-theme reference theme); MEDIUM for token taxonomy (synthesized from Material 3 + observed Godot defaults + prototype critique); MEDIUM for showcase scene (cross-referenced with control_gallery.tscn).

---

## Executive Summary

The "features" of a Godot Theme project are not behavioral features — they are **coverage**. v1 ships when (a) every Godot 4.6 built-in Control class has a complete styling entry, (b) a coherent semantic token system underpins those entries, (c) a small set of justified type variations exists, and (d) a showcase scene proves it on screen.

**Coverage target.** **35 user-facing Control classes** require theme entries in v1 (per Section 1's authoritative enumeration; superseding the earlier "32 user-facing" count which was stale). NeoCade matches all 35 in v1; editor-only types (FlatButton, MainScreenButton, EditorInspector*, BottomPanelButton, etc.) are **deferred** to v1.x.

**Token system critique.** The prototype's token panel is a strong start but has gaps the implementation must fix (reconciled with `SUMMARY.md` Conflict 2):
1. **Surface tokens are correct in spirit but missing one rung** — Base/Secondary/Panel/Raised/Elevated covers backgrounds but lacks an "overlay" token for popups. Add `surface.overlay` (mapped to M3 `surface-container-highest`). **`surface.sunken` REJECTED for v1** per SUMMARY.md Conflict 2 — depth-via-color-only philosophy doesn't have a natural sunken story; inputs are visually distinguished via focus/normal stylebox + corner radius.
2. **No semantic role aliases** — the prototype names accents by hue (Cyan/Pink/etc.) but never by role (primary/success/warning/danger/info). Implementation must define both: physical (`accent.cyan`) AND semantic (`role.primary -> accent.cyan`). Themes that only have hue names lock you into a palette; semantic aliases let v2 swap palettes.
3. **Typography tokens conflate role and weight** — the prototype shows Stroke/Strong/Text/Muted/Dim, which is text-COLOR variants only. There is no typography SCALE (sizes/weights for h1/h2/body/caption). Add a separate `type.*` scale for sizes and a `text.*` scale for colors.

**What NeoCade adds beyond minimal.** Six explicit type variations (PrimaryButton, DangerButton, GhostButton, IconButton, H1/H2/H3 labels, CodeLabel/MonoLabel), plus an opinionated focus ring (1.5px outer + 1px inner inset = "double-ring" arcade glow that meets WCAG without being cyberpunk).

**Anti-features locked.** No: light mode, animations, custom shaders, pixel/scanline textures, glow filters, vertical text orientations, RTL-specific stylebox redesigns (use the built-in `_mirrored` variants), per-locale font swaps, editor-only theming.

---

## Feature Landscape

### Table Stakes (Theme is Broken Without These)

These are the absolute minimum to claim "feature-complete dark theme matching godot-minimal-theme's bar". Missing any one = the theme is incomplete and reviewers will reject.

| # | Feature | Why Expected | Complexity | Notes |
|---|---------|--------------|------------|-------|
| TS-1 | Every BaseButton variant styled (Button, CheckBox, CheckButton, OptionButton, MenuButton, LinkButton, ColorPickerButton) with all 5 states (normal, hover, pressed, disabled, focus) | Buttons are the most-used Control; partial styling = visible inconsistency | HIGH | 6 stylebox states × 7 button classes; Button.normal is the keystone — every other button stylebox inherits its visual language |
| TS-2 | All text inputs styled (LineEdit, TextEdit, CodeEdit, SpinBox) with normal/focus/read_only states + caret + selection + placeholder colors | Text input must signal focus state clearly for keyboard users (WCAG) | HIGH | Caret color and selection color are accessibility-critical |
| TS-3 | Containers (Panel, PanelContainer, MarginContainer, separators, splits) | Layout chrome shows on every screen; bad container styling = bad first impression | MEDIUM | Mostly stylebox + separation constants |
| TS-4 | Range controls (HSlider, VSlider, ProgressBar, TextureProgressBar, HScrollBar, VScrollBar) with grabbers + tick marks + fill | Sliders/scrollbars used everywhere in editor and game UIs | MEDIUM | Slider grabber icon needs custom NeoCade glyph |
| TS-5 | List/tree views (ItemList, Tree) with selected/focused/hovered/cursor states | Tree is the most complex control to theme; minimal theme nails it, we must too | HIGH | 9+ stylebox states per class, custom expand/collapse arrow icons, guide lines |
| TS-6 | Tabs (TabBar, TabContainer) with selected/unselected/hovered/disabled/focus states + close/increment/decrement icons | Tab styling is the second-most-visible chrome after buttons | MEDIUM | Need scroll arrow icons, drop_mark for drag-reorder |
| TS-7 | Popups (PopupMenu, PopupPanel, AcceptDialog, ConfirmationDialog, FileDialog) | Native dialogs render with theme; unstyled dialogs look broken | MEDIUM | PopupMenu has check/radio/submenu icons that must be authored |
| TS-8 | Window theming (title bar color, close icon, embedded_border stylebox) | Embedded windows render in-game; missing window theme = floating untitled boxes | LOW | Most often invisible if game uses fullscreen, but required for editor parity |
| TS-9 | Labels and text rendering (Label, RichTextLabel) with font/font_size/colors | Every UI has labels; the typography token here cascades to all text | LOW | Foundation for type variations H1/H2/H3 |
| TS-10 | ColorPicker + ColorPickerButton (sample_focus, picker icons, slider grabbers) | Used in editor color properties and any in-game color editing | MEDIUM | 16+ icons, several styleboxes; can largely reuse Slider styling |
| TS-11 | Tooltips (TooltipPanel) | Hover help is universal; bare tooltips look broken | LOW | Single panel stylebox |
| TS-12 | Focus indicators visible on every focusable Control | WCAG 2.1 AA non-negotiable; required by PROJECT.md accessibility constraint | HIGH | Single shared focus stylebox philosophy applied to ~25 classes |
| TS-13 | Bundled OFL fonts (Inter, Noto Sans) with bold/italic/weights | Theme without bundled fonts = broken rendering on systems without Inter | LOW | Done at packaging stage; just add font resources to theme |
| TS-14 | High-resolution at 1080p, 1440p, 4K (no pixel-art StyleBoxTextures, no aliasing) | PROJECT.md requires HD; aliasing = unprofessional | LOW | Use StyleBoxFlat exclusively, antialiased corners enabled |
| TS-15 | Showcase scene rendering every above Control | Without it, no QA possible; PROJECT.md requires it | HIGH | Mirrors godot-demo-projects/gui/control_gallery scope |
| TS-16 | Theme toggle button (NeoCade ↔ Godot default) on showcase | PROJECT.md requires it explicitly; communicates value to evaluators | LOW | One floating button, larger than peer controls |

### Differentiators (NeoCade-Specific Polish)

Features that go beyond godot-minimal-theme's coverage and establish NeoCade's identity. These are where NeoCade earns the "neo arcade" name without leaning cyberpunk.

| # | Feature | Value Proposition | Complexity | Notes |
|---|---------|-------------------|------------|-------|
| DF-1 | Semantic type variations: PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton | Out of the box, users get role-based buttons without authoring custom styles. Material 3 parity, Godot-native via `theme_type_variation`. | MEDIUM | 5 variations × 5 states = 25 styleboxes, but most reuse Button base with color overrides |
| DF-2 | Heading type variations: HeaderLarge (H1), HeaderMedium (H2), HeaderSmall (H3), Caption, Code (mono) for Label and RichTextLabel | Eliminates the need for users to override font_size on every Label; gives the theme an editorial typographic system | LOW | Each variation = different font_size + optional weight + color; no styleboxes |
| DF-3 | "Double-ring" focus indicator (1.5px outer cyan stroke + 1px inset darker stroke, rounded to match radius scale) | Distinctive, accessible, arcade-coded without being cyberpunk. Higher contrast than minimal theme's single ring. | MEDIUM | One shared focus stylebox, 24+ classes reference it |
| DF-4 | Accent palette of 8 hues (Cyan, Blue, Pink, Violet, Green, Amber, Red, Orange) with semantic role aliases | Lets users build colorful arcade UIs without picking colors. Aliases keep theming swappable in v2. | LOW | Tokens only, no styleboxes; surfaces as theme color entries |
| DF-5 | 4-rung corner radius scale (0/4/8/12px = none/sm/md/lg) applied consistently | Gives the theme a unified geometric rhythm; users can author styled controls that "fit in" | LOW | Shared constant across all StyleBoxFlat |
| DF-6 | Dedicated icon authoring at 16/24/32px sizes for the ~80 theme icons | Crisp icons at all DPI; Godot's default theme icons are 16px and look fuzzy at 4K | MEDIUM | Use SVG sources, export PNG at 1x/2x/4x; godot supports SVG natively but rasterized PNG is more predictable across renderers |
| DF-7 | RichTextLabel BBCode demonstration in showcase (bold, italic, color, code, table, link) | Shows users that NeoCade's font stack handles BBCode richly; Inter+JetBrainsMono pairing visible | LOW | Just BBCode content in a showcase RichTextLabel; theme already handles it via normal/bold/italic/mono fonts |
| DF-8 | Showcase "Theme Token Gallery" panel rendering color/typography/radius/spacing tokens as visual swatches | Self-documenting theme — users see the design system on screen, not just the result | MEDIUM | Static layout in showcase scene; informs designers and reviewers |
| DF-9 | Disabled state genuinely de-emphasized (50% opacity + saturation drop), not just dimmed text | Common pitfall: themes only dim font_color, leaving stylebox unchanged. NeoCade dims both. | LOW | Apply to disabled stylebox color across all relevant classes |
| DF-10 | Unified "elevation" model on surfaces: Base < Secondary < Panel < Raised < Elevated < Overlay | Gives the dark theme depth without shadows (which look bad in Godot StyleBoxFlat) | LOW | Tokens map to 5-6 grayscale steps, used by Panel, PanelContainer, Window, Popup, etc. |

### Anti-Features (Explicitly Out of Scope for v1)

These look attractive but create problems for a v1 Godot theme. PROJECT.md already locks several; this list adds technical anti-features researchers/implementers will be tempted to add.

| # | Anti-Feature | Why Tempting | Why Problematic | Alternative |
|---|-------------|--------------|-----------------|-------------|
| AF-1 | Glow / outer-glow effects on focus ring | Iconic neon look | Godot StyleBoxFlat doesn't render outer glow; would require StyleBoxTexture (raster, doesn't scale to 4K) or shaders (PROJECT.md forbids). Looks fuzzy and dates fast. | Use crisp double-ring stroke with bright accent color — reads as "neon" without softness |
| AF-2 | Scanline overlays on panels | "Arcade CRT" reference | Same scaling problem; conflicts with PROJECT.md "no synthwave/scanlines" decision. | Solid surface tokens; arcade feel comes from accent palette and corner radii |
| AF-3 | Animated/transitioning hover states beyond Godot's built-in | Modern web feel | Godot Theme has no animation primitives; would require GDScript on every Control. PROJECT.md forbids. | Distinct hover stylebox with brighter color — instant change reads as "responsive" |
| AF-4 | Light mode | "Themes should support both" | Doubles design + QA surface; PROJECT.md defers to v2. | Single dark theme; v2 adds light mode |
| ~~AF-5~~ | ~~Mobile-specific theme variant (`neocade_mobile_theme.tres`)~~ — **STRICKEN 2026-05-04** | _was: "Should work on mobile"_ | **No longer an anti-feature.** Per user constraint update, mobile variant is v1 must-have alongside desktop primary. See `.planning/research/CROSS-PLATFORM.md` for tap-target/type-scale/spacing specifics, token-sharing via `@tool` script generator, and dedicated Mobile Variant Authoring + Cross-Platform Export Validation roadmap phases. | _superseded — see CROSS-PLATFORM.md_ |
| AF-6 | Editor-only types (FlatButton, FlatMenuButton, MainScreenButton, BottomPanelButton, EditorInspector*, etc.) | godot-minimal-theme styles them | These are not in the public Control class hierarchy; they affect Godot's editor chrome only. PROJECT.md scopes to "every built-in Control class". | Skip in v1; if applied as editor theme, the user's editor will fall back to default for these — acceptable for v1 |
| AF-7 | Custom syntax-highlight color scheme for CodeEdit | "Code looks good" | Syntax highlighting is per-language and not a theme entry — it's set by individual nodes/scripts. CodeEdit theme entries (bookmark/breakpoint icons) are in scope; syntax colors are not. | Style CodeEdit's StyleBox + gutter colors only. Document that syntax colors are app-level |
| AF-8 | TextureButton / NinePatchRect / VideoStreamPlayer styling | These are Controls | They have NO theme entries — they render textures provided by the consuming scene. Theme can't style them. | Document in README that these are content-driven, not theme-driven |
| AF-9 | Per-platform fonts (system font on macOS, Segoe UI on Windows) | Native feel | Defeats "bundled fonts" requirement; produces inconsistent screenshots; one of the documented values is unified visual identity. | Inter + Noto Sans bundled, used everywhere |
| AF-10 | Theme-bundled sound effects | Arcade has sound | PROJECT.md explicitly forbids; theme is visual only. | Out of scope, document in README |
| AF-11 | Distinct theming per Container subclass (HBoxContainer ≠ VBoxContainer styling) | More granular control | Containers are invisible by default; only PanelContainer/MarginContainer/Split/Tab need styling. Theming HBox/VBox/FlowContainer/Grid/Center wastes effort. | Style only Containers that have visible chrome (Panel*, Split*, Margin, Tab*); leave layout-only containers untouched (separation constants only) |
| AF-12 | StyleBoxTexture (raster 9-slice) anywhere | "Custom button shapes" | Doesn't scale to 4K; conflicts with HD constraint; harder to swap palettes in v2. | StyleBoxFlat exclusively; corner_radius and border_width handle all needs |
| AF-13 | Drop shadows on panels via StyleBoxFlat shadow | "Material elevation" | Godot's StyleBoxFlat shadow is offset-only and renders behind content — reads as "ghosted clone", not elevation. Looks worse than no shadow. | Use surface tokens (Base/Panel/Raised/Elevated as different gray values) for visual elevation |
| AF-14 | Per-Control type variations no one will use (e.g., "BlueButton", "RedButton") | "Lots of variations" | Bloats theme file; users override colors directly. Variations should be ROLE-based (Primary/Danger/Ghost), not COLOR-based. | Ship 5 button variations max; document how to author custom ones |

---

## (1) Complete Godot 4.6 Built-in Control Class Inventory

Sourced from official Godot 4.6 docs (Control, BaseButton, Container, Range, ScrollBar, Slider, Window, AcceptDialog, Popup pages) and cross-checked with godot-minimal-theme's coverage. **42 user-facing Control classes** across 8 categories. NeoCade v1 styles all that have theme entries (35 classes — content-only Controls like NinePatchRect have none).

### Category A: Buttons (BaseButton family) — 7 classes

| Class | Inherits | Has Theme Entries? | NeoCade v1? |
|-------|----------|-------------------|-------------|
| BaseButton | Control | No (abstract) | n/a |
| Button | BaseButton | Yes | YES |
| CheckBox | Button | Yes | YES |
| CheckButton | Button | Yes | YES |
| OptionButton | Button | Yes | YES |
| MenuButton | Button | Yes | YES |
| LinkButton | BaseButton | Yes | YES |
| ColorPickerButton | Button | Yes | YES |
| TextureButton | BaseButton | No (texture-driven) | NO (anti-feature AF-8) |

### Category B: Text Display & Input — 5 classes

| Class | Inherits | Theme Entries? | NeoCade v1? |
|-------|----------|---------------|-------------|
| Label | Control | Yes | YES |
| RichTextLabel | Control | Yes | YES |
| LineEdit | Control | Yes | YES |
| TextEdit | Control | Yes | YES |
| CodeEdit | TextEdit | Yes (extra) | YES (basic — chrome only, not syntax colors) |

### Category C: Range-Based — 8 classes

| Class | Inherits | Theme Entries? | NeoCade v1? |
|-------|----------|---------------|-------------|
| Range | Control | No (abstract) | n/a |
| ProgressBar | Range | Yes | YES |
| TextureProgressBar | Range | No (texture-driven) | NO (AF-8) |
| ScrollBar | Range | No (abstract) | n/a |
| HScrollBar | ScrollBar | Yes | YES |
| VScrollBar | ScrollBar | Yes | YES |
| Slider | Range | Yes | YES (base) |
| HSlider | Slider | Yes (inherits) | YES |
| VSlider | Slider | Yes (inherits) | YES |
| SpinBox | Range | Inherits LineEdit + adds icons | YES |

### Category D: Selection & Trees — 4 classes

| Class | Inherits | Theme Entries? | NeoCade v1? |
|-------|----------|---------------|-------------|
| ItemList | Control | Yes | YES |
| Tree | Control | Yes | YES |
| TabBar | Control | Yes | YES |
| TabContainer | Container | Yes | YES |

### Category E: Containers (Layout) — 14 classes

| Class | Inherits | Theme Entries? | NeoCade v1? | Notes |
|-------|----------|---------------|-------------|-------|
| Container | Control | No (abstract) | n/a | |
| BoxContainer | Container | Constants only (separation) | YES | Set separation tokens |
| HBoxContainer | BoxContainer | Constants only | YES | Inherits |
| VBoxContainer | BoxContainer | Constants only | YES | Inherits |
| FlowContainer | Container | Constants only (h_separation, v_separation) | YES | Constants only |
| HFlowContainer | FlowContainer | Constants only | YES | |
| VFlowContainer | FlowContainer | Constants only | YES | |
| GridContainer | Container | Constants (h_separation, v_separation) | YES | |
| MarginContainer | Container | Constants (margin_*) | YES | |
| AspectRatioContainer | Container | None | n/a | Layout-only |
| CenterContainer | Container | None | n/a | Layout-only |
| PanelContainer | Container | Stylebox panel | YES | |
| ScrollContainer | Container | Styleboxes panel + focus | YES | |
| SplitContainer | Container | No (abstract — but constants on H/VSplitContainer) | n/a | |
| HSplitContainer | SplitContainer | Constants + grabber icon | YES | |
| VSplitContainer | SplitContainer | Constants + grabber icon | YES | |
| SubViewportContainer | Container | None | n/a | Content-driven |
| FoldableContainer | Container (Godot 4.4+) | Yes — full chrome | YES | Used in control_gallery; required |

### Category F: Visual Elements (mostly content-driven) — 5 classes

| Class | Inherits | Theme Entries? | NeoCade v1? |
|-------|----------|---------------|-------------|
| Panel | Control | Yes (single `panel` stylebox) | YES |
| ColorRect | Control | None | NO (content) |
| TextureRect | Control | None | NO (AF-8) |
| NinePatchRect | Control | None | NO (AF-8) |
| ReferenceRect | Control | None | NO (debug-only) |
| Separator (HSeparator, VSeparator) | Control | Stylebox + constant | YES |

### Category G: Windows & Dialogs (Window family) — 7 classes

| Class | Inherits | Theme Entries? | NeoCade v1? |
|-------|----------|---------------|-------------|
| Window | Viewport | Yes | YES |
| Popup | Window | Inherits Window | YES |
| PopupPanel | Popup | Yes (panel stylebox) | YES |
| PopupMenu | Popup | Yes (extensive) | YES |
| AcceptDialog | Window | Yes | YES |
| ConfirmationDialog | AcceptDialog | Inherits | YES |
| FileDialog | ConfirmationDialog | Yes (icons + colors) | YES |

### Category H: Menus & Misc — 4 classes

| Class | Inherits | Theme Entries? | NeoCade v1? |
|-------|----------|---------------|-------------|
| MenuBar | Control | Yes | YES |
| ColorPicker | VBoxContainer | Yes (extensive) | YES |
| GraphEdit | Control | Yes | YES (basic) |
| GraphNode | GraphElement → Container | Yes | YES (basic) |
| GraphElement | Container | Yes | YES (constants/colors) |
| GraphFrame | GraphElement | Yes | YES (basic) |
| Tooltip (rendered via TooltipPanel theme type) | n/a | Yes (panel stylebox + tooltip color) | YES |

### Special: The "Tooltip" type

Tooltips are rendered via the `TooltipPanel` and `TooltipLabel` theme types — there is no Tooltip control class. Both must be themed.

**Total user-facing Control classes with theme entries to populate in v1: 35**

---

## (2) Per-Control Theme Entry Matrix

This is the implementation checklist. For each Control, list every theme entry that v1 must populate. "S" = Stylebox, "C" = Color, "F" = Font, "FS" = Font Size, "I" = Icon, "K" = Constant.

### Buttons

#### Button (and inherited by CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton)
- **S (11):** normal, normal_mirrored, hover, hover_mirrored, pressed, pressed_mirrored, hover_pressed, hover_pressed_mirrored, disabled, disabled_mirrored, focus
- **C (12):** font_color, font_pressed_color, font_hover_color, font_hover_pressed_color, font_focus_color, font_disabled_color, font_outline_color, icon_normal_color, icon_pressed_color, icon_hover_color, icon_hover_pressed_color, icon_disabled_color, icon_focus_color
- **F (1):** font
- **FS (1):** font_size
- **K (5):** h_separation, icon_max_width, align_to_largest_stylebox, line_spacing, outline_size

**Notes:** This is the keystone class. Every button type variation extends this. Mirrored variants are required for RTL languages — define them as references to the same stylebox unless asymmetry is intentional (don't redesign for RTL).

#### CheckBox (extends Button)
- **S:** normal, normal_mirrored (background — usually transparent)
- **C:** font_pressed_color, font_hover_pressed_color
- **I (8):** checked, checked_disabled, unchecked, unchecked_disabled, radio_checked, radio_checked_disabled, radio_unchecked, radio_unchecked_disabled
- **K (1):** check_v_offset

**NeoCade-specific:** Checkbox icons must be drawn at 24px source for crisp 1x/2x display. Use a tick mark INSIDE a rounded square; "checked" state fills with role.primary.

#### CheckButton (extends Button) — toggle switch style
- **S:** inherits Button styleboxes (normal, hover, etc.)
- **C:** font_focus_color, font_pressed_color, font_hover_pressed_color
- **I (4):** checked, checked_disabled, unchecked, unchecked_disabled
- **K (1):** check_v_offset

**NeoCade-specific:** Checkbutton icon is a horizontal toggle pill; "checked" slides accent color to right.

#### OptionButton
- **S, C, F, FS:** inherits Button
- **I (2):** arrow, arrow_disabled
- **K (1):** arrow_margin

**Notes:** Arrow icon is a downward chevron; reuse OptionButton.arrow icon across MenuButton and TabContainer.menu for consistency.

#### MenuButton
- **S, C, F, FS, K:** inherits Button

**Notes:** No additional theme entries beyond Button. Use FlatButton-style stylebox by default (transparent background) so MenuButtons don't look like primary buttons.

#### ColorPickerButton
- **S, C, F, FS, K:** inherits Button

**Notes:** This control renders a swatch over the button background; theme just needs to provide the wrapper. The swatch is content-driven.

#### LinkButton (extends BaseButton — NOT Button)
- **C (5):** font_color, font_pressed_color, font_hover_color, font_focus_color, font_disabled_color, font_outline_color
- **F (1):** font
- **FS (1):** font_size
- **K (2):** outline_size, underline_spacing
- **S (1):** focus

**NeoCade-specific:** font_color = role.link (cyan); hover adds underline; pressed slightly darker.

### Text Display & Input

#### Label
- **S (2):** normal, focus
- **C (3):** font_color, font_outline_color, font_shadow_color
- **F (1):** font
- **FS (1):** font_size
- **K (6):** line_spacing, outline_size, paragraph_spacing, shadow_offset_x, shadow_offset_y, shadow_outline_size

**Notes:** Set shadow_color to transparent (no shadow by default — can be enabled per-instance).

#### RichTextLabel
- **S (2):** normal, focus
- **C (8):** default_color, font_outline_color, font_selected_color, font_shadow_color, selection_color, table_border, table_even_row_bg, table_odd_row_bg
- **F (5):** normal_font, bold_font, italic_font, bold_italic_font, mono_font
- **FS (5):** normal_font_size, bold_font_size, italic_font_size, bold_italic_font_size, mono_font_size
- **K (8):** line_separation, outline_size, table_h_separation, table_v_separation, shadow_offset_x, shadow_offset_y, shadow_outline_size, text_highlight_h_padding, text_highlight_v_padding

**NeoCade-specific:** mono_font = JetBrains Mono (or Inter when JetBrains is too heavy a dep); table_even_row_bg = surface.panel, table_odd_row_bg = surface.raised → zebra striping.

#### LineEdit
- **S (3):** normal, focus, read_only
- **C (8):** caret_color, clear_button_color, clear_button_color_pressed, font_color, font_outline_color, font_placeholder_color, font_selected_color, font_uneditable_color, selection_color (color of selection rectangle)
- **F (1):** font
- **FS (1):** font_size
- **I (1):** clear
- **K (3):** caret_width, minimum_character_width, outline_size

**NeoCade-specific:** focus stylebox uses role.primary as border (matches button focus); caret_color = role.primary for high visibility.

#### TextEdit
- **S (3):** normal, focus, read_only
- **C (~17):** background_color, current_line_color, caret_color, caret_background_color, font_color, font_readonly_color, font_selected_color, font_outline_color, font_placeholder_color, selection_color, search_result_color, search_result_border_color, word_highlighted_color
- **F (1):** font
- **FS (1):** font_size
- **K (2):** line_spacing, outline_size

**NeoCade-specific:** Use mono font (JetBrains Mono) for TextEdit when used as a code area. Selection_color = role.primary at 30% alpha.

#### CodeEdit (extends TextEdit) — additional entries
- **S (1):** completion (the popup panel)
- **C (12):** bookmark_color, brace_mismatch_color, breakpoint_color, code_folding_color, completion_background_color, completion_existing_color, completion_scroll_color, completion_scroll_hovered_color, completion_selected_color, executing_line_color, folded_code_region_color, line_length_guideline_color
- **I (9):** bookmark, breakpoint, can_fold, can_fold_code_region, completion_color_bg, executing_line, folded, folded_code_region, folded_eol_icon
- **K (3):** completion_lines, completion_max_width, completion_scroll_width

**Notes:** Style CodeEdit's chrome (gutter, completion popup, breakpoint glyphs) only. Syntax highlighting colors are app-level (not theme entries) — anti-feature AF-7.

### Range Controls

#### ProgressBar
- **S (2):** background, fill
- **C (2):** font_color, font_outline_color
- **F (1):** font
- **FS (1):** font_size
- **K (1):** outline_size

**NeoCade-specific:** fill stylebox uses role.primary; corner_radius matches background to avoid bleed.

#### Slider (HSlider, VSlider inherit)
- **S (3):** slider, grabber_area, grabber_area_highlight
- **I (4):** grabber, grabber_disabled, grabber_highlight, tick
- **K (3):** center_grabber, grabber_offset, tick_offset

**NeoCade-specific:** grabber icon = filled circle with double-ring focus glyph; tick = small vertical dash.

#### HScrollBar / VScrollBar
- **S (5):** scroll, scroll_focus, grabber, grabber_highlight, grabber_pressed
- **I (6):** decrement, decrement_highlight, decrement_pressed, increment, increment_highlight, increment_pressed

**NeoCade-specific:** Hide increment/decrement buttons (set icons to transparent 1×1 or zero-size) — modern UI convention; also set scroll background to transparent for floating look.

#### SpinBox
- Inherits LineEdit theme entries (it embeds a LineEdit internally)
- **I (4):** updown, up, down, up_disabled, down_disabled, up_pressed, down_pressed (some variants)

### Selection & Trees

#### ItemList
- **S (9):** panel, focus, cursor, cursor_unfocused, hovered, selected, selected_focus, hovered_selected, hovered_selected_focus
- **C (7):** font_color, font_hovered_color, font_hovered_selected_color, font_selected_color, font_outline_color, guide_color, scroll_hint_color
- **F (1):** font
- **FS (1):** font_size
- **I (1):** scroll_hint
- **K (5):** h_separation, icon_margin, line_separation, outline_size, v_separation

#### Tree
- **S (16):** panel, focus, cursor, cursor_unfocused, button_hover, button_pressed, custom_button, custom_button_hover, custom_button_pressed, hovered, hovered_dimmed, hovered_selected, hovered_selected_focus, selected, selected_focus, title_button_normal, title_button_hover, title_button_pressed
- **C (15):** children_hl_line_color, custom_button_font_highlight, drop_position_color, font_color, font_disabled_color, font_hovered_color, font_hovered_dimmed_color, font_hovered_selected_color, font_outline_color, font_selected_color, guide_color, parent_hl_line_color, relationship_line_color, scroll_hint_color, title_button_color
- **F (2):** font, title_button_font
- **FS (2):** font_size, title_button_font_size
- **I (12):** arrow, arrow_collapsed, arrow_collapsed_mirrored, checked, checked_disabled, indeterminate, indeterminate_disabled, scroll_hint, select_arrow, unchecked, unchecked_disabled, updown
- **K (~26):** button_margin, check_h_separation, children_hl_line_width, dragging_unfold_wait_msec, draw_guides, draw_relationship_lines, h_separation, icon_h_separation, icon_max_width, inner_item_margin_*, item_margin, outline_size, parent_hl_line_*, relationship_line_width, scroll_*, scrollbar_margin_*, v_separation

**Notes:** Tree is the highest-complexity control to theme. Plan a half-day for it alone.

#### TabBar
- **S (7):** tab_selected, tab_unselected, tab_hovered, tab_disabled, tab_focus, button_highlight, button_pressed
- **C (10):** drop_mark_color, font_disabled_color, font_hovered_color, font_outline_color, font_selected_color, font_unselected_color, icon_disabled_color, icon_hovered_color, icon_selected_color, icon_unselected_color
- **F (1):** font
- **FS (1):** font_size
- **I (6):** close, decrement, decrement_highlight, drop_mark, increment, increment_highlight
- **K (5):** h_separation, hover_switch_wait_msec, icon_max_width, outline_size, tab_separation

#### TabContainer
- **S (7):** panel, tabbar_background, tab_selected, tab_unselected, tab_hovered, tab_disabled, tab_focus
- **C (10):** same as TabBar
- **F (1) / FS (1):** font, font_size
- **I (7):** decrement, decrement_highlight, drop_mark, increment, increment_highlight, menu, menu_highlight
- **K (5):** icon_max_width, icon_separation, outline_size, side_margin, tab_separation

### Containers

#### Panel
- **S (1):** panel

#### PanelContainer
- **S (1):** panel

#### MarginContainer
- **K (4):** margin_left, margin_top, margin_right, margin_bottom

#### ScrollContainer
- **S (2):** panel, focus
- **K (~6):** separation (horizontal), separation_v, scrollbar_h_separation, scrollbar_v_separation

#### HSplitContainer / VSplitContainer
- **I (1):** grabber
- **K (3):** autohide, minimum_grab_thickness, separation

#### BoxContainer (HBox, VBox), FlowContainer (HFlow, VFlow), GridContainer
- **K (2):** separation (Box), h_separation + v_separation (Flow, Grid)

#### FoldableContainer
- **S (3+):** panel, title_panel, title_panel_collapsed (or similar — verify on impl)
- **C (3):** title_color, title_hovered_color, title_collapsed_color
- **F (1):** title_font
- **FS (1):** title_font_size
- **I (1):** expand (chevron)
- **K (3):** h_separation, title_padding_*

### Visual Elements

#### Separator (HSeparator, VSeparator)
- **S (1):** separator
- **K (1):** separation

### Windows & Dialogs

#### Window
- **S (2):** embedded_border, embedded_unfocused_border
- **C (2):** title_color, title_outline_modulate
- **F (1):** title_font
- **FS (1):** title_font_size
- **I (2):** close, close_pressed
- **K (5):** close_h_offset, close_v_offset, resize_margin, title_height, title_outline_size

#### PopupPanel
- **S (1):** panel

#### PopupMenu
- **S (5):** panel, hover, separator, labeled_separator_left, labeled_separator_right
- **C (7):** font_color, font_accelerator_color, font_disabled_color, font_hover_color, font_outline_color, font_separator_color, font_separator_outline_color
- **F (2):** font, font_separator
- **FS (2):** font_size, font_separator_size
- **I (10):** checked, checked_disabled, unchecked, unchecked_disabled, radio_checked, radio_checked_disabled, radio_unchecked, radio_unchecked_disabled, submenu, submenu_mirrored
- **K (9):** h_separation, v_separation, indent, icon_max_width, gutter_compact, item_start_padding, item_end_padding, outline_size, separator_outline_size

#### AcceptDialog / ConfirmationDialog (inherits)
- **S (1):** panel
- **K (3):** buttons_min_height, buttons_min_width, buttons_separation

#### FileDialog (inherits ConfirmationDialog)
- **C (3):** file_disabled_color, file_icon_color, folder_icon_color
- **I (17):** back_folder, create_folder, favorite, favorite_down, favorite_up, file, file_thumbnail, folder, folder_thumbnail, forward_folder, list_mode, parent_folder, reload, sort, thumbnail_mode, toggle_filename_filter, toggle_hidden
- **K (1):** thumbnail_size

### Menus & Misc

#### MenuBar
- **S (10):** normal, normal_mirrored, hover, hover_mirrored, pressed, pressed_mirrored, hover_pressed, hover_pressed_mirrored, disabled, disabled_mirrored
- **C (7):** font_color, font_disabled_color, font_focus_color, font_hover_color, font_hover_pressed_color, font_outline_color, font_pressed_color
- **F (1) / FS (1):** font, font_size
- **K (2):** h_separation, outline_size

#### ColorPicker
- **S (3):** picker_focus_circle, picker_focus_rectangle, sample_focus
- **C (1):** focused_not_editing_cursor_color
- **I (16):** add_preset, bar_arrow, color_hue, color_script, expanded_arrow, folded_arrow, menu_option, overbright_indicator, picker_cursor, picker_cursor_bg, sample_bg, sample_revert, screen_picker, shape_circle, shape_rect, shape_rect_wheel
- **K (6):** center_slider_grabbers, h_width, label_width, margin, sv_height, sv_width

#### GraphEdit
- **S (3):** panel, panel_focus, menu_panel
- **C (8):** activity, connection_hover_tint_color, connection_rim_color, connection_valid_target_tint_color, grid_major, grid_minor, selection_fill, selection_stroke
- **I (7):** grid_toggle, layout, minimap_toggle, snapping_toggle, zoom_in, zoom_out, zoom_reset
- **K (3):** connection_hover_thickness, port_hotzone_inner_extent, port_hotzone_outer_extent

#### GraphNode / GraphElement / GraphFrame
- **S (3-5):** panel, panel_selected, titlebar (GraphNode); frame, frame_selected (GraphFrame)
- **C (1-3):** resizer_color (and frame title color)
- **I (2-3):** port, resizer
- **K (3-5):** port_h_offset, separation, title_h_offset, title_offset

#### TooltipPanel + TooltipLabel
- **TooltipPanel S (1):** panel
- **TooltipLabel C (3):** font_color, font_outline_color, font_shadow_color
- **TooltipLabel F (1) / FS (1):** font, font_size
- **TooltipLabel K (3):** outline_size, shadow_offset_x, shadow_offset_y

---

## (3) Semantic Token System

A 5-axis token system. Names use dot-notation (Godot theme entries don't enforce naming, but consistency in the .tres comments and authoring docs matters). Numbers are concrete starting values to refine in mockup phase.

### 3.1 Color Tokens

**A. Surfaces (background hierarchy — fixes prototype gap)**
| Token | Hex | Role |
|-------|-----|------|
| surface.base | #0F1116 | Window/scene background (deepest) |
| surface.secondary | #14171F | Secondary panels behind primary content |
| surface.panel | #1A1E28 | Default Panel/PanelContainer |
| surface.raised | #222735 | Buttons in normal state, popup panels |
| surface.elevated | #2C3242 | Hover states, elevated cards |
| surface.overlay | #353B4D | **NEW vs prototype** — modal backdrops, dropdowns over content (M3 `surface-container-highest`) |
| ~~surface.sunken~~ | ~~#0A0C11~~ | **REJECTED for v1** per SUMMARY.md Conflict 2 — inputs distinguished via focus/normal stylebox + corner radius instead. Reconsider for v2 if depth-via-color-only proves insufficient. |

**B. Text colors (matches prototype's typography panel)**
| Token | Hex | Role |
|-------|-----|------|
| text.strong | #FFFFFF | Primary headings, emphasized text |
| text.default | #E4E7EE | Body text, default font_color |
| text.muted | #A0A6B5 | Secondary text, captions |
| text.dim | #6B7184 | Disabled text, hints |
| text.placeholder | #5A5F70 | Input placeholders |
| text.inverse | #0F1116 | Text on bright accent backgrounds |
| text.link | #56B0FF | LinkButton font_color |

**C. Strokes / Borders**
| Token | Hex | Role |
|-------|-----|------|
| stroke.subtle | #2A2F3D | Default borders, dividers |
| stroke.default | #3A4053 | Standard borders |
| stroke.strong | #5A6178 | Hovered/emphasized borders |
| stroke.focus | (= role.primary) | Focus ring outer |
| stroke.focus.inset | #0F1116 (= surface.base) | Focus ring inner gap |

**D. Accent palette (matches prototype)**
| Token | Hex | Role |
|-------|-----|------|
| accent.cyan | #00D4FF | Primary action color (default brand) |
| accent.blue | #56A0FF | Information |
| accent.violet | #B780FF | Tertiary, decorative |
| accent.pink | #FF6BB1 | Decorative, friendly |
| accent.green | #34D399 | Success |
| accent.amber | #FBBF24 | Warning |
| accent.orange | #FB923C | Alert |
| accent.red | #F87171 | Danger |

**E. Semantic role aliases (NEW vs prototype — closes gap #2)**
These are aliases pointing at accents. v1 ships these defaults; users override individual colors without renaming everywhere.
| Token | Aliases | Role |
|-------|---------|------|
| role.primary | accent.cyan | Primary buttons, focus rings, active states |
| role.success | accent.green | Success messages, confirmation buttons |
| role.warning | accent.amber | Warnings, caution |
| role.danger | accent.red | Destructive actions |
| role.info | accent.blue | Informational |
| role.link | accent.cyan (link variant) | Links |

### 3.2 Typography Scale

**A. Font Stack**
| Token | Resource | Role |
|-------|----------|------|
| font.sans | Inter (Variable) | UI text (default) |
| font.sans.fallback | NotoSans (CJK + global) | Fallback |
| font.mono | JetBrainsMono (or Inter as fallback) | Code, TextEdit, RichTextLabel mono |

**B. Type scale (font_sizes — NEW vs prototype)**
| Token | px (1×) | Use |
|-------|---------|-----|
| type.display | 32 | Hero text in showcase header |
| type.h1 | 24 | Section headings |
| type.h2 | 20 | Subsection headings |
| type.h3 | 16 (bold) | Card headings |
| type.body | 14 | Default UI text |
| type.body.sm | 12 | Compact UI, captions |
| type.label | 11 | Tabs, button labels (uppercase optional) |
| type.code | 13 | Mono code text |

**C. Weights (Inter variable axis values)**
| Token | Weight |
|-------|--------|
| weight.regular | 400 |
| weight.medium | 500 |
| weight.semibold | 600 |
| weight.bold | 700 |

### 3.3 Spacing Scale (4px base)

| Token | Px | Use |
|-------|-----|-----|
| space.0 | 0 | Reset |
| space.1 | 2 | Tightest (between icon and text in compact buttons) |
| space.2 | 4 | Tight (default h_separation in tabs) |
| space.3 | 6 | Compact |
| space.4 | 8 | Default (most h_separation/v_separation) |
| space.5 | 12 | Comfortable (popup item padding) |
| space.6 | 16 | Roomy (panel inner padding) |
| space.7 | 24 | Section gaps |
| space.8 | 32 | Major gaps |

### 3.4 Corner Radius Scale

| Token | Px | Use |
|-------|-----|-----|
| radius.none | 0 | Separators, scroll backgrounds |
| radius.sm | 4 | Inputs, small buttons, checkboxes |
| radius.md | 6 | Default buttons, default panels |
| radius.lg | 8 | Cards, dialogs |
| radius.xl | 12 | Hero/feature panels |
| radius.full | 9999 | Pill buttons, slider grabbers |

### 3.5 Stroke Widths

| Token | Px | Use |
|-------|-----|-----|
| stroke.0 | 0 | No border |
| stroke.1 | 1 | Subtle borders (default) |
| stroke.2 | 1.5 | Focus ring outer |
| stroke.3 | 2 | Emphasized borders, primary button hover |

### 3.6 Elevation (depth-via-color, no shadows — fixes AF-13)

| Level | Surface Token | Use |
|-------|---------------|-----|
| 0 | surface.base | Page background |
| 1 | surface.secondary | Background panels |
| 2 | surface.panel | Default panels |
| 3 | surface.raised | Buttons, raised cards |
| 4 | surface.elevated | Hover states, modals |
| 5 | surface.overlay | Popups, tooltips, dropdowns over content |

---

## (4) Type Variations

Godot type variations (set via `theme_type_variation` on a Control, registered via `Theme.set_type_variation("VariationName", "BaseType")`). NeoCade ships these in v1:

### 4.1 Buttons (5 variations)

| Variation | Base | Visual | Use |
|-----------|------|--------|-----|
| **PrimaryButton** | Button | Filled with role.primary, white text, solid hover (brighter cyan) | Main CTA — "Apply", "Save" |
| **SecondaryButton** | Button | Surface.raised fill, default text, role.primary border on focus | Secondary actions — "Cancel" |
| **DangerButton** | Button | Filled with role.danger, white text | Destructive — "Delete", "Reset" |
| **GhostButton** | Button | Transparent fill, role.primary text, role.primary border on hover | Tertiary — toolbar-style buttons, no emphasis |
| **IconButton** | Button | Square (1:1), transparent, icon-only | Toolbar buttons; auto-square via stylebox padding |
| **FlatButton** | Button | No border, no fill until hover | Inline buttons within text or compact UIs |

**Justification:** Material 3 has Filled/Tonal/Outlined/Text/Elevated buttons (5 variations). PrimaryButton + SecondaryButton + GhostButton + FlatButton + IconButton + DangerButton covers the same role coverage, with names that are role-semantic rather than fill-semantic.

### 4.2 Labels (5 variations)

| Variation | Base | Visual | Use |
|-----------|------|--------|-----|
| **HeaderLarge** (H1) | Label | font_size=type.h1 (24), weight=bold, color=text.strong | Section headings |
| **HeaderMedium** (H2) | Label | font_size=type.h2 (20), weight=semibold, color=text.strong | Subsection headings |
| **HeaderSmall** (H3) | Label | font_size=type.h3 (16), weight=semibold, color=text.strong | Card titles |
| **Caption** | Label | font_size=type.body.sm (12), color=text.muted | Small helper text |
| **CodeLabel** | Label | font=font.mono, font_size=type.code (13) | Inline code |

**Justification:** Eliminates per-instance font_size overrides; provides editorial typography.

### 4.3 RichTextLabel (1 variation)

| Variation | Base | Visual | Use |
|-----------|------|--------|-----|
| **InfoText** | RichTextLabel | Compact line spacing, mono fallback for code spans | Inline rich help text |

### 4.4 Panels (2 variations)

| Variation | Base | Visual | Use |
|-----------|------|--------|-----|
| **CardPanel** | PanelContainer | radius.lg, surface.panel + 1px border | Content cards |
| **HeroPanel** | PanelContainer | radius.xl, surface.elevated, accent border-top | Featured/landing panels |

### 4.5 Total: 13 type variations

This is conservative. PROJECT.md asks for "type variations where appropriate" — 13 is "useful coverage of common UI patterns" without bloating the .tres.

---

## (5) Showcase Scene Scope

`res://main.tscn` mirrors godot-demo-projects/gui/control_gallery layout but extended for full coverage. Layout: top-bar with theme toggle, left sidebar with section nav, central scrolling area with sections.

### 5.1 Top Bar (always visible)

- **NeoCade logo / wordmark** (Label with HeaderLarge variation)
- **Theme toggle button** (large CheckButton, labeled "NeoCade Theme" / "Godot Default", visually larger than peers per PROJECT.md)
- **Resolution test selector** (OptionButton: "1080p", "1440p", "4K") — switches viewport scale to verify HD crispness

### 5.2 Section: Buttons & Actions

- 6 button variations rendered in all 5 states (normal, hover, pressed, disabled, focus): Button (default), PrimaryButton, SecondaryButton, DangerButton, GhostButton, IconButton, FlatButton
- LinkButton example
- ColorPickerButton (open/closed states)
- MenuButton with PopupMenu (showing checkable items, radio items, submenus, separators, accelerators)
- OptionButton with several options
- CheckBox (checked/unchecked/disabled, with label)
- CheckButton (toggle pill)

### 5.3 Section: Text Inputs

- LineEdit (empty placeholder, filled, read-only, focused, disabled)
- LineEdit with clear button
- TextEdit (multi-line) with selection visible
- CodeEdit with sample code (showing line numbers, breakpoint, bookmark, fold gutter)
- SpinBox (default + with min/max)
- RichTextLabel demo (BBCode showing bold, italic, color, table, code, link, image inline)

### 5.4 Section: Numbers & Range

- HSlider (with ticks, with grabber states)
- VSlider (sized vertical)
- ProgressBar (0%, 50%, 100%, with percentage label, indeterminate)
- TextureProgressBar (note: content-driven, basic example only)
- HScrollBar / VScrollBar in a scrollable container
- ColorPicker (full picker mode in a panel)

### 5.5 Section: Selection & Lists

- ItemList (~10 items with mixed icons, showing hovered + selected + cursor)
- Tree (3-level with checkboxes, custom buttons, columns)
- TabContainer with 3 tabs, one disabled, content visible
- TabBar standalone with close buttons
- FoldableContainer (open + collapsed examples)

### 5.6 Section: Containers & Layout

- Panel + PanelContainer comparison
- Three CardPanel variations side-by-side (showcasing radius.lg + surface.panel)
- HeroPanel example
- ScrollContainer with overflowing content
- HSplitContainer + VSplitContainer with content panes
- MarginContainer demo (visualized with colored child)
- HSeparator and VSeparator

### 5.7 Section: Dialogs & Popups

- AcceptDialog example button (opens a modal showing buttons + panel)
- ConfirmationDialog example button
- FileDialog example button
- PopupMenu standalone (right-click on a panel to show)
- TooltipPanel example (hover any tooltip-equipped Label)

### 5.8 Section: Advanced

- GraphEdit with 3-4 GraphNodes connected (input ports, output ports, slots)
- GraphFrame example
- MenuBar at top of a sub-panel (File / Edit / View, with PopupMenu submenus)

### 5.9 Section: Theme Token Gallery (DF-8 — NeoCade-specific)

- **Color swatches**: 5×8 grid showing every surface, text, accent, and role token labeled with hex
- **Typography ladder**: HeaderLarge → HeaderMedium → HeaderSmall → Body → Caption all stacked
- **Radius scale**: 5 boxes showing radius.none → radius.full
- **Spacing scale**: visual grid of space.1 through space.8
- **Stroke samples**: 4 boxes with stroke.0 through stroke.3
- **Elevation ladder**: 6 stacked panels showing elevation 0-5 with labels

### 5.10 Coverage Verification (developer-facing)

A bottom strip lists "Controls covered: 35/35 ✓" — auto-counted via a script enumerating themed types, used for CI/QA.

---

## (6) TABLE STAKES vs DIFFERENTIATORS vs ANTI-FEATURES Summary

### TABLE STAKES (Must Have — theme broken without these)

| Class of feature | Items |
|------------------|-------|
| **Control coverage** | All 35 user-facing Control classes themed, all states populated (TS-1 through TS-11) |
| **Accessibility** | Visible focus on every focusable Control, WCAG AA contrast (TS-12) |
| **Fonts bundled** | Inter + Noto Sans, OFL, all weights (TS-13) |
| **HD rendering** | StyleBoxFlat only, no raster, sharp at 4K (TS-14) |
| **Showcase scene** | Renders every Control in `main.tscn` (TS-15) |
| **Theme toggle** | NeoCade ↔ Godot default, prominent (TS-16) |

### DIFFERENTIATORS (NeoCade Polish)

| Class of feature | Items |
|------------------|-------|
| **Type variations** | 13 variations (DF-1, DF-2): 6 button, 5 label, 1 RichTextLabel, 2 panel |
| **Focus ring** | Double-ring distinctive but accessible (DF-3) |
| **Token system** | 8-hue accent palette with semantic role aliases (DF-4) |
| **Geometric rhythm** | 4-rung corner radius scale, applied consistently (DF-5) |
| **Icon authoring** | Crisp SVG-sourced icons at 16/24/32px (DF-6) |
| **BBCode demo** | Showcase RichTextLabel demonstrates rich formatting (DF-7) |
| **Token gallery** | Self-documenting in showcase (DF-8) |
| **Disabled state** | Genuinely de-emphasized (saturation drop, not just dim) (DF-9) |
| **Surface elevation** | Color-based depth, not shadows (DF-10) |

### ANTI-FEATURES (Explicitly Out of v1)

| Anti-feature | Reason |
|--------------|--------|
| Glow / outer-glow on focus | StyleBoxFlat can't render; conflicts with HD constraint (AF-1) |
| Scanlines / CRT overlays | PROJECT.md no-synthwave decision (AF-2) |
| Animations beyond Godot built-in | Not theme-able (AF-3) |
| Light mode | Deferred to v2 (AF-4) |
| ~~Mobile-specific theme file~~ | ~~Deferred to v2 (AF-5)~~ — **STRICKEN 2026-05-04**; mobile variant is now v1 must-have. See CROSS-PLATFORM.md. |
| Editor-only types (FlatButton, MainScreenButton, EditorInspector*, etc. as per godot-minimal-theme) | Out of "every Control class" scope (AF-6) |
| CodeEdit syntax highlighting colors | Not a theme entry; app-level (AF-7) |
| Texture-driven Controls (TextureButton, TextureRect, NinePatchRect, VideoStreamPlayer) | No theme entries — content driven (AF-8) |
| Per-platform native fonts | Defeats bundled-fonts requirement (AF-9) |
| Sound effects | PROJECT.md explicit no (AF-10) |
| Theming layout-only containers (HBox, VBox, Center, AspectRatio) | Wasted effort — they have no chrome (AF-11) |
| StyleBoxTexture anywhere | HD scaling problem (AF-12) |
| Drop shadows on panels | Godot StyleBoxFlat shadow looks bad (AF-13) |
| Color-named button variations (BlueButton, RedButton) | Bloats theme; use role-based names (AF-14) |

---

## Feature Dependencies (for Roadmap Phase Ordering)

```
[Token System]
    └──required by──> [All Stylebox Authoring]
                       └──required by──> [Per-Control Theme Entries]
                                          └──required by──> [Type Variations]
                                                              └──required by──> [Showcase Scene]
                                                                                  └──required by──> [Visual QA / Mockup approval]

[Bundled Fonts]
    └──required by──> [Per-Control Theme Entries]  (font + font_size entries)

[Icon Set Authored]
    └──required by──> [Buttons, Tree, TabBar, ColorPicker, FileDialog, PopupMenu, ScrollBar]

[Mockup Approval Gate (PROJECT.md non-negotiable)]
    └──BLOCKS──> [All Per-Control Theme Entries]
```

### Dependency Notes

- **Token system blocks everything visual:** No stylebox can be authored before tokens are locked. First implementation sprint = tokens-only.
- **Mockup gate blocks all .tres edits:** PROJECT.md requires approval before authoring; design-first phase produces mockups for at least Buttons, Inputs, Panels, Tree (representative coverage), then user approves.
- **Type variations follow base styling:** Cannot author PrimaryButton until Button is solid.
- **Showcase scene is a forcing function:** Build it AS controls are themed, not after — every theme entry should be visible in showcase the moment it's set.

---

## MVP Definition

### Launch With (v1) — exhaustive

> **Note 2026-05-04:** The 5-phase plan below was authored before CROSS-PLATFORM landed. The current authoritative phase decomposition is the **11-phase plan in `SUMMARY.md` "Implications for Roadmap"**. The 5 categories below remain valid as DELIVERABLES groupings (what gets shipped); SUMMARY.md provides the actual phase sequence (research/design spikes → foundation → core/lists/dialogs → mobile authoring → showcase → QA + cross-platform validation → distribution). Roadmapper should use SUMMARY.md for phasing and FEATURES.md (this file) for per-deliverable specifics.

**Foundation deliverables**
- [ ] All 6.1 token resources defined (colors, types, spacings, radii, strokes, elevations)
- [ ] Inter Variable + Outfit Variable + Noto Sans Variable bundled, font resources created (per Conflict 1 revision; Inter Italic deferred to v1.x)
- [ ] `addons/neocade_theme/_dev/generate_themes.gd` `@tool` script with TokenSet (desktop) + TokenSet.mobile blocks
- [ ] Generated `neocade_theme.tres` + `neocade_mobile_theme.tres` scaffolds with empty entries for every type
- [ ] Mockup approval gate passed for representative Controls (desktop + mobile mockups both required, per ARCHITECTURE Section 6 Step 5b)

**Core Controls deliverables (desktop authoring; mobile overrides accrue alongside)**
- [ ] Button + 6 button variations themed (5 states each)
- [ ] LineEdit + TextEdit + CodeEdit + SpinBox themed
- [ ] Label + RichTextLabel + 5 label variations themed
- [ ] Panel + PanelContainer + 2 panel variations themed
- [ ] CheckBox + CheckButton + OptionButton + MenuButton + ColorPickerButton + LinkButton themed
- [ ] Custom icons authored: check, radio, toggle, arrow_down, clear, close

**Lists & Layout deliverables (desktop authoring)**
- [ ] Tree themed (16 styleboxes, 12 icons)
- [ ] ItemList themed
- [ ] TabBar + TabContainer themed
- [ ] FoldableContainer themed
- [ ] All container constants set (separations, margins)
- [ ] Splits + Separators + ScrollContainer themed
- [ ] HSlider + VSlider + ProgressBar + HScrollBar + VScrollBar themed

**Dialogs & Advanced deliverables (desktop authoring)**
- [ ] Window + AcceptDialog + ConfirmationDialog + FileDialog themed
- [ ] PopupMenu + PopupPanel + TooltipPanel + TooltipLabel themed
- [ ] MenuBar themed
- [ ] ColorPicker themed
- [ ] GraphEdit + GraphNode + GraphFrame themed (basic)

**Mobile Variant Authoring deliverables (NEW; CROSS-PLATFORM Section 3)**
- [ ] TokenSet.mobile overrides filled (button height 48px, body 16px, spacing +50% on space.4+)
- [ ] Generator outputs `neocade_mobile_theme.tres`
- [ ] Tap-target audit script confirms every interactive Control ≥48px in mobile theme
- [ ] `MOBILE-DESIGN-SPEC.md` documents deltas vs desktop
- [ ] Showcase scene supports three-way theme toggle (NeoCade desktop ↔ NeoCade mobile ↔ Godot default)

**Showcase deliverables**
- [ ] `main.tscn` with all 9 sections rendered
- [ ] Three-way theme toggle button functional (desktop ↔ mobile ↔ default)
- [ ] Token gallery section
- [ ] Coverage counter shows "35/35"

**QA + Cross-Platform Export Validation deliverables (EXPANDED; CROSS-PLATFORM Section 6.5)**
- [ ] Visual QA via Godot MCP screenshots at 1080p, 1440p, 4K (Forward+ + GL Compat)
- [ ] WCAG 2.1 AA contrast verified for all text + interactive states
- [ ] Tab-walk every Control + screenshot focused state
- [ ] CVD simulation pass (deuteranopia/protanopia/tritanopia)
- [ ] Multi-script label test (Latin, Cyrillic, Arabic, Hebrew, Devanagari)
- [ ] Per-target export builds + screenshot decks: Windows, macOS, Linux, iOS, Android, Web/Browser
- [ ] CI workflow for desktop + Web targets
- [ ] Manual Android + iOS validation on real devices (or noted deferred per UD-5)

**Distribution deliverables**
- [ ] Asset Library submission package (icon, README, license attributions, install paths)
- [ ] `OFL.txt` covering all bundled fonts (Inter + Outfit + Noto Sans + JetBrains Mono)
- [ ] `LICENSE.md` + initial `CHANGELOG.md`
- [ ] Fresh-install dry-run on a clean Godot project
- [ ] Asset Library current policy verified at submission time (not training data)

### Add After Validation (v1.x)

- [ ] Inter Italic Variable bundled (was deferred from v1 in Conflict 1 revision; replaces synthetic italic transform)
- [ ] Light theme variant (PROJECT.md note: deferred to v1.x or v2)
- [ ] Editor-side application (using as Godot editor theme)
- [ ] Editor-only theme types (FlatButton, MainScreenButton, etc.) for full editor parity
- [ ] Deeper screen-reader QA (VoiceOver/TalkBack/AccessKit) — see UD-6
- [ ] CJK Noto Sans bundling (or formalized opt-in) — see UD-2

### Future Consideration (v2+)

- [ ] ~~Mobile-tuned variant (`neocade_mobile_theme.tres`)~~ **MOVED TO v1 — see Mobile Variant Authoring deliverables above**
- [ ] Alternate palette variants (e.g., `neocade_neon_magenta.tres`, `neocade_amber.tres`)
- [ ] Light mode for both desktop AND mobile variants
- [ ] Alternate palette variants (magenta-led, amber-led, etc.)
- [ ] CodeEdit syntax color presets (separate resource, not theme entries)
- [ ] Animation/transition recommendations as accompanying GDScript snippets

---

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Button + 6 variations | HIGH | MEDIUM | P1 |
| Tree theming | HIGH | HIGH | P1 |
| Token system | HIGH | LOW (just declarations) | P1 |
| Showcase scene | HIGH | HIGH | P1 |
| Theme toggle | MEDIUM | LOW | P1 |
| Focus ring (double-ring) | HIGH (accessibility) | MEDIUM | P1 |
| LineEdit/TextEdit/CodeEdit | HIGH | MEDIUM | P1 |
| ColorPicker | MEDIUM | HIGH | P1 |
| GraphEdit | LOW (specialized) | MEDIUM | P2 |
| FoldableContainer | MEDIUM | LOW | P1 |
| BBCode demo in showcase | MEDIUM | LOW | P2 |
| Token Gallery in showcase | MEDIUM | MEDIUM | P2 |
| Coverage counter (35/35) | LOW | LOW | P2 |
| Editor-only types | LOW (v1.x) | MEDIUM | P3 |
| Light mode | HIGH (eventually) | HIGH | P3 (v2) |

---

## Token System Critique: Prototype Strengths and Adjustments

### Prototype Strengths (preserve)

1. **Surface ladder concept** — Base/Secondary/Panel/Raised/Elevated is the right shape. Naming maps cleanly to Material 3 elevation language without copying. KEEP.
2. **8-hue accent palette** — Cyan/Blue/Pink/Violet/Green/Amber/Red/Orange is comprehensive without being chaotic; covers role coverage (primary/info/success/warning/danger/decorative). KEEP.
3. **Typography color ladder** — Stroke/Strong/Text/Muted/Dim is a strong text-color scale; closer to Tailwind's text-50/100/200 than Material 3's complex token names. KEEP, rename "Stroke" to "text.heading" or fold it into text.strong (it's the brightest text).

### Prototype Gaps (adjust)

1. **No surface.overlay** — dropdowns/popups over content need a layer above elevated (overlay). ADD `surface.overlay`. ~~`surface.sunken` for inputs~~ **REJECTED for v1** per SUMMARY.md Conflict 2 — inputs distinguished via focus/normal stylebox + corner radius. Reconsider for v2.
2. **No semantic role aliases** — palette is named only by hue. Consuming projects that want to swap palettes (v2) must rename every reference. ADD `role.primary/success/warning/danger/info/link` as named pointers.
3. **Conflated "typography" axis** — prototype's Typography panel only shows COLOR variants, not SIZES. There is no h1/h2/h3/body scale visible. ADD `type.display/h1/h2/h3/body/body.sm/label/code` size scale separately from text colors.
4. **"Stroke" token is ambiguous** — the prototype panel labels its brightest text color "Stroke" but in design-system parlance "stroke" means border thickness. RENAME to `text.strong` or `text.heading`; reserve "stroke" for border-related tokens (already done in our token system).
5. **No corner-radius scale visible** — prototype Controls show consistent rounding but no token authority for it. ADD `radius.sm/md/lg/xl/full`.
6. **No spacing scale visible** — prototype shows good spacing rhythm but has no documented token. ADD `space.0` through `space.8` (4px base scale).

---

## Sources

- **Godot 4.6 official docs** (HIGH confidence — authoritative):
  - [Control class hierarchy](https://docs.godotengine.org/en/stable/classes/class_control.html)
  - [BaseButton inheritance](https://docs.godotengine.org/en/stable/classes/class_basebutton.html)
  - [Container subclasses](https://docs.godotengine.org/en/stable/classes/class_container.html)
  - [Range subclasses](https://docs.godotengine.org/en/stable/classes/class_range.html)
  - [Window theme entries](https://docs.godotengine.org/en/stable/classes/class_window.html)
  - [Button theme entries](https://docs.godotengine.org/en/stable/classes/class_button.html)
  - [LineEdit theme entries](https://docs.godotengine.org/en/stable/classes/class_lineedit.html)
  - [Tree theme entries](https://docs.godotengine.org/en/stable/classes/class_tree.html)
  - [ItemList theme entries](https://docs.godotengine.org/en/stable/classes/class_itemlist.html)
  - [TabBar theme entries](https://docs.godotengine.org/en/stable/classes/class_tabbar.html)
  - [TabContainer theme entries](https://docs.godotengine.org/en/stable/classes/class_tabcontainer.html)
  - [PopupMenu theme entries](https://docs.godotengine.org/en/stable/classes/class_popupmenu.html)
  - [ColorPicker theme entries](https://docs.godotengine.org/en/stable/classes/class_colorpicker.html)
  - [GraphEdit theme entries](https://docs.godotengine.org/en/stable/classes/class_graphedit.html)
  - [FileDialog theme entries](https://docs.godotengine.org/en/stable/classes/class_filedialog.html)
  - [MenuBar theme entries](https://docs.godotengine.org/en/stable/classes/class_menubar.html)
  - [Theme type variations tutorial](https://docs.godotengine.org/en/stable/tutorials/ui/gui_theme_type_variations.html)
  - [ProgressBar / Slider / ScrollBar / AcceptDialog / Popup / CodeEdit / Label / Panel](class pages)

- **godot-minimal-theme** by passivestar (HIGH confidence — direct source inspection):
  - [Repository](https://github.com/passivestar/godot-minimal-theme) — confirmed coverage list of 50+ types including editor-only ones; NeoCade scopes user-facing only

- **godot-demo-projects control_gallery** (HIGH confidence — scene file inspected):
  - [Source](https://github.com/godotengine/godot-demo-projects/tree/master/gui/control_gallery) — confirmed sections "Basic controls / Numbers / Lists" and Control list including FoldableContainer

- **PROJECT.md** (authoritative project source):
  - `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme\.planning\PROJECT.md` — name discipline (NeoCade not VirtuCade), aesthetic boundaries, anti-features

- **NeoCade-Theme-Prototype.png** (MEDIUM confidence — design reference, must be challenged):
  - Token panel inspected; gaps identified above (sunken/overlay surfaces, semantic role aliases, type-size scale)

- **Material Design 3** (MEDIUM confidence — vocabulary inspiration only):
  - [m3.material.io/components](https://m3.material.io/components) — button variation taxonomy (Filled/Tonal/Outlined/Text/Elevated) informed our 6 button variations

---

*Feature research for: Godot 4.6 dark UI Theme addon (NeoCade)*
*Researched: 2026-05-04*
