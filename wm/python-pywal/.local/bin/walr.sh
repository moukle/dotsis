#!/usr/bin/env bash

wal --theme $@

mkdir -p ~/.config/zathura
ln -sf "${HOME}/.cache/wal/zathurarc" "${HOME}/.config/zathura/zathurarc"

# mkdir -p ~/.config/dunst
# ln -sf "${HOME}/.cache/wal/dunstrc" "${HOME}/.config/dunst/dunstrc"
# pkill dunst; dunst &
