# Axiom — Phase 2: Wireframes, Copy Deck & Component Specs

Date: 2026-07-31
Status: **Delivered for approval. Not committed.**
No credits spent. No Lovable messages. No Higgsfield. No assets generated or modified.
Owners: B1 UI/UX Designer (wireframes), A2 Copywriter (copy deck), B2 + B3 (component specs)

Builds on the architecture in Phase 0 §6 and the art direction in Phase 1.

**`0.3` CLOSED — EST. 1995 is real.** It appears once, on the house mark, and copy may
reference it. Every deferred date line in this document is now written and marked ✎.

**Deferred pending assets** (marked ⧗ throughout):
- The house mark itself — needs the vector suite (`0.5`)
- Favicon, packaging, neck/care label artwork — same
- Exact red rendering — `--red` is provisional (`0.4`); every use is token-driven, so
  the swap is one line, but §6 lists each place that recomputes

---

## 1. Wireframes

Structural only. No visual design, no assets. `▓` = media, `░` = product image,
`───` = 1px rule, `[ ]` = interactive.

### 1.1 Home

```
DESKTOP ≥1280                                        MOBILE <768
┌──────────────────────────────────────────┐        ┌──────────────────┐
│ ⧗MARK   SHOP  DROPS  MANIFESTO   ⌕ ⛉ BAG⁰│        │ ⧗MARK        ☰ ⁰ │  transparent
├──────────────────────────────────────────┤        ├──────────────────┤  over hero
│▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│        │▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│
│▓          THE STANDARD IS SET           ▓│        │▓ THE STANDARD   ▓│  100vh
│▓                                        ▓│        │▓ IS SET         ▓│  muted loop
│▓                              ↓ scroll  ▓│        │▓          ↓     ▓│  poster = LCP
├──────────────────────────────────────────┤        ├──────────────────┤
│  ██ INK GROUND ██                        │        │  ██ INK ██       │
│  AN AXIOM IS A TRUTH                     │        │  AN AXIOM IS     │  display-xl
│  THAT DOES NOT                           │        │  A TRUTH THAT    │  line reveal
│  REQUIRE VALIDATION                      │        │  DOES NOT...     │  600ms
├──────────────────────────────────────────┤        ├──────────────────┤
│ DROP 004 ─────────────  │ ░░░░  ░░░░     │        │ DROP 004         │  pinned col
│ Twelve pieces.          │ name  name     │        │ ─────────        │  desktop only
│ Nothing repeats.        │ $180  $220     │        │ ░░░░  ░░░░       │  stacks <1024
│ [ VIEW DROP 004 ]       │ ░░░░  ░░░░     │        │ ░░░░  ░░░░       │
├──────────────────────────────────────────┤        ├──────────────────┤
│  ░░░░░░░░░░░░░  │  ░░░░░░░░░░░░░         │        │  ░░░░░░░░░░░░    │  2-up / 1-up
│  ATHLETICS      │  CLUB                  │        │  ATHLETICS       │  video on hover
├──────────────────────────────────────────┤        ├──────────────────┤
│▓▓▓▓▓▓▓▓ full-bleed editorial ▓▓▓▓▓▓▓▓▓▓▓▓│        │▓▓▓ editorial ▓▓▓▓│  parallax 0.85
├──────────────────────────────────────────┤        ├──────────────────┤
│ ░░ ░░ ░░ ░░ ░░ ░░ →  horizontal rail     │        │ ░░ ░░ ░░ → swipe │  snap points
├──────────────────────────────────────────┤        ├──────────────────┤
│  ██ INK ██  Access to every release.     │        │  ██ INK ██       │
│  [ email                    ] [ SUBMIT ] │        │  [ email       ] │  red submit
├──────────────────────────────────────────┤        ├──────────────────┤
│ SHOP        SUPPORT     LEGAL            │        │ SHOP        ▾    │  accordion
│ Athletics   Shipping    Terms            │        │ SUPPORT     ▾    │  on mobile
│ Club        Returns     Privacy          │        │ LEGAL       ▾    │
│ Drops       Sizing      Accessibility    │        │                  │
│ ─────────────────────────────────────────│        │ ──────────────── │
│ AXIOM · EST. 1995 · BASED IN NYC     ✎   │        │ AXIOM · EST.1995 │  mono meta
└──────────────────────────────────────────┘        └──────────────────┘
```

