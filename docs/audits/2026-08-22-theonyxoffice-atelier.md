# Full Audit — theonyxoffice.com (`/#atelier`)

**Target:** https://theonyxoffice.com/#atelier
**Date:** 2026-08-22
**Method:** Headless Chromium (Playwright) render + scroll simulation at 1440×900 and 390×844,
axe-core 4.x accessibility scan, real-origin HTTP header/asset/timing measurement, and static
analysis of the shipped production JS bundle (`index-ChjySJae.js`). Runtime behavior was
reproduced through a local origin mirror; every root cause below was then confirmed against the
real production bundle and real-origin responses.

The `#atelier` fragment is an in-page anchor on a single-page site, so this is a full audit of the
whole page, with the Atelier section called out where relevant.

---

## Health score: 72 / 100 — Good build, one broken promise

The site is well-engineered where it counts: no console errors, no runtime exceptions, no failed
requests, clean HTTPS with HSTS, immutable long-cache + HTTP Range on media, gzipped JS, code
splitting, zero layout shift, a single H1, and no horizontal overflow at any width. The craft in the
motion and glass design system is real.

Two things hold the score down: the exact URL being shared (`/#atelier`) does not actually land on
the Atelier section, and the page ships ~49 MB of media with content images as oversized PNGs.
Neither is hard to fix.

| Category | Grade | Notes |
|---|---|---|
| Functional / correctness | C | Deep-link anchors don't work on cold load (the shared URL is affected) |
| Performance | C+ | Fast TTFB and JS, but ~49 MB of media; PNGs where WebP belongs |
| Accessibility | C+ | No `<main>`/labels; form has placeholder-only fields; weak focus ring |
| SEO / metadata | C | Leftover template tags, no canonical/og:url/JSON-LD, generic title |
| Security (headers) | B- | HSTS/XCTO/Referrer present; no CSP, X-Frame-Options, Permissions-Policy |
| Code quality / stability | A- | Clean console, no errors, code-split, CLS 0, responsive |
| Visual / design craft | A- | Strong, cohesive dark "atelier" system; motion is well-tuned |

---

## Findings (severity-ranked)

### H1 — Deep link `/#atelier` does not scroll to the Atelier section (HIGH)

