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
