## Dotfiles

Dotfiles for...

- bash
- vim
- git
- hg(Mercurial)

## Usage

### First time(Install)
Assuming that you're using bash(git bash if on Windows)...

    cd
    git clone https://github.com/gpsoft/dotfiles
    cd dotfiles
    ./install.sh
    source ~/.bash_profile

Note that you must run git bash __as admin__ to install on Windows because install.sh uses mklink.

### From time to time(Update)
    cd ~/dotfiles
    git pull
    git submodule update

## Note

### Goal
I use Windows, Mac, and Linux(mainly Gentoo).
So my goal is to have all dotfiles shared in these OS's,
then eventually in all computers that I use.

### Git submodules
Most vim plugins are embedded as git submodule. To pull a submodule from original repo:

    cd ~/dotfiles/vimfiles/bundle/awesome-plugin
    git pull
    cd ..
    git commit -am "update awesome-plugin"

Or to pull all submodules:

    cd ~/dotfiles
    git submodule foreach git pull
    git commit -am "update all plugins"

And don't forget to push to the upstream.

### Symbolic links on Windows
When you edit one of dotfiles on Windows, you'd better open the file directly
instead of opening through its symbolic link.

### Git for Windows memo

About installation:
- Git-1.9.5-preview20150319.exe
- uncheck all options such as explorer integration
- select "Use Git from the Windows Command Prompt" about PATH
- select "Checkout as-is, commit as-is" about EOL conversion

About firewall:
- add following files to the white-list of your firewall
  - Git/bin/sh.exe
  - Git/bin/bash.exe
  - Git/bin/ssh.exe
  - Git/bin/git.exe
  - Git/libexec/git-core/git-remote-https.exe

About git bash:
- change fonts back and forth until it shows multi-byte characters correctly
- turn off "Enable Ctrl shortcut key(something like that)" option that introduced in Windows 10

