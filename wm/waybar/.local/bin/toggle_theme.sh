#! /usr/bin/env sh

# set_wall.sh is being replaced by wallpaper_timer.sh
# set_wall.sh $HOME/Pictures/Walls/light
# set_wall.sh $HOME/Pictures/Walls/dark

set_helix_theme() {
    local theme="$1"
    sed -i "s/theme = \".*\"/theme = \"$theme\"/" "${HOME}/.config/helix/config.toml"
    pkill -USR1 helix
}

if [ $test $(dconf read /org/gnome/desktop/interface/color-scheme) = "'prefer-dark'" ]; then
    # switch to light
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
    walr.sh ayu -l
    set_helix_theme "catppuccin_light"
    sed -i "s/--dark/--light/" "${HOME}/.config/lazygit/config.yml"
else
    # switch to dark
    dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
    walr.sh everforest
    set_helix_theme "catppuccin_oled"
    sed -i "s/--light/--dark/" "${HOME}/.config/lazygit/config.yml"
fi
