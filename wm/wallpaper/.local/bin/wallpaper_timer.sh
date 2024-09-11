#!/bin/bash

# Directory containing wallpapers (input this folder)
WALLPAPER_DIR="$1"

# Start and End hours from arguments (default values if not provided)
START_HOUR=${2:-4}  # Default: 4 AM
END_HOUR=${3:-20}   # Default: 8 PM

# Number of wallpapers (calculate from the folder)
N=$(ls "$WALLPAPER_DIR" | wc -l)

# Time interval between wallpaper changes
INTERVAL=$(( (END_HOUR - START_HOUR) * 3600 / (N - 1) ))  # Time between changes (seconds)

# Get current time in seconds since midnight
current_time=$(date +%s)

# Get the time at the start of today for START_HOUR
start_of_day=$(date -d "$(date +%Y-%m-%d) $START_HOUR:00:00" +%s)

# Get the time at the start of today for END_HOUR
end_of_day=$(date -d "$(date +%Y-%m-%d) $END_HOUR:59:00" +%s)

# Determine if we're before START_HOUR or after END_HOUR
if [ "$current_time" -lt "$start_of_day" ]; then
    # Before START_HOUR: show the last wallpaper from the previous day
    image_index=$N
elif [ "$current_time" -ge "$end_of_day" ]; then
    # After END_HOUR: keep the last wallpaper
    image_index=$N
else
    # Calculate the time difference since START_HOUR
    elapsed_time=$((current_time - start_of_day))

    # Calculate which image to display based on elapsed time
    image_index=$((elapsed_time / INTERVAL + 1))
fi

# Desired wallpaper
desired_wallpaper="$WALLPAPER_DIR/$image_index.jpeg"

# Get the current wallpapers for all monitors
current_wallpapers=$(swww query | grep 'currently displaying:' | awk -F 'currently displaying: ' '{print $2}' | sed 's/^image://g' | tr -d '[:space:]')


# Check if the desired wallpaper is already set
if echo "$current_wallpapers" | grep -q "$desired_wallpaper"; then
    echo "Wallpaper is already set to: $desired_wallpaper"
    # notify-send "$(date +%H:%M) Displaying Wallpaper: $desired_wallpaper"
else
    echo "$(date +%H:%M) Displaying Wallpaper: $desired_wallpaper"
    # notify-send "$(date +%H:%M) Displaying Wallpaper: $desired_wallpaper"
    swww img "$desired_wallpaper"
fi

exit 1
