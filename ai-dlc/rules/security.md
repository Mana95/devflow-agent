# Security Rules

## NEVER
- Never hardcode secrets, API keys, passwords, or connection strings in code
- Never commit `.env` files to git
- Never log sensitive data (passwords, tokens, PII)
- Never trust client-supplied IDs without server-side validation
- Never return raw exception messages to the client
- Never use raw SQL — EF Core only
- Never skip input validation on any API endpoint
- Never store passwords in plain text — always bcrypt
- Never allow unauthenticated access to protected resources
- Never expose internal infrastructure details in API responses

---

## ALWAYS
- Always validate and sanitise all inputs server-side
- Always use HTTPS — never HTTP in production config
- Always use parameterised queries if raw SQL is ever needed
- Always set appropriate CORS policy — never use wildcard `*` in production
- Always use environment variables for secrets (`.env.local`, Azure Key Vault, etc.)
- Always implement rate limiting on auth endpoints
- Always hash passwords with bcrypt before storing
- Always validate JWT tokens server-side on every protected request
- Always return generic error messages to the client — log the real error server-side

---

## Authentication Rules
- JWT tokens must have expiry set (max 1 hour for access tokens)
- Refresh tokens must be stored securely (httpOnly cookie)
- Failed login attempts must be rate-limited
- Password reset tokens must expire within 15 minutes

---

## API Security Checklist (per endpoint)
- [ ] Is authentication required? If yes, is `[Authorize]` applied?
- [ ] Are all inputs validated with data annotations or FluentValidation?
- [ ] Does the endpoint only return data the authenticated user owns?
- [ ] Is the HTTP method correct (no GET requests with side effects)?
- [ ] Is the response DTO used (no domain model exposure)?

---

## Environment Files
```
.env              ← never commit
.env.local        ← never commit
.env.production   ← never commit
appsettings.Development.json ← never commit secrets here
```

Add all of the above to `.gitignore` immediately.

---

## .gitignore Minimum
```
.env
.env.*
appsettings.*.json
*.user
bin/
obj/
node_modules/
dist/
.DS_Store
```
