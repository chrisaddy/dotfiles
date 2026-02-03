#!/bin/bash

# PIP window size
WIDTH=480
HEIGHT=270
PADDING=20

# Get screen dimensions (assumes single monitor or uses focused)
SCREEN_WIDTH=1920
SCREEN_HEIGHT=1080

# Calculate top-right position
POS_X=$((SCREEN_WIDTH - WIDTH - PADDING))
POS_Y=$PADDING

# Check if window is currently floating
is_floating=$(niri msg --json focused-window | grep -o '"is_floating":[^,}]*' | grep -o 'true\|false')

if [ "$is_floating" = "true" ]; then
    # Return to tiling
    niri msg action move-window-to-tiling
else
    # Make floating, resize, and position
    niri msg action move-window-to-floating
    niri msg action set-window-width "$WIDTH"
    niri msg action set-window-height "$HEIGHT"
    niri msg action move-floating-window -x "$POS_X" -y "$POS_Y"
fi
