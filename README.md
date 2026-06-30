# DevFlow Agent Project

An AI-assisted software delivery project governed by the AI-DLC methodology.

---

## What This Is
This project is built by an AI agent (Claude Code / Cursor / GitHub Copilot) following
a strict intent-driven delivery process. Every feature starts with a written intent,
every bolt is validated against acceptance criteria, and every bug triggers a full
GitHub issue + PR lifecycle.

---

## Tech Stack
| Layer | Technology |
|-------|-----------|
| Frontend | React 18 + TypeScript + Tailwind CSS |
| Backend | .NET Core 8 Web API |
| Database | PostgreSQL + Entity Framework Core |
| Auth | JWT Bearer tokens |
| Tests | xUnit (backend) + Vitest (frontend) |

---

## How to Work in This Project

### Starting a session
- Claude Code → reads `CLAUDE.md` automatically
- Cursor → reads `.cursorrules` automatically
- GitHub Copilot → reads `.github/copilot-instructions.md` automatically

### Adding a new feature
1. Create an intent file: `ai-dlc/intents/intent-{NNN}-{name}.md`
2. Fill in goal + acceptance criteria
3. Tell the agent: "Read intent-{NNN} and plan the bolts"
4. Agent presents plan — confirm to start build

### Checking progress
- Open `ai-dlc/ops/build/backlog.md`

### When a bug is found
- Agent automatically creates GitHub issue + fix branch + PR
- Review and merge the PR to continue

---

## Key Files
| File | Purpose |
|------|---------|
| `CLAUDE.md` | Agent brain — rules for Claude Code |
| `.cursorrules` | Agent rules for Cursor |
| `.github/copilot-instructions.md` | Agent rules for GitHub Copilot |
| `ai-dlc/ops/build/backlog.md` | Live bolt tracker |
| `ai-dlc/rules/architecture.md` | Architecture decisions |
| `ai-dlc/rules/code-standards.md` | Coding conventions |
| `ai-dlc/rules/security.md` | Security rules |
| `ai-dlc/guidelines/dev-setup.md` | Local setup guide |

---

## Developer Setup
See `ai-dlc/guidelines/dev-setup.md`
