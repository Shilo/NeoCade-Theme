"""
Spike 001: Color Monoculture Diagnostic

Counts perceptually distinct hue families on a sample image. The BRIEF
(mandate item 1) asks for a numeric headline: how many unique hues appear
on a representative showcase frame for each NeoCade direction, vs MD3
reference layouts (3+ roles expected) and shipped game UIs (4-6+ hues common).

Method:
  1. Load image, downsample to a manageable pixel count.
  2. Convert sRGB -> HSV.
  3. Mask out chrome-irrelevant pixels:
       - very dark backgrounds (V < DARK_V_THRESHOLD)
       - near-greys (S < GREY_S_THRESHOLD): surface tint ramps that all
         derive from base_color and read as one tonal family per the BRIEF.
       - near-white text (V > WHITE_V_THRESHOLD AND S < TEXT_S)
  4. Bin remaining pixels by hue into HUE_BINS bins covering the full circle.
  5. Sum the saturation-weighted area per bin (a small but vivid pink reads
     as more "hue presence" than a large but muddy off-grey).
  6. Identify peaks above MIN_BIN_SHARE_OF_KEEP.
  7. Merge adjacent bins (within HUE_MERGE_BINS) into a single hue family.

The classification of "near-grey as not a hue" is deliberate per the BRIEF: the
5-stop tonal ramp (surface_low / surface_base / surface_panel / surface_high /
surface_overlay) all share the same hue family and read as ONE color to the eye.
The user's complaint is "navy + navy + navy + navy + dot of green = 2 hues" --
the analyzer must reflect that perception, not a literal RGB-pixel-count.

NOT in scope: comparing aesthetic quality, judging which colors are good. The
spike answers "how many?" not "which?".
"""

from __future__ import annotations

import colorsys
import json
import sys
from dataclasses import dataclass, asdict
from pathlib import Path

import numpy as np
from PIL import Image

DARK_V_THRESHOLD = 0.15
WHITE_V_THRESHOLD = 0.92
GREY_S_THRESHOLD = 0.12
TEXT_S = 0.06
MIN_BIN_SHARE_OF_KEEP = 0.012
HUE_BINS = 60
HUE_MERGE_BINS = 4
DOWNSAMPLE_TARGET = 200_000


@dataclass
class HueFamily:
    hue_deg: float
    rgb: tuple[int, int, int]
    share_of_keep: float
    saturation_mean: float
    value_mean: float


@dataclass
class ImageReport:
    path: str
    pixels_total: int
    pixels_after_mask: int
    grey_share: float
    dark_share: float
    white_share: float
    hue_count: int
    families: list[HueFamily]


def _load_hsv(path: Path) -> tuple[np.ndarray, int]:
    im = Image.open(path).convert("RGB")
    if im.width * im.height > DOWNSAMPLE_TARGET:
        scale = (DOWNSAMPLE_TARGET / (im.width * im.height)) ** 0.5
        im = im.resize(
            (max(1, int(im.width * scale)), max(1, int(im.height * scale))),
            Image.Resampling.BILINEAR,
        )
    rgb = np.asarray(im, dtype=np.float32) / 255.0
    flat = rgb.reshape(-1, 3)
    r, g, b = flat[:, 0], flat[:, 1], flat[:, 2]
    cmax = np.maximum(np.maximum(r, g), b)
    cmin = np.minimum(np.minimum(r, g), b)
    delta = cmax - cmin

    h = np.zeros_like(cmax)
    nonzero = delta > 1e-6
    rmax = (cmax == r) & nonzero
    gmax = (cmax == g) & nonzero
    bmax = (cmax == b) & nonzero
    h[rmax] = ((g[rmax] - b[rmax]) / delta[rmax]) % 6
    h[gmax] = ((b[gmax] - r[gmax]) / delta[gmax]) + 2
    h[bmax] = ((r[bmax] - g[bmax]) / delta[bmax]) + 4
    h = (h / 6.0) % 1.0

    v = cmax
    s = np.where(cmax > 1e-6, delta / cmax, 0.0)
    return np.stack([h, s, v], axis=-1), flat.shape[0]


