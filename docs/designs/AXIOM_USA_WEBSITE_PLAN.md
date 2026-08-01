# Axiom USA — Website Plan (Lovable Build)

Status: **Phases 0–1 approved and delivered as written work. Phases 2+ not started.**
Nothing built. No assets generated or modified. No Higgsfield or Lovable credits spent.
Date: 2026-07-31

**Companion documents:**
- Phase 0 — [`AXIOM_PHASE0_BRAND_FOUNDATION.md`](./AXIOM_PHASE0_BRAND_FOUNDATION.md)
- Phase 1 — [`AXIOM_PHASE1_ART_DIRECTION.md`](./AXIOM_PHASE1_ART_DIRECTION.md)
Target platform: Lovable (React + TypeScript + Tailwind + shadcn/ui), Supabase backend where needed.

---

## 0. Brand foundation (as given)

> "An axiom is a truth that does not require validation."

Axiom is more than apparel. It represents confidence, ambition, and the pursuit of
greatness. Every collection is intentional, every release is limited, and every piece
represents those who refuse to settle.

**Positioning read.** This is not "luxury heritage" (Burberry) and not "American prep
legacy" (Polo). It is *earned certainty* — a modern, disciplined, athletic-editorial
voice. Closer in feel to a racing team's technical brand crossed with a limited-run
studio label. The three stars, the enclosed capsule mark, and the flat red on stark
white in the source logo all point the same direction: **motorsport / institutional
signage**, not heritage crest.

**Source material observed in supplied assets**
| Asset | Read |
|---|---|
| Primary mark | Black rule box, 3 red stars, capsule-enclosed "A" monogram, heavy red AXIOM wordmark. Institutional / racing badge. |
| White oversized tee | Collegiate arch "AXIOM" in red with black outline, running horse, script "Worldwide", "EST. 1995". |
| Black bucket hat | Globe icon, blackletter "Axiom Studios" over white script "1995", "THE STANDARD IS SET / BASED IN NYC". |
| Black polo + shorts set | Small-format badge lockup, chest-left and hem-right placement. Uniform logic. |

**Tension to resolve before design lock:** the assets carry three different sub-identities
(racing badge / collegiate-equestrian / streetwear-blackletter). A luxury site cannot
present all three as peers. See `Needs confirmation` §12.

---

## 1. Agent team — exact count and composition

**14 specialized agents, organized in 5 pods, plus 1 orchestrator = 15 total.**

The user named 12 domains. Two of those (product presentation, responsive development)
each split into two distinct agents because they have non-overlapping deliverables and
non-overlapping failure modes. Everything else maps 1:1.

### Pod A — Brand & Narrative (3 agents)

| # | Agent | Owns | Primary deliverables |
|---|---|---|---|
| A1 | **Brand Strategist** | Positioning, brand architecture, competitive whitespace vs Polo/Burberry, sub-identity resolution | Brand brief, voice charter, do/don't list, competitive teardown |
| A2 | **Editorial Copywriter** | All site copy, collection names, product story, manifesto, microcopy, error/empty states | Copy deck per page, 3 headline variants per hero, CTA library |
| A3 | **Art Director / Creative Direction** | Visual system authority, final say on layout tension, photography direction, video look | Mood board, art direction bible, shot list, per-page look approvals |

### Pod B — Design System & Interface (3 agents)

| # | Agent | Owns | Primary deliverables |
|---|---|---|---|
| B1 | **Luxury Fashion UI/UX Designer** | Sitemap, wireframes, page-level UX, shopping flow, navigation model | Sitemap, lo-fi → hi-fi frames, flow diagrams |
| B2 | **Design System Architect** | Tokens, type scale, spacing, grid, component inventory, shadcn overrides | `tokens.ts`, Tailwind config, component spec sheet |
| B3 | **Motion & Interaction Designer** | Scroll storytelling, microinteractions, transition choreography, easing library | Motion spec (per component: trigger, duration, easing, distance), prototype refs |

### Pod C — Media Production (3 agents)

| # | Agent | Owns | Primary deliverables |
|---|---|---|---|
| C1 | **Higgsfield Video Producer** | All cinematic video: prompts, model selection, iteration, upscale, reframe | Shot list → prompt sheet → rendered masters + web derivatives |
| C2 | **Product Imagery Specialist** | Product presentation: cutouts, ghost-mannequin consistency, color/shadow normalization, hover-state pairs | Normalized PDP image sets, zoom-tier assets, alt-view sequences |
| C3 | **Asset Pipeline Engineer** | Encoding, poster frames, AVIF/WebP ladders, CDN paths, naming convention, LQIP placeholders | `assets/MANIFEST.json`, encode scripts, naming spec |

### Pod D — Engineering (3 agents)

