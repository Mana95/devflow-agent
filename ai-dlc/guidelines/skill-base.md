# Skill Base

## Purpose
A catalog of reusable domain/business skills — recurring business rules, calculations,
and patterns that span multiple bolts. The agent must check here before re-deriving logic
that already exists, and must add a new entry whenever a reusable rule is introduced.

---

## Skills

| Skill | Description | Used In | Defined In Intent |
|-------|-------------|---------|--------------------|
| Password Complexity Policy | Validates a password against the standard rule: min 8 chars, uppercase, lowercase, number, special character. Central source of truth — do not re-derive the regex elsewhere. | `src/backend/Services/PasswordPolicy.cs` — registration, password reset, change password | intent-001 (register/login) |
| Password Hashing | Hash with BCrypt before storing; verify with `BCrypt.Net.BCrypt.Verify`. Never store or log plaintext passwords. | `AuthService.RegisterAsync`, `AuthService.LoginAsync` | intent-001 |
| JWT Access Token Issuance | Generate a short-lived (config-driven, default 60 min) signed JWT containing `sub` (user id) and `email` claims via `IJwtTokenService.GenerateAccessToken`. | `JwtTokenService`, any endpoint requiring `[Authorize]` | intent-001 |
| Refresh Token Generation & Rotation | Generate a cryptographically random refresh token, store only its SHA-256 hash (never the raw token) with an expiry, and rotate (revoke old, issue new) on every use. | `JwtTokenService.GenerateRefreshToken/HashRefreshToken`, `AuthService.RefreshTokenAsync` | intent-001 |
| Single-Use Expiring Token Pattern | General pattern for tokens that must be used exactly once within a time window (refresh tokens, and reusable for email verification / password reset tokens): random token, hash stored server-side, `ExpiresAt` + `RevokedAt`/`UsedAt` fields, `IsActive` computed property. | `RefreshToken` model; intended reuse for `EmailVerificationToken` and `PasswordResetToken` | intent-001 (reuse expected in intent-002, intent-003) |
| Duplicate-Check Before Create | Query for an existing unique field (e.g. normalized/lowercased email) before insert; throw a typed domain exception (not a generic one) so the controller can map it to the correct HTTP status. | `AuthService.RegisterAsync` → `DuplicateEmailException` → 409 | intent-001 |
| Typed Domain Exceptions → ProblemDetails Mapping | Business-rule failures are thrown as specific exception types (`DuplicateEmailException`, `InvalidCredentialsException`, `WeakPasswordException`, `InvalidRefreshTokenException`) and caught in the controller to return `ProblemDetails` with the correct status code — never leak raw exceptions to the client. | `AuthController` | intent-001 |
| Frontend API Error Surfacing | `apiFetch` throws a typed `ApiError` (status + detail) on non-2xx responses; page components catch it and render the `detail` (or a generic fallback) in a `role="alert"` element. | `apiClient.ts`, `RegisterPage`, `LoginPage` | intent-001 |
| Auth Context + Protected Route | React Context holds `isAuthenticated`/`login`/`logout`; a `ProtectedRoute` wrapper redirects unauthenticated users to `/login`. Reuse this pair for any new authenticated page rather than re-checking tokens ad hoc. | `AuthProvider`, `ProtectedRoute`, `useAuth` | intent-001 |

---

## Add New Skills Here
When a business rule, calculation, or pattern is reused (or likely to be reused) across
more than one bolt, log it here before implementing it again elsewhere.
Format: `| Skill name | What it does | Module/bolt it's used in | Intent that introduced it |`
