import { describe, test, expect } from 'bun:test';
import { spawnSync } from 'child_process';
import * as path from 'path';
import * as fs from 'fs';
import * as os from 'os';

const ROOT = path.resolve(import.meta.dir, '..');
const PROVISIONER = path.join(ROOT, 'scripts', 'provision-external-skills.sh');
const HOOK = path.join(ROOT, '.claude', 'hooks', 'session-start.sh');
const SETUP_SRC = fs.readFileSync(path.join(ROOT, 'setup'), 'utf-8');
const HOOK_SRC = fs.readFileSync(HOOK, 'utf-8');

// Run the provisioner against a throwaway HOME so a developer's real
// ~/.agents or ~/.gstack can neither leak into the assertions nor be mutated
// by them. Every probe the script makes is HOME-relative, so this fully
// isolates it.
function runInSandbox(
  args: string[],
  env: Record<string, string> = {},
): { status: number | null; stdout: string; stderr: string; home: string } {
  const home = fs.mkdtempSync(path.join(os.tmpdir(), 'gstack-extskills-'));
  const res = spawnSync('bash', [PROVISIONER, ...args], {
    encoding: 'utf-8',
    timeout: 30_000,
    env: {
      ...process.env,
      HOME: home,
      GSTACK_HOME: path.join(home, '.gstack'),
      // Empty PATH entry for tools would break bash itself; instead rely on
      // the sandboxed HOME making every "already installed" probe fail.
      GSTACK_EXTERNAL_SKILLS: '',
      ...env,
    },
  });
  return { status: res.status, stdout: res.stdout ?? '', stderr: res.stderr ?? '', home };
}

describe('provision-external-skills: executability + shape', () => {
  test('provisioner and hook are executable', () => {
    expect(fs.statSync(PROVISIONER).mode & 0o111).toBeGreaterThan(0);
    expect(fs.statSync(HOOK).mode & 0o111).toBeGreaterThan(0);
  });

  test.skipIf(process.platform === 'win32')('provisioner passes bash syntax check', () => {
    const res = spawnSync('bash', ['-n', PROVISIONER], { encoding: 'utf-8' });
    expect(res.stderr).toBe('');
    expect(res.status).toBe(0);
  });

  test.skipIf(process.platform === 'win32')('hook passes bash syntax check', () => {
    const res = spawnSync('bash', ['-n', HOOK], { encoding: 'utf-8' });
    expect(res.stderr).toBe('');
    expect(res.status).toBe(0);
  });
});

describe.skipIf(process.platform === 'win32')('provision-external-skills: opt-in gate', () => {
  // The whole safety story rests on this: an un-opted-in run must not install
  // 50MB of third-party skills. If this regresses, every gstack user pays.
  test('--if-enabled is a silent no-op with no marker and no env opt-in', () => {
    const { status, stdout, home } = runInSandbox(['--if-enabled']);
    expect(status).toBe(0);
    expect(stdout.trim()).toBe('');
    // Nothing was created under the sandboxed HOME.
    expect(fs.existsSync(path.join(home, '.agents'))).toBe(false);
  });

  test('--check never mutates and reports MISSING on a clean HOME', () => {
    const { status, stdout, home } = runInSandbox(['--check']);
    // Exit 1 == "not fully provisioned", the documented contract.
    expect(status).toBe(1);
    expect(stdout).toContain('agent-reach:');
    expect(stdout).toContain('nvidia/skills:');
    expect(stdout).toContain('MISSING');
    expect(fs.existsSync(path.join(home, '.agents'))).toBe(false);
  });

  test('an existing marker file flips the gate on', () => {
    // Prove the gate reads the marker: with it present, --if-enabled stops
    // being silent and starts doing work (we assert it *begins*, not that it
    // completes — completion needs network).
    const home = fs.mkdtempSync(path.join(os.tmpdir(), 'gstack-extskills-'));
    const gstackHome = path.join(home, '.gstack');
    fs.mkdirSync(gstackHome, { recursive: true });
    fs.writeFileSync(path.join(gstackHome, 'external-skills-enabled'), '');
    const res = spawnSync('bash', [PROVISIONER, '--if-enabled', '--check'], {
      encoding: 'utf-8',
      timeout: 30_000,
      env: { ...process.env, HOME: home, GSTACK_HOME: gstackHome },
    });
    // --check short-circuits before any install, so this stays hermetic while
    // still proving the marker path is wired.
    expect(res.stdout).toContain('opt-in marker:');
    expect(res.stdout).toContain('external-skills-enabled');
  });
});

describe('provision-external-skills: setup wiring', () => {
  test('setup parses --external-skills and --no-external-skills', () => {
    expect(SETUP_SRC).toContain('--external-skills)    EXTERNAL_SKILLS_MODE="yes"');
    expect(SETUP_SRC).toContain('--no-external-skills) EXTERNAL_SKILLS_MODE="no"');
  });

  test('setup defaults external skills to OFF', () => {
    // The default must stay empty-string (= leave alone). A default of "yes"
    // would push 323 third-party skills onto every gstack user.
    expect(SETUP_SRC).toMatch(/EXTERNAL_SKILLS_MODE=""\s/);
  });

  test('setup invokes the provisioner script rather than inlining the logic', () => {
    expect(SETUP_SRC).toContain('scripts/provision-external-skills.sh');
  });

  test('--no-external-skills clears the marker but does not delete skills', () => {
    const idx = SETUP_SRC.indexOf('EXTERNAL_SKILLS_MODE" = "no"');
    expect(idx).toBeGreaterThan(-1);
    const block = SETUP_SRC.slice(idx, idx + 700);
    expect(block).toContain('rm -f "$_EXTERNAL_SKILLS_MARKER"');
    // Guard against someone "helpfully" making this destructive later.
    expect(block).not.toContain('rm -rf');
  });
});

describe.skipIf(process.platform === 'win32')('provision-external-skills: SessionStart hook', () => {
  test('hook is inert outside a remote container', () => {
    // Simulates a contributor laptop: CLAUDE_CODE_REMOTE unset.
    const home = fs.mkdtempSync(path.join(os.tmpdir(), 'gstack-extskills-'));
    const res = spawnSync('bash', [HOOK], {
      encoding: 'utf-8',
      timeout: 30_000,
      env: { ...process.env, HOME: home, CLAUDE_PROJECT_DIR: ROOT, CLAUDE_CODE_REMOTE: '' },
    });
    expect(res.status).toBe(0);
    expect(res.stdout.trim()).toBe('');
    expect(fs.existsSync(path.join(home, '.agents'))).toBe(false);
  });

  test('hook gates on CLAUDE_CODE_REMOTE', () => {
    expect(HOOK_SRC).toContain('CLAUDE_CODE_REMOTE');
  });

  test('hook can never fail the session', () => {
    // A non-zero exit from a SessionStart hook degrades the user's session for
    // an entirely optional install. Both belts must stay on.
    expect(HOOK_SRC).toContain('|| true');
    expect(HOOK_SRC.trimEnd().endsWith('exit 0')).toBe(true);
  });

  test('hook runs synchronously (no async mode)', () => {
    // Async would return before the skills land, so the agent would build its
    // skill list without them — the install would not appear until the NEXT
    // session, defeating the purpose.
    expect(HOOK_SRC).not.toContain('"async"');
  });
});
