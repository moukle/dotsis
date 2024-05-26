#! /usr/bin/env bash

set -e

packages_base=(
    "gum"
    "stow"
)

packages_cli=(
    "curl"
    "fish"
    "fzf"
    "git"
    "gotop"
    "neovim"
    "pywal"
    "starship"
    "tmux"
    "unzip"
    "yazi"
    "zsh"
)

packages_gui=(
    "code"
    "firefox"
    "kitty"
    "pavucontrol"
    "zathura"
)

packages_wm=(
    "anyrun"
    "dunst"
    "hyprland"
    "libnotify"
    "pipewire"
    "waybar"
)

packages_nvidia=(
    "nvidia"
    "nvidia-utils"
    "cuda"
)

packages_fonts=(
    "ttf-maple"
    "lexend-fonts-git"
)

packages_gaming=(
    "ddnet"
    "steam"
    "vulkan-icd-loader"
    "lib32-vulkan-icd-loader"
)

packages_laptop=(
    "bluez"
    "blueman"
)

options_packages=(
    "packages_cli"
    "packages_gui"
    "packages_wm"
    "packages_nvidia"
    "packages_fonts"
    "packages_gaming"
    "packages_laptop"
)

install_pkgs() {
    echo " Installing: $@"
    if ! command -v gum &> /dev/null
    then
        ./arch_install.sh $@
    else
        gum spin --title "..." --spinner dot --show-output -- ./arch_install.sh $@
    fi
}

stow_pkgs()
{
    echo -n " Stowing: "
    for pkg in $@
    do
        if [ -d $pkg ]; then
            echo -n "$pkg "
            # stow $pkg
        fi
    done
    echo
}

gum_style_list() {
    # header = $1
    # content = ${@:2}

    gum style \
        --border normal --border-foreground 8 \
        --align center \
        --margin "0 1" --padding "1 2" \
        "$(gum style --foreground 1 $1)" "" \
        "${@:2}"
}

# install required pkgs
install_pkgs ${packages_base[@]}

# welcome
gum style --border normal --margin "1" --padding "1 2" --border-foreground 2 "Hello, there! Welcome to $(gum style --foreground 2 'Post-Installer')."

# pick packages

# gum join \
#     "$(gum_style_list "base" ${packages_base[@]})" \
#     "$(gum_style_list "cli" ${packages_cli[@]})" \
#     "$(gum_style_list "wm" ${packages_wm[@]})"

gum_command="gum join"
for option in ${options_packages[@]}; do
    group_name=${option#*_}
    pkgs=$(eval "echo \${${option}[@]}")
    gum_command+=" \"\$(gum_style_list \"$group_name\" $pkgs)\""
done
eval $gum_command

SELECT_PACKAGES=$(gum choose --no-limit \
    --header "Installing <space>" ${options_packages[@]})
    # --selected=${options_packages[0]},${options_packages[1]} \
gum log "Selected: " ${SELECT_PACKAGES[@]}

# install and stow
for package_set in ${SELECT_PACKAGES[@]}; do
    echo $package_set
    cd ../${package_set#*_}
    for pkgs in $package_set[@]
    do
        install_pkgs ${!pkgs}
        stow_pkgs ${!pkgs}
    done
    cd -
    echo ""
done

# TODO: wal
# ln -sf "${HOME}/.cache/wal/dunstrc"   "${HOME}/.config/dunst/dunstrc"
# ln -sf "${HOME}/.cache/wal/zathurarc" "${HOME}/.config/zathura/zathurarc"
