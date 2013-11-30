#fix the keyboard to use correct key mappings
if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

#clipboard synchronization
autocutsel -fork &
autocutsel -selection PRIMARY -fork &
