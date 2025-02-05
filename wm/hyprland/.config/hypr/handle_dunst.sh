#!/usr/bin/env bash

sleep 1 # TODO: currently not starting from hyprs exec-once :(
prev_was_ddnet=false

function handle {
				if [[ ${1:0:14} == "activewindow>>" ]]; then
								if [[ $1 == "DDNet"* ]]; then
												prev_was_ddnet=true
												dunstctl set-paused true
								elif $prev_was_ddnet; then
												prev_was_ddnet=false
												dunstctl set-paused false
												notify-send "DDNet" "Resumed Dunst (Notifications)" \
													-i /usr/share/ddnet/data/deadtee.png -u low
								fi
				fi
}

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
