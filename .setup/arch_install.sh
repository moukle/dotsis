#! /usr/bin/env bash

echo -e -n "\t pacman beepbop"
# exit 0

# install yay
if ! command -v yay &> /dev/null; then
    cd /tmp

    pacman -Sy --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si

    cd -
fi

yay -Sy --needed --noconfirm $@
