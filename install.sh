#!/usr/bin/env bash
# install.sh — symlink dotfiles into place
# Safe to run multiple times (idempotent)

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

symlink() {
  local src="$DOTFILES_DIR/$1"
  local dest="$HOME/$1"
  local dest_dir="$(dirname "$dest")"

  mkdir -p "$dest_dir"

  if [ -L "$dest" ]; then
    echo "  already linked: $dest"
  elif [ -e "$dest" ]; then
    echo "  backing up existing: $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
    ln -s "$src" "$dest"
    echo "  linked: $dest"
  else
    ln -s "$src" "$dest"
    echo "  linked: $dest"
  fi
}

echo "Installing dotfiles from $DOTFILES_DIR..."

symlink ".claude/CLAUDE.md"

# Add more symlinks here as you add files to this repo, e.g.:
# symlink ".gitconfig"
# symlink ".zshrc"

echo "Done."