| # | Agent | Owns | Primary deliverables |
|---|---|---|---|
| D1 | **Lovable Implementation Engineer** | Prompt-driven build in Lovable, component construction, state, routing | Working app, per-phase Lovable prompt scripts |
| D2 | **Responsive & Cross-Device Engineer** | Breakpoint behavior, touch targets, safe areas, mobile video fallbacks, landscape | Breakpoint matrix, device test grid results |
| D3 | **Performance Engineer** | Core Web Vitals, video weight budget, code splitting, font loading, animation cost | Performance budget doc, Lighthouse/CWV report per phase |

### Pod E — Quality & Discovery (2 agents)

| # | Agent | Owns | Primary deliverables |
|---|---|---|---|
| E1 | **Accessibility Engineer** | WCAG 2.2 AA, keyboard paths, focus management, `prefers-reduced-motion`, video captions, contrast against red | A11y audit per phase, reduced-motion spec, remediation list |
| E2 | **SEO & Structured Data Engineer** | Technical SEO, metadata, `Product`/`Organization`/`BreadcrumbList` schema, AI-search readiness, sitemap/robots | SEO spec, schema payloads, indexation plan |

### Orchestrator (1)

| # | Agent | Owns |
|---|---|---|
| O | **Program Lead** | Phase gating, dependency ordering, credit budget enforcement, cross-pod conflict resolution, approval checkpoints |

**QA is deliberately distributed, not a single agent.** D2 (device QA), D3 (performance QA),
E1 (a11y QA), E2 (SEO QA) each own their own verification. A single "QA agent" would
be a bottleneck that catches only surface bugs. A dedicated **QA sweep** is instead run as
a *phase gate* (see §10) executed by E1+E2+D2+D3 together against a shared checklist.

---

## 2. Required skills, per agent

Mapped to skills actually available in this environment. `—` means no matching skill
exists and the agent works from the brief plus web research.

| Agent | Skills / tools |
|---|---|
| A1 Brand Strategist | `competitor-profiling`, `competitors`, `customer-research`, `marketing-psychology`, `product-marketing`, `marketing-plan` |
| A2 Copywriter | `copywriting`, `copy-editing`, `offers`, `content-strategy`, `marketing-psychology` |
| A3 Art Director | `canvas-design`, `theme-factory`, `image`, `dataviz` (for any spec sheets) |
| B1 UI/UX Designer | `site-architecture`, `cro`, `signup`, `onboarding`, `popups` |
| B2 Design System Architect | `theme-factory`, `web-artifacts-builder`, `artifact-design` |
| B3 Motion Designer | `web-artifacts-builder`, `video` (for reference study) |
| C1 Higgsfield Producer | **`mcp__higgs__*`** — `models_explore`, `generate_video`, `generate_image`, `motion_control`, `upscale_video`, `reframe`, `job_display`, `show_generations`, `balance`; plus `video` skill |
| C2 Product Imagery | `image`, `mcp__higgs__generate_image`, `mcp__higgs__remove_background`, `mcp__higgs__upscale_image`, `mcp__higgs__outpaint_image` |
| C3 Asset Pipeline | `—` (Bash/ffmpeg + `mcp__Lovable__get_file_upload_url`) |
| D1 Lovable Engineer | **`mcp__Lovable__*`** — `create_project`, `send_message`, `get_diff`, `read_file`, `list_files`, `set_project_knowledge`, `deploy_project`, `render_project_widget`; `mcp__Supabase__*` if commerce data is needed |
| D2 Responsive Engineer | `—` (Lovable preview + `/browse` for device-matrix screenshots) |
| D3 Performance Engineer | `—` (`/benchmark`, Lighthouse via `/browse`) |
| E1 Accessibility Engineer | `—` (`/qa-only`, `/design-review`, `/browse` snapshot for a11y tree) |
| E2 SEO Engineer | `seo-audit`, `ai-seo`, `schema`, `site-architecture`, `programmatic-seo` (for collection/size pages if warranted) |
| O Program Lead | `/autoplan`, `/plan-ceo-review`, `/plan-design-review`, `/plan-eng-review`, `/ship` |

**Skills we may need to author** (none exist today, all optional):
1. `axiom-brand-voice` — a project skill encoding the voice charter so every agent writes in-brand without re-reading the bible.
2. `higgsfield-shot-prompt` — a repeatable prompt template for the Axiom look, so C1's 40+ renders stay visually consistent.
3. `lovable-axiom-components` — a Lovable **workspace skill** (via `mcp__Lovable__create_workspace_skill`) so the Lovable agent applies the design tokens automatically on every message instead of being re-told.

---

## 3. Creative direction

### 3.1 The idea

**"The standard is set."** The site behaves like a proof, not a pitch. Assertions land
flat and unhedged. No exclamation marks, no "shop now," no urgency theater. Space and
silence carry the luxury; red carries the conviction.

### 3.2 Competing with Polo, Burberry, and Louis Vuitton without copying