Header solidifies to `--ink` past 80vh. Red hairline scroll-progress pinned to viewport
top throughout.

### 1.2 Collection (`/collections/athletics`, `/collections/club`)

```
┌──────────────────────────────────────────┐
│ HEADER (solid from load)                 │
├──────────────────────────────────────────┤
│▓▓▓▓ line film or still ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓│  60vh
│  AXIOM ATHLETICS                         │  display-m
├──────────────────────────────────────────┤
│  Technical pieces. Built to be used.     │  measure-capped thesis
├──────────────────────────────────────────┤
│ ── sticky ───────────────────────────────│
│ SIZE ▾  COLOUR ▾  AVAILABILITY ▾ │ SORT ▾│  filters left, sort right
├──────────────────────────────────────────┤  mobile: [ FILTER ] drawer
│  ░░░░░░   ░░░░░░   ░░░░░░                │  3-up ≥1280
│  NAME     NAME     NAME     SOLD OUT     │  2-up <768
│  $180     $220     $160     $190         │  price ALWAYS visible
│  ● ● ●    ● ●      ● ● ● ●   ●̶ ●̶         │  swatch dots
│                                          │
│  ░░░░░░   ░░░░░░   ░░░░░░                │
├──────────────────────────────────────────┤
│  ██ INK ██ close-out editorial           │
│  [ VIEW AXIOM CLUB → ]                   │  cross-link to other line
└──────────────────────────────────────────┘
```

Sold-out items stay in the grid, greyed, marked `SOLD OUT` in mono. Scarcity is the story.

### 1.3 PDP — the most important page

```
DESKTOP ≥1280
┌───────────────────────────────┬──────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░░░░░       │ ATHLETICS            │ line, mono
│ ░░░░ 1 · front                │ Boxed Tee            │ display-s
│ ░░░░░░░░░░░░░░░░░░░░░░░       │ DROP 004             │ mono
│                               │ $180                 │ SSR, tabular
│ ░░░░ 2 · back                 │ ──────────────────── │
│                               │ COLOUR               │
│ ░░░░ 3 · detail               │ ● ● ● ●              │ garment tokens
│                               │ Black                │
│ ░░░░ 4 · on-body              │ ──────────────────── │
│                               │ SIZE      [Size guide]│ opens drawer
│ ░░░░ 5 · on-body 3/4          │ [S][M][L][X̶L̶][XXL]   │ XL struck = gone
│                               │ ──────────────────── │
│ ▓▓▓▓ 6 · motion clip          │ [    ADD    ]        │ full-width
│      mood only, not product   │ ──────────────────── │
│      truth                    │ ▸ Details            │ accordion
│  ← gallery scrolls            │ ▸ Fabric & Care      │ one open at a time
│    panel is sticky →          │ ▸ Shipping & Returns │
└───────────────────────────────┴──────────────────────┘
├───────────────────────────────────────────────────────┤
│  ██ INK ██  "The piece"  ░░░ + 40 words               │
├───────────────────────────────────────────────────────┤
│  COMPLETE THE LOOK   ░░ ░░ ░░ →   editorially curated │ never algorithmic
├───────────────────────────────────────────────────────┤
│  RECENTLY VIEWED     ░░ ░░ ░░ →                       │
└───────────────────────────────────────────────────────┘

MOBILE: gallery is a full-width swipe carousel with dot indicators; the panel follows
below; ADD becomes a sticky bottom bar past the fold.
```

Click any gallery image → full-screen `ZoomViewer`, pinch/drag, `Esc` closes, focus
returns to the originating thumbnail.

`ADD` → cart drawer slides 300ms; the new line flashes a red left-rule for 600ms.
No page navigation. No toast.

### 1.4 Drops index + drop story

```
/drops                                    /drops/:slug
┌────────────────────────────┐            ┌────────────────────────────┐
│ 2026 ───────────────────── │            │▓▓▓▓ drop film ▓▓▓▓▓▓▓▓▓▓▓▓▓│ 100vh
│  ░░░  DROP 004             │            │  DROP 004                  │
│       12 pieces · Sept     │            ├────────────────────────────┤
│       [ VIEW ]             │            │ ██ INK ██ thesis, 3 para   │
│                            │            ├────────────────────────────┤
│  ░░░  DROP 003   SOLD OUT  │            │ THE PIECES                 │
│                            │            │ ░░ ░░ ░░ ░░ grid           │
│  ░░░  DROP 002   SOLD OUT  │            ├────────────────────────────┤
│ 2025 ───────────────────── │            │ ▓▓ shot gallery ▓▓         │
│  ░░░  DROP 001   SOLD OUT  │            ├────────────────────────────┤
└────────────────────────────┘            │ [ SHOP DROP 004 ]  ← only  │
                                          │   commerce CTA on the page │
Upcoming drops show a server-time         └────────────────────────────┘
countdown. Past drops stay visible.
```

### 1.5 Manifesto

```
┌──────────────────────────────────────────┐
│  ██ INK ██                               │
│  AN AXIOM IS A TRUTH                     │  100vh, held alone
│  THAT DOES NOT REQUIRE VALIDATION        │
├──────────────────────────────────────────┤
│  ░ PAPER ░  Panel 1 — what Axiom is      │  alternating
├──────────────────────────────────────────┤
│  ██ INK ██  Panel 2 — intention          │
├──────────────────────────────────────────┤
│  ░ PAPER ░  Panel 3 — scarcity           │
├──────────────────────────────────────────┤
│  HOUSE CODES                             │
│  ⧗ mark   ★★★      ───      DROP 0NN     │  annotated diagrams
│  capsule  stars   red rule  numbered     │
├──────────────────────────────────────────┤
│  [ VIEW DROP 004 → ]                     │  single exit
└──────────────────────────────────────────┘
```

### 1.6 Cart drawer · Search · Support · Errors

```
CART DRAWER (420px, right)        SEARCH OVERLAY           404
┌──────────────────────┐          ┌──────────────────┐    ┌──────────────┐
│ BAG (2)         [×]  │          │ [ ⌕            ] │    │ 404          │
│ ──────────────────── │          │ ──────────────── │    │              │
│ ░░ Boxed Tee         │          │ RECENT           │    │ THIS PAGE IS │
│    M · Black         │          │ boxed tee        │    │ NOT AN AXIOM │
│    $180    [−][1][+] │          │ ──────────────── │    │ ──────────── │
│            [ Remove ]│          │ ░░ ░░ ░░ results │    │ It does not  │
│ ──────────────────── │          └──────────────────┘    │ exist.       │
│ Subtotal      $400   │                                  │              │
│ Free shipping over   │          SUPPORT                  │ [ GO HOME ]  │
│ $250 ✓               │          ┌──────────────────┐    └──────────────┘
│ ──────────────────── │          │ nav │ article    │
│ [    CHECKOUT    ]   │          │     │ two-col    │
└──────────────────────┘          └──────────────────┘
```

---

## 2. Copy deck

Every line obeys the voice charter (Phase 0 §4). No exclamation marks, no hedging,
nothing from the banned lexicon. Mono for all numbers.

### 2.1 Home

| Slot | Copy |
|---|---|
| Hero statement | **THE STANDARD IS SET** |
| Hero alt (A/B) | **NOTHING HERE NEEDS EXPLAINING** |
| Axiom section | **AN AXIOM IS A TRUTH THAT DOES NOT REQUIRE VALIDATION** |
| Drop eyebrow | `DROP 004` |
| Drop headline | Twelve pieces. Nothing repeats. |
| Drop CTA | `VIEW DROP 004` |
| Line tile — Athletics | **ATHLETICS** / Built to be used. |
| Line tile — Club | **CLUB** / For the ones who were already sure. |
| Editorial overlay | Made once. Made properly. |
| Rail heading | `THE CURRENT RANGE` |
| Email heading | Access to every release. |
| Email placeholder | `your email` |
| Email button | `SUBMIT` |
| Email success | You are on the list. |
| Email error | That address is not complete. |
| Footer meta ✎ | `AXIOM · EST. 1995 · BASED IN NYC` |

### 2.2 Collection

