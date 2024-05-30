#! /usr/bin/env bash

echo -e -n "\t pacman beepbop"
# exit 0

# install yay
if ! command -v paru &> /dev/null; then
    cd /tmp

    pacman -Sy --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si

    cd -
fi

paru -Sy --needed --noconfirm $@
