# Coverage Audit

**Date:** 2026-05-07
**Scope:** Phase 10 autonomous static coverage audit.

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

The visible coverage strip reports `37/37 Controls themed ✓`; additive theme
types and layout/chrome samples are listed alongside the canonical scorecard
so QA can inspect them without changing the scorecard promise.

## Theme Resource Coverage

The shared `NeoCadeTheme._regenerate_theme()` BINDING_TABLE remains the source
for all generated entries. All five direction resources load through the same
class and therefore share generated coverage:

- `pulse_neocade_theme.tres`
- `slate_neocade_theme.tres`
- `bubble_neocade_theme.tres`
- `daybreak_neocade_theme.tres`
- `burst_neocade_theme.tres`

## Deferred

The exhaustive COV-10 slot-by-slot diff against the Phase 1
`godot-minimal-theme` enumeration needs a scriptable Theme inspector/export
surface. It is tracked as deferred manual/tooling UAT, not as missing Phase 9
implementation.