| Slot | Athletics | Club |
|---|---|---|
| Title | **AXIOM ATHLETICS** | **AXIOM CLUB** |
| Thesis | Technical pieces. Built to be used, not looked after. | Cut for people who stopped asking. |
| Empty filter | Nothing matches that. | Nothing matches that. |
| Cross-link | `VIEW AXIOM CLUB` | `VIEW AXIOM ATHLETICS` |
| Close-out | The range does not grow. It gets replaced. | The range does not grow. It gets replaced. |

### 2.3 PDP

| Slot | Copy |
|---|---|
| Line | `ATHLETICS` / `CLUB` |
| Drop | `DROP 004` |
| Size label | `SIZE` |
| Size guide link | `Size guide` |
| Sold-out size | `Gone` (tooltip on the struck size) |
| Add | `ADD` |
| Adding | `ADDING` |
| Added | `ADDED` |
| Sold out | `SOLD OUT` |
| Notify | `NOTIFY ME` |
| Notify success | We will tell you once. |
| Accordion 1 | `DETAILS` |
| Accordion 2 | `FABRIC & CARE` |
| Accordion 3 | `SHIPPING & RETURNS` |
| Product description (pattern) | 14oz brushed cotton. Boxed shoulder. Cut to hold its shape. |
| "The piece" (pattern) | Forty words on why the piece exists. Construction, not adjectives. |
| Complete the look | `WEARS WITH` |
| Recently viewed | `RECENTLY VIEWED` |

**Product description formula** — three sentences, in this order: material and weight ·
construction detail · intent. Never mood. Never "elevated," "essential," or "premium."

### 2.4 Drops

| Slot | Copy |
|---|---|
| Index title | **THE RECORD** |
| Index sub | Every release. Nothing removed. |
| Upcoming | `RELEASES IN 04:12:33:09` (mono, server time) |
| Past | `SOLD OUT` |
| Story thesis (pattern) | What the drop is. Why these pieces. What it replaces. |
| Story CTA | `SHOP DROP 004` |

### 2.5 Manifesto

> **AN AXIOM IS A TRUTH THAT DOES NOT REQUIRE VALIDATION**
>
> Axiom is more than apparel. It stands for confidence, ambition, and the pursuit of
> greatness.
>
> Every collection is intentional. Every release is limited. Every piece is made for
> people who refuse to settle.
>
> ✎ The house was founded in 1995 and is based in New York.
>
> **THE STANDARD IS SET**

House-codes captions: `THREE STARS — the house code` · `THE CAPSULE — the mark` ⧗ ·
`THE RED RULE — where you are` · `DROP 0NN — what it is and when it was`

### 2.6 Cart, checkout, account

| Slot | Copy |
|---|---|
| Drawer title | `BAG (2)` |
| Empty bag | Nothing selected yet. |
| Empty bag CTA | `VIEW DROP 004` |
| Remove | `Remove` |
| Undo | `Undo` |
| Shipping threshold | `$60 TO FREE SHIPPING` → `FREE SHIPPING` |
| Checkout | `CHECKOUT` |
| Steps | `CONTACT` · `SHIPPING` · `PAYMENT` |
| Place order | `PLACE ORDER` |
| Confirmation | Order `AX-004182` confirmed. |
| Account empty | No orders yet. |
| Order statuses | `PLACED` · `MADE` · `SHIPPED` · `DELIVERED` |

### 2.7 Errors, empty states, system

| Surface | Copy |
|---|---|
| 404 | **THIS PAGE IS NOT AN AXIOM** / It does not exist. |
| 500 | **THIS PAGE DID NOT LOAD** / The failure has been recorded. |
| Search zero | Nothing matches that. / `VIEW DROP 004` |
| Offline | No connection. |
| Form required | Required. |
| Invalid email | That address is not complete. |
| Payment declined | That card was declined. Try another. |
| Stock lost at checkout | That size went while you were deciding. |
| Session expired | Signed out. Sign in to continue. |

Every error states what happened and offers exactly one way forward. No apology.

### 2.8 Alt text (A2-authored, never generated)

| Image type | Pattern |
|---|---|
| Product front | Boxed Tee in black, front, flat |
| Product detail | Stitch detail at the shoulder seam |
| On-body | Boxed Tee worn, three-quarter view |
| Editorial | Two figures against a black seamless ground |
| Decorative | `alt=""` + `aria-hidden` |

---

## 3. Component specs

42 components, 6 tiers. Every component lists props · states · responsive · motion · a11y.

### 3.1 Tier 1 — Primitives (10)

| Component | Props | States | A11y contract |
|---|---|---|---|
| `Button` | `variant` primary/secondary/ghost · `size` sm/md/lg · `loading` · `asChild` | default, hover, focus, active, disabled, loading | `aria-busy` when loading; visible focus ring ≥3:1; label never icon-only |
| `Input` | `label` · `hint` · `error` · `type` | default, focus, filled, error, disabled | Label always present, never placeholder-as-label; `aria-describedby` → hint+error; `aria-invalid` |
| `Select` | `options[]` · `label` · `error` | as Input + open | Native semantics or Radix with full keyboard; `SOLD OUT` options `aria-disabled` |
| `Checkbox` | `label` · `error` | default, checked, indeterminate, focus, disabled | Label click-target; `aria-checked` |
| `RadioGroup` | `options[]` · `label` · `error` | as Checkbox | Arrow-key roving tabindex; group has `aria-labelledby` |
| `Rule` | `tone` light/strong/inverse · `orientation` | — | `role="separator"` with `aria-orientation` |
| `Badge` | `tone` default/solid/quiet/soldout | — | Decorative unless it carries the only signal, then `VisuallyHidden` text |
| `Skeleton` | `className` | animating | `aria-hidden`, never announced |
| `VisuallyHidden` | — | — | Clip pattern, focusable variant for skip-link |
| `FocusRing` | — | — | 2px `--ink` outline, 2px offset, inverts to `--pure` on ink grounds |

### 3.2 Tier 2 — Typography & layout (7)

`Display` (xl/l/m/s, tone) · `Statement` · `Body` (l/m/s, tone) · `Meta` (mono, tabular) ·
`Section` (ground paper/pure/ink, flush) · `Grid` (12/6/4) · `Bleed`

Rules: one `Display` per viewport · `Meta` never for prose · `Body` measure-capped at
68ch · `Section` owns vertical rhythm and is never overridden inline.

### 3.3 Tier 3 — Media (6)

| Component | Spec |
|---|---|
| `CinematicVideo` | Poster frame is the LCP element and is server-rendered. `IntersectionObserver`-gated play, muted, loop, `playsInline`. `prefers-reduced-motion` → poster only, no fetch of the video. `preload="none"` below the fold. |
| `ProductImage` | LQIP → AVIF/WebP/JPEG srcset at 480/768/1200/2000. Aspect-locked, zero CLS. `loading="lazy"` except the first grid row and the PDP hero. |
| `HoverSwapImage` | Crossfade 240ms `axiom-in-out`. **Never slide.** Touch devices show primary only. Preloads the alt on pointer-enter, not on mount. |
| `ZoomViewer` | Full-screen, focus-trapped, `Esc` closes, focus returns to origin. Pinch + drag. Arrow keys move between shots. |
| `VideoCard` | Still by default; plays on hover ≥1024px only. Reduced-motion → still. |
| `Lightbox` | Keyboard nav, counter in mono (`03 / 12`), shoppable hotspots link to PDP. |

### 3.4 Tier 4 — Motion (5)

| Component | Spec |
|---|---|
| `Reveal` | opacity 0→1, translateY 24→0, 400/600ms `axiom-out`. Fires once. Never re-triggers on scroll-up. |
| `StaggerGroup` | 60–80ms per child, total capped at 400ms. |
| `ParallaxLayer` | Factor clamped 0.85–1.15. **Never on text.** Disabled below 1024px. |
| `PinnedSection` | Desktop ≥1024px only. Disabled entirely under reduced-motion. |
| `ScrollProgress` | 2px `--red` hairline, viewport top, `role="progressbar"` with live `aria-valuenow`. One of the four permitted red uses. |

All animate `transform` and `opacity` only. `will-change` applied during animation only.

### 3.5 Tier 5 — Commerce (9)

| Component | Spec |
|---|---|
| `ProductCard` | **Price, availability and sold-out state are server-rendered** (guardrail 14). Hover: alt-image crossfade + red rule draws left→right 200ms. Sold-out: greyed, `SOLD OUT` badge, still linked. Swatch dots use `--garment-*`. |
| `ProductGrid` | 3-up ≥1280 / 2-up ≥768 / 2-up <768. `StaggerGroup` on first paint only. |
| `ProductRail` | Horizontal, snap points, drag on desktop, native scroll on touch. **Never scroll-hijacked.** Keyboard-reachable via arrow buttons. |
| `SizeSelector` | Buttons not a `<select>`. Unavailable sizes struck through, `aria-disabled`, tooltip `Gone`. Selection fills with `--ink`. |
| `ColorSwatches` | `--garment-*` tokens only. Selected gets a 1px offset ring. Colour name always shown in text — never colour as the only channel. |
| `PriceDisplay` | Mono, tabular numerals. Never "from". Never hidden. |
| `AddToCartButton` | idle `ADD` → loading `ADDING` (`aria-busy`) → success `ADDED` 1200ms → idle. `axiom-snap` easing, the only place it is used. |
| `CartDrawer` | 300ms slide, focus-trapped, `Esc` closes, focus returns to the trigger. New line flashes red left-rule 600ms. |
| `CartLineItem` | Quantity stepper, remove with 5s undo. Row is a live region on change. |

### 3.6 Tier 6 — Navigation & chrome (5)

| Component | Spec |
|---|---|
| `Header` | Transparent over hero → `--ink` past 80vh, 240ms. ⧗ Mark slot is a placeholder until vectors land. Bag count is server-rendered. Skip-link is the first focusable element. |
| `MobileMenu` | Full-screen `--ink` takeover, staggered link reveal 60ms, focus-trapped, `Esc` closes. |
| `Footer` | Four columns desktop, accordion mobile. Mono meta line ✎ `AXIOM · EST. 1995 · BASED IN NYC`. |
| `Breadcrumbs` | PDP and support only. `BreadcrumbList` schema. |
| `FilterBar` | Sticky under header desktop; `[ FILTER ]` drawer below 768. Active count in mono. Clearing is one action. |

---

## 4. Flows

**Browse → buy:** Home → line or drop → grid → PDP → size → `ADD` → drawer → `CHECKOUT`
→ contact → shipping → payment → confirmation. Six clicks from landing to paid.

**Sold-out recovery:** PDP → size struck → `NOTIFY ME` → email inline → confirm →
"We will tell you once."

**Drop release:** `/drops` countdown → 00:00:00 → drop page live → `SHOP DROP 004` → grid.

---

## 5. What Phase 2 could not complete

| Item | Blocked by |
|---|---|
| ⧗ House mark in `Header`, favicon, packaging, labels | `0.5` vector suite |
| ⧗ Mark diagram on `/manifesto` | `0.5` |
| Real product copy per SKU | `0.10` catalogue — patterns and formulas are specified, the 40-word bodies need real SKUs |
| Size charts | `0.10` |
| Legal copy (shipping, returns, privacy, terms) | Client-supplied |
| Checkout step detail | `7` commerce platform |

---

## 6. What recomputes when `0.4` lands

`--red` is provisional. Every use is token-driven, so the swap is one line in
`styles.css` — but these recompute and must be re-verified:

1. Contrast table (Phase 1 §2.2) — all four red rows
2. `--red-ink` derivation — currently `#C41E08` at 5.93:1 on white
3. `Button` primary — red fill with `--ink-pure` text, currently 5.63:1
4. `ScrollProgress` hairline visibility on both grounds
5. `ProductCard` hover rule
6. Red-budget audit — the ~5% ceiling is measured, not assumed

Nothing else in this document depends on the exact value.

---

## 7. Register after Phase 2

**Closed:** `0.3` EST. 1995 — **real**, appears once on the house mark, copy may
reference it. All ✎ lines in §2 are now live.

**Still blocking:** `0.4` brand red (contained — see §6) · `0.5` vector suite (blocks
mark, favicon, packaging) · `0.10` product catalogue (blocks per-SKU copy and size charts)
· `7` commerce platform (blocks checkout detail).

**Unchanged:** `0.2`, `0.7`, `0.9`, `0.11`–`0.23`, main register `1`–`25`, `F.1`–`F.9`.
