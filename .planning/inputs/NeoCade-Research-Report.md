# VirtuCade UI Style Guide Research

We examined LDtk’s interface and source to distill its UI style, and combined this with Material Design principles and arcade motifs to define a style for *VirtuCade*. LDtk’s editor uses a **dark base with bright accent colors**, flat modern icons, and intuitive layout elements【3†L72-L80】【5†L384-L389】. Its main sidebar (left) holds navigation buttons and layer tools, tinted in distinct hues (e.g. blue for Entities, brown for Walls)【21†】. LDtk’s source confirms it uses **Material Design SVG icons** and a specific color palette (Endesga32) for level tiles【5†L384-L389】. The UI is clean and flat: panels and buttons have minimal borders, with emphasis on legibility and quick access. 

【21†embed_image】*LDtk’s level editor uses a dark theme with colored sidebars and Material-style icons for layers and tools【3†L72-L80】【5†L384-L389】. This clear, flat design with tinted panels inspires our own layout.*

Key aspects of LDtk’s UI style include:
- **Dark Mode Base:** Backgrounds are a dark charcoal/gray, maximizing contrast for colors and pixel art content【21†】. This echoes minimal editor themes (e.g. Godot’s default dark scheme) and works well with neon accents.
- **Color Accents:** Each UI panel or mode is tinted (blue for entities, green for editing tools, etc) to visually differentiate functions【21†】. LDtk uses a fixed palette (Endesga32) for project content, but its UI colors come from themes and custom overrides【5†L384-L389】.
- **Flat Iconography:** Buttons and tool icons are flat, monochrome white/light on colored backgrounds (using Material icons)【5†L384-L389】. This keeps the interface modern and legible.
- **Minimalist Layout:** A left sidebar and top toolbar give quick access to functions; lower panels (e.g. palette at bottom) toggle on demand. UI chrome is kept minimal to focus on content【3†L72-L80】.
- **Typography & Hints:** Text (e.g. layer names, tooltip keys) is simple sans-serif. Keyboard hints appear in-line (e.g. “F1 Entities”) for usability【21†】. 

## Godot Theme API & Minimal Theme

Godot’s theme system lets us apply a global style to all Controls (buttons, labels, panels, etc)【29†L9157-L9165】. The Godot Minimal Theme (now integrated into Godot 4.6) provides a useful reference: it uses a **dark gray base** (`#272727`) with a **blue accent** (`#569eff`) and a sharp, modern sans-serif (Inter) font【35†L263-L270】. Recommended settings include high icon saturation and slight corner rounding (4–5 px)【35†L263-L270】. This creates a cohesive, professional look with clear button states (hover, focus, pressed use brighter tints of the accent) and good readability. 

From the Minimal Theme:
- **Base Color:** #272727 (dark gray) – for panels, backgrounds.
- **Accent Color:** #569eff (bright blue) – for highlights, selected items.
- **Font:** *Inter* (clean, geometric sans-serif) – modern and legible.
- **Corner Radius:** 4–5 px – subtle rounding on UI boxes for a “material” feel.
- **Icon Saturation:** High – icons pop against dark UI.

We will use Godot’s Theme resource to set these styles: define colors, fonts, and StyleBoxes in a `.tres` theme file and apply it project-wide【29†L9157-L9165】.

## Material Design Influence

Material Design 3 (Material You) emphasizes **expressive color, dynamic theming, and accessible UI**. Key ideas we adopt:
- **Dynamic/Expressive Colors:** Material You can extract palettes from images or allow user customization. For VirtuCade, we fix a vibrant palette (inspired by arcades) but ensure all UI elements use consistent tints and contrasts. Google advises using balanced, accessible color pairings【44†L1360-L1368】.
- **Elevation & Motion:** While our UI is mostly flat, we can mimic Material’s layering by using subtle shadows or highlights on buttons (hover/pressed states) to convey depth and interactivity.
- **Shape and Layout:** Material 3 often uses rounded rectangles and cards. We’ll incorporate slight corner rounding (4–8 px) on panels/buttons (in line with Minimal Theme’s 4-5 px) to avoid harsh edges.
- **Typography & Scale:** Use large, bold headings and legible text. Material recommends sans-serif fonts with clear hierarchy; Godot’s Inter font fits this. UI text should be clear and not overly stylized.
- **Accessibility:** Maintain high contrast for text/icon legibility; Material You’s dynamic palette is designed for accessibility【44†L1360-L1368】.