| | Polo Ralph Lauren | Burberry | Louis Vuitton | **Axiom** |
|---|---|---|---|---|
| Core claim | Inherited American aspiration | British heritage, re-authored | Status made legible at a glance | Certainty that needs no proof |
| House code | Crest, pony, tartan-adjacent prep | Check, trench, equestrian knight | Monogram, Damier, trunk hardware | 3 stars, capsule frame, red rule, numbered drop |
| Type voice | Serif nostalgia, engraved | Reformed grotesque, high-fashion neutral | Wide luxury grotesque, monogram-as-type | Condensed institutional grotesque + mono meta |
| Imagery | Estate lifestyle, golden light, family | Cinematic Britain, weather, moodboard warmth | Spectacle, celebrity, scale, saturated color | Hard studio light, black/white seamless, no warmth |
| Color logic | Navy/cream/multi, seasonal | Beige-check + shifting seasonal palette | Brown/gold monogram + loud seasonal color | Black/white with red under a 5% ceiling |
| Availability | Deep, permanent catalog | Broad seasonal catalog | Broad, with engineered waitlists | Genuinely limited, numbered, gone |
| Web behavior | Merchandised grid, catalog-first | Editorial carousels, heavy campaign media | Oversized media, motion spectacle, logo density | Restraint; silence and space as the luxury signal |
| Emotional register | Belonging | Refinement | Arrival | Conviction |

**Where the whitespace actually is.** All three competitors are *logo-dense* — LV most of
all, where the monogram repeating across a surface is the entire product proposition.
Axiom's mark is strong enough to work the opposite way: used once, small, and never
repeated. Restraint is the position no one in that set occupies.

The second gap is **temporal**. Polo and LV are permanent; you can buy the thing next
year. Burberry is seasonal. Axiom is *episodic* — a drop is an event with a beginning and
an end, and the archive is a record, not a shop. The site architecture in §4 treats
`/drops` as a first-class narrative surface for exactly this reason.

**Anti-copy guardrails (A1 enforces at every review):**
1. No repeating-pattern monogram treatment. Ever. That is LV's territory and reads as
   imitation instantly.
2. No crest, shield, laurel, or knight. That is Polo and Burberry.
3. No check, plaid, or tartan.
4. No serif display face. All three lean historical; our position is institutional-modern.
5. No warm/golden campaign grade, no estate or countryside settings.
6. No celebrity-led campaign structure.
7. No "Shop Now" microcopy anywhere.
8. No algorithmic recommendation surfaces in v1 — curation only.
9. No native app. Mobile web is the complete experience.
10. No gendered top-level navigation split.
11. No seasonal framing. Drops are numbered and dated.
12. No price concealment — price visible on every card, never "on request."
13. No client-side-only commerce primitives. Price, size availability, sold-out state,
    and bag count are server-rendered.
14. No region selector until more than one region ships.

A full teardown of the live LV USA site — navigation, category merchandising, seasonal
storytelling, product presentation, Maison content, services and client advisors, account
and wishlist and bag, accessibility, region selector, app promotion, and mobile — is in
[`AXIOM_PHASE0_BRAND_FOUNDATION.md`](./AXIOM_PHASE0_BRAND_FOUNDATION.md) §3.3, with 17
derived Axiom recommendations and a three-tier evidence model separating fetch-verified
findings from browser-verified and still-unverified ones. Guardrails 7–14 come from that
pass.

### 3.3 Visual system

**Color — primarily black and white, controlled red.**

| Token | Value (proposed) | Use |
|---|---|---|
| `--ink` | `#0A0A0A` | Primary text, black surfaces |
| `--paper` | `#FAFAFA` | Primary light surface |
| `--pure` | `#FFFFFF` | Product-shot backgrounds, cards |
| `--red` | `#FF2D0D` *(sampled from supplied logo; `Needs confirmation` on exact hex)* | Accent only |
| `--red-ink` | `#C41E08` | Red-on-white text where AA contrast requires it |
| `--grey-10 … --grey-90` | neutral ramp | Rules, borders, disabled |

**Red discipline — a hard rule the whole team enforces:**
1. Red never exceeds ~5% of any viewport.
2. Red is used for exactly four things: the logo mark, the active/selected state, the
   scroll-progress indicator, and the single primary CTA per view.
3. Red is never used for body text at small sizes (contrast — see §8).
4. Two red elements never appear in the same viewport unless one is the logo.

**Typography.** A three-voice system mirroring the source assets:

| Role | Character | Candidates |
|---|---|---|
| Display / statements | Tight, condensed grotesque, heavy weight, uppercase, near-zero tracking | Neue Haas Grotesk Display, Söhne Breit, Monument Extended, Archivo Expanded |
| Body / UI | Neutral grotesque, high legibility, generous line-height | Söhne, Inter Tight, Suisse Int'l |
| Utility / meta | Mono for drop numbers, sizes, SKUs, timestamps — reinforces the "institutional" read | Söhne Mono, JetBrains Mono |

Type scale: 1.25 minor-third on mobile, 1.333 perfect-fourth desktop. Display sizes clamp
with `clamp()` so the hero statement fills the measure at every width.
*(Licensing is `Needs confirmation` — §12.)*

