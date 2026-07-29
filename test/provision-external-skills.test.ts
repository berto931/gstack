import { describe, test, expect, afterAll } from 'bun:test';
import { spawnSync } from 'child_process';
import * as path from 'path';
import * as fs from 'fs';
import * as os from 'os';

const ROOT = path.resolve(import.meta.dir, '..');
const PROVISIONER = path.join(ROOT, 'scripts', 'provision-external-skills.sh');
const HOOK = path.join(ROOT, '.claude', 'hooks', 'session-start.sh');
const SETTINGS = path.join(ROOT, '.claude', 'settings.json');
const SETUP_SRC = fs.readFileSync(path.join(ROOT, 'setup'), 'utf-8');
const HOOK_SRC = fs.readFileSync(HOOK, 'utf-8');

const IS_WIN = process.platform === 'win32';

// Every sandbox HOME/dir created here is tracked and removed in afterAll so
// os.tmpdir() doesn't accumulate gstack-extskills-* dirs across runs.
const _tmpDirs: string[] = [];
function mkTmp(prefix = 'gstack-extskills-'): string {
  const d = fs.mkdtempSync(path.join(os.tmpdir(), prefix));
  _tmpDirs.push(d);
  return d;
}
afterAll(() => {
  for (const d of _tmpDirs) {
    try { fs.rmSync(d, { recursive: true, force: true }); } catch {}
  }
});

// A hermetic bin dir holding ONLY bash + coreutils — deliberately no python3,
// uv, pipx, npx, pip, or node. This makes every install probe fail fast (so the
// tests never touch the network) AND makes the "MISSING"/gate assertions
// deterministic instead of operator-dependent — the earlier version inherited
// process.env.PATH and passed only by luck. Real /usr/bin is excluded on
// purpose: it contains python3, which would otherwise send the provisioner's
// venv fallback down a real network install and hang the test.
const HERMETIC_BIN = (() => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'gstack-hermbin-'));
  const allow = [
    'bash', 'sh', 'env', 'grep', 'sed', 'tail', 'head', 'ls', 'wc', 'tr', 'cat',
    'rm', 'touch', 'mkdir', 'dirname', 'basename', 'cut', 'flock', 'chmod', 'cp',
    'mv', 'sleep', 'date', 'find', 'mktemp', 'sort', 'uniq', 'xargs',
  ];
  for (const t of allow) {
    for (const base of ['/usr/bin', '/bin']) {
      const p = path.join(base, t);
      if (fs.existsSync(p)) { try { fs.symlinkSync(p, path.join(dir, t)); } catch {} break; }
    }
  }
  return dir;
})();
afterAll(() => { try { fs.rmSync(HERMETIC_BIN, { recursive: true, force: true }); } catch {} });

function controlledPath(): string {
  return HERMETIC_BIN;
}

// Run the provisioner against a throwaway HOME AND a controlled PATH, so a
// developer's real ~/.agents, ~/.gstack, or globally-installed agent-reach can
// neither leak into the assertions nor be mutated by them.
function runInSandbox(
  args: string[],
  env: Record<string, string> = {},
): { status: number | null; stdout: string; stderr: string; home: string } {
  const home = mkTmp();
  const res = spawnSync('bash', [PROVISIONER, ...args], {
    encoding: 'utf-8',
    timeout: 30_000,
    env: {
      HOME: home,
      GSTACK_HOME: path.join(home, '.gstack'),
      PATH: controlledPath(),
      // Clear any ambient opt-in from the developer's own shell so it can't
      // flip the gate under a test that expects it closed.
      GSTACK_EXTERNAL_SKILLS: '',
      ...env,
    },
  });
  return { status: res.status, stdout: res.stdout ?? '', stderr: res.stderr ?? '', home };
}

describe('provision-external-skills: executability + shape', () => {
  test.skipIf(IS_WIN)('provisioner and hook are executable', () => {
    // Unix exec bit only. On Windows, libuv doesn't surface it for .sh files,
    // so this would spuriously fail — the whole feature is Unix-only anyway.
    expect(fs.statSync(PROVISIONER).mode & 0o111).toBeGreaterThan(0);
    expect(fs.statSync(HOOK).mode & 0o111).toBeGreaterThan(0);
  });

  test.skipIf(IS_WIN)('provisioner passes bash syntax check', () => {
    const res = spawnSync('bash', ['-n', PROVISIONER], { encoding: 'utf-8' });
    expect(res.stderr).toBe('');
    expect(res.status).toBe(0);
  });

  test.skipIf(IS_WIN)('hook passes bash syntax check', () => {
    const res = spawnSync('bash', ['-n', HOOK], { encoding: 'utf-8' });
    expect(res.stderr).toBe('');
    expect(res.status).toBe(0);
  });
});

