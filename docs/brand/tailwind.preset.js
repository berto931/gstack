/**
 * ArmoSpectra Brand System v1.0 — Tailwind preset
 *
 * Usage:
 *   // tailwind.config.js
 *   module.exports = { presets: [require('./docs/brand/tailwind.preset.js')], content: [...] }
 *
 * Dark is the default, not a theme. This preset does not ship a light palette.
 * Do not enable `darkMode` and auto-invert — light is a separate project with
 * its own contrast study.
 */

module.exports = {
  theme: {
    extend: {
      colors: {
        ink: {
          900: '#050507', // page base, deepest corners
          800: '#0B0B0F', // primary surface, cards
          700: '#131318', // raised panel, inputs
          600: '#1C1C22', // hairlines, borders
          500: '#26262E', // disabled, inert
        },
        blue: {
          300: '#BFDBFF',
          400: '#6BB4FF',
          500: '#3B8EF0',
          600: '#1F63C4',
          800: '#0E2E5C',
        },
        gray: {
          200: '#D8DADE',
          400: '#9AA0A8',
          600: '#5A5F66',
        },
      },

      fontFamily: {
        display: ['Montserrat', 'Archivo', 'Helvetica Neue', 'system-ui', 'sans-serif'],
        script: ['Great Vibes', 'Snell Roundhand', 'cursive'],
        // Documentation utility only. Never in client-facing surfaces.
        mono: ['JetBrains Mono', 'SFMono-Regular', 'ui-monospace', 'monospace'],
      },

      fontSize: {
        'display-xl': ['84px', { lineHeight: '0.94', letterSpacing: '-0.005em' }],
        'display-l': ['58px', { lineHeight: '0.96', letterSpacing: '-0.005em' }],
        'display-m': ['40px', { lineHeight: '1', letterSpacing: '-0.005em' }],
        heading: ['21px', { lineHeight: '1.15' }],
        lede: ['19px', { lineHeight: '1.55' }],
        body: ['16px', { lineHeight: '1.5' }],
        label: ['14px', { lineHeight: '1', letterSpacing: '0.28em' }],
        caption: ['13px', { lineHeight: '1.45' }],
        eyebrow: ['12px', { lineHeight: '1', letterSpacing: '0.22em' }],
        micro: ['11px', { lineHeight: '1.4' }],
      },

      letterSpacing: {
        wordmark: '0.32em',
        label: '0.28em',
        eyebrow: '0.22em',
        nav: '0.18em',
      },

      // Base unit 8px. Seven values only.
      spacing: {
        1: '8px',
        2: '16px',
        3: '24px',
        5: '40px',
        7: '56px',
        9: '72px',
        12: '96px',
        'capability-row': '74px',
        'icon-box': '44px',
        'cta': '56px',
      },

      borderRadius: {
        card: '12px',
        pill: '9999px',
      },

      maxWidth: {
        measure: '66ch',
      },

      backgroundImage: {
        // Display type only. Max two words. Never below 48px.
        chrome: 'linear-gradient(180deg,#FFFFFF 0%,#DCE9FF 30%,#7FB6F5 62%,#2E6FD0 100%)',
        ambient: 'radial-gradient(120% 120% at 75% 0%,#1A1B20 0%,#050507 70%)',
        divider: 'linear-gradient(90deg,#1C1C22 0%,#3B8EF0 85%,transparent 100%)',
        bloom: 'radial-gradient(60% 100% at 50% 100%,rgba(59,142,240,.45) 0%,rgba(5,5,7,0) 70%)',
      },

      boxShadow: {
        glow: '0 0 40px rgba(59,142,240,.35)',
        'glow-soft': '0 0 24px rgba(59,142,240,.30)',
        'focus-ring': '0 0 0 3px rgba(59,142,240,.16)',
      },

      // Logo stencil. Set `--as-logo` to the official artwork and
      // `--as-logo-ratio` to its exact intrinsic ratio; every instance follows.
      // The deck currently ships interim placeholder geometry in this slot.
      maskImage: {
        logo: 'var(--as-logo)',
      },

      transitionTimingFunction: {
        brand: 'cubic-bezier(.22,.61,.36,1)',
      },
      transitionDuration: {
        brand: '400ms',
      },
    },
  },

  plugins: [
    function ({ addComponents, addUtilities }) {
      addUtilities({
        // Rule 04 — chrome gradient on display type, with a solid fallback
        // for renderers that drop background-clip.
        '.text-chrome': {
          background: 'linear-gradient(180deg,#FFFFFF 0%,#DCE9FF 30%,#7FB6F5 62%,#2E6FD0 100%)',
          '-webkit-background-clip': 'text',
          backgroundClip: 'text',
          '-webkit-text-fill-color': 'transparent',
          color: '#BFDBFF',
          filter: 'drop-shadow(0 0 26px rgba(59,142,240,.30))',
        },
      });

      addComponents({
        // Rule 11 — outlined pill. White on Blue 500 is 3.33:1 and fails AA.
        '.btn-brand': {
          display: 'inline-flex',
          alignItems: 'center',
          justifyContent: 'center',
          height: '56px',
          padding: '0 40px',
          borderRadius: '9999px',
          border: '1px solid #3B8EF0',
          background: 'transparent',
          color: '#FFFFFF',
          fontFamily: 'Montserrat, sans-serif',
          fontSize: '14px',
          fontWeight: '500',
          textTransform: 'uppercase',
          letterSpacing: '0.28em',
          transition: 'border-color .25s, box-shadow .25s, color .25s',
          '&:hover': {
            borderColor: '#6BB4FF',
            boxShadow: '0 0 40px rgba(59,142,240,.35)',
            color: '#BFDBFF',
          },
          '&:focus-visible': { outline: '2px solid #6BB4FF', outlineOffset: '3px' },
        },
        // Size by height only; width follows from the master's ratio.
        // Setting both width and height is the one way to distort the mark.
        '.logo-brand': {
          display: 'inline-block',
          flex: 'none',
          aspectRatio: 'var(--as-logo-ratio)',
          backgroundColor: 'currentColor',
          color: '#FFFFFF',
          '-webkit-maskImage': 'var(--as-logo)',
          maskImage: 'var(--as-logo)',
          '-webkit-maskSize': 'contain',
          maskSize: 'contain',
          '-webkit-maskRepeat': 'no-repeat',
          maskRepeat: 'no-repeat',
          '-webkit-maskPosition': 'center',
          maskPosition: 'center',
        },
        '.logo-brand-ink': { color: '#050507' },
        '.logo-brand-watermark': { opacity: '0.22' },
        '.divider-brand': {
          height: '1px',
          border: '0',
          background: 'linear-gradient(90deg,#1C1C22 0%,#3B8EF0 85%,transparent 100%)',
        },
        '.rule-brand': {
          width: '70px',
          height: '2px',
          border: '0',
          background: '#3B8EF0',
          boxShadow: '0 0 40px rgba(59,142,240,.35)',
        },
      });
    },
  ],
};