**Layout.** 12-column desktop / 6-column tablet / 4-column mobile. Baseline grid of 8px.
Deliberate asymmetry: full-bleed media against a hard-stopped 6-col text block. Generous
top/bottom rhythm (128–192px desktop section padding). Thin 1px rules as structural
punctuation, borrowed from the logo's box frame.

**Photography & video look.** Studio seamless, hard key with a controlled falloff,
either pure white or pure black ground. No environmental warmth. Motion is slow and
weighted — dolly, not handheld. Grain is minimal. If anything moves fast, it is a single
cut, not a shake.

---

## 4. Sitemap

```
/                          Home — cinematic entry, manifesto, featured drop, collection grid
/collections               Index of all collections
  /collections/:slug       Collection page — editorial + product grid
/products/:slug            PDP — product detail
/drops                     Drop archive / release calendar
  /drops/:slug             Individual drop story page
/manifesto                 Brand story — "an axiom is a truth that does not require validation"
/lookbook                  Editorial gallery (video + stills, scroll-driven)
/cart                      Cart (drawer primary; route as fallback/deep link)
/checkout                  Checkout  [Needs confirmation — platform, §12]
/account                   Account: orders, addresses, saved  [gated]
  /account/orders
  /account/orders/:id
/search                    Search results
/stockists                 Where to find Axiom  [only if retail/wholesale exists]
/support                   Support hub
  /support/shipping
  /support/returns
  /support/sizing          Size guide + fit notes
  /support/care            Garment care
  /support/faq
  /support/contact
/legal/terms
/legal/privacy
/legal/accessibility       Accessibility statement (also an SEO/compliance asset)
404, 500                   Branded error states
```

**Navigation model.** Persistent minimal header: `AXIOM` mark left, `SHOP / DROPS /
MANIFESTO` center, `SEARCH / ACCOUNT / CART(n)` right. Header is transparent over hero
media, then solidifies to `--ink` on scroll past 80vh. Full-screen overlay menu on
mobile, with a black takeover and staggered link reveal.

---

## 5. Page-by-page UX

### 5.1 Home

| # | Section | Behavior |
|---|---|---|
| 1 | **Cinematic hero** | Full-viewport Higgsfield video, muted autoplay, loop, poster-frame LCP. Wordmark and a single statement fade in at 400ms. Scroll cue at bottom. Reduced-motion → static poster. |
| 2 | **Axiom statement** | Black section. The manifesto line set at display scale, revealed line-by-line on scroll. Nothing else in the viewport. |
| 3 | **Featured drop** | Split layout: locked video panel left, product cards revealing right as you scroll (pinned-column pattern). Drop number in mono. |
| 4 | **Collection grid** | 2-up desktop / 1-up mobile. Each tile is a video-on-hover card with a red rule that draws in on hover. |
| 5 | **Editorial break** | Full-bleed image, single overlay line, parallax at ~0.85 factor. |
| 6 | **Product rail** | Horizontal scroll of key pieces, snap points, drag on desktop, native scroll on touch. |
| 7 | **Sign-up** | "Access to every release." Single email field, red submit. No modal on first visit — earn it. |
| 8 | **Footer** | Tall, structured, mono meta line: `AXIOM · EST. [year] · NYC`. |

### 5.2 Collection page

Editorial header (video or still + collection name + short thesis) → sticky filter/sort
bar (categories, size, price, sort; filters as a left drawer on mobile) → responsive
product grid (3-up desktop / 2-up mobile) → collection close-out editorial → cross-link
to the next collection. Grid items: primary image, alt image on hover (crossfade, not
slide), name, price, size availability dots. Sold-out pieces stay visible, greyed, marked
`SOLD OUT` in mono — scarcity is the story.

### 5.3 PDP (Product Detail)

The single most important page. Layout:

- **Left (60%):** vertical gallery — sticky scroll through 4–6 shots plus one product
  motion clip. Click opens a full-screen zoom viewer with pinch/drag.
- **Right (40%):** sticky panel — name, drop number in mono, price, color swatches, size
  selector (with a `Size guide` link that opens a drawer, never a new page), the add-to-cart
  button (black default, red on hover/focus), and accordion sections: Details, Fabric &
  Care, Shipping & Returns.
- **Below:** "The piece" editorial block (one image + 40 words), then a complete-the-look
  rail, then a recently-viewed rail.
- **Add to cart** opens the cart drawer with a 300ms slide; the added line item flashes a
  red left-rule for 600ms then settles. No page navigation, no toast pileup.
- **Out of stock:** size button disabled with a strikethrough + `Notify me` inline capture.

### 5.4 Drops

`/drops` is a chronological archive — a vertical timeline with year markers in mono, each
entry a card with the drop film's poster frame. Upcoming drops show a countdown (server
time, not client). `/drops/:slug` is a long-form scroll story: film → thesis → the pieces
→ shot gallery → shop the drop CTA.

### 5.5 Manifesto

