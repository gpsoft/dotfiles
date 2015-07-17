function win() { [[ -n "$WINDIR" ]]; }
function mac() { [ `uname` = "Darwin" ]; }
function linux() { [ `uname` = "Linux" ]; }

alias cd='cd -P'
alias ls='ls --color=auto -F'
alias ll='ls -lrt'

if mac; then
    alias gvim='mvim'
    alias gvimdiff='mvimdiff'
fi

if win; then
    alias ls='ls -F'

    alias Rsv='cd /d/ebica/pg/Rsv/cake/app'
    alias Conf='cd /d/ebica/pg/Conf/cake/app'
    alias Ope='cd /d/ebica/pg/Ope/cake/app'
    alias Docs='cd /d/ebica/reference/Docs'

    cd /d/ebica/pg/Conf/cake/app
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
