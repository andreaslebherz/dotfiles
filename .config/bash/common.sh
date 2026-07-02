# PATH: standard user bins
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# PATH: dotfiles tools
export PATH="$PATH:$HOME/.dual-graph"

# Aliases
alias sb="source ~/.bashrc"
alias vb="vi ~/.bashrc"
alias r="reset"
# alias st="if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then git status; else cd ~/repos/YOUR_PROJECT && git status; fi"
alias pull="git pull && git submodule update --recursive"

# Ghostty shell integration — emits OSC 7 (CWD) so splits open in correct directory
if [ -n "$GHOSTTY_RESOURCES_DIR" ]; then
    builtin source "$GHOSTTY_RESOURCES_DIR/shell-integration/bash/ghostty.bash"
fi
