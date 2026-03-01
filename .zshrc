# PATH
export PATH="$HOME/.local/bin:$PATH"

# Navigation
alias ll="ls -la"
alias la="ls -A"
alias ..="cd .."
alias ...="cd ../.."

# Git shortcuts
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gaa="git add -A"
alias gc="git commit"
alias gco="git checkout"
alias gl="git lg"
alias gp="git push"
alias gpl="git pull"

# Clone a GitHub repo into ~/github.com/<org>/<repo> and cd into it
# Usage:
#   ghclone eldobo/dotfiles
#   ghclone https://github.com/eldobo/dotfiles
#   ghclone git@github.com:eldobo/dotfiles.git
ghclone() {
  local input="$1"
  local base="$HOME/github.com"
  local path

  if [[ "$input" =~ ^git@github\.com:(.+?)(\.git)?$ ]]; then
    path="${match[1]}"
  elif [[ "$input" =~ ^https://github\.com/(.+?)(\.git)?$ ]]; then
    path="${match[1]}"
  elif [[ "$input" =~ ^[^/]+/[^/]+$ ]]; then
    path="$input"
    input="git@github.com:$input.git"
  else
    echo "Usage: ghclone <org/repo> | <https://github.com/...> | <git@github.com:...>"
    return 1
  fi

  local dest="$base/$path"
  mkdir -p "$(dirname "$dest")"
  git clone "$input" "$dest" && cd "$dest"
}

# Load machine-specific overrides (not committed)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
