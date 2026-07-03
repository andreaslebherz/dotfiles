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

# Inside nvim's built-in terminal, WezTerm/tmux shell-integration escapes
# (OSC 7 CWD + OSC 1337 user-vars) can't be parsed and leak as raw text on the
# prompt. nvim exports $NVIM in :term children, so suppress the hooks there.
if [ -n "$NVIM" ]; then
    export WEZTERM_SHELL_SKIP_ALL=1
    PROMPT_COMMAND=""
fi
