# Phase 3.4 Dark Palette WCAG Audit

**Updated:** 2026-05-06  
**Reason:** User rejected the light Bubble/Daybreak base treatment and requested all concepts use dark backgrounds with properly related accessible accent colors.

## Source Basis

Official WCAG references used for this pass:

- WCAG 2.2 SC 1.4.3 Contrast (Minimum): normal text requires at least 4.5:1 contrast; large text requires at least 3:1.
- WCAG 2.2 SC 1.4.6 Contrast (Enhanced): AAA normal text requires at least 7:1; large text requires at least 4.5:1.
- WCAG 2.2 SC 1.4.11 Non-text Contrast: meaningful UI component/state visual information requires at least 3:1 against adjacent colors.
- WCAG contrast ratio formula: `(L1 + 0.05) / (L2 + 0.05)`, where `L1` is the lighter relative luminance and `L2` is the darker relative luminance.

Source URLs:

- https://www.w3.org/TR/wcag/#contrast-minimum
- https://www.w3.org/TR/wcag/#contrast-enhanced
- https://www.w3.org/TR/wcag/#non-text-contrast
- https://www.w3.org/TR/wcag/#dfn-contrast-ratio

## Acceptance Targets

This mockup pass uses stricter-than-minimum targets for the main palette pairs:

- Accent on dark base: target >= 7:1 where practical.
- Primary text on dark base: target >= 7:1.
- Text/icon on accent button using a dark on-accent color: target >= 7:1 where practical.
- UI outlines and focus indicators: must remain capable of >= 3:1 against adjacent colors in later tokenization.

## Revised Dark Direction Palettes

| Direction | Dark base | Accent | Accent vs base | On-base text | Text vs base | On-accent text | Text vs accent | Status |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| Pulse | `#151A2E` | `#8BFF6A` | 13.62:1 | `#F7F8FB` | 16.22:1 | `#0B1020` | 14.97:1 | PASS AAA |
| Slate | `#111820` | `#8BD3FF` | 10.94:1 | `#F7F8FB` | 16.82:1 | `#071019` | 11.72:1 | PASS AAA |
| Bubble | `#241326` | `#FFB3E6` | 10.74:1 | `#FFF7FC` | 16.69:1 | `#160916` | 11.84:1 | PASS AAA |
| Daybreak | `#0B2420` | `#76F2D1` | 11.96:1 | `#F4FFFB` | 15.96:1 | `#061713` | 13.51:1 | PASS AAA |
| Burst | `#20112E` | `#FFD166` | 12.33:1 | `#FDF8FF` | 16.97:1 | `#12081B` | 13.53:1 | PASS AAA |

## Direction Revisions

### Bubble

Prior text-level direction used a light `#FFF4FA` base with deep berry accent. The revised mockup palette keeps Bubble's friendly berry/pink identity but moves the base to `#241326`, a dark berry-aubergine. The accent becomes `#FFB3E6`, which reads as playful light pink on dark surfaces and keeps the accent usable for action/focus text or filled buttons.

### Daybreak

Prior text-level direction used a light mint `#EAF7F1` base with teal accent. The revised mockup palette keeps Daybreak's fresh mint/teal wayfinding but moves the base to `#0B2420`, a dark teal-green. The accent becomes `#76F2D1`, which preserves the daylight/mint association while meeting dark-theme contrast needs.

## Computation Method

Ratios were computed locally with the WCAG relative luminance formula:

```text
linear channel = c/12.92 if c <= 0.04045, otherwise ((c + 0.055) / 1.055) ^ 2.4
relative luminance = 0.2126 R + 0.7152 G + 0.0722 B
contrast ratio = (lighter + 0.05) / (darker + 0.05)
```

These are mockup-level pairings. Phase 4 and later production token work must still verify every final text, icon, outline, disabled, hover, focus, pressed, and selected role against its actual adjacent surface.