## Arcade-Style Inspiration

Classic arcades and retro games inform our theme’s “personality”. Common arcade motifs:
- **Neon & Dark Contrast:** Bright neon colors (hot pink, electric cyan, bright green, purple) on deep black or navy backgrounds【46†L49-L58】【24†L23-L25】. The contrast makes UI elements glow and stand out. As one design pack notes, neon palettes *“look especially good on dark backgrounds (black, midnight blue, dark grey)”*【24†L23-L25】. 
- **Synthwave/Vaporwave Vibe:** References to 1980s-90s sci-fi (Tron, synth music) – think magenta and cyan glows, grid patterns or scanlines as subtle background texture【46†L49-L58】.
- **Pixel/Vector Art:** Although our UI is vector, we can mimic pixel-art charm via fonts or graphics. For example, using a sharp monospace or “arcade” font for title text adds flavor. Button graphics might have a slight 8-bit outline or glow.
- **Bold Buttons & Icons:** Arcade UIs often have chunky, framed buttons labeled in pixel/bitmap fonts (see example below). Interactive elements should feel “clicky” and responsive.
- **Sound & Animation:** While outside theme file, remember that arcade style suggests playful sound feedback and smooth animations (Material suggests motion). 

【47†embed_image】*Arcade-inspired UIs use high-contrast neon-on-black graphics. For example, this cyan-blue pixel-art button set (from a “Cyan Neon UI Pack”) shows common labels and arrow icons glowing on black【24†L23-L25】【46†L49-L58】.* 

## Proposed UI Style & Vocabulary

