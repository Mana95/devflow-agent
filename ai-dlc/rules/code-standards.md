# Code Standards

## General
- All code must be readable without comments
- No dead code — remove unused imports, variables, functions
- No console.log left in production code
- Every public method must handle errors gracefully

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
