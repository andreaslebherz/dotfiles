# dotfiles

Personal configuration files for:

- **Neovim** — Lua config with [lazy.nvim](https://github.com/folke/lazy.nvim)
- **tmux** — Vim-style keybindings, true-color support

## Structure

```
dotfiles/
├── .config/
│   ├── nvim/
│   │   ├── init.lua
│   │   ├── lazy-lock.json
│   │   └── lua/
│   │       ├── config/
│   │       │   ├── keymaps.lua
│   │       │   ├── lazy.lua
│   │       │   └── options.lua
│   │       └── plugins/
│   │           ├── formatting.lua
│   │           ├── telescope.lua
│   │           ├── theme.lua
│   │           └── treesitter.lua
│   └── tmux/
│       └── .tmux.conf
└── install.sh
```

The install script uses **symlinks** — configs live in this repo and the system config
paths point here. Editing a file in either location edits the same file.

## Installation

```bash
git clone git@github.com:andreaslebherz/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles
chmod +x install.sh
./install.sh
```

The script will:

1. Symlink `~/.config/tmux/.tmux.conf` → `dotfiles/.config/tmux/.tmux.conf`
2. Symlink `~/.config/nvim` → `dotfiles/.config/nvim` (entire directory)
3. Run `nvim --headless "+Lazy! sync" +qa` to install all plugins

Any pre-existing file/directory is automatically backed up with a timestamped `.bak` suffix before being replaced.

## tmux: TPM (plugin manager)

Currently no plugins are used. If you decide to add tmux plugins later:

1. Add `set -g @plugin '...'` entries to `.tmux.conf`
2. Append the TPM bootstrap lines at the bottom of `.tmux.conf`
3. Uncomment the TPM block in `install.sh`

TPM bootstrap snippet for `.tmux.conf`:
```
set -g @plugin 'tmux-plugins/tpm'
run '~/.config/tmux/plugins/tpm/tpm'
```

## Adding new dotfiles

1. Create the matching directory under `.config/` (e.g. `.config/ghostty/`)
2. Copy the file there
3. Add a `safe_link` call in `install.sh`
4. Commit and push
