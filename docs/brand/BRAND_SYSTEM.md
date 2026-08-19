# ArmoSpectra — Brand System v1.0

**Growth Operating Systems for Modern Businesses.**

Dark-first visual identity. This document is the written specification; the
[visual deck](armospectra-brand-deck.html) is the presentation of it, and
`tokens.css` / `tokens.json` / `tailwind.preset.js` are the machine-readable
source. All four stay in sync — change the spec, then change the tokens.

Derived from the ArmoSpectra CEO poster, which remains the primary source of truth
for anything not covered here.

---

## 1. Positioning

| | |
|---|---|
| **Category** | Premium marketing and growth systems agency. We sell architecture, not deliverables. |
| **Positioning statement** | ArmoSpectra builds Growth Operating Systems — websites, visibility, portals, dashboards, and workflows connected into one system rather than assembled as separate tools. |
| **Audience** | Modern businesses whose marketing runs across disconnected tools, and whose owners are accountable for growth rather than for channels. |
| **Structure** | Founder-led. The identity carries a named principal. |

**Attributes:** Engineered · Composed · Premium · Direct.

**What we are:** an operating system for growth · one connected architecture ·
founder-led and accountable · built to be handed over and run.

**What we are not:** a channel-by-channel service menu · a template marketplace ·
an anonymous agency roster · a one-off campaign vendor.

---

## 2. The capability architecture

Six fixed words, in fixed order. Four stages carry a prospect from unknown to
managed; two layers run underneath all four.

| | Capability | Role |
|---|---|---|
| Stage 01 | **Visibility** | Being findable. Search, content, and presence that put the business in front of demand. |
| Stage 02 | **Capture** | Turning attention into a record. Sites, forms, and lead paths that hold what visibility earns. |
| Stage 03 | **Follow-up** | Nothing waits. Sequences and reminders that keep every captured lead in a conversation. |
| Stage 04 | **Portals** | The client-facing surface. Dashboards and portals where the work becomes visible to the customer. |
| Substrate | **Automation** | The connective layer. Workflows that move data between the four stages without a person carrying it. |
| Substrate | **AI Readiness** | Structured data, clean records, and defined processes — the preconditions for anything intelligent on top. |

Never reorder them. Never present them as independent services. Never substitute
synonyms ("lead gen" for Capture, "CRM" for Follow-up) — the vocabulary is part
of the identity.

---

## 3. Logo

| Element | Spec |
|---|---|
| Mark | Single-weight outline primate, walking pose, long curled tail. No fill, rounded joins. |
| Wordmark | `ARMOSPECTRA`, uppercase, weight 200–300, tracking **0.32em**, optically matched to the mark's width. |
| Vertical lockup | Mark centred over wordmark. Stack gap = **0.4× mark height**. Primary. |
| Horizontal lockup | Mark left of wordmark. Navigation, letterhead, signatures. |
| Mark alone | Avatars, favicons, watermarks. |
| Clearspace | Wordmark cap-height (**1×**) on all four sides. Nothing enters it — not type, not the arc motif, not a photo edge. |
| Stroke | Scales with the mark. Never below **1.25px** rendered. |

**Colourways:** white on ink (primary) · ink on white (invert only) · 22% white
(watermark). Never blue, never chrome, never filled.

**Minimum sizes**

| Lockup | Digital | Print |
|---|---|---|
| Vertical | 96 px wide | 26 mm |
| Horizontal | 140 px wide | 34 mm |
| Mark alone | 32 px | 9 mm |
| Wordmark alone | 120 px wide | 30 mm |

**Never:** colour the mark · fill it or apply the chrome gradient · place it on a
chromatic or photographic background · stretch or distort it · thicken the stroke ·
remove the wordmark tracking · reset the wordmark in another typeface.

---

## 4. Colour

### Foundation — the ground

| Token | HEX | Use |
|---|---|---|
| Ink 900 | `#050507` | Page base, deepest corners |
| Ink 800 | `#0B0B0F` | Primary surface, cards |
| Ink 700 | `#131318` | Raised panel, inputs |
| Ink 600 | `#1C1C22` | Hairlines, borders |
| Ink 500 | `#26262E` | Disabled, inert states |

