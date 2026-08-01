# Axiom — Phase 3: Build-Out Results

Date: 2026-07-31
Status: **Complete. All verification passed.**
Executed against `AXIOM_PHASE3_BUILD_PLAN.md`. Scope and deferrals unchanged.

Repository: `berto931/axiom-foundation` @ `62883a9`
Baseline at start of Phase 3: `97ead59`

---

## 1. What was built

**22 of 22 remaining components, plus the typed product fixture and the styleguide
extension.** The AXIOM component layer now holds 30 files.

| Batch | Commit | Tier | Components |
|---|---|---|---|
| 1 | `cf064dd` | Fixture + value primitives | `products.ts`, `PriceDisplay`, `ColorSwatches`, `SizeSelector` |
| 2 | `c6db528` | Product surfaces | `ProductCard`, `ProductGrid`, `ProductRail` |
| 3 | `78823e0` | Cart | `AddToCartButton`, `CartLineItem`, `CartDrawer` |
| 4 | `df7ed47` | Navigation & chrome | `Header`, `MobileMenu`, `Footer`, `Breadcrumbs`, `FilterBar` |
| 5 | `bbed3cb` | Media | `ProductImage`, `CinematicVideo`, `HoverSwapImage`, `ZoomViewer`, `VideoCard`, `Lightbox` |
| 6 | `71aa822` | Motion | `ParallaxLayer`, `PinnedSection` |
| 7 | `e0c4cfe` | Styleguide + semantic fix | `/styleguide` extension, `FieldLabel` correction |
| 8 | `62883a9` | Correction | Red-budget violation fixed |

**Net: 26 files changed, +2,777 / −11.**

---

## 2. Verification results

### 2.1 Automated gates — all passing

| Check | Result |
|---|---|
| `npx tsc --noEmit` | **0 errors** |
| `npx eslint .` | **0 errors**, 10 warnings (pre-existing `react-refresh` in shadcn template files) |
| `npm run build` | **exit 0**, 508ms |
| SSR chunk emission | 9 `_ssr/*.mjs` chunks |
| `/styleguide` | HTTP **200**, 210,651 bytes served |
| `/` | HTTP **200** |

### 2.2 The seven assertions

| # | Assertion | Result |
|---|---|---|
| **V1** | Server-render proof | **PASS** |
| **V2** | Red budget | **PASS** after one correction |
| **V3** | Reduced motion | **PASS** |
| **V4** | Focus traps | **PASS** |
| **V5** | Zero CLS | **PASS** |
| **V6** | Garment-token containment | **PASS** |
| **V7** | No client-only commerce primitives | **PASS** |

**V1 — server-render proof.** Every commerce value appears in the *served* markup, not
after hydration:

| Value | Occurrences in served HTML |
|---|---|
| `$180` | 5 |
| `$95` | 2 |
| `SOLD OUT` | 5 |
| `Training Hood` (the fully sold-out fixture) | 6 |
| `gone` (unavailable-size accessible names) | 11 |

The `gone` count matters most: screen-reader parity for unavailable sizes survives even
if hydration never runs.

`FREE SHIPPING` is absent from the initial markup, which is correct rather than a failure.
`CartDrawer` is a Radix dialog and renders content only when open; the styleguide has it
closed by default. The threshold is computed from props at `cart-drawer.tsx:43`, not
fetched, so it is server-derived whenever it renders.

**V3 — reduced motion.** Five `usePrefersReducedMotion` call sites in `motion.tsx`, a
`@media (prefers-reduced-motion: reduce)` block at `styles.css:280`, and a desktop-only
block gated on `no-preference` at `:335` so pinning never engages under reduced motion.

**V4 — focus traps.** `CartDrawer`, `ZoomViewer`, `Lightbox` and `MobileMenu` are all
built on `@radix-ui/react-dialog`. None hand-rolled, so trapping, Esc-to-close and
focus restoration are inherited rather than reimplemented.

**V5 — zero CLS.** `aspect-[4/5]` locked in `ProductCard` and `CartLineItem`. Placeholder
and loaded states occupy identical space.

**V6 — garment-token containment.** `--garment-*` appears in `color-swatches.tsx` and
`product-card.tsx` only. Both permitted.

**V7 — no client-only commerce.** `ProductCard`, `ProductGrid`, `PriceDisplay`,
`SizeSelector` and `CartDrawer` contain no `useState` or `useEffect` — pure props.
`CartLineItem` has both, used solely for the 5-second undo timer, which is UI state
rather than a commerce value.

### 2.3 The one violation found

Verification caught three uses of `hover:text-red` — two in `header.tsx`, one in
`mobile-menu.tsx`.

Contrast was never the problem: all three sit on `--ink` grounds with `--paper` text,
where red reads at 5.63:1 and passes AA. The problem was **budget**. Red is reserved for
exactly four things — logo mark, active/selected state, scroll-progress hairline, single
primary CTA. A hover state is none of them.

Before assuming a pattern, every other red class was audited. All eight remaining uses map
to a permitted one:

