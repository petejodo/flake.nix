if status is-interactive
    starship init fish | source
end

function fish_greeting
    fastfetch
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

# Utility to quickly copy backup of file
function backup --argument filename
    cp $filename $filename.bak
end

if test -d ~/.local/state
    # Enable history in erlang/elixir interpreters
    set -gx ERL_AFLAGS "-kernel shell_history enabled -kernel shell_history_path '\"~/.local/state/erlang\"'"
end

# Useful aliases

## Shortcut for git
alias g='git'

## Replace ls with eza
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons -I .git' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles

## Replace cat with bat
alias cat='bat'

## Utilities
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Setup zoxide
zoxide init fish | source