### Accent — the only chromatic family

| Token | HEX | Use |
|---|---|---|
| Blue 300 | `#BFDBFF` | Chrome highlight stop, hover text |
| Blue 400 | `#6BB4FF` | Inline emphasis, eyebrows, icon glow |
| Blue 500 | `#3B8EF0` | Primary accent, CTA border, section rules |
| Blue 600 | `#1F63C4` | Gradient mid, divider glow |
| Blue 800 | `#0E2E5C` | Arc motif, ambient wash |

### Neutrals — cool-biased, not pure grey

| Token | HEX | Use |
|---|---|---|
| White | `#FFFFFF` | Headlines, logo, capability labels |
| Gray 200 | `#D8DADE` | Body copy |
| Gray 400 | `#9AA0A8` | Secondary, captions, metadata |
| Gray 600 | `#5A5F66` | Photo mid-tones, slide footers |

### Coverage ratio

**80% black · 15% white · 5% blue.** If a layout reads as blue, reduce the accent
before adjusting anything else.

**Always blue:** eyebrows and kickers, inline emphasis in a subhead, section rules,
divider glow, CTA border, focus rings, active nav state.
**Never blue:** the logo, body copy, headline base weight, default icon strokes,
large background fills.
**One primary CTA per view.** Secondary actions take the ghost variant in Ink 500.

### Contrast (WCAG 2.1, computed against `#0B0B0F`)

| Foreground | Ratio | |
|---|---:|---|
| White | 19.65 | AAA |
| Gray 200 | 14.04 | AAA |
| Blue 300 | 13.84 | AAA |
| Blue 400 | 8.98 | AAA |
| Gray 400 | 7.45 | AAA |
| Blue 500 | 5.91 | AA |
| Blue 600 | 3.41 | Large text / UI boundaries only |
| Blue 800 | 1.46 | Ambient only, never text |

Two pairings that decide component design:

- **White on Blue 500 = 3.33:1 — fails AA.** This is the technical reason
  solid-fill blue buttons are off-brand.
- **Ink 900 on Blue 500 = 6.12:1 — passes.** If a filled blue chip is unavoidable,
  its label is Ink 900.

Semantic UI colours (success / warning / critical) are a separate, desaturated set,
introduced only when a real interface needs them. They are not the brand accent and
never appear on marketing surfaces.

---

## 5. Typography

Two brand faces, hard cap.

| Role | Face | Spec |
|---|---|---|
| Everything | **Montserrat** | Weights 200 · 300 · 400 · 500 · 800 · 900. Fallback: Archivo, Helvetica Neue, system-ui. |
| Signature only | **Great Vibes** | One instance per composition, only for the principal's name, always under the `CEO OF ARMOSPECTRA` eyebrow. Fallback: Snell Roundhand, cursive. |
| Documentation only | JetBrains Mono | Specs, token tables, code. **Not a brand face.** Never in marketing, social, or client-facing surfaces. |

### Weight roles

| Weight | Role |
|---|---|
| 900 | Display black — spread numerals only |
| 800 | Headlines |
| 500 | Labels, buttons, eyebrows |
| 400 | Body copy |
| 300 | Lede paragraphs and subheads |
| 200 | Wordmark |

### Scale (px @ 1440pt viewport)

| Tier | Size / line-height | Case | Tracking |
|---|---|---|---|
| Display XL | 84 / 0.94 | Upper | −0.005em |
| Display L | 58 / 0.96 | Upper | −0.005em |
| Display M | 40 / 1.00 | Upper | −0.005em |
| Heading | 21 / 1.15 | Upper | 0.01em |
| Lede | 19 / 1.55 | Sentence | 0 |
| Body | 16 / 1.50 | Sentence | 0 |
| Capability label | 14 / 1.00 | Upper | 0.28em |
| Caption | 13 / 1.45 | Sentence | 0 |
| Eyebrow | 12 / 1.00 | Upper | 0.22em |
| Micro | 11 / 1.40 | Upper | 0.04em |

