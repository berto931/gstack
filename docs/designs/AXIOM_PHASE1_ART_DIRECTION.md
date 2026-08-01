# Axiom — Phase 1: Art Direction

Date: 2026-07-31
Status: **Delivered as written specification. Provisional pending Phase 0 confirmations.**
No assets generated or modified. No Higgsfield. No Lovable. No credits spent.
Owners: A3 Art Director, with B2 Design System Architect on tokens and type.

Written against the **house / lines / drops architecture** resolved in Phase 0 §6. The
house register is institutional; the two permanent lines (ATHLETICS, CLUB) carry their own
vocabulary beneath it, and drop graphics are free within the guardrails.

> **Scope note.** The approved plan put style-anchor still generation in Phase 1. That
> work is **deferred** under the no-generation instruction. What follows is the complete
> written direction those stills would have been produced from — the prompts, lighting,
> grade, and acceptance criteria are specified here and ready to execute on approval.

---

## 1. The look, in one paragraph

Hard light on a seamless ground, nothing warm anywhere in frame. Type is condensed,
uppercase, and set tight, with mono numerals doing the meta work — drop numbers, sizes,
prices. Structure is announced by 1px rules borrowed from the logo's box frame. Space is
generous to the point of feeling withheld. Red appears rarely and always means something.
The overall impression should be a technical document that happens to be beautiful, not a
fashion campaign that happens to be minimal.

---

## 2. Color system

### 2.1 Tokens

| Token | Value | Role |
|---|---|---|
| `--ink` | `#0A0A0A` | Primary text on light; primary dark surface |
| `--ink-pure` | `#000000` | Photographic/video seamless ground only |
| `--paper` | `#FAFAFA` | Primary light surface |
| `--pure` | `#FFFFFF` | Product-shot ground, cards, elevated surfaces |
| `--red` | `#FF2D0D` *(provisional)* | Brand accent — display sizes, marks, indicators |
| `--red-ink` | `#C41E08` | Red used as text at body sizes on light surfaces |
| `--grey-05` | `#F0F0F0` | Hairline on light |
| `--grey-20` | `#D6D6D6` | Borders, dividers |
| `--grey-45` | `#8C8C8C` | Meta text, disabled |
| `--grey-70` | `#4A4A4A` | Secondary text on light |
| `--grey-85` | `#1F1F1F` | Elevated surface on dark |

`Needs confirmation` **0.4** — `--red` is sampled from a supplied raster and is **not
authoritative**. Every contrast figure below recomputes when the true brand red lands.

### 2.2 Contrast analysis — a real constraint, computed

Measured against WCAG 2.2 AA using the provisional red.

| Pair | Ratio | AA normal (4.5:1) | AA large / UI (3:1) |
|---|---|---|---|
| `--ink` on `--paper` | 18.9:1 | Pass | Pass |
| `--paper` on `--ink` | 18.9:1 | Pass | Pass |
| `--red` on `--pure` (white) | **3.73:1** | **Fail** | Pass |
| `--red` on `--ink` (black) | **5.63:1** | **Pass** | Pass |
| `--red-ink` on `--pure` | **5.93:1** | Pass | Pass |
| `--grey-45` on `--paper` | 3.54:1 | Fail | Pass |
| `--grey-70` on `--paper` | 8.6:1 | Pass | Pass |

**The finding that shapes the system:** the brand red passes on black and fails on white
for body-size text. That is not a defect to design around — it is a directive. Red as
*text* belongs on dark surfaces. On light surfaces, red is a **mark, rule, or indicator**
at display size, and `--red-ink` carries any small red type.

E1 owns this rule. It is the most likely place for the build to quietly regress.

### 2.3 Red discipline

1. Red never exceeds ~5% of any viewport.
2. Red is reserved for exactly four things: the logo mark, the active/selected state, the
   scroll-progress hairline, and the single primary CTA per view.
3. Never red body text on a light surface — use `--red-ink`, or move it to dark.
4. Two red elements never share a viewport unless one is the logo.
5. Red is never used for error states. Errors use `--ink` with a rule. Red means Axiom,
   not danger — overloading it costs the brand more than it costs the error message.

Rule 5 is a deliberate trade and worth flagging: it means error styling leans on weight,
position, and an icon rather than color, which E1 will verify is sufficient without color
as the only channel (WCAG 1.4.1).

### 2.4 Surface strategy

Sections alternate between `--paper` and `--ink` as a rhythm device. Product grids are
always light (product truth needs a neutral ground). Manifesto and drop-story sections are
always dark. The header inverts on scroll. Roughly 60/40 light-to-dark across a full home
scroll.

---

## 3. Typography

### 3.1 Three voices

| Role | Character | Why |
|---|---|---|
| **Display** | Condensed or expanded grotesque, heavy, uppercase, tracking `-0.02em` | Carries the institutional/signage read; this is the brand's loudest instrument |
| **Body / UI** | Neutral grotesque, regular/medium, generous line-height | Legibility; deliberately recessive so display and product carry the page |
| **Meta** | Monospace, uppercase, tracking `+0.08em` | Drop numbers, SKUs, sizes, prices, timestamps. The single strongest "technical authority" cue available. |

