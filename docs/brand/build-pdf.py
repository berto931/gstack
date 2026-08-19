#!/usr/bin/env python3
"""Render the ArmoSpectra brand deck to a print-ready PDF.

Each of the 23 spreads becomes one 16:9 page, scaled to fit so nothing clips.
Brand fonts are fetched from Google Fonts and embedded as base64 @font-face
rules, so the PDF carries its own typography and does not depend on the
reader having Montserrat installed.

    python3 build-pdf.py [-o armospectra-brand-deck.pdf]

Fonts: Montserrat and Great Vibes are SIL Open Font License 1.1;
JetBrains Mono is Apache License 2.0. All three are redistributable.
"""
import base64, os, re, sys, urllib.request

HERE = os.path.dirname(os.path.abspath(__file__))
DECK = os.path.join(HERE, 'armospectra-brand-deck.html')
OUT  = os.path.join(HERE, 'armospectra-brand-deck.pdf')

PAGE_W, PAGE_H = 1600, 900          # CSS px, 16:9
DPI = 96
UA = ("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36")
GF = ("https://fonts.googleapis.com/css2"
      "?family=Montserrat:wght@200;300;400;500;800;900"
      "&family=Great+Vibes"
      "&family=JetBrains+Mono:wght@400;500&display=swap")


def grain_tile(size=128, seed=7):
    """A seeded noise tile, generated once and reused by every page.

    The deck uses an SVG feTurbulence filter for grain. Chromium re-rasterizes
    that filter per page when printing, which cost 8.1 MB across 23 pages. A
    small tiled PNG carries the same anti-banding texture as one image object.
    """
    import io, random
    from PIL import Image
    random.seed(seed)
    img = Image.new('L', (size, size))
    img.putdata([random.randint(0, 255) for _ in range(size * size)])
    buf = io.BytesIO()
    img.save(buf, format='PNG', optimize=True)
    b64 = base64.b64encode(buf.getvalue()).decode('ascii')
    print(f"  grain     : {size}x{size} tile, {len(buf.getvalue()):,} bytes")
    return 'data:image/png;base64,' + b64


def get(url, headers=None):
    req = urllib.request.Request(url, headers=headers or {'User-Agent': UA})
    with urllib.request.urlopen(req, timeout=40) as r:
        return r.read()


def embed_fonts():
    """Fetch the Latin subsets and inline them as base64 @font-face rules.

    Montserrat and JetBrains Mono ship from Google Fonts as VARIABLE fonts —
    one file per subset covering the whole weight axis. Chromium renders those
    correctly on screen but does not embed them when printing to PDF; it
    substitutes a system font instead, so the deck came out set in DejaVu Sans
    while only the rasterised chrome-gradient words kept the real face.

    So: pull each variable font once, instantiate a STATIC instance at every
    weight the deck actually uses, and embed those. Static TrueType embeds
    cleanly. Great Vibes is already static and passes through untouched.
    """
    import io
    from fontTools.ttLib import TTFont
    from fontTools.varLib import instancer

    css = get(GF).decode('utf-8')

    # (family, subset) -> url, plus the weights each family needs.
    faces, weights = {}, {}
    for m in re.finditer(r'(?:/\*\s*([\w-]+)\s*\*/\s*)?(@font-face\s*\{[^}]*\})', css):
        subset, block = m.group(1), m.group(2)
        if subset not in ('latin', 'latin-ext'):
            continue
        fam = re.search(r"font-family:\s*'([^']+)'", block)
        wt  = re.search(r'font-weight:\s*([\d ]+);', block)
        url = re.search(r'url\((https://fonts\.gstatic\.com[^)]+)\)', block)
        if not (fam and url):
            continue
        fam = fam.group(1)
        faces.setdefault((fam, subset), url.group(1))
        if wt:
            for w in wt.group(1).split():
                weights.setdefault(fam, set()).add(int(w))

    out, n_static, n_inst = [], 0, 0
    for (fam, subset), url in sorted(faces.items()):
        blob = get(url)
        font = TTFont(io.BytesIO(blob), fontNumber=0)
        variable = 'fvar' in font

        if not variable:
            b64 = base64.b64encode(blob).decode('ascii')
            for w in sorted(weights.get(fam, {400})):
                out.append(_face(fam, w, b64, 'woff2', 'woff2'))
            n_static += 1
            font.close()
            continue

        for w in sorted(weights.get(fam, {400})):
            inst = instancer.instantiateVariableFont(
                TTFont(io.BytesIO(blob), fontNumber=0), {'wght': w}, inplace=False,
                updateFontNames=False, overlap=True)
            buf = io.BytesIO()
            inst.flavor = None                     # plain TTF: embeds cleanly
            inst.save(buf)
            out.append(_face(fam, w, base64.b64encode(buf.getvalue()).decode('ascii'),
                             'ttf', 'truetype'))
            inst.close()
            n_inst += 1
        font.close()

    css_out = '\n'.join(out)
    print(f"  fonts     : {n_inst} static instances from variable masters, "
          f"{n_static} already-static file(s) -> {len(css_out)//1024} KB")
    return css_out


