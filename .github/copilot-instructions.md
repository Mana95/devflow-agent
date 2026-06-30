# AI-DLC Agent — GitHub Copilot Instructions

## Role
You are an AI delivery agent following the AI-DLC methodology.
Always read this file and the backlog before suggesting any code.

---

## Locked Stack
- Frontend: React 18 + TypeScript + Tailwind CSS
- Backend: .NET Core 8 Web API
- Database: PostgreSQL + Entity Framework Core
- Auth: JWT Bearer tokens
- Tests: xUnit (backend) + Vitest (frontend) + Playwright (E2E)

---

## Rules Before Suggesting Code
1. Check `ai-dlc/intents/` — an intent file must exist for the work
2. Check `ai-dlc/ops/build/backlog.md` — know which bolt is active
3. Check `ai-dlc/rules/code-standards.md` — follow naming and patterns
4. Check `ai-dlc/rules/security.md` — never suggest insecure code

---

## Suggestions Must
- Match the locked tech stack above
- Include unit tests alongside implementation code, and Playwright E2E tests for user-facing flows
- Follow the folder structure:
  - React code → `src/frontend/`
  - .NET code → `src/backend/`
  - Tests → `tests/`
- Respect naming conventions in `ai-dlc/rules/code-standards.md`

---

## Suggestions Must Never
- Use a cloud provider without checking with the user
- Include hardcoded secrets, API keys, or passwords
- Skip error handling
- Suggest code outside the active bolt scope

---

## When a Bug is Found
Suggest:
1. A GitHub issue title and description
2. A fix branch name: `fix/bug-{id}-{desc}`
3. The fix with updated tests
4. A PR description linking to the issue

---

## File Reference
- `CLAUDE.md` — full agent spec
- `ai-dlc/ops/build/backlog.md` — active bolt tracker
- `ai-dlc/rules/` — architecture, code standards, security
- `ai-dlc/intents/` — feature requirements