The brand line held alone for a full viewport, then the three-paragraph story revealed
across three black/white alternating panels, then the house codes (3 stars / capsule /
red rule) presented as annotated diagrams. Ends with a single link to the current drop.

### 5.6 Lookbook

Masonry-free, strictly gridded editorial gallery. Mixed stills and short loops. Click
opens a full-screen lightbox with keyboard nav and a shoppable hotspot overlay linking to
the PDP.

### 5.7 Cart / Checkout

Cart drawer: line items with thumbnails, quantity steppers, remove with undo, subtotal,
shipping-threshold indicator, single black `CHECKOUT` button. Empty state is branded, not
apologetic. Checkout is a single-column, three-step flow (contact → shipping → payment)
with a persistent order summary. *Platform is `Needs confirmation` — §12.*

### 5.8 Account, Search, Support, Errors

Account: order list with status chips, order detail with tracking, saved addresses, size
profile. Search: overlay-first with instant results, recent searches, and zero-result
recovery (suggest current drop). Support: two-column doc layout, sticky sub-nav, search
across articles. 404: full-bleed black, the wordmark, `This page is not an axiom.` and
one link home.

---

## 6. Component system

Built on shadcn/ui primitives, restyled to the token set. **~42 components in 6 tiers.**

**Tier 1 — Primitives (10)**
`Button` (variants: primary/secondary/ghost/destructive; sizes sm/md/lg), `Input`,
`Select`, `Checkbox`, `RadioGroup`, `Rule` (the 1px structural line), `Badge`,
`Skeleton`, `VisuallyHidden`, `FocusRing`.

**Tier 2 — Typography & Layout (7)**
`Display`, `Statement`, `Body`, `Meta` (mono), `Section` (owns vertical rhythm),
`Grid`, `Bleed` (full-width escape hatch).

**Tier 3 — Media (6)**
`CinematicVideo` (poster + lazy + reduced-motion + intersection-gated play),
`ProductImage` (LQIP + AVIF/WebP srcset + aspect-lock), `HoverSwapImage`,
`ZoomViewer`, `VideoCard`, `Lightbox`.

**Tier 4 — Motion (5)**
`Reveal` (fade+rise on enter), `StaggerGroup`, `ParallaxLayer`, `PinnedSection`,
`ScrollProgress` (the red hairline at viewport top).

**Tier 5 — Commerce (9)**
`ProductCard`, `ProductGrid`, `ProductRail`, `SizeSelector`, `ColorSwatches`,
`PriceDisplay`, `AddToCartButton` (idle/loading/added states), `CartDrawer`,
`CartLineItem`.

**Tier 6 — Navigation & Chrome (5)**
`Header` (transparent→solid), `MobileMenu`, `Footer`, `Breadcrumbs`, `FilterBar`.

Each component gets a spec entry: props, variants, states (default/hover/focus/active/
disabled/loading/error), responsive behavior, motion behavior, and a11y contract.

---

## 7. Animation strategy

**Principle: motion confirms, it never entertains.** Every animation answers "did that
work?" or "what is important here?" Nothing loops for decoration except hero video.

**Easing library**
| Name | Curve | Use |
|---|---|---|
| `axiom-out` | `cubic-bezier(0.16, 1, 0.3, 1)` | Entrances, reveals |
| `axiom-in-out` | `cubic-bezier(0.65, 0, 0.35, 1)` | Transitions between states |
| `axiom-snap` | `cubic-bezier(0.34, 1.4, 0.64, 1)` | Micro-confirmations only (add-to-cart) |

**Duration ladder:** 120ms (hover/focus) · 240ms (state change) · 400ms (element reveal)
· 600ms (section reveal) · 800ms (page transition). Nothing exceeds 800ms.

**Scroll storytelling techniques, and where each is allowed**
| Technique | Where | Constraint |
|---|---|---|
| Fade + 24px rise on enter | Everywhere | Once only; no re-trigger on scroll-up |
| Staggered children (60ms delta) | Grids, nav, footer columns | Cap total stagger at 400ms |
| Pinned column | Home featured drop, drop story | Desktop only; disabled below 1024px |
| Parallax | Editorial breaks only | Max 0.85–1.15 factor. Never on text. |
| Horizontal scroll section | Product rails | Native scroll on touch, never scroll-hijacked |
| Scroll-linked video scrub | Drop story hero (optional) | Only if the file is under budget; otherwise cut |
| Line-by-line text reveal | Manifesto, statement sections | Clip-path reveal, never letter-by-letter |

**Hard bans:** scroll-jacking full pages, cursor-follow blobs, letter-by-letter typing,
loading-screen counters, magnetic buttons, custom scrollbar-driven page pagination.

**Microinteractions (the details that read as expensive):** rule-draw on card hover
(200ms, left→right), size button fill on select, cart count roll-up, red hairline scroll
progress, header logo scale from 1.0→0.85 on scroll, input underline draw on focus,
image crossfade (never slide) on hover, disabled-size strikethrough draw.

