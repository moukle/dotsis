#! /usr/bin/env bash

# WARN: causes weird lag
# NOTE: why different state per pid?

TITLE="Dispatch"
PIDS=$(pgrep -f $TITLE)

notify-send --app-name=$TITLE "Paused Toggled"

for PID in $PIDS; do
    STATE=$(ps -o state= -p "$PID" | tr -d ' ')
    if [[ "$STATE" == "T" ]]; then
        kill -CONT -"$PID"
        # notify-send "Contiue: $PID"
    else
        kill -STOP -"$PID"
        # notify-send "Pause: $PID"
    fi
done

exit

# NOTE: general approach based on focused-window... PID = xway-sattelite... :(

PID=$(niri msg focused-window | awk '/PID:/ {print $2}')
# TITLE=$(niri msg focused-window | awk '/Title:/ {print $2}')
TITLE=$(niri msg focused-window | awk -F'Title:' '{print $2}'})

TITLE=$(niri msg focused-window | awk -F'Title: ' '
/Title:/ {
    title=$2
    sub(/[[:space:]]*$/, "", title)
    sub(/^"/, "", title)
    sub(/"$/, "", title)
    print title
}')

# TITLE="Dispatch  "
# TITLE=$(echo $TITLE | xargs) # trim
NAME="Pauser"

# more processes with that title?
# notify-send $(ps -A)
