# DevFlow Agent Project

An AI-assisted software delivery project governed by the AI-DLC methodology.

---

## What This Is
This project is built by an AI agent (Claude Code / Cursor / GitHub Copilot) following
a strict intent-driven delivery process.

Given a Jira ticket, GitHub issue, or epic, the agent:
0. **Brainstorms** the feature as a domain expert first — surfacing edge cases,
   alternative approaches, and commonly-needed business rules the requirement didn't
   mention, rather than transcribing whatever was pasted (skippable on request)
1. **Intakes** the ticket and, if it's an epic, splits it into individual feature intents (subtasks)
2. **Discovers** existing related work across Jira / GitHub / Figma / the codebase before building anything new
3. **Reasons** about the breakdown into bolts (smallest deployable units), checking the domain glossary and skill base so business logic stays consistent
4. **Waits for human approval** of the plan before writing any code
5. **Builds** one bolt at a time — writing a test plan first, then the code, then unit tests and E2E tests (using the frameworks chosen in `project-config.md`) for user-facing flows
6. **Validates** every bolt against its acceptance criteria — automated tests are the required gate; manual browser testing is optional
7. **Handles bugs** end-to-end — classifying severity, opening a GitHub issue, fixing on a branch, and raising a PR for review

Nothing is marked done without passing validation, and no code is written before the
plan is approved. The agent also follows explicit branch-before-build discipline and a
set of professional-team code-design standards (SOLID, DI via interfaces, no magic
numbers, explicit null-safety) — see `ai-dlc/rules/harness-governance.md` and
`ai-dlc/rules/code-standards.md`.

---

## Workflow Pattern
```
┌─────────────────────────────────────┐
│      BRAINSTORMING LAYER            │
│  Domain-expert discussion           │
│  Edge cases, alternatives, risks    │
│  (skippable on explicit request)    │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│         INTAKE LAYER                │
│  User submits requirements          │
│  ai-dlc requirement gathering       │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│         DISCOVERY LAYER             │
│  Check Jira / GitHub / Figma        │
│  Detect conflicts between sources   │
│  Map existing vs missing work       │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│         REASONING LAYER             │
│  Decide Mode 1 or Mode 2            │
│  Choose tech stack                  │
│  Create feature breakdown (Bolts)   │
│  Write plan to memory file          │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│      HUMAN APPROVAL CHECKPOINT  👤  │
│  Show plan to user                  │
│  User approves / adjusts            │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│         BUILD LAYER                 │
│  Build feature by feature (Bolts)   │
│  Generate tests alongside code      │
│  Validate against acceptance criteria│
│  Error recovery if build fails      │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│         AUDIT LAYER                 │
│  Log every decision made            │
│  Track what was built vs planned    │
│  Feed failures back as new rules    │
└─────────────────────────────────────┘
```

---

## Tech Stack — chosen per project
The stack is **not** fixed. On first run the agent asks whether you're starting a new
project or plugging into an existing one, then either interviews you for each layer
(frontend, backend, database, auth, styling, unit testing, E2E) or detects the stack
from an existing codebase. Your answers are written to `ai-dlc/project-config.md`,
which becomes the locked stack for that clone.

| Layer | Chosen in onboarding |
|-------|----------------------|
| Project type | new / existing |
| Domain | e.g. e-commerce, fintech, healthcare |
| Frontend | e.g. React, Vue, Angular, none |
| Backend | e.g. .NET, Node/Express, Django, Spring Boot |
| Database | e.g. PostgreSQL, MySQL, MongoDB, none |
| Auth | e.g. JWT, session cookies, OAuth |
| Styling | e.g. Tailwind, CSS Modules |
| Unit testing | e.g. xUnit, Vitest, Jest, pytest |
| E2E testing | e.g. Playwright, Cypress, none |
| Cloud | none until you choose a provider |

The React 18 + .NET 8 + PostgreSQL + JWT combination is the sample used in
`ai-dlc/examples/` — it's an illustration, not a requirement.

---

## Use dev-agent as a submodule (recommended for real apps)

This repo is a reusable **dev-agent brain**. For a real app, don't build inside this
repo — create the app as its **own repository** and embed the dev-agent inside it as a
git submodule. That keeps the app and the agent as two independent repos, while letting
the app pull the latest agent whenever it wants.

```
Workspace/
├── dev-agent/          ← this repo (the brain: CLAUDE.md, rules, ai-dlc/ templates)
└── sales-app/          ← your app, its OWN repo → pushed to the sales-app repository
    ├── .git
    ├── src/, package.json
    ├── CLAUDE.md        ← thin wrapper: just `@dev-agent/CLAUDE.md`
    ├── ai-dlc/          ← THIS app's state (project-config, intents, backlog, discovery)
    └── dev-agent/       ← git SUBMODULE → points at the dev-agent repo
```

**Create a new app** (run from the dev-agent repo):

```bash
scripts/bootstrap-app.sh sales-app https://github.com/<you>/dev-agent.git
```

```powershell
./scripts/bootstrap-app.ps1 -AppName sales-app -DevAgentUrl https://github.com/<you>/dev-agent.git
```

This scaffolds the app repo, adds the submodule, writes the thin `CLAUDE.md`, and seeds
the app-root `ai-dlc/` state from the brain templates. Then open the app with Claude Code
and run First-Run Onboarding to lock its stack.

**Pull the latest dev-agent into an app** (run from inside the app repo):

```bash
git submodule update --remote dev-agent
git add dev-agent && git commit -m "chore: update dev-agent brain"
```

The submodule is pinned to a specific dev-agent commit, so updates are **deliberate**:
an app keeps running the version it pinned until you explicitly run the command above.
App code and app-specific `ai-dlc/` state are never touched. Reusable rules
(`code-standards`, `security`, `harness-governance`, `infrastructure`) live only in the
submodule; per-app files (`project-config.md`, intents, backlog, discovery, ADRs,
glossary, skill-base) live at the app root. See CLAUDE.md → "Consumption Modes" for the
full file map.

**Clone an app that already uses the submodule:**

```bash
git clone <app-url> && cd <app> && git submodule update --init --recursive
```

---

## How to Work in This Project

### Starting a session
- Claude Code → reads `CLAUDE.md` automatically
- Cursor → reads `.cursorrules` automatically
- GitHub Copilot → reads `.github/copilot-instructions.md` automatically

### Adding a new feature
1. Describe the feature/epic to the agent (free text, or a ticket link) — it will
   brainstorm domain edge cases and open questions with you first (say "skip the
   brainstorm" to bypass this)
2. Agent creates an intent file: `ai-dlc/intents/intent-{NNN}-{name}.md` with goal + acceptance criteria
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
| `ai-dlc/rules/harness-governance.md` | Agent operating rules — branching discipline, external tool access, CI, lint gates |
| `ai-dlc/rules/code-standards.md` | Coding conventions, incl. Design & Maintainability and UI/Style standards |
| `ai-dlc/rules/security.md` | Security rules |
| `ai-dlc/guidelines/domain-glossary.md` | Canonical business terms |
| `ai-dlc/guidelines/skill-base.md` | Reusable domain/business skills catalog |
| `ai-dlc/guidelines/dev-setup.md` | Local setup guide |

---

## Developer Setup
See `ai-dlc/guidelines/dev-setup.md`
