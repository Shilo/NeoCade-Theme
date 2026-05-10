"""
Synthesize reference images for the diagnostic.

Two synthetic reference frames so the comparison is measurable, not just cited:

  1. md3-reference.png -- a 1280x720 frame composed of MD3 spec role colors
     ONLY (primary, secondary, tertiary, error, plus surface tones). Uses the
     MD3 dynamic-color spec role names verbatim. This is what MD3 expects to
     be visible simultaneously per the spec referenced in the BRIEF.

  2. game-ui-reference.png -- a 1280x720 frame composed in the spirit of
     shipped mobile flat-modern game UIs (HCGames, Royal Match, Brawl Stars
     -- the cohort the BRIEF names). Uses 5 distinct hue families: a primary
     CTA (pink), secondary (cyan), tertiary (yellow/coin), severity-success
     (green pill), severity-danger (red dot), plus an off-base surface tint.

Synthesizing rather than fetching avoids copyright issues with shipped games.
The point is to MEASURE the same way we measure NeoCade and report a number.
"""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

OUT_DIR = Path(__file__).parent

MD3_PALETTE = {
    "surface": "#101418",
    "surface_container_low": "#1c2024",
    "surface_container": "#22262a",
    "surface_container_high": "#2c3034",
    "primary": "#a8c8ff",
    "primary_container": "#003258",
    "on_primary_container": "#d3e3ff",
    "secondary": "#bcc8db",
    "secondary_container": "#3c4858",
    "tertiary": "#dcbedc",
    "tertiary_container": "#4f3f4f",
    "error": "#ffb4ab",
    "error_container": "#680015",
}

GAME_PALETTE = {
    "surface": "#1a1730",
    "surface_panel": "#272246",
    "primary_cta": "#ff4d9a",
    "primary_cta_depth": "#b03169",
    "secondary": "#3ec1d3",
    "tertiary_coin": "#ffc857",
    "success": "#7ee08a",
    "danger": "#ff5e5e",
    "info": "#9c8cf4",
}


def _hex_to_rgb(h: str) -> tuple[int, int, int]:
    h = h.lstrip("#")
    return (int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16))


def synth_md3() -> Path:
    W, H = 1280, 720
    im = Image.new("RGB", (W, H), _hex_to_rgb(MD3_PALETTE["surface"]))
    d = ImageDraw.Draw(im)
    d.rectangle((40, 40, W - 40, 120), fill=_hex_to_rgb(MD3_PALETTE["surface_container_low"]))
    d.rectangle((40, 140, 360, 680), fill=_hex_to_rgb(MD3_PALETTE["surface_container"]))
    d.rectangle((380, 140, W - 40, 460), fill=_hex_to_rgb(MD3_PALETTE["surface_container_high"]))
    d.rectangle((380, 480, W - 40, 680), fill=_hex_to_rgb(MD3_PALETTE["surface_container"]))
    d.rectangle((420, 200, 700, 280), fill=_hex_to_rgb(MD3_PALETTE["primary_container"]))
    d.rectangle((420, 200, 700, 280), outline=_hex_to_rgb(MD3_PALETTE["primary"]), width=4)
    d.rectangle((720, 200, 1000, 280), fill=_hex_to_rgb(MD3_PALETTE["secondary_container"]))
    d.rectangle((420, 320, 700, 400), fill=_hex_to_rgb(MD3_PALETTE["tertiary_container"]))
    d.rectangle((720, 320, 1000, 400), fill=_hex_to_rgb(MD3_PALETTE["error_container"]))
    d.rectangle((420, 540, 700, 620), fill=_hex_to_rgb(MD3_PALETTE["primary"]))
    d.rectangle((720, 540, 900, 620), fill=_hex_to_rgb(MD3_PALETTE["error"]))
    d.rectangle((80, 200, 320, 260), fill=_hex_to_rgb(MD3_PALETTE["tertiary"]))
    d.rectangle((80, 280, 320, 340), fill=_hex_to_rgb(MD3_PALETTE["secondary"]))
    out = OUT_DIR / "md3-reference.png"
    im.save(out)
    return out


def synth_game() -> Path:
    W, H = 1280, 720
    im = Image.new("RGB", (W, H), _hex_to_rgb(GAME_PALETTE["surface"]))
    d = ImageDraw.Draw(im)
    d.rectangle((0, 0, W, 80), fill=_hex_to_rgb(GAME_PALETTE["surface_panel"]))
    d.ellipse((20, 20, 60, 60), fill=_hex_to_rgb(GAME_PALETTE["danger"]))
    d.rectangle((100, 22, 280, 58), fill=_hex_to_rgb(GAME_PALETTE["surface_panel"]))
    d.rectangle((110, 28, 270, 52), fill=_hex_to_rgb(GAME_PALETTE["success"]))
    d.rectangle((W - 220, 16, W - 40, 64), fill=_hex_to_rgb(GAME_PALETTE["tertiary_coin"]))
    d.rectangle((40, 120, W - 40, 480), fill=_hex_to_rgb(GAME_PALETTE["surface_panel"]))
    d.rectangle((80, 540, 380, 660), fill=_hex_to_rgb(GAME_PALETTE["primary_cta_depth"]))
    d.rectangle((80, 530, 380, 640), fill=_hex_to_rgb(GAME_PALETTE["primary_cta"]))
    d.rectangle((420, 540, 720, 660), fill=_hex_to_rgb(GAME_PALETTE["info"]))
    d.rectangle((760, 540, 1060, 660), fill=_hex_to_rgb(GAME_PALETTE["secondary"]))
    d.rectangle((1100, 540, 1240, 660), fill=_hex_to_rgb(GAME_PALETTE["tertiary_coin"]))
    d.rectangle((80, 160, 600, 220), fill=_hex_to_rgb(GAME_PALETTE["primary_cta"]))
    d.rectangle((80, 240, 600, 300), fill=_hex_to_rgb(GAME_PALETTE["secondary"]))
    d.rectangle((80, 320, 600, 380), fill=_hex_to_rgb(GAME_PALETTE["info"]))
    d.rectangle((80, 400, 600, 460), fill=_hex_to_rgb(GAME_PALETTE["success"]))
    d.rectangle((640, 160, 1240, 460), fill=_hex_to_rgb(GAME_PALETTE["surface"]))
    d.ellipse((680, 200, 760, 280), fill=_hex_to_rgb(GAME_PALETTE["danger"]))
    d.ellipse((780, 200, 860, 280), fill=_hex_to_rgb(GAME_PALETTE["success"]))
    d.ellipse((880, 200, 960, 280), fill=_hex_to_rgb(GAME_PALETTE["tertiary_coin"]))
    d.ellipse((980, 200, 1060, 280), fill=_hex_to_rgb(GAME_PALETTE["info"]))
    out = OUT_DIR / "game-ui-reference.png"
    im.save(out)
    return out


if __name__ == "__main__":
    p1 = synth_md3()
    p2 = synth_game()
    print(f"wrote {p1}")
    print(f"wrote {p2}")
