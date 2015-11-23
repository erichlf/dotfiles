#clipboard synchronization
autocutsel -fork &
autocutsel -selection PRIMARY -fork &

xsetroot -cursor_name left_ptr
xrdb $HOME/.Xresources &
#fix the keyboard to use correct key mappings
if [ -s $HOME/.Xmodmap ]; then
    xmodmap $HOME/.Xmodmap
fi