**Implementation.** Framer Motion for component-level orchestration; CSS
`@keyframes` + `IntersectionObserver` for anything cheap enough not to need JS. GSAP
ScrollTrigger only for the pinned sections **if** Framer's `useScroll` proves insufficient
— that is a decision D1+B3 make at Phase 4, not now. All transforms restricted to
`transform` and `opacity`; `will-change` applied only during active animation.

**`prefers-reduced-motion: reduce` contract (E1 owns, non-negotiable):** all reveals
become instant, parallax factor → 1.0, pinning disabled, hero video swaps to poster
frame, scroll-linked scrub disabled, microinteractions reduce to a 0ms color change.
The site must be fully usable and still look intentional with motion off.

---

## 8. Higgsfield production plan

Owner: **C1**, art-directed by **A3**.

### 8.1 Method

1. `mcp__higgs__balance` and `show_plans_and_credits` first — establish the credit
   ceiling before any generation.
2. `mcp__higgs__models_explore(action:'recommend')` with the Axiom look brief to pick the
   right video model per shot type rather than assuming one.
3. **Establish a style anchor.** Generate a small set of stills first
   (`generate_image`) until one nails the look. That still becomes the image-to-video
   reference for every subsequent shot. This is the single biggest lever on consistency
   and cost.
4. Generate video at draft quality → A3 review → iterate only the shots that fail →
   `upscale_video` only the approved masters.
5. `reframe` produces the 9:16 and 1:1 derivatives for mobile hero and social, rather
   than re-generating.
6. `motion_control` for any shot needing a specific camera move rather than prompt-luck.
7. Everything logged in a shot sheet: shot ID, prompt, model, seed/job ID, verdict.

### 8.2 Shot list (14 hero shots + derivatives)

| ID | Shot | Duration | Placement | Notes |
|---|---|---|---|---|
| H-01 | Brand hero — fabric in motion, hard light, black ground | 8–12s loop | Home hero | Seamless loop point is mandatory |
| H-02 | Alternate hero — figure, slow dolly, white seamless | 8–12s loop | Home hero A/B | |
| D-01 | Drop film — full cinematic piece | 30–45s | `/drops/:slug` hero | Highest-value asset |
| D-02..04 | Drop film cutdowns | 6–10s | Collection cards, rails | Derived from D-01 where possible |
| C-01..03 | Collection mood loops (one per collection) | 6–8s | Collection headers, hover cards | |
| P-01..04 | Product motion — garment detail, texture, drape | 4–6s | PDP gallery slot 5 | Must match the still-photo lighting exactly |
| M-01 | Manifesto ambient — abstract, minimal, near-still | 10s | `/manifesto` | Almost a moving photograph |
| L-01 | Lookbook loop set | 4s ×4 | `/lookbook` grid | |

### 8.3 Prompt discipline

Every prompt carries the same locked block (drafted by A3, reused verbatim):
subject → wardrobe → lighting (`hard key, single source, controlled falloff, no fill`) →
ground (`pure black seamless` / `pure white seamless`) → camera (`slow dolly in, 35mm,
shallow`) → grade (`high contrast monochrome, single red accent`) → negatives
(`no text, no logos, no warm tint, no handheld shake, no lens flare`).

**Note on generated apparel:** Higgsfield output must not be presented as the literal
product on a PDP — generated garments will not match the real product. Generated video is
used for **mood, texture, and atmosphere**; real photography carries product truth. C2
owns the boundary. (This is both an honesty and a returns-rate issue.)

### 8.4 Delivery spec

MP4 (H.264, yuv420p, faststart) + WebM/VP9. 16:9 desktop, 9:16 mobile, 1:1 social.
Hero loops ≤ 2.5 MB after encode; PDP clips ≤ 1.2 MB. Every video ships with a poster
frame (AVIF) that is the LCP element. Captions/audio described in §9.

---

## 9. Asset requirements

### 9.1 Brand assets (from client)
- Logo suite: primary lockup, horizontal, mark-only, wordmark-only, in SVG. **Currently we
  have raster only.** Vector is required for crisp rendering at all sizes.
- Mono (all-black, all-white) logo variants.
- Exact brand red hex/Pantone.
- Font licenses (web-embedding rights).
- Favicon set + Apple touch icon + `site.webmanifest`.
- OG/Twitter share images (1200×630) per template.

### 9.2 Product photography (per SKU)
- 4–6 shots minimum: front flat/ghost, back, detail (fabric/stitch/logo), on-body front,
  on-body 3/4, scale/stack.
- Consistent white-seamless for grid shots (grid consistency is what reads as luxury).
- Color-accurate, calibrated. Same lighting across all SKUs.
- Minimum 2400px on the long edge for zoom.
- Delivered AVIF + WebP + JPEG fallback, at 480/768/1200/2000 widths.

### 9.3 Editorial photography
- 8–12 campaign images per collection, mixed crops (full-bleed 16:9, portrait 4:5, square).

