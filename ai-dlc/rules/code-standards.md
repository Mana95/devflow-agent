# Code Standards

## General
- All code must be readable without comments
- No dead code — remove unused imports, variables, functions
- No console.log left in production code
- Every public method must handle errors gracefully

---

## Design & Maintainability
These apply across both stacks — the goal is code a professional engineering team
would accept in review, not just code that works.

- **Single Responsibility** — a class/function does one thing. If a service method
  needs "and" to describe it (e.g. "validates and sends email and logs"), split it.
- **Depend on abstractions, not concretions** — controllers/services take interfaces
  via constructor injection (`IProductService`, not `ProductService` directly), so
  implementations can be swapped/mocked without touching callers.
- **No magic numbers or strings** — extract repeated literals (status codes, config
  keys, business thresholds like "8 char minimum") into named constants or config,
  not inline literals scattered across files.
- **Null-safety is explicit** — nullable reference types stay on (.NET) and are
  respected, not suppressed with `!` except where a preceding check already proves
  non-null. TypeScript: no `any` to bypass a type error — fix the type instead.
- **Async all the way down** — never block on async code (no `.Result`/`.Wait()` in
  .NET, no unnecessarily-sync wrappers around promises in TS). If a method awaits
  anything, it is itself `async`.
- **Small, composable functions over deep nesting** — prefer early returns / guard
  clauses over multiple levels of nested `if`.
- **Favor composition over inheritance** — extend behavior via injected
  services/hooks, not deep class hierarchies or prop-drilled component inheritance.

---

## .NET Core (Backend)

### Naming
| Element | Convention | Example |
|---------|-----------|---------|
| Class | PascalCase | `UserService` |
| Method | PascalCase | `GetUserById` |
| Property | PascalCase | `FirstName` |
| Private field | _camelCase | `_userRepository` |
| Local variable | camelCase | `userCount` |
| Interface | IPascalCase | `IUserService` |
| DTO | PascalCase + Suffix | `CreateUserRequest`, `UserResponse` |

### Structure
- Controllers → thin. No business logic. Call services only.
- Services → all business logic lives here
- Models → domain entities only. No annotations except EF mappings.
- DTOs → separate request and response objects always
- Never return domain models directly from controllers — always use DTOs

### API Conventions
- All routes prefixed: `/api/v1/`
- GET → retrieve, no side effects
- POST → create
- PUT → full update
- PATCH → partial update
- DELETE → remove
- Return types: `ActionResult<T>` always
- HTTP status codes must be explicit — never return 200 for errors

### Error Handling
- Use `ProblemDetails` standard for all error responses
- All exceptions must be caught at controller or middleware level
- Never expose stack traces to the client

---

## React + TypeScript (Frontend)

### Naming
| Element | Convention | Example |
|---------|-----------|---------|
| Component | PascalCase | `UserProfile` |
| Hook | camelCase + use | `useUserData` |
| Service | camelCase | `userService` |
| Type/Interface | PascalCase | `UserProfile`, `ApiResponse` |
| File | PascalCase for components | `UserProfile.tsx` |
| CSS class | kebab-case | `user-profile-card` |

### Structure
- One component per file
- Props interface defined above the component
- No inline styles — use Tailwind classes only
- API calls → services layer only, never inside components directly
- useEffect dependencies must be explicit — no empty arrays unless intentional

### State
- Local state → useState
- Shared state → React Context
- Do not use global state libraries unless explicitly approved

### UI / Style
- Follow modern UI design conventions: consistent spacing scale, clear typographic
  hierarchy, accessible color contrast, responsive layout — do not ship a raw/unstyled
  HTML-forms look for user-facing pages.
- Never put placeholder or AI-generated-sounding text into shipped UI copy — no
  "AI Generated Title", no lorem ipsum, no meta-references to the content being
  generated. Titles, labels, and copy must read like real product copy a human product
  team would write for that specific feature (e.g. "Create account", not "Page Title" or
  "AI Generated Heading").
- If a real title/label isn't known yet, ask the user or infer one from the feature's
  actual purpose — do not leave a generic placeholder in committed code.

---

## Testing

### Backend (xUnit)
- Every service method must have at least one test
- Test naming: `MethodName_Scenario_ExpectedResult`
- Example: `GetUserById_UserNotFound_ReturnsNotFound`
- Use Moq for mocking dependencies
- Arrange / Act / Assert structure always

### Frontend (Vitest)
- Every custom hook must have tests
- Every service function must have tests
- Component tests for complex interaction logic only
- Use Testing Library conventions

---

## Git
- Branch naming: `feature/{intent-id}-{short-desc}` or `fix/bug-{id}-{desc}`
- Commit messages: lowercase, imperative: `add user authentication endpoint`
- No direct commits to main — always PR
- PR must reference the intent or bug ID
