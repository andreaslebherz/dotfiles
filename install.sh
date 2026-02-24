#!/usr/bin/env bash

# Exit immediately if any command fails
set -e

# ──────────────────────────────────────────────
# Helpers
# ──────────────────────────────────────────────

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

status() {
  printf "\e[33m⭑\e[0m %s\n" "$1"
}

error() {
  printf "\e[31m✗\e[0m %s\n" "$1" >&2
}

# Create a symlink, backing up any existing non-symlink file/directory first.
# Usage: safe_link <source_in_dotfiles> <target_on_filesystem>
safe_link() {
  local src="$1"
  local dst="$2"

  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$dst")"

  # If the target already exists and is NOT already a symlink pointing here, back it up
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    local backup="${dst}.bak.$(date +%Y%m%d_%H%M%S)"
    status "Backing up existing $(basename "$dst") → $backup"
    mv "$dst" "$backup"
  fi

  # Remove any stale symlink
  [ -L "$dst" ] && rm "$dst"

  ln -sf "$src" "$dst"
  status "Linked $src → $dst"
}

# ──────────────────────────────────────────────
# tmux
# ──────────────────────────────────────────────

status "Setting up tmux config"
safe_link "$DOTFILES_DIR/.config/tmux/.tmux.conf" "$HOME/.config/tmux/.tmux.conf"

# Uncomment the block below if you start using TPM (tmux plugin manager).
# See README for details.
#
# status "Setting up TPM (tmux plugin manager)"
# mkdir -p ~/.config/tmux/plugins
# if [ ! -d ~/.config/tmux/plugins/tpm ]; then
#   git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
# fi

# ──────────────────────────────────────────────
# Neovim
# ──────────────────────────────────────────────

status "Setting up Neovim config"
# Symlink the entire nvim directory so new plugins/files are tracked automatically.
safe_link "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

status "Syncing Neovim plugins via lazy.nvim"
if command -v nvim &> /dev/null; then
  nvim --headless "+Lazy! sync" +qa > /dev/null 2>&1
  status "Plugins synced"
else
  error "nvim not found — skipping plugin sync. Install neovim and re-run."
fi

# ──────────────────────────────────────────────
# Done
# ──────────────────────────────────────────────

status "Installation complete 🚀"
