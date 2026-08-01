# Axiom — Phase 3: Component Build-Out Plan & Gap Analysis

Date: 2026-07-31
Status: **Plan approved. Execution NOT started — Lovable execution deliberately withheld.**
No code, design, asset or Lovable changes. No credits spent.
Owners: B2 Design System Architect, B3 Motion Designer, D1 Lovable Engineer

Builds on Phase 0 §6 (architecture), Phase 1 (art direction), Phase 2 (wireframes, copy
deck, 42 component specs).

---

## 1. Revised phase definition

The plan's §11 defined Phase 3 as *"Design system: tokens, Tailwind config, all 42
components spec'd, motion spec."*

**That definition is satisfied.** Tokens, Tailwind config and the motion primitives are
live in `berto931/axiom-foundation` at `7e4f86d`, and all 42 components were specified in
Phase 2 §3. Phase 3 as originally written was overtaken by events.

**Phase 3 is redefined as the component build-out**: implement the 23 unbuilt components
against the Phase 2 specs, add a typed product fixture to unblock the commerce tier, and
extend `/styleguide` to cover everything.

This is a redefinition, not a scope increase. The build-out was previously implicit in
Phase 4 ("Build core"); moving it into Phase 3 keeps Phase 4 focused on pages, which is
what it was always for.

---

## 2. Gap analysis

Inventory taken against `berto931/axiom-foundation` @ `7e4f86d`.

| Tier | Specced | Built | Remaining |
|---|---|---|---|
| 1 — Primitives | 10 | **9** | `FocusRing` |
| 2 — Typography & layout | 7 | **7** | — |
| 3 — Media | 6 | **0** | all 6 |
| 4 — Motion | 5 | **3** | `ParallaxLayer`, `PinnedSection` |
| 5 — Commerce | 9 | **0** | all 9 |
| 6 — Navigation & chrome | 5 | **0** | all 5 |
| **Total** | **42** | **19** | **23** |

### 2.1 Built and verified present

**Tier 1:** `Button`, `Input`, `Select`, `Checkbox`, `RadioGroup`, `Rule`, `Badge`,
`Skeleton`, `VisuallyHidden`
**Tier 2:** `Display`, `Statement`, `Body`, `Meta`, `Section`, `Grid`, `Bleed`
**Tier 4:** `Reveal`, `StaggerGroup`, `ScrollProgress`

**Four components exist that are not in the 42:** `Field`, `FieldLabel`, `FieldHint`,
`FieldError`. They are sound and used by the form primitives. Fold them into the Tier 1
count rather than removing them — the specced total becomes 46.

**`FocusRing` is not a component.** It is implemented as CSS (`:focus-visible` plus the
`on-ink` utility that inverts the ring on dark grounds). That is arguably the better
implementation — a focus ring is a global concern, not a wrapper. **Recommendation: close
it as satisfied by CSS and drop it from the component count** rather than build a
redundant wrapper. Specced total then becomes 45, built 19, remaining 22 + fixture.

### 2.2 Not built

| Tier | Components |
|---|---|
| 3 — Media | `CinematicVideo`, `ProductImage`, `HoverSwapImage`, `ZoomViewer`, `VideoCard`, `Lightbox` |
| 4 — Motion | `ParallaxLayer`, `PinnedSection` |
| 5 — Commerce | `ProductCard`, `ProductGrid`, `ProductRail`, `SizeSelector`, `ColorSwatches`, `PriceDisplay`, `AddToCartButton`, `CartDrawer`, `CartLineItem` |
| 6 — Nav & chrome | `Header`, `MobileMenu`, `Footer`, `Breadcrumbs`, `FilterBar` |

### 2.3 Other findings

**No data layer exists.** No Supabase, no fixtures, no typed product shapes. The commerce
tier cannot be built without one — see §3.1.

**Routes present:** `__root.tsx`, `index.tsx`, `styleguide.tsx`. No commerce routes, which
is correct; pages are Phase 4.

---

## 3. Deliverables

### 3.1 Product fixture module

`src/lib/fixtures/products.ts` — typed shapes for product, variant, size, colourway, drop
and cart line. Two lines, roughly six products, all four garment colours, deliberate
sold-out states so those paths are exercised rather than assumed.

**This is code, not content.** It unblocks the commerce tier without touching `0.10`. Real
catalogue data replaces the fixture in Phase 4 or 5 without changing a single component
signature, provided the fixture types are authored as the contract rather than as
convenience shapes.

### 3.2 Tier 5 — nine commerce components

Built to Phase 2 §3.5. The load-bearing constraint: **price, size availability, sold-out
state and bag count are server-rendered** (guardrail 14). `--garment-*` tokens appear only
in `ColorSwatches`, `ProductCard` swatch dots and the PDP colour selector.

### 3.3 Tier 6 — five navigation and chrome components

Built to Phase 2 §3.6. `Header` ships with a **placeholder mark slot** — the real mark
waits on `0.5`. Bag count is server-rendered. The skip-link is the first focusable element.

### 3.4 Tier 3 — six media components

Built to Phase 2 §3.3 against the poster/placeholder contract. `CinematicVideo`'s poster
frame is the LCP element and is server-rendered; real footage slots in later without
touching the component.

### 3.5 Tier 4 — two motion components

