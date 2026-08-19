# ArmoSpectra brand assets

Dark-first visual identity system, v1.0. Derived from the ArmoSpectra CEO poster,
which remains the primary source of truth for anything these files do not cover.

## Files

| File | What it is |
|---|---|
| [`armospectra-brand-deck.html`](armospectra-brand-deck.html) | The visual deck — 23 spreads, self-contained, opens in any browser |
| [`BRAND_SYSTEM.md`](BRAND_SYSTEM.md) | The written specification. Read this before changing anything |
| [`tokens.css`](tokens.css) | CSS custom properties + reference implementations of the signature devices |
| [`tokens.json`](tokens.json) | Design tokens in DTCG-style JSON, including measured contrast ratios |
| [`tailwind.preset.js`](tailwind.preset.js) | Tailwind theme preset with `.text-chrome`, `.btn-brand`, `.divider-brand` |
| `assets/logo-mark.svg` | Mark, construction reference |
| `assets/logo-lockup-vertical.svg` | Primary lockup |
| `assets/logo-lockup-horizontal.svg` | Secondary lockup |
| `assets/arc-motif.svg` | Ambient arc anchor |
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

## Two things to know before you ship

**The mark is a construction reference.** `logo-mark.svg` and the two lockups
encode the stroke weight, proportion, and geometry rules. They are not a
substitute for the original vector artwork. Replace them with the supplied
production file before anything is printed or published.

**The lockup SVGs use live text.** The wordmark is a `<text>` element in
Montserrat, not outlined paths. That keeps it editable and keeps tracking
adjustable, but it means the file renders correctly only where Montserrat is
available. Convert to outlines before sending to a printer or an external party.

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
