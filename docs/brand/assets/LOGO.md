# Logo artwork — slot specification

**Status: awaiting official artwork.**

The three constructed SVG lockups that previously sat in this directory have been
removed. They were approximations, not the ArmoSpectra logo, and keeping them
risked one being used in production.

## What goes here

| File | Format | Notes |
|---|---|---|
| `armospectra-logo.svg` | SVG, transparent background | Preferred master. Paths, not embedded raster. |
| `armospectra-logo.png` | PNG, transparent background, 4× | Fallback master if no vector exists. |
| `armospectra-logo.jpg` | As supplied | Keep the original untouched alongside the working masters. |

A **transparent background is required.** The system renders the logo as a mask
(see `.as-logo` in `../tokens.css`), which is what lets one file serve every
colourway — white on ink, ink on white, 22% watermark — without ever recolouring,
redrawing, or distorting the artwork itself. A flattened JPG with a light
background cannot do this: dropped onto a near-black surface it renders as a pale
rectangle, and knocking that background out by hand would mean altering the file.

## Installing it

Two values, one place. In both `../tokens.css` and the deck's logo stencil block:

```css
--as-logo: url("data:image/svg+xml,<the artwork, URL-encoded>");
--as-logo-ratio: <exact intrinsic width>/<exact intrinsic height>;
```

That updates all 28 logo instances across the deck plus every export file at once.
No per-surface edits. `aspect-ratio` is bound to `--as-logo-ratio`, so distortion
is structurally impossible — instances are sized by height only and the width
follows from the master.

## Rules that already apply to it

Set in [`../BRAND_SYSTEM.md` § 3](../BRAND_SYSTEM.md#3-logo) and final:

- **Clearspace** — 1× wordmark cap-height on all four sides. Nothing enters it.
- **Minimum sizes** — vertical 96 px / 26 mm · horizontal 140 px / 34 mm ·
  mark alone 32 px / 9 mm · wordmark alone 120 px / 30 mm.
- **Colourways** — white on ink (primary) · ink on white (invert only) · 22% white
  (watermark). Applied by tinting the stencil, never by editing the file.
- **Never** — recolour, redraw, trace, reinterpret, distort, stretch, fill, apply
  the chrome gradient, add glow/shadow/outline effects, place on a chromatic or
  photographic background, or retype the wordmark.