Loading `https://theonyxoffice.com/#atelier` cold leaves the viewport at the very top of the page
(scrollY = 0). The same is true for `/#practice`, `/#selects`, and `/#contact`. Clicking the nav
links **after** the page has loaded works correctly (About → scrollY 900, which is the Atelier
section's offset), so the section IDs and in-app navigation are fine — it is specifically first-load
navigation from a URL fragment that fails.

**Why it matters:** this is the exact URL in the audit request, i.e. the kind of link that gets
shared, bookmarked, or put in a bio/DM. Every one of those recipients lands on the hero and has to
find the section themselves. A deep link that doesn't deep-link is a broken promise to the visitor.

**Root cause (confirmed in the production bundle):** the SPA mounts a `ScrollToTop` effect that runs
`window.scrollTo({top:0,left:0,behavior:"auto"})` on route mount, and there is no code anywhere that
reads `location.hash` to scroll to the target after hydration (`scrollIntoView` count: 0;
`hashchange` listeners: 0; the only `location.hash` reference in the bundle is Supabase's auth client
*clearing* the hash during `_getSessionFromURL`). So the browser's native "scroll to #id" is
overridden on load, and nothing restores it. Supabase's hash-clearing can also strip the fragment
outright.

**Fix:** after hydration, if `location.hash` is present, scroll its target into view (and make
`ScrollToTop` skip when a hash is present). Minimal React sketch:

```jsx
useEffect(() => {
  const { hash } = window.location;
  if (!hash) return;
  const el = document.getElementById(hash.slice(1));
  if (el) requestAnimationFrame(() => el.scrollIntoView({ behavior: "auto", block: "start" }));
}, []);
```

Guard the existing `ScrollToTop` with `if (window.location.hash) return;` so the two don't fight.

---

### M1 — ~49 MB of media on the page (MEDIUM)

Measured directly from the origin (deduped, uncompressed transfer):

| Class | Files | Weight |
|---|---|---|
| Video (`.mp4`) | 11 | ~32.2 MB |
| Images (`.png`) | 17 | ~16.2 MB |
| Main JS (gzip) | 1 | 0.18 MB |
| **Total media** | — | **~48–49 MB** |

Heaviest single assets: `spiral-crystal.mp4` **12.4 MB**, `rice-cooker-scroll.mp4` 5.3 MB,
`cp-02-communications.mp4` 4.2 MB, `cp-01-systems.mp4` 3.6 MB, `cp-03-intelligence.mp4` 3.4 MB.
Media loads progressively as you scroll (not all upfront), and Range + immutable caching are in
place, so repeat visits are cheap — but a first visit on a phone or metered connection pays the full
tab. **Fix:** re-encode the hero/loop videos (H.264 → AV1/HEVC or at least tighter H.264 CRF + lower
bitrate; a silent decorative loop rarely needs >1–2 MB), cap dimensions to display size, and
consider a poster-first / play-on-visible pattern for the below-the-fold clips.

### M2 — Content images are oversized PNGs where WebP/AVIF belongs (MEDIUM)

`unicorn-card.png` is **2.9 MB** (1920×1433); `dangote-preview.png` 1.8 MB, `ia-sub-1.png` 1.8 MB,
`pierce-sub-1.png` 1.7 MB, and several more sit at 1.2–1.4 MB. These are photographic/mockup
visuals shipped as PNG at up to 1920 px. Converting to WebP or AVIF and sizing to the actual
display box typically cuts 70–85%. The pipeline already emits WebP for the social share image
(`og:image` is `.webp`), so this is a settings change, not new tooling. Serving `srcset`/`sizes`
(or `<picture>`) would also stop phones downloading desktop-scale art.

### M3 — Background videos ignore `prefers-reduced-motion` (MEDIUM, accessibility)

The site partly honors reduced-motion — it skips loading the Lenis smooth-scroll engine and drops
into a reduced animation mode (also triggered by coarse pointer / narrow width / low CPU). But the
autoplaying, looping background crystal videos keep playing under
`prefers-reduced-motion: reduce` (verified: a background clip was still un-paused mid-section with
the reduce flag set). axe flags `no-autoplay-audio` on 5 videos (they're muted, so no audio, but the
*motion* is the issue for this user group). **Fix:** when `prefers-reduced-motion: reduce` matches,
pause/omit the decorative video loops (swap to a poster frame) alongside the existing scroll/anim
downgrade.

### M4 — Contact form fields have no programmatic labels (MEDIUM, accessibility)

The three inputs (name, email, message) carry only `placeholder` text — no `<label>`, `aria-label`,
`id`, `name`, or `autocomplete`. Placeholders vanish on focus and are not reliable accessible names,
so this fails WCAG 1.3.1 / 4.1.2 and defeats browser autofill. The "Select type / Scope / Budget"
choices are `<button>` toggles with no `role`/`aria-pressed`, so their selected state isn't exposed
to assistive tech. **Fix:** add visually-hidden `<label for>` (or `aria-label`) to each field, set
`autocomplete="name|email"`, and give the toggles `aria-pressed` (or use radio/checkbox semantics).

### M5 — No `<main>`, `<nav>`, or `<footer>` landmarks (MEDIUM, accessibility)

axe: `landmark-one-main` (0 main landmarks) and `region` (55 nodes of content outside any landmark).
A `<header>` exists, but the primary content and the contact area aren't wrapped in landmarks, so
screen-reader rotor/region navigation has nothing to jump to. **Fix:** wrap the page body in
`<main>`, mark the nav ring/menu as `<nav aria-label="Primary">`, and add a `<footer>`.

### M6 — Missing hardening headers: CSP, X-Frame-Options, Permissions-Policy (MEDIUM, security)

Present and good: `Strict-Transport-Security` (1 yr + subdomains), `X-Content-Type-Options: nosniff`,
`Referrer-Policy: strict-origin-when-cross-origin`. Missing: **no Content-Security-Policy**
(no restriction on script/style/connect sources), **no X-Frame-Options / `frame-ancestors`**
(clickjackable in an iframe), **no Permissions-Policy**. **Fix:** add `X-Frame-Options: DENY` (or
CSP `frame-ancestors 'none'`), a starter `Permissions-Policy` locking down camera/mic/geolocation,
and a CSP (report-only first) allowing self + the Google Fonts / Storage / Supabase origins the app
actually uses.

---

### L1 — Leftover Lovable template artifacts shipped to production (LOW)

In the live `<head>`: `<meta name="author" content="Lovable">`,
`<meta name="twitter:site" content="@Lovable">`, and a literal
`<!-- TODO: Update og:title to match your application name -->` comment. A social share currently
attributes the brand's Twitter card to **@Lovable**. **Fix:** set author to The Onyx Office, set
`twitter:site` to the brand handle (or remove it), delete the TODO.

### L2 — SEO metadata gaps (LOW)

No `<link rel="canonical">`, no `og:url`, no `og:site_name`, no `og:image:alt`, no JSON-LD
structured data, and no `sitemap.xml` (returns 404). The `<title>` is a bare "the Onyx Office"
(lowercase "the", no positioning keywords). **Fix:** add canonical + `og:url`, an
`Organization`/`ProfessionalService` JSON-LD block, a one-line sitemap, and a title like
"The Onyx Office — Digital Systems, Visual Direction & Emerging Intelligence".

### L3 — Image alt text is mostly empty or generic (LOW, accessibility)

Only 3 of 16 content images have alt text; the rest are `alt=""`. Some empties are fine (decorative
crystal art), but project screenshots convey meaning and should describe the work. One existing alt
is truncated ("GOVERNMENT AFFAIRS AN"), another just repeats its heading. **Fix:** write descriptive
alt for the case-study visuals; keep `alt=""` only for purely decorative layers.

### L4 — Keyboard focus indicator is nearly invisible on primary nav (LOW, accessibility)

Several ring/menu links compute `outline: solid 2px rgba(0,0,0,0)` — a transparent outline — so a
keyboard user can't see where focus is. Some buttons do get a visible ring, so it's inconsistent.
**Fix:** give every interactive element a visible `:focus-visible` style (a light outline or ring
that reads on the near-black background).

### L5 — Mobile menu: Escape doesn't close it, and focus isn't managed (LOW)

The hamburger menu opens correctly, but pressing Escape does not close it and focus is not moved
into or trapped within the panel. **Fix:** close on Escape, move focus to the first item on open,
return focus to the toggle on close.

### L6 — Contact form posts directly to Supabase with the public anon key (LOW — owner verification)

The form inserts into the `contact_enquiries` table on `lkpxgpsikgnbwztncgtb.supabase.co` using the
anon key embedded in the bundle. This is the normal Supabase pattern (anon keys are public by
design), **but its safety depends entirely on Row-Level Security.** Two owner actions:
1. Confirm RLS allows INSERT but **denies SELECT** with the anon key, so the public key can't read
   back everyone's submitted names/emails/messages (a PII leak if misconfigured). I did not test
   this — sending the token to the third-party host was out of scope for this audit — so please
   verify it directly.
2. The endpoint is an unauthenticated public insert with client-only validation (it checks that
   name/email are non-empty, nothing else). Add a honeypot field and/or rate limiting to blunt spam.

### L7 — Soft 404 (LOW)

Unknown routes return HTTP 200 with the homepage shell (standard SPA behavior). Acceptable, but
there's no real not-found view. Consider a `/404` route for clarity and to avoid indexing dead URLs
as the homepage.

---

## What's already good (keep it)

- **No console errors, no page exceptions, no failed requests** on the real origin.
- **Clean transport:** HTTPS, HSTS (1 yr, includeSubDomains), nosniff, sane Referrer-Policy.
- **Smart caching:** hashed assets are `cache-control: immutable, max-age=1yr`; video supports HTTP
  Range (206) for seek/streaming.
- **Fast shell:** TTFB ~0.2–0.7 s (Cloudflare), 11 KB HTML, 179 KB gzip JS in ~0.43 s.
- **Stable layout:** CLS 0, single H1, sensible H2/H3 hierarchy, no horizontal overflow at 390 px or
  1440 px.
- **Code splitting:** the landing page loads only its own chunk; the larger app's routes are lazy.
- **Reduced-motion is partly respected** (Lenis disabled, animation quality reduced) — M3 just asks
  to extend that to the video loops.
- **Design craft:** the dark onyx/glass system, the spiral orbit nav, and the scroll-driven gallery
  are cohesive and well-tuned.

---

## Priority order

1. **H1** — fix hash deep-linking (the shared URL is broken). Small, high-leverage.
2. **M1 / M2** — compress video + convert PNGs to WebP/AVIF. Biggest real-world speed win.
3. **M4 / M5 / M3** — form labels, landmarks, reduced-motion for video. Accessibility floor.
4. **M6** — add CSP / X-Frame-Options / Permissions-Policy headers.
5. **L1 / L2** — strip Lovable template leftovers, fill SEO metadata.
6. **L3–L7** — alt text, focus ring, menu Escape, verify Supabase RLS, 404 view.
