#! /usr/bin/env bash

notify-send "Setting Wall" "$1"
swww img "$1" -t random &

#
# theme=$(dconf read /org/gnome/desktop/interface/color-scheme)
#
# function matu() {
# 	matugen \
# 		--mode "$1" \
# 		--contrast -1 \
# 		--type scheme-fidelity \
# 		image "$2"
# 		# --type scheme-tonal-spot \
# }
#
# if [[ $theme == "'prefer-light'" ]]; then
# 	if [[ ! -L $1 ]]; then
# 		ln -sf "$1" "$HOME"/Pictures/Walls/light
# 	fi
# 	matu "light" "$1"
# else
# 	if [[ ! -L $1 ]]; then
# 		ln -sf "$1" "$HOME"/Pictures/Walls/dark
# 	fi
# 	matu "dark" "$1"
# fi
