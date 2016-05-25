export PATH=$PATH:~/bin

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

if [ -f /usr/bin/startx ] && [ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ]; then
    exec startx
fi
