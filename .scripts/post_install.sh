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
    "git"
    "gotop"
    "neovim"
    "pywal"
    "starship"
    "tmux"
    "yazi"
    "zsh"
)

packages_gui=(
    "kitty"
    "vscode"
)

packages_wm=(
    "anyrun"
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
    "packages_gui"
    "packages_wm"
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
gum join \
    "$(gum_style_list "base" ${packages_base[@]})" \
    "$(gum_style_list "cli" ${packages_cli[@]})" \
    "$(gum_style_list "desktop" ${packages_desktop[@]})"

SELECT_PACKAGES=$(gum choose --no-limit \
    --header "Installing <space>" ${options_packages[@]})
    # --selected=${options_packages[0]},${options_packages[1]} \
gum log "Selected: " ${SELECT_PACKAGES[@]}

# install and stow
for package_set in $SELECT_PACKAGES
do
    cd ../${package_set#*_}
    for pkgs in $package_set[@]
    do
        install_pkgs ${!pkgs}
        stow_pkgs ${!pkgs}
    done
    cd -
    echo ""
done
