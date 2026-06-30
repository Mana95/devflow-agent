# Architecture Decisions

## Stack Overview
```
┌─────────────────────────────────┐
│  Frontend: React 18 + TypeScript │
│  Styling:  Tailwind CSS          │
│  State:    React Context / hooks │
└────────────────┬────────────────┘
                 │ HTTP / REST
┌────────────────▼────────────────┐
│  Backend: .NET Core 8 Web API   │
│  Auth:    JWT Bearer            │
│  ORM:     Entity Framework Core │
└────────────────┬────────────────┘
                 │
┌────────────────▼────────────────┐
│  Database: PostgreSQL            │
└─────────────────────────────────┘
```

---

## Decisions Log

### ADR-001: Frontend framework
- Decision: React 18 + TypeScript
- Reason: User confirmed. Industry standard. Strong ecosystem.
- Date: Project start

### ADR-002: Backend framework
- Decision: .NET Core 8 Web API
- Reason: User confirmed .NET Core preference.
- Date: Project start

### ADR-003: Database
- Decision: PostgreSQL
- Reason: Best fit for relational data with EF Core support.
- Date: Project start

### ADR-004: Authentication
- Decision: JWT Bearer tokens
- Reason: Stateless, works well with REST API and React SPA.
- Date: Project start

### ADR-005: Testing
- Decision: xUnit for .NET, Vitest for React
- Reason: Industry standard for each stack.
- Date: Project start

---

## Open Decisions
| Topic | Options | Decision needed by |
|-------|---------|-------------------|
| Cloud provider | Azure / AWS / None | Before first deployment |
| API versioning | URL path / header | Before first public release |
| Caching layer | Redis / in-memory | When performance needed |

---

## Constraints
- No cloud provider configured yet — do not add cloud-specific code without user confirmation
- All API endpoints must be versioned: `/api/v1/`
- All controllers must have XML doc comments
- No raw SQL — use EF Core only
