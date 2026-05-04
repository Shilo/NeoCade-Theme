---
phase: 03-visual-direction-mockup-approval-gate
artifact: mood-board-index
status: schema-created
---

# NeoCade Phase 3 Mood-Board

## Purpose

This mood-board is the Phase 3 visual evidence base for NeoCade's art-direction mockups. It collects real arcade, entertainment-venue, cabinet, prize-counter, classic/barcade, and minority future/sci-fi references before any concept direction is generated. Every entry includes an anti-cyberpunk constraint so the collection stays anchored in vibrant arcade hall by day.

The collection policy is intentionally broad: unusual, spaceship, neo-arcade, or risky images are not rejected during collection. They are tagged honestly and constrained to influence NeoCade through extracted design moves only, not through importing a whole cyberpunk, noir, dystopian, or synthwave mood.

## Reference Schema

`references.json` is a JSON object with one top-level key:

```json
{ "references": [] }
```

Every reference entry must include:

| Field | Meaning |
| --- | --- |
| `id` | Stable reference identifier, e.g. `MB-001`. |
| `title` | Short human-readable name. |
| `source_url` | Page URL where the reference is documented. |
| `image_url_or_local_path` | Remote image URL or local file path when reuse rights are explicit. |
| `source_family` | Source bucket such as modern venue, prize/ticket, classic/barcade, cabinet/signage, or future/sci-fi. |
| `license_or_usage` | Usage status and attribution. |
| `tags` | Approved tags only: `theme-safe`, `game-world`, `palette`, `surface`, `shape`, `risky`. |
| `extract` | One-sentence note naming the palette, surface, lighting, control shape, signage rhythm, density, affordance, or mood to extract. |
| `anti_cyberpunk_note` | Constraint that keeps the reference aligned with vibrant arcade hall by day rather than cyberpunk/noir. |
| `candidate_direction_influence` | How this reference can influence one or more Phase 3 candidate directions. |

## License Rule

Images with unclear licensing or all-rights-reserved promotional status are URL-only references. They must not be committed locally, embedded in distributable assets, or copied into generated deliverables.

Local reference image files are allowed only when the license is explicit CC/PD or equivalent and attribution is captured in the entry.

## Approved Tags

| Tag | Use |
| --- | --- |
| `theme-safe` | Directly suitable for NeoCade v1 visual language. |
| `game-world` | Useful for VirtuCade world imagination, not necessarily direct theme language. |
| `palette` | Color or light-rhythm extraction. |
| `surface` | Material, border, finish, depth, or panel extraction. |
| `shape` | Control, cabinet, signage, or layout form extraction. |
| `risky` | Can drift toward cyberpunk/noir/dystopia/sci-fi dominance unless constrained. |

## Reference Inventory

Pending population.
