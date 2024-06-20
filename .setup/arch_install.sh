#! /usr/bin/env bash

# echo -e -n "\t pacman beepbop"
# exit 0

# install yay
if ! command -v yay &> /dev/null; then
    cd /tmp || exit

    sudo pacman -Sy --noconfirm --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg --noconfirm -si

    cd - || exit
fi

yay -Sy --needed --noconfirm "$@"
