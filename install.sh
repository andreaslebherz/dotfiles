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

is_wsl() {
  [ -n "${WSL_DISTRO_NAME:-}" ]
}

# Download a URL into a fresh temp dir and print the file path.
fetch() {
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/$(basename "$1")" "$1" && echo "$tmp/$(basename "$1")"
}

# ──────────────────────────────────────────────
# WSL: tools
# ──────────────────────────────────────────────

if is_wsl; then
  status "Installing apt packages"
  sudo apt-get update -qq
  sudo apt-get install -y -qq build-essential curl unzip ripgrep fd-find \
    nodejs npm python3-venv clang-format tmux

  mkdir -p "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"

  # Ubuntu's apt nvim is too old for vim.lsp.config (needs 0.11+).
  if ! command -v nvim &> /dev/null; then
    status "Installing Neovim (latest release)"
    archive="$(fetch https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz)"
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf "$archive"
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  fi

  # nvim-treesitter main branch compiles parsers with the CLI.
  if ! command -v tree-sitter &> /dev/null; then
    status "Installing tree-sitter CLI"
    archive="$(fetch https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz)"
    gunzip -c "$archive" > "$HOME/.local/bin/tree-sitter"
    chmod +x "$HOME/.local/bin/tree-sitter"
  fi

  # Clipboard bridge for nvim (unnamedplus) and tmux copy-mode.
  if ! command -v win32yank.exe &> /dev/null; then
    status "Installing win32yank"
    archive="$(fetch https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip)"
    unzip -p "$archive" win32yank.exe | sudo tee /usr/local/bin/win32yank.exe > /dev/null
    sudo chmod +x /usr/local/bin/win32yank.exe
  fi

  # Ubuntu ships fd as fdfind; telescope looks for fd.
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

# ──────────────────────────────────────────────
# Bash
# ──────────────────────────────────────────────

status "Setting up bash common config"
safe_link "$DOTFILES_DIR/.config/bash/common.sh" "$HOME/.config/bash/common.sh"

bash_hook='[ -f ~/.config/bash/common.sh ] && source ~/.config/bash/common.sh'
if ! grep -qF "$bash_hook" "$HOME/.bashrc" 2>/dev/null; then
  echo "$bash_hook" >> "$HOME/.bashrc"
  status "Added common.sh hook to ~/.bashrc"
fi

# ──────────────────────────────────────────────
# Ghostty
# ──────────────────────────────────────────────

status "Setting up Ghostty config"
# Linking the config file specifically to match standard Ghostty pathing
safe_link "$DOTFILES_DIR/.config/ghostty/config" "$HOME/.config/ghostty/config"

# ──────────────────────────────────────────────
# WezTerm
# ──────────────────────────────────────────────

status "Setting up WezTerm config"
safe_link "$DOTFILES_DIR/.config/wezterm" "$HOME/.config/wezterm"

# ──────────────────────────────────────────────
# tmux
# ──────────────────────────────────────────────

status "Setting up tmux config"
safe_link "$DOTFILES_DIR/.config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

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
# clang-format
# ──────────────────────────────────────────────

status "Setting up global clang-format config"
safe_link "$DOTFILES_DIR/.config/clang-format/.clang-format" "$HOME/.clang-format"

# ──────────────────────────────────────────────
# Claude Code
# ──────────────────────────────────────────────
mkdir -p ~/.claude
ln -sf ~/repos/dotfiles/.claude/CLAUDE.md ~/.claude/CLAUDE.md

# ──────────────────────────────────────────────
# WSL: Windows side (WezTerm runs on Windows, not in WSL)
# ──────────────────────────────────────────────

if is_wsl; then
  win_home="$(wslpath "$(powershell.exe -NoProfile -Command '$env:USERPROFILE' | tr -d '\r')")"

  # Windows can't follow WSL symlinks, so a stub loads the repo config via \\wsl$.
  status "Writing WezTerm config stub"
  unc_path="\\\\wsl\$\\${WSL_DISTRO_NAME}${DOTFILES_DIR//\//\\}\\.config\\wezterm\\wezterm.lua"
  stub="return dofile([[${unc_path}]])"
  stub_file="$win_home/.wezterm.lua"
  if [ -f "$stub_file" ] && [ "$(cat "$stub_file")" != "$stub" ]; then
    backup="${stub_file}.bak.$(date +%Y%m%d_%H%M%S)"
    status "Backing up existing .wezterm.lua → $backup"
    mv "$stub_file" "$backup"
  fi
  echo "$stub" > "$stub_file"

  status "Creating WezTerm Start Menu shortcut (Ctrl+Alt+T)"
  powershell.exe -NoProfile -Command '
    $exe = "$env:ProgramFiles\WezTerm\wezterm-gui.exe"
    if (-not (Test-Path $exe)) { exit 1 }
    $lnk = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\WezTerm.lnk"
    $s = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk)
    $s.TargetPath = $exe
    $s.WorkingDirectory = Split-Path $exe
    $s.Hotkey = "CTRL+ALT+T"
    $s.Save()' \
    || error "WezTerm not found on Windows - install it (winget install wez.wezterm) and re-run."

  if ! compgen -G "/mnt/c/Windows/Fonts/FiraCodeNerdFont*" > /dev/null \
    && ! compgen -G "$win_home/AppData/Local/Microsoft/Windows/Fonts/FiraCodeNerdFont*" > /dev/null; then
    error "FiraCode Nerd Font missing on Windows - download FiraCode.zip from https://www.nerdfonts.com/font-downloads, select all .ttf, 'Install for all users'."
  fi
fi

# ──────────────────────────────────────────────
# Done
# ──────────────────────────────────────────────

status "Installation complete 🚀"
