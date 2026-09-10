#!/usr/bin/env python3
"""Render preview JPEGs of selected deck spreads for PR review.

Fonts are embedded via build-pdf.py's own embed_fonts(), not left to the
deck's Google Fonts <link>. Rendering a file:// page in a container that
cannot reach fonts.gstatic.com silently falls back to DejaVu Sans, which is
how the first round of previews ended up showing the wrong typeface while
the PDF showed the right one. Sharing the embedder keeps them in step.

    python3 render-previews.py            # all six
    python3 render-previews.py cover logo # a subset
"""
import importlib.util, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
DECK = os.path.join(HERE, 'armospectra-brand-deck.html')
OUTDIR = os.path.join(HERE, 'previews')
SCALE = 2                      # retina, so type holds up when GitHub scales it

# name -> spread id. Titles live in the deck; see the id map in the PR body.
SPREADS = {
    'cover':      's00',       # cover
    'logo':       's03',       # Logo system
    'misuse':     's04',       # Logo misuse
    'web':        's16',       # website direction
    'social':     's17',       # social applications
    'collateral':'s19',       # business collateral
}


def _build_pdf_module():
    """build-pdf.py has a hyphen, so it needs loading by path."""
    spec = importlib.util.spec_from_file_location(
        'build_pdf', os.path.join(HERE, 'build-pdf.py'))
    mod = importlib.util.module_from_spec(spec)
    sys.dont_write_bytecode = True          # no __pycache__ beside the source
    spec.loader.exec_module(mod)
    return mod


def main():
    wanted = [a for a in sys.argv[1:] if not a.startswith('-')] or list(SPREADS)
    unknown = [w for w in wanted if w not in SPREADS]
    if unknown:
        sys.exit(f"unknown preview(s): {', '.join(unknown)}\n"
                 f"choose from: {', '.join(SPREADS)}")

    bp = _build_pdf_module()
    print(f"\n  ArmoSpectra previews\n  source    : {os.path.basename(DECK)}")
    fonts = bp.embed_fonts()

    from playwright.sync_api import sync_playwright
    chrome = '/opt/pw-browsers/chromium-1194/chrome-linux/chrome'
    if not os.path.exists(chrome):
        chrome = None

    os.makedirs(OUTDIR, exist_ok=True)
    with sync_playwright() as pw:
        b = pw.chromium.launch(executable_path=chrome, args=['--no-sandbox'])
        pg = b.new_page(viewport={'width': bp.PAGE_W, 'height': bp.PAGE_H},
                        device_scale_factor=SCALE)
        pg.goto('file://' + DECK, wait_until='load')
        pg.add_style_tag(content=fonts)
        pg.add_style_tag(content="""
          @media screen { .spread { break-after: auto } }
          html, body { background: #050507 }
        """)
        pg.evaluate("async () => { await document.fonts.ready; }")
        pg.wait_for_timeout(1200)

        # Prove the real face actually loaded before writing any file. A
        # preview set in the wrong typeface is worse than none: it looks
        # authoritative and is silently wrong.
        got = pg.evaluate("""() => {
          const el = document.querySelector('.spread h2, .spread h1, .spread');
          const fam = getComputedStyle(el).fontFamily;
          const ok = document.fonts.check('600 48px Montserrat');
          return {fam, ok};
        }""")
        if not got['ok']:
            b.close()
            sys.exit(f"  ABORT: Montserrat did not load (computed: {got['fam']}).\n"
                     f"  Previews would show fallback type. Not writing files.")
        print(f"  fonts     : Montserrat loaded ({got['fam'].split(',')[0]})")

        for name in wanted:
            sid = SPREADS[name]
            el = pg.query_selector(f'#{sid}')
            if el is None:
                b.close()
                sys.exit(f"  ABORT: spread #{sid} ({name}) not found in deck.")
            el.scroll_into_view_if_needed()
            pg.wait_for_timeout(250)
            path = os.path.join(OUTDIR, f'{name}.jpg')
            el.screenshot(path=path, type='jpeg', quality=88)
            box = el.bounding_box()
            print(f"  {name:<11} #{sid}  {int(box['width'])}x{int(box['height'])}  "
                  f"{os.path.getsize(path):,} bytes")
        b.close()
    print()


if __name__ == '__main__':
    main()
