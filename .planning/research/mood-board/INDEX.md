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

## Distribution Summary

| Source family | Count | Role |
| --- | ---: | --- |
| Modern arcade / entertainment venue | 11 | Dominant evidence base for v1: real, social, commercial arcade energy. |
| Prize / ticket / counter / crane | 5 | Strongest evidence for a unique bright direction and reward-state language. |
| Classic / barcade / pinball / cabinet row | 5 | Nostalgia and physical cabinet grammar, constrained to HD theme language. |
| Future / neo / sci-fi / immersive venue | 4 | Curated minority for optional future-facing and spaceship-adjacent inspiration. |
| **Total** | **25** | Within the required 20-30 reference range. |

## Reference Inventory

| ID | Title | Family | Tags | Extraction |
| --- | --- | --- | --- | --- |
| MB-001 | Round1 Jersey Gardens - dense cabinet hall | Modern venue | `theme-safe`, `palette`, `surface`, `shape` | Warm venue light, saturated cabinet faces, and row rhythm. |
| MB-002 | Round1 Las Vegas - broad public entertainment mix | Modern venue | `theme-safe`, `palette`, `surface` | Multi-activity zoning by color and surface transitions. |
| MB-003 | Round1 Mission Viejo - rhythm and crane variety | Modern venue | `theme-safe`, `palette`, `shape` | Upright cabinets, rhythm machines, and crane silhouettes. |
| MB-004 | Round1 activities - bowling, darts, karaoke, arcade mix | Modern venue | `theme-safe`, `surface`, `shape` | Distinct attraction controls inside one shared venue shell. |
| MB-005 | Dave & Buster's Play - midway loop | Modern venue | `theme-safe`, `palette`, `shape` | Play-card, tickets, and win loop as reward-state reference. |
| MB-006 | Dave & Buster's company events - arcade plus seating | Modern venue | `theme-safe`, `surface` | High-energy arcade edges with calmer seating surfaces. |
| MB-007 | Dave & Buster's games - branded cabinet variety | Modern venue | `theme-safe`, `shape`, `surface` | Modular cabinet bezels, control decks, and display hierarchy. |
| MB-008 | Main Event arcade - family entertainment game floor | Modern venue | `theme-safe`, `palette`, `shape` | Cabinet color, prize messaging, and accessible walkways. |
| MB-009 | Main Event bowling and arcade adjacency | Modern venue | `theme-safe`, `surface` | Smooth material contrast around brighter arcade accents. |
| MB-010 | Two Bit Circus - micro-amusement park | Neo-arcade venue | `theme-safe`, `game-world`, `palette`, `shape` | Playful invention mood and social spectacle without grit. |
| MB-011 | Andretti Indoor Karting - arcade attraction mix | Modern venue | `theme-safe`, `surface`, `shape` | Durable glossy surfaces and fast-action signage. |
| MB-012 | Round1 crane game category | Prize/crane | `theme-safe`, `palette`, `shape` | Candy-bright prize walls, transparent bays, and rounded controls. |
| MB-013 | Dave & Buster's WIN loop | Prize/ticket | `theme-safe`, `palette` | Ticket accumulation and success-state contrast. |
| MB-014 | Main Event arcade prizes and Fun Card loop | Prize/card | `theme-safe`, `palette`, `shape` | Card-station clarity and compact touch confirmations. |
| MB-015 | Chuck E. Cheese games and e-ticket flow | Prize/family | `theme-safe`, `palette`, `shape` | Large, unambiguous reward and touch affordances. |
| MB-016 | Wikimedia Commons - claw crane category | Prize/crane | `theme-safe`, `shape`, `surface` | Transparent bays, low control panels, and joystick/button pairing. |
| MB-017 | Neon Retro Arcade - classic cabinet room | Classic arcade | `theme-safe`, `palette`, `shape` | Nostalgic cabinet silhouettes and marquee rhythm. |
| MB-018 | Barcade - cabinets in hospitality setting | Barcade | `theme-safe`, `surface` | Wood, metal, cabinet glow, and readable signage. |
| MB-019 | Pinball Hall of Fame - physical pinball collection | Pinball | `theme-safe`, `palette`, `shape`, `surface` | Chrome rails, score inserts, bumpers, and tactile density. |
| MB-020 | Wikimedia Commons - arcade cabinets category | Cabinet row | `theme-safe`, `shape`, `surface` | Upright bezel, marquee strip, deck, side-panel, and row spacing. |
| MB-021 | Internet Arcade - virtual classic arcade library | Virtual classic | `game-world`, `shape`, `risky` | Attract-mode hierarchy and cabinet-screen framing as abstraction only. |
| MB-022 | AREA15 - immersive entertainment district | Future venue | `game-world`, `palette`, `surface`, `risky` | Playful spectacle, portals, and saturated wayfinding. |
| MB-023 | Electric Playhouse - interactive projected play | Future venue | `game-world`, `palette`, `shape` | Broad interactive light fields and rounded room-scale affordances. |
| MB-024 | Level99 - challenge-room social gaming | Future venue | `game-world`, `surface`, `shape` | Modular room identity and challenge-state signage. |
| MB-025 | Sandbox VR - immersive headset venue | Future venue | `game-world`, `surface`, `risky` | Clean onboarding stations and luminous team-session states. |

## Evidence Clusters For New Directions

**Prize Pop Plaza** is the clearest fourth direction candidate. MB-012 through MB-016 provide a distinct vocabulary of transparent prize cases, candy-bright reward color, rounded crane controls, ticket/card states, and large accessible touch affordances. This direction should be energetic and playful without becoming childish; the extract is reward clarity, not mascot branding.

**Orbital Playdeck** is the clearest fifth direction candidate. MB-010 and MB-022 through MB-025 provide a constrained futuristic lane: visitable immersive venues, clean equipment surfaces, modular challenge rooms, projected play, and playful portal color. This direction can explore spaceship-adjacent UI ideas, but it must stay a curated minority influence and avoid cyberpunk, synthwave, noir, military, or dystopian cues.

## Collection Notes

All all-rights-reserved venue imagery remains URL-only. Wikimedia category pages are also URL-only until a specific reusable file is selected and attributed. No reference image files are copied into this repository by this mood-board.
