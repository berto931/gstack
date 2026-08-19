# Logo artwork

**Status: installed.**

## Provenance

| | |
|---|---|
| Source | `berto931/armospectra-team-portal` → `public/armospectra-logo.jpg` |
| SHA-256 | `03d95cb8f8b39f8272b6b27d27de7cbae024b306381edaa672e532f5406ecf06` |
| Source size | 1080 × 1350, baseline JPEG, 61,403 bytes |
| Background | flat `#F2F4F3` (86.44% of all pixels; all four corners identical) |
| Ink | `#58595D` |
| Mark bounding box | x 129–946, y 259–1090 → **818 × 832** |
| Installed ratio | `818/832` = 0.98317 |

The `dist/` copy referenced locally is a build artifact of this same `public/` source.

## Files

| File | What it is |
|---|---|
| `armospectra-logo.jpg` | The supplied master, **byte-identical**. Verified by SHA-256. Never edit. |
| `armospectra-logo.png` | Transparent, full 1080 × 1350 canvas, original ink RGB preserved. Use when the file's own padding is wanted. |
| `armospectra-logo-mark.png` | Transparent, trimmed to the 818 × 832 mark box, original ink RGB. General-purpose asset. |
| `armospectra-logo-mask.png` | 818 × 832 LA stencil. Drives `--as-logo`. `L == A`, so it masks correctly under both alpha and luminance interpretation. |

## How the background was removed

Luminance keying, not thresholding:

```
alpha = clamp((bg_luma - pixel_luma) / (bg_luma - ink_luma), 0, 1)
      = clamp((243.5 - luma) / 154.4, 0, 1)
```

Alpha varies linearly with how far each pixel travelled from background toward
ink, so the original antialiased edge ramp survives intact — **70,032 pixels**
carry partial alpha in the result. No thresholding, no blurring, no morphology,
no despeckling, no redrawing, no resampling. Geometry is bit-for-bit the
original; only the flat background was keyed to transparent.

Crop is to the mark's own bounding box, so the mark's aspect ratio is exactly
preserved. The source padding was near-symmetric to begin with (L129 R133,
T259 B259).

## Reinstalling / replacing

```bash
python3 docs/brand/install-logo.py docs/brand/assets/armospectra-logo-mask.png
```

Accepts SVG or a transparent PNG. It computes the exact intrinsic ratio, embeds
the file verbatim as a data URI, and patches `--as-logo`, `--as-logo-ratio`, and
`--as-logo-installed` in both `tokens.css` and the deck — all 28 logo instances
at once. `--check` validates without writing. It refuses embedded rasters inside
SVG, alpha-less PNGs, full-bleed background plates, and missing dimensions.

**When a vector master exists, switch to it.** SVG scales without limit and is
what large-format print wants. The installer takes it directly; nothing else changes.

## Rules

Set in [`../BRAND_SYSTEM.md` § 3](../BRAND_SYSTEM.md#3-logo):

- **Sizing** — by **height only**. Width follows from `--as-logo-ratio`. Setting
  both is the one way to distort the mark, and `aspect-ratio` prevents it.
- **Clearspace** — 1× wordmark cap-height on all four sides. Nothing enters it.
- **Minimum sizes** — vertical 96 px / 26 mm · horizontal 140 px / 34 mm ·
  mark alone 32 px / 9 mm · wordmark alone 120 px / 30 mm. At 26 mm the 818 px
  master resolves to roughly 800 DPI, so resolution is not a constraint.
- **Colourways** — white on ink (primary) · ink on white (invert only) · 22% white
  (watermark). Applied by tinting the stencil via `color`, never by editing a file.
- **Never** — recolour, redraw, trace, reinterpret, distort, stretch, fill, apply
  the chrome gradient, add glow/shadow/outline effects, place on a chromatic or
  photographic background, or retype the wordmark.
