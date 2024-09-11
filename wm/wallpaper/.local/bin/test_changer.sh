#!/bin/bash

sudo timedatectl set-ntp false

# Starting date and time (format: YYYY-MM-DD HH:MM:SS)
START_TIME="2024-09-12 00:00:00"

# Number of steps (24 for one hour each step)
STEPS=24

# Loop through each step
for ((i=0; i<$STEPS; i++)); do
    # Calculate the new time
    NEW_TIME=$(date -d "$START_TIME + $i hour" +"%Y-%m-%d %H:%M:%S")
    
    # Set the system time
    sudo timedatectl set-time "$NEW_TIME"

    # Print the current time being set
    # echo "Setting system time to: $NEW_TIME"
    ./wallpaper_timer.sh /home/mori/Pictures/Walls/Küste 4 23
done

sudo timedatectl set-ntp true
