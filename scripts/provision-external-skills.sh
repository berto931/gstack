#!/usr/bin/env bash
# provision-external-skills.sh — install third-party agent skills that are NOT
# part of the gstack repo, so they survive an ephemeral container rebuild.
#
# Two payloads today:
#   1. Agent Reach (https://github.com/Panniantong/agent-reach) — a Python CLI
#      that routes internet access (web/YouTube/RSS/Exa/V2EX/Bilibili) and
#      installs its own skill into ~/.claude/skills/agent-reach.
#   2. NVIDIA/skills (https://github.com/NVIDIA/skills) — the full skill catalog
#      installed via the `skills` CLI into ~/.agents/skills, symlinked into
#      every detected agent directory.
#
# WHY THIS IS OPT-IN: `./setup` is gstack's public installer. Every gstack
# user runs it. Neither payload belongs to gstack, and the NVIDIA catalog
# alone adds ~60K tokens of skill descriptions to EVERY agent session plus a
# ~50MB download. So nothing here runs unless explicitly asked for, via:
#   ./setup --external-skills          (one-shot, this machine)
#   GSTACK_EXTERNAL_SKILLS=1           (env opt-in)
#   ~/.gstack/external-skills-enabled  (marker; what --external-skills writes)
#
# SURVIVING A CONTAINER REBUILD: the marker above is NOT what does it — it
# lives in $HOME, which an ephemeral container wipes along with everything
# else. Only the repo survives a rebuild, so the restore instruction has to be
# checked in. That is .claude/hooks/session-start.sh, which calls this script
# with --if-enabled and GSTACK_EXTERNAL_SKILLS=1 on every session start. That
# hook gates on $CLAUDE_CODE_REMOTE so it fires in disposable web containers
# and stays out of the way on contributor laptops.
#
# SUPPLY-CHAIN NOTE: both payloads are third-party code fetched at install time
# (agent-reach from its git repo, the NVIDIA catalog via `npx skills`). Version
# pinning is intentionally NOT baked in here — see PROVISION_PINNING below and
# the PR discussion. Treat this script as executing code you have chosen to
# trust from those two upstreams.
#
# Modes:
#   (none)        provision now, unconditionally
#   --if-enabled  provision only when opted in; silent no-op otherwise
#   --check       report status only, never mutate (exit 0 = fully provisioned)
#   --quiet       suppress progress chatter
#
# EXIT CODE CONTRACT: this script exits 0 even when a payload fails to
# install. It runs from a SessionStart hook, where a non-zero exit degrades
# the user's session for something entirely optional. Failures are reported on
# stderr and re-attempted on the next run. --check is the one exception: it
# exits 1 when provisioning is incomplete, so tests and humans can assert.
# An UNKNOWN flag exits 2 (see the arg loop) — a typo must not silently fall
# through to the unconditional-install default.

set -uo pipefail

GSTACK_HOME_DIR="${GSTACK_HOME:-$HOME/.gstack}"
ENABLE_MARKER="$GSTACK_HOME_DIR/external-skills-enabled"
LOCK_FILE="$GSTACK_HOME_DIR/.external-skills.lock"
# Completion stamp for the NVIDIA catalog. We write this OURSELVES only after
# `npx skills add` returns 0 — we do NOT probe an upstream-authored file. A
# sentinel like nvidia-skill-finder/SKILL.md is written at an uncontrolled
# point in the installer's run order (so a mid-install kill leaves it present
# with the catalog incomplete) and can be renamed/dropped upstream (so every
# session would reinstall 50MB forever). Our own stamp has neither failure mode.
NVIDIA_STAMP="$GSTACK_HOME_DIR/.nvidia-skills-provisioned"
AGENT_REACH_SKILL="$HOME/.claude/skills/agent-reach/SKILL.md"

# Two install sources, tried in order. Upstream's docs recommend the codeload
# archive, but some egress proxies (including Claude Code on the web's) allow
# git traffic while returning 403 for codeload archive paths. git+https works
# in both places, so it leads; the archive stays as a fallback for hosts with
# no git binary.
AGENT_REACH_SRC_GIT="git+https://github.com/Panniantong/agent-reach.git"
AGENT_REACH_SRC_ZIP="https://github.com/Panniantong/agent-reach/archive/main.zip"
NVIDIA_SKILLS_PKG="nvidia/skills"