| Use | Permitted as |
|---|---|
| `Button` primary fill | primary CTA |
| `ProductCard` hover rule | authorised in the batch 2 spec |
| `CartDrawer` line flash | authorised in the batch 3 spec |
| `RadioGroup` checked border | active/selected state |
| `ScrollProgress` hairline | permitted use |
| 2 styleguide swatches | token documentation |

One narrow drift, not a systemic failure. Corrected in `62883a9` — three lines,
`hover:text-red` → `hover:text-pure`, nothing else touched. Post-correction: **zero bare
`text-red` anywhere in the codebase.**

---

## 3. Scope and deferrals — unchanged

### 3.1 Scope held

| Constraint | Result |
|---|---|
| No routes beyond `/` and `/styleguide` | **held** — `src/routes/` still contains only `__root`, `index`, `styleguide` |
| No links to nonexistent routes | **held** — nav items are non-navigating buttons, zero `<Link>` usage in chrome |
| No invented logo or favicon | **held** — `MarkSlot` placeholder with a comment pointing at the pending vectors |
| No Supabase, auth, analytics, payments | **held** |
| No new libraries | **held** — Radix primitives already present were reused |
| No token changes | **held** — only the four `--garment-*` tokens the plan specified, plus keyframes |

### 3.2 Deferrals intact

| Deferred | Item | State at end of Phase 3 |
|---|---|---|
| Vector logo suite | `0.5` | `Header` renders `MarkSlot`, a bordered square with `A` and a replacement comment |
| Exact brand red | `0.4` | Provisional token unchanged; the six recomputations in Phase 2 §6 still pending |
| Per-SKU content | `0.10` | Fixture carries structure; six products with house-formula descriptions |
| Size charts | `0.10` | `SizeSelector` built, `onSizeGuideClick` fires, guide content empty |
| Checkout detail | item `7` | `CartDrawer` ends at a `CHECKOUT` button with no handler |
| Product photography | `0.9` | `ProductImage` handles empty `src` with a `--grey-05` placeholder and hidden alt text |

Every deferral is a content or asset slot. None required a structural workaround.

---

## 4. The semantic fix, folded in free

`ColorSwatches` rendered its group label through `FieldLabel`, producing a `<label>` with
an `id` and no `htmlFor` — a label with nothing to label. Replaced with a styled `<span>`
keeping the `id`, so the existing `aria-labelledby` still resolves. `SizeSelector` carried
the same pattern and got the same fix.

Delivered inside batch 7 at no additional message cost, as scoped.

---

## 5. Credits

**8 Lovable messages.** Seven batches plus one correction, against the 12–18 documented
in the build plan.

`set_project_knowledge` was used once to install the design-system contract as standing
configuration. It is configuration rather than an agent turn and consumed no credits. It
is very likely why only one corrective message was needed across 22 components.

No Higgsfield usage. No assets generated.

---

## 6. Browser QA limitation — `F.8`, unchanged

**There is still no live browser QA in this environment.** Chromium cannot use the agent
proxy: `ERR_CONNECTION_RESET` on a control URL where `curl` returns 200.

Everything in §2 was verified through served-HTML inspection, static source analysis and
build output. That is sufficient for the seven assertions, all of which are structural.

Still unavailable and unverified:

- Visual regression — no screenshot comparison
- Responsive behaviour across a real device matrix
- Hover, focus-ring and motion behaviour **observed** rather than asserted from source
- Accessibility-tree auditing with a real assistive-technology stack
- Lighthouse and Core Web Vitals measurement

**This remains a scheduling dependency for Phases 4 and 7**, both of which assume working
browser QA. Phase 3 survived without it because its assertions are structural; Phase 4's
device matrix and Phase 7's a11y audit and CWV tuning cannot.

---

## 7. Register after Phase 3

**Recommended closure:** `FocusRing` — satisfied by CSS, as proposed in the build plan.
Adjusted count: 45 specced, 45 built.

**Still blocking:**

| # | Item | Effect |
|---|---|---|
| `0.4` | Authoritative brand red | Six recomputations, Phase 2 §6 |
| `0.5` | Vector logo suite | `MarkSlot` placeholder, favicon absent |
| `0.10` | Product catalogue | Fixture stands in; per-SKU copy and size charts pending |
| `7` | Commerce platform | Checkout route and handler |
| `F.8` | Browser QA | **Blocks Phase 4 and Phase 7 scheduling** |

**Also open:** `0.9` photography · `0.21` garment colour sampling · `0.22` two-line
ceiling · `0.23` artwork revision ownership.

---

## 8. What Phase 4 inherits

A complete, verified component layer of 45 components with a typed data contract that real
catalogue data can satisfy without changing a single component signature. Every commerce
primitive server-renders. Every modal traps focus properly. Reduced motion is honoured
throughout.

Phase 4 builds pages on top of it. It needs `0.4` and `0.5` to start without a
swap-and-reverify pass, `0.10` for real content, and `F.8` resolved before its device
matrix can be verified at all.
