#!/usr/bin/env python3
"""Install the official ArmoSpectra logo into the brand system.

Reads the vector master, computes its exact intrinsic aspect ratio, and writes
it into the two places that drive every logo surface:

    docs/brand/tokens.css                  --as-logo / --as-logo-ratio
    docs/brand/armospectra-brand-deck.html  same pair, in the stencil block

The artwork is never redrawn, recoloured, or resized. It is URL-encoded verbatim
into a data URI and used as a CSS mask.

    python3 install-logo.py [path/to/armospectra-logo.svg]

Run with --check to validate the master without writing anything.
"""
import re, sys, os
import xml.etree.ElementTree as ET
from urllib.parse import quote
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT = os.path.join(HERE, 'assets', 'armospectra-logo.svg')
SVG_NS = '{http://www.w3.org/2000/svg}'


def fail(msg):
    print(f"  FAIL  {msg}")
    sys.exit(1)


def parse_len(v):
    if v is None:
        return None
    m = re.match(r'^\s*([\d.]+)\s*(px|pt|mm|cm|in)?\s*$', v)
    return float(m.group(1)) if m else None


def intrinsic_ratio(root):
    """Exact width/height from viewBox, falling back to width/height attrs."""
    vb = root.get('viewBox')
    if vb:
        parts = re.split(r'[\s,]+', vb.strip())
        if len(parts) == 4:
            w, h = float(parts[2]), float(parts[3])
            if w > 0 and h > 0:
                return w, h, 'viewBox'
    w, h = parse_len(root.get('width')), parse_len(root.get('height'))
    if w and h:
        return w, h, 'width/height'
    fail("master has neither a usable viewBox nor width/height — cannot lock aspect ratio")


def validate(root, raw):
    """Checks that decide whether the mask will actually render."""
    warn = []

    imgs = root.iter(SVG_NS + 'image')
    if any(True for _ in imgs):
        fail("master embeds a raster <image>. Supply true vector paths, or the "
             "mark will pixelate at the sizes this system uses.")

    # A full-bleed background rect makes the alpha mask fully opaque, which
    # renders as a solid block instead of the mark.
    vb = root.get('viewBox')
    if vb:
        p = [float(x) for x in re.split(r'[\s,]+', vb.strip())]
        for rect in root.iter(SVG_NS + 'rect'):
            rw, rh = parse_len(rect.get('width')), parse_len(rect.get('height'))
            fillv = (rect.get('fill') or '').lower()
            if rw and rh and rw >= p[2] * 0.98 and rh >= p[3] * 0.98 and fillv not in ('none', ''):
                warn.append(f"full-bleed <rect fill=\"{fillv}\"> found — this is a background "
                            "plate and will mask as a solid block. Delete it from the master.")

    drawables = sum(1 for t in ('path', 'circle', 'ellipse', 'polygon', 'polyline', 'line')
                    for _ in root.iter(SVG_NS + t))
    if drawables == 0:
        fail("no drawable geometry found in the master")

    if len(raw) > 180_000:
        warn.append(f"master is {len(raw)//1024} KB — large for an inline data URI; "
                    "consider simplifying paths")
    return warn, drawables


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('-')]
    check_only = '--check' in sys.argv
    src = args[0] if args else DEFAULT

    print(f"\n  ArmoSpectra logo installer\n  master: {src}\n")

    if not os.path.exists(src):
        fail(f"not found: {src}\n        Commit the vector master to "
             f"docs/brand/assets/armospectra-logo.svg and re-run.")
    if not src.lower().endswith('.svg'):
        fail("this installer takes SVG. AI/EPS need Ghostscript or Inkscape, neither of "
             "which is available here — export to SVG first.")

    raw = open(src, encoding='utf-8').read()
    try:
        root = ET.fromstring(raw)
    except ET.ParseError as e:
        fail(f"master is not valid XML: {e}")

    w, h, srcattr = intrinsic_ratio(root)
    warn, drawables = validate(root, raw)

    ratio = Fraction(w).limit_denominator(10000) / Fraction(h).limit_denominator(10000)
    print(f"  OK    valid SVG, {drawables} drawable elements")
    print(f"  OK    intrinsic size {w:g} x {h:g} (from {srcattr})")
    print(f"  OK    aspect ratio  {w:g}/{h:g}  = {float(ratio):.5f}")
    for m in warn:
        print(f"  WARN  {m}")

    uri = 'data:image/svg+xml,' + quote(raw.strip(), safe="")
    print(f"  OK    data URI {len(uri):,} bytes")

    if check_only:
        print("\n  --check: nothing written.\n")
        return

    ratio_css = f"{w:g}/{h:g}"
    targets = [os.path.join(HERE, 'tokens.css'),
               os.path.join(HERE, 'armospectra-brand-deck.html')]
    for t in targets:
        s = open(t, encoding='utf-8').read()
        before = s
        s = re.sub(r'--as-logo:\s*[^;]+;', f'--as-logo:url("{uri}");', s, count=1)
        s = re.sub(r'--as-logo-ratio:\s*[^;]+;',
                   f'--as-logo-ratio:{ratio_css};', s, count=1)
        s = re.sub(r'--as-logo-installed:\s*0;', '--as-logo-installed:1;', s, count=1)
        if s == before:
            fail(f"no --as-logo token found in {os.path.basename(t)}")
        open(t, 'w', encoding='utf-8').write(s)
        print(f"  OK    patched {os.path.basename(t)}")

    print("\n  Installed. Remaining manual steps:")
    print("    1. Remove the ARTWORK PENDING banner from the logo spread (spread 03).")
    print("    2. Update the status lines in BRAND_SYSTEM.md section 3, README.md,")
    print("       tokens.json (logo.status), and assets/LOGO.md.")
    print("    3. Re-run the verification pass, then republish and update the PR.\n")


if __name__ == '__main__':
    main()
