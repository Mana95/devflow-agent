# Intent Template

> Copy this file to `ai-dlc/intents/intent-{NNN}-{name}.md` when creating a new intent.
> Replace all placeholder text in [brackets].

---

# Intent: [Short name of what needs to be built]

## ID
intent-[NNN]

## Status
DRAFT | APPROVED | IN PROGRESS | DONE

## Priority
HIGH | MEDIUM | LOW

## Goal
[One paragraph. What needs to be built and WHY it's needed.
Written from the user's perspective.]

## Affected Modules
- [ ] Frontend — [which components/pages]
- [ ] Backend — [which controllers/services]
- [ ] Database — [which tables/models]
- [ ] Auth — [any permission changes]

## Acceptance Criteria
Each criterion must be specific and testable.

- [ ] AC-001: [When X happens, Y must occur]
- [ ] AC-002: [When X is invalid, Z error must be returned]
- [ ] AC-003: [The response must contain fields A, B, C]

## Bolts
Break the intent into bolts once approved.

| Bolt ID | Description | Status |
|---------|-------------|--------|
| [intent-NNN]-bolt-001 | [what this bolt builds] | PENDING |
| [intent-NNN]-bolt-002 | [what this bolt builds] | PENDING |

## Discovery Notes
[What was found in Jira / GitHub / Figma related to this intent]

## Assumptions
[Any assumptions the agent made during planning]

## Out of Scope
[What is explicitly NOT being built in this intent]
