# Domain Glossary

## Purpose
Canonical business terms used in code, prompts, and documentation.
The agent must use these exact terms in all generated code and files.
When in doubt, use the term defined here — not a synonym.

---

## Terms

| Term | Definition | Used In |
|------|-----------|---------|
| Intent | A written statement of what needs to be built and why, with acceptance criteria | ai-dlc/intents/ |
| Bolt | The smallest deployable unit of work within an intent | Backlog |
| Backlog | The live list of all bolts and their status | ai-dlc/ops/build/backlog.md |
| Discovery | The process of checking existing sources (Jira, GitHub, Figma) before building | ai-dlc/discovery/ |
| Mode 1 | Build mode when existing work is found in connected sources | Discovery report |
| Mode 2 | Build mode when starting from scratch with no existing work | Discovery report |
| Acceptance Criteria | The specific, testable conditions a bolt must satisfy to be marked DONE | Intent files |
| Validation Loop | The process of checking every acceptance criterion after each bolt | CLAUDE.md |
| Bug Lifecycle | The full flow from validation failure to GitHub issue to PR | CLAUDE.md |
| Human Checkpoint | The approval gate where the user confirms the plan before build starts | CLAUDE.md |
| Tech Stack | The locked set of technology choices for this project | CLAUDE.md memory |
| PR | Pull Request — the code review artifact created after a bug fix | GitHub |
| ADR | Architecture Decision Record — a logged decision in architecture.md | ai-dlc/rules/ |

---

## Add New Terms Here
When a new domain concept is introduced by the user, add it here before using it in code.
Format: `| Term | Definition | Where used |`
