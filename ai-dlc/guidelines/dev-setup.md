# Developer Setup Guide

## Prerequisites

### Tools Required
- Node.js 20+ → https://nodejs.org
- .NET 8 SDK → https://dotnet.microsoft.com/download
- PostgreSQL 15+ → https://www.postgresql.org/download
- Git → https://git-scm.com

### AI Tools (install at least one)
- Claude Code → `npm install -g @anthropic-ai/claude-code`
- Cursor → https://cursor.com
- GitHub Copilot → VS Code extension

---

## Local Setup

### 1. Clone and enter project
```bash
git clone {repo-url}
cd ai-dlc-agent
```

### 2. Frontend setup
```bash
cd src/frontend
npm install
cp .env.example .env.local
npm run dev
```

### 3. Backend setup
```bash
cd src/backend
dotnet restore
cp appsettings.example.json appsettings.Development.json
# Edit appsettings.Development.json with your local DB connection
dotnet ef database update
dotnet run
```

### 4. Database setup
```bash
# Create local database
createdb ai_dlc_agent_dev

# Connection string format:
# Host=localhost;Database=ai_dlc_agent_dev;Username=postgres;Password=yourpassword
```

---

## Starting an AI Session

### With Claude Code
```bash
# From project root
claude
# Claude reads CLAUDE.md automatically
```

### With Cursor
```bash
# Open project in Cursor
cursor .
# Cursor reads .cursorrules automatically
```

### With GitHub Copilot
```
# Open project in VS Code
# Copilot reads .github/copilot-instructions.md automatically
```

---

## First Session Checklist
- [ ] All tools installed
- [ ] Database running locally
- [ ] Environment files configured
- [ ] Agent reads CLAUDE.md / .cursorrules at session start
- [ ] Backlog checked — know which bolt is active
- [ ] Never commit .env files

---

## Team Conventions
- Always work from an intent file — no ad-hoc coding
- Always update backlog.md when bolt status changes
- Always raise a PR — no direct commits to main
- Always run tests before raising a PR