MODE="provision"
QUIET=0
while [ $# -gt 0 ]; do
  case "$1" in
    --if-enabled) MODE="if-enabled"; shift ;;
    --check)      MODE="check"; shift ;;
    -q|--quiet)   QUIET=1; shift ;;
    # Unknown flag → hard error. Falling through to `shift` would silently keep
    # MODE=provision (the unconditional-install default), so a typo like
    # `--if-enbaled` would bypass the opt-in gate and install 50MB anyway.
    *) echo "provision-external-skills: unknown argument: $1" >&2; exit 2 ;;
  esac
done

log()  { [ "$QUIET" -eq 0 ] && echo "$@" || true; }
warn() { echo "$@" >&2; }

# Run one install step, keeping its output only if it fails. Swallowing stderr
# outright turns every failure into an unactionable "install failed" — the
# real cause here has been things like a proxy CA the tool could not verify,
# which is invisible without the underlying message.
run_step() {
  local label="$1"; shift
  local out rc
  out="$("$@" 2>&1)"; rc=$?
  if [ $rc -ne 0 ]; then
    warn "  $label failed (exit $rc):"
    printf '%s\n' "$out" | tail -5 | sed 's/^/    /' >&2
  fi
  return $rc
}

# ─── Opt-in gate ──────────────────────────────────────────────
external_skills_enabled() {
  [ -f "$ENABLE_MARKER" ] && return 0
  case "${GSTACK_EXTERNAL_SKILLS:-}" in
    1|yes|true) return 0 ;;
  esac
  return 1
}

# ─── Status probes ────────────────────────────────────────────
# Agent Reach installs its CLI to a user-level bin that is not always on PATH
# in a non-login shell, so probe the known locations too.
agent_reach_bin() {
  if command -v agent-reach >/dev/null 2>&1; then
    command -v agent-reach
    return 0
  fi
  for candidate in "$HOME/.local/bin/agent-reach" "$HOME/.agent-reach-venv/bin/agent-reach"; do
    if [ -x "$candidate" ]; then
      echo "$candidate"
      return 0
    fi
  done
  return 1
}

# "Installed" means the TERMINAL artifact is present, not just the binary. The
# feature exists to restore ~/.claude/skills/agent-reach; that skill is written
# by phase 2 (`agent-reach install --env=auto`), which can fail while the phase-1
# binary install already succeeded. Probing only the binary let a skill-write
# failure self-certify as healthy and never retry (the exact silent-partial the
# whole feature is supposed to prevent). Require BOTH: skill on disk AND a
# working binary.
agent_reach_installed() { [ -f "$AGENT_REACH_SKILL" ] && agent_reach_bin >/dev/null 2>&1; }
nvidia_skills_installed() { [ -f "$NVIDIA_STAMP" ]; }

# Count entries actually contributed by the NVIDIA catalog. agent-reach also
# writes into ~/.agents/skills, so a bare `ls | wc -l` over-attributes its own
# dir to the NVIDIA payload — the number a human reads to judge whether the
# catalog install completed. Exclude the known non-NVIDIA entry.
nvidia_skill_count() {
  local d="$HOME/.agents/skills"
  [ -d "$d" ] || { echo 0; return; }
  ls "$d" 2>/dev/null | grep -vxF 'agent-reach' | wc -l | tr -d ' '
}

# ─── Payload 1: Agent Reach ───────────────────────────────────

# Try the git source, then the archive, running each attempt exactly ONCE.
# The previous shape ran a silent attempt and then a second run_step attempt
# on failure purely to capture output — doubling the network cost on the exact
# path where the network is already broken, and occasionally turning the
# "diagnostic" retry into an undeclared third install. Here we capture every
# attempt's output and surface it only if BOTH sources fail, so a git-only
# failure (e.g. proxy blocks git) is still visible instead of masked by the
# zip error.
_install_agent_reach_cli() {
  local installer_desc="$1"; shift  # remaining args = the installer command
  local src out rc first_err="" second_err=""
  local i=0
  for src in "$AGENT_REACH_SRC_GIT" "$AGENT_REACH_SRC_ZIP"; do
    i=$((i + 1))
    out="$("$@" "$src" 2>&1)"; rc=$?
    if [ $rc -eq 0 ]; then
      return 0
    fi
    if [ $i -eq 1 ]; then first_err="$out"; else second_err="$out"; fi
  done
  warn "  agent-reach: $installer_desc failed for both git and archive sources."
  warn "    git source error (tail):"
  printf '%s\n' "$first_err" | tail -3 | sed 's/^/      /' >&2
  warn "    archive source error (tail):"
  printf '%s\n' "$second_err" | tail -3 | sed 's/^/      /' >&2
  return 1
}

