# Harness Governance

## Purpose
Rules for how the agent operates the Claude Code harness itself (permissions, external
tool access, branching discipline, CI, and code quality gates) — separate from
`code-standards.md` (which governs the code being written) and `architecture.md` (which
governs the tech stack). These exist because real session mistakes showed that "the
workflow says to do X" is not enough on its own; the harness needs to make X the easy
or automatic path.

---

## Branch-Before-Build (mandatory)

Before writing any Phase 5 Build code for a bolt:
1. Confirm the current git branch is a `feature/{intent-id}-{short-desc}` branch, not `main`.
2. If on `main` (or any other non-feature branch) with intake artifacts (intent files,
   backlog entries) ready to commit, create the feature branch FIRST, commit intake
   artifacts to it, THEN start Phase 5.
3. Never write bolt implementation code while `git branch --show-current` reports `main`.

**Why this is here:** in an early session, 8 bolts of ECOM-001 were built directly on
`main` before switching to a feature branch, only caught when the user asked to raise a
PR. Nothing in the workflow mechanically prevented it — this rule exists so the check
happens explicitly, every time, before Phase 5 starts.

---

## External Tool Access (GitHub, Jira, Figma, etc.)

- Prefer an authenticated CLI (`gh`) or an MCP connector over raw `curl` + a manually
  pasted token. Raw `curl` calls with an inline token are error-prone (easy to leak via
  chat, easy to typo a scope) and were only used because neither `gh` nor a GitHub MCP
  was available in-session.
- Before starting Discovery (Phase 2) on any source (GitHub/Jira/Figma), check whether
  a working credential already exists (env var set, `gh auth status`, MCP connector
  connected). If it doesn't — or it exists but lacks the scope needed (e.g. a GitHub
  token with `project` scope but not `repo`, which cannot create issues) — stop and ask
  the user to add/update the credential in a gitignored `.env` before proceeding on
  that source. Don't guess at scopes and don't skip the source silently.
- If a user pastes a live token/credential directly into chat, treat it as compromised
  immediately: tell them to revoke it, do not use it, and wait for a replacement placed
  directly into a gitignored file instead.
- Store tokens only in gitignored files (`.env`, `.env.local`) or the CLI's own secure
  credential store — never in tracked files, never echoed back in full.

---

## Permission Prompt Reduction

- Repeated read-only / build / test commands (`dotnet build`, `dotnet test`, `npm test`,
  `npm run build`, `git status`, `git diff`, `git log`) generate a fresh approval prompt
  each time with no allowlist configured. Use the `fewer-permission-prompts` skill (or
  hand-edit `.claude/settings.json`) once a project's common command set stabilizes, so
  routine build/test/status commands don't require repeated confirmation.

---

## CI Wiring

- Backend (xUnit) and frontend (Vitest) suites currently only run when the agent
  remembers to run them locally — nothing runs them automatically on push/PR.
- When a project reaches its first PR, check whether `.github/workflows/` exists; if
  not, flag it to the user as a gap (don't add CI config silently/unprompted, since it's
  a shared-infrastructure change — confirm first per the risk-of-action guidance in
  the system prompt).

---

## Lint / Format Gates

- `code-standards.md` defines real naming/structure conventions, but nothing
  auto-enforces them (e.g. `dotnet format`, `oxlint --fix`) on save or pre-commit.
  Until a hook exists, the agent must self-check generated code against
  `code-standards.md` before considering a bolt done — don't assume a linter will catch
  violations.

---

## Config File Integrity

Two real bugs surfaced from files that looked fine but silently broke things:
- A generic `.gitignore` pattern (`build/`) accidentally excluded a *tracked* directory
  (`ai-dlc/ops/build/`) that happened to share the name with a build-output convention.
- Another `.gitignore` pattern (`.env.*`) accidentally excluded `.env.example`, a
  template file meant to be committed.

**Rule:** before assuming a "missing" file was never created, run
`git check-ignore -v <path>` to rule out an overly broad ignore pattern first.
