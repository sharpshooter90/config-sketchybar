#!/bin/bash
source "$CONFIG_DIR/colors.sh" # Source the colors configuration

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
    background.border_color=$WORKSPACE_ITEM_BORDER_ACTIVE_COLOR \
    background.color=$ACTIVE_WORKSPACE_SECONDARY_BG_COLOR \
    # label.drawing=on
else
  # For unfocused workspaces:
  # - Remove the border (width=0)
  # - Set a dark border color
  # - Hide the workspace label/name
  sketchybar --set "$NAME" \
    background.border_width=0 \
    background.drawing=off \
    # label.drawing=off
fi
