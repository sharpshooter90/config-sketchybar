#!/bin/bash

# This script handles the appearance of workspace indicators in sketchybar
# $1: Current workspace being processed
# $FOCUSED_WORKSPACE: Currently focused/active workspace
# $NAME: Name of the workspace item in sketchybar

# Check if this workspace is the focused one
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  # For focused workspace:
  # - Add a white border (width=1)
  # - Show the workspace label/name
  sketchybar --set "$NAME" \
    background.border_width=1 \
    background.border_color=0xffffffff 
    # label.drawing=on
else
  # For unfocused workspaces:
  # - Remove the border (width=0)
  # - Set a dark border color
  # - Hide the workspace label/name
  sketchybar --set "$NAME" \
    background.border_width=0 \
    background.border_color=0xff262626
    # label.drawing=off
fi
