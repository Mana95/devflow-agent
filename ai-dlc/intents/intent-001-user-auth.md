# Intent: User Authentication — Login & Register

## ID
intent-001

## Status
DRAFT

## Priority
HIGH

## Goal
Build a user authentication system with registration and login functionality. Users must be able to create an account with email/password and log in to receive a JWT token for accessing protected resources.

## Affected Modules
- [x] Frontend — Login page, Register page, auth service, auth context
- [x] Backend — AuthController, AuthService, User model, JWT middleware
- [x] Database — Users table (Id, Email, PasswordHash, CreatedAt)
- [x] Auth — JWT token generation and validation

## Acceptance Criteria

- [ ] AC-001: User can register with email and password; API returns 201 with user ID
- [ ] AC-002: Registration with duplicate email returns 409 Conflict
- [ ] AC-003: Registration with invalid email or weak password returns 400 with validation errors
- [ ] AC-004: User can login with valid credentials; API returns 200 with JWT access token
- [ ] AC-005: Login with wrong credentials returns 401 Unauthorized
- [ ] AC-006: JWT token contains user ID and email claims, expires in 1 hour
- [ ] AC-007: Protected endpoints reject requests without valid JWT (401)
- [ ] AC-008: Frontend login form submits credentials and stores token on success
- [ ] AC-009: Frontend register form submits data and redirects to login on success
- [ ] AC-010: Frontend shows validation errors from API

## Bolts

| Bolt ID | Description | Status |
|---------|-------------|--------|
| 001-bolt-001 | Backend User model + DB migration + DbContext | PENDING |
| 001-bolt-002 | Backend AuthService (register + login + JWT generation) | PENDING |
| 001-bolt-003 | Backend AuthController + JWT middleware config | PENDING |
| 001-bolt-004 | Backend unit tests (xUnit) | PENDING |
| 001-bolt-005 | Frontend auth service + types | PENDING |
| 001-bolt-006 | Frontend Register page + Login page | PENDING |
| 001-bolt-007 | Frontend auth context + protected route | PENDING |
| 001-bolt-008 | Frontend unit tests (Vitest) | PENDING |

## Discovery Notes
No existing auth code found. Building from scratch (Mode 2).

## Assumptions
- Password hashing via BCrypt
- JWT secret stored in appsettings (not hardcoded)
- No refresh tokens in v1 — just access token with 1hr expiry
- No email verification in v1
- No social login in v1

## Out of Scope
- Password reset / forgot password
- Email verification
- Refresh tokens
- Social/OAuth login
- Role-based authorization (future intent)
