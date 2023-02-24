#!/usr/bin/env bash

##### UTILITY FUNCTIONS
function win() { [[ -n "$WINDIR" ]]; }
function mac() { [ `uname` = "Darwin" ]; }
function linux() { [ `uname` = "Linux" ]; }

# winpath /c/windows/win.ini
# it echoes c:\windows\win.ini
function winpath() {
    local p=${1/\//}
    p=${p/\//:\\}
    echo ${p//\//\\}
}

# delete a symlink
function dellink() {
    if win; then
        local c="del"
        if [[ -d "$1" ]]; then
            c="rd"
        fi
        cmd <<<"$c \"`winpath $1`\"" >/dev/null
    else
        rm "$1"
    fi
}

# make a symlink or test if it exists
# usage: symlink <LINK> [<REAL>]
# symlink ~/.bashrc ~/dotfiles/.bashrc
function symlink() {
    # second arg is optional.
    if [[ -z "$2" ]]; then
        # test if it's already been linked.
        if win; then
            fsutil reparsepoint query "$1" >/dev/null
        else
            [[ -h "$1" ]]
        fi
        return $?
    fi

    # abort if <REAL> doesn't exist.
    if [[ ! -e "$2" ]]; then
        echo "$2 doesn't exist"
        return 1
    fi

    # delete if it's already been linked.
    if symlink "$1"; then
        echo removing $1.
        dellink $1
    fi

    # save it if 1st arg is a real dir/file.
    if [[ -e "$1" ]]; then
        moveorg $1
    fi

    # make a link.
    echo linking from $1 to $2.
    if win; then
        local o=""
        if [[ -d "$2" ]]; then
            o="/D"
        fi
        # You need to run the shell AS ADMIN to do this!
        cmd <<<"mklink $o \"`winpath $1`\" \"`winpath $2`\"" >/dev/null
        return $?
    fi
    ln -s "$2" "$1"
}

# move the original file
# moveorg <FILE>
function moveorg() {
    local o="$1.org"
    if [[ -e $o ]]; then
        echo "CANNOT CONTINUE; $o already exists."
        exit -1
    fi
    echo moving original to $o.
    if win; then
        cmd <<<"move \"`winpath $1`\" \"`winpath $o`\"" >/dev/null
    else
        mv "$1" "$o"
    fi
}

# move a file to temp dir.
function movetotmp() {
    local t="/var/tmp"
    if win; then
        t="$HOME/AppData/Local/Temp"
        # can't use $TMP here.
    fi
    echo MOVING $1 TO $t.
    echo RESCUE THEM IF YOU NEED.
    if win; then
        cmd <<<"move \"`winpath $1`\" \"`winpath $t`\"" >/dev/null
    else
        mv "$1" "$t"
    fi
}




##### OPERATION FUNCTIONS

# a wrapper to call symlink.
# usage: linkhome <REAL_AND_LINK> [<REAL-ALT>]
# linkhome hoge       ... link hoge to ~/hoge
# linkhome hoge fuga  ... link fuga to ~/hoge
function linkhome() {
    local real=$1
    if [[ -n "$2" ]]; then
        real=$2
    fi
    symlink ~/$1 `pwd`/$real;
}

# copy a template file to home
function copytempl() {
    if [[ -e ~/$1 ]]; then
        movetotmp ~/$1
    fi
    if [[ -e $1.template ]]; then
        echo copying $1.template to ~
        cp $1.template ~/$1
    fi
}





if mac; then
    linkhome .zprofile  sh_profile.mac
    linkhome .zshrc     shrc.mac
else
    exit
fi
linkhome .gitconfig        gitconfig
linkhome .gitignore_global gitignore_global
linkhome .tmux.conf        tmux.conf
linkhome .vim       vimfiles
linkhome .vimrc     vimrc
exit






##### MAKE SYMBOLIC LINKS
if mac; then
    mkdir -p /var/tmp/bak
    linkhome .bash_profile .bash_profile.mac
elif win; then
    linkhome .bash_profile .bash_profile.win
else
    mkdir -p /var/tmp/bak
    linkhome .bash_profile
    linkhome .profile
    linkhome .xprofile
fi
linkhome .bashrc
linkhome .colorrc
linkhome .gitconfig
linkhome .gitignore_global
linkhome .vimrc
linkhome .gvimrc
linkhome .vrapperrc
linkhome .tmux.conf
if win; then
    linkhome vimfiles
else
    linkhome .vim vimfiles
fi

copytempl .bashrc.local
copytempl .vimrc.constants.local
copytempl .vimrc.local
copytempl .gvimrc.local

##### UPDATE GIT SUBMODULES
git checkout renewal2017
git pull
git submodule init
echo updating submodules.
git submodule update