### 9.4 Video — see §8.

### 9.5 Copy & data
- Product data: name, drop number, price, description (40–80 words), fabric composition,
  care, fit notes, size chart (numeric, per garment type), stock per size.
- Legal copy: shipping, returns, privacy, terms.
- Founder/brand story long-form for `/manifesto`.

### 9.6 Accessibility assets
- Alt text for every image (written by A2, not auto-generated — alt text is copy).
- Captions (`.vtt`) for any video carrying speech; a text summary for narrative films.
- Accessibility statement copy.

---

## 10. Lovable implementation workflow

### 10.1 Setup (before any feature prompt)

1. `mcp__Lovable__list_workspaces` → confirm target workspace and credit standing.
2. `mcp__Lovable__create_project` with an initial message that establishes **the system,
   not a page** — tokens, type scale, motion primitives, and the red-discipline rule.
   Getting the system in the first message is worth more than any later correction.
3. `mcp__Lovable__set_project_knowledge` with the condensed brand + design-system
   contract, so every subsequent message inherits it without restating.
4. Optionally `create_workspace_skill` (`lovable-axiom-components`) so the token rules are
   applied automatically.
5. `render_project_widget` to give the user live build visibility.

### 10.2 Per-change loop

```
plan_mode=true message  →  review approach
      ↓
send_message (one scoped change)
      ↓
get_diff / read_file        →  verify what actually changed
      ↓
/browse screenshot at 5 breakpoints
      ↓
E1 a11y pass + D3 perf pass on changed surface
      ↓
accept, or one corrective message (never a vague "make it better")
```

**Credit discipline (Program Lead enforces):**
- One concern per message. Batching five changes produces one unreviewable diff.
- Never send "improve the design" — send the specific token, spacing, or state change.
- Upload reference frames with the message rather than describing them in prose.
- Use `plan_mode=true` for anything structural before spending a build cycle.
- Assets go up via `get_file_upload_url` — never ask the agent to source imagery.

### 10.3 Backend

Supabase for: product catalog, drops/releases, stock by size, email capture, accounts,
saved items. Checkout/payments depend on the commerce decision in §12. If a hosted
commerce platform is chosen instead, Supabase narrows to email capture + editorial content.

### 10.4 Rendering strategy — open tension

Guardrail 13 (no client-side-only commerce primitives) comes from the LV teardown: on
that site, price, save, and bag count all render client-side, arriving after hydration.
For a brand claiming every piece is intentional, the price cannot be the last thing to
paint.

Lovable's default stack is a client-rendered React SPA. Delivering server-rendered price,
size availability, sold-out state, and bag count therefore needs an explicit decision at
project creation — a framework preference stated in the initial message, or an accepted
trade with a defined mitigation (server-rendered poster values, no layout shift on
hydration, `noscript` fallbacks for price).

This is not a blocker and it is not resolved here. It is the kind of choice that is cheap
at project creation and expensive in Phase 5.

`Needs confirmation` **25** — rendering approach: SSR-capable framework at project
creation, or SPA with a stated mitigation for commerce primitives?

### 10.5 Deployment

`mcp__Lovable__deploy_project` per phase to a staging URL. Custom domain, analytics,
and search-console verification at Phase 7.

---

## 11. Phased execution

Effort shown as human-team vs. CC+gstack, per house convention.

| Phase | Contents | Gate to pass | Human team | CC+gstack |
|---|---|---|---|---|
| **0. Foundation** ✅ | Brand brief, sub-identity analysis, voice charter, competitive teardown (Polo / Burberry / LV), asset audit | **Delivered** — see `AXIOM_PHASE0_BRAND_FOUNDATION.md`. Sub-identity recommended, not confirmed. | 1 week | ~3 hrs |
| **1. Direction** ✅ | Art direction bible, color + contrast system, type system, photography & motion direction, house codes, mood-board specs | **Delivered as written spec** — see `AXIOM_PHASE1_ART_DIRECTION.md`. Style-anchor stills and mood boards specified but **not generated** (no-generation instruction). Red and typeface remain provisional. | 1 week | ~4 hrs |
| **2. Structure** | Sitemap lock, wireframes all pages, flow diagrams, copy deck v1 | UX + copy approved | 1 week | ~4 hrs |
| **3. Design system** | Tokens, Tailwind config, all 42 components spec'd, motion spec | B2+B3 sign-off | 1 week | ~3 hrs |
| **4. Build core** | Lovable project, system in place, Home + PDP + Collection built | Three pages pass a11y/perf/device gate | 2 weeks | ~6 hrs |
| **5. Build full** | Remaining routes, cart, account, search, support, errors | All routes complete | 2 weeks | ~6 hrs |
| **6. Media integration** | All Higgsfield masters + product imagery wired, encode ladder, posters | Perf budget still met **with** real media | 1 week | ~4 hrs |
| **7. Polish & QA sweep** | Motion refinement, full WCAG 2.2 AA audit, CWV tuning, SEO + schema, device matrix, cross-browser | Zero AA blockers; LCP < 2.0s; CLS < 0.05 | 1 week | ~5 hrs |
| **8. Launch** | Domain, analytics, search console, sitemap submission, launch content, monitoring | Live, verified, monitored | 3 days | ~2 hrs |

