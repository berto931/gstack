#!/bin/bash
# SessionStart hook — restore external (non-gstack) agent skills after a
# container rebuild.
#
# Claude Code on the web runs in an ephemeral container: the repo is cloned
# fresh and $HOME is empty. Anything installed into ~/.claude/skills or
# ~/.agents/skills in a previous session is gone. The repo is the only thing
# that survives, so the restore instruction has to live here.
#
# WHY THIS GATES ON $CLAUDE_CODE_REMOTE: the payloads it installs (Agent Reach
# + the 323-skill NVIDIA catalog) are third-party, not part of gstack, and the
# NVIDIA catalog alone adds ~60K tokens of skill descriptions to every session
# plus a 50MB download. A contributor cloning gstack on their laptop must not
# inherit that. Remote containers are the case the user asked for, and they
# are disposable, so that is the only place this fires automatically. Local
# users opt in explicitly with `./setup --external-skills`.
#
# WHY SYNCHRONOUS (no async mode): agent skills are enumerated when the
# session starts. If this returned early and installed in the background, the
# skills would land after the agent had already built its skill list and would
# not be visible until the NEXT session — defeating the point. The container
# image is cached after the hook completes, so the slow first install is paid
# once per environment rebuild, not once per session. Every later run hits the
# provisioner's already-installed fast path and exits in milliseconds.
set -uo pipefail

# Local machine, or a non-remote harness: do nothing.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

PROVISIONER="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}/scripts/provision-external-skills.sh"
[ -x "$PROVISIONER" ] || exit 0

# GSTACK_EXTERNAL_SKILLS=1 is the opt-in the provisioner looks for. Being in a
# remote container IS the opt-in, since the marker file it would normally read
# lives in $HOME and does not survive the rebuild.
#
# Never fail the session over an optional third-party install: the provisioner
# already exits 0 on payload failure, and `|| true` covers the rest.
GSTACK_EXTERNAL_SKILLS=1 "$PROVISIONER" --if-enabled || true
exit 0