describe.skipIf(IS_WIN)('provision-external-skills: opt-in gate', () => {
  // The whole safety story rests on this: an un-opted-in run must not install
  // 50MB of third-party skills. If this regresses, every gstack user pays.
  test('--if-enabled is a silent no-op with no marker and no env opt-in', () => {
    const { status, stdout, home } = runInSandbox(['--if-enabled']);
    expect(status).toBe(0);
    expect(stdout.trim()).toBe('');
    expect(fs.existsSync(path.join(home, '.agents'))).toBe(false);
  });

  test('--check never mutates and reports MISSING on a clean HOME', () => {
    const { status, stdout, home } = runInSandbox(['--check']);
    // Exit 1 == "not fully provisioned", the documented contract.
    expect(status).toBe(1);
    expect(stdout).toContain('agent-reach:   MISSING');
    expect(stdout).toContain('nvidia/skills: MISSING');
    expect(fs.existsSync(path.join(home, '.agents'))).toBe(false);
  });

  test('unknown flag exits 2 instead of falling through to install', () => {
    // A typo must NOT leave MODE=provision (unconditional install). This is the
    // gate's last line of defense against `--if-enbaled` silently installing.
    const { status, stderr } = runInSandbox(['--if-enbaled']);
    expect(status).toBe(2);
    expect(stderr).toContain('unknown argument');
  });

  test('--if-enabled proceeds past the gate when the marker is present', () => {
    // With the marker present and a PATH lacking every installer, the gate
    // must OPEN (print the restore line) and then no-op cleanly — proving the
    // marker actually flips the gate, which the old --if-enabled --check test
    // never did (check-mode won and short-circuited before the gate).
    const home = mkTmp();
    const gs = path.join(home, '.gstack');
    fs.mkdirSync(gs, { recursive: true });
    fs.writeFileSync(path.join(gs, 'external-skills-enabled'), '');
    const res = spawnSync('bash', [PROVISIONER, '--if-enabled'], {
      encoding: 'utf-8',
      timeout: 30_000,
      // PATH has coreutils but NO uv/pipx/npx/python3, so both installs fail
      // fast and the run stays hermetic (no network, no real install).
      env: { HOME: home, GSTACK_HOME: gs, PATH: controlledPath() },
    });
    expect(res.status).toBe(0);
    expect(res.stdout).toContain('Restoring external skills');
  });

  test('GSTACK_EXTERNAL_SKILLS=0 stays a closed gate', () => {
    const { status, stdout } = runInSandbox(['--if-enabled'], { GSTACK_EXTERNAL_SKILLS: '0' });
    expect(status).toBe(0);
    expect(stdout.trim()).toBe('');
  });

  test('exit code stays 0 even when an install path fails (session-safety contract)', () => {
    // Opted in, PATH lacks every installer → both payloads fail → the script
    // must still exit 0, because a non-zero exit from the SessionStart hook
    // degrades the user's session for an optional feature.
    const home = mkTmp();
    const gs = path.join(home, '.gstack');
    fs.mkdirSync(gs, { recursive: true });
    const res = spawnSync('bash', [PROVISIONER], {
      encoding: 'utf-8',
      timeout: 30_000,
      env: { HOME: home, GSTACK_HOME: gs, PATH: controlledPath(), GSTACK_EXTERNAL_SKILLS: '1' },
    });
    expect(res.status).toBe(0);
  });
});

describe('provision-external-skills: setup wiring', () => {
  test('setup parses --external-skills and --no-external-skills', () => {
    // Whitespace-tolerant so a reformat of the case statement doesn't cry wolf.
    expect(SETUP_SRC).toMatch(/--external-skills\)\s+EXTERNAL_SKILLS_MODE="yes"/);
    expect(SETUP_SRC).toMatch(/--no-external-skills\)\s+EXTERNAL_SKILLS_MODE="no"/);
  });

  test('setup defaults external skills to OFF', () => {
    // The default must stay empty-string (= leave alone). A default of "yes"
    // would push the third-party skills onto every gstack user.
    expect(SETUP_SRC).toMatch(/EXTERNAL_SKILLS_MODE=""\s/);
  });

  test('setup invokes the provisioner script rather than inlining the logic', () => {
    expect(SETUP_SRC).toContain('scripts/provision-external-skills.sh');
  });

  test('--no-external-skills clears the marker but does not delete skills', () => {
    const idx = SETUP_SRC.indexOf('EXTERNAL_SKILLS_MODE" = "no"');
    expect(idx).toBeGreaterThan(-1);
    // Bound the block by the next `fi` rather than a fixed char slice.
    const fiIdx = SETUP_SRC.indexOf('\nfi', idx);
    const block = SETUP_SRC.slice(idx, fiIdx > idx ? fiIdx : idx + 700);
    expect(block).toContain('rm -f "$_EXTERNAL_SKILLS_MARKER"');
    // Guard against someone "helpfully" making this destructive later.
    expect(block).not.toContain('rm -rf');
  });
});

