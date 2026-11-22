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

# tmux: attach to (or create) a session; inside tmux, switch instead of nesting.
tm() {
    if [ -z "$1" ]; then
        tmux attach 2>/dev/null || tmux new-session
    elif [ -n "$TMUX" ]; then
        tmux has-session -t "=$1" 2>/dev/null || tmux new-session -d -s "$1"
        tmux switch-client -t "=$1"
    else
        tmux new-session -A -s "$1"
    fi
}

_tm_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W "$(tmux list-sessions -F '#S' 2>/dev/null)" -- "$cur"))
}
complete -F _tm_complete tm