install_agent_reach() {
  # Terminal-artifact fast path: skill present AND binary works → nothing to do.
  if agent_reach_installed; then
    log "  agent-reach: already installed ($(agent_reach_bin))"
    return 0
  fi

  # Install the CLI only if the binary is genuinely missing. Re-running
  # `uv tool install` on an already-installed binary just burns a network round
  # trip and can cascade into the archive fallback — so guard on the binary,
  # not on the (possibly-missing) skill artifact.
  if ! agent_reach_bin >/dev/null 2>&1; then
    log "  agent-reach: installing CLI..."
    # Preference order: uv tool → pipx → dedicated venv. uv and pipx both give
    # an isolated tool venv with a stable shim on PATH. A dedicated venv is the
    # last resort; plain `pip install --user` is intentionally NOT used because
    # on PEP 668 distros it fails outright.
    if command -v uv >/dev/null 2>&1; then
      _install_agent_reach_cli "uv tool install" uv tool install
    elif command -v pipx >/dev/null 2>&1; then
      _install_agent_reach_cli "pipx install" pipx install
    elif command -v python3 >/dev/null 2>&1; then
      if run_step "  agent-reach: venv create" python3 -m venv "$HOME/.agent-reach-venv"; then
        _install_agent_reach_cli "venv pip install" "$HOME/.agent-reach-venv/bin/pip" install -q
      fi
    else
      warn "  agent-reach: no uv, pipx, or python3 found — cannot install CLI"
    fi
  fi

  local ar
  ar="$(agent_reach_bin 2>/dev/null)" || {
    warn "  agent-reach: not on PATH after install — skipping channel setup"
    return 0
  }

  # yt-dlp and feedparser ship inside agent-reach's own tool venv, where
  # `shutil.which("yt-dlp")` and a bare `import feedparser` cannot see them.
  # Agent Reach's doctor then reports YouTube and RSS as broken even though
  # the wheels are on disk. Install both where the channels actually look.
  if ! command -v yt-dlp >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/yt-dlp" ]; then
    log "  agent-reach: installing yt-dlp onto PATH..."
    if command -v uv >/dev/null 2>&1; then
      run_step "  yt-dlp: uv tool install" uv tool install "yt-dlp[default]"
    elif command -v pipx >/dev/null 2>&1; then
      run_step "  yt-dlp: pipx install" pipx install "yt-dlp[default]"
    else
      warn "  yt-dlp: no uv or pipx — YouTube channel will be degraded"
    fi
  fi
  if ! python3 -c "import feedparser" >/dev/null 2>&1; then
    log "  agent-reach: installing feedparser for the RSS channel..."
    # --user FIRST. --break-system-packages mutates the distro-managed system
    # site-packages (PEP 668 protection exists precisely to stop that) and this
    # path also runs on contributor laptops via `./setup --external-skills`, so
    # the polite install has to lead. --break-system-packages is the fallback
    # for minimal containers where --user isn't available.
    python3 -m pip install -q --user feedparser >/dev/null 2>&1 \
      || python3 -m pip install -q --break-system-packages feedparser >/dev/null 2>&1 \
      || warn "  feedparser install failed — RSS channel will be degraded"
  fi

  # YouTube extraction needs an external JS runtime. yt-dlp only reads this
  # from its config file, so write it once (idempotent, append-if-absent).
  # Guard the append with a trailing-newline fixup: yt-dlp treats an unknown
  # option in its config as FATAL for every invocation, so concatenating onto a
  # file whose last line lacks a newline would corrupt an existing option and
  # break yt-dlp entirely.
  local ytdlp_cfg="${XDG_CONFIG_HOME:-$HOME/.config}/yt-dlp/config"
  if command -v node >/dev/null 2>&1; then
    mkdir -p "$(dirname "$ytdlp_cfg")"
    if ! grep -qxF -- '--js-runtimes node' "$ytdlp_cfg" 2>/dev/null; then
      # If the file exists and its last byte is not a newline, add one first.
      if [ -s "$ytdlp_cfg" ] && [ -n "$(tail -c1 "$ytdlp_cfg" 2>/dev/null)" ]; then
        printf '\n' >> "$ytdlp_cfg"
      fi
      printf '%s\n' '--js-runtimes node' >> "$ytdlp_cfg"
    fi
  fi

  # ORDERING BUG THIS GUARDS AGAINST: agent-reach only installs its skill into
  # skill dirs that ALREADY EXIST (its loop is gated on os.path.isdir). On a
  # freshly rebuilt container ~/.claude/skills does not exist yet, so it
  # silently falls back to creating ~/.agents/skills/agent-reach alone and the
  # skill never becomes visible to Claude Code. Creating the directory first
  # is what makes a clean rebuild match a warm one.
  mkdir -p "$HOME/.claude/skills"

  # Installs gh CLI + mcporter + Exa config, then writes the agent-reach skill
  # into every detected agent dir. Safe to re-run: it skips what it finds.
  log "  agent-reach: configuring channels (agent-reach install --env=auto)..."
  run_step "  agent-reach: channel setup" "$ar" install --env=auto \
    || warn "  agent-reach: run 'agent-reach doctor' to inspect remaining channels"
}

# ─── Payload 2: NVIDIA skills ─────────────────────────────────
install_nvidia_skills() {
  if nvidia_skills_installed; then
    log "  nvidia/skills: already installed ($(nvidia_skill_count) skills in ~/.agents/skills)"
    return 0
  fi
  if ! command -v npx >/dev/null 2>&1; then
    warn "  nvidia/skills: npx not found (needs Node.js) — skipped"
    return 0
  fi
  log "  nvidia/skills: installing the NVIDIA catalog (~50MB, this takes a minute)..."
  # --all == --skill '*' --agent '*' -y. Files land once in ~/.agents/skills and
  # are symlinked into each agent dir, so the disk cost is paid a single time.
  # Write our own completion stamp ONLY on success, so a mid-install kill leaves
  # no stamp and the next session retries (see NVIDIA_STAMP rationale above).
  if run_step "  nvidia/skills: npx skills add" \
       npx -y skills@latest add "$NVIDIA_SKILLS_PKG" --all -g; then
    mkdir -p "$GSTACK_HOME_DIR"
    : > "$NVIDIA_STAMP"
  else
    warn "  nvidia/skills: re-run './setup --external-skills' to retry"
  fi
}

# ─── Status reporting ─────────────────────────────────────────
report_status() {
  local ar_state="MISSING" nv_state="MISSING"
  agent_reach_installed && ar_state="ok"
  nvidia_skills_installed && nv_state="ok ($(nvidia_skill_count) skills in ~/.agents/skills)"
  echo "external skills status:"
  echo "  agent-reach:   $ar_state"
  echo "  nvidia/skills: $nv_state"
  echo "  opt-in marker: $([ -f "$ENABLE_MARKER" ] && echo "$ENABLE_MARKER" || echo 'absent')"
}

# ─── Provisioning driver (holds the concurrency lock) ─────────
do_provision() {
  install_agent_reach
  install_nvidia_skills
}

# ─── Main ─────────────────────────────────────────────────────
case "$MODE" in
  check)
    report_status
    if agent_reach_installed && nvidia_skills_installed; then exit 0; else exit 1; fi
    ;;
  if-enabled)
    external_skills_enabled || exit 0
    # Fast path: both payloads present, nothing to do. This is the common case
    # on every session start after the first, and must stay cheap.
    if agent_reach_installed && nvidia_skills_installed; then exit 0; fi
    log "Restoring external skills after container rebuild..."
    ;;
esac

# Serialize concurrent runs. Two Claude sessions can start in one container at
# once; without a lock both would run `npx skills add` into the same tree and
# both create/populate ~/.agent-reach-venv concurrently, a documented pip
# corruption path. Non-blocking: if another run holds the lock it is already
# doing the work, so we exit cleanly. flock is Linux/util-linux; on hosts
# without it (stock macOS) we proceed unlocked, which is fine because the
# unlocked case is a single interactive `./setup` invocation, not racing
# session-start hooks.
mkdir -p "$GSTACK_HOME_DIR"
if command -v flock >/dev/null 2>&1; then
  exec 9>"$LOCK_FILE"
  if ! flock -n 9; then
    log "External skills: another provisioning run is in progress — skipping."
    exit 0
  fi
  # Re-check under the lock: the other holder may have just finished.
  if [ "$MODE" = "if-enabled" ] && agent_reach_installed && nvidia_skills_installed; then
    exit 0
  fi
fi

do_provision

if [ "$MODE" != "if-enabled" ]; then
  log ""
  report_status
fi
exit 0
