#!/bin/sh

source "$CONFIG_DIR/colors.sh"
# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

sketchybar --set "$NAME" label="$(date '+%d/%m %H:%M')" label.color=$WORKSPACE_LABEL_SECONDARY_COLOR icon.color=$WORKSPACE_ICON_SECONDARY_COLOR background.color=$ACTIVE_WORKSPACE_SECONDARY_BG_COLOR

