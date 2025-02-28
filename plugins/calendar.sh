#!/bin/bash

source "$CONFIG_DIR/colors.sh"
sketchybar --set $NAME label="$(date +'%a %d %b %H:%M')" label.color=$WORKSPACE_LABEL_SECONDARY_COLOR icon.color=$WORKSPACE_ICON_SECONDARY_COLOR background.color=$ACTIVE_WORKSPACE_SECONDARY_BG_COLOR
