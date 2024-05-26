#! /usr/bin/env bash

set -e

packages_base=(
    "git"
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
    "tmux"
    "yazi"
    "zsh"
)

packages_desktop=(
    "dunst"
    "hyprland"
    "waybar"
)

packages_nvidia=(
    "nvidia"
    "cuda"
)

options_packages=(
    "packages_cli"
    "packages_desktop"
    "packages_nvidia"
)

install_pkgs() {
    echo " Installing: $@"
    if ! command -v gum &> /dev/null
    then
        arch_install $@
    else
        gum spin --title "..." --spinner dot --show-output -- ./arch_install.sh $@
    fi
}

stow_pkgs()
{
    cd ..
    echo -n " Stowing: "
    for pkg in $@
    do
        if [ -d $pkg ]; then
            echo -n "$pkg "
            # stow $pkg
        fi
    done
    echo
    cd - > /dev/null
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

# welcome
gum style --border normal --margin "1" --padding "1 2" --border-foreground 2 "Hello, there! Welcome to $(gum style --foreground 2 'Post-Installer')."

# install required pkgs
install_pkgs ${packages_base[@]}

# pick packages
gum join \
    "$(gum_style_list "base" ${packages_base[@]})" \
    "$(gum_style_list "cli" ${packages_cli[@]})" \
    "$(gum_style_list "desktop" ${packages_desktop[@]})"

SELECT_PACKAGES=$(gum choose --no-limit \
    --selected=${options_packages[0]},${options_packages[1]} \
    --header "Installing <space>" ${options_packages[@]})
gum log "Selected: " ${SELECT_PACKAGES[@]}

# install and stow
for package_set in $SELECT_PACKAGES
do
    for pkgs in $package_set[@]
    do
        install_pkgs ${!pkgs}
        stow_pkgs ${!pkgs}
    done
    echo ""
done
