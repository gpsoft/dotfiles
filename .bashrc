if [ -f ~/.bashrc.org ]; then
   source ~/.bashrc.org
fi

function win() { [[ -n "$WINDIR" ]]; }
function mac() { [ `uname` = "Darwin" ]; }
function linux() { [ `uname` = "Linux" ]; }

alias cd='cd -P'
alias ls='ls --color=auto -F --show-control-chars'
alias ll='ls -lrt --show-control-chars'

if mac; then
    alias gvim='mvim'
    alias gvimdiff='mvimdiff'
fi

if win; then
    alias ls='ls -F --show-control-chars'
fi


if ! win; then
    eval `dircolors ~/.colorrc`

    PROMPT_DIRTRIM=3
    # PS1='\u \[\033[32m\]\w\[\033[0m\] \$ '
    # PS1='\[\e[0;100m\] \[\e[0m\] \[\e[1;36m\]\w \\$ \[\e[0m\]'
    function __prompt_command() {
        local e="$?"
        PS1=""
        if [ $e != 0 ]; then
            PS1+="\[\e[0;101m\]\h"
        else
            PS1+="\[\e[0;100m\]\h"
        fi
        PS1+="\[\e[0m\] \[\e[1;36m\]\w \\$ \[\e[0m\]"
    }
    PROMPT_COMMAND=__prompt_command
fi

vim()
{
    # Enable to use <C-Q> in vim
    local STTYOPTS="$(stty --save)"
    stty -ixon
    command vim "$@"
    stty "$STTYOPTS"
}

if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi
