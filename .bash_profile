export PATH=$PATH:~/bin:~/local/bin:~/.gem/ruby/2.1.0/bin
export VTE_CJK_WIDTH=1

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

if [ -f /usr/bin/startx ] && [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi
