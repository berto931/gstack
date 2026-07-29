#!/usr/bin/env bash
# provision-external-skills.sh — install third-party agent skills that are NOT
# part of the gstack repo, so they survive an ephemeral container rebuild.
#
# Two payloads today:
#   1. Agent Reach (https://github.com/Panniantong/agent-reach) — a Python CLI
#      that routes internet access (web/YouTube/RSS/Exa/V2EX/Bilibili) and
#      installs its own skill into ~/.claude/skills/agent-reach.
#   2. NVIDIA/skills (https://github.com/NVIDIA/skills) — 323 skills installed
#      via the `skills` CLI into ~/.agents/skills, symlinked into every
#      detected agent directory.
#
# WHY THIS IS OPT-IN: `./setup` is gstack's public installer. Every gstack
# user runs it. Neither payload belongs to gstack, and the NVIDIA catalog
# alone adds ~60K tokens of skill descriptions to EVERY agent session plus a
# 50MB download. So nothing here runs unless explicitly asked for, via:
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

set -uo pipefail

GSTACK_HOME_DIR="${GSTACK_HOME:-$HOME/.gstack}"
ENABLE_MARKER="$GSTACK_HOME_DIR/external-skills-enabled"
# Two install sources, tried in order. Upstream's docs recommend the codeload
# archive, but some egress proxies (including Claude Code on the web's) allow
# git traffic while returning 403 for codeload archive paths. git+https works
# in both places, so it leads; the archive stays as a fallback for hosts with
# no git binary.
AGENT_REACH_SRC_GIT="git+https://github.com/Panniantong/agent-reach.git"
AGENT_REACH_SRC_ZIP="https://github.com/Panniantong/agent-reach/archive/main.zip"
NVIDIA_SKILLS_PKG="nvidia/skills"
# Sentinel skill: present iff the NVIDIA catalog installed. Cheaper and more
# honest than counting 323 directories, which drifts as upstream adds skills.
NVIDIA_SENTINEL="$HOME/.agents/skills/nvidia-skill-finder/SKILL.md"

MODE="provision"
QUIET=0
while [ $# -gt 0 ]; do
  case "$1" in
    --if-enabled) MODE="if-enabled"; shift ;;
    --check)      MODE="check"; shift ;;
    -q|--quiet)   QUIET=1; shift ;;
    *) shift ;;
  esac
done

log()  { [ "$QUIET" -eq 0 ] && echo "$@" || true; }
warn() { echo "$@" >&2; }

# Run a install step, keeping its output only if it fails. Swallowing stderr
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

agent_reach_installed() { agent_reach_bin >/dev/null 2>&1; }
nvidia_skills_installed() { [ -f "$NVIDIA_SENTINEL" ]; }

# ─── Payload 1: Agent Reach ───────────────────────────────────
install_agent_reach() {
  if agent_reach_installed; then
    log "  agent-reach: already installed ($(agent_reach_bin))"
  else
    log "  agent-reach: installing..."
    # uv and pipx both give an isolated tool venv with a stable shim on PATH.
    # Plain `pip install --user` is the last resort: on PEP 668 distros it
    # fails outright, which is why it is not the first choice.
    # Try the git source, then the archive. Only the SECOND failure is worth
    # reporting loudly — a noisy first-attempt warning on every proxied host
    # would train people to ignore the output.
    for src in "$AGENT_REACH_SRC_GIT" "$AGENT_REACH_SRC_ZIP"; do
      if command -v uv >/dev/null 2>&1; then
        uv tool install "$src" >/dev/null 2>&1 && break
        [ "$src" = "$AGENT_REACH_SRC_ZIP" ] \
          && run_step "  agent-reach: uv tool install" uv tool install "$src"
      elif command -v pipx >/dev/null 2>&1; then
        pipx install "$src" >/dev/null 2>&1 && break
        [ "$src" = "$AGENT_REACH_SRC_ZIP" ] \
          && run_step "  agent-reach: pipx install" pipx install "$src"
      else
        python3 -m venv "$HOME/.agent-reach-venv" >/dev/null 2>&1
        "$HOME/.agent-reach-venv/bin/pip" install -q "$src" >/dev/null 2>&1 && break
        [ "$src" = "$AGENT_REACH_SRC_ZIP" ] \
          && run_step "  agent-reach: venv pip install" \
               "$HOME/.agent-reach-venv/bin/pip" install -q "$src"
      fi
    done
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
    fi
  fi
  if ! python3 -c "import feedparser" >/dev/null 2>&1; then
    log "  agent-reach: installing feedparser for the RSS channel..."
    python3 -m pip install -q --break-system-packages feedparser >/dev/null 2>&1 \
      || python3 -m pip install -q --user feedparser >/dev/null 2>&1 \
      || warn "  feedparser install failed — RSS channel will be degraded"
  fi

  # YouTube extraction needs an external JS runtime. yt-dlp only reads this
  # from its config file, so write it once (idempotent, append-if-absent).
  local ytdlp_cfg="${XDG_CONFIG_HOME:-$HOME/.config}/yt-dlp/config"
  if command -v node >/dev/null 2>&1; then
    mkdir -p "$(dirname "$ytdlp_cfg")"
    grep -qxF -- '--js-runtimes node' "$ytdlp_cfg" 2>/dev/null \
      || printf '%s\n' '--js-runtimes node' >> "$ytdlp_cfg"
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
    log "  nvidia/skills: already installed ($(ls "$HOME/.agents/skills" 2>/dev/null | wc -l | tr -d ' ') skills)"
    return 0
  fi
  if ! command -v npx >/dev/null 2>&1; then
    warn "  nvidia/skills: npx not found (needs Node.js) — skipped"
    return 0
  fi
  log "  nvidia/skills: installing 323 skills (~50MB, this takes a minute)..."
  # --all == --skill '*' --agent '*' -y. Files land once in ~/.agents/skills and
  # are symlinked into each agent dir, so the disk cost is paid a single time.
  run_step "  nvidia/skills: npx skills add" \
    npx -y skills@latest add "$NVIDIA_SKILLS_PKG" --all -g \
    || warn "  nvidia/skills: re-run './setup --external-skills' to retry"
}

# ─── Status reporting ─────────────────────────────────────────
report_status() {
  local ar_state="MISSING" nv_state="MISSING"
  agent_reach_installed && ar_state="ok"
  nvidia_skills_installed && nv_state="ok ($(ls "$HOME/.agents/skills" 2>/dev/null | wc -l | tr -d ' ') skills)"
  echo "external skills status:"
  echo "  agent-reach:   $ar_state"
  echo "  nvidia/skills: $nv_state"
  echo "  opt-in marker: $([ -f "$ENABLE_MARKER" ] && echo "$ENABLE_MARKER" || echo 'absent')"
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

install_agent_reach
install_nvidia_skills

if [ "$MODE" != "if-enabled" ]; then
  log ""
  report_status
fi
exit 0
