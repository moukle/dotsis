#! /usr/bin/env sh

# set_wall.sh is being replaced by wallpaper_timer.sh

if [ $test $(dconf read /org/gnome/desktop/interface/color-scheme) = "'prefer-dark'" ]; then
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
    walr.sh ayu -l
    # set_wall.sh $HOME/Pictures/Walls/light
else
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
    walr.sh hal
    # set_wall.sh $HOME/Pictures/Walls/dark
fi