These three voices are the **house** system and govern every site surface. Line and drop
graphics may use their own lettering on garments — CLUB's script, a drop's blackletter —
but those never enter the site's interface typography. The arched collegiate wordmark is
retired outright (guardrail 16).

### 3.2 Candidates

| Tier | Display | Body | Meta |
|---|---|---|---|
| **Preferred** (commercial) | Söhne Breit or Neue Haas Grotesk Display | Söhne | Söhne Mono |
| **Alternate** (commercial) | Monument Extended, Archivo Expanded | Suisse Int'l | JetBrains Mono |
| **Open-source fallback** (zero license cost) | Archivo Expanded (OFL) | Inter Tight (OFL) | JetBrains Mono (OFL) |

The open-source row is a genuinely viable system, not a consolation. Archivo Expanded plus
Inter Tight plus JetBrains Mono delivers ~85% of the preferred look at no licensing cost.

`Needs confirmation` **0.11** — font licensing budget. This decision is the difference
between the preferred and fallback rows and cannot be made by us.

### 3.3 Scale

Modular: 1.25 (minor third) mobile, 1.333 (perfect fourth) desktop. Display sizes use
`clamp()` so a hero statement fills its measure at every width.

| Step | Mobile | Desktop | Use |
|---|---|---|---|
| `display-xl` | 40px | 128px | Hero statement, manifesto |
| `display-l` | 32px | 80px | Section statements |
| `display-m` | 26px | 56px | Collection titles |
| `display-s` | 22px | 36px | Product name on PDP |
| `body-l` | 18px | 20px | Lead paragraphs |
| `body-m` | 16px | 16px | Default body |
| `body-s` | 14px | 14px | Secondary, captions |
| `meta` | 12px | 12px | Mono. Drop numbers, sizes, SKUs |

Line-height: 0.92 display, 1.55 body, 1.2 meta. Measure capped at 68 characters.

### 3.4 Rules

1. Display is always uppercase. Body is always sentence case.
2. Never more than one display element per viewport.
3. Mono is never used for prose — only for values, identifiers, and labels.
4. No italics anywhere in interface type. Script and italic lettering is permitted inside
   CLUB and drop artwork, never in the UI.
5. Numerals in product context are always mono, always tabular.

---

## 4. Layout and grid

12 columns desktop / 6 tablet / 4 mobile. 8px baseline. Gutters 24px mobile, 32px tablet,
40px desktop. Max content width 1680px; text blocks never exceed 8 columns.

**Section rhythm:** 96px mobile / 128px tablet / 192px desktop vertical padding. This is
deliberately larger than conventional — the space *is* the luxury signal, and it is the
first thing that will get compressed under pressure in Phase 4. It should not be.

**Composition principles**

1. **Deliberate asymmetry.** Full-bleed media against a hard-stopped 6-column text block.
   Never center everything.
2. **Rules as punctuation.** 1px `--grey-20` lines mark structural boundaries, echoing the
   logo's box frame. This is a house code, used consistently.
3. **One idea per viewport.** If two things compete, one moves to the next scroll.
4. **Hard edges.** No rounded corners above 2px, no drop shadows, no gradients, no glass
   effects. Elevation is communicated by surface color and rule weight only.
5. **Media is either full-bleed or precisely gridded.** Never floating at an arbitrary
   width.

---

## 5. Photography direction

### 5.1 Product photography

| Parameter | Specification |
|---|---|
| Ground | Pure white seamless (`#FFFFFF`) for all grid/PDP shots |
| Key light | Single hard source, ~45° camera-left, high | 
| Fill | None or minimal — shadow falloff is part of the look |
| Shadow | Present and directional. Not floated, not clipped out. |
| Lens | 85–105mm equivalent; minimal distortion |
| Color | Calibrated, neutral. No warm grade. Garment blacks must read as `--ink`, not blue or brown. |
| Consistency | **Identical lighting across every SKU.** Grid consistency is the single largest driver of perceived luxury. |
| Resolution | ≥2400px long edge for zoom |
| Shot set | Front (flat or ghost), back, detail (fabric/stitch/mark), on-body front, on-body 3/4, scale/stack |

### 5.2 Editorial / campaign photography

Studio-led, black or white seamless, occasionally a hard architectural environment. Never
countryside, estate, or heritage interior (Phase 0 guardrail 5). Casting reads as
composed and self-possessed, not aspirational-lifestyle. Subjects rarely smile and never
perform. No golden hour, no warm grade, no lens flare.

### 5.3 Two-source problem

Grid shots must be lit identically across SKUs; editorial can vary. If those are shot in
different sessions, the grid will fracture. **Recommendation: shoot the full grid set in
one session, editorial in another.** C2 owns the consistency check.

---

## 6. Motion look (video direction)

Specification only. No generation performed.