Display tiers scale fluidly with `clamp()`; text tiers are fixed. Running text
never exceeds `66ch`.

---

## 6. Hierarchy

Six tiers, always in this order, separated by whitespace jump or a rule — never
by colour alone.

1. **Logo lockup** — identity
2. **Headline** — the promise, roughly 3.5× the next element
3. **Subhead** — category definition, one blue phrase
4. **Attribution + signature** — the human
5. **Capability list** — six equal items, none emphasised
6. **Summary → CTA** — the action

A 70 × 2 px blue rule precedes tiers 3 and 6.

---

## 7. Grid & spacing

| | |
|---|---|
| Columns | 12 (desktop), 6 (tablet), 4 (mobile). 16 px gutter. |
| Page margin | **10.4%** of viewport width — from the source poster's 98 px inset on a 940 px canvas. |
| Text column | ≤ 7 of 12 when paired with an image; ≤ 66ch for running text. |
| Alignment | Left, single column. Centring is reserved for the avatar and the standalone mark. |
| Image bleed | Photography bleeds off the right and bottom edges. Copy never overlaps the subject's face or hands. |
| Slide margin | 7.5% on a 1920 × 1080 canvas. |

**Spacing scale — base unit 8 px. Only these seven values:**
`8` inline · `16` label-to-value · `24` card padding and grid gap ·
`40` block separation · `56` section opener · `72` major break · `96` page padding.

If a gap needs 30 px, the composition is wrong, not the scale.

**Fixed component metrics:** capability row `74px` · icon box `44px` ·
CTA height `56px` (radius = height ÷ 2) · section rule `70 × 2px` ·
card radius `12px` · hairline `1px` gradient.

---

## 8. Gradients, light & texture

One light source: **upper right**, falling to black toward the lower left.

| Gradient | Value |
|---|---|
| Chrome (display type) | `linear-gradient(180deg,#FFFFFF 0%,#DCE9FF 30%,#7FB6F5 62%,#2E6FD0 100%)` |
| Ambient (page ground) | `radial-gradient(120% 120% at 75% 0%,#1A1B20 0%,#050507 70%)` |
| Divider (hairline) | `linear-gradient(90deg,#1C1C22 0%,#3B8EF0 85%,transparent 100%)` |
| Bloom (ambient accent) | `radial-gradient(60% 100% at 50% 100%,rgba(59,142,240,.45) 0%,rgba(5,5,7,0) 70%)` |

**Chrome rules:** display type only · one or two words per headline, never a whole
line · minimum 48 px · paired with a ~30% drop-shadow glow, never a hard stroke ·
always declare `#BFDBFF` as the solid fallback behind the clip · **not reproducible
in print** — substitute plain white or white foil, never silver-metallic ink.

**Texture:** fractal noise at **2–4%** opacity over any gradient field larger than
~400 px. It prevents visible banding on dark 8-bit displays.

**No** drop shadows on UI elements, glassmorphism, blur panels, or frosted overlays.
Depth comes from the ground gradient and hairlines.

---

## 9. Photography

Monochrome, high-contrast, black wardrobe, subject dissolving into the ground.

| | |
|---|---|
| Saturation | 0%, faint cool cast permitted. Never warm. |
| Contrast | High — roughly +28% over a neutral grade. |
| Blacks | Crushed to `#050507`. Highlights clip to white only on the rim. |
| Wardrobe | All black. Subject merges with the ground at the frame edge. |
| Cutout | Soft-edge feather. Never a hard mask or visible outline. |
| Framing | Full or three-quarter body, generous headroom, subject in the right ~55% of a vertical layout. |
| Direction | Confident, relaxed. Direct-to-camera or slightly off-axis. |

