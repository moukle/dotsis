#!/usr/bin/env bash

wal --theme $@

if [[ "$*" == *"-l"* ]]
then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    gsettings set org.gnome.desktop.interface gtk-theme "Plata-Lumine"
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme "phocus"
fi

mkdir -p ~/.config/zathura
mkdir -p ~/.config/dunst

ln -sf "${HOME}/.cache/wal/zathurarc" "${HOME}/.config/zathura/zathurarc"
ln -sf "${HOME}/.cache/wal/dunstrc" "${HOME}/.config/dunst/dunstrc"

pkill dunst; dunst &
