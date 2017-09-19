#!/usr/bin/env bash

##### FUNCTIONS
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

# usage: symlink <LINK> <REAL>
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
        if win; then
            local c="del"
            if [[ -d "$1" ]]; then
                c="rd"
            fi
            cmd <<<"$c \"`winpath $1`\"" >/dev/null
        else
            rm "$1"
        fi
    fi

    # move away if 1st arg is a real dir/file.
    if [[ -e "$1" ]]; then
        movetotmp ~/$1
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

# a wrapper to call symlink.
function linkhome() {
    local real=$1
    if [[ -n "$2" ]]; then
        real=$2
    fi
    symlink ~/$1 `pwd`/$real;
}

# move a file to temp dir.
function movetotmp() {
    local t="/tmp"
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

##### MAKE SYMBOLIC LINKS
if mac; then
    linkhome .bash_profile .bash_profile.mac
elif win; then
    linkhome .bash_profile .bash_profile.win
else
    linkhome .bash_profile
fi
linkhome .bashrc
linkhome .colorrc
linkhome .gitconfig
linkhome .gitignore_global
linkhome .hgignore_global
linkhome .hgrc
linkhome .vimrc
linkhome .gvimrc
linkhome .vrapperrc
linkhome .vimperatorrc
linkhome .vimperator
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
git checkout master
git pull
git submodule init
echo updating submodules.
git submodule update