`ParallaxLayer` (factor clamped 0.85–1.15, never on text, disabled below 1024px) and
`PinnedSection` (desktop only, disabled entirely under reduced motion).

### 3.6 Styleguide extension

Every new component, every state, on both `--paper` and `--ink` grounds. The styleguide is
the verification surface for Phase 3 — if a state is not on it, it is not done.

---

## 4. Dependencies

### 4.1 Needs approval, not assets

**Lovable credits.** Phase 3 is the first phase that spends them. Estimated 12–18 scoped
messages, one concern per message, each reviewed with `get_diff` before the next.

**Execution is explicitly withheld pending a separate approval.** This document is the
plan only.

### 4.2 Deferred — none of these block the build

| Deferred | Item | Handling in Phase 3 |
|---|---|---|
| Vector logo suite | `0.5` | `Header` ships a placeholder mark slot; favicon untouched |
| Exact brand red | `0.4` | Provisional token; Phase 2 §6 lists the six recomputations |
| Per-SKU content | `0.10` | Fixtures carry structure; real copy slots in later |
| Size charts | `0.10` | `SizeSelector` is built; the size-guide drawer ships empty |
| Checkout detail | item `7` | `CartDrawer` ends at `CHECKOUT`; the route is Phase 5 |
| Product photography | `0.9` | `ProductImage` is built against the srcset contract; placeholders in the styleguide |

Every one of these is a content or asset slot, not a structural dependency. That is why
Phase 3 is executable now.

---

## 5. Verification plan

### 5.1 Per batch — automated

| Check | Command | Gate |
|---|---|---|
| Typecheck | `npx tsc --noEmit` | 0 errors |
| Lint | `npx eslint .` | 0 errors; `printWidth: 100` preserved |
| Build | `npm run build` | exit 0 |
| SSR emission | build output | `_ssr/*.mjs` present |

### 5.2 Assertions that matter more than the build passing

| # | Assertion | Method |
|---|---|---|
| V1 | **Server-render proof** — price, size availability, sold-out state and bag count appear in the *served* markup, not after hydration | Fetch `/styleguide` HTML, grep for the fixture values |
| V2 | **Red budget** — no `text-red` on light surfaces; red-bearing elements within the ~5% ceiling per viewport | grep rendered markup; count against Phase 1 §2.3 |
| V3 | **Reduced motion** — reveals, parallax and pinning all resolve to final state | assert the CSS block and `[data-axiom-reveal]` override |
| V4 | **Focus traps** — `CartDrawer`, `ZoomViewer`, `MobileMenu`, `Lightbox` trap focus, close on `Esc`, and return focus to the trigger | static review plus served-markup attributes |
| V5 | **Zero CLS** — `ProductImage` is aspect-locked | assert width/height or aspect-ratio on every instance |
| V6 | **Garment-token containment** — `--garment-*` appears only in the three permitted components | grep; any other use is a review blocker |
| V7 | **No client-only commerce** — no commerce primitive depends on hydration | V1 plus static review |

V1 and V6 are the two most likely to regress silently. Both are cheap greps and should run
on every batch, not just at the end.

### 5.3 Browser QA limitation — `F.8`

**There is no live browser QA available in this environment.** Chromium cannot use the
agent proxy: it returns `ERR_CONNECTION_RESET` on a control URL where `curl` returns 200.
Verification therefore leans on served-HTML inspection and build output.

Blocked until `F.8` is resolved:

- Visual regression
- Responsive screenshots across the device matrix
- Real accessibility-tree auditing
- Lighthouse and Core Web Vitals measurement
- Hover, focus and motion behaviour observed rather than asserted from source

**This matters beyond Phase 3.** Phase 4 (device matrix) and Phase 7 (a11y audit, CWV
tuning) both assume working browser QA. `F.8` should be resolved before either is
scheduled, not discovered during them.

---

## 6. Out of scope

No pages or routes beyond `/styleguide`. No checkout. No Supabase or real backend. No real
content, photography or video. No Higgsfield. No vector artwork. No favicon.

---

## 7. Effort

| | Human team | CC + gstack | Compression |
|---|---|---|---|
| Phase 3 build-out | ~1 week | ~3 hours | ~13x |

Plus 12–18 Lovable messages. The compression is lower than the boilerplate rate because
the commerce tier carries real correctness constraints — server-rendering, focus
management, reduced motion — that are not mechanical.

---

## 8. Register after Phase 3 planning

**Recommended closure:** `FocusRing` — satisfied by CSS, drop from the component count.
Specced total 45, built 19, remaining 22 plus the fixture.

**Unchanged and still blocking:** `0.4` brand red (contained) · `0.5` vector suite (mark,
favicon, packaging) · `0.10` catalogue (per-SKU copy, size charts) · item `7` commerce
platform (checkout).

**Elevated:** `F.8` browser QA — was an observation, is now a scheduling dependency for
Phases 4 and 7.

**Also open:** `0.9` photography · `0.21` garment colour sampling · `0.22` two-line
ceiling · `0.23` artwork revision ownership.

---

## 9. Recommendation

Approve execution when ready, and answer `0.4` and `0.5` in parallel. Neither blocks the
build, but landing them during Phase 3 means Phase 4 starts with a real mark and a locked
palette rather than a swap-and-reverify pass.

Resolve `F.8` before Phase 4 is scheduled.
