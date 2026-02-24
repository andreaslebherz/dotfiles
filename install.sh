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
safe_link() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    local backup="${dst}.bak.$(date +%Y%m%d_%H%M%S)"
    status "Backing up existing $(basename "$dst") → $backup"
    mv "$dst" "$backup"
  fi

  [ -L "$dst" ] && rm "$dst"

  ln -sf "$src" "$dst"
  status "Linked $src → $dst"
}

# ──────────────────────────────────────────────
# Ghostty
# ──────────────────────────────────────────────

status "Setting up Ghostty config"
# Linking the config file specifically to match standard Ghostty pathing
safe_link "$DOTFILES_DIR/.config/ghostty/config" "$HOME/.config/ghostty/config"

# ──────────────────────────────────────────────
# tmux
# ──────────────────────────────────────────────

status "Setting up tmux config"
safe_link "$DOTFILES_DIR/.config/tmux/.tmux.conf" "$HOME/.config/tmux/.tmux.conf"

# ──────────────────────────────────────────────
# Neovim
# ──────────────────────────────────────────────

status "Setting up Neovim config"
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
