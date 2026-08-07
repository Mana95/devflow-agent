<#
.SYNOPSIS
    Scaffold a new app repo that consumes the dev-agent brain as a git submodule.

.DESCRIPTION
    Creates a self-contained app repository (its own git) with:
      - the dev-agent embedded at ./dev-agent as a git submodule
      - a thin ./CLAUDE.md that imports the brain (@dev-agent/CLAUDE.md)
      - app-root ai-dlc/ state (project-config.md configured:false, blank backlog,
        blank discovery, intent template, blank architecture/glossary/skill-base)
      - src/ placeholder and a .gitignore

    Reusable rules (code-standards, security, harness-governance, infrastructure) are
    NOT copied — they stay in the submodule so `git submodule update --remote dev-agent`
    pulls the latest brain without touching this app's state.

.PARAMETER AppName
    Name of the app (also the default folder name), e.g. "sales-app".

.PARAMETER DevAgentUrl
    Git URL (or local path) of the dev-agent repo to add as the ./dev-agent submodule,
    e.g. "https://github.com/<you>/dev-agent.git".

.PARAMETER AppPath
    Where to create the app folder. Defaults to a sibling of the current directory:
    ../<AppName>.

.EXAMPLE
    ./scripts/bootstrap-app.ps1 -AppName sales-app `
        -DevAgentUrl https://github.com/you/dev-agent.git
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)] [string] $AppName,
    [Parameter(Mandatory = $true)] [string] $DevAgentUrl,
    [Parameter(Mandatory = $false)] [string] $AppPath
)

$ErrorActionPreference = "Stop"

if (-not $AppPath -or $AppPath.Trim() -eq "") {
    $AppPath = Join-Path (Split-Path -Parent (Get-Location).Path) $AppName
}

Write-Host "==> Bootstrapping app '$AppName' at: $AppPath" -ForegroundColor Cyan

if (Test-Path $AppPath) {
    $existing = Get-ChildItem -Force $AppPath | Where-Object { $_.Name -ne '.git' }
    if ($existing) {
        throw "Target path '$AppPath' already exists and is not empty. Aborting."
    }
} else {
    New-Item -ItemType Directory -Path $AppPath | Out-Null
}

Push-Location $AppPath
try {
    # 1. Fresh git repo for the app
    if (-not (Test-Path ".git")) {
        git init | Out-Null
        Write-Host "    git init done" -ForegroundColor DarkGray
    }

    # 2. Embed the dev-agent brain as a submodule
    if (-not (Test-Path "dev-agent")) {
        Write-Host "==> Adding dev-agent submodule from $DevAgentUrl" -ForegroundColor Cyan
        git submodule add $DevAgentUrl dev-agent
        git submodule update --init --recursive
    }

    $brain = "dev-agent"
    if (-not (Test-Path (Join-Path $brain "CLAUDE.md"))) {
        throw "dev-agent submodule did not populate (no dev-agent/CLAUDE.md). Check the URL."
    }

    # 3. Thin wrapper CLAUDE.md that imports the brain
    $thinClaude = @"
# $AppName — App Rules (thin wrapper)

This app consumes the **dev-agent brain** as a git submodule at ``./dev-agent``.
The full agent rules live there and are imported below.

@dev-agent/CLAUDE.md

---

## App-specific overrides
<!-- Add rules that should extend or override the brain for THIS app only. -->
"@
    Set-Content -Path "CLAUDE.md" -Value $thinClaude -Encoding utf8

    # Thin pointers for Cursor / Copilot
    New-Item -ItemType Directory -Force -Path ".github" | Out-Null
    Set-Content -Path ".cursorrules" -Encoding utf8 -Value `
        "# Rules for this app live in the dev-agent submodule. See dev-agent/.cursorrules and dev-agent/CLAUDE.md."
    Set-Content -Path ".github/copilot-instructions.md" -Encoding utf8 -Value `
        "# Rules for this app live in the dev-agent submodule. See dev-agent/.github/copilot-instructions.md and dev-agent/CLAUDE.md."

    # 4. App-root ai-dlc/ state, copied from the brain templates (single source of truth)
    $dirs = @("ai-dlc/intents", "ai-dlc/discovery", "ai-dlc/ops/build", "ai-dlc/rules", "ai-dlc/guidelines", "src", "tests")
    foreach ($d in $dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }

    $copy = @{
        "$brain/ai-dlc/project-config.md"              = "ai-dlc/project-config.md"
        "$brain/ai-dlc/ops/build/backlog.md"           = "ai-dlc/ops/build/backlog.md"
        "$brain/ai-dlc/discovery/discovery-report.md"  = "ai-dlc/discovery/discovery-report.md"
        "$brain/ai-dlc/intents/intent-template.md"     = "ai-dlc/intents/intent-template.md"
        "$brain/ai-dlc/rules/architecture.md"          = "ai-dlc/rules/architecture.md"
        "$brain/ai-dlc/guidelines/domain-glossary.md"  = "ai-dlc/guidelines/domain-glossary.md"
        "$brain/ai-dlc/guidelines/skill-base.md"       = "ai-dlc/guidelines/skill-base.md"
        "$brain/.gitignore"                            = ".gitignore"
    }
    foreach ($src in $copy.Keys) {
        if (Test-Path $src) {
            Copy-Item -Path $src -Destination $copy[$src] -Force
        } else {
            Write-Warning "Template not found in brain, skipped: $src"
        }
    }

    New-Item -ItemType File -Force -Path "src/.gitkeep" | Out-Null
    New-Item -ItemType File -Force -Path "tests/.gitkeep" | Out-Null

    Write-Host ""
    Write-Host "==> Done. App scaffolded at $AppPath" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. cd `"$AppPath`""
    Write-Host "  2. Open the app with Claude Code and run First-Run Onboarding to lock the stack."
    Write-Host "  3. Create the '$AppName' GitHub repo, then: git remote add origin <url> && git push -u origin main"
    Write-Host ""
    Write-Host "To pull the latest dev-agent brain later:" -ForegroundColor Yellow
    Write-Host "  git submodule update --remote dev-agent && git add dev-agent && git commit -m 'chore: update dev-agent brain'"
}
finally {
    Pop-Location
}
