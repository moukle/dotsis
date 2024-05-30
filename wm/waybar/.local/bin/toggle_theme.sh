#! /usr/bin/env sh

if [ $test $(dconf read /org/gnome/desktop/interface/color-scheme) = "'prefer-dark'" ]; then
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
else
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
fi
