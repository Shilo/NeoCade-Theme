# Coverage Audit

**Date:** 2026-05-07
**Updated:** 2026-05-13
**Scope:** Phase 10 autonomous static coverage audit, updated for the current canonical-resource implementation.

## Runtime Showcase Coverage

`showcase/showcase.tscn` serializes visible or callable samples for:

- Button, CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton, LinkButton
- Label, RichTextLabel, LineEdit, TextEdit, CodeEdit
- SpinBox, HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar
- ItemList, Tree, TabBar, TabContainer, FoldableContainer
- Panel, PanelContainer, ScrollContainer, SplitContainer, MarginContainer,
  HBoxContainer, VBoxContainer, FlowContainer, GridContainer, CenterContainer
- PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog,
  TooltipPanel, TooltipLabel, Window
- MenuBar, ColorPicker, GraphEdit, GraphNode, GraphFrame

The visible coverage strip reports `37/37 Controls themed`; additive theme
types, layout/chrome samples, and the Phase 13 Role Variations tab are listed
alongside the canonical scorecard so QA can inspect them without changing the
scorecard promise.

## Theme Resource Coverage

The shared `NeoCadeTheme._regenerate_theme()` BINDING_TABLE remains the source
for all generated entries. The current architecture uses one canonical resource:

- `addons/neocade_theme/neocade_theme.tres`

The five built-in styles (`PULSE`, `SLATE`, `BUBBLE`, `DAYBREAK`, `BURST`) are
selected through the `style` export on that one resource. As of the 2026-05-13
docs sync, the live generated surface is `BINDING_TABLE.size() == 150` and
`TYPE_VARIATIONS.size() == 62`.

## Deferred

The exhaustive COV-10 slot-by-slot diff against the Phase 1
`godot-minimal-theme` enumeration needs a scriptable Theme inspector/export
surface. It is tracked as deferred manual/tooling UAT, not as missing Phase 9
implementation.