| Parameter | Specification |
|---|---|
| Camera | Slow dolly in/out, or locked. **No handheld, no shake, no whip pan.** |
| Focal | 35mm for wide, 85mm for detail. Shallow but not novelty-shallow. |
| Lighting | Hard key, single source, controlled falloff, no fill |
| Ground | Pure black or pure white seamless |
| Grade | High-contrast monochrome, single red accent permitted |
| Pace | Slow and weighted. If something moves fast it is one cut, not motion blur. |
| Grain | Minimal to none |
| Duration | 8–12s hero loops; seamless loop point mandatory |
| Audio | None on site (all autoplay is muted). Films may carry sound in social cutdowns. |

### 6.1 Locked prompt block (ready to execute, not executed)

Every future generation reuses this verbatim, varying only the subject line:

```
SUBJECT:   <per shot>
WARDROBE:  <per shot — Axiom piece, accurate colorway>
LIGHTING:  hard key, single source, controlled falloff, no fill
GROUND:    pure black seamless   |   pure white seamless
CAMERA:    slow dolly in, 35mm, shallow depth, locked horizon
GRADE:     high contrast monochrome, single red accent
NEGATIVE:  no text, no logos, no warm tint, no handheld shake,
           no lens flare, no crowd, no environment, no fast motion
```

### 6.2 Style-anchor procedure (deferred)

When approved, C1 generates a small set of stills first, iterating until one nails the
look. That approved still becomes the image-to-video reference for **every** subsequent
shot. This is the single largest lever on both consistency and credit cost, and it is why
no video should be generated before one still is approved.

**Acceptance criteria for the anchor still:** black reads as true black with visible
shadow detail; the key light direction is unambiguous; zero warm cast; no text or logo
artifacts; red (if present) occupies under 5% of frame.

### 6.3 Product-truth boundary

Generated video is used for **mood, texture, and atmosphere only**. It is never presented
as the literal product on a PDP, because generated garments will not match what ships.
Real photography carries product truth. C2 owns this boundary; it is an honesty issue and
a returns-rate issue simultaneously.

`Needs confirmation` **16** — whether AI-generated video is acceptable in brand-facing
hero placement, and whether disclosure is required in your shipping markets.

---

## 7. House codes

Confirmed by the Phase 0 brand architecture pass (Phase 0 §6). Four devices, used
consistently enough to become recognisable without the wordmark.

| Code | Form | Where it appears |
|---|---|---|
| **Capsule-A badge** | The house mark. Compact form drops the rule box and wordmark, leaving capsule-A plus three stars | Header, favicon, packaging, neck and care labels, checkout, order confirmation, and a small chest or hem hit on every garment |
| **Three stars** | From the primary mark | Section dividers, loading state, footer, packaging |
| **Red rule** | 1–2px red hairline | Scroll progress, active nav, card hover draw-in, drop markers |
| **Numbered drop** | Mono, zero-padded — `DROP 004` | PDP, drop archive, packaging, order confirmation |

These replace the crest/check/monogram function the competitors rely on. They are
structural rather than decorative, which is what keeps the site from needing pattern fill
to feel branded.

**Line-level vocabulary** sits below the house codes and never replaces them:

| Line | Vocabulary |
|---|---|
| AXIOM ATHLETICS | Wordmark, single star, horizontal rules, box lockups |
| AXIOM CLUB | Script wordmark, laurel wreath, single star |

**Retired** and not to be reintroduced: heraldic crest, AW monogram, globe, arched
collegiate wordmark. See Phase 0 §6.7 and guardrails 2, 16, 17.

## 8. Mood board specification

Boards are **specified, not produced** — production requires image sourcing or generation,
both out of scope under the current instruction.

| Board | Contents | Purpose |
|---|---|---|
| **B1 — Institutional** | Motorsport liveries, standards-body signage, technical certification marks, aerospace placards | Establishes the house register |
| **B2 — Light** | Hard-key studio product work, single-source shadow studies, black-on-black texture | Locks the lighting contract |
| **B3 — Type** | Condensed grotesque signage, mono data tables, numbered edition marks | Locks the three-voice system |
| **B4 — Space** | Editorial layouts with extreme vertical rhythm, single-image viewports | Justifies the 192px section padding before it gets compressed |
| **B5 — Anti-board** | Explicit examples of what we refuse: monogram fills, crests, checks, warm grades, celebrity campaigns | Faster to enforce a guardrail with a picture than a rule |

B5 is the one most teams skip and the one that saves the most review cycles.

---

## 9. What Phase 1 could not lock, and why

| Item | Status | Blocked by |
|---|---|---|
| Brand red | **Provisional** | `Needs confirmation` 0.4 — authoritative hex/Pantone |
| Typeface selection | **Two viable systems specified, neither selected** | `Needs confirmation` 0.11 — licensing budget |
| Sub-identity | **RESOLVED** — house / lines / drops architecture | Closed by Phase 0 §6 |
| Style-anchor stills | **Specified, not generated** | Current no-generation instruction |
| Mood boards | **Specified, not produced** | Current no-generation instruction |
| Logo application rules | **Cannot finalize** | `Needs confirmation` 0.5 — vector suite absent |
| Photography direction validation | **Written, unproven** | `Needs confirmation` 0.9 — no photography exists |

Everything above is written specification ready to execute. None of it required
assumptions to be made on your behalf, and none were.
