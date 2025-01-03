#! /usr/bin/env bash

# quit on fail
set -e

source ./packages.sh

install_pkgs() {
    echo " Installing: " "$@"
    if ! command -v gum &> /dev/null
    then
        ./arch_install.sh "$@"
    else
        #./arch_install.sh $@
        # gum spin --title "..." --spinner dot --show-output -- ./arch_install.sh "$@"
        ./arch_install.sh "$@"
    fi
}

stow_pkgs() {
    if [ ! -d ../"$1" ]; then
        echo "No dots for $1"
        return
    fi

    cd ../"$1"

    echo -n " Stowing: "
    for pkg in "${@:2}"
    do
        if [ -d "$pkg" ]; then
            echo -n "$pkg "
            stow --target="$HOME" "$pkg"
        fi
    done
    echo

    cd -
}

gum_style_list() {
    gum style \
        --border normal --border-foreground 8 \
        --align center \
        --margin "0 1" --padding "1 2" \
        "$(gum style --foreground 1 "$1")" "" \
        "${@:2}"
    }

# install required pkgs
packages_base=( "gum" "stow")
install_pkgs "${packages_base[@]}"

# welcome
gum style --border normal --margin "1" --padding "1 2" --border-foreground 2 "Hello, there! Welcome to $(gum style --foreground 2 'Post-Installer')."

# print packages
gum_command="gum join"
for option in "${options_packages[@]}"; do
    group_name=${option#*_}
    pkgs=$(eval "echo \${${option}[@]}")
    gum_command+=" \"\$(gum_style_list \"$group_name\" $pkgs)\""
done
eval "$gum_command"

# pick packages
select_options=$(gum choose --no-limit \
    --header "Installing <space>" "${options_packages[@]}")
    # --selected=${options_packages[0]},${options_packages[1]} \
    gum log "Selected: " "${select_options[@]}"

# install and stow
mkdir -p ~/.local/bin/

for package_set in ${select_options[@]}; do
    echo "$package_set"
    for pkgs in $package_set[@]
    do
        echo ${!pkgs}
        install_pkgs "${!pkgs}"
        stow_pkgs "${package_set#*_}" "${!pkgs}"
    done
    echo ""
done

# [TODO): wal
# ln -sf "${HOME}/.cache/wal/dunstrc"   "${HOME}/.config/dunst/dunstrc"
# ln -sf "${HOME}/.cache/wal/zathurarc" "${HOME}/.config/zathura/zathurarc"

# set shell
if ! $(cat /etc/passwd | grep -q zsh); then
    chsh -s /usr/bin/zsh "$USER"
fi

# TODO: ask with gum...
sudo cp -rf ../etc/pacman.conf /etc/pacman.conf  # colors, chaotic, ...
sudo cp -rf ../etc/grub /etc/default/grub        # nvidia ...
sudo cp -rf ../etc/sudoers /etc/sudoers          # show ***
sudo usermod -aG gamemode $USER

# make it a ssh repo...
git remote set-url origin git@github.com:moukle/dotsis.git

gum style --border normal --margin "1" --padding "1 2" --border-foreground 2 "Finished. $(gum style --foreground 2 'Have Fun!')."