def _face(family, weight, b64, ext, fmt):
    return (f"@font-face{{font-family:'{family}';font-style:normal;"
            f"font-weight:{weight};font-display:block;"
            f"src:url(data:font/{ext};base64,{b64}) format('{fmt}');}}")


PRINT_CSS = """
@page { size: %(w)fin %(h)fin; margin: 0; }
html, body { margin:0; padding:0; background:#050507; }
body::after { display:none !important; }              /* fixed overlay can't paginate */
.rail { display:none !important; }
* { -webkit-print-color-adjust:exact !important; print-color-adjust:exact !important; }
.pdfpage {
  width:%(pw)dpx; height:%(ph)dpx; overflow:hidden; position:relative;
  background:#050507; break-after:page; page-break-after:always;
}
.pdfpage:last-child { break-after:auto; page-break-after:auto; }
.pdfpage::after {           /* grain, re-anchored per page so every page gets it */
  content:""; position:absolute; inset:0; pointer-events:none; opacity:.035;
  background-image:url("%(grain)s"); background-repeat:repeat;
}
/* A 16:9 page has far less vertical room than a scrolling spread. Trim the
   spread's own padding for print so the fit comes from layout, not from
   shrinking the type. */
.spread { border-top:0 !important; padding:44px 0 !important; }
.spread .wrap { width:92%% !important; }
a { text-decoration:none !important; }
"""

# Fit each spread to the page ASPECT rather than scaling it uniformly into the
# page. Measuring at a wider width lets tall content redistribute horizontally,
# so the finished page is filled and the type stays large. Four passes converge
# well within a pixel or two; the width cap stops a very tall spread from being
# stretched into an unreadable line length.
PAGINATE_JS = """([pw, ph]) => {
  const TARGET = ph / pw, MAXW = 2560, PAD = 6;
  const out = [];
  document.querySelectorAll('.spread').forEach((sec, i) => {
    let W = pw;
    for (let pass = 0; pass < 4; pass++) {
      sec.style.width = W + 'px';
      const h = sec.getBoundingClientRect().height;
      const aspect = h / W;
      if (aspect <= TARGET) break;
      W = Math.min(MAXW, W * Math.sqrt(aspect / TARGET));
    }
    sec.style.width = W + 'px';
    const h = sec.getBoundingClientRect().height;
    const s = Math.min(pw / W, (ph - PAD) / h);
    const page = document.createElement('div');
    page.className = 'pdfpage';
    sec.parentNode.insertBefore(page, sec);
    page.appendChild(sec);
    sec.style.transformOrigin = 'top left';
    sec.style.transform = 'scale(' + s + ')';
    sec.style.marginTop = Math.max(0, (ph - h * s) / 2) + 'px';
    sec.style.marginLeft = Math.max(0, (pw - W * s) / 2) + 'px';
    out.push({ i, width: Math.round(W), naturalHeight: Math.round(h),
               scale: +s.toFixed(4), fill: +((W * s) / pw).toFixed(3) });
  });
  return out;
}"""


def main():
    out = OUT
    if '-o' in sys.argv:
        out = sys.argv[sys.argv.index('-o') + 1]

    from playwright.sync_api import sync_playwright
    chrome = '/opt/pw-browsers/chromium-1194/chrome-linux/chrome'
    if not os.path.exists(chrome):
        chrome = None

    print(f"\n  ArmoSpectra deck -> PDF\n  source    : {os.path.basename(DECK)}")
    fonts = embed_fonts()

    with sync_playwright() as pw:
        b = pw.chromium.launch(executable_path=chrome, args=['--no-sandbox'])
        pg = b.new_page(viewport={'width': PAGE_W, 'height': PAGE_H})
        pg.goto('file://' + DECK, wait_until='load')
        pg.add_style_tag(content=fonts)
        pg.add_style_tag(content=PRINT_CSS % {
            'w': PAGE_W / DPI, 'h': PAGE_H / DPI,
            'pw': PAGE_W, 'ph': PAGE_H, 'grain': grain_tile()})
        pg.evaluate("async () => { await document.fonts.ready; }")
        pg.wait_for_timeout(1200)

        stats = pg.evaluate(PAGINATE_JS, [PAGE_W, PAGE_H])
        pg.wait_for_timeout(600)

        fills = [s['fill'] for s in stats]
        print(f"  pages     : {len(stats)}")
        print(f"  width fill: min {min(fills):.3f}  mean {sum(fills)/len(fills):.3f}")
        print(f"  scale     : min {min(s['scale'] for s in stats):.3f}  "
              f"max {max(s['scale'] for s in stats):.3f}")
        worst = sorted(stats, key=lambda x: x['fill'])[:3]
        print("  least-filled pages: " + ", ".join(
            f"#{w['i']+1}(fill {w['fill']}, w{w['width']})" for w in worst))

        pg.pdf(path=out, width=f'{PAGE_W/DPI}in', height=f'{PAGE_H/DPI}in',
               print_background=True, margin={'top':'0','bottom':'0','left':'0','right':'0'},
               prefer_css_page_size=True)
        b.close()

    print(f"  written   : {out}  ({os.path.getsize(out):,} bytes)\n")


if __name__ == '__main__':
    main()
