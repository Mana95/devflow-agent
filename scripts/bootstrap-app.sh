#!/usr/bin/env bash
#
# Scaffold a new app repo that consumes the dev-agent brain as a git submodule.
#
# Creates a self-contained app repository (its own git) with:
#   - the dev-agent embedded at ./dev-agent as a git submodule
#   - a thin ./CLAUDE.md that imports the brain (@dev-agent/CLAUDE.md)
#   - app-root ai-dlc/ state (project-config.md configured:false, blank backlog,
#     blank discovery, intent template, blank architecture/glossary/skill-base)
#   - src/ placeholder and a .gitignore
#
# Reusable rules (code-standards, security, harness-governance, infrastructure) are NOT
# copied — they stay in the submodule so `git submodule update --remote dev-agent` pulls
# the latest brain without touching this app's state.
#
# Usage:
#   scripts/bootstrap-app.sh <app-name> <dev-agent-url> [app-path]
#
# Example:
#   scripts/bootstrap-app.sh sales-app https://github.com/you/dev-agent.git
#
set -euo pipefail

APP_NAME="${1:-}"
DEV_AGENT_URL="${2:-}"
APP_PATH="${3:-}"

if [[ -z "$APP_NAME" || -z "$DEV_AGENT_URL" ]]; then
    echo "Usage: $0 <app-name> <dev-agent-url> [app-path]" >&2
    exit 1
fi

if [[ -z "$APP_PATH" ]]; then
    APP_PATH="$(dirname "$(pwd)")/$APP_NAME"
fi

echo "==> Bootstrapping app '$APP_NAME' at: $APP_PATH"

if [[ -d "$APP_PATH" ]] && [[ -n "$(ls -A "$APP_PATH" 2>/dev/null | grep -v '^\.git$' || true)" ]]; then
    echo "Target path '$APP_PATH' already exists and is not empty. Aborting." >&2
    exit 1
fi
mkdir -p "$APP_PATH"
cd "$APP_PATH"

# 1. Fresh git repo for the app
[[ -d .git ]] || { git init >/dev/null; echo "    git init done"; }

# 2. Embed the dev-agent brain as a submodule
if [[ ! -d dev-agent ]]; then
    echo "==> Adding dev-agent submodule from $DEV_AGENT_URL"
    git submodule add "$DEV_AGENT_URL" dev-agent
    git submodule update --init --recursive
fi

BRAIN="dev-agent"
[[ -f "$BRAIN/CLAUDE.md" ]] || { echo "dev-agent submodule did not populate. Check the URL." >&2; exit 1; }

# 3. Thin wrapper CLAUDE.md that imports the brain
cat > CLAUDE.md <<EOF
# $APP_NAME — App Rules (thin wrapper)

This app consumes the **dev-agent brain** as a git submodule at \`./dev-agent\`.
The full agent rules live there and are imported below.

@dev-agent/CLAUDE.md

---

## App-specific overrides
<!-- Add rules that should extend or override the brain for THIS app only. -->
EOF

mkdir -p .github
echo "# Rules for this app live in the dev-agent submodule. See dev-agent/.cursorrules and dev-agent/CLAUDE.md." > .cursorrules
echo "# Rules for this app live in the dev-agent submodule. See dev-agent/.github/copilot-instructions.md and dev-agent/CLAUDE.md." > .github/copilot-instructions.md

# 4. App-root ai-dlc/ state, copied from the brain templates (single source of truth)
mkdir -p ai-dlc/intents ai-dlc/discovery ai-dlc/ops/build ai-dlc/rules ai-dlc/guidelines src tests

copy_if_present() { [[ -f "$1" ]] && cp -f "$1" "$2" || echo "  (skipped, not in brain: $1)"; }
copy_if_present "$BRAIN/ai-dlc/project-config.md"             "ai-dlc/project-config.md"
copy_if_present "$BRAIN/ai-dlc/ops/build/backlog.md"          "ai-dlc/ops/build/backlog.md"
copy_if_present "$BRAIN/ai-dlc/discovery/discovery-report.md" "ai-dlc/discovery/discovery-report.md"
copy_if_present "$BRAIN/ai-dlc/intents/intent-template.md"    "ai-dlc/intents/intent-template.md"
copy_if_present "$BRAIN/ai-dlc/rules/architecture.md"         "ai-dlc/rules/architecture.md"
copy_if_present "$BRAIN/ai-dlc/guidelines/domain-glossary.md" "ai-dlc/guidelines/domain-glossary.md"
copy_if_present "$BRAIN/ai-dlc/guidelines/skill-base.md"      "ai-dlc/guidelines/skill-base.md"
copy_if_present "$BRAIN/.gitignore"                           ".gitignore"

touch src/.gitkeep tests/.gitkeep

cat <<EOF

==> Done. App scaffolded at $APP_PATH

Next steps:
  1. cd "$APP_PATH"
  2. Open the app with Claude Code and run First-Run Onboarding to lock the stack.
  3. Create the '$APP_NAME' GitHub repo, then:
     git remote add origin <url> && git push -u origin main

To pull the latest dev-agent brain later:
  git submodule update --remote dev-agent && git add dev-agent \\
    && git commit -m "chore: update dev-agent brain"
EOF