def analyze(path: Path) -> ImageReport:
    hsv, total = _load_hsv(path)
    H = hsv[:, 0]
    S = hsv[:, 1]
    V = hsv[:, 2]

    dark_mask = V < DARK_V_THRESHOLD
    white_mask = (V > WHITE_V_THRESHOLD) & (S < TEXT_S)
    grey_mask = (S < GREY_S_THRESHOLD) & ~dark_mask & ~white_mask

    drop_mask = dark_mask | white_mask | grey_mask
    keep_idx = ~drop_mask
    keep = hsv[keep_idx]

    if keep.shape[0] < 100:
        return ImageReport(
            path=str(path),
            pixels_total=total,
            pixels_after_mask=int(keep.shape[0]),
            grey_share=float(grey_mask.sum() / total),
            dark_share=float(dark_mask.sum() / total),
            white_share=float(white_mask.sum() / total),
            hue_count=0,
            families=[],
        )

    hue_idx = np.minimum((keep[:, 0] * HUE_BINS).astype(int), HUE_BINS - 1)
    weights = keep[:, 1]
    bins = np.zeros(HUE_BINS, dtype=np.float64)
    bins_count = np.zeros(HUE_BINS, dtype=np.int64)
    s_sum = np.zeros(HUE_BINS, dtype=np.float64)
    v_sum = np.zeros(HUE_BINS, dtype=np.float64)
    np.add.at(bins, hue_idx, weights)
    np.add.at(bins_count, hue_idx, 1)
    np.add.at(s_sum, hue_idx, keep[:, 1])
    np.add.at(v_sum, hue_idx, keep[:, 2])

    total_weight = bins.sum()
    if total_weight <= 0:
        return ImageReport(
            path=str(path),
            pixels_total=total,
            pixels_after_mask=int(keep.shape[0]),
            grey_share=float(grey_mask.sum() / total),
            dark_share=float(dark_mask.sum() / total),
            white_share=float(white_mask.sum() / total),
            hue_count=0,
            families=[],
        )

    bin_share = bins / total_weight
    significant = bin_share >= MIN_BIN_SHARE_OF_KEEP

    families: list[HueFamily] = []
    visited = np.zeros(HUE_BINS, dtype=bool)
    for i in np.argsort(-bin_share):
        if not significant[i] or visited[i]:
            continue
        merged_bins = [int(i)]
        for d in range(1, HUE_MERGE_BINS + 1):
            for j in ((i + d) % HUE_BINS, (i - d) % HUE_BINS):
                if visited[j]:
                    continue
                if bin_share[j] >= MIN_BIN_SHARE_OF_KEEP * 0.4:
                    merged_bins.append(int(j))
        merged_bins = list(dict.fromkeys(merged_bins))
        for j in merged_bins:
            visited[j] = True
        share = float(sum(bin_share[j] for j in merged_bins))
        cnt = sum(int(bins_count[j]) for j in merged_bins)
        if cnt == 0:
            continue
        s_mean = float(sum(s_sum[j] for j in merged_bins) / cnt)
        v_mean = float(sum(v_sum[j] for j in merged_bins) / cnt)
        cos_sum = sum(np.cos(2 * np.pi * (j + 0.5) / HUE_BINS) * bin_share[j] for j in merged_bins)
        sin_sum = sum(np.sin(2 * np.pi * (j + 0.5) / HUE_BINS) * bin_share[j] for j in merged_bins)
        ang = np.degrees(np.arctan2(sin_sum, cos_sum)) % 360.0
        rgb = colorsys.hsv_to_rgb(ang / 360.0, max(s_mean, 0.4), max(v_mean, 0.5))
        families.append(
            HueFamily(
                hue_deg=float(ang),
                rgb=(int(rgb[0] * 255), int(rgb[1] * 255), int(rgb[2] * 255)),
                share_of_keep=share,
                saturation_mean=s_mean,
                value_mean=v_mean,
            )
        )

    families.sort(key=lambda f: -f.share_of_keep)
    return ImageReport(
        path=str(path),
        pixels_total=total,
        pixels_after_mask=int(keep.shape[0]),
        grey_share=float(grey_mask.sum() / total),
        dark_share=float(dark_mask.sum() / total),
        white_share=float(white_mask.sum() / total),
        hue_count=len(families),
        families=families,
    )


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print("usage: analyze_hues.py <image> [<image> ...]")
        return 2
    out = []
    for arg in argv[1:]:
        p = Path(arg)
        rep = analyze(p)
        out.append(asdict(rep))
        swatches = " ".join(
            f"#{f.rgb[0]:02x}{f.rgb[1]:02x}{f.rgb[2]:02x}@{f.share_of_keep:.0%}"
            for f in rep.families
        )
        print(
            f"{p.name}: hues={rep.hue_count} "
            f"grey={rep.grey_share:.1%} dark={rep.dark_share:.1%} "
            f"keep={rep.pixels_after_mask} :: {swatches}"
        )
    Path("hue_report.json").write_text(json.dumps(out, indent=2))
    print("wrote hue_report.json")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
