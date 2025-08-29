# .zshrc

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]] ; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

###########
# ALIASES #
###########

# Replace ls with exa
alias ls='exa -aalgF --git --color=always --group-directories-first --icons' # preferred listing
alias lt='exa -aT --color=always --group-directories-first --icons'          # tree listing
alias l.="exa -a | egrep '^\.'"                                              # show only dotfiles

# Custom git overrides
git() {
    local command
    command="${1:-}"
    if [ "$#" -gt 0 ]; then
        shift
    fi

    case "$command" in
        "log")
            command git log --graph --pretty=format:"%C(magenta)%h %C(black)%G? %C(blue)%an %C(black)%ar%C(auto)  %D%n%s%n" "$@"
            ;;
        "")
            command git
            ;;
        *)
            command git "$command" "$@"
            ;;
    esac
}

# Cd shows ls
function cd {
    builtin cd "$@" > /dev/null && pwd && ls -F
}

# Quit with q
alias q="exit"

# Continue partial download
alias wget='wget -c '

# Colored grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Python stuff
alias py="python3"
function pyvenv {
    [ ! -d "venv" ] && python -m venv venv
    source venv/bin/activate
}
alias pyreq="python -m pip install -U -r requirements.txt"

# Arch linux stuff
if [ "$(grep -e '^ID=' /etc/os-release | cut -d '=' -f 2)" = "arch" ] ; then

    # Interactive paru -R
    paru() {
        local command
        command="${1:-}"
        if [ "$#" -gt 0 ]; then
            shift
        fi

        case "$command" in
            "-R")
                pacman-R "$@"
                ;;
            "")
                command paru
                ;;
            *)
                command paru "$command" "$@"
                ;;
        esac
    }

    # Delete pacman database lock
    alias fixpacman="sudo rm /var/lib/pacman/db.lck"

    # Sort installed packages according to size in MB
    alias big="expac -H M '%m\t%n' | sort -h | nl"

    # Get fastest mirrors
    alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"

    # Recent installed packages
    alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

fi

# Aliases with sudo
alias sudo='sudo '

##########
# CONFIG #
##########

# History
HISTFILE=~/.zhistory
HISTSIZE=50000
SAVEHIST=10000

# Starship prompt + matching sudo prompt
eval "$(starship init zsh)"
export SUDO_PROMPT="$(echo -e "\e[0m\n \e[0;31m╭─\e[1;31mSUDO\e[0m: \e[1;33mpassword\e[0m for \e[1;31m$USER\e[0m@\e[31m$(hostname)\e[0m\n \e[0;31m╰─\e[1;31mλ\e[0m ")"

# Options
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt auto_pushd                                               # Push pwd onto stack (cd -)
setopt pushd_ignore_dups                                        # No duplicates in pwd stack
setopt pushd_minus                                              # Allow multiple cd - (cd -2)

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' rehash true                              # Automatically find new executables in path
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zcache

# Automatically load bash completion functions
autoload -U +X bashcompinit && bashcompinit

# Autosuggestion
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null || echo "No zsh-autosuggestions!"

# Syntax highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets regexp)
typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_REGEXP+=(' -{1,2}[a-zA-Z0-9_-]*' fg=000,bold)
ZSH_HIGHLIGHT_REGEXP+=('^sudo' fg=red,underline,bold)
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null || echo "No zsh-syntax-highlighting!"
ZSH_HIGHLIGHT_STYLES[precommand]=fg=red,underline,bold
ZSH_HIGHLIGHT_STYLES[arg0]=fg=blue,bold

# Use fzf for history search and completions
source /usr/share/fzf/shell/key-bindings.zsh 2>/dev/null || source /usr/share/fzf/key-bindings.zsh 2>/dev/null || source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null || echo "No fzf/key-bindings!"
source /usr/share/fzf/shell/completion.zsh 2>/dev/null || source /usr/share/fzf/completion.zsh 2>/dev/null || source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null || echo "No fzf/completion!"

########
# KEYS #
########

# Use emacs key bindings
bindkey -e

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
    bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
    bindkey -M viins "${terminfo[kpp]}" up-line-or-history
    bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi

# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
    bindkey -M emacs "${terminfo[knp]}" down-line-or-history
    bindkey -M viins "${terminfo[knp]}" down-line-or-history
    bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

# Start typing + [Up-Arrow] - Fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search

    bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
    bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
    bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Start typing + [Down-Arrow] - Fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search

    bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
    bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
    bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
    bindkey -M emacs "${terminfo[khome]}" beginning-of-line
    bindkey -M viins "${terminfo[khome]}" beginning-of-line
    bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
fi

# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
    bindkey -M emacs "${terminfo[kend]}"  end-of-line
    bindkey -M viins "${terminfo[kend]}"  end-of-line
    bindkey -M vicmd "${terminfo[kend]}"  end-of-line
fi

# [Shift-Tab] - Move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
    bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
    bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
    bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# [Backspace] - Delete backward
bindkey -M emacs "^?" backward-delete-char
bindkey -M viins "^?" backward-delete-char
bindkey -M vicmd "^?" backward-delete-char

# [Delete] - Delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
    bindkey -M emacs "${terminfo[kdch1]}" delete-char
    bindkey -M viins "${terminfo[kdch1]}" delete-char
    bindkey -M vicmd "${terminfo[kdch1]}" delete-char
else
    bindkey -M emacs "^[[3~" delete-char
    bindkey -M viins "^[[3~" delete-char
    bindkey -M vicmd "^[[3~" delete-char

    bindkey -M emacs "^[3;5~" delete-char
    bindkey -M viins "^[3;5~" delete-char
    bindkey -M vicmd "^[3;5~" delete-char
fi

# [Ctrl + Left|Right] - Move through words
bindkey -M emacs "^[[1;5C" forward-word
bindkey -M viins "^[[1;5C" forward-word
bindkey -M vicmd "^[[1;5C" forward-word
bindkey -M emacs "^[[1;5D" backward-word
bindkey -M viins "^[[1;5D" backward-word
bindkey -M vicmd "^[[1;5D" backward-word

# [Ctrl + Backspace] - Delete word
bindkey -M emacs "^H" backward-kill-word
bindkey -M viins "^H" backward-kill-word
bindkey -M vicmd "^H" backward-kill-word

# [Ctrl + Delete] - Delete word forward
bindkey -M emacs "^[[3;5~" kill-word
bindkey -M viins "^[[3;5~" kill-word
bindkey -M vicmd "^[[3;5~" kill-word

# [Ctrl + Z/Y] - Undo and redo
bindkey -M emacs "^Z" undo
bindkey -M viins "^Z" undo
bindkey -M vicmd "^Z" undo
bindkey -M emacs "^Y" redo
bindkey -M viins "^Y" redo
bindkey -M vicmd "^Y" redo

# Stop Ctrl+Backspace and Ctrl+Right/Left in more places
WORDCHARS=' `~!@#$%^&*()=+-[{]}\|;:",.<>/?'"'"
autoload -Uz select-word-style
select-word-style normal
zstyle ':zle:*' word-style unspecified

# Make sure the terminal is in application mode when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start { echoti smkx }
    function zle_application_mode_stop { echoti rmkx }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi
