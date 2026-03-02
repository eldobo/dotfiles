# install.ps1 — install dotfiles on Windows
# Safe to run multiple times (idempotent)
# Usage: .\install.ps1

$ErrorActionPreference = "Stop"
$DotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

function New-Hardlink {
    param([string]$Source, [string]$Dest)

    $destDir = Split-Path -Parent $Dest
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }

    if (Test-Path $Dest) {
        # Check if already linked to the same file (compare content + size as proxy)
        $srcHash = (Get-FileHash $Source).Hash
        $destHash = (Get-FileHash $Dest).Hash
        if ($srcHash -eq $destHash) {
            Write-Host "  already linked: $Dest"
            return
        }
        $backup = "$Dest.bak"
        Write-Host "  backing up existing: $Dest -> $backup"
        Move-Item $Dest $backup -Force
    }

    cmd /c mklink /H "$Dest" "$Source" | Out-Null
    Write-Host "  linked: $Dest"
}

function Install-GitConfig {
    $gitconfigPath = Join-Path $HOME ".gitconfig"
    $personalPath = Join-Path $HOME ".gitconfig-personal"
    $dotfilesGitconfig = Join-Path $DotfilesDir ".gitconfig"

    # Read personal identity from the dotfiles .gitconfig
    $personalName = git config --file $dotfilesGitconfig user.name
    $personalEmail = git config --file $dotfilesGitconfig user.email

    if (Test-Path $gitconfigPath) {
        $existing = git config --global user.email 2>$null
        if ($existing) {
            Write-Host "  .gitconfig already exists (user: $existing)"
            Write-Host "  skipping — delete ~/.gitconfig to regenerate"
            return
        }
    }

    # Prompt for work identity
    Write-Host ""
    Write-Host "  Personal git identity (from dotfiles): $personalName <$personalEmail>"
    Write-Host "  Enter your WORK git identity for this machine (leave blank to use personal only):"
    $workName = Read-Host "    Work name (default: $personalName)"
    $workEmail = Read-Host "    Work email"

    if (-not $workName) { $workName = $personalName }

    if ($workEmail) {
        # Multi-identity setup: work as default, personal for dotfiles org repos
        $includeIfDir = ($DotfilesDir -replace '\\[^\\]+$', '') -replace '\\', '/'
        $content = @"
# Include shared settings and aliases from dotfiles repo
[include]
	path = ~/github.com/eldobo/dotfiles/.gitconfig

# Work identity (default)
[user]
	name = $workName
	email = $workEmail

# Personal identity for personal repos
[includeIf "gitdir/i:$includeIfDir/"]
	path = ~/.gitconfig-personal
"@
        Set-Content -Path $gitconfigPath -Value $content -NoNewline
        Write-Host "  created: $gitconfigPath (work default + personal conditional)"

        # Create personal identity include file
        $personalContent = @"
[user]
	name = $personalName
	email = $personalEmail
"@
        Set-Content -Path $personalPath -Value $personalContent -NoNewline
        Write-Host "  created: $personalPath"
    }
    else {
        # Single-identity setup: just include the dotfiles gitconfig
        $content = @"
# Include settings and aliases from dotfiles repo
[include]
	path = ~/github.com/eldobo/dotfiles/.gitconfig
"@
        Set-Content -Path $gitconfigPath -Value $content -NoNewline
        Write-Host "  created: $gitconfigPath (personal identity only)"
    }
}

Write-Host "Installing dotfiles from $DotfilesDir..."
Write-Host ""

# Hardlink account-agnostic files
Write-Host "Linking files..."
New-Hardlink -Source (Join-Path $DotfilesDir ".claude\CLAUDE.md") -Dest (Join-Path $HOME ".claude\CLAUDE.md")
New-Hardlink -Source (Join-Path $DotfilesDir ".gitignore_global") -Dest (Join-Path $HOME ".gitignore_global")

# Set up git config with identity management
Write-Host ""
Write-Host "Configuring git..."
Install-GitConfig

Write-Host ""
Write-Host "Done."
Write-Host "Note: .zshrc is skipped on Windows."
