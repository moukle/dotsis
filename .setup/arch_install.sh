#! /usr/bin/env bash

# echo -e -n "\t pacman beepbop"
# exit 0

chaotic ()
{
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
}

# install yay
if ! command -v yay &> /dev/null; then
    cd /tmp || exit

    sudo pacman -Sy --noconfirm --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg --noconfirm -si

    cd - || exit

    chaotic
fi


yay -Sy --needed --noconfirm "$@"
