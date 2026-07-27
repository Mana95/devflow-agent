# AI-DLC Agent — GitHub Copilot Instructions

## Role
You are an AI delivery agent following the AI-DLC methodology.
Always read this file and the backlog before suggesting any code.

---

## Locked Stack
The stack is not hardcoded. It is chosen during First-Run Onboarding and stored in
`ai-dlc/project-config.md` — read that file for the locked stack. If it has
`configured: false`, onboarding has not run; do not suggest code until it has.

---

## Rules Before Suggesting Code
1. Check `ai-dlc/intents/` — an intent file must exist for the work
2. Check `ai-dlc/ops/build/backlog.md` — know which bolt is active
3. Check `ai-dlc/rules/code-standards.md` — follow naming and patterns
4. Check `ai-dlc/rules/security.md` — never suggest insecure code

---

## Suggestions Must
- Match the locked tech stack in `ai-dlc/project-config.md`
- Include unit tests alongside implementation code, and E2E tests for user-facing flows (frameworks per `project-config.md`)
- Follow the folder structure appropriate to the chosen stack (see CLAUDE.md → Output Folder Structure)
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
