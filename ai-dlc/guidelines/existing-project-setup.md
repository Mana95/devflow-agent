# Configuring AI-DLC on an Existing Project

## When to use this guide
Use this when attaching the AI-DLC agent workflow (a `CLAUDE.md` + `ai-dlc/` folder)
to a codebase that already has real, working application code — not a project
started from scratch by this agent. This is "Situation C" in
`CLAUDE.md`'s Session Start Protocol.

**Do not** copy this repo's `CLAUDE.md` Memory block (React 18 / .NET 8 / PostgreSQL /
etc.) into a different project verbatim. That stack is locked *for this project only*.
An existing codebase almost certainly uses different technology — the whole point of
this guide is to discover and record what's actually there.

---

## Step 1: Detect what's actually there
Before creating any `ai-dlc/` files, scan the existing repo. Do not ask the user to
restate what a quick look at the repo already answers.

- **Backend**: look for `.csproj`/`.sln`, `package.json`, `requirements.txt`/`pyproject.toml`,
  `pom.xml`/`build.gradle`, `go.mod`, etc. to identify language, framework, and version.
- **Frontend**: check `package.json` dependencies for the UI framework (React/Vue/Angular/etc.),
  its version, and the build tool (Vite/webpack/CRA/Next.js).
- **Database**: look for migration folders, ORM config files, connection string
  patterns (redact any real secrets you find — never echo them back).
- **Auth**: look for existing auth middleware, packages, or custom implementations
  already in use.
- **Testing**: look for existing test frameworks/folders and what (if anything) they
  currently cover.
- **CI**: check for `.github/workflows/`, `azure-pipelines.yml`, `.gitlab-ci.yml`, etc.
- **Conventions already in use**: naming style, folder structure, error-handling
  patterns — these inform `code-standards.md`, not just the template defaults.

If the codebase mixes conventions (e.g. two different ORMs in different modules, or
inconsistent naming across older vs. newer code), do not silently pick one — ask the
user which is canonical going forward.

---

## Step 2: Populate `ai-dlc/rules/architecture.md` from reality
- Write the **actual** detected stack as the new project's own locked decisions —
  this becomes that project's Memory block, replacing the template values.
- Note any existing ADRs implied by the codebase itself (e.g. "already uses Redis for
  session cache" is a decision that was already made, even if never written down).
- Leave genuinely undecided items (e.g. no cloud provider configured yet) as open
  questions, same as a fresh project would.

## Step 3: Scaffold the rest of `ai-dlc/`
Create (if missing), based on Step 1's findings rather than blank templates:
- `ai-dlc/intents/` — empty, ready for the first intent
- `ai-dlc/discovery/discovery-report.md` — pre-filled with what Step 1 found
- `ai-dlc/ops/build/backlog.md` — empty backlog table
- `ai-dlc/rules/architecture.md` — populated per Step 2
- `ai-dlc/rules/code-standards.md` — seed from conventions actually observed in the
  existing code, not copied wholesale from a template project
- `ai-dlc/rules/security.md` — adjust to the real auth/secrets setup found
- `ai-dlc/rules/harness-governance.md` — these are agent-operating rules, not
  project-specific; safe to copy as-is
- `ai-dlc/guidelines/domain-glossary.md` — start empty, fill in as work happens
- `ai-dlc/guidelines/skill-base.md` — start empty, fill in as work happens
- `ai-dlc/guidelines/dev-setup.md` — write real setup steps for the actual stack found,
  not the template's assumed stack

## Step 4: Set the Discovery Report mode expectation
Because real code already exists, the first feature worked on will almost always
start as **Mode 1** (existing work found) rather than Mode 2 — there's a whole
codebase to check against before assuming anything needs to be built from scratch.

## Step 5: Copy the governance entry point
Copy the appropriate rules file into the existing project's repo root, with the
Memory section replaced per Step 2:
- `CLAUDE.md` for Claude Code
- `.cursorrules` for Cursor
- `.github/copilot-instructions.md` for GitHub Copilot

## Step 6: First real session
Once the above exists, start a session normally. The agent's Session Start Protocol
will detect `ai-dlc/` is now configured (Situation B) and proceed straight to asking
about the first Epic/feature — no need to repeat this onboarding flow again.
