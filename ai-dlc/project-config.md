# Project Config

This file holds the per-project decisions chosen during **First-Run Onboarding**
(see CLAUDE.md). Until `configured` is `true`, the agent must run onboarding before
doing any intake, discovery, or build work.

Once set, these become the **locked stack** for this project — the agent does not
re-ask about them unless the user says "reset stack".

```
configured   : false
project_type : # new | existing
domain       : # e.g. e-commerce, fintech, healthcare, internal-tooling
frontend     : # e.g. React 18 + TypeScript, Vue 3, Angular, none
backend      : # e.g. .NET Core 8 Web API, Node/Express, Django, Spring Boot
database     : # e.g. PostgreSQL + EF Core, MySQL, MongoDB, none
auth         : # e.g. JWT Bearer, session cookies, OAuth/OIDC, none
styling      : # e.g. Tailwind CSS, CSS Modules, styled-components
unit_testing : # e.g. xUnit (.NET) + Vitest (React), Jest, pytest
e2e_testing  : # e.g. Playwright, Cypress, none
cloud        : # e.g. Azure, AWS, GCP, none / not configured yet
```

---

## Notes
- For an **existing** project, Discovery detects the stack by scanning the repo —
  the agent should fill these fields from what it finds, and only ask about gaps it
  cannot infer.
- For a **new** project, the agent fills these from the onboarding interview.
- `cloud` stays `none` until the user explicitly chooses a provider.