describe('provision-external-skills: settings.json wiring', () => {
  // settings.json is the piece that actually makes the hook fire. A JSON typo
  // or a wrong path silently disables the whole feature (Claude Code skips
  // malformed hooks) while every other test still passes — so validate it
  // structurally here.
  const cfg = JSON.parse(fs.readFileSync(SETTINGS, 'utf-8'));
  const entry = cfg?.hooks?.SessionStart?.[0]?.hooks?.[0];

  test('registers a SessionStart command hook pointing at session-start.sh', () => {
    expect(entry).toBeTruthy();
    expect(entry.type).toBe('command');
    expect(entry.command).toContain('.claude/hooks/session-start.sh');
  });

  test('quotes $CLAUDE_PROJECT_DIR so a path with spaces survives', () => {
    expect(entry.command).toContain('"$CLAUDE_PROJECT_DIR"');
  });

  test('hook is synchronous — async would land skills after the skill list is built', () => {
    // This is the real home of the async knob (NOT the shell script). Async
    // mode would return before the skills exist, so they wouldn't appear until
    // the NEXT session, defeating the restore.
    expect(entry.async).toBeUndefined();
    expect(entry.timeout).toBeGreaterThan(0);
  });
});

describe.skipIf(IS_WIN)('provision-external-skills: SessionStart hook', () => {
  test('hook is inert outside a remote container', () => {
    // Contributor laptop: CLAUDE_CODE_REMOTE unset → the hook must do nothing.
    const home = mkTmp();
    const res = spawnSync('bash', [HOOK], {
      encoding: 'utf-8',
      timeout: 30_000,
      env: { HOME: home, PATH: controlledPath(), CLAUDE_PROJECT_DIR: ROOT, CLAUDE_CODE_REMOTE: '' },
    });
    expect(res.status).toBe(0);
    expect(res.stdout.trim()).toBe('');
    expect(fs.existsSync(path.join(home, '.agents'))).toBe(false);
  });

  test('hook invokes the provisioner with --if-enabled + opt-in when remote', () => {
    // Positive path: point CLAUDE_PROJECT_DIR at a sandbox whose provisioner is
    // a stub that records its argv + env, and assert the hook calls it exactly
    // as designed. This is what proves the gate/path/env handoff actually works
    // in a remote container, which no prior test covered.
    const proj = mkTmp('gstack-hookpos-');
    fs.mkdirSync(path.join(proj, 'scripts'), { recursive: true });
    const stub = path.join(proj, 'scripts', 'provision-external-skills.sh');
    fs.writeFileSync(stub, '#!/bin/bash\necho "args=$* opt=${GSTACK_EXTERNAL_SKILLS:-}"\n');
    fs.chmodSync(stub, 0o755);
    const res = spawnSync('bash', [HOOK], {
      encoding: 'utf-8',
      timeout: 30_000,
      env: { HOME: mkTmp(), PATH: controlledPath(), CLAUDE_PROJECT_DIR: proj, CLAUDE_CODE_REMOTE: 'true' },
    });
    expect(res.status).toBe(0);
    expect(res.stdout).toContain('args=--if-enabled opt=1');
  });

  test('hook exits 0 when the provisioner is missing', () => {
    // The [ -x ] guard: a checkout without the script must not error the session.
    const proj = mkTmp('gstack-hooknoprov-');
    const res = spawnSync('bash', [HOOK], {
      encoding: 'utf-8',
      timeout: 30_000,
      env: { HOME: mkTmp(), PATH: controlledPath(), CLAUDE_PROJECT_DIR: proj, CLAUDE_CODE_REMOTE: 'true' },
    });
    expect(res.status).toBe(0);
  });

  test('hook source gates on CLAUDE_CODE_REMOTE and can never fail the session', () => {
    expect(HOOK_SRC).toContain('CLAUDE_CODE_REMOTE');
    expect(HOOK_SRC).toContain('|| true');
    expect(HOOK_SRC.trimEnd().endsWith('exit 0')).toBe(true);
  });
});