**Color Palette:** Adopt a **neon arcade palette** balanced with Material clarity. For instance:
- Backgrounds: Very dark grey/black (#000–#111).
- Primary Accent: Electric Cyan (#00ffff or similar) for primary buttons/icons.
- Secondary Accent: Hot Pink/Magenta (#ff33cc) for highlights/secondary actions.
- Tertiary Accent: Bright green or purple (#00ff66 or #cc00ff) for alerts or toggles.
- Neutrals: Light gray (#ddd) for disabled text, off-white (#f0f0f0) for text on dark.
These ensure vibrant pops against dark UI. We’ll define these as color constants in the theme.

**Fonts:** Use **Inter** (or similar modern sans-serif) for UI labels. For strong arcade feel, reserve a stylized pixel font for title logos only (not UI text). Font sizes: titles ~20px+, buttons ~16px, ensuring legibility.

**Icons:** Use crisp SVG icons (Material icons or custom neon-styled ones). Icons should be single-color (white or accent) so they adapt to theme tint. In Godot theme, assign icon textures to control types (via `add_icon`)【31†L9288-L9296】.

**Controls:** 
- Buttons and Tabs: Filled with accent or dark styles, with hover/pressed states tinted brighter/darker. Rounded corners (4-6px).
- StyleBoxes: Use solid background or subtle gradients (Material 3 often uses “tonal spot” colors) with matching border accent.
- Sliders & Progress: Neon track on dark base.
- Panels: Semi-transparent overlays or tinted bars for side panels.

**Terminology & Style Terms:**  
- *Dark Mode*: The entire UI uses a dark background (#0–#111) as primary canvas.  
- *Neon Accent*: Bright saturated colors (cyan, magenta, green) for interactive elements, providing energy and clarity.  
- *High Contrast*: Ensure text/icons contrast at least 4.5:1 with background for readability.  
- *Flat/Minimal*: Clean shapes with minimal decoration; focus on function.  
- *Rounded Corners*: Soft edges (4–8 px radius) for modern feel (in line with Material guidelines).  
- *Bold Typography*: Use large, clear fonts for headings and labels.  
- *Pixel Art Influence*: Subtle pixel grid textures or fonts in logos to nod to retro games (sparingly, to not hinder readability).  
- *Glow Effect*: Simulate neon glow via drop-shadows or light edges in artwork (not directly in theme code, but in icons/controls images).  
- *Responsive Layout*: Panels can collapse/expand (like LDtk’s toggleable palette) for efficient use of space.

## Theme Naming Suggestions

For a Godot theme evoking this style, consider names that fuse arcade nostalgia with modern flair:
- **ArcadeGlow UI** – Emphasizes neon glow.  
- **NeonGrid Theme** – Suggests grid overlays and neon palette.  
- **RetroSynth Theme** – Combines “retro” and “synthwave” aesthetic.  
- **VirtuPixel Theme** – Ties to *VirtuCade* name, suggests pixel/virtual arcade.  
- **SynthWave UI** – Clearly signals 80s vibe.  
- **CyberCade** – Mashes cyberpunk and arcade.  
- **NeonCade** – Play on “arcade” + “neon”.  
- **NightArcade Theme** – Implies dark mode arcade.  

Each name should hint at neon/digital-arcade style so users know what to expect.

## Handoff: Assets, Tokens, and Implementation Notes

To transition from design to coding, we will prepare:

- **Color Tokens:** Define named color constants in a stylesheet or documentation (e.g. `BG_DARK=#101010`, `ACCENT_PRIMARY=#00ffff`, `ACCENT_SECONDARY=#ff33cc`, `TEXT_HIGH=#f0f0f0`, `TEXT_LOW=#888`). These tokens guide theme resource values.
- **Font Assets:** Include the Inter font files (or use system default if embedded) and ensure licensing. If using a pixel font for logos, list that asset.
- **Icon Set:** Collect or create a set of monochrome SVG icons (using Google’s Material icon library as LDtk does) and neon-themed symbols. Provide these in a folder; theme script will assign them via `add_icon("icon_name", icon_texture)`.
- **Button Graphics:** If any custom button art (e.g. 3D-like or pixel) is needed, supply as textures. Otherwise, Godot `StyleBoxFlat` can create colored rectangles with borders.
- **StyleBox Definitions:** Plan out `StyleBoxFlat` or `StyleBoxTexture` resources in the theme for controls. For example, a flat style with border: 
  ```gdscript
  var button_box = StyleBoxFlat.new()
  button_box.bg_color = ACCENT_PRIMARY
  button_box.border_width_all = 2
  button_box.border_color = ACCENT_PRIMARY.darker(0.8)
  button_box.corner_radius = 5
  theme.set_stylebox("normal", "Button", button_box)
  ```
- **Screenshots/Mockups:** Provide references (like the LDtk [21] screenshot and neon UI [47] above) to guide exact color application. (We have already captured [21] and [47].)
- **Accessibility Checks:** Verify color contrasts using tools (Material accessibility guidelines) before finalizing tokens.
- **Godot Project Setup:** Use `ProjectSettings.gui/theme/custom` to load the theme resource. In scripts, use `get_theme_color("font_color", "Control")` etc. Document where to set these (e.g. in an autoload script or UI base).

By combining LDtk’s functional clarity, Material 3’s polish, and arcade’s vibrancy, the *VirtuCade* theme will be modern, colorful, and intuitively game-like, ready for implementation in Godot. 

**Sources:** Analysis based on LDtk docs and code【3†L72-L80】【5†L384-L389】, Google Material Design guidelines【44†L1353-L1360】, Godot theme docs【29†L9157-L9165】, and arcade UI examples【46†L49-L58】【24†L23-L25】.