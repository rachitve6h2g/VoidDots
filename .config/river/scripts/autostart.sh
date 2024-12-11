#!/bin/bash

# Function to start a process if not already running
start_if_not_running() {
    if ! pgrep -x "$1" > /dev/null; then
        "$@" &
    fi
}

# Brightness control variables
BRIGHTNESS_LOW=10
BRIGHTNESS_RESTORE=$(brightnessctl get)

# Start services
start_if_not_running pipewire
start_if_not_running mako
start_if_not_running wbg $HOME/Pictures/Wallpapers/current.png
start_if_not_running swayidle \
    timeout 180 'riverctl spawn "swaylock"' \
    timeout 300 'riverctl spawn "swaylock && loginctl suspend"' \
    before-sleep 'riverctl spawn "swaylock"' \
    before-sleep 'brightnessctl set ${BRIGHTNESS_LOW}%' \
    after-resume 'brightnessctl set ${BRIGHTNESS_RESTORE}'
start_if_not_running yambar