**Total: ~10 weeks human team → ~1.5 days of focused CC+gstack execution**, excluding
real-world photography shoots and any client-side approval latency, which do not compress.

**Dependency spine:** 0 → 1 → 2 → 3 → 4 → 5, with Phase 6 media production running in
**parallel from the end of Phase 1** (C1/C2 start generating the moment the look is
approved — video is the longest lead item and must not sit on the critical path).

**Budget checkpoints:** Program Lead reports credit spend (Higgsfield + Lovable) at the
end of Phases 1, 4, 6, and 7. Any phase projected to exceed its allocation stops for a
decision rather than silently overrunning.

---

## 12. `Needs confirmation`

Nothing below is assumed. Each blocks or reshapes real work.

**Brand & identity**
1. `Needs confirmation` — **Sub-identity resolution.** Assets show three directions
   (racing badge / collegiate-equestrian "EST. 1995" / blackletter "Axiom Studios,
   BASED IN NYC"). Which is the primary house identity? The other two become either
   sub-lines or retired.
2. `Needs confirmation` — **"Axiom USA" vs "Axiom Worldwide" vs "Axiom Studios."** Three
   names appear across the brief and the assets. One must be the legal/primary name.
3. `Needs confirmation` — **"EST. 1995" — real or aesthetic?** If the brand is new, a
   false founding date is a credibility and (in some markets) advertising-claims risk.
4. `Needs confirmation` — Exact brand red (hex / Pantone). `#FF2D0D` is sampled from a
   supplied raster and is not authoritative.
5. `Needs confirmation` — Vector logo files. We currently have raster only.
6. `Needs confirmation` — Is the horse/equestrian device a permanent house code or a
   single-season graphic? This materially changes the visual system.

**Commerce**
7. `Needs confirmation` — **Commerce platform.** Shopify (headless or hosted) / Stripe
   direct via Supabase / other. This is the single largest architectural fork and gates
   Phases 4–5.
8. `Needs confirmation` — Payment methods, currencies, and shipping regions.
9. `Needs confirmation` — Does the drop model need queue/raffle/timed-release mechanics,
   or is it simply limited stock?
10. `Needs confirmation` — Accounts required to purchase, or guest checkout?
11. `Needs confirmation` — Tax/duty handling and returns policy (drives copy + checkout UX).

**Content & assets**
12. `Needs confirmation` — Does real product photography exist, or is a shoot required?
    (If a shoot is needed it is the critical path, not the site build.)
13. `Needs confirmation` — Full product catalog: SKUs, sizes, prices, stock.
14. `Needs confirmation` — Font licensing budget. The named display faces are commercial;
    open alternatives exist but shift the look.
15. `Needs confirmation` — Model/talent releases for any on-body imagery.
16. `Needs confirmation` — Is AI-generated video acceptable in brand-facing hero
    placement, and does it need disclosure? (Some markets are tightening on this.)

**Technical**
17. `Needs confirmation` — Domain and hosting arrangement.
18. `Needs confirmation` — Analytics stack (GA4 / Plausible / other) and consent/cookie
    requirements (GDPR/CCPA scope depends on shipping regions).
19. `Needs confirmation` — Email platform for the capture form.
20. `Needs confirmation` — Multi-language / multi-currency in v1, or English/USD only?
21. `Needs confirmation` — Browser support floor (affects whether we can rely on
    `view-transition`, container queries, and modern codecs).

**Program**
22. `Needs confirmation` — Higgsfield and Lovable credit budgets (hard ceilings).
23. `Needs confirmation` — Launch date, and whether it is tied to a specific drop.
24. `Needs confirmation` — Who holds final creative approval, and what the review
    turnaround is (this, not build time, usually sets the schedule).

**Rendering**
25. `Needs confirmation` — Rendering approach: an SSR-capable framework declared at Lovable
    project creation, or a client-rendered SPA with a stated mitigation for commerce
    primitives? Derived from guardrail 13 and the LV render-tier finding (Phase 0
    §3.3.11). Cheap to decide at project creation, expensive in Phase 5. See §10.4.

Phase 0 adds a further register, items `0.1`–`0.20`, in
[`AXIOM_PHASE0_BRAND_FOUNDATION.md`](./AXIOM_PHASE0_BRAND_FOUNDATION.md) §6. All remain
open.

---

## 13. Recommendation

Approve Phases 0–1 only. Resolve items 1–6 and 12 before any pixel is designed and before
any Higgsfield credit is spent — the sub-identity question alone can invalidate an entire
art-direction pass. Item 7 (commerce platform) must land before Phase 3 ends.

**Stopping here for approval. No project created, no credits spent.**
