# ArmoSpectra brand assets

Dark-first visual identity system, v1.0. Derived from the ArmoSpectra CEO poster,
which remains the primary source of truth for anything these files do not cover.

## Files

| File | What it is |
|---|---|
| [`armospectra-brand-deck.html`](armospectra-brand-deck.html) | The visual deck — 23 spreads, self-contained, opens in any browser |
| [`armospectra-brand-deck.pdf`](armospectra-brand-deck.pdf) | The same deck as a 23-page 16:9 PDF, fonts embedded |
| [`build-pdf.py`](build-pdf.py) | Regenerates the PDF from the HTML |
| [`BRAND_SYSTEM.md`](BRAND_SYSTEM.md) | The written specification. Read this before changing anything |
| [`tokens.css`](tokens.css) | CSS custom properties + reference implementations of the signature devices |
| [`tokens.json`](tokens.json) | Design tokens in DTCG-style JSON, including measured contrast ratios |
| [`tailwind.preset.js`](tailwind.preset.js) | Tailwind theme preset with `.text-chrome`, `.btn-brand`, `.divider-brand` |
| `assets/armospectra-logo.jpg` | The supplied master, byte-identical |
| `assets/armospectra-logo*.png` | Transparent + stencil derivatives |
| `assets/LOGO.md` | Logo provenance, key method, reinstall steps |
| `assets/arc-motif.svg` | Ambient arc anchor |
| `install-logo.py` | One-command logo install (SVG or transparent PNG) |
| `assets/icons/*.svg` | Six capability icons — 24 px canvas, 1.5 stroke, outline only |

## Using the tokens

```html
<link rel="stylesheet" href="docs/brand/tokens.css">
<link rel="stylesheet"
      href="https://fonts.googleapis.com/css2?family=Montserrat:wght@200;300;400;500;800;900&family=Great+Vibes&display=swap">
```

```js
// tailwind.config.js
module.exports = {
  presets: [require('./docs/brand/tailwind.preset.js')],
  content: ['./src/**/*.{html,js,jsx,ts,tsx}'],
};
```

SVGs are stroked with `currentColor`, so they inherit from their container:

```html
<span style="color: var(--as-white)">
  <svg><use href="assets/icons/visibility.svg#..."></use></svg>
</span>
```

## The logo

The official artwork is **installed**, sourced from
`armospectra-team-portal/public/armospectra-logo.jpg` (sha256 `03d95cb8…`). Its
flat `#F2F4F3` background was keyed out by luminance distance, which preserves the
original antialiased edges exactly. The mark's pixels and its 818 × 832 bounding
box are unmodified — nothing redrawn, traced, recoloured, or resampled. The
untouched original ships alongside as `assets/armospectra-logo.jpg`.

All 28 logo instances render from one token, `--as-logo`, used as a CSS mask. One
file serves every colourway — white on ink, ink on white, 22% watermark — by
tinting the stencil rather than editing the file. `aspect-ratio` is bound to
`--as-logo-ratio` (`818/832`) and instances are sized by height only, so
distortion is structurally impossible rather than merely prohibited.

To replace it (a vector master, when one exists):

```bash
python3 docs/brand/install-logo.py path/to/armospectra-logo.svg
```

Provenance, key method, and rules: [`assets/LOGO.md`](assets/LOGO.md).

## The five rules people break first

1. Dark is the default, not a theme — never auto-invert these tokens for light mode.
2. Blue stays under ~5% of pixels. If it reads as blue, it is wrong.
3. Chrome gradient on display type only, one or two words, never below 48 px.
4. Two brand typefaces. The mono face in these files is documentation only.
5. CTAs are outlined pills. White on Blue 500 measures 3.33:1 and fails AA.

Full list: [`BRAND_SYSTEM.md` § 15](BRAND_SYSTEM.md#15-master-rules).

## What is deliberately missing

No client names, metrics, case studies, testimonials, pricing, or a light-mode
palette. None of those are established in the source material, and the messaging
framework keeps its proof tier visibly empty rather than filling it with
plausible-sounding copy. Add them with evidence.


## Regenerating the PDF

```bash
python3 docs/brand/build-pdf.py
```

23 pages at 16.667 × 9.377 in (16:9). Each spread becomes one page, fitted to the
page aspect rather than uniformly shrunk, so type stays large and the page fills.

Two things the builder handles that a plain browser "Print to PDF" does not:

- **Fonts.** Montserrat and JetBrains Mono ship from Google Fonts as *variable*
  fonts. Chromium renders those correctly on screen but substitutes a system font
  when printing, which silently set the deck in DejaVu Sans. The builder pulls each
  variable master once, instantiates a static instance at every weight the deck
  uses, and embeds those. Only `→` (U+2192) and `≤` (U+2264) fall back, both being
  outside Montserrat's Latin subset. Liberation Serif appears once by design — it is
  the "never reset the wordmark in another typeface" misuse demo.
- **Grain.** The deck's anti-banding texture is an SVG `feTurbulence` filter, which
  Chromium re-rasterizes per page: 8.1 MB across 23 pages. The builder substitutes a
  seeded 128 × 128 PNG tile, same texture as one reusable image object. Final PDF is
  3.4 MB.

Chrome-gradient headline words are rasterized rather than kept as text, because
`background-clip: text` has no PDF text equivalent. They stay crisp, but are not
selectable or searchable; all other text is.
