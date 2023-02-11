## Dotfiles

My dotfiles for...

- bash/zsh
- vim
- git
- and more

## Goal

- work on Win(Gvim, DOS prompt and git bash)/Mac(terminal)/Linux(Gvim and terminal)
- take care of machine local settings
- semi-automatic

## Checkpoints
### Vim

- `,vs` shortcut
- `listchars` and `ambiwidth`
- `ColorColumn`
- off ime when normal mode

# === out dated ===
## Usage

This is a message for myself as I'm the only user.

### First time(Install)
Assuming that you're using bash(git bash if on Windows)...

    cd
    git clone https://github.com/gpsoft/dotfiles
    cd dotfiles
    ./install.sh
    source ~/.bash_profile

Note that you must run git bash __as admin__ to install on Windows because install.sh uses mklink.

You can put some machine-depend settings in .bashrc.local or .vimrc.constants.local. You've got templates in the dotfiles directory.

### From time to time(Update)
    cd ~/dotfiles
    git pull
    git submodule update --init

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

And don't forget to push your repo to the upstream.

### Symbolic links on Windows
When you edit one of dotfiles on Windows, you'd better open the file directly
instead of opening through its symbolic link.

### Git for Windows memo

About installation:
- Git-1.9.5-preview20150319.exe
- uncheck all options such as explorer integration
- select "Use Git from the Windows Command Prompt" about PATH
  - select third option or add PATH yourself for unix commands such as diff
  - some vim commands, like diffthis and Gdiff, need it
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
- turn off "Enable Ctrl shortcut key(something like that)" option that was introduced in Windows 10