**Subject classes:** principal portraiture (default) · environment (architectural,
empty of people) · interface capture (in the brand's own dark UI) · abstract
structure (sparingly, behind type).

**Never:** colour portraits or environments · white/cream/studio-cyclorama
backdrops · stock staging (handshakes, whiteboards, laptop-and-coffee) · groups ·
hard-masked cutouts · any image that would read as on-brand for someone else's brand.

Where no principal image exists for a surface, use environment or abstract
structure — never substitute stock people.

---

## 10. Iconography

| | |
|---|---|
| Canvas | `24 × 24` viewBox, live area `20 × 20` with 2 px padding |
| Stroke | `1.5` units, uniform within and between icons |
| Terminals | `stroke-linecap: round`, `stroke-linejoin: round` |
| Geometry | Circles, rectangles, straight runs. Curves are circular arcs. |
| Fill | `none`, without exception. The only permitted solid is a dot terminal under 2.5 units. |
| States | White at rest · Blue 400 + glow when active · Gray 600 when inert |

**Never:** solid or duotone fills · app-tile containers behind icons · multi-colour.
A new icon that needs a fill to read must be redrawn, not excepted.

---

## 11. Graphic motifs

**Ambient arcs.** Concentric circles, 1 px stroke, `#0E2E5C` at 12–20% effective
opacity. Anchored *off-canvas* at top-right and bottom-left so only arcs enter the
frame, never a whole circle. Radii step irregularly and tighten toward the outer
edge — evenly spaced rings read as a target, not an orbit. Always behind content.
At most two anchors per surface, and not every surface needs them.

**Glowing hairline dividers.** `90deg, #1C1C22 0%, #3B8EF0 85%, transparent 100%`.
The bright end travels down the right edge of a stack, implying the same light
source as the page grade. Always left-dark to right-bright. For list rows and
section tiers — not table rules, not card borders.

**Section rule.** 70 × 2 px, Blue 500, 40 px glow at 35%. Precedes a subhead or a
footer tier. One per tier, never decorative.

Separation comes from hairlines and whitespace. If a divider is not enough to
separate two things, they need more space, not a box.

---

## 12. Tone of voice

**Imperative** — headlines are commands. **Concrete** — name components that exist.
**Unhurried** — no urgency devices. **Accountable** — first person singular where
the principal is speaking.

| | |
|---|---|
| Sentences | Short. Mix one-line punches with two- or three-sentence runs. |
| Headlines | Uppercase, under 10 words, one chrome emphasis word. |
| Body | Sentence case, active voice, second person. |
| Numbers | Only measured ones, with the source named. |
| Banned | Exclamation marks, emoji, "unlock", "supercharge", "game-changing", "revolutionise", "seamless", "solutions" as a standalone noun. |

**Test before publishing:** does the sentence name something that exists, could it
have been written by any other agency, and does it survive being read aloud without
an exclamation mark?

---

## 13. Messaging framework

**Master message:** Build the system behind your growth.

| Pillar | Claim |
|---|---|
| 01 · Connected, not assembled | The parts were always available. The connection is the product. |
| 02 · Built to be run | A system you operate, not a dependency on the agency that made it. |
| 03 · Ready for what's next | Clean data and defined process are the precondition for anything intelligent. |

**By audience**

| Audience | Lead with | Entry point |
|---|---|---|
| Owner-operator | Nothing waits, and nothing is lost between tools. | Capture & Follow-up |
| Marketing lead | One architecture instead of six subscriptions. | Visibility & Automation |
| Operations lead | The client-facing surface stops being email. | Portals |
| Investor / partner | A repeatable system, not a bespoke engagement. | The full six-stage architecture |

**Fixed strings — do not paraphrase for a channel**

- Tagline — *Build the system behind your growth.*
- Descriptor — *Growth Operating Systems for Modern Businesses.*
- One-liner — *Websites, visibility, portals, dashboards, and workflows, connected into one system.*
- Capability list — *Visibility · Capture · Follow-up · Portals · Automation · AI Readiness*

**The proof tier is deliberately empty.** This framework asserts no metrics, client
names, or results, because none are established in the source material. A number
ships only with a named source and a stated period. A client name ships only with
written permission on file. Never fill a proof slot with a capability restatement.

---

## 14. Applications

### Website
Dark by default, no light mode. Radial ambient from upper right over `#050507`.
Horizontal lockup left, four uppercase links right at 0.18em. Hero: eyebrow →
headline with one chrome word → section rule → subhead → single outlined CTA, arc
motif behind and never crossing type. Motion: fade-and-rise, 400 ms, 12 px travel,
once per element, respecting `prefers-reduced-motion`. No parallax, no counters,
no autoplay video. Focus: 2 px Blue 400 ring at 3 px offset.

### Social
Horizontal lockup top-left is the only fixed element. Statement under 9 words,
uppercase, one chrome word maximum. 44 px rule below the statement, never above.
Close with either the domain in tracked caps or one outlined pill, never both.
Keep content 12% inside every edge. Avatar is the mark alone at 58% of the circle
diameter — never the full lockup.

**Never:** emoji (graphics or captions) · coloured backgrounds or duotone photo
treatments · a carousel where slide 2+ drops the lockup · light-mode screenshots ·
text over a subject's face · typeface substitution.

### Presentation
16:9, 7.5% margins. Four masters: **A** title · **B** section divider ·
**C** content · **D** data. Footer carries the wordmark left and slide number right
in Gray 600 mono at 8 px, absent on Master A. One headline per slide. One chrome
word per slide, Masters A and B only. Maximum six bullets *or* three cards *or* one
chart — never a combination.

**Charts:** Ink 500 for the set, one emphasised bar in the blue gradient. One
baseline and one axis in Ink 600, no gridlines. `tabular-nums` always. A mandatory
source line — a chart without a named source and period does not ship. No 3D, no
pie charts, no drop shadows on bars, no second accent hue for series (use lightness
within the blue ramp).

### Print collateral
In print the chrome gradient cannot be reproduced and the glow disappears; both are
dropped. Uncoated black-cored board, 600 gsm for cards; uncoated 120 gsm for
letterhead. Mark in opaque white screen or white foil — never white toner on coated
stock, it greys. Blue 500 as a spot colour on the rule and eyebrow only. Soft-touch
matte, never gloss.

**Email signature:** horizontal lockup as a 2× PNG (never live SVG — mail clients
strip it), max 320 px wide, divider as a 1 px background-image gradient with a flat
Ink 600 fallback. No social icon row, no quote, no disclaimer block. Set type
colours explicitly; never rely on the container.

---

## 15. Master rules

When two rules conflict, the lower number wins.

1. **Dark is the default, not a theme.** Light mode is a separate project with its own contrast study. Never auto-invert.
2. **One accent hue.** No second chromatic family. Semantic UI states are desaturated and separate.
3. **Blue never exceeds ~5% of pixels.** If a comp looks blue, reduce the accent first.
4. **Chrome gradient on display type only, max two words.** Below 48 px the stops compress; on a full headline the emphasis cancels.
5. **Two brand typefaces. Hard cap.** The script appears once, for a person's name.
6. **The logo is monochrome, outline, unfilled — always.**
7. **Uppercase + wide tracking marks structure;** body stays sentence case.
8. **Icons are 1.5 px outline strokes.** No fills, no tiles.
9. **Dividers glow. Containers don't.** No drop shadows, no added boxes.
10. **8 px vertical rhythm;** section breaks at 56 / 72 / 96.
11. **CTAs are outlined pills, transparent fill.** White on Blue 500 is 3.33:1 and fails AA — the outline is an accessibility decision.
12. **Photography is monochrome, high-contrast, black wardrobe, edge-feathered.**
13. **Left-aligned single column;** text column ≤ 7 of 12 when paired with an image.
14. **Arc motif is ambient:** corners, under 20% opacity, always behind content.
15. **A number ships only with a named source and a stated period.**

---

## 16. Extending the system

1. **Derive, don't invent.** A new component must be buildable from existing tokens.
2. **Check rule order.** Run the proposal against the fifteen master rules.
3. **Measure contrast.** 4.5 for body, 3.0 for large type and UI boundaries.
4. **Test at thumbnail.** If it stops reading as ArmoSpectra at 200 px wide, it is decoration, not identity.

## What this document does not contain

Client names, case studies, testimonials · performance metrics or result claims ·
pricing or commercial terms · a light-mode palette.

Each is absent because it is not established in the source material. They are
additions to be made with evidence, not gaps to be filled with plausible copy.
