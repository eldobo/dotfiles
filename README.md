# dotfiles

Personal configuration files for development environments. Managed with symlinks so changes sync across machines via git.

## Setup on a new machine

```bash
git clone git@github.com:eldobo/dotfiles.git ~/github.com/eldobo/dotfiles
cd ~/github.com/eldobo/dotfiles
./install.sh
source ~/.zshrc
```

That's it. Open a new terminal and everything is live.

## What's included

### `.gitconfig`
Global Git configuration.
- Rebase on pull (linear history)
- Auto-sets upstream on first push
- Default branch: `main`
- Global gitignore applied to every repo

**Aliases:**
| Alias | Command | Description |
|-------|---------|-------------|
| `git st` | `status` | Short status |
| `git co` | `checkout` | Switch branches |
| `git br` | `branch -vv` | List branches with tracking info |
| `git lg` | Pretty graph log | Readable commit history |
| `git undo` | `reset HEAD~1 --mixed` | Undo last commit, keep changes |
| `git unstage` | `reset HEAD --` | Unstage files |
| `git last` | `log -1 HEAD --stat` | Show last commit |
| `git wip` | Stage all + commit "WIP" | Quick save in-progress work |

### `.gitignore_global`
Applied to every git repo on the machine — no need to add these to individual projects.
- macOS: `.DS_Store`, `._*`, `.Spotlight-V100`
- Editor artifacts: `.swp`, `.swo`, `.idea/`, `.vscode/`
- Secrets: `.env`, `*.pem`, `*.key`

### `.zshrc`
Shell configuration.

**Navigation:**
```bash
ll          # ls -la
la          # ls -A
..          # cd ..
...         # cd ../..
```

**Git shortcuts:**
```bash
gs, gd, ga, gaa, gc, gco, gl, gp, gpl
```

**`ghclone` — clone GitHub repos into `~/github.com/<org>/<repo>`:**
```bash
ghclone eldobo/dotfiles                        # shorthand
ghclone https://github.com/eldobo/dotfiles     # HTTPS URL
ghclone git@github.com:eldobo/dotfiles.git     # SSH URL
```
Automatically creates the directory structure and `cd`s into the repo.

### `.claude/CLAUDE.md`
User-level instructions for [Claude Code](https://github.com/anthropics/claude-code) — engineering workflow standards, planning discipline, docs-first development, and debugging methodology. Applied globally to all Claude Code sessions.

## Machine-specific config

For settings that shouldn't be committed (machine-specific paths, work credentials, private env vars), create `~/.zshrc.local`. It's sourced automatically by `.zshrc` but is gitignored.
